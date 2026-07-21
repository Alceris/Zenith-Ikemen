[StateDef 513]
type = A
movetype = I
physics = N
velset = 0,0
anim = 512
ctrl = 0
sprpriority = 3

[State 0, VarSet]
type = VarSet
trigger1 = !time
fvar(0) = 1.0+randomrange(0,100)*0.04

[State 0, VarSet]
type = VarSet
trigger1 = !time
fvar(1) = random*(pi/499.5)

[State 0, VarSet]
type = VarSet
trigger1 = !time
fvar(2) = randomrange(100,1000)*0.015

[State 0, Explod]
type = Explod
trigger1 = !time
anim = 513
ID = 513
pos = 0,0
postype = p1  ;p2,front,back,left,right
facing = 1
vfacing = 1
bindtime = 0
vel = fvar(2)*sin(fvar(1)),fvar(2)*cos(fvar(1))*1.5
friction = 0.9,0.9
removetime = 31
pausemovetime = 0
scale = const(size.xscale)*fvar(0),const(size.yscale)*fvar(0)
palfx.time = -1
palfx.mul = 256,256,256
trans = add
alpha = 256,256
interpolation.time = 31
interpolation.alpha = 0,256
interpolation.palfx.mul = 256,0,0
sprpriority = 5
ontop = 0
shadow = 0,0,0
reflection = 1
shader = "trans_rights"
shadertime = -1
ownpal = 1
removeongethit = 0
ignorehitpause = 1

[State 0, VarAdd]
type = VarAdd
trigger1 = !time
var(0) = 1

[State 0, ChangeState]
type = ChangeState
trigger1 = !time
trigger1 = var(0) < 12
value = 513
ctrl = 0

[State 511, ShaderSet]
type = ShaderSet
trigger1 = shader != "trans_rights"
shader = "trans_rights"
time = -1
ignorehitpause = 1

[State 0, VarSet]
type = VarSet
trigger1 = !time
trigger2 = animelem = 3
trigger3 = !animtime
fvar(0) = ifelse(animelemtime(3) = 0,0.78125,1)

[State 0, VarSet]
type = VarSet
trigger1 = !time
fvar(1) = 1

[State 0, VarAdd]
type = VarAdd
trigger1 = time >= 10
fvar(1) = -1.0/27.0

[State 0, VarSet]
type = VarSet
trigger1 = time = 1
fvar(2) = 1

[State 0, VarSet]
type = VarSet
trigger1 = time = 1
fvar(3) = .3

[State 0, AngleDraw]
type = AngleDraw
trigger1 = time
value = 0
yangle = 70
scale = fvar(2),fvar(2)

[State 0, VarAdd]
type = VarAdd
trigger1 = time
fvar(2) = fvar(3)

[State 0, VarSet]
type = VarSet
trigger1 = time
fvar(3) = fvar(3)*.9

[State 0, Trans]
type = Trans
trigger1 = time >= 10
trans = add
alpha = floor(256*fvar(1)),256

[State 0, PalFX]
type = PalFX
trigger1 = 1
time = 1
mul = 256,floor(256*fvar(0)*fvar(1)),floor(256*fvar(0)*fvar(1))

[State 0, DestroySelf]
type = DestroySelf
trigger1 = time = 37
