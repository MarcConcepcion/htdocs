import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { apiGet, apiPost } from "../../utils/api";
import FloatingNav from "../../components/FloatingNav";
import PageBanner  from "../../components/PageBanner";
import "./DeliveryPage.css";
 
export default function DeliveryPage() {
  const { offerId } = useParams();
  const navigate    = useNavigate();
  const [offer,     setOffer]     = useState(null);
  const [method,    setMethod]    = useState("");
  const [address,   setAddress]   = useState("");
  const [schedule,  setSchedule]  = useState("");
  const [saving,    setSaving]    = useState(false);
  const [saved,     setSaved]     = useState(false);
 
  useEffect(() => {
    apiGet("/trades/get_offers.php").then(d=>{
      if (d.success) {
        const found = d.offers.find(o=>o.offer_id==offerId);
        setOffer(found||null);
      }
    });
  }, [offerId]);
 
  const save = async () => {
    if (!method||!schedule) return;
    setSaving(true);
    // Save delivery note as a trade comment
    const note = `[DELIVERY] Method: ${method} | Schedule: ${schedule}${address?" | Address: "+address:""}`;
    await apiPost("/trade_comments/post_comment.php",{offer_id:offerId,content:note});
    setSaving(false); setSaved(true);
    setTimeout(()=>navigate(`/trades/${offerId}`),2000);
  };
 
  return (
    <div className="page-with-nav delivery-screen">
      <FloatingNav /><PageBanner />
      <div className="delivery-wrap">
        <div className="delivery-card">
          <h2 className="delivery-title">&#x1F69A; Coordinate Delivery</h2>
          {offer&&<p className="delivery-trade">
            Trade: <strong>{offer.offered_title}</strong> &#x21C6; <strong>{offer.requested_title}</strong>
          </p>}
 
          <label className="delivery-label">Delivery Method *</label>
          <div className="delivery-options">
            {[
              {v:"meetup",  icon:"\u{1F91D}", label:"Meet-up", desc:"Agree on a place to meet"},
              {v:"cod",     icon:"\u{1F4E6}", label:"COD",     desc:"Ship with cash on delivery"},
              {v:"pickup",  icon:"\u{1F697}", label:"Pick-up", desc:"Receiver comes to sender"},
            ].map(o=>(
              <label key={o.v}
                className={`delivery-option ${method===o.v?"selected":""}`}>
                <input type="radio" value={o.v}
                  checked={method===o.v}
                  onChange={()=>setMethod(o.v)}
                  style={{display:"none"}} />
                <span className="delivery-opt-icon">{o.icon}</span>
                <div>
                  <p className="delivery-opt-label">{o.label}</p>
                  <p className="delivery-opt-desc">{o.desc}</p>
                </div>
              </label>
            ))}
          </div>
 
          {(method==="meetup"||method==="cod") && (
            <><label className="delivery-label">Address / Location</label>
            <input className="form-field" placeholder="Enter address or meeting point"
              value={address} onChange={e=>setAddress(e.target.value)} /></>
          )}
 
          <label className="delivery-label">Agreed Schedule *</label>
          <input className="form-field" type="datetime-local"
            value={schedule} onChange={e=>setSchedule(e.target.value)} />
 
          {saved&&<p className="delivery-saved">&#x2713; Saved! Redirecting to trade panel...</p>}
          <button className="btn-primary" onClick={save}
            disabled={saving||!method||!schedule||saved}>
            {saving?"Saving...":"Confirm Delivery Plan"}
          </button>
        </div>
      </div>
    </div>
  );
}
