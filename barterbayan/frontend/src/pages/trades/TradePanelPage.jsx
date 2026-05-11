import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";
import { apiGet, apiPost } from "../../utils/api";
import FloatingNav    from "../../components/FloatingNav";
import TradeComments  from "../../components/TradeComments";
import PostReviewModal from "../../components/PostReviewModal";
import "./TradePanelPage.css";
 
export default function TradePanelPage() {
  const { offerId } = useParams();
  const { user }    = useAuth();
  const navigate    = useNavigate();
  const [offers,     setOffers]     = useState([]);
  const [selected,   setSelected]   = useState(null);
  const [showReview, setShowReview] = useState(false);
  const [loading,    setLoading]    = useState(true);
 
  useEffect(() => {
    apiGet("/trades/get_offers.php")
      .then(d => {
        if (d.success) {
          setOffers(d.offers);
          if (offerId) {
            setSelected(d.offers.find(o => o.offer_id == offerId) || null);
          }
        }
      }).finally(() => setLoading(false));
  }, [offerId]);
 
  const respond = async (offer_id, response) => {
    const d = await apiPost("/trades/respond_offer.php", { offer_id, response });
    if (d.success) {
      setOffers(prev => prev.map(o => o.offer_id===offer_id ? {...o, status:response} : o));
      if (selected?.offer_id === offer_id) setSelected(s => ({...s, status:response}));
    }
  };
 
  const statusColor = s => s==="accepted"?"tp-status-green":s==="declined"?"tp-status-red":"tp-status-yellow";
 
  return (
    <div className="page-with-nav tp-screen">
      <FloatingNav />
      <div className="tp-layout">
 
        {/* Offers sidebar */}
        <div className="tp-sidebar">
          <h2 className="tp-sidebar-title">My Trades</h2>
          {loading && <p className="tp-state">Loading...</p>}
          {offers.map(o => (
            <div key={o.offer_id}
              className={`tp-offer-row ${selected?.offer_id===o.offer_id?"active":""}`}
              onClick={() => setSelected(o)}>
              <div className="tp-offer-titles">
                <span className="tp-offer-item">{o.offered_title}</span>
                <span className="tp-offer-arrow">&#x21C6;</span>
                <span className="tp-offer-item">{o.requested_title}</span>
              </div>
              <div className="tp-offer-meta">
                <span className="tp-offer-who">
                  {o.sender_id == user?.user_id ? `To: ${o.receiver_name}` : `From: ${o.sender_name}`}
                </span>
                <span className={`tp-status-badge ${statusColor(o.status)}`}>{o.status}</span>
              </div>
            </div>
          ))}
        </div>
 
        {/* Detail panel */}
        {selected ? (
          <div className="tp-detail">
            <div className="tp-detail-header">
              <h3 className="tp-detail-title">{selected.offered_title} &#x21C6; {selected.requested_title}</h3>
              <span className={`tp-status-badge ${statusColor(selected.status)}`}>{selected.status}</span>
            </div>
 
            <div className="tp-parties">
              <div className="tp-party"><span className="tp-party-label">Sender</span><span className="tp-party-name">{selected.sender_name}</span></div>
              <div className="tp-party"><span className="tp-party-label">Receiver</span><span className="tp-party-name">{selected.receiver_name}</span></div>
              {selected.cash_topup > 0 && <div className="tp-party"><span className="tp-party-label">Cash Top-up</span><span className="tp-party-name">₱{selected.cash_topup}</span></div>}
            </div>
 
            {/* Accept / Reject — only receiver can act, only when pending */}
            {selected.receiver_id == user?.user_id && selected.status === "pending" && (
              <div className="tp-actions">
                <button className="btn-primary tp-accept" onClick={() => respond(selected.offer_id, "accepted")}>
                  &#10003; Accept Trade
                </button>
                <button className="btn-secondary tp-reject" onClick={() => respond(selected.offer_id, "declined")}>
                  &#10005; Decline
                </button>
              </div>
            )}
 
            {/* Leave review after accepted */}
            {selected.status === "accepted" && (
              <button className="btn-secondary tp-review-btn" onClick={() => setShowReview(true)}>
                &#9733; Leave a Review
              </button>
            )}
 
            {/* Comment thread */}
            <TradeComments offerId={selected.offer_id} />
          </div>
        ) : (
          <div className="tp-empty">
            <p>Select a trade offer from the list to view details.</p>
          </div>
        )}
      </div>
 
      {showReview && selected && (
        <PostReviewModal
          revieweeId={selected.sender_id == user?.user_id ? selected.receiver_id : selected.sender_id}
          revieweeName={selected.sender_id == user?.user_id ? selected.receiver_name : selected.sender_name}
          offerId={selected.offer_id}
          onClose={() => setShowReview(false)}
        />
      )}
    </div>
  );
}
