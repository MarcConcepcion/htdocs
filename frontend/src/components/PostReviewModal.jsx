import { useState } from "react";
import { apiPost } from "../utils/api";
import "./PostReviewModal.css";

function Stars({ value, onChange }) {
  return (
    <div className="star-picker">
      {[1,2,3,4,5].map(n=>(
        <button key={n} type="button"
          className={`star-pick ${n<=value?"filled":""}`}
          onClick={()=>onChange(n)}>&#9733;</button>
      ))}
    </div>
  );
}

export default function PostReviewModal({revieweeId,revieweeName,offerId,onClose}) {
  const [rating,  setRating]  = useState(5);
  const [comment, setComment] = useState("");
  const [saving,  setSaving]  = useState(false);
  const [error,   setError]   = useState("");
  const [done,    setDone]    = useState(false);

  const submit = async () => {
    if (!comment.trim()) { setError("Please write a comment."); return; }
    setSaving(true);
    setError("");
    try {
      const d = await apiPost("/reviews/post_review.php", {
        reviewee_id: revieweeId,
        offer_id:    offerId ?? null,
        rating,
        comment,
      });
      if (d.success) {
        setDone(true);
        // Auto-close after 2 seconds (optional)
        setTimeout(() => {
          onClose();
        }, 2000);
      } else {
        setError(d.message || "Could not post review.");
        setSaving(false);
      }
    } catch(e) {
      setError("Server unreachable. Check XAMPP is running.");
      setSaving(false);
    }
  };

  return (
    <div className="overlay-backdrop-center" onClick={onClose}>
      <div className="review-modal" onClick={e=>e.stopPropagation()}>
        {done ? (
          <div className="review-modal-done">
            <p className="review-done-icon">&#10003;</p>
            <p className="review-done-msg">Review posted!</p>
            <button className="btn-primary" onClick={onClose}>Close</button>
          </div>
        ) : (
          <>
            <div className="modal-header">
              <h2 className="modal-title">Review {revieweeName}</h2>
              <button className="modal-close" onClick={onClose}>&times;</button>
            </div>
            <p className="review-modal-sub">How was your trade experience?</p>
            <Stars value={rating} onChange={setRating} />
            <textarea className="form-field review-textarea"
              placeholder="Share your experience..."
              value={comment} onChange={e=>setComment(e.target.value)} />
            {error && <div className="review-modal-error">&#x26A0; {error}</div>}
            <button className="btn-primary" onClick={submit} disabled={saving}>
              {saving ? "Posting..." : "Post Review"}
            </button>
          </>
        )}
      </div>
    </div>
  );
}