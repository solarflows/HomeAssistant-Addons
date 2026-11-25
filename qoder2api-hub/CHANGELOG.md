### 1.10.1 (2026-11-25)

#### v1.10.1 — HungerG 活动模型与排队提示

- 新增国际版限时匿名模型 HungerG：目录展示为 0 倍率、支持低/中/高/最大思考档位，并仅按国际区路由。官方动态清单暂未列出该模型时，在活动截止（2026-11-30 24:00，UTC+8）前保留条目；截止后自动隐藏，不覆盖官方清单。国内区与团队/企业账号是否可见仍以官方返回为准。
- 账号测试遇到上游 10605/RESOURCE_LIMIT 排队时，接口明确标记 `queued`，面板显示「测试未完成」而不是「测试失败」；不改变上游排队、冷却或账号轮换策略。

[完整变更](https://github.com/shuishuipingan/qoder2api-hub/compare/v1.10.0...v1.10.1)

---

### 1.10.0 (2026-11-24)

#### v1.10.0 — 独立网页抓取与 Anthropic 思考输出

- 合并修正后的 PR #169（感谢 @blowingwind05）：WebFetch 可独立选用网关直连、Qoder 官方或管理员配置的 HTTP JSON 服务；默认沿用原行为。外部服务须报告实际最终 URL，并负责每次连接和重定向的公网限制。更换端点来源不会沿用旧密钥，临时环境覆盖不会写入持久设置。
- 合并修正后的 PR #170（感谢 @zjzhang-cn）：普通和托管 Anthropic Messages 统一思考输出策略和用量；新增 `thinking_tokens` 并保留 `reasoning_tokens`。SSE 提前结束思考块再发送正文或工具，不为了迟来的思考阻塞首字。兼容块的空签名不是 Anthropic 原生签名。
- 修复 #171 的网关侧缺陷：明确的 `Cannot find model` 模型解析拒绝不再重放、轮换或冷却账号；HTTP 与 SSE 都会保留失败结果，诊断不记录请求正文。没有修改用户或系统提示。

[完整变更](https://github.com/shuishuipingan/qoder2api-hub/compare/v1.9.14...v1.10.0)

---

### 1.9.14 (2026-11-23)

#### v1.9.14 — Anthropic 网关联网工具

- 合并修正后的 PR #165（感谢 @blowingwind05）：启用网页工具后，Anthropic `/v1/messages` 支持网关托管的 WebSearch 与 WebFetch；默认开关不变，客户端自带工具仍由客户端执行。
- 支持流式和非流式输出、按原顺序保留工具前文本与混合工具调用。同批有客户端调用时，待客户端提交工具结果后再继续；待续批次保留在当前网关进程，需在 10 分钟内续传并通过当前路由及账号检查。
- 执行命名工具、`none`、`any` 选择约束，并限制单工具额度、跨轮输出预算和待续轮数。空工具名、无效或超额输出用量不会触发新工具调用。保留对缺用量环境的保守预算估算，不将估算计为真实用量。

[完整变更](https://github.com/shuishuipingan/qoder2api-hub/compare/v1.9.13...v1.9.14)

---

### 1.9.13 (2026-11-21)

#### v1.9.13 — 签到状态修正与可选默认提示词

- 修复 #167 中排查到的网关误判：未明确标注已领取的 `HTTP 409` 和通用 `BLOCKED` 不再记成已签到；活动未开放、风控限制及风控服务异常不再误报为新人任务未完成。已明确拒绝的活动不改走旧接口再次领取。保留真正的已领取、名额用尽和同人去重结果，不改变上游资格或领取策略。
- 调度日志区分实际已检查的账号数与新增积分；无符合条件的账号不再误报全员已签到。新增 52 项离线检查覆盖签到结果、兼容回退和调度。
- 合并修正后的 PR #166（感谢 @blowingwind05）：面板可以省略模板默认系统提示词，默认行为不变；非空客户端提示词和显式启动参数仍优先，Kimi 工具协议指令不受影响。修正版保护异常配置文件，处理表单刷新／保存竞态，并刷新英文翻译缓存。

[完整变更](https://github.com/shuishuipingan/qoder2api-hub/compare/v1.9.12...v1.9.13)

---

### 1.9.12 (2026-11-19)

#### v1.9.12 — 自动签到与可选联网工具后端

- 回应 #164：自动签到原已内置且默认每日09:00/21:00；面板明确显示「自动签到 / Token 保活」、服务端时区、排程入口及运行条件，不新增第二套领取任务。修复启动巡检无视持久化暂停、停止期间仍执行初始化的问题，启动等待改为可取消；显式手动巡检仍可补签。新增24项真实调度路径行为回归，保留资格过滤与当日去重。
- 合并经补充修正的 PR #159（感谢 @blowingwind05）：新增原内置 / Qoder官方 / 外部搜索三类可选后端，支持CN/INTL官方独立工具、SearXNG/Tavily/Brave/Serper/自定义HTTP JSON。保持原默认开关/后端，按服务隔离配置和密钥、请求级快照、管理接口不回显明文密钥，不在失败时静默切换后端或账号。
- Responses托管工具支持实际进度、search/open_page、来源引用与多轮用量汇总；普通function/custom/namespace在流式及非流式保留参数、ID和名称，length/content_filter以incomplete结束，保留指令与metadata/模型身份。工具预算耗尽后仍留最终合成轮；同批混合托管与客户端调用明确失败。
- 复核并保留作者的凭证隔离修正：官方签名POST禁用重定向且单次工具请求不自动重试；缓存按realm/endpoint/organization/token摘要隔离。维护者额外修复托管聚合忽略inner.error而伪报completed/执行错误帧工具的问题，新增真实HTTP前/中/后终态错误、不重放、不泄露原文回归；修正Python3.9 synthetic HTTPError fixture。
- 发布前完整整合回归：161套件全绿，4752项报告检查，另3个unittest套件分别26/14/42项全通过（不混计为4752）；工作区清洁检查通过。Linux另验自动签到24项、Responses42项、官方工具26项、后端14项。修正新套件只设环境变量却未绑定导入目录的隔离问题，防止读取真实面板Key配置而产生401。
- 官方远端抓取只能校验输入与回报最终URL，无法钉扎远端DNS或审计中间跳转；企业VPC未验证而明确拒绝，工具独立计费未核实，不承诺免费或任意站点可读。维护者验收使用离线夹具，第三方真实密钥联测范围见文档。

完整变更：https://github.com/shuishuipingan/qoder2api-hub/compare/v1.9.11...v1.9.12

---

### 1.9.11 (2026-11-18)

#### v1.9.11 — 流收尾、模型身份与面板关停

- 修复 #162：读取上游连接重置/中断/超时不再误判为客户端断开；明确流内错误并在所有 POST 退出路径终止 chunked 流。已建立流的读取失败不自动重放收费请求，客户端断开不再记为正常 chat done。新增三协议真实 HTTP 流回归98项。
- 修复 #163：成功用量增加 `requested_model` / `resolved_model` / `upstream_model_key`，上游未回报则实际身份为 null；Responses 同步上游实际 model，初始未获数据时空 model，发现后更新 in_progress。面板用量显示请求名 → 上游回报名，保留旧 model 分组兼容。新增模型身份138项与面板6项回归。
- 新增 `QD_UNKNOWN_MODEL=pass|auto|error`：默认 pass 保持 BYOK/自定义名称兼容并限频 WARN；auto 显式提交 auto；error 在收费请求前本地400。识别动态目录 key/显示名，严格模式受本地目录新鲜度限制。
- 发布前完整回归：156 个套件、4710 项检查、0 失败，工作区清洁检查通过；Linux 另验三协议流98项、模型身份138项、关停安全21项。
- PR #159 网页工具后端本轮不纳入：流式普通function丢失、length终态与账号缓存隔离边界需继续修正，审查证据已写回PR。

**✨ 合并修正后的 PR #161（感谢 @loong-git）：面板关闭网关（`POST /admin/shutdown`）**

面板此前只能「一键更新（含自动重启）」，没有任何停止入口；要停只能去跑
`stop-qoder-proxy.bat` / `.sh`。现在「设置 → 运行信息」下方新增**关闭网关**卡片。

- 安全模型与一键更新一致：**面板会话 + 仅本机来源 + 请求体显式 `{"confirm": true}`**
  （必须是布尔 true，`1` / `"true"` 一律 400，裸 POST 关不掉网关）；
  `QD_SHUTDOWN_DISABLE=1` 一键禁用，`QD_SHUTDOWN_ALLOW_REMOTE=1` 才放开远程（不建议）。
- `HTTPServer.shutdown()` 不能在运行 `serve_forever` 的**同一线程**调用（#156）；
  请求工作线程并不天然死锁。为避免阻塞响应，由独立线程延迟关闭，
  收尾走与 SIGTERM 相同的路径（`server_close()` → atexit → pid 文件清理）。
- 关停是幂等的：连点或并发只会关一次；当前进程没有监听器时返回409。维护者修正代理来源头绕过、线程启动失败状态回滚、stopping计划与前端失败误报；新增安全21项、UI10项回归，原关停42项保留。200仅确认已安排，不承诺已退出或排空在途请求。
- `GET /settings` 新增 `shutdown` 块（`can_shutdown` / `blocked_codes` /
  `blocked_reasons` / `restart_hint`），面板据此**只在可执行时才渲染按钮**
  （与 #132 的 `can_apply` 同一原则），仅在收到关停确认后停掉轮询；失败保留刷新。
- 文档：`docs/api.md` 补端点与闸门表，`docs/deployment.md` 补两个环境变量与
  「容器里更推荐 `docker compose restart`」的说明；`i18n/en.json` 补文案（version 19→20）。
- 测试：新增 `tests/_test_admin_shutdown.py`（42 条：三层闸门、confirm 类型、
  禁用/远程开关、plan 可执行性与 code、真实关停后端口释放、幂等、源码接线与文档同步）。



完整变更：https://github.com/shuishuipingan/qoder2api-hub/compare/v1.9.10...v1.9.11

---

### 1.9.10-build.3 (2026-11-18)

CI 工作流维护
- 自动化构建流水线与容器发布底座例行维护

---

### 1.9.10-build.2 (2026-11-18)

Dockerfile + patches 维护
- refactor(patches): centralize apply-patches.sh via build-contexts and auto-map /src/<repo> [skip-rebuild]

---

### 1.9.10-build.1 (2026-11-17)

CI 工作流维护
- feat: unify build-time hot-patching architecture and dockerfile partitioning

---

### 1.9.10 (2026-11-16)

#### v1.9.10 — 持续排队诊断（#158）

- 修正 `/diag/queue` 将 HTTP 200 建流误报成功的问题：实际消费 SSE 信封，区分排队、内嵌错误和缺少完成帧的空流；探测只发一次上游请求，不静默等待/自动重试，异常路径释放并发租约。
- `/health` 新增脱敏的 `queue_observation` 聚合，按实际账号、端点和模型隔离观察；有界内存、24小时 TTL、进程内状态，成功终止仅清理匹配作用域，健康查询不触发上游请求。
- 排队诊断提供 `queue_type`、`service_available`、`retry_after`、`queue_count`；修正文案与文档，不再承诺等待后必放行，也不把 `p4`、出口类型或额度正常直接当作容量/风控结论。排队原因保持 `unknown`，不修改默认流量守卫、账号冷却或自动换区策略。
- 新增 61 项行为回归覆盖嵌套/畸形队列、采样间隔、过期淘汰、并发记账、匹配恢复、实际 HTTP/SSE 诊断和租约清理；实际备用推理网关各自独立统计，其他网关成功不会清除原队列记录。
- 发布前完整本地回归：150 个套件、4395 项检查、0 失败；新增套件 Windows / Linux 均 61/61 通过。上游持续排队根因仍需实际对照确认，不将诊断改进等同于解除上游排队。

完整变更：https://github.com/shuishuipingan/qoder2api-hub/compare/v1.9.9...v1.9.10

---

### 1.9.9-build.6 (2026-11-16)

Dockerfile 维护
- feat(healthcheck,skills): 全量标准化 Healthcheck 规约体系与智能体部署时序推导引擎

---

### 1.9.9-build.5 (2026-11-16)

Dockerfile + rootfs 维护
- feat(s6): standardize S6-rc v3 architecture, decouple alist-tvbox services, and eliminate startup race conditions

---

### 1.9.9-build.4 (2026-11-16)

rootfs 维护
- fix(addons): resolve upstream runtime parameter discrepancies and configuration faults

---

### 1.9.9-build.3 (2026-11-15)

Dockerfile 维护
- refactor(addons): complete repository-wide config streamlining, zero-option TZ, and entrypoint timezone fallback

---

### 1.9.9-build.2 (2026-11-15)

rootfs 维护
- refactor(addons): eliminate synthetic credentials and enforce zero-default service startup

---

### 1.9.9-build.1 (2026-11-15)

rootfs 维护
- refactor(addons): streamline runtime configuration, adopt zero-option TZ, and migrate to supervisor socket

---

### 1.9.9 (2026-11-13)

#### v1.9.9 — 容器退出与工具调用身份修复

- 修复 #156：默认 Python PID 1 显式处理 SIGTERM，解开监听循环、关闭 socket，并执行 atexit/PID 清理；不在同线程 signal handler 调用会死锁的 `HTTPServer.shutdown()`。保留 Ctrl+C 行为，清理期间重复 TERM 不打断关闭。
- 新增生命周期回归：信号注册/恢复、重复 TERM、异常路径、非主线程，以及 Linux 真实子进程发 TERM 后成功退出和 atexit 清理。发布 Docker 冒烟新增真实默认 PID 1 `docker stop`，要求退出码0且不等满宽限期。
- 合并 PR #157（感谢 @2UBBISH）：上游不同工具 ID 复用同一 index 时，在流式守卫与非流式聚合入口规范化独立槽位，保留名称和完整参数；正常未改帧字节保持不变。新增172项离线回归，保持无名/截断调用明确失败。无ID的歧义交错仍无法唯一恢复，多choice适配语义不扩展。
- 修复既有 macOS 监听测试对 `SO_ACCEPTCONN` 的兼容性：改为真实 connect/accept 验证，不影响 Windows 独占绑定断言。

- 发布前本地整合：149 个套件、4334 项检查、0 失败（Windows 的真实 POSIX TERM 子进程项明确跳过）；同一源码在 Linux 额外完成生命周期13项与监听10项行为验证。

#### v1.9.8 — Kimi 工具协议与升级可靠性

完整变更：https://github.com/shuishuipingan/qoder2api-hub/compare/v1.9.8...v1.9.9

---

### 1.9.8-build.3 (2026-11-13)

CI 工作流维护
- 自动化构建流水线与容器发布底座例行维护

---

### 1.9.8-build.2 (2026-11-13)

Dockerfile + rootfs 维护
- feat(s6): 全量引入 S6 原生 finish 退出钩子与熔断机制，修复 cliproxyapi 启动死循环

---

### 1.9.8-build.1 (2026-11-12)

rootfs 维护
- docs: unify README layout and align real configs across all addons
- refactor(hubs): enforce unset-by-default env policy and document presets

---

### 1.9.8 (2026-11-12)

#### v1.9.8 — Kimi 工具协议与升级可靠性

- Kimi 展示名和内部 key 统一识别，纳入 CN / INTL 的默认结构化工具历史；保持空字符串 content、工具 ID 与区域守卫，避免双层 JSON 文本历史诱导模型复述。
- Kimi 有工具且本轮允许调用时，在现有系统提示后追加稳定的原生通道、JSON 转义、完整对象与 schema 约束；不覆盖客户端提示、不修改工具 schema、推理强度和采样参数。
- 保留坏参数协议校验，不通过猜测补齐后执行、不自动重发收费请求；显式关闭结构化历史仍有效。
- 新增 109 项 Kimi 行为回归，覆盖十步历史、三协议桥接、前缀稳定、输入/schema 不变与非法参数校验。真实 Kimi 非法参数发生率的改善仍需部署后观察。
- 合并 PR #154（感谢 @StephenBoyMi）：GitHub 限流或网络失败时，更新预检回退到成功缓存；无法查询时明确展示错误，不再误报「当前已是最新版本」。
- 合并修订后的 PR #155（感谢 @StephenBoyMi）：Windows 监听改为 `SO_EXCLUSIVEADDRUSE`，POSIX 保留地址复用；维护者移除原 PR 的不安全兼容回退，所有重试保持独占绑定。新增占位/监听、旧 reuse socket、反向抢绑和关闭后重绑行为回归。

- 发布前整合回归：147 个套件、4154 项检查全部通过；Windows 绑定行为已本机验证，两个 PR 合并后的 Linux Python 3.9 / 3.12 与 Windows Python 3.12 CI 均通过。


完整变更：https://github.com/shuishuipingan/qoder2api-hub/compare/v1.9.7...v1.9.8

---

<!-- auto-generated by CI -->
