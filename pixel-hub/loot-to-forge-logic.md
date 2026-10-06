# Loot To Forge — logic upgrade, 6 October 2026

Only Loot To Forge changes in this release. Ride A Pet and the shared UI library are unchanged.

## Fixed

- **Auto click:** one persistent worker per feature, including rapid off/on toggles. Requested rate is configurable from 1–10 CPS, default 6. It pauses while typing when enabled, skips dead/missing characters, resumes after respawn, and does not issue a catch-up burst after a delayed frame. It still calls the game's existing TrainOnce API; the game's own cooldown determines accepted training clicks.
- **Kill Aura:** uses the same single-worker lifecycle. A missing enemy folder is treated as a temporary absence rather than an error that disables the feature.
- **Scheduler:** escaped job errors retry with exponential backoff from 0.25 to 2 seconds. Success clears the failure streak. Persistent errors still disable the feature and queue one UI warning; re-enabling a toggle clears old retry state.
- **Training search:** accepts numeric or string area IDs and numeric/string bonus values, ignores malformed entries, sorts the best bonus first and handles string-valued acknowledgement attributes. Generation changes and unload cancel the search.
- **Auto reconnect:** repeated error signals share one timer. The timer rechecks whether the hub is alive, reconnect is enabled and the error still exists.
- **Race and coin loops:** stop initiating new iterations after unload. Race rolling refuses to consume rolls without a target.
- **Auto Index:** exclusive-job errors now reach the scheduler's failure policy; the exclusive lock is still released before reporting failure.

Existing option IDs, configs, forge behavior, game remotes, UI theme and URLs remain compatible. The new settings are `ClickRate` and `ClickPauseTyping`.

## Checks

Luau compilation; coroutine tests for click cadence, typing, respawn, rapid toggles, missed frames, retry timing, training ID sorting/cancellation, reconnect cancellation and unload; regression tests for confirmed forge results and rejected responses.

Roblox runtime is unavailable here. Actual server cooldowns, executor behavior and in-game throughput have not been measured. An already pending game call is not cancelled by turning a feature off; the guards stop subsequent work.
