import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { apiPost } from "../../utils/api";
import Logo from "../../components/Logo";
import "./SignUp.css";

const PH_CITIES = [
  "Mamburao, Occidental Mindoro", "San Jose, Occidental Mindoro",
  "Caloocan", "Las Pinas", "Makati", "Malabon", "Mandaluyong",
  "Manila", "Marikina", "Muntinlupa", "Navotas", "Paranaque",
  "Pasay", "Pasig", "Quezon City", "San Juan", "Taguig", "Valenzuela",
  "Cebu City", "Mandaue", "Lapu-Lapu", "Davao City",
  "Iloilo City", "Baguio", "Cagayan de Oro", "Zamboanga City",
  "General Santos", "Bacolod", "Butuan",
];

export default function SignUp() {
  const navigate = useNavigate();
  const [form, setForm] = useState({
    first_name: "",
    middle_initial: "",
    last_name: "",
    username: "",
    email: "",
    phone: "",
    city: "",
    barangay: "",
    password: "",
  });
  const [error, setError] = useState("");
  const [done, setDone] = useState(false);
  const [agreed, setAgreed] = useState(false);

  const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    if (!agreed) {
      setError("You must agree to the Terms and Conditions.");
      return;
    }
    const data = await apiPost("/auth/register.php", form);
    if (data.success) {
      setDone(true);
      setTimeout(() => navigate("/login"), 2000);
    } else {
      setError(data.message);
    }
  };

  return (
    <div className="auth-screen">
      <div className="auth-card">
        <Logo size={56} />
        <h1 className="auth-logo">BarterBayan</h1>
        <p className="auth-tagline">Join the Community Barter Network</p>

        {done && <p className="auth-success">Registered! Redirecting...</p>}
        {error && <p className="auth-error">{error}</p>}

        <form className="auth-form" onSubmit={handleSubmit}>
          <div className="auth-name-row">
            <div className="auth-field-group auth-name-first">
              <label className="auth-label">First Name *</label>
              <input
                className="form-field"
                name="first_name"
                placeholder="Juan"
                value={form.first_name}
                onChange={handleChange}
                required
              />
            </div>
            <div className="auth-field-group auth-name-mi">
              <label className="auth-label">M.I.</label>
              <input
                className="form-field"
                name="middle_initial"
                placeholder="D."
                value={form.middle_initial}
                onChange={handleChange}
                maxLength={3}
              />
            </div>
            <div className="auth-field-group auth-name-last">
              <label className="auth-label">Last Name *</label>
              <input
                className="form-field"
                name="last_name"
                placeholder="Dela Cruz"
                value={form.last_name}
                onChange={handleChange}
                required
              />
            </div>
          </div>

          <div className="auth-field-group">
            <label className="auth-label">Username</label>
            <input
              className="form-field"
              name="username"
              placeholder="e.g. JuanBarter"
              value={form.username}
              onChange={handleChange}
              required
            />
          </div>
          <div className="auth-field-group">
            <label className="auth-label">Email Address</label>
            <input
              className="form-field"
              type="email"
              name="email"
              value={form.email}
              onChange={handleChange}
              required
            />
          </div>
          <div className="auth-field-group">
            <label className="auth-label">Phone Number</label>
            <input
              className="form-field"
              name="phone"
              placeholder="09XXXXXXXXX"
              value={form.phone}
              onChange={handleChange}
              required
            />
          </div>
          <div className="auth-field-group">
            <label className="auth-label">City / Municipality</label>
            <select
              className="form-field"
              name="city"
              value={form.city}
              onChange={handleChange}
              required
            >
              <option value="">-- Select your city --</option>
              {PH_CITIES.map(c => <option key={c} value={c}>{c}</option>)}
            </select>
          </div>
          <div className="auth-field-group">
            <label className="auth-label">Barangay</label>
            <input
              className="form-field"
              name="barangay"
              placeholder="Your barangay"
              value={form.barangay}
              onChange={handleChange}
            />
          </div>
          <div className="auth-field-group">
            <label className="auth-label">Password</label>
            <input
              className="form-field"
              type="password"
              name="password"
              value={form.password}
              onChange={handleChange}
              required
            />
          </div>

          <label className="auth-terms-row">
            <input type="checkbox" checked={agreed} onChange={e => setAgreed(e.target.checked)} />
            <span>
              I agree to the{" "}
              <a href="/terms" target="_blank" className="auth-link">Terms and Conditions</a>
              {" "}and{" "}
              <a href="/privacy" target="_blank" className="auth-link">Privacy Policy</a>.
            </span>
          </label>

          <button type="submit" className="btn-primary" style={{ marginTop: "8px" }}>
            Create Account
          </button>
        </form>
        <p className="auth-footer">
          Already have an account?{" "}
          <Link to="/login" className="auth-link">Sign In</Link>
        </p>
      </div>
    </div>
  );
}