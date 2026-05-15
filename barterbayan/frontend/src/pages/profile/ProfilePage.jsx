import { useEffect, useState, useRef } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { apiGet, apiPost } from "../../utils/api";
import { useAuth } from "../../context/AuthContext";
import NavBar       from "../../components/FloatingNav";
import ItemCard     from "../../components/ItemCard";
import ReviewCard   from "../../components/ReviewCard";
import PostReviewModal from "../../components/PostReviewModal";
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
  const [trades, setTrades] = useState([]);
  const [activeTab, setActiveTab] = useState("listings");

  // Edit profile state
  const [editing, setEditing] = useState(false);
  const [editForm, setEditForm] = useState({ username: "", location: "", barangay: "" });
  const [editSaving, setEditSaving] = useState(false);
  const [uploadingPic, setUploadingPic] = useState(false);

  useEffect(() => {
    apiGet("/users/get_profile.php", { user_id: id }).then(d => { if (d.success) setProfile(d.user); });
    apiGet("/items/get_user_items.php", { user_id: id }).then(d => { if (d.success) setItems(d.items); });
    apiGet("/reviews/get_reviews.php", { reviewee_id: id }).then(d => {
      if (d.success) { setReviews(d.reviews); setAvgRating(d.avg_rating); }
    });
    apiGet("/trades/get_offers.php", { user_id: id }).then(d => { if (d.success) setTrades(d.offers); });
  }, [id]);

  const handleMessage = async () => {
    const d = await apiPost("/messages/start_convo.php", { other_user_id: id });
    if (d.success) navigate(`/messages/${d.convo_id}`);
  };

  const handleLogout = async () => {
    await apiGet("/auth/logout.php");
    logout();
    navigate("/login");
  };

  // Edit handlers
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

  // Profile picture upload
  const handlePicChange = async (e) => {
    const file = e.target.files[0];
    if (!file) return;
    if (!file.type.startsWith("image/")) {
      alert("Please select an image file.");
      return;
    }
    const formData = new FormData();
    formData.append("profile_pic", file);

    setUploadingPic(true);
    try {
      const res = await fetch("/api/users/upload_profile_pic.php", {
        method: "POST",
        credentials: "include",
        body: formData,
      });
      const data = await res.json();
      if (data.success) {
        setProfile(p => ({ ...p, profile_pic: data.profile_pic_url }));
      } else {
        alert(data.message || "Upload failed");
      }
    } catch (err) {
      console.error(err);
      alert("Upload error");
    }
    setUploadingPic(false);
    if (fileInputRef.current) fileInputRef.current.value = "";
  };

  if (!profile) return <p className="profile-loading">Loading...</p>;

  const isOwnProfile = user?.user_id == id;
  const joinYear = new Date(profile.created_at || Date.now()).getFullYear();

  return (
    <div className="profile-screen">
      <NavBar />

      <div className="content-wrap">       {/* ADDED WRAPPER */}

        {/* Hero */}
        <div className="profile-hero">
          <div className="profile-avatar-wrap">
            <div className="profile-avatar">
              {profile.profile_pic ? (
                <img src={profile.profile_pic} alt={profile.username} />
              ) : (
                <span className="profile-avatar-icon">&#x1F464;</span>
              )}
            </div>
            {isOwnProfile && !editing && (
              <>
                <button
                  className="profile-change-pic-btn"
                  onClick={() => fileInputRef.current?.click()}
                  disabled={uploadingPic}
                >
                  {uploadingPic ? "⏳" : "📷"}
                </button>
                <input
                  type="file"
                  accept="image/*"
                  ref={fileInputRef}
                  style={{ display: "none" }}
                  onChange={handlePicChange}
                />
              </>
            )}
            {profile.is_verified == 1 && (
              <span className="profile-verified-badge">&#10003;</span>
            )}
          </div>

          {!editing ? (
            <>
              <p className="profile-location">&#x1F4CD; {profile.location || "Location not set"}</p>
              {avgRating > 0 && (
                <p className="profile-rating">
                  <Stars rating={avgRating} />
                  <span className="profile-rating-val">{avgRating} Rating</span>
                </p>
              )}
              <p className="profile-member">&#x23F0; Member since {joinYear}</p>
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
                  &#x270E; Edit Profile
                </button>
                <button className="profile-logout-btn" onClick={handleLogout}>
                  &#x2192; Logout
                </button>
              </>
            )}
            {!isOwnProfile && (
              <>
                <button className="btn-secondary profile-btn" onClick={() => setShowReview(true)}>
                  &#x2605; Leave a Review
                </button>
                <button className="btn-secondary profile-btn" onClick={handleMessage}>
                  &#x1F4AC; Message
                </button>
              </>
            )}
          </div>

          {/* Stats row */}
          <div className="profile-stats">
            <div className="profile-stat">
              <span className="profile-stat-num profile-stat-green">{reviews.length}</span>
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

        {/* Tab Bar */}
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

        {/* Conditional Sections */}
        {activeTab === "listings" && (
          <div className="profile-section">
            <h3 className="profile-section-title">
              <span className="profile-section-icon">&#x1F4E6;</span> My Active Listings
            </h3>
            {items.filter(i => i.status === "available").length === 0 ? (
              <div className="profile-empty-state">
                <span className="profile-empty-icon">&#x1F4E6;</span>
                <p className="profile-empty-msg">You don't have any active listings right now.</p>
                <p className="profile-empty-hint">Post an item to start trading!</p>
              </div>
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
            <h3 className="profile-section-title">
              <span className="profile-section-icon">&#x21C6;</span> Recent Trades
            </h3>
            {trades.length === 0 ? (
              <p className="profile-no-reviews">No trades yet.</p>
            ) : (
              trades.map(o => (
                <div key={o.offer_id} className="trade-history-row">
                  <span className="th-item">
                    {o.offered_title} &#x21C6; {o.requested_title}
                  </span>
                  <span className={`tp-status-badge tp-status-${o.status === "accepted" ? "green" : o.status === "declined" ? "red" : "yellow"}`}>
                    {o.status}
                  </span>
                </div>
              ))
            )}
          </div>
        )}

        {activeTab === "reviews" && (
          <div className="profile-section">
            <h3 className="profile-section-title">
              <span className="profile-section-icon">&#x1F4AC;</span> My Reviews
            </h3>
            {reviews.length === 0 ? (
              <p className="profile-no-reviews">No reviews yet.</p>
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
            onClose={() => setShowReview(false)}
          />
        )}

      </div>                               {/* CLOSE WRAPPER */}
    </div>
  );
}