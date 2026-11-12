# Saltline 引擎深度剖析（场景重建/画质升级/中文化手术路标）

> 剖析对象：`C:/Users/Administrator/Desktop/youxi/saltline-original/index.html`（6193 行，约 1.4 MB，单文件浏览器 FPS）。
> 本文档所有行号均在本次剖析会话中用 grep/awk/Read 实际核验，引用处附 1–2 行原文证据。
> 日期：2026-11-12。

---

## 0. 文件与行段总览

| 行段 | 内容 | 证据 |
|---|---|---|
| 1–6 | HTML head；Google Fonts（Big Shoulders Display / IBM Plex Mono / Barlow Condensed） | 行 5–6 `<link rel="preconnect" href="https://fonts.googleapis.com">` |
| 7–338 | 全部 CSS（`<style>` 行 7 … `</style>` 行 338） | 行 8 注释 `/* game/ui.css — owned by the Game agent. … Sections: tokens · page + boot · HUD · radio · touch controls · menus · panel · motion preferences. */` |
| 339–347 | HTML body：`#app > #view(canvas) + #ui + #boot` | 行 340 `<canvas id="view" tabindex="0"></canvas>`，行 344 `<div class="boot-sub" id="boot-msg">Raising the terminal</div>` |
| 348 / 6191 | `<script>` / `</script>` | 行 348 `<script>` |
| 349–4179 | **three.js r180 引擎包**（压缩 IIFE，349 行 134KB、388 行 238KB 为两大巨行） | 行 349 开头 `(()=>{var _M=Object.defineProperty;…br(lt,{ACESFilmicToneMapping:()=>xc,…AgXToneMapping:()=>X2,…`；行 4180 尾部有 r180 版本串 `"three.js r${"180"}` |
| 4180 | **引擎包尾 + 游戏公共常量层**（62KB 巨行）：世界边界/太阳/天空色/玩家常量、画质预设、事件总线、种子随机、工具函数、stub 模块表 `dr` | 行 4180 内 `var oi={min:new W(-40,0,-30),max:new W(40,30,30),groundY:0,seaY:-1.6,quayX:30},Mn={dir:new W(.916,.225,.331).normalize(),color:new Ve(1,.72,.42),intensity:9}` |
| 4181–4345 | 自定义 GLSL 公共段：噪声库 `Ug`（4181–4184）、天空工具 `Ng`（4185–4194）、噪声纹理生成 `Oy`（4195）、**天空 shader `H6`（4196–4283，标记 `// SALTLINE_SKY`）**、天空顶点+PMREM 捕获+阴影函数（4284–4285）、软阴影 patch `qy`（4285–4338）、后期公共 GLSL `Js`(4339)/`Og`(4343) | 行 4196 `// SALTLINE_SKY`；行 4182 `float n2(vec2 p){ … texture2D(tNoise, (i + f + 0.5) / 256.0).r; }` |
| 4346–4732 | **全部后期链 shader 字符串**（AO/体积雾/合成/运动模糊/泛光/眩光/最终合成/颗粒-FXAA） | 行 4458 `uniform sampler2D tColor, tDepth, tDepthHalf, tAO, tVol;`（合成 pass）；行 4607 `vec3 slAgxContrast(vec3 x){…}` |
| 4732–4733 | 后期链装配 `jy` 与各 pass 函数；**render 模块 `Hg`（4733 行内字节 10857）** | 行 4732 `function jy(i,e,{noiseTex:t}){let n=new nt;…` |
| 4733–5282 | render 模块主体 + **程序化贴图 GLSL 函数库 `Tn`（4822–5265，27 个）** + 材质生成 shader `i3`(5269)/`s3`(5280) | 行 4822 `void main(){ surf(vUv); }`,Tn={};Tn.asphalt=` |
| 5283–5305 | 字体常量、**材质定义表 `l1`（偏移 19691，49 项）、贴图集表 `c3`（偏移 17954，27 项）、fallback `fA`** | 行 5283 内 `l1={asphalt:Nt("asphalt",{wet:[.45,.3,.5,0],macro:o1}),concrete:Nt("concrete",{macro:o1}),…` |
| 5306–5441 | 材质 shader 注入 chunk `mA/dA/…`（wet 湿度/blink 等 onBeforeCompile 片段） | 行 5306 开头 `` `,mA=` `` |
| 5442 | **游戏世界核心巨行（180KB）**：mats `Gg`(230)、physics `d3`(7059)、props 表 `Gi`(14010)/`Xg`(15645)、props `Yg`(15676)、level 构建 `ob`(c 段 11522)/`C1`(c 段 50974)、关卡数据（c 段 55300–55950） | 行 5442 开头 `` `+mA).replace("#include <map_fragment>",gA)…async function Gg(i){`` |
| 5463–5813 | backdrop `pv`（远景吊车/船/海鸥群 `saltline-gulls`）、apron 地面材质 `saltline-apron-3`（5650） | 行 5463 内 `l.customProgramCacheKey=()=>"saltline-gulls";`，`var _R=["crane","ship","boat","sky"];` |
| 5814–5927 | 雨幕 instanced 几何 `Fb`、室内漏雨+天窗系统、**雷暴调度（偏移 2292 emit "thunder"）**、ground `O1`(2339)、地面常量 `Li={x0:-44,z0:-40,size:80}` | 行 5814 内 `A-=w,A<=0&&(A=30+t()*30,i.events.emit("thunder",{intensity:.3+.7*t()}))` |
| 5928–6053 | fx `Cf`(16951)、audio `c_`(70903)（含音色表 `Go`(64931)）、input `v_`(92556)、player `x_`(101183)、combat `zv`(107925) | 行 5928 内 `function Cf(i){let e=i.scene||i.render&&i.render.scene,…` |
| 6054–6075 | weapon `dm`(545)、枪模常量 `mi`、姿态 `eu/qv/tu/nu`、敌人参数 `Zv`(Gull)/`Kv`(Hound)/`Ui`、enemies `Em`(60910) | 行 6054 内 `Ui={gull:Zv,hound:Kv,sightRange:45,sightCone:200,…poolGulls:10,poolHounds:8,…}` |
| 6076–6089 | hud `hM`(8498)、comms 无线电字幕(10960)、键鼠按键表模板 `$C`（6076 行尾 `var $C=` 起跨行） | 行 6078 `<div><dt>Move</dt><dd><kbd>W</kbd><kbd>A</kbd><kbd>S</kbd><kbd>D</kbd></dd></div>` |
| 6089–6098 | 触摸按键表模板 `ZC` | 行 6099 `` </dl>`;function pM(i,e){`` |
| 6099–6181 | **菜单 DOM 模板**（pM 函数，标题/暂停/死亡/结算/设置面板/loc-card，全部 JS 动态生成） | 行 6103 `<section class="m-screen m-title" data-s="title" aria-label="Saltline">` |
| 6182 | **游戏流程巨行（24KB）**：pM 逻辑结尾、流程表 `Yi`、台词表 `_l`、game `mM`(5777)、showcase 注册表 `gM`(17694)、调试全局 `window.__frames/__ready/__fatal/__errors`(约 18300)、`bM`(致命层)、`Nr`(boot 文案)、**`QC`(18616，boot 入口)**、bench `eP` | 行 6182 内 `var gM={mats:qg,level:cv,backdrop:mv,ground:vv,fx:Sv,weapon:Xv,enemies:ex,props:$g,render:Vg};` |
| 6183–6189 | bench 输出模板（多行字符串）；input stub `tP`、player state 工厂 `nP` | 行 6184 `buffer ${_.x}x${_.y}  quality ${i.quality.name}  dpr ${window.devicePixelRatio}` |
| 6190–6193 | 空行 / `</script>` / `</html>` | 行 6191 `</script>` |

关键事实：**整个脚本是一个 IIFE**（行 349 `(()=>{`），three.js 与游戏代码共享作用域（短名压缩符号互通，如 4733 行 `Hg` 里 `n.toneMapping=ys` 引用的 `ys` 即行 4180 前定义的枚举）。

---

## 1. 系统地图：QC boot 流程与 15 个模块

### 1.1 boot 入口 `QC`（6182 行，字节偏移 18616 起）

```js
async function QC(){let i=Object.fromEntries(new URLSearchParams(location.search)),
e=!!i.bench||location.hash==="#bench";e&&(i.noaudio="1",i.autostart="1");
let t={THREE:lt,params:i,events:Dy(),rng:il(+(i.seed||4207)),time:{t:0,dt:0,frame:0,real:0},
quality:zy(i.q||(i.shot?"test":""))};window.__G=t;…
```

流程（同一行内顺序核验）：

1. 解析 URL 参数 → `t`（全局上下文，挂到 `window.__G`）。
2. `window.__setShot = o`（运行时 cam/fov/exposure 覆盖）。
3. 通用装载器 `r(name, key, factory, required)`：失败时 `console.error('[boot] module "X" failed: …')`，非必需模块回退到 stub 表 `dr[key]()`（`dr` 定义于行 4180）。
4. boot 文案/进度由 `Nr(msg, frac)` 驱动（6182 行，写 `#boot-msg`/`#boot-fill`）。

**boot 步骤顺序（全部在 6182 行 QC 内，文案即加载文案）**：

| 文案 | 进度 | 模块 | 入口函数 | 失败策略 |
|---|---|---|---|---|
| `Raising the terminal` | — | （HTML 初始，行 344） | — | — |
| `Waking the renderer` | .04 | render | `Hg(t)`（4733 行） | required |
| `Mixing paint, rust and rain` | .12 | mats | `Gg(t)`（5442 行） | 可 stub |
| — | — | physics | `d3(t)`（5442 行） | 直接赋值 |
| — | — | props | `Yg(t)`（5442 行） | 直接赋值 |
| — | — | input | `v_(t)`（5928 行）/ showcase 用 stub `tP()`（6189 行） | — |
| **showcase 分支**（`?show=`） | | 建 stub level+backdrop+ground+audio+hud+weapon+enemies；`gM[n].showcase(t)` | 各模块 showcase 函数 | — |
| `Stacking containers` | .34 | **level** | `C1(t)`（5442 行） | required |
| `Raising the cranes` | .5 | backdrop | `pv(t)`（5463 行） | 可 stub |
| `Flooding the apron` | .58 | ground | `O1(t)`（5814 行） | 可 stub（补 400×400 asphalt 平面） |
| — | — | physics.build() | `o()`（5442 行 d3 内） | — |
| `Loading tracers and smoke` | .66 | fx | `Cf(t)`（5928 行） | 可 stub |
| — | — | audio | `c_(t)`（5928 行）/ `?noaudio` 用 `dr.audio()` | 可 stub |
| — | — | player / combat | `x_(t)`（5928）/ `zv(t)`（5928） | 直接赋值 |
| `Checking the rifle` | .74 | weapon | `dm(t)`（6054 行） | 可 stub |
| `Waking the Harbormaster` | .82 | enemies | `Em(t)`（6054 行） | 可 stub |
| — | — | hud | `hM(t)`（6076 行） | 可 stub |
| — | — | game | `mM(t)`（6182 行） | 直接赋值 |
| `Waiting for first light` | .92 | render.onLevelReady() | 4733 行 | try/catch |
| `Ready` | 1 | 淡出 boot（`vM.classList.add("done")`） | — | — |

之后 `setAnimationLoop` 主循环（6182 行 QC 尾部）每帧调用序：`input → game.update → [showcase.update] → player/weapon/enemies（仅 playing）→ 武器湿润度（检测 interiorBoxes[0]，向 weapon.setWetness 传 0.3/1）→ fx/ground/level/backdrop/mats（非 paused）→ audio → hud → __setShot 相机 → bench.frame → render.frame → __frames++`。

### 1.2 模块清单（入口/行号/职责/对外接口）

| 模块 | 入口 | 行号 | 职责 | 对外接口（核验过的调用点） |
|---|---|---|---|---|
| render | `Hg` | 4733（偏移 10857） | WebGLRenderer、双相机（世界 74°+ 枪模 54° 分层）、太阳/闪光灯池、PMREM 环境、MSAA RT、后期链、自适应曝光、onLevelReady、setQuality、stats | `render.renderer/scene/camera/viewCamera`、`lightPool.flash/acquire`、`post:{fade,flash,saturation,damage,lowHealth,ads,exposure,…}`、`stats()`、`setQuality()`、`frame(dt)`、`onLevelReady()` |
| mats | `Gg` | 5442（偏移 230） | 程序化贴图烘焙（MRT albedo/ORM/normal）+ MeshStandardMaterial 缓存工厂 + 湿度/blink 等 shader 注入 + decal/label 画布材质 | `get(name,opts)`、`emissive(color,intensity)`、`names`、`decal(name)`、`label(text,opts)`、`uniforms:{wet}`、`update(dt)` |
| physics | `d3` | 5442（偏移 7059） | AABB 盒列表射线/扫掠/胶囊移动/高度查询 + 0.5m 栅格导航（A*） | `boxes`、`addBox(min,max,{surface,tag,noNav,bulletOnly,playerOnly})`、`removeBox`、`build()`、`raycast(o,d,max)`、`lineOfSight(a,b)`、`groundHeight(x,z,maxY)`、`moveCapsule(pos,vel,dt,r,h,step)`、`nav:{cell:0.5,isWalkable,findPath,randomPoint,clearLine,_grid}` |
| props | `Yg` | 5442（偏移 15676） | 36 种尺寸表道具 + `Xg` 自定义构建器（container/stairs/catwalk/relay_node 等经 `_i(name,fn)` 注册） | `names()`、`has(name)`、`build(name,opts)` → Group（`userData.colliders=[{min,max,surface}]`、`userData.size`） |
| level | `C1` | 5442（c 段偏移 50974） | 组装 yard/shed/quay 三区+关卡数据+静态合批+标签图集 | 见 §2（返回对象字段） |
| backdrop | `pv` | 5463（偏移 2092） | 远景：吊车/船/岸线/群鸥 instanced（`saltline-gulls` cache key） | `update(dt)`；碰撞盒 tag:"backdrop" 注册进 physics（`i.physics.addBox(b.min,b.max,{surface:m,tag:"backdrop",noNav:…})`，5442 行内） |
| ground | `O1` | 5814（偏移 2339） | apron 码头地面（`saltline-apron-3`）、海面 mesh+skirt、雨幕/水花粒子、平面反射 prepass、水坑/湿气查询 | `root/apron/sea/rain`、`puddleDepth`、`isPuddle`、`wetnessAt`、`seaHeight`、`setRain(v)`、`get rainLevel`、`setReflections(b)`、`update(dt)`、`reflectionTarget/Camera` |
| fx | `Cf` | 5928（偏移 16951） | 软粒子 billboard 池（`Ev` lit/unlit 两组 atlas）、弹道拖尾、烟/火花/爆炸/碎片/弹壳/贴花、雷暴闪光订阅 | `update(dt)`、`muzzleFlash/tracer/impact/sparks/smoke/explosion/debris/shell/decal/dust/clear/splash`、`addEmitter(pos,"steam"/"fire"/"drip")`（5928 行 showcase 内核验） |
| audio | `c_`→`u_` | 5928（偏移 70903） | WebAudio 全程序化合成（57 音色）、总线+混响、环境层强度、45 voice 池 | `ctx/resume/play(name,opts)/loop(name)/update/ready/selfTest`、`setIntensity(0..1)`、`setInterior(0..1)`、`setVolume(0..1)`、`setPaused`、`names`、`debug()` |
| player | `x_` | 5928（偏移 101183） | 胶囊移动状态、视角/ADS FOV、后坐/震屏、伤害/死亡事件、落水判定（`isPuddle`→脚步 "water"） | 状态对象 `C{pos,eye,vel,forward,yaw,pitch,health,maxHealth,alive,onGround,sprinting,crouching,ads,speed,…}`、`reset(playerStart)`、`damage(n,fromPos)`、`heal`、`addRecoil(p,y)`、`addShake(n)`、`setFov`、`update(dt)` |
| input | `v_` | 5928（偏移 92556） | 键鼠/触摸/手柄三模式（`mode:"lock"|"drag"|"touch"`），action 映射表 `h_`（KeyW→forward 等） | `move/look/fire/ads/sprint/crouch/locked/touch/gamepad`、`down(action)`、`pressed(action)`、`requestLock/exitLock`、`setGameplay(b)`、`describeMode()`、`onModeChange(fn)`、`endFrame()` |
| combat | `zv` | 5928（偏移 107925） | 射击判定仲裁（玩家/敌人/爆炸） | `stats{shots,hits,kills}`、`playerShot(o,d,{damage:28,range:300})`、`enemyShot(o,d,{damage:6,range:200})`、`explode(pos,radius=5,dmg=80,from)`、`reset()` |
| weapon | `dm` | 6054（偏移 545） | PAC-9 程序化枪模（4 材质+刻字）、弹药/换弹状态机、ADS/腰射姿态弹簧、wetness | `update/reset/setVisible`、`ammo/reserve/state/name:"PAC-9 Longshore"/ads/spread`、`muzzleWorld/reloadNow/addAmmo/setWetness/snap/debug/info` |
| enemies | `Em` | 6054（偏移 60910） | Gull/Hound 工厂+对象池（10/8）、感知/令牌/AI 状态机、电弹 bolt、残骸 | `list`、`update(dt)`、`spawn(type,pos,opts)`、`raycast(o,d,maxDist)`、`aliveCount()`、`clear()`、`alert(pos,radius)` |
| hud | `hM` | 6076（偏移 8498） | 纯 JS 生成 HUD DOM（罗盘/目标/准星/命中标记/伤害弧/交互提示/弹药/血量/击杀流/警告/世界标记）+ 无线电字幕 | `root`、`show(b)`、`setObjective(text)`、`setRelays(n,total)`、`radio(text,sec)`、`clearRadio()`、`message(text,sec)`、`warn(text,sec)`、`hitmarker(kind)`、`setPrompt(text,frac)`、`setMarkers(list)`、`reset()` |
| game | `mM` | 6182（偏移 5777） | 状态机 title/intro/playing/paused/dead/complete、中继目标流、波次调度、撤离、结算 | `state/flow:Yi/run/menus`、`start({skipIntro,quick})`、`pause/resume`、`update(dt)`、`debugCut()` |
| bench | `eP` | 6182（QC 内） | 沿 cinematicPath 巡航测帧率，`#bench` pre 覆盖层 | `bench.frame(dt)` |

stub 表 `dr`（行 4180）给出每个模块的**最小接口契约**（例：`fx:()=>({stub:!0,update:Wt,muzzleFlash:Wt,tracer:Wt,impact:Wt,sparks:Wt,smoke:Wt,explosion:Wt,debris:Wt,shell:Wt,decal:Wt,dust:Wt,clear:Wt,splash:Wt,addEmitter:…})`）——改造模块时以它为准。

---

## 2. 关卡数据结构（重点）

### 2.1 世界/物理常量（行 4180）

```js
oi={min:new W(-40,0,-30),max:new W(40,30,30),groundY:0,seaY:-1.6,quayX:30}
Li={x0:-44,z0:-40,size:80}        // 地面贴图覆盖域（行 5814）
```
- 码头侧（x≤30）地面高度 0；海侧（x>30）海面 -1.6（physics `raycast` 内 `O===2?"water"`，5442 行）。

### 2.2 区域常量（行 5442 内）

```js
no={X0:-16,X1:12,Z0:-28,Z1:-11,EAVE:7,RIDGE:9.5,ZR:-19.5,FLOOR:.03}   // shed 机库
```
- shed 的 relay 返回：`{fan,lights,skylights,relayPos:new W(-2,y,-19.5),update}`（5442 行 c 段偏移 ~34100 上文，`new W(-2,y,-19.5)`）。
- quay 的 relay 返回：`{relayPos:new W(23,0,0),extraction:new W(29,0,h)}`（5442 行 c 段偏移 ~42750）。

### 2.3 level 返回对象（`C1` 尾部，5442 行 c 段偏移 ~55800）

```js
return{root:e,playerStart:d,objectives:v,extraction:{pos:s.extraction.clone(),radius:2.5},
enemySpawns:y,zones:b,interiorBoxes:m,cinematicPath:A,coverPoints:_,skylights:n.skylights,
shedLights:n.lights,vantage:{stairsFoot:mt(-2.2,0,12.4),roof:mt(13.5,2.59,12.4)},
stats:{…},placed:t.placed,groundSurfaceAt(z,H){return t.isMetal(z,H)?"metal":"concrete"},
update(z){n.update(z),h.update(z);…}}
```

**确切当前值**：

- **playerStart**：`d={pos:mt(-32,0,6),yaw:-ts}`，即 **pos=(-32,0,6)、yaw=-π/2（面向 +z 大门方向）**（`ts=uR/2`，行 5442 内 `var uR=Math.PI,ts=uR/2`）。
- **objectives**（3 个中继）：
```js
v=[{id:"relay_a",label:"Relay A — Yard", zone:"yard", pos:mt(1.5,0,7.5),                      object:o},
   {id:"relay_b",label:"Relay B — Shed", zone:"shed", pos:mt(n.relayPos.x,no.FLOOR,n.relayPos.z), object:r},   // ≈(-2,0.03,-19.5)
   {id:"relay_c",label:"Relay C — Quay", zone:"quay", pos:mt(s.relayPos.x,0,s.relayPos.z),      object:a}]   // =(23,0,0)
```
  relay 实体在 `C1` 内由 `t.place("relay_node",…)` 放置（id relay_a/b/c 的 object 分别是 o/r/a），`userData.setState(state)` 被 game 调用切 "live/cutting/cut"（6182 行 `function O(P,V){…Y.setState(V)…}`）。
- **extraction**：**pos=(29,0,-?)（quay 返回的 h 为码头南端梯子的 z 值）、radius=2.5**；判定在 6182 行：`L<(Y.radius||2.5)&&Math.abs(Y.pos.y-n.pos.y)<3.5`。
- **enemySpawns**（`g(x,z,zone)={pos,zone,type:"ground"}`、`x(y,x,z,zone)={pos,zone,type:"air"}`）：
  - yard 地面 10 个：(-19,-1.4),(3.5,-1.6),(14.2,16.4),(-3.2,16.6),(-16,26),(6,26),(4.2,-5.12),(-7.8,21.4),(-11.3,12.5),(17.5,22.2)
  - yard 空中 6 个：(10,11,23.5),(2,11,21.5),(13,9,11),(-4,12.5,-4.5),(9,10,1.5),(-10,12,24.5)
  - shed 地面 7 个：(-12.4,-24.8),(9.6,-25.3),(-13.4,-19.6),(4.6,-13.8),(-21,-27.2),(-18.6,-22),(13.6,-24)
  - shed 空中 5 个：(-8,5.4,-20.5),(5,5.2,-18),(-20,10.5,-20),(14.5,10,-22),(-2,12.5,-8.5)
  - quay 地面 7 个：(27.7,-24.2),(18.3,-25.4),(27.2,-12.6),(20.2,14),(23.4,23.2),(18,24.4),(27.4,11.6)
  - quay 空中 6 个：(36,9,4),(38,11,-6),(35,8.5,16),(24,12.5,10.5),(33.5,10,24.5),(22,13,-14)
- **zones**（名字→XZ 矩形）：
```js
b=[{name:"gate",min:[-40,-30],max:[-24,30]},{name:"yard",min:[-24,-10],max:[16,30]},
   {name:"shed",min:[-24,-30],max:[16,-10]},{name:"quay",min:[16,-30],max:[40,30]}]
```
- **interiorBoxes**（室内体，主 shed；最多用前 4 个，QC/ground/render 均只取 `[0]` 或循环 4 个）：
```js
m=[{min:mt(no.X0,0,no.Z0),max:mt(no.X1,no.RIDGE,no.Z1)}]   // = min(-16,0,-28) max(12,9.5,-11)
```
- **cinematicPath**：12 个 `{pos,look}` 关键帧（从 (-34,1.6,6.2) 起沿 yard→shed→quay 的标题漫游样条，5442 行 c 段偏移 ~55250 起）。
- **coverPoints**：56 个 `mt(x,y,z)` 点（ yard 50 个 + 屋顶 2 个 `(13.5,2.59,12.4)/(4.4,2.59,12.4)` + 其它 4 个），生成后用 `physics.nav.isWalkable` 校正（`E=z=>{…for(let H of[.5,1,1.5,2])for(let O=0;O<8;O++)…}`，5442 行）。
- **groundSurfaceAt(x,z)**：`t.isMetal(z,H)?"metal":"concrete"`（脚步/枪声表面音效和拖尾贴花都用它）。

### 2.4 物理注册：`physics.build` 吃什么

- `addBox(min,max,{surface,tag,noNav,bulletOnly,playerOnly})` 是唯一注册入口（5442 行 d3 内，`z={min:…,max:…,surface:E.surface||"concrete",tag:E.tag||"",noNav:!!E.noNav,bulletOnly:…,playerOnly:…}`）。
- `build()` 仅重建导航栅格 `a()`：遍历 boxes（排除 `noNav/bulletOnly/max.y<u1+.05/min.y>1.5`，`u1=.42` 为上台阶高度），膨胀 `yf=.5` 后烘焙到 `Uint8Array(qt*Qs)`；栅格范围 `Ya=-40,EA=31,ol=-32,SA=30,qt=Math.round((EA-Ya)/Ls),Qs=Math.round(…)`，cell `Ls=.5`（→ 142×124 格），码头边缘与栅格外圈强制阻挡。
- 注册来源三类：① 关卡构建上下文 `ob` 的 `col=A(T,D,C,G,j,N,Q,K)=i.physics.addBox(...)`（5442 行 c 段偏移 ~11650 `function A(T,D,C,G,j,N,Q="concrete",K={}){return i.physics.addBox([T,D,C],[G,j,N],{surface:Q,...K})}`）；② 道具 `place`→`props.build` 的 `userData.colliders`（`[{min:[-l[0]/2,0,-l[2]/2],max:[…],surface:…}]`，5442 行 props `Yg`/place `E`（偏移 134684）内 `!Q.noCol&&!cR.has(T)&&M(K,G,Q)`）；③ backdrop 的 tag:"backdrop" 盒（`i.physics.addBox(b.min,b.max,{surface:m,tag:"backdrop",noNav:…})`）。
- 射线是**手工 slab 法 AABB 遍历**（5442 行 d3 `raycast`），命中地面/海面时 `surface:O===2?"water":(level.groundSurfaceAt(x,z)||"concrete")`。

### 2.5 地面/室内判定如何工作

- **室内**：`level.interiorBoxes`（当前 1 个）。使用点：① QC 主循环（6182 行）检测相机在盒内→`weapon.setWetness` 降到 0.3；② 后期体积雾（4733 行 P 函数：`uBoxMin/uBoxMax/uBoxDust` 室内尘土）；③ ground `b(M,E)`（5814 行 O1 内：遍历 boxes 判 x/z 在 min/max 内→室内湿气 0.12）；④ fx/5814 行雨滴系统 `uDrip`+天窗 `uSkylight[8]`（来自 `level.skylights`，shed 返回的 `skylights:X`）。
- **地面材质**：`groundSurfaceAt`→`isMetal`（5442 行 c 段偏移 ~16396：`metalRects` 矩形列表，`U=(x,z)=>{for(...){if(x>=C[0]&&x<=C[2]&&z>=C[1]&&z<=C[3])return!0}return!1}` 的形态，由 `col(...,"metal")` 注册时收集）。
- **水坑/湿气**：ground `O1` 的 `wetnessAt/puddleDepth/isPuddle`（5814 行）：`M>oi.quayX→1`（海面全湿）、室内 0.12、apron 由 1024 水坑噪声图 `U1(s,n,M,E,0)` 求 `0.5-depth`。

---

## 3. 天空与天气

### 3.1 SALTLINE_SKY（4196–4283 行，fragment `H6`）

标记：行 4196 `// SALTLINE_SKY`。手写 GLSL，注入 `Ug`（4181–4184：`tNoise` 256² 采样 `n2` + `fbm5/fbm3`，旋转矩阵 `mat2(1.6,1.2,-1.2,1.6)`）与 `Ng`（4185–4194：`skyToSun(d)` = 方位对齐因子 0..1、`horizonColor(d)` = 落日方向 3 段 mix，`c=mix(c, vec3(1.0,0.60,0.24)*3.4, pow(ts,34.0))`）。

结构（每段都有行号证据）：
- **晴空基底**（4211–4217）：`clearC` 由 horizonColor→浅带→高空蓝 mix，加 4 项 Mie 光晕 `pow(s,8/64/600/6000)`。
- **云 deck**（4219–4241）：`cuv=d.xz/(h+0.10)*vec2(0.62,0.95)` 东-西向卷云，风移 `vec2(-0.012,0.004)*uTime`；`warp=fbm3(q*0.45+7.1)` 域扭曲；`dens=fbm5(qq)`；`ridg` 脊状底面细节；覆盖率 `cov=smoothstep(0.31,0.50,body)`；deck 下缘 `edge=mix(0.030,0.285,pow(ts,1.7))`（朝阳缺口处云层抬高，" burning gap"）；太阳位置永远烧穿一个破洞（`hole=smoothstep(0.972,0.9985,mu+…)`）。
- **云层光照**（4243–4257）：朝太阳密度梯度 `relief` 做自阴影；冷面 `cool`（板岩色，厚处更暗）；暖光斜射 `warm`（`uHor*vec3(1.30,0.66,0.40)`）+ 云缘燃烧 rim。
- **片状闪电**（4258–4260）：`float fl=uFlash*pow(max(dot(d,uFlashDir),0.0),5.0); cloudC += vec3(0.55,0.68,1.0)*fl*(0.4+2.2*dens*dens)`。
- **太阳盘**（4268–4271）：`disk=smoothstep(0.999905,0.999955,mu)`，`col += vec3(1.0,0.80,0.52)*disk*110.0*veil*(1.0-uEnv)`（PMREM 捕获时 `uEnv=1` 去掉太阳盘）。
- **地平线下**（4273–4279）：海雾/地面反照。

天空网格：`Hy`（4285 行内）——材质 `name:"saltline-sky",side:Ki(BackSide),depthWrite:!1,renderOrder=-1e3`，2×2×2 BoxGeometry，`frustumCulled=!1`。uniforms 由 `W6`（4285 行内）：`tNoise/uTime/uEnv/uFlash/uFlashDir(-.5,.5,-.7)/uSunDir/uZen/uHor/uHorAway/uSunCol`。
PMREM 环境捕获 `Vy`（4285 行内）：克隆材质置 `uEnv=1`，`t.fromScene(s,0,.1,100)`，赋给 `scene.environment`（`environmentIntensity=Jy=2`，行 4180 尾部/4733 行 `r.environmentIntensity=Jy`）。

### 3.2 天气参数定义在哪

- **天空色/太阳常量**（行 4180）：`en={zenith:new Ve(.055,.085,.13),horizon:new Ve(.95,.55,.28),horizonAway:new Ve(.16,.22,.3),fog:new Ve(.42,.47,.52)}`、`Mn={dir:new W(.916,.225,.331).normalize(),color:new Ve(1,.72,.42),intensity:9}`。
- **雨强度**：画质预设 `Pr[.rain]`（行 4180：test .4/low .5/medium .8/high·ultra 1）→ ground `setRain/rainLevel`（5814 行）驱动雨幕粒子密度与湿气。
- **雷暴**：5814 行内 `A-=w,A<=0&&(A=30+t()*30,i.events.emit("thunder",{intensity:.3+.7*t()}))` —— 每 30–60 秒随机；监听方：render（闪电时天空 `uFlash`+环境，4733 行 `i.events.on("thunder",ie=>{w.t=0,w.power=…})`）、audio（雷声延迟播放 `ze("thunder",{…delay:.5+(1-he)*2+s()*.6,…})`，5928 行）。
- **风**：仅作云移动常量（4221 行）与 fx 粒子 `wind` 通道（5928 行 `l.wind[_e]=ce`）。

---

## 4. 光照与阴影、曝光与后期链

### 4.1 灯光

- **太阳**（4733 行 Hg 内）：`let h=new W0(Mn.color,Mn.intensity);h.name="sun",h.castShadow=!0`（DirectionalLight，color=(1,.72,.42)，intensity=9）。阴影相机用 `Gy`（4285 行内）沿太阳方向拟合场景 AABB（near/far 由 `new W(-41,-.2,-33)…new W(72,36,34)` 两组角点求出，`g.left=c-x…g.updateProjectionMatrix()`）。
- **闪光灯池**（4733 行）：6 个 `Qr(16777215,0,12,2)` PointLight（decay 2，distance 12），`x={flash(pos,color,intensity,dist,ttl),acquire(),update}` 用于枪口/爆炸/闪电，支持 persistent 借用（`acquire`+`release`）。
- **室内灯**：`level.shedLights`（`n.lights`，shed 构建返回）；环境整体靠 `scene.environment`（PMREM，强度 2）。
- **色调映射状态机**（4733 行）：HDR 路径 forward 渲染 `n.toneMapping=ys`（`ys=0`=NoToneMapping，行 4180 前定义；证据 `grep "ys=0,V2"` → `…za=3,Ch=4,Ph=5,Ih=6,zh=7,vc=0,O2=1,H2=2,ys=0,V2=1,W2=2,G2=3,xc=4…`）；最终 blit pass `G()`（4733 行偏移 15443）临时切 ACES：`function G(){n.toneMapping!==xc&&(n.toneMapping=xc),n.toneMappingExposure=.6*N.exposure*(1-…N.post.fade))…}` —— **最终输出用 three.js ACESFilmicToneMapping（xc=4），曝光 = 0.6 × 自适应曝光 × (1-fade)**。`j()`（偏移 15675）为 post=0 的 fallback 路径：`toneMapping=ys, toneMappingExposure=1`。
- **AgX/ACES 自定义实现**（最终合成 shader tA，4577–4702 行）：`uAgxMix` 混合两个手写曲线：行 4607 `vec3 slAgxContrast(vec3 x){…}`、行 4608 `vec3 slAgx(vec3 color){…}`、行 4624 `vec3 slAces(vec3 c){…}`，行 4677 `col = mix(slAces(col), slAgx(col), uAgxMix);`（注释：`// filmic curve: ACES (Hill fit) for punch and burning oranges, pulled toward AgX so hig…`）。

### 4.2 阴影参数当前值（4733 行 Hg 内）

```js
n.shadowMap.enabled=!0,n.shadowMap.type=gc,n.shadowMap.autoUpdate=!1;
p=()=>Math.min(i.quality.shadow||2048,n.capabilities.maxTextureSize);
h.shadow.mapSize.set(p(),p());h.shadow.bias=-12e-5;h.shadow.normalBias=.02;h.shadow.radius=1;h.shadow.autoUpdate=!0;
d=qy(f,{taps:i.quality.name==="low"?10:16,searchTaps:8})
```
- `gc=1` = **PCFShadowMap**（非 soft；证据行 4180 前 `p5=0,gc=1,Eh=2,ur=3`，且 349 行导出表 `PCFShadowMap:()=>gc`）。
- mapSize：quality.shadow（test 1024 / low·medium 2048 / high·ultra 4096，行 4180 `Pr`）与 maxTextureSize 取小。
- **软阴影 patch**（`qy`，4285–4338 行）：运行时改写 three.js `It.shadowmap_pars_fragment` 的 `getShadow`——Vogel 盘采样（行 4327 `vec2 o = slVogel( i, ${e}, phi + 1.7 ) * filtR;`），半影随遮挡距离增长（行 4323 `float penM = clamp( distM * 0.022 * shadowRadius, 0.012 * shadowRadius, 0.60 * shadowRadius );`），map 边缘 2% 渐隐回 lit。失败回退 stock PCF（`console.warn("[render] soft shadows: unexpected Three shader chunk layout, keeping stock PCF")`，4285 行尾）。恢复函数 `Xy`（4338 行）。

### 4.3 后期链各 pass（`jy`，4732–4733 行；执行函数 `P` 在 4733 行偏移 5813）

执行顺序（4733 行 `P({hdr,camera,sun,dt,post,exposure,time,fast,thunder})` 内核验）：

1. **深度半分辨率拷贝**（`l(S,y.depthHalf)`，shader `$y` 4444 行）。
2. **SSAO**（可选）：`z`（AO shader `Y6` 4356 行）→ 可分离模糊 `O`（`$y`）双 pass x/y。URL `?ao=0` 可关。
3. **体积雾/光轴**（可选，shader `$6` 4388 行）：`H` 半分辨率 raymarch `VOL_STEPS`（ue 函数 4733 行：`Math.max(6,d().volSteps|0)`，low/test 8、ultra 16、medium/high 12——实际 uniforms `defines.VOL_STEPS`）；**采样太阳 shadow map**（`be.tShadow.value=pt…uShadowMatrix.value.copy(le.shadow.matrix)`）；太阳辐射 `uSunRad=sun.color*sun.intensity*g.volSunScale`；环境项 `uAmb=en.fog*volAmbient*(1+thunder*1.5)`；**室内盒** `uBoxMin/uBoxMax/uBoxDust=g.volInteriorDust`（interiorBoxes[0]）。URL `?vol=0` 关。
4. **HDR 合成**（shader `Z6` 4457 行：`tColor+tDepth+tAO+tVol → y.scene`，AO/体积可 `uAoOn/uVolOn` 旁路）。
5. **运动模糊**（可选，shader `j6` 4489 行；`uShutter=Math.min(.5,1/190/Math.max(R,.001))`；URL `?mb=1` 强开，quality.motionBlur 默认 low/medium 关）。
6. **泛光**：b 级降采样链（shader `J6` 4510 行 `uFirst`）+ 上采样叠加（`K6` 4529 行 `tLow/tHigh/uMix`）；阈值 pass（`Q6` 4538 行，`thr = uThreshold / max(slExposure(), 0.2)`）。URL `?bloom=0` 关。
7. **太阳眩光/遮挡累积**（shader `eA` 4551 行：`tPrev/tLum/tDepth/uSunUv/uSunOn/uRate/uVisRa…` —— god rays/occlusion 逐帧累积）。
8. **最终合成**（shader `tA` 4577–4702 行）：色差 `uCA+uDamage*0.006`（4659 行）、ADS 周边柔化（4663）、bloom energy-conserving mix + **lens dirt**（4665–4668 `col=mix(col,bloom,uBloom); col+=bloom*dirt*uDirt`）、**anamorphic streak**（4669 `col+=texture2D(tStreak,vUv).rgb*vec3(0.45,0.62,1.0)*uStreak`）、**太阳 glare+flare 遮挡测试**（4670–4672）、**曝光 = manual × 自适应**（4674 `col *= slExposure()`，`slExposure` 定义在 4344–4345 行：`float slExposure(){ float a = texture2D(tAdapt, vec2(0.5)).r; return uExposure * mix(1.0, clamp(pow(…`）、闪电加亮（4675）、ACES/AgX（4677）、**grade**（4679–4691：split-tone 青阴影暖高光、S-curve、青黑位、饱和度随 uLowHealth/uDamage 降）、**暗角**（4692–4695）、**受伤红边**（4696–4698）、fade（4699）、`toSRGB`（4700）。
9. **颗粒/锐化/FXAA**（shader `iA` 4702 行起：`uGrain,uSharpen,uFxaa`）。
10. **自适应曝光**（4733 行 `Z()` 偏移 10375）：`readRenderTargetPixels(y.adapt[m],…)` 读半浮点亮度 → `fe=Math.min(g.maxExposure,Math.max(g.minExposure,Math.pow(g.key/…`，写入 `y.adapt[m]` ping-pong RT。

### 4.4 画质预设（行 4180 `Pr`）

```js
Pr={test:{scale:1,msaa:0,shadow:1024,tex:256,volSteps:10,ao:!0,planar:.5,bloom:!0,motionBlur:!1,rain:.4},
low:{scale:.7,msaa:0,shadow:2048,tex:512,volSteps:12,ao:!1,planar:0,bloom:!0,rain:.5},
medium:{scale:.85,msaa:2,shadow:2048,tex:1024,volSteps:16,ao:!0,planar:.5,rain:.8},
high:{scale:1,msaa:4,shadow:4096,tex:1024,volSteps:24,ao:!0,planar:.5,bloom:!0,motionBlur:!0,rain:1},
ultra:{scale:1,msaa:4,shadow:4096,tex:2048,volSteps:40,ao:!0,planar:1,bloom:!0,motionBlur:!0,rain:1}}
```
自动选择 `zy`（行 4180）：移动 UA/maxTouchPoints→low；`/SwiftShader|llvmpipe|Software|Mali|Adreno|PowerVR/i` 或非 Arc 的 Intel→medium；否则 high。

---

## 5. 材质系统

### 5.1 mats.get 支持的材质名（`l1` 表，5283 行偏移 19691，共 49 个）

`asphalt, concrete, concrete_dirty, concrete_painted, brick, floor_epoxy, paint_red, paint_blue, paint_green, paint_yellow, paint_orange, paint_white, paint_grey, paint_teal, steel_galv, steel_dark, steel_worn, steel_bare, steel_rust, diamond_plate, corrugated_roof, chainlink, aluminium, brass, hazard_stripes, gunmetal, anodized_black, polymer_black, polymer_tan, rubber, carbon, glove_fabric, armor_white, armor_orange, wood_pallet, wood_dark, plastic_blue, plastic_red, plastic_grey, tarp, cardboard, rope, tire, glass, glass_dirty, hull_paint, hull_red, water_dark`（fallback `fA=Nt("metal",…)`）。未知名会 `console.warn('[mats] unknown material "X" — using fallback')`（5442 行 Gg 内 `w()` 函数）。

### 5.2 程序化贴图如何生成

- **贴图集表 `c3`**（5283 行偏移 17954，27 个 set）：`asphalt:{fn:"asphalt",size:1,tile:2,bump:1.6,hero:!0}, concrete:{…}, brick:{fn:"brick",size:.5,tile:1.8,bump:6}, … corrugated:{fn:"corrugated",size:.5,tile:[.762,2.286],bump:19}, … water:{fn:"water",size:.25,tile:4,bump:30}`。`fn` 指向 **GLSL 函数库 `Tn`**（4735–5265 行，`Tn.asphalt`(4822)/`Tn.concrete`(4847)/`Tn.brick`(4874)/`Tn.epoxy`(4891)/`Tn.paint`(4942)/`Tn.hazard`(4948)/`Tn.hull`(4957)/`Tn.galv`(4987)/`Tn.metal`(5002)/`Tn.brushed`(5016)/`Tn.rust`(5027)/`Tn.diamond`(5051)/`Tn.corrugated`(5068)/`Tn.chainlink`(5091)/`Tn.gunmetal`(5106)/`Tn.polymer`(5120)/`Tn.carbon`(5132)/`Tn.fabric`(5142)/`Tn.armor`(5152)/`Tn.wood`(5167)/`Tn.plastic`(5188)/`Tn.tarp`(5200)/`Tn.cardboard`(5215)/`Tn.rope`(5226)/`Tn.tire`(5235)/`Tn.glass`(5250)/`Tn.water`(5265)）。
- **烘焙管线**（5442 行 `Gg` 的 `A(set)` 函数）：每 set 一次 MRT 离屏渲染（3 目标），随后 ① `uSq=1` 平方变换 → **albedo**（sRGB）；② 直拷 → **ORM**（roughness/metalness/AO 合一）；③ 高度图 `tH` → Sobel 法线 → **normal**。目标尺寸 `q=Math.round(s*O.size)`（`s=min(tex,1024)`，hero 材质在 tex≥2048 时强制 2048）；RT `anisotropy=o`（≤8），`wrapS/T=Is(Repeat)`，mipmap 生成（`b()` 里 `generateMipmaps:!0,minFilter:Ln`）。
- **噪声来源**：每个 `Tn[fn]` GLSL 自带 hash/fbm（材质内嵌，与天空 `Ug` 独立）；`uP` 四参数 + `uSeed` 由 c3 的 `p`/`seed` 提供（`j.uniforms.uP.value.set(N[0]||0,…),j.uniforms.uSeed.value=U.seed||0`，5442 行）。
- **材质组装**（5442 行 `w(name,opts)`）：缓存键 `name|v(vertexColors)|t+scale(triplanar)|d(doubleSide)|i(interior)|c+color` → `new Qt({map,normalMap,roughnessMap,metalnessMap,aoMap,color,roughness,metalness,vertexColors})` + shader 注入（5306–5441 行的 chunk：湿度 wet 路径、blink 闪烁等；5449 行 `e.customProgramCacheKey=()=>"saltline-blink"`）。
- **opts**：`{vertexColors, triplanar(+scale), doubleSide, interior, color}`。

### 5.3 如何新增一种材质（手术步骤）

1. 在 `Tn`（4822–5265 行区间任一处，如 `Tn.myset=`）写一个 `void surf(vec2 uv)` 形式的 GLSL 函数，输出 albedo/高度/ORM 到约定的 MRT 通道（参照 `Tn.concrete` 4847 行）。
2. 在 `c3`（5283 行）登记：`myset:{fn:"myset",size:.5,tile:2,bump:2,p:[…],seed:N}`。
3. 在 `l1`（5283 行）登记材质：`my_mat:Nt("myset",{color:0x…,rough:…,metal:…,wet:[…],macro:[…]})`（`Nt` 工厂同处：`Nt=(i,e={})=>({set:i,tint:0,color:16777215,rough:1,metal:1,wet:cA,macro:hA,nrm:1,...e})`）。
4. 之后任何地方 `i.mats.get("my_mat")` 即可；若要 triplanar 顶点色变体（关卡合批用），level 会自动生成 `{vertexColors:!0}` 变体（5442 行 C1 的材质去重循环）。

---

## 6. 音频系统（c_，5928 行偏移 70903）

### 6.1 合成器结构

- **AudioContext** `{latencyHint:"interactive"}`；无 WebAudio → `iC()` 静音 stub。
- **音色表 `Go`**（5928 行偏移 64931，57 项）：每项 `{gen,sr,n(变体数),peak,bus,max(并发),pri(优先级),boot?,loop?,ir?,ref,roll}`。gen 全部是**程序化采样合成器**（如 `rifle_shot:{gen:KR,n:4,sr:ki,peak:.97,bus:"near",max:5,pri:9,boot:1}`，KR 定义于 5928 行）。合成走**分步生成器**避免卡顿（`a_()` + 每 6ms 一批 `setTimeout(y,12)`，5928 行 `function y(){…if(pe&&(h(he.k,pe),d.shift(),be(he.name)),performance.now()-te>6)break…}`）。
- 音色分组（`Go` 实测清单）：
  - 武器：`rifle_shot×4 / rifle_tail_out / rifle_tail_in / rifle_dry / reload_magout / reload_magin / reload_bolt / shell_bounce×3`
  - 脚步：`step_concrete×4 / step_water×3 / step_metal×3 / land / jump / hurt / ear_ring`（按表面映射 `Iv={metal:"step_metal",water:"step_water",concrete:"step_concrete",wood:"step_concrete",dirt:"step_concrete",glass:"step_concrete",rubber:"step_concrete"}`，5928 行）
  - 命中：`impact_metal/concrete/wood/water/enemy/glass / whiz×3 / ricochet×3`（`l_={metal:"impact_metal",concrete:"impact_concrete",wood:"impact_wood",water:"impact_water",glass:"impact_glass",dirt:"impact_concrete",rubber:"impact_wood"}`）
  - 敌人：`gull_fire×2 / hound_fire×2 / hound_step×3 / gull_die / hound_die / telegraph×2 / alert×2 / gull_rotor(loop) / hound_servo(loop)`
  - 环境：`relay_hum(loop) / rain(loop) / rain_interior(loop) / wind(loop) / sea(loop) / thunder×2 / foghorn / gull_cry×2 / halyard×2 / container_bang`
  - UI/任务：`ui_click / ui_hover / objective / objective_all / complete / death / relay_cut`
  - 音乐 5 层 loop：`music_drone / music_ost / music_perc / music_brass / music_motif`（`tm=[…]`，5928 行）
  - 混响 IR：`ir_outdoor / ir_shed`（Convolver buffer）

### 6.2 音量总线（5928 行，核验过的节点链）

```
world(1.0) ─┐
near(0.95) ─┼─ lowpass20kHz ─ z(1) ─ A(1) ─ compressor(th-10,knee6,ratio6,atk.002,rel.14) ─ M(0.45) ─ waveshaper软削波 ─ w(0.9) ─ destination
amb(0.55) ──┘
dry(1.0) ───────────────↗ A（绕过低通）
music(0.62) ─ K(0.2) ──↗ A；另music→C(ir_shed)
world→N(0.9)→q→U→D(ir_outdoor,0.75)→S；near→Q(0.32)→q→T(0)→C(ir_shed,0.95)→S
```
- voice 池：22 world（带 equalpower PannerNode：`panningModel="equalpower",distanceModel="inverse",refDistance=3,rolloffFactor=.6,maxDistance=400`）+ 12 near + 8 dry + 3 music（5928 行 `for(let te=0;te<22;te++)ne("world",!0);…`）。
- play 分配器 `ze(name,opts)`（5928 行）：变体轮换 `Pe[name]=(Pe+1+随机跳变)%n`、按表面替换（`te==="impact_concrete"?te=l_[he.surface]`）、`tC` 集合内的音色允许 preboot。
- 主循环音量/滤波随状态：`setIntensity(0..1)`（巡逻 .15 / 战斗 .6–1，由 game `c.intensity` 驱动，6182 行）、`setInterior(0..1)`（室内滤波/混响切换）。

### 6.3 无线电字幕与提示音；有无语音合成

- **无线电字幕**：hud `hM` 内生成 `.comms` 容器（6076 行偏移 10960）：`"comms",'<span class="comms-who">Control</span><span class="comms-t"></span>'` + `role="status" aria-live="polite"`；游戏侧经 `o.radio(text,sec)` 调用（6182 行 mM 内多处，如 `o.radio(_l.intro,4.2)`）。
- **台词表 `_l`**（6182 行）：intro/contact/cut[2 条]/all/low/done，全文：
```js
_l={intro:"Breacher, this is Control. The Harbormaster holds the berth. Cut its three uplinks — yard, shed, quay.",
contact:"It has seen you. Gulls fly, Hounds walk. Put them down.",
cut:["One relay dark. It felt that — machines inbound.","Two dark. It is throwing everything it has left at you."],
all:"All three dark. The boat is holding at the quay ladder, south end. Run.",
low:"You are hit hard. Get behind steel and breathe.",
done:"Breacher is aboard. Saltline is dark. Good work."}
```
- **提示音**：audio 内事件订阅（5928 行偏移 ~85800）：`ln("extraction:reached",Zo)`（播放 complete）、`ln("thunder",…)`、`ln("ui:click"/"ui:hover")`、objective/objective_all 同处（`ze("objective_all",{delay:2.2,gain:1,jitter:0})`）。任务音objective 走 music bus。
- **语音合成：不存在** —— `grep -c "speechSynthesis"` 返回 0。全部"语音"以合成音效+字幕呈现。

---

## 7. UI 文案位置（中文化手术清单）

### 7.1 HTML 静态文案（仅 boot 屏）

| 行 | 内容 |
|---|---|
| 3 | `<title>Saltline</title>` |
| 343 | `<div class="boot-mark">SALTLINE</div>` |
| 344 | `<div class="boot-sub" id="boot-msg">Raising the terminal</div>` |

### 7.2 JS 动态生成（真正的文案主体）

**菜单模板**（`pM`，6099–6181 行 + 6182 行逻辑；`$C` 键鼠表 6077–6089 行、`ZC` 触摸表 6090–6098 行）：

| 行 | 文案 |
|---|---|
| 6105 | `B4` `Port Authority Breach Unit` `Saltline Terminal · 05:42` |
| 6106 | 标题 `SALTLINE` |
| 6107 | 前提 `The port's security net has gone feral. Cut its three uplinks. Reach the boat.` |
| 6109–6111 | 按钮 `Deploy / Settings / Controls` |
| 6113 | `Every surface, machine and sound is generated in your browser. Nothing is downloaded.` |
| 6116–6118 | 标题屏按键图例（WASD Move…Touch…） |
| 6123–6131 | 暂停卡：`Operation on hold / Paused / Resume / Settings / Controls / Restart mission` |
| 6135–6138 | 死亡卡：`Breacher down / Signal lost / Time survived / Relays cut / Retry` |
| 6142–6151 | 结算卡：`Berth 4 · Debrief / Saltline is dark / Rating / Time / Accuracy / Machines destroyed / Retries / Redeploy` |
| 6157–6169 | 设置面板：`Settings / Controls / Graphics quality(test|low|medium|high|ultra) / Mouse sensitivity / Invert Y / Master volume / Field of view / Display-Enter fullscreen` |
| 6174 | `If the browser will not capture the mouse, hold a mouse button and drag to look…` |
| 6177 | 手柄说明 `Sticks move and look · RT fire · LT aim · A jump · B crouch · X reload · Y cut relay · L3 sprint · Start pause.` |
| 6181 | loc-card：`Saltline Terminal · Berth 4 · 05:42` + `Port Authority Breach Unit — one breacher, no backup` |
| 6182 | 设置提示 `Quality was picked for this device (…). Lower it if the frame rate struggles.` / `Quality changes apply at once; shadows and reflections may take a moment to rebuild.`；任务目标函数 `D()`：`Cut the three uplink relays` / `Cut the remaining N relays` / `Cut the last relay` / `Get to the boat`；提示 `Hauled out of the water`、`Relays still live — the boat will not wait under fire`、`Contact — <方位词>`（`jC=["NORTH",…8 方位]`，6182 行）；结算评语 `["Messy","Loud","Steady","Clean","Sharp","Surgical"]`（6182 行 `ee()` 内） |
| 6182 | 无线电台词 `_l`（见 §6.3） |

**HUD 文案**（`hM`，6076 行）：`Objective`（6076 行偏移 9167：`'<div class="h-k">Objective</div>…<span>Relays</span>…<b>0/3</b>'`）、交互提示 `Cut relay X`（6182 行 `ue()`：`o.setPrompt("Cut relay "+V.short,Fo(V.t))`）、击杀流 `<b>GULL/HOUND</b> destroyed` + `<em>Weak point</em>`（6076 行偏移 ~11131 事件订阅）。

**boot 加载文案**（QC 内 `Nr` 调用，6182 行）：`Waking the renderer / Mixing paint, rust and rain / Stacking containers / Raising the cranes / Flooding the apron / Loading tracers and smoke / Checking the rifle / Waking the Harbormaster / Waiting for first light / Ready`（进度 .04/.12/.34/.5/.58/.66/.74/.82/.92/1）。致命错误前缀 `Saltline could not start: `（`bM`，6182 行）。

**input 描述文案**（5928 行 `describeMode`）：`Touch controls active` / `Mouse capture unavailable — move the mouse to look, rest it at a screen edge to keep turning · click fires · arrows or IJKL also turn`；音频 debug 名单/名称无需翻译。

---

## 8. 调试钩子

### 8.1 URL 参数（QC 及各模块读取）

| 参数 | 行为 | 出处 |
|---|---|---|
| `bench`（或 `#bench`） | 强制 `noaudio=1&autostart=1`，禁用玩家控制，沿 cinematicPath 巡航测帧率，输出 `#bench` pre 层（GPU/分辨率/平均帧/中位/p99/errors/stats） | 6182 行 QC 开头 + `eP` |
| `shot` | 截图/定帧模式：quality=test、自动 start（`i.shot||i.autostart → t.game.start({skipIntro:!0})`）、跳过鼠标锁定 | 6182 行 |
| `cam=x,y,z,lx,ly,lz` | 固定相机位置与注视点（每帧 `camera.position.copy(s.pos);camera.lookAt(s.look)`）；`cam=` 空值清除 | 6182 行 `o()`/`__setShot` |
| `fov` | 覆盖相机 FOV | 6182 行 `o()` |
| `exposure` | 覆盖渲染曝光 | 6182 行 `o()` |
| `show=name` | showcase 模式（见 8.3） | 6182 行 `n=i.show&&gM[i.show]` |
| `q=test|low|medium|high|ultra` | 画质预设（shot 模式默认 test） | 6182 行 `zy(i.q||(i.shot?"test":""))` |
| `seed=4207` | 世界随机种子 | 6182 行 `il(+(i.seed||4207))` |
| `eseed=9001` | 敌人随机种子 | 6054 行 `Em`：`il(+(i.params&&i.params.eseed||9001))` |
| `noaudio` | 音频 stub（`dr.audio()`） | 6182 行 |
| `autostart` | 跳过标题直接 `game.start({skipIntro:!0})` | 6182 行 |
| `noweapon` | `t.weapon.setVisible(!1)` | 6182 行 |
| `dt` | 固定步长（`i.dt&&(p=+i.dt)`） | 6182 行主循环 |
| `post=0` / `ao=0` / `vol=0` / `bloom=0` / `mb=1` | 关后期链 / 关 AO / 关体积雾 / 关泛光 / 强开运动模糊 | 4733 行 Hg：`e.post!=="0"…e.ao==="0"&&(i.quality.ao=!1),e.vol==="0"&&(i.quality.volSteps=0),e.bloom==="0"&&(i.quality.bloom=!1),e.mb==="1"&&(i.quality.motionBlur=!0)` |
| `wet=0..1` | 材质湿度覆盖 | 5442 行 `Gg`：`r={wet:{value:t.wet!==void 0?+t.wet:1}}` |
| `names=a,b,c` | props showcase 只显示指定道具 | 5442 行 `AA()`：`i.params.names?i.params.names.split(",")` |

### 8.2 window 全局

| 全局 | 用途 | 行号 |
|---|---|---|
| `__G` | 游戏上下文 t（THREE/params/events/rng/time/quality+全部模块） | 6182 行 `window.__G=t` |
| `__errors` | 错误数组（`window.onerror` + 包装 `console.error`，截 400 字符） | 6182 行 `window.__errors=[]` 及包装 |
| `__stats()` | `{…render.stats(), fps, state}` | 6182 行 |
| `__setShot({cam,fov,exposure})` | 运行时相机/曝光覆盖（cam="," 分隔 6 数） | 6182 行 |
| `__frames / __ready` | QA 探针（第 2 帧后 `__ready=!0`） | 6182 行 `window.__frames=0;window.__ready=!1;…window.__frames===2&&(window.__ready=!0)` |
| `__fatal` | 致命错误串 + `#fatal` 层 | 6182 行 `bM` |

### 8.3 showcase 注册表 `gM`（6182 行偏移 17694）

```js
var gM={mats:qg, level:cv, backdrop:mv, ground:vv, fx:Sv, weapon:Xv, enemies:ex, props:$g, render:Vg}
```
9 个模式：`?show=mats`（材质球）、`level`（关卡相机 `cam:[-32,1.7,6],target:[0,2.4,6.4]`，5442 行 `mR`）、`backdrop`、`ground`、`fx`（发射器 demo：`addEmitter(-6.2,.05,-1.5,"steam")…`，5928 行）、`weapon`、`enemies`、`props`（道具铺排 `AA`，5442 行）、`render`（`Vg={create:Hg,showcase:sA}`，`sA` 4733 行偏移 21754：盒子矩阵场景）。showcase 分支只建 stub level（`t.level={stub:!0,playerStart:{pos:new W(0,0,4),yaw:0},objectives:[],…}`，6182 行 QC 内）。

---

## 9. 敌人系统（Em，6054 行偏移 60910）

### 9.1 配置表（6054 行）

```js
Zv={hp:45,boltDamage:7,boltSpeed:70,burst:3,burstGap:.12,telegraph:.55,cooldown:[1.9,3.3],
    rangeMin:12,rangeMax:25,altMin:4,altMax:8,maxSpeed:8,patrolSpeed:3,accel:11,
    spreadFar:.065,spreadNear:.018,fireRange:42,explodeRadius:3,explodeDamage:30}   // Gull
Kv={hp:140,shotDamage:5,burst:4,burstGap:.11,telegraph:.5,cooldown:[1.8,3],
    runSpeed:4.5,stalkSpeed:2,patrolSpeed:1.5,accel:7,turnRate:2.5,rangeMin:8,rangeMax:18,
    spreadFar:.12,spreadNear:.045,lungeRange:3,lungeDamage:15,lungeCooldown:3.5,lungeSpeed:9.5,
    replan:.6,smokeBelow:.4}                                                          // Hound
Ui={gull:Zv,hound:Kv,sightRange:45,sightCone:200,loseSight:4,searchTime:8,hearRadius:45,
    maxTokens:2,maxTokensCrowd:3,tokenGap:1.25,exposureUp:.1,exposureDown:.45,
    poolGulls:10,poolHounds:8,maxWrecks:5,maxBolts:32}
```
- 感知：距离 `sightRange=45` + 视锥 `sightCone=200°`（`BC=Math.cos(Ui.sightCone/2*Math.PI/180)`）+ 听觉半径 45；`exposureUp/Down` 为玩家暴露度累积速率；**射击令牌**（maxTokens 2 / crowd 3）防止齐射。
- 材质：`armor_white/gunmetal` triplanar + 发光眼（`glow/lens/disc`）+ 视锥指示 shader（`u.uColor/uGain` 自定义 zn，6054 行 Em 开头）。

### 9.2 生成：依赖关卡数据的方式

- **不读 zones**。game 侧 `Q(type,{minDist,from,preferHidden})`（6182 行）从 **`level.enemySpawns`** 按类型过滤：`N(P){let V=P==="gull"?"air":"ground",Y=s&&s.enemySpawns||[],L=Y.filter(Z=>Z.type===V);return L.length?L:Y}`。
- 评分选点：`I+=R>=V?2+…:-(V-R)/4`（距离惩罚 minDist=Yi.spawnFar=18）+ `preferHidden` 时 `physics.lineOfSight(spawnPos→player.eye)` 不可见 +2.5 + 6 秒重用惩罚 -3 + 随机 0–1.5；落地类再 `physics.nav.isWalkable` 校验 + ±1.2m 抖动；Gull 最低高度 `fe.y=6+i.rng()*3`。
- 巡逻：`ie()` 开局 `Yi.patrol={gull:2,hound:1}`；波次：`F(cut)` 取 `Yi.waves[cut]`（`[{gull:3,hound:1},{gull:3,hound:2},{gull:4,hound:3}]`）交错入 `c.queue`（`at=c.time+1.6+fe*Yi.spawnStagger(.85)`），并 `o.warn("Contact — "+jC[方位],3.4)`；上限 `maxAlive=9`；全切后追猎波 `pursuitEvery=7s, pursuitExtra=5`（6182 行 `X()`）。

### 9.3 AI 与导航

- **Gull（Zv）**：无地面导航，纯 steering——目标点绕圈（`orbitR` 在 rangeMin–rangeMax 随机、`orbitDir` 每 3–8s 翻转，6054 行偏移 ~37600 `d.orbitR=bl(d.orbitR+(o()-.5)*6,Pn.rangeMin+1,Pn.rangeMax-2)`）；丢失目标 >1.5s 去 lastKnown；**避障靠射线**：下视 2.4m（`s.physics.raycast(d.pos,J_,2.4)`）、上视 4m（`Hf`），三轴速度反推（6054 行偏移 ~38900 `for(let P=0;P<3;P++){…Z=s.physics.raycast(d.pos,Bs,…);Z&&(d.vel.setComponent(P,-V*.25)…}`）；攻击为 telegraph 后三连发电弹 bolt（`boltSpeed=70`，对象池 `maxBolts=32`），死亡原地爆炸（explodeRadius 3 / explodeDamage 30）。
- **Hound（Kv）**：**用导航栅格**——`M()` 每 `replan=.6s` 调 `s.physics.nav.findPath(m.pos,m.goal)`（A*），随后路点跟随（<0.55m 切下一个），转向速率限制 `turnRate=2.5`（6054 行偏移 ~47420）；射击位评分遍历 **`level.coverPoints`** + `nav.randomPoint(pos,rangeMax)` 候选：距离/朝向一致性/同伴分散/`lineOfSight` 可见性加分（6054 行偏移 ~48260 `G(j[Q],-2)` 循环 coverPoints）；近身扑击 lunge。
- **combat 接口**：`i.enemies.raycast(o,d,maxDist)` 返回 `{enemy,part:"body"|"weak",point,normal,dist}`（weak 部位伤害 ×2.2，5928 行 zv：`u=c.part==="weak"?2.2:1`）；命中部位由每敌 hitbox 定义（6054 行 damage 内 `G==="weak"?1.6:1` 的击退系数差异等）。

### 9.4 改造场景时必须保持的接口

1. `level.enemySpawns[].type` 必须仍是 `"ground"|"air"`，且 gull=air / hound=ground 的映射在 game `N()`（6182 行）硬编码。
2. `level.coverPoints` 位置数组（Hound 射击位）需随场景更新，且点应在导航栅格可达范围（函数会用 `nav.isWalkable` 修正，但移动过远会失效）。
3. `physics.nav`（0.5m 栅格，障碍由 `physics.boxes` 烘焙）：**碰撞盒必须用 addBox 注册**（不建 nav 用 `noNav:!0`，纯子弹阻挡用 `bulletOnly:!0`）；`build()` 在 level+ground 装载后调用（6182 行 QC）。
4. `physics.lineOfSight / raycast / groundHeight` 是敌人感知/避障/落点唯一依赖。
5. `level.interiorBoxes`（体积雾室内尘土/武器湿润/地面湿气共用 `[0]`，fx 用前 4 个）。
6. `level.groundSurfaceAt(x,z)`（脚步/命中音效表面）与 `ground.wetnessAt/isPuddle`（脚步变体）。
7. 敌人生成依赖 `i.rng`（seed 参数），改世界布局时注意 spawn 点与掩体一致。

---

## 10. 水面

**已有实现**：
- **海面 mesh**：ground `O1`（5814 行偏移 2339）内 `g=kb(i,p)`（sea 网格 + `g.skirt` 裙边防侧面穿帮），`seaHeight(M,E)=Lb(M,E,A)`（A 为时间累积——顶点波浪函数）；物理海平面 `oi.seaY=-1.6`（x>quayX=30 时 raycast 命中面 `surface:"water"`，5442 行 d3）。
- **平面反射**：`y=zb(i,v.uniforms,[v.mesh,g.mesh,x.rain,x.splash]); i.render.addPrePass(y.pass)`（5814 行），质量由 `quality.planar`（low 0 关闭 / medium·high .5 / ultra 1）；`setReflections(b)` 开关。
- **水面行为**：`wetnessAt`（海面区恒 1）、`isPuddle/puddleDepth`（apron 水坑）、落水判定（player 脚步 → "water"，game 的 `player:rescued` → "Hauled out of the water"）。
- 音频 `sea` loop 音色（`Go.sea:{gen:W8,sr:pl,peak:.5,loop:1,ref:10,roll:.6}`，5928 行）。

**结论与建议**：码头外的**海面已经存在**（波浪+反射+溅花）。若场景重建要加"内陆水道/积水池/船坞水线"，最合适的挂载层是 **ground 模块（O1，5814 行）**：在 `kb()`（sea 构建）旁增加新的水体网格、把新水面 AABB 加进物理 `addBox(…,{surface:"water",noNav:!0})` 让 `groundSurfaceAt` 返回 "water"（脚步/命中音效自动切换 `step_water/impact_water`），并在 `seaHeight`/`wetnessAt` 里按新区域扩展。注意 raycast 的水面命中目前**只在 x>quayX 的海侧**自动生成（5442 行 d3 `if(C<-1e-6){let F=(oi.groundY-U)/C; if(F>0&&F<w) if(q+D*F<=oi.quayX) w=F,O=1; else{let ne=(oi.seaY-U)/C;…O=2}}`），新增内陆水面必须显式加物理盒。

---

## 11. 手术路标速查

### 11.1 场景重建（换地图）
- 改动点集中在 **5442 行**（level：`C1`+区域函数 `hR`(集装箱场, c 段 42856)/`ab`(shed, c 段 18585)/`cb`(quay, c 段 38068)/`ob`(构建上下文, c 段 11522)）与 **5463 行**（backdrop）。
- 数据必须重导出：playerStart/objectives(3 relay_node 的 pos 与 object)/enemySpawns/zones/interiorBoxes/extraction/cinematicPath/coverPoints/skylights/shedLights（§2.3 字段一个不能少，QC/game/render/fx/ground 都直接读）。
- 阴影相机范围在 4733 行 Hg 内硬编码（`new W(-41,-.2,-33)…new W(72,36,34)`），换图需重调。
- 地面覆盖域 `Li={x0:-44,z0:-40,size:80}`（5814 行）与物理边界 `oi={min(-40,0,-30),max(40,30,30)}`（4180 行）配套。
- 敌人侧只需保证 §9.4 的 7 项接口。

### 11.2 画质升级
- 后期链 pass 全在 **4346–4732 行**（shader 字符串）+ **4733 行**（装配/执行）；新 pass 的插入点是 `P` 函数（4733 行偏移 5813）的 pass 顺序链与 `y.*` RT 管理（`me()` resize、`Y()` dispose）。
- AgX/ACES 曲线在 **4607–4630 行**（`slAgxContrast/slAgx/slAces`），混合比 `uAgxMix`（最终合成 uniforms，4577 行段）。
- 曝光管线：`slExposure`（4343–4345 行）× 最终 blit `toneMappingExposure=.6*exposure*(1-fade)`（4733 行 `G()` 偏移 15443）。
- 阴影升级点：mapSize/bias（4733 行 Hg）、软阴影 taps（`qy` 调用参数 `{taps,searchTaps}`，4733 行）。
- 材质分辨率：`Gg` 的 `s=Math.min(n,1024)` + `hero` 2048 通道（5442 行）；贴图函数在 `Tn`（4822–5265 行）。

### 11.3 中文化
1. **HTML**（2 处）：行 3 `<title>`、行 343–344 boot 文案。
2. **菜单模板**（6077–6181 行）：按键表 `$C/ZC`、标题/暂停/死亡/结算/设置全部内联 HTML。
3. **流程文案**（6182 行）：`_l` 台词 7 条、任务目标 `D()` 4 句、`jC` 罗盘 8 词、结算评语 6 词、提示语 3 条（"Contact—"、"Hauled out of the water"、"Relays still live…"）、设置面板 qnote 两句。
4. **HUD**（6076 行 `hM`）：`Objective`/`Relays`/`0/3` 字面量、击杀流 `destroyed`/`Weak point`。
5. **input 描述**（5928 行 `describeMode` 两句长文案）。
6. **字体**：行 5–6 的 Google Fonts 链接需换成支持中文的字体栈，并同步 5283 行字体常量（`o3='"Big Shoulders Display",…'` 等，canvas label/decal 用它画字——**标签图集 `rb`（5442 行 c 段偏移 ~16500）与 canvas 文本材质的字体都在 JS 常量里**）。
7. 注意 CSS `letter-spacing`/`text-transform:uppercase` 对中文无效但无害；`.m-word` 的 `white-space:nowrap`（217 行）在中文标题下需复核宽度。

### 11.4 快速自检命令（重建后回归）
```
index.html?show=mats|level|backdrop|ground|fx|weapon|enemies|props|render   # 各模块独立验收
index.html?bench                                                            # 帧率基准+错误面板
index.html?shot&cam=-32,1.7,6,0,2.4,6.4                                     # 定帧截图
window.__stats(); window.__errors; window.__ready                           # 控制台探针
```

---

### 附：核验方法说明
- 行段边界：`grep -n "<script\|</script>\|<style\|</style>"`、`awk '{if(length($0)>2000)…}'`（巨行清单）。
- 函数定位：`grep -on "function Hg|Gg|d3|Yg|C1|pv|O1|Cf|c_|x_|zv|dm|Em|hM|mM|v_|eP"` + 对 180KB/141KB/62KB 巨行用 `awk substr` 按字节偏移切片阅读。
- 常量值：直接 `grep -o "Mn={[^}]*}"` 等提取原文。
- 唯一未能进一步下钻的部分：three.js 引擎包内部（349–4179 行）按任务要求仅标注边界未逐行阅读；其中与游戏相关的 three.js 枚举值（toneMapping/shadowMap 类型映射）已通过 349 行导出表与 4180 行定义交叉核验。
