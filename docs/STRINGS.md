# 《盐线》（SALTLINE）玩家可见文案盘点与本地化对照表

> 源文件：`C:/Users/Administrator/Desktop/youxi/saltline-original/index.html`（6193 行，单文件浏览器 FPS，雨天集装箱码头）
> 产出目标：`resort-island-shipyard`（度假岛·船厂区）
> 盘点方法：`grep -n` 检索 `textContent / innerHTML / document.title / OBJECTIVE / RELAY / DEPLOY / CUT / SETTINGS / CONTROLS / label(` 等关键词；对超长压缩行（行 349 CSS、行 5442/5928/6054/6076/6182 JS）用 `sed -n 'Np'` 导出后 `fold -w 160 -s` 分段精读核验；另用 perl 正则提取全部带空格英文短语句与全部 `label()` 标牌防遗漏。文中所有行号均指 `saltline-original/index.html`。

---

## 〇、背景改写说明（务必先读）

**新故事**：你是一名受雇的渗透员，潜入"度假岛"的**船厂区**。度假岛的安保网络由一台"安保主脑"（原 Harbormaster/港务主脑）控制。你的任务：**切断安保系统的三个上行中继站**（分别位于船坞堆场、厂棚、码头），随后赶到码头梯口**乘快艇撤离**。

- 原版的"盐线集装箱码头 / 港务局 / 4 号泊位"背景全部替换为"度假岛船厂区"语境，**玩法机制（切断 3 个中继 → 波次敌人 → 快艇撤离）完全不变**。
- 游戏名 **SALTLINE 译作《盐线》**，浏览器标签页与标题屏沿用《盐线》。
- 术语统一：**relay=中继站、uplink=上行链路、extract=撤离、drone=无人机**；Harbormaster=安保主脑；Breacher=渗透员；Gull（空中敌人）=无人机；Hound（地面敌人）=机器犬。

---

## 第一节 · 逐条翻译表

### 1. 文档元数据

| 原文 | 位置 | 语境 | 建议中文译文 |
|---|---|---|---|
| `<html lang="en">` | 行 2 | 页面语言声明 | `<html lang="zh-CN">` |
| `Saltline`（`<title>`） | 行 3 | 浏览器标签页标题 | `盐线` |

### 2. 开机与加载屏（boot）

| 原文 | 位置 | 语境 | 建议中文译文 |
|---|---|---|---|
| `SALTLINE` | 行 343（`.boot-mark`） | 加载屏大字标 | 《盐线》（LOGO 可保留英文，下方加《盐线》） |
| `Raising the terminal` | 行 344（`#boot-msg` 默认值） | 进度条初始文案 | 唤醒终端 |
| `Waking the renderer` | 行 6182（`Nr("Waking the renderer",.04)`） | 加载阶段 1 | 唤醒渲染引擎 |
| `Mixing paint, rust and rain` | 行 6182（`.12`） | 加载阶段 2（材质） | 调和油漆、铁锈与雨水 |
| `Stacking containers` | 行 6182（`.34`） | 加载阶段 3（关卡） | 吊装集装箱 |
| `Raising the cranes` | 行 6182（`.5`） | 加载阶段 4（背景） | 竖起龙门吊 |
| `Flooding the apron` | 行 6182（`.58`） | 加载阶段 5（地面） | 雨水漫上码头 |
| `Loading tracers and smoke` | 行 6182（`.66`） | 加载阶段 6（特效） | 装填曳光弹与烟雾 |
| `Checking the rifle` | 行 6182（`.74`） | 加载阶段 7（武器） | 检查步枪 |
| `Waking the Harbormaster` | 行 6182（`.82`） | 加载阶段 8（敌人 AI） | 唤醒安保主脑 |
| `Waiting for first light` | 行 6182（`.92`） | 加载阶段 9（渲染收尾） | 等待破晓 |
| `Ready` | 行 6182（`1`） | 加载完成 | 就绪 |
| `Saltline could not start: <错误>` | 行 6182（`bM()`，`#fatal`） | 致命错误提示 | 《盐线》启动失败：<错误原因> |

> 语境备注：apron=码头前沿场地；新背景中"Stacking containers / Raising the cranes"可保留（船厂区同样有集装箱与龙门吊），仅换地点词亦可，如"吊装钢构 / 竖起船台吊"。

### 3. 标题屏（m-title，行 6103–6120）

| 原文 | 位置 | 语境 | 建议中文译文 |
|---|---|---|---|
| `Saltline`（aria-label） | 行 6103 | 标题屏区块名 | 盐线 |
| `B4`（`.m-tag`） | 行 6105 | 眉头徽标（泊位/车间编号） | `B4`（保留；新背景可改 `船厂 B4`） |
| `Port Authority Breach Unit` | 行 6105（眉条第 2 段） | 玩家所属单位 | 度假岛破网小组 · 受雇作业 |
| `Saltline Terminal · 05:42`（`.m-dim`） | 行 6105 | 时间地点行 | 度假岛船厂区 · 05:42 |
| `SALTLINE`（`h1.m-word`） | 行 6106 | 大标题 | 《盐线》（建议保留英文 LOGO 字形，副标注《盐线》） |
| `The port's security net has gone feral. Cut its three uplinks. Reach the boat.`（`.m-premise`） | 行 6107 | 任务简报（副标题） | 度假岛的安保网络已经失控。切断三条上行链路，登上快艇。 |
| `Deploy`（`data-act="deploy"`） | 行 6109 | 主按钮：开始任务 | 出击 |
| `Settings` | 行 6110 | 设置按钮 | 设置 |
| `Controls` | 行 6111 | 操作说明按钮（窄屏显示） | 操作 |
| `Every surface, machine and sound is generated in your browser. Nothing is downloaded.`（`.m-note`） | 行 6113 | 底部说明文字 | 所有表面、机械与声音均在浏览器内实时生成，无需下载。 |
| `Controls at a glance`（aside aria-label） | 行 6115 | 右侧速览栏区块名 | 操作速览 |
| `W A S D Move` | 行 6116 | 速览第 1 行 | `W A S D` 移动 |
| `Mouse Look` | 行 6116 | 速览第 1 行 | `鼠标` 视角 |
| `LMB Fire` | 行 6116 | 速览第 1 行 | `左键` 开火 |
| `RMB Aim` | 行 6116 | 速览第 1 行 | `右键` 瞄准 |
| `R Reload` | 行 6116 | 速览第 1 行 | `R` 换弹 |
| `E Cut relay` | 行 6117 | 速览第 2 行 | `E` 切断中继站 |
| `Space Jump` | 行 6117 | 速览第 2 行 | `空格` 跳跃 |
| `Shift Sprint` | 行 6117 | 速览第 2 行 | `Shift` 冲刺 |
| `C Crouch` | 行 6117 | 速览第 2 行 | `C` 蹲下 |
| `Esc Pause` | 行 6117 | 速览第 2 行 | `Esc` 暂停 |
| `Touch`（`.lg-touch em`） | 行 6118 | 触屏速览标签 | 触屏 |
| `Left thumb moves` | 行 6118 | 触屏速览 | 左拇指移动 |
| `Right thumb looks` | 行 6118 | 触屏速览 | 右拇指转视角 |
| `Fire · Aim · Reload · Jump on screen` | 行 6118 | 触屏速览 | 开火 · 瞄准 · 换弹 · 跳跃为屏幕按键 |

### 4. 暂停屏（m-card / data-s="paused"，行 6122–6132）

| 原文 | 位置 | 语境 | 建议中文译文 |
|---|---|---|---|
| `Paused`（aria-label） | 行 6122 | 区块名 | 已暂停 |
| `Operation on hold`（`.m-k`） | 行 6123 | 眉头小字 | 行动暂停 |
| `Paused`（`h2.m-h`） | 行 6124 | 大标题 | 已暂停 |
| （`data-f="lookmode"` 动态行） | 行 6125 | 当前操作模式说明 | 见第 11 节 |
| `Resume`（`data-act="resume"`） | 行 6127 | 主按钮 | 继续 |
| `Settings` | 行 6128 | 设置按钮 | 设置 |
| `Controls` | 行 6129 | 操作按钮 | 操作 |
| `Restart mission`（`data-act="restart"`） | 行 6130 | 重开按钮 | 重启任务 |

### 5. 死亡屏（m-card m-dead / data-s="dead"，行 6134–6139）

| 原文 | 位置 | 语境 | 建议中文译文 |
|---|---|---|---|
| `Signal lost`（aria-label） | 行 6134 | 区块名 | 信号丢失 |
| `Breacher down`（`.m-k`） | 行 6135 | 眉头小字 | 渗透员倒下 |
| `Signal lost`（`h2.m-h`） | 行 6136 | 大标题 | 信号丢失 |
| `Time survived`（`dt`） | 行 6137 | 结算项 | 存活时间 |
| `00:00`（`data-f="dead-time"` 默认值） | 行 6137 | 时间格式 `分分:秒秒` | `00:00`（保留数字格式） |
| `Relays cut`（`dt`） | 行 6137 | 结算项 | 已切断中继 |
| `0/3`（`data-f="dead-relays"` 默认值） | 行 6137 | 数量格式 `x/3` | `0/3`（保留） |
| `Retry`（`data-act="retry"`） | 行 6138 | 主按钮 | 重试 |

### 6. 结算屏（m-card m-debrief / data-s="complete"，行 6141–6152）

| 原文 | 位置 | 语境 | 建议中文译文 |
|---|---|---|---|
| `Debrief`（aria-label） | 行 6141 | 区块名 | 任务复盘 |
| `Berth 4 · Debrief`（`.m-k`） | 行 6142 | 眉头小字 | 船厂区 · 任务复盘 |
| `Saltline is dark`（`h2.m-h`） | 行 6143 | 大标题 | 全网已熄灯 |
| `Rating`（`.m-rating span`） | 行 6144 | 评级标签 | 评级 |
| `Clean`（`b[data-f="rating"]` 默认值） | 行 6144 | 评级默认值 | 干净利落 |
| `Time`（`dt`） | 行 6146 | 结算项 | 用时 |
| `Accuracy`（`dt`） | 行 6147 | 结算项（显示 `xx%` 或 `—`） | 命中率 |
| `Machines destroyed`（`dt`） | 行 6148 | 结算项 | 摧毁机器数 |
| `Retries`（`dt`） | 行 6149 | 结算项 | 重试次数 |
| `Redeploy`（`data-act="redeploy"`） | 行 6151 | 主按钮 | 重新出击 |

> 评级词表（行 6182 `["Messy","Loud","Steady","Clean","Sharp","Surgical"]`，按用时/命中/重试计算）：
> `Messy`→狼狈 · `Loud`→大动静 · `Steady`→稳扎稳打 · `Clean`→干净利落 · `Sharp`→精准狠辣 · `Surgical`→手术刀级

### 7. 设置与操作面板（panel，行 6154–6179）

| 原文 | 位置 | 语境 | 建议中文译文 |
|---|---|---|---|
| `Settings and controls`（panel aria-label） | 行 6154 | 对话框名 | 设置与操作 |
| `Settings`（tab） | 行 6157 | 页签 1 | 设置 |
| `Controls`（tab） | 行 6158 | 页签 2 | 操作 |
| `Close`（`data-act="close-panel"`） | 行 6160 | 关闭按钮 | 关闭 |
| `Graphics quality`（`#l-q`） | 行 6163 | 画质选项 | 画质 |
| `low` / `medium` / `high` / `ultra`（`dM`，行 6076；按钮渲染于行 6164） | 行 6164 | 画质档位 | 低 / 中 / 高 / 极高 |
| `Mouse sensitivity`（`for=s-sens`） | 行 6165 | 灵敏度滑杆 | 鼠标灵敏度（输出 `1.00×`） |
| `Invert Y`（`#l-inv`） | 行 6166 | 反转选项 | Y 轴反转 |
| `Off` / `On`（toggle 内 span，行 6182 `g()` 动态写入） | 行 6166 | 开关态 | 关 / 开 |
| `Master volume`（`for=s-vol`） | 行 6167 | 音量滑杆 | 主音量（输出 `80%`） |
| `Field of view`（`for=s-fov`） | 行 6168 | 视场角滑杆 | 视场角（输出 `75°`） |
| `Display`（`#l-fs`） | 行 6169 | 显示选项 | 显示 |
| `Enter fullscreen`（`#fs-t`） | 行 6169 | 全屏按钮 | 进入全屏 |
| `Exit fullscreen`（行 6182 `E()` 动态写入） | 行 6182 | 全屏中按钮 | 退出全屏 |
| `Fullscreen is not available here`（行 6182 `_()`） | 行 6182 | 全屏失败提示 | 当前环境不支持全屏 |
| `Quality was picked for this device (high). Lower it if the frame rate struggles.`（`qnote`，行 6182 `g()`） | 行 6182 | 画质=auto 时注记 | 已为本机自动选定画质（高）。若卡顿请调低。 |
| `Quality changes apply at once; shadows and reflections may take a moment to rebuild.`（`qnote`） | 行 6182 | 手动画质注记 | 画质立即生效；阴影与反射需稍候重建。 |
| `Keyboard · Mouse`（h3） | 行 6173 | 键鼠操作区标题 | 键盘 · 鼠标 |
| 键位表 `$C`（行 6077–6089，`dl.keys`） | 行 6077–6089 | 见下表 | 见下表 |
| `If the browser will not capture the mouse, hold a mouse button and drag to look (left also fires, right also aims). Arrow keys or I J K L turn, Enter fires.`（panel-note） | 行 6174 | 键鼠备注 | 若浏览器无法捕获鼠标，可按住鼠标拖动转视角（左键仍开火、右键仍瞄准）。方向键或 `I/J/K/L` 转身，`Enter` 开火。 |
| `Touch`（h3） | 行 6175 | 触屏操作区标题 | 触屏 |
| 触屏表 `$ZC`（行 6090–6098，`dl.keys`） | 行 6090–6098 | 见下表 | 见下表 |
| `Gamepad`（h3） | 行 6176 | 手柄区标题 | 手柄 |
| `Sticks move and look · RT fire · LT aim · A jump · B crouch · X reload · Y cut relay · L3 sprint · Start pause.`（panel-note） | 行 6177 | 手柄说明 | 双摇杆移动与视角 · RT 开火 · LT 瞄准 · A 跳跃 · B 蹲下 · X 换弹 · Y 切断中继站 · L3 冲刺 · Start 暂停。 |

**键鼠键位表（`$C`，行 6077–6089）**

| 原文（dt / dd） | 语境 | 建议中文译文 |
|---|---|---|
| `Move` / `W A S D` | 移动 | 移动 / `W A S D` |
| `Look` / `Mouse` | 视角 | 视角 / 鼠标 |
| `Fire` / `Left button` | 开火 | 开火 / 鼠标左键 |
| `Aim` / `Right button` | 瞄准 | 瞄准 / 鼠标右键 |
| `Reload` / `R` | 换弹 | 换弹 / `R` |
| `Cut relay` / `Hold E` | 切断中继站 | 切断中继站 / 按住 `E` |
| `Jump` / `Space` | 跳跃 | 跳跃 / `空格` |
| `Sprint` / `Shift` | 冲刺 | 冲刺 / `Shift` |
| `Crouch` / `C or Ctrl` | 蹲下 | 蹲下 / `C` 或 `Ctrl` |
| `Melee` / `F` | 近战 | 近战 / `F` |
| `Pause` / `Esc or P` | 暂停 | 暂停 / `Esc` 或 `P` |

**触屏键位表（`$ZC`，行 6090–6098）**

| 原文（dt / dd） | 语境 | 建议中文译文 |
|---|---|---|
| `Move` / `Left thumb, anywhere` | 移动 | 移动 / 左拇指，任意区域 |
| `Look` / `Drag the right side` | 视角 | 视角 / 拖动屏幕右侧 |
| `Fire` / `Hold FIRE, drag to track` | 开火 | 开火 / 按住"开火"并拖动追踪 |
| `Aim` / `AIM toggles` | 瞄准 | 瞄准 / 点"瞄准"切换 |
| `Reload` / `RLD` | 换弹 | 换弹 / `换弹`键 |
| `Jump` / `JUMP` | 跳跃 | 跳跃 / `跳跃`键 |
| `Cut relay` / `Hold USE at a relay` | 切断中继站 | 切断中继站 / 在中继站处按住"使用" |
| `Sprint` / `Push the stick fully forward` | 冲刺 | 冲刺 / 摇杆向前推满 |

### 8. HUD（行 6076 `hM()` 动态构建）

| 原文 | 位置 | 语境 | 建议中文译文 |
|---|---|---|---|
| `N / NE / E / SE / S / SW / W / NW`（`GC` 映射表，行 6076） | `.h-tape` 指南针刻度 | 罗盘方位字母 | 北 / 东北 / 东 / 东南 / 南 / 西南 / 西 / 西北（若保留单字母军事惯例，可维持 N/E/S/W 并在图例注明） |
| `000 / 015 / 030 … 345`（`padStart(3)`，每 15° 一格） | `.h-tape` 刻度数字 | 度数刻度 | 保留（数字通用） |
| `000`（`.h-heading` 初始值） | 指南针读数 | 当前朝向度数 | 保留（数字通用） |
| `Objective`（`.h-obj .h-k`） | 行 6076 | 目标栏标签 | 任务目标 |
| `Cut the three uplink relays`（行 6182 `D()`） | `.h-obj-t` 目标文本 | 初始目标 | 切断三个上行中继站 |
| `Cut the remaining N relays`（行 6182 `D()`） | `.h-obj-t` | 中期目标 | 切断剩余 N 个中继站 |
| `Cut the last relay`（行 6182 `D()`） | `.h-obj-t` | 仅剩 1 个时 | 切断最后一个中继站 |
| `Get to the boat`（行 6182 `D()`） | `.h-obj-t` | 全部切断后 | 前往快艇撤离 |
| `Relays`（`.h-relays span`） | 行 6076 | 中继计数标签 | 中继站 |
| `0/3`（`.h-relays b`，动态 `${done}/${total}`） | 行 6076 | 计数 | 保留（数字） |
| `Vitals`（`.h-health .h-k`） | 行 6076 | 生命栏标签 | 生命体征 |
| `100`（`.h-hp-n` 初始值） | 行 6076 | 血量数字 | 保留（数字） |
| `30` / `120`（`.h-ammo-n` / `.h-ammo-r` 初始值） | 行 6076 | 弹匣/备弹 | 保留（数字） |
| `PAC-9 Longshore`（`mi.name`，行 5928 偏移 ≈112886；写入 `.h-wname`，行 6182 `ve={name:mi.name…}`） | 行 5928/6076 | 武器名 | `PAC-9 岸勤型`（型号保留，Longshore=码头装卸工，意译"岸勤型"；亦可将"岸勤型"改"码头工型"） |
| `Reloading`（`.h-cue`） | 行 6076 | 换弹提示 | 换弹中 |
| `R — Reload`（桌面端空匣） | 行 6076 | 空匣提示 | `R —— 换弹` |
| `Reload`（触屏端空匣） | 行 6076 | 空匣提示（触屏） | 换弹 |
| `Empty` | 行 6076 | 无备弹提示 | 弹尽 |
| `Low ammo` | 行 6076 | 低弹量提示 | 弹药不足 |
| `E`（`.h-key` 默认值；动态：触屏 `USE`、手柄 `Y`，行 6076 `setPrompt`） | 交互提示键位 | 交互键 | `E`；触屏键面译"使用"，手柄 `Y` 保留 |
| `Hold E — Cut relay A`（模板 `` `Hold ${key} — ${text}` ``，text=`` "Cut relay "+short ``，行 6182 `ue()`） | `.h-plabel` 长按提示 | 交互提示 | 按住 `E` —— 切断 A 号中继站 |
| `GULL destroyed`（模板 `` `<b>${type}</b> destroyed` ``，type 由 `gull/hound` 大写；缺省 `machine`） | 行 6076 击杀播报（`.h-feed`） | 击杀信息流 | 无人机已摧毁 / 机器犬已摧毁 / 机器已摧毁 |
| `Weak point`（`<em>` 追加） | 行 6076 弱点击杀 | 弱点提示 | 弱点击破 |
| `Control`（`.comms-who`） | 行 6076 | 无线电发话方 | 指挥部 |
| `Relay A — Yard` / `Relay B — Shed` / `Relay C — Quay`（关卡数据 `label`，行 5442，`zone:"yard/shed/quay"`）；`Boat`（撤离标记 `label`，行 6182 `q()`，`short:"EX"`）；HUD 缺省 `"Relay "+short` | 3D 标签 + `.h-wm` 屏幕标记 | 世界标记名 | 中继站 A —— 船坞堆场 / 中继站 B —— 厂棚 / 中继站 C —— 码头 / 快艇 |
| `A / B / C / EX`（标记缩写字 `short`，`EX`=extract） | `.h-cm` / `.h-wm` 标记字母 | 指南针/屏幕标记 | `A / B / C / 撤`（EX 亦可保留） |
| `123m`（距离模板 `${m}m`） | 标记距离 | 距离读数 | 保留（`123m` 可作 `123 米`，建议保留 `m`） |

### 9. 无线电字幕（原文台词，`_l` 常量，行 6182；逐字打字机效果于行 6076 `ae()`）

| 原文 | 触发点 | 建议中文译文（正式版，见第二节风格版） |
|---|---|---|
| `Breacher, this is Control. The Harbormaster holds the berth. Cut its three uplinks — yard, shed, quay.` | 任务开场 1.3 秒后 | 渗透员，这里是指挥部。安保主脑控制着船厂区。切断它的三条上行链路——堆场、厂棚、码头。 |
| `It has seen you. Gulls fly, Hounds walk. Put them down.` | 首次触发警报 | 它发现你了。无人机上天，机器犬上街。全部放倒。 |
| `One relay dark. It felt that — machines inbound.` | 切断第 1 台 | 一台中继熄火。它察觉到了——机器正在逼近。 |
| `Two dark. It is throwing everything it has left at you.` | 切断第 2 台 | 两台瘫痪。它把剩下的家底全压向你了。 |
| `All three dark. The boat is holding at the quay ladder, south end. Run.` | 三台全部切断 | 三台全灭。快艇停在码头南端梯口。快跑。 |
| `You are hit hard. Get behind steel and breathe.` | 血量首次低于 30 | 你伤得不轻。躲进钢板后面，喘口气。 |
| `Breacher is aboard. Saltline is dark. Good work.` | 登艇、任务完成 | 渗透员登艇。全网熄灯。干得漂亮。 |

### 10. 警告 / 消息（HUD 顶部红字与中部提示）

| 原文 | 位置 | 语境 | 建议中文译文 |
|---|---|---|---|
| `Contact — NORTH / NORTH-EAST / EAST / SOUTH-EAST / SOUTH / SOUTH-WEST / WEST / NORTH-WEST`（模板 `` "Contact — "+jC[...] ``，`jC` 行 6182） | 行 6182 `F()` → `.h-warn` | 每波敌人来袭方向警告 | 发现敌人 —— 北面 / 东北 / 东面 / 东南 / 南面 / 西南 / 西面 / 西北 |
| `Hauled out of the water` | 行 6182 `player:rescued` → `.h-msg` | 落水被救回 | 已把你拖回岸上 |
| `Relays still live — the boat will not wait under fire` | 行 6182 `ue()` → `.h-msg` | 未切完中继就到撤离点 | 中继站仍在工作 —— 快艇不会在炮火里干等 |

### 11. 操作模式提示（`describeMode()`，行 5928 偏移 ≈93219；显示于暂停屏与画面中部）

| 原文 | 语境 | 建议中文译文 |
|---|---|---|
| `Touch controls active` | 触屏模式 | 触屏操控已启用 |
| `Mouse capture unavailable — move the mouse to look, rest it at a screen edge to keep turning · click fires · arrows or IJKL also turn` | 无法锁定鼠标（拖拽模式） | 无法锁定鼠标——移动鼠标转视角，靠住屏幕边缘可持续转向 · 点击开火 · 方向键或 `I/J/K/L` 也可转向 |
| `Mouse captured — Esc releases it` | 鼠标已锁定 | 鼠标已锁定 —— 按 `Esc` 释放 |
| `Click the view to capture the mouse` | 待锁定 | 点击画面锁定鼠标 |

### 12. 触屏按钮（行 5928 偏移 ≈96157，`.t-btn`）

| 原文（键面 span / aria-label） | 语境 | 建议中文译文 |
|---|---|---|
| `FIRE` / Fire | 开火按钮 | 键面"开火"（字数受限可保留 FIRE） |
| `AIM` / Aim | 瞄准切换 | 键面"瞄准"（可保留 AIM） |
| `RLD` / Reload | 换弹 | 键面"换弹"（可保留 RLD） |
| `JUMP` / Jump | 跳跃 | 键面"跳跃"（可保留 JUMP） |
| `USE` / Interact | 交互/切断 | 键面"使用" |
| `II` / Pause | 暂停（图标 Ⅱ） | 保留 Ⅱ 图形 |

### 13. 武器贴图刻字（canvas 纹理，行 5928 偏移 ≈138400–139200；PAC-9 枪身涂装）

| 原文 | 语境 | 建议中文译文 |
|---|---|---|
| `PAC-9` | 枪身大字型号 | `PAC-9`（保留） |
| `LONGSHORE ARMS WORKS · SALTLINE` | 制造商行 | 长岸兵工厂 · 盐线（新背景可改：度假岛安保装备处） |
| `CAL 5.8×40   SN PA-004217` | 口径与枪号 | `CAL 5.8×40   枪号 PA-004217` |
| `PROPERTY OF PORT AUTHORITY — BERTH 4 ARMOURY` | 财产铭牌 | 港务局财产 —— 4 号泊位军械库（新背景：度假岛安保部财产 —— 船厂区军械库） |
| `S` / `1` / `A`（保险/单发/连发档位） | 快慢机刻字 | 保 / 单 / 连 |
| `B4-07`（`rack` 大字）与 `T2 / T4 / T6 / T8 / T10 / T12` | 枪架编号 | `B4-07`、`T2…T12`（保留编号） |
| `HX-2 REFLEX` | 瞄具型号 | `HX-2 反射式瞄具` |
| `900 LM  IPX8` | 战术灯参数 | `900 流明  IPX8` |
| `WARNING — CLEAR CHAMBER BEFORE STOWAGE. AUTHORISED BREACH PERSONNEL ONLY. PA-REG 44/7` | 枪身警示三行 | 警告 —— 入库前清空膛室。仅限破网作业授权人员。港务条例 PA-44/7 |

### 14. 3D 场景标牌（`mats.label()` / `i.label()` canvas 贴图，perl 全量检索）

| 原文 | 语境 | 建议中文译文 |
|---|---|---|
| `SALTLINE` | 大门/塔台品牌大字 | 盐线（新背景换"RESORT ISLAND"） |
| `SALTLINE 04` | 门牌编号 | 盐线 04 号（新背景：度假岛 04 号区） |
| `SALTLINE TERMINAL  B4-0271` | 集装箱箱体喷涂 | 盐线码头 B4-0271（新背景：度假岛船厂 B4-0271） |
| `BERTH 4 WORKSHOP` | 车间墙字 | 4 号泊位车间（新背景：船厂车间） |
| `BOAT STN 4` | 快艇站标牌 | 4 号快艇站 |
| `LANE 1 / LANE 2 / LANE 3` | 车间通道地面/柱标 | 1 号通道 / 2 号通道 / 3 号通道 |
| `DANGER` | 危险标牌 | 危险 |
| `KEEP CLEAR` | 地面禁停字 | 保持畅通 |
| `MAX GROSS 30480 KG` | 集装箱限重 | 最大总重 30480 千克 |
| `MAX 2500 kg` | 吊架限重 | 最大承重 2500 千克 |
| `UN 1202` | 危险品编号（柴油） | 联合国编号 1202 |
| `DIESEL` | 油罐标识 | 柴油 |
| `LPG` | 气罐标识 | 液化气 |
| `IBC 1000 L` | 集装桶标识 | IBC 集装桶 1000 升 |
| `API 5L X52  273.1 x 12.5  HEAT 40719` | 管材钢印 | 保留原文（工业钢印，属美术细节） |
| `EUR` / `G-XX` / `H-XX` | 集装箱箱主代码 | 保留原文（箱主代码惯例） |
| `KITTIWAKE` | 船名 | 保留"KITTIWAKE"或译"三趾鸥号" |

> 附注一（不属于玩家文案，未翻译）：THREE.js 控制台警告（`THREE.Color: …` 等，行 5928 内）仅输出到 console；`?bench=1` 调试覆盖层（行 6183–6189，`SALTLINE BENCH / GPU: / buffer / frame ms avg / stats / errors`）与 `window.__stats` 为开发者工具。
> 附注二（数值默认值无需翻译）：`00:00`、`0/3`、`0%`、`—`（行 6137/6144/6146–6149）、HUD 初始 `100 / 30 / 120 / 000`（行 6076）。

---

## 第二节 · 中文无线电台词表（speechSynthesis zh-CN 播报）

**播报设定**：发话方呼号显示为"**指挥部**"（对应 `.comms-who`，原 `Control`）；全部走 `speechSynthesis`，`lang="zh-CN"`，建议 `rate 1.05–1.15`、单线打断式播报（新线覆盖旧线），字幕照常打字机显示。

| # | 使用时机 | 台词 | 字数 | 建议性别/语气 | 对应原文 |
|---|---|---|---|---|---|
| 1 | 任务开始（开场 1.3 秒） | 渗透开始。三条上行链路，逐一切断。 | 14 | 男声，低沉冷静 | `_l.intro` |
| 2 | 任务开始（补充，进场 5 秒未接敌） | 你已进场，安保主脑还没发现你。 | 13 | 女声，镇定 | `_l.intro` 备选 |
| 3 | 接近中继站（8 米内首达） | 中继站就在前面，找接口，按住别松。 | 15 | 女声，急促 | 新增 |
| 4 | 接近中继站（附近有敌人巡逻） | 它盯着这台中继，切之前先清场。 | 13 | 男声，警觉 | 新增 |
| 5 | 切断第 1 个中继 | 第一台熄火。它察觉了，机器正在过来。 | 16 | 男声，急促 | `_l.cut[0]` |
| 6 | 切断第 2 个中继 | 第二台瘫痪。还剩最后一台，顶住。 | 14 | 女声，绷紧 | `_l.cut[1]` |
| 7 | 切断第 3 个中继 | 三台全灭。全网瘫痪，快艇在等你。跑！ | 16 | 男声，提速喝令 | `_l.all` |
| 8 | 被无人机锁定/追击 | 无人机咬住你了，找掩体，别停。 | 13 | 女声，拉警报感 | 新增（`enemy:alert` 空中型） |
| 9 | 被机器犬追击 | 机器犬贴上来了，边退边打。 | 12 | 男声，急促 | 新增（`enemy:alert` 地面型） |
| 10 | 低血量（首次 <30） | 你伤得很重，躲到钢板后面喘口气。 | 14 | 女声，关切而克制 | `_l.low` |
| 11 | 击毁敌人（无人机） | 空中的哑了，干得不错。 | 10 | 男声，短促赞许 | 新增（`enemy:killed` gull） |
| 12 | 击毁敌人（机器犬） | 机器犬趴窝了，继续推进。 | 11 | 男声，短促 | 新增（`enemy:killed` hound） |
| 13 | 全部中继完成（广播） | 安保网络下线。撤离窗口，现在开启。 | 15 | 男声，宣告式 | `objective:all` |
| 14 | 撤离开启/导航提示 | 快艇停在码头南端，梯子那儿。快走。 | 15 | 女声，催促 | `_l.all` 备选 |
| 15 | 任务完成（登艇） | 你已登艇，全网静默。干得漂亮。 | 13 | 男声，释然收尾 | `_l.done` |
| 16 | 任务失败（死亡） | 信号丢失……渗透员，请回话。 | 12 | 女声，压低、迟疑 | `player:dead` |
| 17 | 环境闲聊（开局 20 秒未接敌） | 雨一直下，正好盖住你的脚步。 | 13 | 女声，松弛 | 新增 |
| 18 | 环境闲聊（波次间隙） | 度假岛夜里巡逻比平时密，小心。 | 14 | 男声，闲聊带提醒 | 新增 |
| 19 | 环境闲聊（撤离途中） | 潮涨了，快艇贴着梯口晃，别磨蹭。 | 14 | 女声，闲聊 | 新增 |

> 语气基调：军事 FPS 硬朗短句，动词开头、少虚词；紧急线（5/7/8/9/14）语速可再 +0.1，闲聊线（17/18/19）语速 -0.05。
