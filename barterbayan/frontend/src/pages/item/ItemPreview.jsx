import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { apiGet, apiPost } from "../../utils/api";
import { useAuth } from "../../context/AuthContext";
import NavBar          from "../../components/FloatingNav";
import TradeOfferModal from "../../components/TradeOfferModal";
import MapOverlay      from "../../components/MapOverlay";
import PageBanner      from "../../components/PageBanner";
import "./ItemPreview.css";

function timeAgo(dateStr) {
  const diff = Date.now() - new Date(dateStr).getTime();
  const h = Math.floor(diff / 3600000);
  if (h < 24) return `${h}h ago`;
  return `${Math.floor(h / 24)}d ago`;
}

function Stars({ rating }) {
  return (
    <span className="stars">
      {[1, 2, 3, 4, 5].map(n => (
        <span key={n} className={`star ${n <= Math.round(rating) ? "filled" : ""}`}>&#9733;</span>
      ))}
    </span>
  );
}

export default function ItemPreview() {
  const { id } = useParams();
  const { user } = useAuth();
  const navigate = useNavigate();
  const [item, setItem] = useState(null);
  const [showOffer, setShowOffer] = useState(false);
  const [showMap, setShowMap] = useState(false);
  const [favorited, setFavorited] = useState(false);
  const [favLoading, setFavLoading] = useState(false);

  // Message drawer state
  const [showMsgDrawer, setShowMsgDrawer] = useState(false);
  const [msgText, setMsgText]             = useState("");
  const [msgSending, setMsgSending]       = useState(false);
  const [msgSent, setMsgSent]             = useState(false);

  useEffect(() => {
    apiGet("/items/get_single_item.php", { item_id: id })
      .then(d => { if (d.success) setItem(d.item); });
  }, [id]);

  // Check if item is already favorited
  useEffect(() => {
    if (id && user) {
      apiGet("/favorites/get_favs.php", { item_id: id })
        .then(d => { if (d.success) setFavorited(d.favorited); });
    }
  }, [id, user]);

  const toggleFav = async () => {
    setFavLoading(true);
    const d = await apiPost("/favorites/toggle_fav.php", { item_id: id });
    if (d.success) setFavorited(d.favorited);
    setFavLoading(false);
  };

  const shareItem = async () => {
    const url = window.location.href;
    if (navigator.share) {
      await navigator.share({ title: item.title, url });
    } else {
      await navigator.clipboard.writeText(url);
      alert("Link copied to clipboard!");
    }
  };

  const sendQuickMsg = async () => {
    if (!msgText.trim()) return;
    setMsgSending(true);
    const d = await apiPost("/messages/start_convo.php", { other_user_id: item.user_id });
    if (d.success) {
      await apiPost("/messages/send_dm.php", { convo_id: d.convo_id, content: msgText });
      setMsgSent(true);
      setMsgText("");
      setTimeout(() => { 
        setShowMsgDrawer(false); 
        setMsgSent(false); 
      }, 2000);
    }
    setMsgSending(false);
  };

  if (!item) return <p className="preview-loading">Loading...</p>;

  const isOwner = user?.user_id == item.user_id;
  const heroImg = item.images?.[0] ?? null;

  return (
    <div className="preview-screen">
      <NavBar />
      <PageBanner />
      <div className="content-wrap">

        {/* Hero image */}
        <div className="preview-hero">
          {heroImg
            ? <img src={heroImg} alt={item.title} />
            : <div style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "4rem" }}>&#x1F4E6;</div>
          }
          <span className="preview-hero-cond">{item.condition_status.replace("_", " ")}</span>
        </div>

        <div className="preview-content">
          {/* Title + location */}
          <div className="preview-title-row">
            <h2 className="preview-title">{item.title}</h2>
            {item.location && (
              <div className="preview-location">
                <span className="preview-loc-name">{item.location}</span>
                <span className="preview-loc-icon">&#x1F4CD;</span>
              </div>
            )}
          </div>

          {/* Like / share / time (updated) */}
          <div className="preview-actions">
            <button
              className={`preview-action-btn ${favorited ? "fav-active" : ""}`}
              onClick={toggleFav}
              disabled={favLoading}
              title={favorited ? "Remove from favorites" : "Add to favorites"}
            >
              {favorited ? "♥" : "♡"}
            </button>
            <button className="preview-action-btn" onClick={shareItem} title="Share item">
              🔗
            </button>
            <span className="preview-time">⏰ {timeAgo(item.created_at)}</span>
          </div>

          {/* LOOKING FOR */}
          {item.swap_for && (
            <div className="preview-looking">
              <div className="preview-looking-label">&#x21C6; Looking For</div>
              <div className="preview-looking-val">{item.swap_for}</div>
            </div>
          )}

          {/* Description */}
          <div>
            <p className="preview-desc-title">Description</p>
            <p className="preview-desc-text">{item.description || "No description provided."}</p>
          </div>

          {/* Seller row */}
          <div className="preview-seller">
            <div className="preview-seller-avatar">
              {item.profile_pic
                ? <img src={item.profile_pic} alt={item.username} />
                : item.username?.[0]?.toUpperCase()}
            </div>
            <div className="preview-seller-info">
              <span
                className="preview-seller-name clickable-name"
                onClick={() => navigate(`/profile/${item.user_id}`)}
              >
                {item.username}
              </span>
              <div className="preview-seller-row">
                <Stars rating={4} />
                {item.is_verified == 1 && (
                  <span className="preview-verified">&#10003; Verified</span>
                )}
              </div>
            </div>
          </div>

          {/* Message Trader button (only if not owner) — now opens drawer */}
          {!isOwner && (
            <button className="btn-secondary preview-msg-btn" onClick={() => setShowMsgDrawer(true)}>
              &#x1F4AC; Message Trader
            </button>
          )}

          {/* View on Map button */}
          {item.latitude && item.longitude && (
            <button className="btn-secondary preview-map-btn" onClick={() => setShowMap(true)}>
              &#x1F5FA; View on Map
            </button>
          )}
        </div>

        {/* Sticky trade offer button */}
        {!isOwner && (
          <button className="btn-primary preview-offer-btn" onClick={() => setShowOffer(true)}>
            &#x21C6; Make a Trade Offer
          </button>
        )}

        {/* Map overlay modal */}
        {showMap && <MapOverlay onClose={() => setShowMap(false)} focusItem={item} />}
        {showOffer && <TradeOfferModal targetItem={item} onClose={() => setShowOffer(false)} />}

        {/* Message slide-in drawer — placed OUTSIDE preview-content but INSIDE content-wrap */}
        {showMsgDrawer && (
          <>
            <div className="msg-drawer-backdrop" onClick={() => setShowMsgDrawer(false)} />
            <div className={`msg-drawer ${showMsgDrawer ? "open" : ""}`}>
              <div className="msg-drawer-header">
                <div>
                  <p className="msg-drawer-label">Message</p>
                  <p className="msg-drawer-name">{item.username}</p>
                </div>
                <button className="msg-drawer-close" onClick={() => setShowMsgDrawer(false)}>
                  &times;
                </button>
              </div>
              <div className="msg-drawer-body">
                {msgSent ? (
                  <div className="msg-drawer-sent">
                    <span>&#x2713;</span>
                    <p>Message sent to {item.username}!</p>
                  </div>
                ) : (
                  <>
                    <p className="msg-drawer-hint">
                      Send a message about: <strong>{item.title}</strong>
                    </p>
                    <textarea
                      className="form-field msg-drawer-textarea"
                      placeholder="Hi! Is this still available for trade?"
                      value={msgText}
                      onChange={e => setMsgText(e.target.value)}
                      rows={4}
                      autoFocus
                    />
                    <button
                      className="btn-primary"
                      onClick={sendQuickMsg}
                      disabled={msgSending || !msgText.trim()}
                    >
                      {msgSending ? "Sending..." : "Send Message"}
                    </button>
                  </>
                )}
              </div>
            </div>
          </>
        )}

      </div>
    </div>
  );
}