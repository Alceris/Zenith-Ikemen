;Stand
[StateDef 0]
type = S
movetype = I
physics = N
anim = 0
sprpriority = 0

[State DestroySelf]
Type = DestroySelf
Trigger1 = IsHelper
ignorehitpause = 1

[State 0, CtrlSet]
type = CtrlSet
trigger1 = introstate != [1,2]
value = 1

[State ChangeAnim]
type = ChangeAnim
trigger1 = anim != 0
value = 0

[State Vel Y 0]
type = VelSet
trigger1 = Time = 0
y = 0

[State Stop]
type = VelSet
trigger1 = time = 1
x = 0

[State Dead]
type = ChangeState
trigger1 = !alive
value = 5050

[StateDef 10]
type = C
movetype = I
physics = N
ctrl = 1
sprpriority = 0

[State 0, ChangeAnim]
type = ChangeAnim
trigger1 = anim != 10
value = 10

[State 0, MapSet]
type = MapSet
trigger1 = animelemtime(2) >= 0
map = "NoElectron"
value = 1

[State Stop]
type = VelSet
trigger1 = vel X
x = 0

[State Dead]
type = ChangeState
trigger1 = !alive
value = 5050

[State 0, ChangeState]
type = ChangeState
trigger1 = !AnimTime
value = 11
ctrl = 1

[StateDef 11]
type = C
movetype = I
physics = N
anim = 11
ctrl = 1
sprpriority = 0

[State 0, MapSet]
type = MapSet
trigger1 = 1
map = "NoElectron"
value = 1

[State Stop]
type = VelSet
trigger1 = vel X
x = 0

[State Dead]
type = ChangeState
trigger1 = !alive
value = 5050

[StateDef 12]
type = S
movetype = I
physics = S
anim = 12
ctrl = 1
sprpriority = 0

[State 0, MapSet]
type = MapSet
trigger1 = animelemno(0) = 2
map = "NoElectron"
value = 1

[State Stop]
type = VelSet
trigger1 = vel X
x = 0

[State Dead]
type = ChangeState
trigger1 = !alive
value = 5050

[State 0, ChangeState]
type = ChangeState
trigger1 = !AnimTime
value = 0
ctrl = 1

[StateDef 40]
type = S
movetype = I
physics = N
velset = 0,0
anim = 40
ctrl = 0
sprpriority = 0

[State 0, NotHitBy]
type = NotHitBy
trigger1 = 1
value = ,AT
time = 1

[State 40, 1]
type = VarSet
trigger1 = !time
sysvar(1) = 0

[State 40, 2]
type = VarSet
triggerall = !time
trigger1 = command = "holdright"
trigger1 = command != "holdleft"
trigger1 = facing = 1
trigger2 = command != "holdright"
trigger2 = command = "holdleft"
trigger2 = facing = -1
sysvar(1) = 1

[State 40, 3]
type = VarSet
triggerall = !time
trigger1 = command = "holdright"
trigger1 = command != "holdleft"
trigger1 = facing = -1
trigger2 = command != "holdright"
trigger2 = command = "holdleft"
trigger2 = facing = 1
sysvar(1) = 2

[State 40, 4]
type = VelSet
trigger1 = !AnimTime
x = ifelse(sysvar(1)=0, const(velocity.jump.neu.x), ifelse(sysvar(1)=1, const(velocity.jump.fwd.x), const(velocity.jump.back.x)))
y = const(velocity.jump.y)

[State Dead]
type = ChangeState
trigger1 = !alive
value = 5050

[State 0, VarSet]
type = VarSet
trigger1 = !AnimTime
sysfvar(35) = const(movement.yaccel)

[State 0, ChangeState]
type = ChangeState
trigger1 = !AnimTime
value = 50
anim = 41+sysvar(1)
ctrl = 0

[StateDef 50]
type = A
movetype = I
physics = N
sprpriority = 0

[State 0, CtrlSet]
type = CtrlSet
trigger1 = time = 1
value = 1

[State 50, ChangeAnim]
type = ChangeAnim
trigger1 = anim != [41,46]
value = ifelse(vel Y >= const(movement.yaccel)*-14.0,44,ifelse(vel X < 0,43,ifelse(vel X > 0,42,41)))
elem = ifelse(vel Y < const(movement.yaccel)*-14.0,1,5)

[State Dead]
type = ChangeState
trigger1 = !alive
value = 5050

[State 0, ChangeState]
type = ChangeState
trigger1 = pos Y >= 0
trigger1 = vel Y = 0
trigger1 = statetype = A
value = 52
ctrl = 1

[State 0, VelAdd]
type = VelAdd
trigger1 = 1
y = sysfvar(35)

[State 0, PosSet]
type = PosSet
trigger1 = pos Y + vel Y >= 0
y = 0

[State 0, VelSet]
type = VelSet
trigger1 = pos Y + vel Y >= 0
y = 0

[StateDef 52]
type = S
movetype = I
physics = N
anim = 47
poweradd = 0
ctrl = 1
sprpriority = 0

[State -1, Turn]
type = Turn
trigger1 = p2dist X < 0

[State 0, PlaySnd]
type = PlaySnd
trigger1 = !time
value = S52,0

[State 0, VelSet]
type = VelSet
trigger1 = !time
y = 0
x = 0

[State 0, PosSet]
type = PosSet
trigger1 = !time
y = 0

[State Dead]
type = ChangeState
trigger1 = !alive
value = 5050

[State 0, ChangeState]
type = ChangeState
trigger1 = !AnimTime
value = 0
ctrl = 1
