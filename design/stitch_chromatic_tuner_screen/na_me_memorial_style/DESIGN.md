# Design System Document: An Editorial Vision for Quiet Reverence

## 1. Overview & Creative North Star: "The Resonant Echo"
This design system is not a utility; it is a sanctuary. Designed for the "About" experience of a memorial music application, the Creative North Star is **"The Resonant Echo."** 

We move away from the rigid, clinical grids of standard SaaS products and toward a handcrafted, editorial layout. The interface should feel like an expensive, leather-bound program from a classical concert hall or a weathered piece of sheet music. We achieve this through:
*   **Intentional Asymmetry:** Avoid centering everything. Let white space (or "dark space") breathe.
*   **Overlapping Elements:** Images and typography should gently bleed into one another to create a sense of continuity and memory.
*   **Soft Glows:** Instead of harsh lights, we use the amber palette to create "candlelight" effects that guide the eye.

## 2. Colors & Tonal Depth
The palette is rooted in the earth and precious metals. We treat the screen not as a monitor, but as a physical surface of dark wood and gold leaf.

### The "No-Line" Rule
**Strict Mandate:** 1px solid borders are strictly prohibited for sectioning or containment. We define boundaries through tonal shifts. A `surface-container-low` section sitting on a `surface` background provides all the separation needed. If a user can see a hard line, the "handcrafted" feel is lost.

### Surface Hierarchy & Nesting
Treat the UI as a series of nested physical layers. 
*   **Base Layer:** `surface` (#161311) – The deep, dark wood foundation.
*   **Secondary Layer:** `surface-container-low` (#1E1B19) – For subtle content grouping.
*   **Focus Layer:** `surface-container-high` (#2D2927) – For interactive elements or featured stories.

### The "Glass & Gold" Rule
To create a premium, intimate feel, use Glassmorphism for floating overlays (like music players or navigation bars). 
*   **Formula:** Use `surface-variant` (#383432) at 60% opacity with a `20px` backdrop-blur. 
*   **Signature Texture:** Use a radial gradient for Hero sections: `primary` (#FFC66B) transitioning to `primary-container` (#E8A838) at a 15% opacity to mimic the soft glow of a spotlight on a stage.

## 3. Typography: The Voice of Memory
The interplay between the bold, expressive **Plus Jakarta Sans** and the sensitive **Be Vietnam Pro** creates a dialogue between the "Headline" (the legend) and the "Body" (the story).

*   **Display & Headline (Plus Jakarta Sans):** These should be treated as art. Use `display-lg` with tight letter-spacing (-0.02em) to create an authoritative, editorial look.
*   **Body & Labels (Be Vietnam Pro):** Reserved for the narrative. Ensure line-height is generous (1.6x for `body-lg`) to allow for "sensitive" reading—never cramming the text.
*   **Contrast:** Always use `on-surface` (#E9E1DD) for body text. Use `muted warm gray` (#8A8078) for `label-sm` to denote secondary metadata like dates or photo credits.

## 4. Elevation & Depth: Tonal Layering
In a memorial context, traditional shadows can feel "heavy" or "digital." We use light and layering to create lift.

*   **The Layering Principle:** Place a `surface-container-lowest` card on a `surface-container-low` section. This creates a soft, natural "recessed" look, like a photograph tucked into a frame.
*   **Ambient Shadows:** If an element must float (e.g., a "Play Tribute" FAB), use a shadow with a `40px` blur at 8% opacity. The shadow color must be a tinted version of the background, never pure black.
*   **The Ghost Border:** If a boundary is required for accessibility, use `outline-variant` (#504535) at **15% opacity**. It should be felt, not seen.

## 5. Components: The Handcrafted Interface

### Buttons: The Tactile Gold
*   **Primary:** A soft gradient from `primary-fixed-dim` to `primary-container`. No hard borders. `xl` roundedness (0.75rem).
*   **Secondary:** No fill. `on-surface` text with a "Ghost Border."
*   **States:** On hover, primary buttons should not "glow" brighter; instead, they should subtly increase in saturation.

### Cards & Lists: The No-Divider Rule
*   **Cards:** Use `surface-container-low` with a padding of `8` (2.75rem) from the spacing scale. 
*   **Lists:** Forbid the use of divider lines. Use vertical white space (`spacing-6` or `spacing-8`) to separate list items. The eye will follow the rhythm of the typography.

### Chips: The Subtle Marker
*   Used for music genres or era tags. Use `surface-variant` background with `on-surface-variant` text. Roundedness: `full`. 

### The "Memorial Timeline" (Custom Component)
A vertical line using `outline-variant` at 20% opacity. Points on the timeline should use `primary` gold circles with a `6px` soft outer glow to represent "points of light" in a person's history.

## 6. Do’s and Don’ts

### Do:
*   **Use Organic Spacing:** Lean into the `spacing-12` (4rem) and `spacing-16` (5.5rem) tokens for section margins. Distance creates reverence.
*   **Embrace the Dark:** Let the `background` (#161311) dominate. High-end design is defined by what you *don't* fill.
*   **Use Soft Transitions:** All hover states and page transitions should be slow (300ms–500ms) and use an "ease-in-out" curve to mimic a natural fade.

### Don’t:
*   **No Pure White:** Never use #FFFFFF. It is clinical and breaks the "warm wood" atmosphere. Use `on-surface` (#E9E1DD).
*   **No Centered Blocks of Text:** For "About" sections, left-align body text for readability, but offset the image to the right to create asymmetrical balance.
*   **No Icons with Enclosures:** Avoid putting icons in circles or boxes. Let the `amber gold` icons sit naked on the background to feel more integrated and less like a "web app."

---
*Director's Note: Remember, you are designing a digital heirloom. Every pixel should feel intentional, quiet, and warm.*