import { useAuth } from "../context/AuthContext";
import "./MapFilter.css";
 
const PH_REGIONS = [
  { label: "All Philippines",          value: "" },
  { label: "Mamburao, Occ. Mindoro",   value: "Mamburao" },
  { label: "San Jose, Occ. Mindoro",   value: "San Jose" },
  { label: "Metro Manila",             value: "Manila" },
  { label: "Quezon City",              value: "Quezon City" },
  { label: "Makati",                   value: "Makati" },
  { label: "Pasig",                    value: "Pasig" },
  { label: "Cebu City",               value: "Cebu City" },
  { label: "Mandaue",                  value: "Mandaue" },
  { label: "Davao City",              value: "Davao City" },
  { label: "Iloilo City",             value: "Iloilo City" },
  { label: "Baguio",                   value: "Baguio" },
  { label: "Cagayan de Oro",           value: "Cagayan de Oro" },
  { label: "Zamboanga City",           value: "Zamboanga City" },
  { label: "General Santos",           value: "General Santos" },
];
 
export default function MapFilter({ currentRegion, onApply, onClose }) {
  const { user } = useAuth();
  const userCity = user?.city || "";
 
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
            <button className="mf-near-me"
              onClick={() => onApply(userCity)}>
              Near Me
            </button>
          </div>
        )}
 
        <p className="mf-section-label">Select a Region / City</p>
        <div className="map-filter-list">
          {PH_REGIONS.map(r => (
            <button key={r.value}
              className={`map-filter-item ${currentRegion === r.value ? "active" : ""}`}
              onClick={() => onApply(r.value)}>
              {r.label}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
