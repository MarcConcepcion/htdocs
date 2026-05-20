import { useState } from "react";
import { apiPost } from "../utils/api";
import "./PostReviewModal.css";
 
function StarPicker({ value, onChange }) {
  return (
    <div className="star-picker">
      {[1,2,3,4,5].map(n => (
        <button key={n} type="button"
          className={`star-pick ${n <= value ? "filled" : ""}`}
          onClick={() => onChange(n)}>
          &#9733;
        </button>
      ))}
    </div>
  );
}
 
export default function PostReviewModal({ revieweeId, revieweeName, offerId, onClose }) {
  const [rating,  setRating]  = useState(5);
  const [comment, setComment] = useState("");
  const [saving,  setSaving]  = useState(false);
  const [error,   setError]   = useState("");
  const [done,    setDone]    = useState(false);
 
  const handleSubmit = async () => {
    if (!comment.trim()) { setError("Please write a comment."); return; }
    setSaving(true);
    setError("");
    try {
      const data = await apiPost("/reviews/post_review.php", {
        reviewee_id: revieweeId,
        offer_id:    offerId ?? null,
        rating,
        comment,
      });
      if (data.success) {
        setDone(true);
      } else {
        setError(data.message || "Failed to post review.");
        setSaving(false);   // ← KEY FIX: reset so button is not stuck
      }
    } catch (e) {
      setError("Network error. Please try again.");
      setSaving(false);    // ← reset on network error too
    }
  };
 
  return (
    // Use centered backdrop (same as notification)
    <div className="overlay-backdrop-center" onClick={onClose}>
      <div className="review-modal" onClick={e => e.stopPropagation()}>
        {done ? (
          <div className="review-modal-done">
            <p className="review-done-icon">&#10003;</p>
            <p className="review-done-msg">Review posted successfully!</p>
            <button className="btn-primary" onClick={onClose}>Close</button>
          </div>
        ) : (
          <>
            <div className="modal-header">
              <h2 className="modal-title">Review {revieweeName}</h2>
              <button className="modal-close" onClick={onClose}>&times;</button>
            </div>
            <p className="review-modal-sub">How was your trade experience?</p>
            <StarPicker value={rating} onChange={setRating} />
            <textarea className="form-field review-textarea"
              placeholder="Share your experience..."
              value={comment}
              onChange={e => setComment(e.target.value)} />
            {error && <p className="review-modal-error">{error}</p>}
            <button className="btn-primary"
              onClick={handleSubmit}
              disabled={saving}>
              {saving ? "Posting..." : "Post Review"}
            </button>
          </>
        )}
      </div>
    </div>
  );
}
