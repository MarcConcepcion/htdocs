import { useState, useEffect } from "react";
import { useAuth } from "../context/AuthContext";
import { apiGet }  from "../utils/api";
import MapFilter   from "./MapFilter";
import "./MapOverlay.css";
 
// Leaflet loaded via useEffect to avoid SSR/Vite issues
let L = null;
 
export default function MapOverlay({ onClose }) {
  const { user }    = useAuth();
  const [items,     setItems]     = useState([]);
  const [showFilter,setShowFilter]= useState(false);
  const [filterCat, setFilterCat] = useState("all");
  const [mapReady,  setMapReady]  = useState(false);
  const [mapInst,   setMapInst]   = useState(null);
 
  // Load Leaflet CSS dynamically once
  useEffect(() => {
    if (!document.getElementById("leaflet-css")) {
      const link = document.createElement("link");
      link.id   = "leaflet-css";
      link.rel  = "stylesheet";
      link.href = "https://unpkg.com/leaflet@1.9.4/dist/leaflet.css";
      document.head.appendChild(link);
    }
    // Load Leaflet JS
    import("leaflet").then(leaflet => {
      L = leaflet.default ?? leaflet;
      // Fix default icons broken by Vite
      delete L.Icon.Default.prototype._getIconUrl;
      L.Icon.Default.mergeOptions({
        iconUrl:       "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png",
        iconRetinaUrl:"https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png",
        shadowUrl:    "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
      });
      setMapReady(true);
    });
    // Fetch items with coordinates
    apiGet("/items/get_items.php").then(d => { if (d.success) setItems(d.items); });
  }, []);
 
  // Init map after container is in DOM
  useEffect(() => {
    if (!mapReady || mapInst) return;
    const el = document.getElementById("bb-leaflet-map");
    if (!el) return;
    const center = user?.latitude && user?.longitude
      ? [parseFloat(user.latitude), parseFloat(user.longitude)]
      : [13.2249, 120.5988]; // default: Mamburao
    const map = L.map("bb-leaflet-map").setView(center, 12);
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution:"© OpenStreetMap contributors"
    }).addTo(map);
    setMapInst(map);
  }, [mapReady]);
 
  // Add/update markers when items or filter changes
  useEffect(() => {
    if (!mapInst || !L) return;
    mapInst.eachLayer(l => { if (l instanceof L.Marker) mapInst.removeLayer(l); });
    const visible = filterCat === "all" ? items : items.filter(i => i.category === filterCat);
    visible
      .filter(i => i.latitude && i.longitude)
      .forEach(item => {
        L.marker([parseFloat(item.latitude), parseFloat(item.longitude)])
          .addTo(mapInst)
          .bindPopup(`<strong>${item.title}</strong><br/>${item.username} — ${item.location}`);
      });
  }, [mapInst, items, filterCat]);
 
  return (
    <>
      <div className="map-overlay-wrap">
        <div className="map-controls">
          <button className="map-btn" onClick={() => setShowFilter(true)}>&#128269; Filter</button>
          <button className="map-btn map-close-btn" onClick={onClose}>&#10005; Close</button>
        </div>
        {!mapReady && <div className="map-loading">Loading map...</div>}
        <div id="bb-leaflet-map" className="bb-map-container" />
      </div>
      {showFilter && (
        <MapFilter
          current={filterCat}
          onApply={cat => { setFilterCat(cat); setShowFilter(false); }}
          onClose={() => setShowFilter(false)}
        />
      )}
    </>
  );
}
