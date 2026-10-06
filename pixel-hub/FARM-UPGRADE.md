# Loot To Forge — fast ore collection

## Behavior

- Auto Collect Ore has one persistent dedicated worker instead of running in the general scheduler. Its requested period is 40 ms, with no catch-up burst. Actual round time still includes server response time and completing the current batch.
- `FarmWorkers` supports 1–32 concurrent ore pickups, default 24. Concurrency is capped by the number of pending UUIDs. Saved worker preferences remain intact: older configurations may still select 4.
- New `FarmAllOres` defaults to true. It bypasses the rarity filter for auto collection. Turning it off restores the existing filter. Internal targeted collection callers retain their explicit filters.
- Each ore is assigned to one worker. Errors and explicit false responses retry that UUID up to three times, with 40/80 ms retry waits. One failing UUID no longer stops other workers from trying the remaining ore.
- Unfinished batches survive pickup errors, final-claim errors and toggle cancellation. Subsequent collection calls finish the pending batch before opening another stage. Successful UUIDs are not re-requested.
- Final claim is sent only after all selected pickups have returned without outstanding detected errors. Disable/unload prevents new pickups and final claim; pending calls must return before ownership is released.
- Farm, Max Gear and Auto Index coordinate using the existing exclusive-job lock. Stone farming finishes an existing pending ore batch first. Auto click remains 1–25 CPS, with its previous typing/respawn behavior.

The existing game remotes and public URL are unchanged. The collector retains compatibility with nil-returning pickup APIs; nil is not treated as a rejection. FireServer stone pickups/final claim have no server acknowledgement in this API, so their receipt cannot be verified locally.

## Verification

- Luau compilation passed.
- 21 coroutine checks passed: default 24 and capped 32 workers, complete pickup queues, filters, rejection isolation, per-UUID retry, unfinished-batch resumption, claim failures, cancellation, sequential fallback, malformed responses, exclusive locks, collect-all, duplicate-toggle prevention and unload.
- 25 existing click/scheduler/training/reconnect checks and forge regression checks passed.

No Roblox server/executor runtime is available here. Real throughput, server throttling, remote response formats and loot expiry have not been measured. A hung InvokeServer cannot safely be cancelled or replaced with a new batch.
