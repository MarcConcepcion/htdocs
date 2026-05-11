import { useEffect, useState, useRef } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useAuth }  from "../../context/AuthContext";
import { apiGet, apiPost } from "../../utils/api";
import FloatingNav from "../../components/FloatingNav";
import "./ChatView.css";
 
export default function ChatView() {
  const { convoId } = useParams();
  const { user }    = useAuth();
  const navigate    = useNavigate();
  const [messages, setMessages] = useState([]);
  const [text,     setText]     = useState("");
  const [sending,  setSending]  = useState(false);
  const bottomRef = useRef(null);
 
  const loadMsgs = () => {
    apiGet("/messages/get_dms.php", { convo_id: convoId })
      .then(d => { if (d.success) setMessages(d.messages); });
  };
 
  useEffect(() => { loadMsgs(); }, [convoId]);
  useEffect(() => { bottomRef.current?.scrollIntoView({behavior:"smooth"}); }, [messages]);
 
  const send = async () => {
    if (!text.trim()) return;
    setSending(true);
    await apiPost("/messages/send_dm.php", { convo_id: convoId, content: text });
    setText("");
    loadMsgs();
    setSending(false);
  };
 
  const handleKey = e => { if (e.key === "Enter" && !e.shiftKey) { e.preventDefault(); send(); } };
 
  return (
    <div className="page-with-nav chat-screen">
      <FloatingNav />
      <div className="chat-header">
        <button className="chat-back" onClick={() => navigate("/messages")}>&#8592;</button>
        <h2 className="chat-title">Chat</h2>
      </div>
      <div className="chat-messages">
        {messages.map(m => {
          const isMine = m.sender_id == user?.user_id;
          return (
            <div key={m.dm_id} className={`chat-bubble-wrap ${isMine ? "mine" : "theirs"}`}>
              {!isMine && <div className="chat-avatar">{m.sender_name?.[0]}</div>}
              <div className={`chat-bubble ${isMine ? "mine" : "theirs"}`}>
                <p className="chat-text">{m.content}</p>
                <span className="chat-time">{new Date(m.sent_at).toLocaleTimeString([],{hour:"2-digit",minute:"2-digit"})}</span>
              </div>
            </div>
          );
        })}
        <div ref={bottomRef} />
      </div>
      <div className="chat-input-row">
        <textarea className="chat-input form-field" rows={1}
          placeholder="Type a message..."
          value={text} onChange={e=>setText(e.target.value)} onKeyDown={handleKey} />
        <button className="chat-send-btn" onClick={send} disabled={sending || !text.trim()}>
          &#x27A4;
        </button>
      </div>
    </div>
  );
}
