import { useAuth }    from "../context/AuthContext";
import { useNavigate }from "react-router-dom";
import Logo from "./Logo";
import "./PageBanner.css";
 
export default function PageBanner() {
  const { user } = useAuth();
  const navigate = useNavigate();
 
  return (
    <div className="page-banner">
      {/* Background decorative image — replace src with real banner image */}
      <div className="page-banner-bg" />
 
      <div className="page-banner-content">
        <div className="page-banner-brand" onClick={() => navigate("/home")}>
          <Logo size={32} />
          <div>
            <span className="page-banner-name">BarterBayan</span>
            <span className="page-banner-tag">The Community Barter Network.</span>
          </div>
        </div>
 
        {user && (
          <div className="page-banner-user">
            <span className="page-banner-greeting">
              Hi, <strong>{user.username}</strong>
            </span>
          </div>
        )}
      </div>
    </div>
  );
}
