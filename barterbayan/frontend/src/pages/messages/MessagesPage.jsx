import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { apiGet } from "../../utils/api";
import FloatingNav from "../../components/FloatingNav";
import "./MessagesPage.css";
 
export default function MessagesPage() {
  const navigate = useNavigate();
  const [convos, setConvos] = useState([]);
  const [loading, setLoading] = useState(true);
 
  useEffect(() => {
    apiGet("/messages/get_convos.php")
      .then(d => { if (d.success) setConvos(d.conversations); })
      .finally(() => setLoading(false));
  }, []);
 
  return (
    <div className="page-with-nav messages-screen">
      <FloatingNav />
      <div className="msg-header">
        <h2 className="msg-title">Messages</h2>
      </div>
      {loading && <p className="msg-state">Loading...</p>}
      {!loading && convos.length === 0 && (
        <p className="msg-state">No conversations yet. Message a trader from their item page!</p>
      )}
      <div className="msg-list">
        {convos.map(c => (
          <div key={c.convo_id} className="msg-row"
            onClick={() => navigate(`/messages/${c.convo_id}`)}>
            <div className="msg-avatar">
              {c.other_pic
                ? <img src={c.other_pic} alt={c.other_name} />
                : c.other_name?.[0]?.toUpperCase()}
            </div>
            <div className="msg-info">
              <span className="msg-name">{c.other_name}</span>
              <span className="msg-preview">{c.last_msg || "No messages yet"}</span>
            </div>
            {c.unread > 0 && <span className="msg-unread">{c.unread}</span>}
          </div>
        ))}
      </div>
    </div>
  );
}
