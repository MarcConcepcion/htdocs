import { useEffect, useState } from "react";
import { apiGet } from "../../utils/api";
import NavBar   from "../../components/NavBar";
import ItemCard from "../../components/ItemCard";
import "./LandingPage.css";

// CATEGORIES constant is removed – now dynamic from DB

export default function LandingPage() {
  const [items,    setItems]    = useState([]);
  const [category, setCategory] = useState("all");
  const [loading,  setLoading]  = useState(true);
  
  // NEW: dynamic categories state
  const [dbCategories, setDbCategories] = useState(["all"]);

  // Existing fetch for items when category changes
  useEffect(() => {
    setLoading(true);
    apiGet("/items/get_items.php", category !== "all" ? { category } : {})
      .then(data => { if (data.success) setItems(data.items); })
      .finally(() => setLoading(false));
  }, [category]);

  // NEW: fetch once to get distinct categories from all items
  useEffect(() => {
    apiGet("/items/get_items.php").then(d => {
      if (d.success) {
        const cats = ["all", ...new Set(d.items.map(i => i.category).filter(Boolean))];
        setDbCategories(cats);
      }
    });
  }, []);

  return (
    <div className="landing-screen">
      <NavBar />

      <div className="landing-hero">
        <h1 className="landing-heading">What do you want to trade<br/>for today?</h1>
        <p className="landing-sub">Browse items from people near you looking to swap.</p>
      </div>

      <div className="landing-search-row">
        <div className="landing-search">
          <span className="landing-search-icon">&#x1F50D;</span>
          <input placeholder="Search items..." />
        </div>
        <button className="landing-icon-btn" title="Map">&#x1F5FA;</button>
        <button className="landing-icon-btn" title="Filter">&#x25A6;</button>
      </div>

      {/* NEW: dynamic category chips */}
      <div className="category-chips">
        {dbCategories.map(c => (
          <button
            key={c}
            className={`cat-chip ${category === c ? "active" : ""}`}
            onClick={() => setCategory(c)}
          >
            {c === "all" ? "All" : c.charAt(0).toUpperCase() + c.slice(1)}
          </button>
        ))}
      </div>

      <div className="landing-feed">
        {loading
          ? <p className="landing-state">Loading items...</p>
          : items.length === 0
            ? <p className="landing-state">No items yet. Be the first to post!</p>
            : items.map(item => <ItemCard key={item.item_id} item={item} />)
        }
      </div>
    </div>
  );
}