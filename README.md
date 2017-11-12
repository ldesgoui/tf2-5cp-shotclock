# TF2 5CP Shot Clock

Make round timers shorter based on point control, attribute points whenever these timers run out.

## Usage:

Put .smx file in tf/addons/sourcemod/scripting

## Commands:
```
sm_shotclock_version
# Amount of time alloted on a point before round ends
sm_shotclock_time_last 60
sm_shotclock_time_second 120
sm_shotclock_time_middle 305
# Amount of score a point will give you if round ends
sm_shotclock_score_last 4
sm_shotclock_score_second 2
sm_shotclock_score_middle 1
```

## Notes:
This does not do any map recognition, the code may run on non-5CP maps and therefor cause problems.
Unload it from sourcemod in those cases.
Thanks.
