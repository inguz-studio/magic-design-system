# UI/UX Pro Max — 99 Guidelines (Imported)

**Status:** Adotado como referencia (Round 5)
**Consumido por:** `mds-ux` (futuro), opcionalmente `mds-ui` cross-reference
**Origem:** ui-ux-pro-max-skill (nextlevelbuilder)
**Atribuicao:** https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
**Importado em:** 2026-05-18 (Round 5)

---

## 0. Como usar este arquivo

Este e um **knowledge base** de 99 guidelines UX organizados em 18 categorias. `mds-ux` consulta como **uma das fontes** durante:

- `*heuristic-audit` (alem de Nielsen 10)
- `*design-critique` (referencia qualitativa)
- `*anti-patterns` (detection)
- Outras tasks que precisem de regra documentada

**Nao substitui Nielsen Heuristics nem UX Laws checklist.** Adiciona granularidade pratica.

## 0.1 Severity mapping

Severity declarada na fonte: `High` / `Medium` / `Low`.

Mapping pro vocabulario do squad:
- High → **error** (bloqueia ops em design-check C/D)
- Medium → **warning** (reporta, nao bloqueia)
- Low → **info** (stats)

---

## Categoria: Navigation

### 1. Smooth Scroll [Web, Medium]
**Issue:** Anchor links should scroll smoothly to target section.
**Do:** Use `scroll-behavior: smooth` on html element.
**Don't:** Jump directly without transition.
**Code good:** `html { scroll-behavior: smooth; }`
**Code bad:** `<a href='#section'>` without CSS

### 2. Sticky Navigation [Web, Medium]
**Issue:** Fixed nav should not obscure content.
**Do:** Add padding-top to body equal to nav height.
**Don't:** Let nav overlap first section content.

### 3. Active State [All, Medium]
**Issue:** Current page/section should be visually indicated.
**Do:** Highlight active nav item with color/underline.
**Don't:** No visual feedback on current location.

### 4. Back Button [Mobile, High]
**Issue:** Users expect back to work predictably.
**Do:** Preserve navigation history properly (`history.pushState()`).
**Don't:** Break browser/app back button behavior.

### 5. Deep Linking [All, Medium]
**Issue:** URLs should reflect current state for sharing.
**Do:** Update URL on state/view changes (query params or hash).
**Don't:** Static URLs for dynamic content.

### 6. Breadcrumbs [Web, Low]
**Issue:** Show user location in site hierarchy.
**Do:** Use for sites with 3+ levels of depth.
**Don't:** Use for flat single-level sites.

---

## Categoria: Animation

### 7. Excessive Motion [All, High]
**Issue:** Too many animations cause distraction and motion sickness.
**Do:** Animate 1-2 key elements per view maximum.
**Don't:** Animate everything that moves.

### 8. Duration Timing [All, Medium]
**Issue:** Animations should feel responsive not sluggish.
**Do:** Use 150-300ms for micro-interactions.
**Don't:** Use animations longer than 500ms for UI.

### 9. Reduced Motion [All, High]
**Issue:** Respect user's motion preferences.
**Do:** Check `prefers-reduced-motion` media query.
**Don't:** Ignore accessibility motion settings.

### 10. Loading States [All, High]
**Issue:** Show feedback during async operations.
**Do:** Use skeleton screens or spinners.
**Don't:** Leave UI frozen with no feedback.

### 11. Hover vs Tap [All, High]
**Issue:** Hover effects don't work on touch devices.
**Do:** Use click/tap for primary interactions.
**Don't:** Rely only on hover for important actions.

### 12. Continuous Animation [All, Medium]
**Issue:** Infinite animations are distracting.
**Do:** Use for loading indicators only.
**Don't:** Use for decorative elements.

### 13. Transform Performance [Web, Medium]
**Issue:** Some CSS properties trigger expensive repaints.
**Do:** Use `transform` and `opacity` for animations.
**Don't:** Animate width/height/top/left properties.

### 14. Easing Functions [All, Low]
**Issue:** Linear motion feels robotic.
**Do:** Use ease-out for entering, ease-in for exiting.
**Don't:** Use linear for UI transitions.

---

## Categoria: Layout

### 15. Z-Index Management [Web, High]
**Issue:** Stacking context conflicts cause hidden elements.
**Do:** Define z-index scale system (10, 20, 30, 50).
**Don't:** Use arbitrary large z-index values like 9999.

### 16. Overflow Hidden [Web, Medium]
**Issue:** Hidden overflow can clip important content.
**Do:** Test all content fits within containers.
**Don't:** Blindly apply `overflow-hidden`.

### 17. Fixed Positioning [Web, Medium]
**Issue:** Fixed elements can overlap or be inaccessible.
**Do:** Account for safe areas and other fixed elements.
**Don't:** Stack multiple fixed elements carelessly.

### 18. Stacking Context [Web, Medium]
**Issue:** New stacking contexts reset z-index.
**Do:** Understand what creates new stacking context.
**Don't:** Expect z-index to work across contexts.

### 19. Content Jumping [Web, High]
**Issue:** Layout shift when content loads is jarring.
**Do:** Reserve space for async content (`aspect-ratio` or fixed height).
**Don't:** Let images/content push layout around.

### 20. Viewport Units [Web, Medium]
**Issue:** 100vh can be problematic on mobile browsers.
**Do:** Use `dvh` or account for mobile browser chrome.
**Don't:** Use `100vh` for full-screen mobile layouts.

### 21. Container Width [Web, Medium]
**Issue:** Content too wide is hard to read.
**Do:** Limit max-width for text content (65-75ch).
**Don't:** Let text span full viewport width.

---

## Categoria: Touch

### 22. Touch Target Size [Mobile, High]
**Issue:** Small buttons are hard to tap accurately.
**Do:** Minimum 44x44px touch targets.
**Don't:** Tiny clickable areas.

### 23. Touch Spacing [Mobile, Medium]
**Issue:** Adjacent touch targets need adequate spacing.
**Do:** Minimum 8px gap between touch targets.
**Don't:** Tightly packed clickable elements.

### 24. Gesture Conflicts [Mobile, Medium]
**Issue:** Custom gestures can conflict with system.
**Do:** Avoid horizontal swipe on main content.
**Don't:** Override system gestures.

### 25. Tap Delay [Mobile, Medium]
**Issue:** 300ms tap delay feels laggy.
**Do:** Use `touch-action: manipulation`.
**Don't:** Default mobile tap handling.

### 26. Pull to Refresh [Mobile, Low]
**Issue:** Accidental refresh is frustrating.
**Do:** Disable where not needed (`overscroll-behavior: contain`).
**Don't:** Enable by default everywhere.

### 27. Haptic Feedback [Mobile, Low]
**Issue:** Tactile feedback improves interaction feel.
**Do:** Use for confirmations and important actions.
**Don't:** Overuse vibration feedback.

---

## Categoria: Interaction

### 28. Focus States [All, High]
**Issue:** Keyboard users need visible focus indicators.
**Do:** Use visible focus rings on interactive elements (`focus:ring-2`).
**Don't:** Remove focus outline without replacement.
**Cross-ref:** UI-PD-3 em `ui-pre-delivery-checklist.md`

### 29. Hover States [Web, Medium]
**Issue:** Visual feedback on interactive elements.
**Do:** Change cursor and add subtle visual change.
**Don't:** No hover feedback on clickable elements.

### 30. Active States [All, Medium]
**Issue:** Show immediate feedback on press/click.
**Do:** Add pressed/active state visual change (`active:scale-95`).
**Don't:** No feedback during interaction.

### 31. Disabled States [All, Medium]
**Issue:** Clearly indicate non-interactive elements.
**Do:** Reduce opacity and change cursor (`opacity-50 cursor-not-allowed`).
**Don't:** Confuse disabled with normal state.

### 32. Loading Buttons [All, High]
**Issue:** Prevent double submission during async actions.
**Do:** Disable button and show loading state.
**Don't:** Allow multiple clicks during processing.

### 33. Error Feedback [All, High]
**Issue:** Users need to know when something fails.
**Do:** Show clear error messages near problem.
**Don't:** Silent failures with no feedback.

### 34. Success Feedback [All, Medium]
**Issue:** Confirm successful actions to users.
**Do:** Show success message or visual change (toast/checkmark).
**Don't:** No confirmation of completed action.

### 35. Confirmation Dialogs [All, High]
**Issue:** Prevent accidental destructive actions.
**Do:** Confirm before delete/irreversible actions.
**Don't:** Delete without confirmation.

---

## Categoria: Accessibility

### 36. Color Contrast [All, High]
**Issue:** Text must be readable against background.
**Do:** Minimum 4.5:1 ratio for normal text (WCAG AA).
**Don't:** Low contrast text.

### 37. Color Only [All, High]
**Issue:** Don't convey information by color alone.
**Do:** Use icons/text in addition to color.
**Don't:** Red/green only for error/success.

### 38. Alt Text [All, High]
**Issue:** Images need text alternatives.
**Do:** Descriptive alt text for meaningful images.
**Don't:** Empty or missing alt attributes.

### 39. Heading Hierarchy [Web, Medium]
**Issue:** Screen readers use headings for navigation.
**Do:** Use sequential heading levels h1-h6.
**Don't:** Skip heading levels or misuse for styling.

### 40. ARIA Labels [All, High]
**Issue:** Interactive elements need accessible names.
**Do:** Add `aria-label` for icon-only buttons.
**Don't:** Icon buttons without labels.

### 41. Keyboard Navigation [Web, High]
**Issue:** All functionality accessible via keyboard.
**Do:** Tab order matches visual order.
**Don't:** Keyboard traps or illogical tab order.

### 42. Screen Reader [All, Medium]
**Issue:** Content should make sense when read aloud.
**Do:** Use semantic HTML and ARIA properly (`<nav>`, `<main>`, `<article>`).
**Don't:** Div soup with no semantics.

### 43. Form Labels [All, High]
**Issue:** Inputs must have associated labels.
**Do:** Use `<label for="...">` or wrap input.
**Don't:** Placeholder-only inputs.

### 44. Error Messages [All, High]
**Issue:** Error messages must be announced.
**Do:** Use `aria-live` or `role="alert"` for errors.
**Don't:** Visual-only error indication.

### 45. Skip Links [Web, Medium]
**Issue:** Allow keyboard users to skip navigation.
**Do:** Provide "Skip to main content" link.
**Don't:** No skip link on nav-heavy pages.

---

## Categoria: Performance

### 46. Image Optimization [All, High]
**Issue:** Large images slow page load.
**Do:** Use appropriate size and format (WebP), `srcset`.
**Don't:** Unoptimized full-size images.

### 47. Lazy Loading [All, Medium]
**Issue:** Load content as needed.
**Do:** Lazy load below-fold images and content (`loading="lazy"`).
**Don't:** Load everything upfront.

### 48. Code Splitting [Web, Medium]
**Issue:** Large bundles slow initial load.
**Do:** Split code by route/feature (`dynamic import()`).
**Don't:** Single large bundle.

### 49. Caching [Web, Medium]
**Issue:** Repeat visits should be fast.
**Do:** Set appropriate cache headers.
**Don't:** No caching strategy.

### 50. Font Loading [Web, Medium]
**Issue:** Web fonts can block rendering.
**Do:** Use `font-display: swap` or `optional`.
**Don't:** Invisible text during font load (FOIT).
**Cross-ref:** UI-PD-2 em `ui-pre-delivery-checklist.md`

### 51. Third Party Scripts [Web, Medium]
**Issue:** External scripts can block rendering.
**Do:** Load non-critical scripts `async` or `defer`.
**Don't:** Synchronous third-party scripts.

### 52. Bundle Size [Web, Medium]
**Issue:** Large JavaScript slows interaction.
**Do:** Monitor and minimize bundle size.
**Don't:** Ignore bundle size growth.

### 53. Render Blocking [Web, Medium]
**Issue:** CSS/JS can block first paint.
**Do:** Inline critical CSS, defer non-critical.
**Don't:** Large blocking CSS files.

---

## Categoria: Forms

### 54. Input Labels [All, High]
**Issue:** Every input needs a visible label.
**Do:** Always show label above or beside input.
**Don't:** Placeholder as only label.

### 55. Error Placement [All, Medium]
**Issue:** Errors should appear near the problem.
**Do:** Show error below related input.
**Don't:** Single error message at top of form.

### 56. Inline Validation [All, Medium]
**Issue:** Validate as user types or on blur.
**Do:** Validate on blur for most fields.
**Don't:** Validate only on submit.

### 57. Input Types [All, Medium]
**Issue:** Use appropriate input types.
**Do:** `type="email"`, `type="tel"`, `type="number"`, etc.
**Don't:** Text input for everything.

### 58. Autofill Support [Web, Medium]
**Issue:** Help browsers autofill correctly.
**Do:** Use `autocomplete` attribute properly.
**Don't:** Block or ignore autofill.

### 59. Required Indicators [All, Medium]
**Issue:** Mark required fields clearly.
**Do:** Use asterisk or "(required)" text.
**Don't:** No indication of required fields.

### 60. Password Visibility [All, Medium]
**Issue:** Let users see password while typing.
**Do:** Toggle to show/hide password.
**Don't:** Password always hidden.

### 61. Submit Feedback [All, High]
**Issue:** Confirm form submission status.
**Do:** Show loading then success/error state.
**Don't:** No feedback after submit.

### 62. Input Affordance [All, Medium]
**Issue:** Inputs should look interactive.
**Do:** Use distinct input styling (border/background).
**Don't:** Inputs that look like plain text.

### 63. Mobile Keyboards [Mobile, Medium]
**Issue:** Show appropriate keyboard for input type.
**Do:** Use `inputmode` attribute (`inputmode="numeric"`).
**Don't:** Default keyboard for all inputs.

---

## Categoria: Responsive

### 64. Mobile First [Web, Medium]
**Issue:** Design for mobile then enhance for larger.
**Do:** Start with mobile styles then add breakpoints (`md:`, `lg:`, `xl:`).
**Don't:** Desktop-first causing mobile issues.

### 65. Breakpoint Testing [Web, Medium]
**Issue:** Test at all common screen sizes.
**Do:** Test at 320, 375, 414, 768, 1024, 1440.
**Don't:** Only test on your device.

### 66. Touch Friendly [Web, High]
**Issue:** Mobile layouts need touch-sized targets.
**Do:** Increase touch targets on mobile.
**Don't:** Same tiny buttons on mobile.

### 67. Readable Font Size [All, High]
**Issue:** Text must be readable on all devices.
**Do:** Minimum 16px body text on mobile.
**Don't:** Tiny text on mobile.

### 68. Viewport Meta [Web, High]
**Issue:** Set viewport for mobile devices.
**Do:** `<meta name="viewport" content="width=device-width, initial-scale=1">`.
**Don't:** Missing or incorrect viewport.

### 69. Horizontal Scroll [Web, High]
**Issue:** Avoid horizontal scrolling.
**Do:** Ensure content fits viewport width.
**Don't:** Content wider than viewport.

### 70. Image Scaling [Web, Medium]
**Issue:** Images should scale with container.
**Do:** Use `max-width: 100%; height: auto`.
**Don't:** Fixed width images overflow.

### 71. Table Handling [Web, Medium]
**Issue:** Tables can overflow on mobile.
**Do:** Use horizontal scroll wrapper or card layout.
**Don't:** Wide tables breaking layout.

---

## Categoria: Typography

### 72. Line Height [All, Medium]
**Issue:** Adequate line height improves readability.
**Do:** Use 1.5-1.75 for body text.
**Don't:** Cramped or excessive line height.

### 73. Line Length [Web, Medium]
**Issue:** Long lines are hard to read.
**Do:** Limit to 65-75 characters per line (`max-w-prose`).
**Don't:** Full-width text on large screens.

### 74. Font Size Scale [All, Medium]
**Issue:** Consistent type hierarchy aids scanning.
**Do:** Use consistent modular scale.
**Don't:** Random font sizes.

### 75. Font Loading [Web, Medium]
**Issue:** Fonts should load without layout shift.
**Do:** Reserve space with fallback font similar in metrics.
**Don't:** Layout shift when fonts load.

### 76. Contrast Readability [All, High]
**Issue:** Body text needs good contrast.
**Do:** Use darker text on light backgrounds.
**Don't:** Gray text on gray background.

### 77. Heading Clarity [All, Medium]
**Issue:** Headings should stand out from body.
**Do:** Clear size/weight difference (bold + larger).
**Don't:** Headings similar to body text.

---

## Categoria: Feedback

### 78. Loading Indicators [All, High]
**Issue:** Show system status during waits.
**Do:** Show spinner/skeleton for operations > 300ms.
**Don't:** No feedback during loading.

### 79. Empty States [All, Medium]
**Issue:** Guide users when no content exists.
**Do:** Show helpful message and action ("No items yet. Create one!").
**Don't:** Blank empty screens.

### 80. Error Recovery [All, Medium]
**Issue:** Help users recover from errors.
**Do:** Provide clear next steps ("Try again" button + help link).
**Don't:** Error without recovery path.

### 81. Progress Indicators [All, Medium]
**Issue:** Show progress for multi-step processes.
**Do:** Step indicators or progress bar ("Step 2 of 4").
**Don't:** No indication of progress.

### 82. Toast Notifications [All, Medium]
**Issue:** Transient messages for non-critical info.
**Do:** Auto-dismiss after 3-5 seconds.
**Don't:** Toasts that never disappear.

### 83. Confirmation Messages [All, Medium]
**Issue:** Confirm successful actions.
**Do:** Brief success message (toast).
**Don't:** Silent success.

---

## Categoria: Content

### 84. Truncation [All, Medium]
**Issue:** Handle long content gracefully.
**Do:** Truncate with ellipsis and expand option (`line-clamp-2 with expand`).
**Don't:** Overflow or broken layout.

### 85. Date Formatting [All, Low]
**Issue:** Use locale-appropriate date formats.
**Do:** Use relative or locale-aware dates ("2 hours ago").
**Don't:** Ambiguous date formats ("01/02/03").

### 86. Number Formatting [All, Low]
**Issue:** Format large numbers for readability.
**Do:** Use thousand separators or abbreviations ("1.2K", "1,234").
**Don't:** Long unformatted numbers ("1234567").

### 87. Placeholder Content [All, Low]
**Issue:** Show realistic placeholders during dev.
**Do:** Use realistic sample data.
**Don't:** Lorem ipsum everywhere.

---

## Categoria: Onboarding

### 88. User Freedom [All, Medium]
**Issue:** Users should be able to skip tutorials.
**Do:** Provide Skip and Back buttons.
**Don't:** Force linear unskippable tour.

---

## Categoria: Search

### 89. Autocomplete [Web, Medium]
**Issue:** Help users find results faster.
**Do:** Show predictions as user types (debounced fetch + dropdown).
**Don't:** Require full type and enter.

### 90. No Results [Web, Medium]
**Issue:** Dead ends frustrate users.
**Do:** Show "No results" with suggestions ("Try searching for X instead").
**Don't:** Blank screen or "0 results".

---

## Categoria: Data Entry

### 91. Bulk Actions [Web, Low]
**Issue:** Editing one by one is tedious.
**Do:** Allow multi-select and bulk edit (checkbox column + action bar).
**Don't:** Single row actions only.

---

## Categoria: AI Interaction

### 92. Disclaimer [All, High]
**Issue:** Users need to know they talk to AI.
**Do:** Clearly label AI generated content ("AI Assistant").
**Don't:** Present AI as human.

### 93. Streaming [All, Medium]
**Issue:** Waiting for full text is slow.
**Do:** Stream text response token by token (typewriter effect).
**Don't:** Show loading spinner for 10s+.

### 98. Feedback Loop [All, Low]
**Issue:** AI needs user feedback to improve.
**Do:** Thumbs up/down or "Regenerate".
**Don't:** Static output only.

---

## Categoria: Spatial UI (VisionOS)

### 94. Gaze Hover [VisionOS, High]
**Issue:** Elements should respond to eye tracking before pinch.
**Do:** Scale/highlight element on look (`hoverEffect()`).
**Don't:** Static element until pinch.

### 95. Depth Layering [VisionOS, Medium]
**Issue:** UI needs Z-depth to separate content from environment.
**Do:** Use glass material and z-offset (`.glassBackgroundEffect()`).
**Don't:** Flat opaque panels blocking view.

---

## Categoria: Sustainability

### 96. Auto-Play Video [Web, Medium]
**Issue:** Video consumes massive data and energy.
**Do:** Click-to-play or pause when off-screen (`playsInline muted preload="none"`).
**Don't:** Auto-play high-res video loops.

### 97. Asset Weight [Web, Medium]
**Issue:** Heavy 3D/Image assets increase carbon footprint.
**Do:** Compress and lazy load 3D models (Draco compression).
**Don't:** Load 50MB textures.

### 99. Motion Sensitivity [All, High]
**Issue:** Parallax/Scroll-jacking causes nausea.
**Do:** Respect `prefers-reduced-motion`.
**Don't:** Force scroll effects.

---

## Resumo por categoria

| Categoria | Count | Severity dominante |
|---|---|---|
| Navigation | 6 | Medium |
| Animation | 8 | Medium/High |
| Layout | 7 | Medium |
| Touch | 6 | Medium |
| Interaction | 8 | High |
| Accessibility | 10 | High |
| Performance | 8 | Medium |
| Forms | 10 | Medium/High |
| Responsive | 8 | Medium/High |
| Typography | 6 | Medium |
| Feedback | 6 | Medium |
| Content | 4 | Low |
| Onboarding | 1 | Medium |
| Search | 2 | Medium |
| Data Entry | 1 | Low |
| AI Interaction | 3 | High/Medium |
| Spatial UI | 2 | Mixed |
| Sustainability | 3 | Medium/High |
| **Total** | **99** | — |

---

## Como consultar (uso operacional)

### Pra cada audit do mds-ux:
1. Identificar **categoria(s) relevante(s)** pro artefato auditado (ex: form → Forms + Accessibility)
2. Pegar guidelines daquela categoria
3. Cruzar com Nielsen Heuristics + UX Laws + anti-patterns
4. Output: relatorio cita qual guideline foi violada (atribuindo fonte)

### Heuristica de priorizacao:
- **High severity ausente** → bloqueia design-check em C/D
- **Medium severity ausente** → warning, nao bloqueia
- **Low severity ausente** → info, registrado mas sem flag

### Items que ja temos em nossos checklists nativos (nao duplicar):
- 8 (duration timing) ↔ nossos motion roles
- 9, 99 (reduced motion) ↔ nosso reduce-motion set
- 15 (z-index) ↔ nossos z roles
- 22 (touch 44px) ↔ nossa density coarse-pointer guard
- 36 (color contrast) ↔ nossos WCAG checks
- 50 (font loading) ↔ UI-PD-2 (ui-pre-delivery)
- 28 (focus states) ↔ UI-PD-3 (ui-pre-delivery)

Mais ~80 guidelines unicos da skill que **complementam** nossos checklists.

---

## Pendentes / Futuro

- Quando `mds-ux` for criado, este arquivo entra como `dependencies.checklists`
- Quando squad rodar em projeto Marketing/Sales, revisitar quais guidelines aplicam (ex: AI Interaction relevante pra LLM-driven products)
- Manutencao: re-sync com origem 1x/ano se upstream atualizar
