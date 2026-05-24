import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { apiGet } from "../../utils/api";
import FloatingNav from "../../components/FloatingNav";
import PageBanner from "../../components/PageBanner";
import ItemCard from "../../components/ItemCard";
import FilterPanel from "../../components/FilterPanel";
import "./LandingPage.css";

export default function LandingPage() {
  const navigate = useNavigate();
  const [items, setItems] = useState([]);
  const [allItems, setAllItems] = useState([]);
  const [categories, setCategories] = useState(["all"]);
  const [search, setSearch] = useState("");
  const [loading, setLoading] = useState(true);
  const [scrolled, setScrolled] = useState(false);
  const [userResults, setUserResults] = useState([]);
  const [showDropdown, setShowDropdown] = useState(false);
  const [advFilters, setAdvFilters] = useState({
    category: "all",
    condition: "all",
    delivery: "all",
    location: "",
  });
  const [showFilterPanel, setShowFilterPanel] = useState(false);

  useEffect(() => {
    setLoading(true);
    apiGet("/items/get_items.php")
      .then((d) => {
        if (d.success) {
          setAllItems(d.items);
          setItems(d.items);
          const cats = [
            "all",
            ...new Set(
              d.items
                .map((i) => i.category)
                .filter(Boolean)
            ),
          ];
          setCategories(cats);
        }
      })
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    let filtered = allItems;
    if (advFilters.category !== "all")
      filtered = filtered.filter((i) => i.category === advFilters.category);
    if (advFilters.condition !== "all")
      filtered = filtered.filter((i) => i.condition_status === advFilters.condition);
    if (advFilters.delivery !== "all")
      filtered = filtered.filter(
        (i) => i.delivery_type === advFilters.delivery || i.delivery_type === "both"
      );
    if (advFilters.location.trim())
      filtered = filtered.filter(
        (i) =>
          (i.location && i.location.toLowerCase().includes(advFilters.location.toLowerCase())) ||
          (i.city && i.city.toLowerCase().includes(advFilters.location.toLowerCase()))
      );
    if (search.trim()) {
      const q = search.trim().toLowerCase();
      filtered = filtered.filter(
        (i) =>
          i.title?.toLowerCase().includes(q) ||
          i.description?.toLowerCase().includes(q) ||
          i.username?.toLowerCase().includes(q)
      );
    }
    setItems(filtered);
  }, [advFilters, search, allItems]);

  useEffect(() => {
    const handleScroll = () => setScrolled(window.scrollY > 10);
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  useEffect(() => {
    if (search.trim().length < 2) {
      setUserResults([]);
      setShowDropdown(false);
      return;
    }
    const timer = setTimeout(() => {
      apiGet("/users/search_users.php", { q: search.trim() })
        .then((d) => {
          if (d.success && d.users.length > 0) {
            setUserResults(d.users);
            setShowDropdown(true);
          } else {
            setShowDropdown(false);
          }
        });
    }, 400);
    return () => clearTimeout(timer);
  }, [search]);

  return (
    <div className="temp-nav-override">
      <FloatingNav />
      <div className="landing-layout">
        <main className="landing-main">
          <PageBanner />
          <div className="content-wrap">
            <div className="landing-hero">
              <h1 className="landing-heading">
                What do you want to
                <br />
                trade for today?
              </h1>
              <p className="landing-sub">
                Browse items from people near you looking to swap.
              </p>
            </div>

            <div className={`landing-sticky-bar ${scrolled ? "scrolled" : ""}`}>
              <div className="landing-search-wrap">
                <div className="landing-search">
                  <span className="landing-search-icon">&#x1F50D;</span>
                  <input
                    type="text"
                    placeholder="Search items or traders..."
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                    onBlur={() => setTimeout(() => setShowDropdown(false), 150)}
                    onFocus={() => userResults.length > 0 && setShowDropdown(true)}
                  />
                  {search && (
                    <button
                      className="landing-search-clear"
                      onClick={() => {
                        setSearch("");
                        setShowDropdown(false);
                      }}
                    >
                      &#x2715;
                    </button>
                  )}
                  <button
                    className="landing-icon-btn"
                    onClick={() => setShowFilterPanel((p) => !p)}
                    title="Advanced filters"
                  >
                    ☰
                  </button>
                </div>

                {showDropdown && userResults.length > 0 && (
                  <div className="search-user-dropdown">
                    <p className="search-dropdown-label">Traders</p>
                    {userResults.map((u) => (
                      <div
                        key={u.user_id}
                        className="search-user-row"
                        onMouseDown={() => navigate(`/profile/${u.user_id}`)}
                      >
                        <div className="search-user-avatar">
                          {u.profile_pic ? (
                            <img src={u.profile_pic} alt={u.username} />
                          ) : (
                            u.username?.[0]?.toUpperCase()
                          )}
                        </div>
                        <div className="search-user-info">
                          <span className="search-user-name">{u.username}</span>
                          {u.is_verified == 1 && (
                            <span className="search-user-badge">&#10003; Verified</span>
                          )}
                          {u.is_banned == 1 && (
                            <span className="search-user-banned">Suspended</span>
                          )}
                          <span className="search-user-loc">{u.location}</span>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>

              <div className="category-bar-wrap">
                <div className="category-bar">
                  {categories.map((c) => (
                    <button
                      key={c}
                      className={`cat-chip ${advFilters.category === c ? "active" : ""}`}
                      onClick={() => setAdvFilters((f) => ({ ...f, category: c }))}
                    >
                      {c === "all" ? "All" : c.charAt(0).toUpperCase() + c.slice(1)}
                    </button>
                  ))}
                </div>
              </div>
            </div>

            {!loading && (
              <p className="landing-count">
                {items.length} {items.length === 1 ? "item" : "items"} found
                {advFilters.category !== "all" ? ` in ${advFilters.category}` : ""}
                {search ? ` matching "${search}"` : ""}
              </p>
            )}

            <div className="landing-feed">
              {loading ? (
                <p className="landing-state">Loading items...</p>
              ) : items.length === 0 ? (
                <p className="landing-state">
                  No items found. Try a different search or category.
                </p>
              ) : (
                items.map((item) => <ItemCard key={item.item_id} item={item} />)
              )}
            </div>
          </div>
        </main>
      </div>

      {/* Pop-up modal for advanced filters */}
      {showFilterPanel && (
        <div
          className="overlay-backdrop-center"
          onClick={() => setShowFilterPanel(false)}
        >
          <div onClick={(e) => e.stopPropagation()}>
            <FilterPanel
              onApply={setAdvFilters}
              onClose={() => setShowFilterPanel(false)}
            />
          </div>
        </div>
      )}
    </div>
  );
}