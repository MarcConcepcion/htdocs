import { Link, useNavigate, useLocation } from "react-router-dom";
import { useState } from "react";
import { useAuth }        from "../context/AuthContext";
import { apiGet }         from "../utils/api";
import MapOverlay         from "./MapOverlay";
import NotificationPanel  from "./NotificationPanel";
import "./FloatingNav.css";
 
export default function FloatingNav() {
  const { user, logout } = useAuth();
  const navigate  = useNavigate();
  const location  = useLocation();
  const [showMap,    setShowMap]    = useState(false);
  const [showNotifs, setShowNotifs] = useState(false);
  const [unread,     setUnread]     = useState(0);
  const [expanded,   setExpanded]   = useState(false);
 
  const tab = p => location.pathname === p ? "fn-item active" : "fn-item";
 
  const handleLogout = async () => {
    await apiGet("/auth/logout.php");
    logout(); navigate("/login");
  };
 
  return (
    <>
      <nav className={`floating-nav ${expanded ? "expanded" : ""}`}>
 
        {/* Logo / Toggle */}
        <button className="fn-logo" onClick={() => setExpanded(e => !e)}
          title="BarterBayan">
          <span className="fn-logo-icon">&#x21BB;</span>
          {expanded && <span className="fn-logo-text">BarterBayan</span>}
        </button>
 
        <Link to="/home" className={tab("/home")} title="Home">
          <span className="fn-icon">&#x2302;</span>
          {expanded && <span className="fn-label">Home</span>}
        </Link>
 
        <Link to="/post" className={tab("/post")} title="Post Item">
          <span className="fn-icon fn-post-icon">+</span>
          {expanded && <span className="fn-label">Post Item</span>}
        </Link>
 
        <Link to="/trades" className={tab("/trades")} title="My Trades">
          <span className="fn-icon">&#x21C6;</span>
          {expanded && <span className="fn-label">Trades</span>}
        </Link>
 
        <Link to="/messages" className={tab("/messages")} title="Messages">
          <span className="fn-icon">&#x1F4AC;</span>
          {expanded && <span className="fn-label">Messages</span>}
        </Link>
 
        <button className="fn-item fn-notif" title="Notifications"
          onClick={() => setShowNotifs(true)}>
          <span className="fn-icon">&#x1F514;</span>
          {unread > 0 && <span className="fn-badge">{unread}</span>}
          {expanded && <span className="fn-label">Alerts</span>}
        </button>
 
        <button className="fn-item" title="Map" onClick={() => setShowMap(true)}>
          <span className="fn-icon">&#x1F5FA;</span>
          {expanded && <span className="fn-label">Map</span>}
        </button>
 
        <Link to={`/profile/${user?.user_id}`}
          className={tab(`/profile/${user?.user_id}`)} title="Profile">
          <span className="fn-icon">&#x1F464;</span>
          {expanded && <span className="fn-label">Profile</span>}
        </Link>
 
        <button className="fn-item fn-logout" title="Logout" onClick={handleLogout}>
          <span className="fn-icon">&#x2192;</span>
          {expanded && <span className="fn-label">Logout</span>}
        </button>
      </nav>
 
      {showMap    && <MapOverlay        onClose={() => setShowMap(false)} />}
      {showNotifs && <NotificationPanel onClose={() => setShowNotifs(false)} setUnread={setUnread} />}
    </>
  );
}
