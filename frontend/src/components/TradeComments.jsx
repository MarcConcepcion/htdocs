import { useEffect, useState } from "react";
import { useAuth } from "../context/AuthContext";
import { apiGet, apiPost } from "../utils/api";
import "./TradeComments.css";
 
export default function TradeComments({ offerId }) {
  const { user }    = useAuth();
  const [comments, setComments] = useState([]);
  const [text,     setText]     = useState("");
 
  const load = () => {
    apiGet("/trade_comments/get_comments.php", { offer_id: offerId })
      .then(d => { if (d.success) setComments(d.comments); });
  };
 
  useEffect(() => { load(); }, [offerId]);
 
  const send = async () => {
    if (!text.trim()) return;
    await apiPost("/trade_comments/post_comment.php", { offer_id: offerId, content: text });
    setText("");
    load();
  };
 
  return (
    <div className="tc-wrap">
      <h4 className="tc-title">Trade Discussion</h4>
      <div className="tc-list">
        {comments.length === 0 && <p className="tc-empty">No comments yet. Start the conversation!</p>}
        {comments.map(c => (
          <div key={c.comment_id} className={`tc-bubble ${c.user_id==user?.user_id?"mine":"theirs"}`}>
            <div className="tc-avatar">{c.username?.[0]?.toUpperCase()}</div>
            <div className="tc-body">
              <span className="tc-name">{c.username}</span>
              <p className="tc-text">{c.content}</p>
              <span className="tc-time">{new Date(c.created_at).toLocaleString()}</span>
            </div>
          </div>
        ))}
      </div>
      <div className="tc-input-row">
        <input className="form-field tc-input" placeholder="Write a comment..."
          value={text} onChange={e=>setText(e.target.value)}
          onKeyDown={e=>e.key==="Enter"&&send()} />
        <button className="btn-primary tc-send" onClick={send} disabled={!text.trim()}>Send</button>
      </div>
    </div>
  );
}
