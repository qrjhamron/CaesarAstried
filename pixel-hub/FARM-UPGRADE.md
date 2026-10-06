# Loot To Forge — rarity-first collection

- Auto Collect Ore always follows `CollectRarities`. The bypass option has been removed. Old saved `FarmAllOres` entries are ignored because that option no longer exists.
- Ore IDs and rarity levels accept numeric/string forms. Filter names accept case/whitespace differences. Unknown rarity retains the original drop batch and reports an error instead of silently skipping that ore.
- Selected ore is ordered by rarity level, highest first. Worker range remains 1–32, default 24. Saved worker settings are preserved.
- Successful farm rounds have no additional configured inter-round pause; the next round starts on the next available task tick. A BindableEvent wakes the collector as soon as the final worker finishes instead of polling for completion. Server response time still limits throughput.
- Pickup errors/explicit false responses retry the affected UUID up to three times with 20/40 ms waits. Successful UUIDs are not retried. Failed batches remain pending; final claim is withheld on detected errors. Disabling/unloading stops subsequent work and waits for in-flight calls.
- An internal collector resuming a filtered batch cannot broaden its saved filter. Empty rarity selections pause auto farming. Farm/gear/index retain exclusive coordination.
- Notifications cover start/pause, delayed selected-ore pickups, recovered batches and feature errors. Retry notices are limited to one warning per failure/recovery cycle.

## PixeL UI defaults and persistence

- Library default scale is 80%. Loot To Forge explicitly starts in English at 80%. Saved language/scale choices are restored; consumer-specified options can override defaults.
- Autosave is enabled by default after window controls are built (`AutoSave=false` opts out). On first use it saves `default` and establishes autoload automatically. Existing autoload profiles are restored first.
- Filters/rates/preferences load before feature toggles. Saved changes are debounced for 350 ms, failed writes retry every 5 seconds, and pending changes flush before unload cleanup turns features off. Transient/NoSave fields are excluded.
- Autosave status/failure notifications are provided. Executors without file APIs receive a warning; no persistent-save claim is made. Unreadable JSON or failed deserialization prevents autosave from replacing that profile.
- Public library APIs and URLs remain compatible. `Library:StartAutoSave(name)` is available for consumers that build controls after normal initialization.

## Checks and limits

Luau compilation passed for both scripts. 28 farm checks, 25 existing logic checks, 22 autosave checks, forge regression checks and shared-UI layout/animation/localization mock checks passed.

No Roblox/executor runtime is available here. Real throughput, throttling and loot expiry remain unmeasured. The collector accepts nil-returning pickup APIs for compatibility; only errors and explicit false are known rejection signals. FireServer stone/final-claim calls have no receipt acknowledgement. Pending InvokeServer calls cannot safely be cancelled.
