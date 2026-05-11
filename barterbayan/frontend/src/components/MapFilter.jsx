import { useAuth } from "../context/AuthContext";
import "./MapFilter.css";
 
const CATS = ["all","electronics","vehicles","furniture","clothing","other"];
 
export default function MapFilter({ current, onApply, onClose, onCityFilter }) {
  const { user } = useAuth();
  const userCity = user?.city || "";
 
  return (
    <div className="overlay-backdrop" onClick={onClose}>
      <div className="map-filter-panel" onClick={e => e.stopPropagation()}>
        <div className="modal-header">
          <h3 className="modal-title">Filter Map</h3>
          <button className="modal-close" onClick={onClose}>&times;</button>
        </div>
 
        {/* Location filter — pre-filled with user city (change #11) */}
        <div className="mf-section">
          <p className="mf-section-label">Location</p>
          <div className="mf-city-row">
            <span className="mf-city-icon">&#x1F4CD;</span>
            <span className="mf-city-name">{userCity || "All Philippines"}</span>
            {userCity && (
              <button className="mf-city-clear" onClick={() => onCityFilter && onCityFilter("")}>
                Show All
              </button>
            )}
          </div>
          {userCity && (
            <p className="mf-city-hint">Map is filtered to items near {userCity}</p>
          )}
        </div>
 
        {/* Category filter */}
        <div className="mf-section">
          <p className="mf-section-label">Category</p>
          <div className="map-filter-list">
            {CATS.map(c => (
              <button key={c}
                className={`map-filter-item ${current === c ? "active" : ""}`}
                onClick={() => onApply(c)}>
                {c === "all" ? "All Categories" : c.charAt(0).toUpperCase() + c.slice(1)}
              </button>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
