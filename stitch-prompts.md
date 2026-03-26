# Nağme — Google Stitch Tasarım Prompt'ları

> Bu dosyadaki prompt'ları stitch.withgoogle.com adresinde kullan.
> Mobile layout seç, Experimental Mode (Gemini 2.5 Pro) kullan.
> Her ekran için ayrı prompt gir, sonra prototype ile birleştir.

---

## GENEL STİL TANIMLAMASI (Her prompt'un başına ekle)

```
Style: Professional music studio aesthetic.
Dark background (#1A1A2E base, #16213E surfaces).
Warm accent colors: amber/gold (#F4A261) for primary actions and in-tune states,
coral red (#E76F51) for sharp/flat indicators,
soft cream (#F5F0E8) for text.
Subtle gradients, no flat colors. Rounded corners (16px).
Typography: clean sans-serif for labels, monospace for frequency numbers.
Minimal decorative elements — let the instrument and gauge be the visual focus.
Feel: like a high-end analog tuner meets modern digital interface.
No neon, no sci-fi — warm, musical, tactile.
```

---

## EKRAN 1: ANA TUNER

```
Design a mobile chromatic tuner screen for a professional music tuning app called "Nağme".

[STİL TANIMLAMASINI BURAYA YAPIŞTIR]

Layout (top to bottom):
1. TOP BAR: App name "Nağme" left-aligned, settings gear icon right.
   Below it: currently selected instrument as a pill/chip (e.g. "Keman" with a small violin icon).

2. NOTE DISPLAY (center, dominant):
   - Very large note letter (e.g. "A") with octave number small next to it (e.g. "4")
   - Below: frequency in Hz with monospace font (e.g. "440.0 Hz")
   - The note letter should glow amber/gold when in tune

3. CENTS GAUGE (below note):
   - Semi-circular or arc gauge from -50 to +50 cents
   - Center mark clearly visible
   - Animated needle pointing to current cents offset
   - Left side label: "♭" (flat), right side: "♯" (sharp), center: "✓"
   - When in tune (±5 cents): gauge fills with warm amber glow
   - When flat: needle area tints coral/red
   - When sharp: needle area tints coral/red

4. INSTRUMENT STRINGS (below gauge):
   - Horizontal row of circles/dots representing the instrument's strings
   - For violin: 4 circles labeled G, D, A, E
   - Active/closest string highlighted with amber fill
   - Other strings dimmed but visible

5. WAVEFORM (small, bottom area):
   - Thin waveform visualization showing the audio input
   - Subtle, not dominant — amber colored line on dark background

6. BOTTOM ACTION:
   - Large circular "Start/Stop" button (mic icon when idle, stop icon when active)
   - Warm amber gradient when active, dark outline when idle

Mobile layout, dark theme, 390x844 (iPhone 14 size).
Make it feel like a premium analog instrument, not a tech gadget.
```

---

## EKRAN 2: ENSTRÜMAN SEÇİMİ

```
Design an instrument selection screen for a music tuning app called "Nağme".

[STİL TANIMLAMASINI BURAYA YAPIŞTIR]

Layout:
1. TOP: Back arrow + title "Enstrüman Seç" (Turkish for "Select Instrument")

2. SEARCH BAR: Rounded, subtle, placeholder "Ara..." (Search)

3. INSTRUMENT GRID/LIST: Cards for each instrument:
   - Each card has: instrument icon/illustration, instrument name in Turkish,
     string count badge (e.g. "4 tel"), standard tuning preview (e.g. "G D A E")
   - Cards have subtle dark surface background with warm border on hover/select
   - Currently selected instrument has amber border + checkmark

   Instruments to show:
   - Keman (Violin) — 4 tel
   - Gitar (Guitar) — 6 tel
   - Bas Gitar (Bass Guitar) — 4 tel
   - Ukulele — 4 tel
   - Bağlama (Saz) — 7 tel
   - Ud (Oud) — 11 tel
   - Viyola (Viola) — 4 tel
   - Çello (Cello) — 4 tel
   - Kromatik (Chromatic) — all notes, no specific strings

4. BOTTOM: "Onayla" (Confirm) button, amber gradient, full width.

Use a 2-column grid for the instrument cards.
Mobile layout, dark theme.
```

---

## EKRAN 3: AYARLAR

```
Design a settings screen for a music tuning app called "Nağme".

[STİL TANIMLAMASINI BURAYA YAPIŞTIR]

Layout:
1. TOP: Back arrow + title "Ayarlar" (Settings)

2. SECTIONS with grouped settings:

   Section "Akort" (Tuning):
   - Reference pitch A4: stepper control showing "440 Hz" with -/+ buttons (range 415-466)
   - Sensitivity: slider from "Düşük" (Low) to "Yüksek" (High)
   - In-tune threshold: "±3 / ±5 / ±10 cents" segmented control

   Section "Görünüm" (Appearance):
   - Theme: "Koyu" (Dark) / "Açık" (Light) toggle — dark is default
   - Notation: "Do Re Mi" / "C D E" toggle — for solfege vs letter notation

   Section "Ses" (Sound):
   - Tuning sound: toggle on/off (play reference tone when tapping a string)
   - Sound type: "Sinüs" (Sine) / "Piyano" (Piano)

   Section "Hakkında" (About):
   - Version: "1.0.0"
   - "Geri Bildirim Gönder" (Send Feedback) link
   - "Değerlendir" (Rate) link

Each section has a subtle divider. Settings items have the label on the left
and the control on the right. Dark cards with rounded corners for each section.
Mobile layout, dark theme.
```

---

## PROTOTYPE AKIŞI

Stitch'te prototype oluştururken:

```
Ana Tuner → (enstrüman chip'ine tıkla) → Enstrüman Seçimi → (onayla) → Ana Tuner
Ana Tuner → (settings icon) → Ayarlar → (back) → Ana Tuner
```

---

## EXPORT SONRASI

Stitch'ten HTML/CSS export al, bana (Claude'a) yükle.
Ben Flutter widget'larına dönüştürürüm — renkleri, spacing'i, font'ları birebir koruyarak.
