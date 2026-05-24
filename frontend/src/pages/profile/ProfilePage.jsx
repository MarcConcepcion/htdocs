import { useEffect, useState, useRef } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { apiGet, apiPost } from "../../utils/api";
import { useAuth } from "../../context/AuthContext";
import NavBar       from "../../components/FloatingNav";
import ItemCard     from "../../components/ItemCard";
import ReviewCard   from "../../components/ReviewCard";
import PostReviewModal from "../../components/PostReviewModal";
import PageBanner   from "../../components/PageBanner";
import ReportModal from "../../components/ReportModal";
import "./ProfilePage.css";

function Stars({ rating }) {
  return (
    <span className="stars">
      {[1,2,3,4,5].map(n => (
        <span key={n} className={`star ${n <= Math.round(rating) ? "filled" : ""}`}>&#9733;</span>
      ))}
    </span>
  );
}

export default function ProfilePage() {
  const { id } = useParams();
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const fileInputRef = useRef(null);

  const [profile, setProfile] = useState(null);
  const [items, setItems] = useState([]);
  const [reviews, setReviews] = useState([]);
  const [avgRating, setAvgRating] = useState(0);
  const [showReview, setShowReview] = useState(false);
  const [showReport, setShowReport] = useState(false);
  const [trades, setTrades] = useState([]);
  const [activeTab, setActiveTab] = useState("listings");
  const [pfpUploading, setPfpUploading] = useState(false);
  const [verifChecks, setVerifChecks] = useState(null);
  const [editing, setEditing] = useState(false);
  const [editForm, setEditForm] = useState({ username: "", location: "", barangay: "" });
  const [editSaving, setEditSaving] = useState(false);

  // Force fresh data with cache busting
  const fetchProfileData = () => {
    const ts = Date.now();
    console.log("Fetching profile data at", ts);
    apiGet("/users/get_profile.php", { user_id: id, _t: ts }).then(d => {
      if (d.success) setProfile(d.user);
    });
    apiGet("/items/get_user_items.php", { user_id: id, _t: ts }).then(d => {
      if (d.success) setItems(d.items);
    });
    apiGet("/reviews/get_reviews.php", { reviewee_id: id, _t: ts }).then(d => {
      console.log("Reviews API response:", d);
      if (d.success) {
        setReviews(d.reviews);
        setAvgRating(d.avg_rating);
      }
    });
    apiGet("/trades/get_offers.php", { user_id: id, _t: ts }).then(d => {
      if (d.success) setTrades(d.offers);
    });
  };

  useEffect(() => {
    fetchProfileData();
  }, [id]);

  useEffect(() => {
    if (user?.user_id == id) {
      apiGet("/users/check_verification.php").then(d => {
        if (d.success) setVerifChecks(d.checks);
      });
    }
  }, [id, user]);

  const handleMessage = async () => {
    const d = await apiPost("/messages/start_convo.php", { other_user_id: id });
    if (d.success) navigate(`/messages/${d.convo_id}`);
  };

  const handleLogout = async () => {
    await apiGet("/auth/logout.php");
    logout();
    navigate("/login");
  };

  const startEdit = () => {
    setEditForm({
      username: profile.username || "",
      location: profile.location || "",
      barangay: profile.barangay || "",
    });
    setEditing(true);
  };

  const saveEdit = async () => {
    setEditSaving(true);
    const d = await apiPost("/users/update_profile.php", editForm);
    if (d.success) {
      setProfile(p => ({ ...p, ...editForm }));
      setEditing(false);
    } else {
      alert(d.message || "Failed to update profile");
    }
    setEditSaving(false);
  };

  const handlePfpChange = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (!file.type.startsWith("image/")) {
      alert("Please select an image file.");
      return;
    }
    setPfpUploading(true);
    const reader = new FileReader();
    reader.onload = async () => {
      const base64 = reader.result;
      const uploadRes = await apiPost("/items/upload_image.php", {
        image_data: base64,
        file_name:  file.name,
      });
      if (uploadRes.success) {
        const updateRes = await apiPost("/users/update_profile.php", {
          username:    profile.username,
          location:    profile.location || "",
          profile_pic: uploadRes.url,
        });
        if (updateRes.success) {
          setProfile(p => ({ ...p, profile_pic: uploadRes.url }));
        } else {
          alert(updateRes.message || "Failed to update profile picture");
        }
      } else {
        alert(uploadRes.message || "Image upload failed");
      }
      setPfpUploading(false);
    };
    reader.onerror = () => {
      alert("Failed to read the image file");
      setPfpUploading(false);
    };
    reader.readAsDataURL(file);
  };

  if (!profile) return <p className="profile-loading">Loading...</p>;

  const isOwnProfile = user?.user_id == id;
  const joinYear = new Date(profile.created_at || Date.now()).getFullYear();
  const completedTrades = trades.filter(t => t.status === "accepted").length;

  return (
    <div className="profile-screen">
      <NavBar />
      <PageBanner />
      <div className="content-wrap">
        <div className="profile-hero">
          <div
            className="profile-avatar-wrap"
            onClick={() => isOwnProfile && fileInputRef.current?.click()}
            style={{ cursor: isOwnProfile ? "pointer" : "default" }}
          >
            <div className="profile-avatar">
              {profile.profile_pic ? (
                <img src={profile.profile_pic} alt={profile.username} />
              ) : (
                <span className="profile-avatar-icon">&#x1F464;</span>
              )}
            </div>
            {profile.is_verified == 1 && (
              <span className="profile-verified-badge">✓</span>
            )}
            {isOwnProfile && (
              <span className="profile-camera-btn">
                {pfpUploading ? "⏳" : "📷"}
              </span>
            )}
            <input
              ref={fileInputRef}
              type="file"
              accept="image/jpeg,image/png,image/webp"
              style={{ display: "none" }}
              onChange={handlePfpChange}
            />
          </div>

          {!editing ? (
            <>
              <p className="profile-location">📍 {profile.location || "Location not set"}</p>
              {avgRating > 0 && (
                <p className="profile-rating">
                  <Stars rating={avgRating} />
                  <span className="profile-rating-val">{avgRating} Rating</span>
                </p>
              )}
              <p className="profile-member">⏰ Member since {joinYear}</p>
            </>
          ) : (
            <div className="profile-edit-form">
              <input
                className="form-field profile-edit-input"
                placeholder="Username"
                value={editForm.username}
                onChange={e => setEditForm(f => ({ ...f, username: e.target.value }))}
              />
              <input
                className="form-field profile-edit-input"
                placeholder="Location / City"
                value={editForm.location}
                onChange={e => setEditForm(f => ({ ...f, location: e.target.value }))}
              />
              <input
                className="form-field profile-edit-input"
                placeholder="Barangay"
                value={editForm.barangay}
                onChange={e => setEditForm(f => ({ ...f, barangay: e.target.value }))}
              />
              <div className="profile-edit-actions">
                <button className="btn-secondary" onClick={() => setEditing(false)}>Cancel</button>
                <button className="btn-primary profile-edit-save" onClick={saveEdit} disabled={editSaving}>
                  {editSaving ? "Saving..." : "Save Changes"}
                </button>
              </div>
            </div>
          )}

          <div className="profile-actions">
            {isOwnProfile && !editing && (
              <>
                <button className="btn-secondary profile-btn" onClick={startEdit}>
                  ✎ Edit Profile
                </button>
                <button className="profile-logout-btn" onClick={handleLogout}>
                  → Logout
                </button>
              </>
            )}
            {!isOwnProfile && (
              <>
                <button className="btn-secondary profile-btn" onClick={() => setShowReview(true)}>
                  ★ Leave a Review
                </button>
                <button className="btn-secondary profile-btn" onClick={handleMessage}>
                  💬 Message
                </button>
                <button className="btn-secondary profile-btn" onClick={() => setShowReport(true)}>
                  ⚠️ Report
                </button>
              </>
            )}
          </div>

          {isOwnProfile && verifChecks && !profile.is_verified && (
            <div className="verif-checklist">
              <p className="verif-title">Complete your profile to get verified:</p>
              {[
                ["email_verified",    "Verify your email address"],
                ["has_name",          "Add your full name"],
                ["has_phone",         "Add your phone number"],
                ["has_location",      "Set your city"],
                ["has_profile_pic",   "Upload a profile photo"],
                ["has_completed_trade","Complete your first trade"],
              ].map(([key, label]) => (
                <div key={key} className={`verif-item ${verifChecks[key] ? "done" : "pending"}`}>
                  <span>{verifChecks[key] ? "\u2713" : "\u25CB"}</span>
                  <span>{label}</span>
                </div>
              ))}
            </div>
          )}

          <div className="profile-stats">
            <div className="profile-stat">
              <span className="profile-stat-num profile-stat-green">{completedTrades}</span>
              <span className="profile-stat-label">COMPLETED<br/>TRADES</span>
            </div>
            <div className="profile-stat-divider" />
            <div className="profile-stat">
              <span className="profile-stat-num profile-stat-red">
                {items.filter(i => i.status === "available").length}
              </span>
              <span className="profile-stat-label">ACTIVE<br/>LISTINGS</span>
            </div>
          </div>
        </div>

        <div className="profile-tabs">
          {["listings", "trades", "reviews"].map(t => (
            <button
              key={t}
              className={`profile-tab ${activeTab === t ? "active" : ""}`}
              onClick={() => setActiveTab(t)}
            >
              {t.charAt(0).toUpperCase() + t.slice(1)}
            </button>
          ))}
        </div>

        {activeTab === "listings" && (
          <div className="profile-section">
            <h3 className="profile-section-title">📦 My Active Listings</h3>
            {items.filter(i => i.status === "available").length === 0 ? (
              <div className="profile-empty-state">No active listings.</div>
            ) : (
              <div className="profile-grid">
                {items.filter(i => i.status === "available").map(item => (
                  <ItemCard key={item.item_id} item={item} />
                ))}
              </div>
            )}
          </div>
        )}

        {activeTab === "trades" && (
          <div className="profile-section">
            <h3 className="profile-section-title">🔄 Recent Trades</h3>
            {trades.length === 0 ? (
              <p>No trades yet.</p>
            ) : (
              trades.map(o => (
                <div key={o.offer_id} className="trade-history-row">
                  <span>{o.offered_title} ⇄ {o.requested_title}</span>
                  <span className={`tp-status-badge tp-status-${o.status}`}>{o.status}</span>
                </div>
              ))
            )}
          </div>
        )}

        {activeTab === "reviews" && (
          <div className="profile-section">
            <h3 className="profile-section-title">💬 My Reviews</h3>
            {reviews.length === 0 ? (
              <p className="profile-no-reviews">No reviews yet. Be the first to review this trader!</p>
            ) : (
              <div className="profile-reviews-list">
                {reviews.map(r => <ReviewCard key={r.review_id} review={r} />)}
              </div>
            )}
          </div>
        )}

        {showReview && (
          <PostReviewModal
            revieweeId={id}
            revieweeName={profile.username}
            onClose={() => {
              setShowReview(false);
              // Wait 1 second for DB commit, then refresh
              setTimeout(() => fetchProfileData(), 1000);
            }}
          />
        )}

        {showReport && (
          <ReportModal
            reportedId={profile.user_id}
            reportedName={profile.username}
            itemId={null}
            onClose={() => setShowReport(false)}
          />
        )}
      </div>
    </div>
  );
}