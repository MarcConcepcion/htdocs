import { useAuth } from "../context/AuthContext";
import "./MapFilter.css";

const PH_REGIONS = [
  { label: "All Philippines",         value: "",             lat: 12.8797, lng: 121.7740, zoom: 6 },
  { label: "Mamburao, Occ. Mindoro",  value: "Mamburao",     lat: 13.2249, lng: 120.5988, zoom: 14 },
  { label: "San Jose, Occ. Mindoro",  value: "San Jose",     lat: 12.3500, lng: 121.0667, zoom: 13 },
  { label: "Calintaan",               value: "Calintaan",    lat: 12.5667, lng: 120.8667, zoom: 13 },
  { label: "Paluan",                  value: "Paluan",       lat: 13.4167, lng: 120.4667, zoom: 13 },
  { label: "Metro Manila",            value: "Manila",       lat: 14.5995, lng: 120.9842, zoom: 12 },
  { label: "Quezon City",             value: "Quezon City",  lat: 14.6760, lng: 121.0437, zoom: 13 },
  { label: "Makati",                  value: "Makati",       lat: 14.5547, lng: 121.0244, zoom: 14 },
  { label: "Pasig",                   value: "Pasig",        lat: 14.5764, lng: 121.0851, zoom: 14 },
  { label: "Taguig",                  value: "Taguig",       lat: 14.5176, lng: 121.0509, zoom: 14 },
  { label: "Cebu City",               value: "Cebu City",    lat: 10.3157, lng: 123.8854, zoom: 13 },
  { label: "Mandaue",                 value: "Mandaue",      lat: 10.3503, lng: 123.9322, zoom: 14 },
  { label: "Lapu-Lapu",               value: "Lapu-Lapu",    lat: 10.3103, lng: 123.9494, zoom: 14 },
  { label: "Davao City",              value: "Davao City",   lat: 7.0644,  lng: 125.6079, zoom: 12 },
  { label: "Tagum",                   value: "Tagum",        lat: 7.4478,  lng: 125.8077, zoom: 13 },
  { label: "Iloilo City",             value: "Iloilo City",  lat: 10.7202, lng: 122.5621, zoom: 13 },
  { label: "Baguio",                  value: "Baguio",       lat: 16.4023, lng: 120.5960, zoom: 14 },
  { label: "Cagayan de Oro",          value: "Cagayan de Oro", lat: 8.4822, lng: 124.6472, zoom: 13 },
  { label: "Zamboanga City",          value: "Zamboanga City", lat: 6.9214, lng: 122.0790, zoom: 13 },
  { label: "General Santos",          value: "General Santos", lat: 6.1164, lng: 125.1716, zoom: 13 },
  { label: "Bacolod",                 value: "Bacolod",      lat: 10.6713, lng: 122.9511, zoom: 13 },
  { label: "Butuan",                  value: "Butuan",       lat: 8.9475,  lng: 125.5406, zoom: 13 },
  { label: "Tacloban",                value: "Tacloban",     lat: 11.2442, lng: 125.0044, zoom: 13 },
  { label: "Puerto Princesa",         value: "Puerto Princesa", lat: 9.7392, lng: 118.7353, zoom: 13 },
  { label: "Naga",                    value: "Naga",         lat: 13.6218, lng: 123.1948, zoom: 13 },
  { label: "Lipa",                    value: "Lipa",         lat: 13.9411, lng: 121.1631, zoom: 13 },
];

export default function MapFilter({ currentRegion, onApply, onClose }) {
  const { user } = useAuth();
  const userCity = user?.city || "";

  // Find region object for the current value (if any)
  const currentRegionObj = PH_REGIONS.find(r => r.value === currentRegion) || null;

  // Handle "Near Me" – create a region-like object from user's city
  const handleNearMe = () => {
    // Attempt to find matching region data for userCity, otherwise create a basic one
    const matchedRegion = PH_REGIONS.find(r => r.value.toLowerCase() === userCity.toLowerCase());
    if (matchedRegion) {
      onApply(matchedRegion);
    } else {
      // Fallback: create a simple region object without lat/lng/zoom
      onApply({ label: userCity, value: userCity, lat: null, lng: null, zoom: null });
    }
  };

  return (
    <div className="overlay-backdrop-center" onClick={onClose}>
      <div className="map-filter-panel" onClick={e => e.stopPropagation()}>
        <div className="modal-header">
          <h3 className="modal-title">Filter by Place</h3>
          <button className="modal-close" onClick={onClose}>&times;</button>
        </div>

        {userCity && (
          <div className="mf-user-city">
            <span className="mf-city-icon">&#x1F4CD;</span>
            <span>Your location: <strong>{userCity}</strong></span>
            <button className="mf-near-me" onClick={handleNearMe}>
              Near Me
            </button>
          </div>
        )}

        <p className="mf-section-label">Select a Region / City</p>
        <div className="map-filter-list">
          {PH_REGIONS.map(r => (
            <button
              key={r.value}
              className={`map-filter-item ${currentRegionObj?.value === r.value ? "active" : ""}`}
              onClick={() => onApply(r)}
            >
              {r.label}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}