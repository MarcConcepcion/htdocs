import { useEffect, useState, useRef } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useAuth }        from "../../context/AuthContext";
import { apiGet, apiPost }from "../../utils/api";
import FloatingNav        from "../../components/FloatingNav";
import PageBanner         from "../../components/PageBanner";
import "./MessagesPage.css";
 
export default function MessagesPage() {
  const { convoId }   = useParams();
  const { user }      = useAuth();
  const navigate      = useNavigate();
  const [convos,   setConvos]   = useState([]);
  const [messages, setMessages] = useState([]);
  const [active,   setActive]   = useState(convoId || null);
  const [activeUser, setActiveUser] = useState(null);
  const [text,     setText]     = useState("");
  const [sending,  setSending]  = useState(false);
  const bottomRef  = useRef(null);
 
  useEffect(() => {
    apiGet("/messages/get_convos.php").then(d => {
      if (d.success) {
        setConvos(d.conversations);
        if (convoId) {
          const found = d.conversations.find(c => c.convo_id == convoId);
          if (found) setActiveUser(found);
        }
      }
    });
  }, []);
 
  const loadMessages = (cid) => {
    if (!cid) return;
    apiGet("/messages/get_dms.php", { convo_id: cid })
      .then(d => { if (d.success) setMessages(d.messages); });
  };
 
  useEffect(() => { loadMessages(active); }, [active]);
  useEffect(() => { bottomRef.current?.scrollIntoView({ behavior:"smooth" }); }, [messages]);
 
  const selectConvo = (c) => {
    setActive(c.convo_id);
    setActiveUser(c);
    setMessages([]);
    navigate(`/messages/${c.convo_id}`, { replace: true });
  };
 
  const send = async () => {
    if (!text.trim() || !active) return;
    setSending(true);
    await apiPost("/messages/send_dm.php", { convo_id: active, content: text });
    setText("");
    loadMessages(active);
    setSending(false);
  };
 
  const handleKey = e => {
    if (e.key==="Enter" && !e.shiftKey) { e.preventDefault(); send(); }
  };
 
  return (
    <div className="temp-banner-override">
  <PageBanner />
  <div className="temp-nav-override">
  <FloatingNav />
    <div className="page-with-nav msg-shell">
      
 
      <div className="msg-layout">
 
        <aside className="msg-sidebar">
          <div className="msg-sidebar-header">
            <h2 className="msg-sidebar-title">Messages</h2>
          </div>
          <div className="msg-sidebar-list">
            {convos.length === 0 && (
              <p className="msg-sidebar-empty">No conversations yet.</p>
            )}
            {convos.map(c => (
              <div key={c.convo_id}
                className={`msg-sidebar-row ${c.convo_id==active?"active":""}`}
                onClick={() => selectConvo(c)}>
                <div className="msg-avatar">
                  {c.other_pic
                    ? <img src={c.other_pic} alt={c.other_name} />
                    : <span>{c.other_name?.[0]?.toUpperCase()}</span>}
                </div>
                <div className="msg-info">
                  <span className="msg-name">{c.other_name}</span>
                  <span className="msg-preview">{c.last_msg||"No messages yet"}</span>
                </div>
                {c.unread>0 && <span className="msg-badge">{c.unread}</span>}
              </div>
            ))}
          </div>
        </aside>
 
        <div className="msg-main">
          {!active ? (
            <div className="msg-empty">
              <span className="msg-empty-icon">&#x1F4AC;</span>
              <p>Select a conversation to start chatting</p>
            </div>
          ) : (
            <>
              <div className="msg-chat-header">
                <div className="msg-chat-avatar">
                  {activeUser?.other_name?.[0]?.toUpperCase()}
                </div>
                <span className="msg-chat-name">
                  {activeUser?.other_name || "Chat"}
                </span>
              </div>
 
              <div className="msg-messages">
                {messages.map(m => {
                  const isMine = m.sender_id == user?.user_id;
                  return (
                    <div key={m.dm_id}
                      className={`msg-bubble-wrap ${isMine?"mine":"theirs"}`}>
                      {!isMine && (
                        <div className="msg-bubble-avatar">
                          {m.sender_name?.[0]?.toUpperCase()}
                        </div>
                      )}
                      <div className={`msg-bubble ${isMine?"mine":"theirs"}`}>
                        <p className="msg-bubble-text">{m.content}</p>
                        <span className="msg-bubble-time">
                          {new Date(m.sent_at).toLocaleTimeString([],
                            {hour:"2-digit",minute:"2-digit"})}
                        </span>
                      </div>
                    </div>
                  );
                })}
                {messages.length===0 && (
                  <p className="msg-no-messages">No messages yet. Say hello!</p>
                )}
                <div ref={bottomRef} />
              </div>
 
              <div className="msg-input-row">
                <input className="msg-input form-field"
                  placeholder="Type a message..."
                  value={text}
                  onChange={e=>setText(e.target.value)}
                  onKeyDown={handleKey}
                />
                <button className="msg-send-btn"
                  onClick={send}
                  disabled={sending||!text.trim()}>
                  &#x27A4;
                </button>
              </div>
            </>
          )}
        </div>
 
      </div>
    </div>
    </div>
    </div>
  );
}
