# Design System Document: The Sacred Editorial

## 1. Overview & Creative North Star
**Creative North Star: "The Timeless Archivist"**

This design system moves away from the cold, modular nature of standard web layouts. Instead, it treats the digital screen as a curated, high-end editorial publication—think of a bespoke museum monograph or a legacy leather-bound archive. 

We achieve an "Intimate and Reverent" feel by breaking the rigid, symmetrical grid. We favor **intentional asymmetry**, where white space (breath) is as important as the content itself. By utilizing overlapping elements, deep tonal layering, and soft amber glows, we create an environment that feels lived-in, nostalgic, and deeply respectful. This is not a "website"; it is a digital sanctuary.

---

## 2. Colors & Atmospheric Depth

The palette is rooted in the warmth of aged wood and the flicker of candlelight. 

### The "No-Line" Rule
**Explicit Instruction:** You are prohibited from using 1px solid borders to define sections. High-end design is felt, not outlined. Boundaries must be defined solely through:
- **Background Shifts:** Moving from `surface` (#161311) to `surface-container-low` (#1e1b19).
- **Soft Glows:** Using radial gradients of `primary` (#ffc66b) at 5-10% opacity to "lift" a section.

### Surface Hierarchy & Nesting
Treat the UI as physical layers of "dark wood" and "frosted vellum."
- **Base Layer:** `surface` (#161311).
- **Secondary Content:** Use `surface-container` (#221f1d) for large content blocks.
- **Emphasis/Nesting:** To highlight a specific memory or quote, use `surface-container-highest` (#383432) nested within a lower tier. This creates depth without visual clutter.

### The "Glass & Gold" Rule
To mimic the feel of a preserved relic behind glass, use **Glassmorphism** for floating elements (like navigation bars or hovering cards). Use a semi-transparent `surface-container-low` with a `backdrop-blur` of 20px. 

### Signature Textures
Apply a subtle linear gradient to main CTAs: `primary` (#ffc66b) transitioning to `primary-container` (#e8a838) at a 45-degree angle. This provides a metallic, "gold-leaf" luster that flat colors cannot replicate.

---

## 3. Typography

The typographic soul of this system lies in the contrast between the modern precision of **Plus Jakarta Sans** and the rhythmic, humanist flow of **Be Vietnam Pro**.

*   **Display & Headlines (Plus Jakarta Sans):** These are your "Architectural" elements. Use `display-lg` and `headline-lg` with tight letter-spacing (-0.02em) to create an authoritative, editorial presence.
*   **Body & Italics (Be Vietnam Pro):** This is your "Narrative" element. The slightly taller x-height of Be Vietnam Pro ensures readability against dark backgrounds. Use *italics* generously for quotes or nostalgic asides to evoke the feeling of handwritten notes.
*   **Hierarchy as Brand:** Use `secondary` text color (#8a8078) for metadata or "secondary memories" to ensure the eye always lands on the `primary` narrative first.

---

## 4. Elevation & Depth

We move beyond the Material Design "drop shadow" into **Tonal Layering**.

*   **The Layering Principle:** Depth is achieved by stacking. Place a `surface-container-lowest` card on a `surface-container-low` section. This creates a "recessed" or "carved" look, reminiscent of an engraved plaque.
*   **Ambient Shadows:** If a card must float, use a shadow with a blur of 40px and a 6% opacity. The shadow color should be `#000000` (to deepen the wood tones) rather than a neutral grey.
*   **The "Ghost Border" Fallback:** If a border is required for accessibility, use the `outline-variant` (#504535) at **15% opacity**. It should be felt as a subtle change in light, not a hard line.
*   **Amber Glows:** Use the `surface-tint` (#fdba49) as a soft, blurred background glow behind high-priority imagery to simulate the warmth of a nearby candle or reading lamp.

---

## 5. Components

### Buttons & CTAs
*   **Primary:** High-luster gradient (`primary` to `primary-container`). Roundedness: `md` (0.375rem). No border. Text is `on-primary` (#432c00), all caps, bold.
*   **Tertiary (Ghost):** No background. Text in `primary`. On hover, a subtle `surface-container-highest` background appears with a soft fade.

### Cards & Narrative Blocks
*   **Strict Rule:** No dividers. Use **Spacing Scale 12** (4rem) to separate stories or sections.
*   **Styling:** Use `surface-container-low`. Apply a 2px "Ghost Border" on the top edge only to catch the "light" of the amber theme.

### Chips & Tags
*   Use `surface-variant` with `on-surface-variant` text. Roundedness: `full`. These should feel like small, smooth stones—organic and unobtrusive.

### Input Fields
*   **Style:** Minimalist. Only a bottom "Ghost Border" that transitions to a `primary` (#ffc66b) glow on focus. Labels use `label-md` in `secondary` text.

### The "Memory Timeline" (Custom Component)
Instead of a straight line, use a staggered vertical layout. Dates use `headline-sm` in `primary` gold, while the narrative body text wraps around them with generous padding (`Spacing Scale 8`).

---

## 6. Do’s and Don'ts

### Do:
*   **Use Asymmetry:** Place an image on the left and text on the right, but offset their vertical alignment.
*   **Embrace the Dark:** Allow large areas of `#161311` to exist. It creates the "reverent" atmosphere.
*   **Use Large Imagery:** When using photos of the subject/memorial, let them bleed off one edge of the screen to break the "contained" feel.

### Don't:
*   **Don't use 100% white:** Never use #FFFFFF. It will shatter the "warm amber" immersion. Use `primary` text (#e9e1dd).
*   **Don't use sharp corners:** Avoid `none` roundedness. Even a subtle `sm` (0.125rem) radius softens the digital edge and makes the UI feel more "analog."
*   **Don't use rapid animations:** Transitions should be slow (300ms-500ms) and use a "Cubic Bezier" ease-in-out to mimic the deliberate turning of a heavy book page.

### Accessibility Note:
While we use deep dark tones, always ensure your `primary` and `secondary` text colors maintain a 4.5:1 contrast ratio against the `surface-container` tiers to ensure the memorial is readable for all generations.