import { useState, useEffect, useRef } from "react";
import { useAuth } from "../context/AuthContext";
import { apiGet }  from "../utils/api";
import MapFilter   from "./MapFilter";
import "./MapOverlay.css";

let L = null;

export default function MapOverlay({ onClose, focusItem }) {
  const { user }       = useAuth();
  const [items,        setItems]       = useState([]);
  const [showFilter,   setShowFilter]  = useState(false);
  const [filterRegion, setFilterRegion] = useState("");
  const [filterLabel,  setFilterLabel] = useState("");
  const [mapReady,     setMapReady]    = useState(false);
  const mapRef     = useRef(null);
  const markersRef = useRef([]);

  // Load Leaflet + items
  useEffect(() => {
    if (!document.getElementById("leaflet-css")) {
      const l = document.createElement("link");
      l.id = "leaflet-css";
      l.rel = "stylesheet";
      l.href = "https://unpkg.com/leaflet@1.9.4/dist/leaflet.css";
      document.head.appendChild(l);
    }
    import("leaflet").then(mod => {
      L = mod.default ?? mod;
      delete L.Icon.Default.prototype._getIconUrl;
      L.Icon.Default.mergeOptions({
        iconUrl:       "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png",
        iconRetinaUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png",
        shadowUrl:     "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
      });
      setMapReady(true);
    });
    apiGet("/items/get_items.php").then(d => { if (d.success) setItems(d.items); });
  }, []);

  // Init map once
  useEffect(() => {
    if (!mapReady || mapRef.current) return;
    const el = document.getElementById("bb-map");
    if (!el) return;
    const center = user?.latitude && user?.longitude
      ? [parseFloat(user.latitude), parseFloat(user.longitude)]
      : [13.2249, 120.5988];
    const map = L.map("bb-map", { center, zoom: 12, zoomControl: true });
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors",
      maxZoom: 19
    }).addTo(map);
    mapRef.current = map;
    if (focusItem?.latitude && focusItem?.longitude) {
      map.flyTo(
        [parseFloat(focusItem.latitude), parseFloat(focusItem.longitude)],
        15,
        { animate: true, duration: 1.2 }
      );
    }
  }, [mapReady]);

  // Update markers when items or filter changes
  useEffect(() => {
    if (!mapRef.current || !L) return;
    markersRef.current.forEach(m => m.remove());
    markersRef.current = [];
    const visible = filterRegion
      ? items.filter(i =>
          (i.location && i.location.toLowerCase().includes(filterRegion.toLowerCase())) ||
          (i.city && i.city.toLowerCase().includes(filterRegion.toLowerCase()))
        )
      : items;
    visible.filter(i => i.latitude && i.longitude).forEach(item => {
      const m = L.marker([parseFloat(item.latitude), parseFloat(item.longitude)])
        .addTo(mapRef.current)
        .bindPopup(`
          <div style="min-width:150px">
            <strong>${item.title}</strong><br/>
            <span style="color:#059669">${item.username}</span><br/>
            <span style="color:#64748B;font-size:0.8rem">📍 ${item.location || ""}</span>
          </div>
        `);
      markersRef.current.push(m);
    });
    if (markersRef.current.length > 0 && filterRegion) {
      const grp = L.featureGroup(markersRef.current);
      mapRef.current.fitBounds(grp.getBounds().pad(0.15), {
        animate: true,
        duration: 0.8,
        maxZoom: 15
      });
    }
  }, [items, filterRegion]);

  // Handle filter — FLY TO selected region
  const handleFilterApply = (regionObj) => {
    setFilterRegion(regionObj.value);
    setFilterLabel(regionObj.label);
    setShowFilter(false);
    if (!mapRef.current) return;
    mapRef.current.flyTo(
      [regionObj.lat, regionObj.lng],
      regionObj.zoom,
      { animate: true, duration: 1.4, easeLinearity: 0.25 }
    );
  };

  return (
    <>
      <div className="map-overlay-wrap">
        <div className="map-controls">
          <button className="map-btn" onClick={() => setShowFilter(true)}>
            &#128269; Filter
            {filterLabel && <span className="map-filter-active">{filterLabel}</span>}
          </button>
          {filterRegion && (
            <button className="map-btn" onClick={() => { setFilterRegion(""); setFilterLabel(""); }}>
              &#x2715; Clear
            </button>
          )}
          <button className="map-btn map-close-btn" onClick={onClose}>
            &#10005; Close
          </button>
        </div>
        {!mapReady && <div className="map-loading">Loading map...</div>}
        <div id="bb-map" className="bb-map-container" />
      </div>
      {showFilter && (
        <MapFilter
          currentRegion={filterRegion}
          onApply={handleFilterApply}
          onClose={() => setShowFilter(false)}
        />
      )}
    </>
  );
}