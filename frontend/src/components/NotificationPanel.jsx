import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";                     // NEW import
import { apiGet, apiPost } from "../utils/api";
import "./NotificationPanel.css";

export default function NotificationPanel({ onClose, setUnread }) {
  const navigate = useNavigate();                                   // NEW
  const [notifs,  setNotifs]  = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    apiGet("/notifications/get_notifs.php")
      .then(d => {
        if (d.success) {
          setNotifs(d.notifications);
          setUnread(d.unread_count);
        }
      })
      .finally(() => setLoading(false));
  }, []);

  const markRead = async (notif_id) => {
    await apiPost("/notifications/mark_read.php", { notif_id });
    setNotifs(prev => prev.map(n => n.notif_id === notif_id ? { ...n, is_read: 1 } : n));
    setUnread(prev => Math.max(0, prev - 1));
  };

  return (
    <div className="overlay-backdrop-center" onClick={onClose}>
      <div className="notif-panel" onClick={e => e.stopPropagation()}>
        <div className="modal-header">
          <h2 className="modal-title">Notifications</h2>
          <button className="modal-close" onClick={onClose}>&times;</button>
        </div>
        {loading && <p className="notif-state">Loading...</p>}
        {!loading && notifs.length === 0 && (
          <p className="notif-state">No notifications yet.</p>
        )}
        <div className="notif-list">
          {notifs.map(n => (
            <div
              key={n.notif_id}
              className={`notif-row ${n.is_read ? "" : "unread"}`}
              onClick={() => {
                if (!n.is_read) markRead(n.notif_id);
                // Navigate to trade panel if trade-related
                if (["trade_offer", "offer_accepted", "offer_declined"].includes(n.type) && n.reference_id) {
                  onClose();
                  navigate(`/trades/${n.reference_id}`);
                }
              }}
            >
              <div className="notif-dot">{!n.is_read && <span className="dot" />}</div>
              <div className="notif-body">
                <p className="notif-msg">{n.message}</p>
                <p className="notif-time">{new Date(n.created_at).toLocaleString()}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}