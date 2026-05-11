import "./ModerationBanner.css";
 
export default function ModerationBanner({ isWarned, isBanned, negCount }) {
  if (!isWarned && !isBanned) return null;
  return (
    <div className={`mod-banner ${isBanned ? "banned" : "warned"}`}>
      {isBanned ? (
        <>
          <span className="mod-icon">&#x26D4;</span>
          <div>
            <p className="mod-title">Account Suspended</p>
            <p className="mod-msg">This account has been banned due to {negCount} negative reviews.</p>
          </div>
        </>
      ) : (
        <>
          <span className="mod-icon">&#x26A0;</span>
          <div>
            <p className="mod-title">Account Warning</p>
            <p className="mod-msg">This account has received {negCount} negative reviews. Continued violations may result in suspension.</p>
          </div>
        </>
      )}
    </div>
  );
}
