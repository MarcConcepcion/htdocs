import { useState } from "react";
import "./FilterPanel.css";
 
export default function FilterPanel({ onApply, onClose }) {
  const [category,  setCategory]  = useState("all");
  const [condition, setCondition] = useState("all");
  const [delivery,  setDelivery]  = useState("all");
  const [location,  setLocation]  = useState("");
 
  const apply = () => {
    onApply({ category, condition, delivery, location });
    onClose();
  };
 
  const reset = () => {
    setCategory("all"); setCondition("all");
    setDelivery("all"); setLocation("");
    onApply({ category:"all", condition:"all", delivery:"all", location:"" });
  };
 
  return (
    <div className="filter-panel">
      <div className="filter-panel-header">
        <span className="filter-panel-title">&#x2630; Advanced Filters</span>
        <button className="filter-reset" onClick={reset}>Reset all</button>
      </div>
 
      <div className="filter-row">
        <label className="filter-label">Category</label>
        <select className="form-field filter-select" value={category}
          onChange={e=>setCategory(e.target.value)}>
          <option value="all">All Categories</option>
          <option value="electronics">Electronics</option>
          <option value="vehicles">Vehicles</option>
          <option value="furniture">Furniture</option>
          <option value="clothing">Clothing</option>
          <option value="other">Other</option>
        </select>
      </div>
 
      <div className="filter-row">
        <label className="filter-label">Condition</label>
        <div className="filter-chips">
          {["all","new","like_new","good","fair","poor"].map(c=>(
            <button key={c}
              className={`filter-chip ${condition===c?"active":""}`}
              onClick={()=>setCondition(c)}>
              {c==="all"?"Any":c.replace("_"," ")}
            </button>
          ))}
        </div>
      </div>
 
      <div className="filter-row">
        <label className="filter-label">Delivery</label>
        <div className="filter-chips">
          {[{v:"all",l:"Any"},{v:"pickup",l:"Meet-up"},{v:"cod",l:"COD"},{v:"both",l:"Both"}].map(d=>(
            <button key={d.v}
              className={`filter-chip ${delivery===d.v?"active":""}`}
              onClick={()=>setDelivery(d.v)}>{d.l}</button>
          ))}
        </div>
      </div>
 
      <div className="filter-row">
        <label className="filter-label">Location</label>
        <input className="form-field" placeholder="City or municipality..."
          value={location} onChange={e=>setLocation(e.target.value)} />
      </div>
 
      <button className="btn-primary" onClick={apply}>Apply Filters</button>
    </div>
  );
}
