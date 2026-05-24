import { useState } from "react";
import { apiPost } from "../utils/api";
import "./ReportModal.css";
 
const REASONS = [
  {value:"scam",         label:"Scam / Fraud"},
  {value:"fake_item",    label:"Fake or misrepresented item"},
  {value:"harassment",   label:"Harassment or threats"},
  {value:"illegal_trade",label:"Illegal item or trade"},
  {value:"spam",         label:"Spam or fake account"},
  {value:"other",        label:"Other"},
];
 
export default function ReportModal({reportedId,reportedName,itemId,offerId,onClose}) {
  const [reason,  setReason]  = useState("");
  const [details, setDetails] = useState("");
  const [saving,  setSaving]  = useState(false);
  const [done,    setDone]    = useState(false);
  const [error,   setError]   = useState("");
 
  const submit = async () => {
    if (!reason) { setError("Please select a reason."); return; }
    setSaving(true);
    const d = await apiPost("/reports/submit_report.php",{
      reported_id:reportedId,item_id:itemId??null,
      offer_id:offerId??null,reason,details,
    });
    setSaving(false);
    if (d.success) setDone(true);
    else setError(d.message||"Failed to submit report.");
  };
 
  return (
    <div className="overlay-backdrop-center" onClick={onClose}>
      <div className="report-modal" onClick={e=>e.stopPropagation()}>
        {done ? (
          <div className="report-done">
            <span>&#x2714;</span>
            <p>Report submitted. Our admin team will review it.</p>
            <button className="btn-primary" onClick={onClose}>Close</button>
          </div>
        ) : (
          <>
            <div className="modal-header">
              <h2 className="modal-title">Report {reportedName}</h2>
              <button className="modal-close" onClick={onClose}>&times;</button>
            </div>
            <p className="report-sub">Select the reason for your report:</p>
            <div className="report-reasons">
              {REASONS.map(r=>(
                <label key={r.value} className={`report-reason ${reason===r.value?"active":""}`}>
                  <input type="radio" name="reason" value={r.value}
                    checked={reason===r.value}
                    onChange={()=>setReason(r.value)}
                    style={{display:"none"}} />
                  {r.label}
                </label>
              ))}
            </div>
            <textarea className="form-field report-textarea"
              placeholder="Additional details (optional)..."
              value={details} onChange={e=>setDetails(e.target.value)} />
            {error&&<p className="report-error">{error}</p>}
            <button className="btn-primary" onClick={submit} disabled={saving||!reason}>
              {saving?"Submitting...":"Submit Report"}
            </button>
          </>
        )}
      </div>
    </div>
  );
}
 
// Add Report button to ItemPreview.jsx and ProfilePage.jsx:
// import ReportModal from "../../components/ReportModal";
// const [showReport, setShowReport] = useState(false);
// <button className="btn-secondary" onClick={()=>setShowReport(true)}>&#x26A0; Report</button>
// {showReport && <ReportModal reportedId={item.user_id} reportedName={item.username}
//   itemId={item.item_id} onClose={()=>setShowReport(false)} />}
