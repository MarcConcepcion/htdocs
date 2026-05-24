import { useEffect, useState, useRef } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { apiGet, apiPost } from "../../utils/api";
import { useAuth } from "../../context/AuthContext";
import NavBar          from "../../components/FloatingNav";
import TradeOfferModal from "../../components/TradeOfferModal";
import MapOverlay      from "../../components/MapOverlay";
import PageBanner      from "../../components/PageBanner";
import ReportModal     from "../../components/ReportModal";
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
  const [showReport, setShowReport] = useState(false);

  // Chat drawer state
  const [showChat, setShowChat] = useState(false);
  const [convoId, setConvoId] = useState(null);
  const [messages, setMessages] = useState([]);
  const [msgText, setMsgText] = useState("");
  const [sending, setSending] = useState(false);
  const [loadingMsgs, setLoadingMsgs] = useState(false);
  const bottomRef = useRef(null);

  // 1. Fetch item details
  useEffect(() => {
    apiGet("/items/get_single_item.php", { item_id: id })
      .then(d => { if (d.success) setItem(d.item); });
  }, [id]);

  // 2. Check if favorited
  useEffect(() => {
    if (id && user) {
      apiGet("/favorites/get_favs.php", { item_id: id })
        .then(d => { if (d.success) setFavorited(d.favorited); });
    }
  }, [id, user]);

  // 3. When chat drawer opens, ensure conversation exists and load messages
  useEffect(() => {
    if (!showChat || !item || !user) return;
    const initConvo = async () => {
      setLoadingMsgs(true);
      try {
        // Start or get conversation with the seller
        const startRes = await apiPost("/messages/start_convo.php", {
          other_user_id: item.user_id
        });
        if (startRes.success) {
          setConvoId(startRes.convo_id);
          // Load messages
          const msgsRes = await apiGet("/messages/get_dms.php", { convo_id: startRes.convo_id });
          if (msgsRes.success) setMessages(msgsRes.messages);
        } else {
          console.error("Failed to start convo", startRes);
        }
      } catch (err) {
        console.error("Chat init error", err);
      } finally {
        setLoadingMsgs(false);
      }
    };
    initConvo();
  }, [showChat, item, user]);

  // Auto-scroll to bottom when new messages arrive
  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

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

  const sendMessage = async () => {
    if (!msgText.trim() || !convoId) return;
    setSending(true);
    const res = await apiPost("/messages/send_dm.php", { convo_id: convoId, content: msgText });
    if (res.success) {
      setMsgText("");
      // Reload messages
      const msgsRes = await apiGet("/messages/get_dms.php", { convo_id: convoId });
      if (msgsRes.success) setMessages(msgsRes.messages);
    }
    setSending(false);
  };

  const handleKey = (e) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  };

  if (!item) return <p className="preview-loading">Loading...</p>;

  const isOwner = user?.user_id == item.user_id;
  const heroImg = item.images?.[0] ?? null;

  return (
    <div className="preview-screen">
      <div className="temp-nav-override">
        <NavBar />
      </div>
      <PageBanner />
      <div className="content-wrap">

        <div className="preview-hero">
          {heroImg ? (
            <img src={heroImg} alt={item.title} />
          ) : (
            <div style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "4rem" }}>
              &#x1F4E6;
            </div>
          )}
          <span className="preview-hero-cond">{item.condition_status.replace("_", " ")}</span>
        </div>

        <div className="preview-content">
          <div className="preview-title-row">
            <h2 className="preview-title">{item.title}</h2>
            {item.location && (
              <div className="preview-location">
                <span className="preview-loc-name">{item.location}</span>
                <span className="preview-loc-icon">&#x1F4CD;</span>
              </div>
            )}
          </div>

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

          {item.swap_for && (
            <div className="preview-looking">
              <div className="preview-looking-label">&#x21C6; Looking For</div>
              <div className="preview-looking-val">{item.swap_for}</div>
            </div>
          )}

          <div>
            <p className="preview-desc-title">Description</p>
            <p className="preview-desc-text">{item.description || "No description provided."}</p>
          </div>

          <div className="preview-seller">
            <div className="preview-seller-avatar">
              {item.profile_pic ? (
                <img src={item.profile_pic} alt={item.username} />
              ) : (
                item.username?.[0]?.toUpperCase()
              )}
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
                {item.is_verified == 1 && <span className="preview-verified">&#10003; Verified</span>}
              </div>
            </div>
          </div>

          {!isOwner && (
            <>
              <button className="btn-secondary preview-msg-btn" onClick={() => setShowChat(true)}>
                &#x1F4AC; Message Trader
              </button>
              {item.latitude && item.longitude && (
                <button className="btn-secondary preview-map-btn" onClick={() => setShowMap(true)}>
                  &#x1F5FA; View on Map
                </button>
              )}
              <button className="btn-secondary" onClick={() => setShowReport(true)}>
                &#x26A0; Report
              </button>
            </>
          )}
        </div>

        {!isOwner && (
          <button className="btn-primary preview-offer-btn" onClick={() => setShowOffer(true)}>
            &#x21C6; Make a Trade Offer
          </button>
        )}

        {showMap && <MapOverlay onClose={() => setShowMap(false)} focusItem={item} />}
        {showOffer && <TradeOfferModal targetItem={item} onClose={() => setShowOffer(false)} />}
        {showReport && (
          <ReportModal
            reportedId={item.user_id}
            reportedName={item.username}
            itemId={item.item_id}
            onClose={() => setShowReport(false)}
          />
        )}

        {/* Slide-out chat drawer - full conversation */}
        {showChat && (
          <>
            <div className="chat-drawer-backdrop" onClick={() => setShowChat(false)} />
            <div className="chat-drawer">
              <div className="chat-drawer-header">
                <div className="chat-drawer-title">
                  <span className="chat-drawer-avatar">
                    {item.profile_pic ? (
                      <img src={item.profile_pic} alt={item.username} />
                    ) : (
                      item.username?.[0]?.toUpperCase()
                    )}
                  </span>
                  <span>{item.username}</span>
                </div>
                <button className="chat-drawer-close" onClick={() => setShowChat(false)}>
                  &times;
                </button>
              </div>
              <div className="chat-drawer-messages">
                {loadingMsgs && <p className="chat-loading">Loading messages...</p>}
                {!loadingMsgs && messages.length === 0 && (
                  <p className="chat-empty">No messages yet. Say hello!</p>
                )}
                {messages.map((msg) => {
                  const isMine = msg.sender_id === user?.user_id;
                  return (
                    <div key={msg.dm_id} className={`chat-bubble ${isMine ? "mine" : "theirs"}`}>
                      <p className="chat-bubble-text">{msg.content}</p>
                      <span className="chat-bubble-time">
                        {new Date(msg.sent_at).toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })}
                      </span>
                    </div>
                  );
                })}
                <div ref={bottomRef} />
              </div>
              <div className="chat-drawer-input">
                <input
                  type="text"
                  className="form-field"
                  placeholder="Type a message..."
                  value={msgText}
                  onChange={(e) => setMsgText(e.target.value)}
                  onKeyDown={handleKey}
                />
                <button className="chat-send-btn" onClick={sendMessage} disabled={sending || !msgText.trim()}>
                  &#x27A4;
                </button>
              </div>
            </div>
          </>
        )}

      </div>
    </div>
  );
}