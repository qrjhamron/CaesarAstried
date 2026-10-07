# PixeL UI 1.2 — Kingdom

Kingdom is the new default theme: charcoal stone, parchment text, aged gold accents and burgundy banners. Chunky tabs keep a consistent gold selection marker; header/page accents and controls share the same palette. The brand uses a small pixel crown.

The 7.5-second opening builds two crenellated towers, banners, masonry, a crown and a split gate. The gate opens outward at the Ready phase, after interface construction completes. Castle geometry fits inside the responsive opening card. Banner motion is finite and is omitted when Reduce Motion is enabled. The normal reduced-motion path skips the opening entirely.

Notifications use scroll, shield, crown and castle sprites, with a status ribbon and restrained motion. Success/warning/error colors remain distinct. Existing English/Indonesian/Thai notifications and autosave remain available.

Existing autoload profiles adopt Kingdom once using a saved `PixelKingdomRevision` marker. Later explicit theme choices remain saved. Other consumers that explicitly choose Field or another theme retain their specified theme. Loot To Forge now requests Kingdom and a crown emblem. Farm logic, API, 80% scale and English defaults are unchanged.

Verification: both scripts compile; shared-UI mocks check palette coverage, responsive layout, 7.5-second timing, castle construction, ready-only outward gate animation and reduced-motion behavior. Autosave tests include one-time theme migration and preservation of later theme choices. No live Roblox/executor rendering was available.
