import "./BannedLoginModal.css";
 
export default function BannedLoginModal({ onAcknowledge }) {
  return (
    <div className="banned-modal-overlay">
      <div className="banned-modal-card">
        <span className="banned-modal-icon">&#x26D4;</span>
        <h2 className="banned-modal-title">Account Suspended</h2>
        <p className="banned-modal-msg">
          Your BarterBayan account has been suspended due to receiving
          10 or more negative reviews from the community.
        </p>
        <p className="banned-modal-sub">
          You can still browse the platform, but you cannot post items,
          send trade offers, or message other traders.
        </p>
        <div className="banned-modal-actions">
          <button className="btn-primary banned-modal-btn"
            onClick={onAcknowledge}>
            I Understand — Continue
          </button>
        </div>
      </div>
    </div>
  );
}
