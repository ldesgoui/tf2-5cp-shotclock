# TF2 5CP Shot Clock

Make round timers shorter based on point control, reward points for map control whenever these timers run out.

## Usage:

Put .smx file in tf/addons/sourcemod/scripting

## Commands:
```
sm_shotclock_version
sm_shotclock 1
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
Disable it using `sm_shotclock 0` in those cases.
Thanks.

## 6v6

This modification was created with the idea of adressing a few common issues with 5CP.
I don't pretend they are the best changes you could wish for, nor do I pretend to fully understand the complexity of the 5CP gamemode as a whole.
Those changes are offered as-is, as a way of discovering new ways to play the game and experiment.
Here are some counter-arguments:

### Complexity:

- Competitive 6v6 Team Fortress 2 is already complex, adding more rules on top of a feature-rich game might confuse new players.
To that I can only agree but promise that the concept is easy to understand; the concept of timers are not hard to grasp: most gamemodes use them. The other feature of the mod can easily be explained in a few words: "Map control is rewarded". The concepts of breaking long stalemates do not require explanation to a new eye. If you wan't everyone to understand what's going on, either TF2 needs to be dumbed down, or better explanations need to be given to newer players, hopefully by VALVe.

### Low risk play:

- After a team (say RED) has acquired enough points, they can ride their advantage out by forcing stalemates after every mid fight and only losing advantage one point at a time.
I do not feel this is a massive issue, forcing a stalemate is not fool-proof, the BLU team would have multiple chances to outplay RED over the remaining time. If they do not manage to, they're clearly the lesser team.

### Punishment when failing an attack from Mid to Enemy Second

- Failing a push of this type completely would allow for the enemy team to push back Middle and 2nd for little to no risk. The net worth of this transaction is -3 for the previously attacking team (-1 for losing control of middle, -2 for losing control of 2nd). Compared to original 5CP, this is a big change and might force slower play altogether.


### An insentive to push out of last was created, but it's not easier.

### Time constraints add to the mind play: Deciding to push from 2nd to Last

### Backcaps are even more powerful

### Changes might positively affect League/Tournament play but might not be enjoyable for lobbies/pick-up games
