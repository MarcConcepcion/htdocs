import { useEffect, useState } from "react";
import { apiGet } from "../../utils/api";
import FloatingNav from "../../components/FloatingNav";
import ItemCard    from "../../components/ItemCard";
import "./LandingPage.css";
 
export default function LandingPage() {
  const [items,       setItems]       = useState([]);
  const [allItems,    setAllItems]    = useState([]);
  const [categories,  setCategories]  = useState(["all"]);
  const [category,    setCategory]    = useState("all");
  const [search,      setSearch]      = useState("");
  const [loading,     setLoading]     = useState(true);
 
  useEffect(() => {
    setLoading(true);
    apiGet("/items/get_items.php")
      .then(d => {
        if (d.success) {
          setAllItems(d.items);
          setItems(d.items);
          const cats = ["all", ...new Set(d.items.map(i => i.category).filter(Boolean))];
          setCategories(cats);
        }
      })
      .finally(() => setLoading(false));
  }, []);
 
  useEffect(() => {
    let filtered = allItems;
    if (category !== "all") {
      filtered = filtered.filter(i => i.category === category);
    }
    if (search.trim()) {
      const q = search.trim().toLowerCase();
      filtered = filtered.filter(i =>
        i.title.toLowerCase().includes(q) ||
        (i.description && i.description.toLowerCase().includes(q)) ||
        (i.username  && i.username.toLowerCase().includes(q))
      );
    }
    setItems(filtered);
  }, [category, search, allItems]);
 
  return (
    <div className="page-with-nav landing-screen">
      <FloatingNav />
 
      <div className="content-wrap">       {/* ADDED WRAPPER */}
        {/* Header */}
        <div className="landing-hero">
          <h1 className="landing-heading">What do you want to<br/>trade for today?</h1>
          <p className="landing-sub">Browse items from people near you looking to swap.</p>
        </div>
 
        {/* Search bar */}
        <div className="landing-search-row">
          <div className="landing-search">
            <span className="landing-search-icon">&#x1F50D;</span>
            <input
              placeholder="Search items, traders..."
              value={search}
              onChange={e => setSearch(e.target.value)}
            />
            {search && (
              <button className="landing-search-clear" onClick={() => setSearch("")}>&#x2715;</button>
            )}
          </div>
        </div>
 
        {/* Category chips */}
        <div className="category-bar-wrap">
          <div className="category-bar">
            {categories.map(c => (
              <button
                key={c}
                className={`cat-chip ${category === c ? "active" : ""}`}
                onClick={() => setCategory(c)}
              >
                {c === "all" ? "All" : c.charAt(0).toUpperCase() + c.slice(1)}
              </button>
            ))}
          </div>
        </div>
 
        {/* Results count */}
        {!loading && (
          <p className="landing-count">
            {items.length} {items.length === 1 ? "item" : "items"} found
            {category !== "all" ? ` in ${category}` : ""}
            {search ? ` matching "${search}"` : ""}
          </p>
        )}
 
        {/* Item feed */}
        <div className="landing-feed">
          {loading ? (
            <p className="landing-state">Loading items...</p>
          ) : items.length === 0 ? (
            <p className="landing-state">No items found. Try a different search or category.</p>
          ) : (
            items.map(item => <ItemCard key={item.item_id} item={item} />)
          )}
        </div>
      </div>                               {/* CLOSE WRAPPER */}
    </div>
  );
}