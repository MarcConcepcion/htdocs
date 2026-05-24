// Reusable logo component — replace SVG content with real logo when ready
export default function Logo({ size = 32 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 40 40"
      fill="none" xmlns="http://www.w3.org/2000/svg"
      aria-label="BarterBayan logo">
      {/* House shape */}
      <path d="M20 4L36 18H30V36H10V18H4L20 4Z"
        fill="#059669" opacity="0.15" />
      <path d="M20 4L36 18H30V36H10V18H4L20 4Z"
        stroke="#059669" strokeWidth="2.5" strokeLinejoin="round" fill="none"/>
      {/* Arrows inside */}
      <path d="M14 26l4-4-4-4M26 22l-4 4 4 4"
        stroke="#059669" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
      <line x1="18" y1="22" x2="22" y2="22"
        stroke="#059669" strokeWidth="2" strokeLinecap="round"/>
    </svg>
  );
}
