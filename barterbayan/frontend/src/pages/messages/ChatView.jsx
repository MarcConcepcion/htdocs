import { useEffect, useState, useRef } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useAuth }  from "../../context/AuthContext";
import { apiGet, apiPost } from "../../utils/api";
import FloatingNav from "../../components/FloatingNav";
import "./ChatView.css";
import PageBanner from "../../components/PageBanner";

export default function ChatView() {
  const { convoId } = useParams();
  const { user }    = useAuth();
  const navigate    = useNavigate();
  const [convos,   setConvos]   = useState([]);
  const [messages, setMessages] = useState([]);
  const [text,     setText]     = useState("");
  const [sending,  setSending]  = useState(false);
  const bottomRef = useRef(null);
 
  // Load conversation list
  useEffect(() => {
    apiGet("/messages/get_convos.php").then(d => {
      if (d.success) setConvos(d.conversations);
    });
  }, []);
 
  // Load messages for current convo
  const loadMsgs = () => {
    if (!convoId) return;
    apiGet("/messages/get_dms.php", { convo_id: convoId })
      .then(d => { if (d.success) setMessages(d.messages); });
  };
  useEffect(() => { loadMsgs(); }, [convoId]);
  useEffect(() => { bottomRef.current?.scrollIntoView({ behavior:"smooth" }); }, [messages]);
 
  const send = async () => {
    if (!text.trim() || !convoId) return;
    setSending(true);
    await apiPost("/messages/send_dm.php", { convo_id: convoId, content: text });
    setText(""); loadMsgs();
    setSending(false);
  };
 
  const handleKey = e => {
    if (e.key === "Enter" && !e.shiftKey) { e.preventDefault(); send(); }
  };
 
  return (
    <div className="page-with-nav chat-shell">
      <FloatingNav />
      <PageBanner />
      {/* ── Left: Conversation list ── */}
      <aside className="chat-sidebar">
        <div className="chat-sidebar-header">
          <h2 className="chat-sidebar-title">Messages</h2>
        </div>
        <div className="chat-sidebar-list">
          {convos.length === 0 && (
            <p className="chat-sidebar-empty">No conversations yet.</p>
          )}
          {convos.map(c => (
            <div key={c.convo_id}
              className={`chat-sidebar-row ${c.convo_id == convoId ? "active" : ""}`}
              onClick={() => navigate(`/messages/${c.convo_id}`)}>
              <div className="chat-sidebar-avatar">
                {c.other_pic
                  ? <img src={c.other_pic} alt={c.other_name} />
                  : c.other_name?.[0]?.toUpperCase()}
              </div>
              <div className="chat-sidebar-info">
                <span className="chat-sidebar-name">{c.other_name}</span>
                <span className="chat-sidebar-preview">
                  {c.last_msg || "No messages yet"}
                </span>
              </div>
              {c.unread > 0 && (
                <span className="chat-sidebar-badge">{c.unread}</span>
              )}
            </div>
          ))}
        </div>
      </aside>
 
      {/* ── Right: Chat area ── */}
      <div className="chat-main">
        {!convoId ? (
          <div className="chat-empty-state">
            <span className="chat-empty-icon">&#x1F4AC;</span>
            <p>Select a conversation to start chatting</p>
          </div>
        ) : (
          <>
            <div className="chat-header">
              <button className="chat-back" onClick={() => navigate("/messages")}
                style={{display:"none"}}>&#8592;</button>
              <h3 className="chat-header-name">
                {convos.find(c => c.convo_id == convoId)?.other_name || "Chat"}
              </h3>
            </div>
 
            <div className="chat-messages">
              {messages.map(m => {
                const isMine = m.sender_id == user?.user_id;
                return (
                  <div key={m.dm_id}
                    className={`chat-bubble-wrap ${isMine ? "mine" : "theirs"}`}>
                    {!isMine && (
                      <div className="chat-avatar">
                        {m.sender_name?.[0]?.toUpperCase()}
                      </div>
                    )}
                    <div className={`chat-bubble ${isMine ? "mine" : "theirs"}`}>
                      <p className="chat-text">{m.content}</p>
                      <span className="chat-time">
                        {new Date(m.sent_at).toLocaleTimeString([],
                          {hour:"2-digit",minute:"2-digit"})}
                      </span>
                    </div>
                  </div>
                );
              })}
              <div ref={bottomRef} />
            </div>
 
            <div className="chat-input-row">
              <input className="chat-input form-field"
                placeholder="Type a message..."
                value={text}
                onChange={e => setText(e.target.value)}
                onKeyDown={handleKey}
              />
              <button className="chat-send-btn"
                onClick={send}
                disabled={sending || !text.trim()}>
                &#x27A4;
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
