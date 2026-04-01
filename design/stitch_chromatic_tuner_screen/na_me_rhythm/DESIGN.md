# Design System Strategy: The Rhythmic Pulse

## 1. Overview & Creative North Star
The creative North Star for this design system is **"The Digital Conductor."** 

This is not a static interface; it is a living, breathing instrument. To move beyond the "template" look of modern SaaS, we lean into the precision of high-end audio engineering and the kinetic energy of rhythm games. The aesthetic rejects the "flatness" of standard Material Design in favor of **Tonal Luminescence**. 

We achieve an editorial, premium feel by utilizing intentional asymmetry—placing technical data in narrow, high-density columns (using Space Grotesk) against expansive, airy headlines (using Plus Jakarta Sans). Overlapping elements, such as waveforms bleeding behind UI containers, break the "box-within-a-box" monotony and create a sense of rhythmic depth.

---

## 2. Colors & Atmospheric Depth

Our palette is rooted in deep, oceanic teals to minimize eye strain during long production sessions, punctuated by "vibrant neon" status hits that mimic LED indicators on hardware.

### The "No-Line" Rule
**Borders are prohibited for structural sectioning.** Boundaries must be defined solely through background color shifts or subtle tonal transitions. For example, a track list should sit on `surface_container_low` while the active track's background shifts to `surface_container_high`. If a boundary feels "lost," increase the contrast between the surface tiers rather than reaching for a stroke.

### Surface Hierarchy & Nesting
Treat the UI as a series of stacked, semi-translucent glass plates. 
- **Base Layer:** `surface_dim` (#041615) for the global canvas.
- **Sectioning:** Use `surface_container_low` (#0C1F1D) for main content areas.
- **Interactive Layers:** Use `surface_container_highest` (#253836) for cards or floating panels to create a natural "lift."

### The "Glass & Glow" Rule
To capture the "Rhythm Game" energy, use **Glassmorphism** for floating controllers and playheads. Apply `surface_variant` at 60% opacity with a `24px` backdrop blur. 
- **Signature Glow:** Instead of heavy gradients, use a 2px inner-shadow on primary buttons using `primary_fixed` at 30% opacity to mimic a backlit mechanical key.

---

## 3. Typography: The Editorial Mix

We use a tri-font system to separate brand emotion, technical precision, and functional utility.

*   **Display & Headlines (Plus Jakarta Sans):** These are our "Hero" moments. Use `display-lg` with tight letter-spacing (-2%) and `headline-md` for page titles. The soft curves of Jakarta balance the sharp technicality of the app.
*   **Technical Data (Space Grotesk):** All numerical values, BPM counts, timestamps, and frequencies must use Space Grotesk. Its monospaced-leaning rhythm conveys professional-grade accuracy.
*   **UI Labels (Be Vietnam Pro):** Used for navigation, tooltips, and small button text. It provides maximum legibility at small scales (`label-sm`) without the personality of the other two fonts.

---

## 4. Elevation & Depth: Tonal Layering

Traditional shadows feel "heavy" and muddy in dark teal environments. We use **Tonal Layering** and **Ambient Light**.

*   **The Layering Principle:** Depth is achieved by "stacking." A `surface_container_lowest` inset area within a `surface_container_high` card creates a "milled" look, similar to an aluminum audio interface.
*   **Ambient Shadows:** When an element must float (e.g., a modal), use a shadow tinted with `primary` at 5% opacity, with a `48px` blur. This creates a "glow" rather than a "shadow."
*   **The Ghost Border Fallback:** If a separator is required for accessibility, use the `outline_variant` token at **15% opacity**. It should be felt, not seen.
*   **Oscilloscope Textures:** Apply a 10% opacity dot-grid pattern (using `outline`) to `surface_container_lowest` backgrounds to provide a tactile, technical "floor" to the interface.

---

## 5. Components

### Buttons
*   **Primary:** Solid `primary_container` (#4ECDC4) with `on_primary` text. No border. State changes (hover/active) should be handled via a brightness shift or a subtle `primary` outer glow.
*   **Secondary:** Ghost-style but with no border. Use `surface_container_highest` as the background.
*   **Rhythmic Interaction:** All buttons should have a `200ms` "spring" transition to mimic the tactile feedback of a MIDI controller.

### Cards & Lists
*   **Constraint:** Zero dividers. 
*   **Separation:** Use `8px` (`2`) or `12px` (`3`) vertical spacing from the scale. 
*   **Hover State:** On hover, a list item should shift from `surface` to `surface_container_low` and reveal a `2px` vertical accent of `primary` on the far left.

### Oscilloscope Visualizers (Custom Component)
*   **Style:** Use `secondary` (#4EDEA3) for active waveforms.
*   **Treatment:** Lines should be 1.5px thick with a `primary_fixed_dim` outer glow to simulate a CRT phosphor screen.

### Checkboxes & Radios
*   Avoid standard boxes. Use "Toggle Switches" that resemble vintage console flip-switches. Use `primary` for the "On" state and `surface_variant` for "Off."

---

## 6. Do's and Don'ts

### Do
*   **DO** use `Space Grotesk` for anything involving a number.
*   **DO** use asymmetric layouts (e.g., a wide 8-column main view and a narrow 4-column "Technical Inspector" view).
*   **DO** use `surface_container` tokens to create "wells" and "plateaus" in the UI.

### Don't
*   **DON'T** use 100% opaque white text. Use `on_surface_variant` (#BCC9C7) for body text to maintain the "Dark Teal" atmosphere.
*   **DON'T** use 1px solid borders to separate tracks or menu items. Use white space.
*   **DON'T** use standard "Drop Shadows." If it needs to pop, use a "Tonal Lift" (lighter background) or a "Glow."
*   **DON'T** use sharp 0px corners. Stick to the `md` (0.375rem) or `lg` (0.5rem) roundedness scale to keep the "Professional" but "Vibrant" vibe.