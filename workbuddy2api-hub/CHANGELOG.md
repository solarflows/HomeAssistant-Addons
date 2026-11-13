### 2.1.3 (2026-11-13)

- **CodeArts 并发占满改为有界排队**（#886 / #887）：单账号并发槽被占满时最多等待 `busy_wait_seconds`（默认 10 秒，范围 0–120），名额释放通过 `Condition` 立即唤醒；超时返回可重试的 429 `rate_limit_error` 并带 `reset_at`，不再误报 502「没有可用的账号」。真正空池 / 全停用 / 全冷却仍提示添加账号；多账号仍优先选空闲账号。
- **工具 Schema 关键字类型纠偏**（#885）：数字、布尔、字符串约束字段统一纠偏，`enum` / `examples` 形状校验，并拒绝 `NaN / Infinity`，修复上游 code 11129。
- **清理合并遗留的重复顶层定义**（#888）：删除 `wb_proxy.py` 中不生效的旧 `credits_remain_of` 与 per-key 并发实现，避免后续维护误改。
- **运营活动任务自动化**：新增星巴克协作与记者节福利活动，接入 `/portal/activity/tasks` 的任务读取、`viewed`、事件上报、`claim` 与 `claimed_at` 回读确认。星巴克自动完成 3 次小程序对话和专家对话；记者节自动完成指定专家、`interview-material-organizer` 技能体验及桌面 `playbook_prompt_send` 灵感任务。手机端 App 对话任务只提示、不伪造，完成后再运行会自动补领。
- **活动与成长任务解耦**：运营活动走独立的 portal 契约，不再依赖成长任务清单是否下发；成长任务暂时为空或读取失败时，一次性 / 活动入口仍会继续执行活动任务并分别记录原因。
- **真实技能分享**：`skill_share` 先从市场技能目录取可分享技能，调用 Open Platform `asset-shares/c2c/channels` 创建真实分享渠道；只有同时拿到 `share_code` 与 `link` 才上报 `skill_share_channel_action` 的 `click` / `success` 事件，服务端进度确认后才领奖。渠道创建失败、缺少链接或事件上报失败均不伪造、不领奖。
- **模板任务真实场景**：`template_5` 从 `/console/as/support/scenes` 读取真实场景 ID，按缺口逐组上报 `agent_task_created`、`agent_task_created_with_template`、`template_used`、`playbook_prompt_send` 四事件；服务端不可用时才回落到内置场景表，进度未确认不提前领奖。
- **测试**：新增活动任务读取、viewed、进度补发、专家 / 技能 / 桌面事件、App 边界、领奖回读，以及技能分享渠道 / 链接校验和模板真实场景 / 四事件组 / 进度确认测试。
- 全量测试：**306 个套件：229 个 Python + 77 个 JS，`306 passed, 0 failed, 0 skipped`**。

<!-- release-download-block -->
#### 下载说明

- `workbuddy2api-hub-v2.1.3.zip`
  - 通用便携版（Python 源码 + 看板 + 启动脚本）
  - Windows / macOS / Linux
  - 需要 Python 3.9+
  - 内置 Windows amd64、macOS 与 Linux amd64 / arm64 的 Go/uTLS bridge
  - 未设置 TLS 模式时默认 auto；桥不可用时自动回退 Python，无需安装 Go
  - 解压后使用对应平台的启动脚本

- `workbuddy2api_2.1.3-1_all.ipk`
  - OpenWrt 的 opkg 系安装包
  - 适用于对应受支持的旧版 OpenWrt 路线

- `workbuddy2api-2.1.3-r1.apk`
  - OpenWrt 25.x+ 的 apk-tools 安装包

- `SHA256SUMS`
  - Release 资产的 SHA-256 校验值

---

### 2.1.2 (2026-11-12)

- **请求列表支持失败详情与筛选**（#883）：最近请求现在可按账号、模型、API Key 和结果筛选；失败状态可直接展开完整错误，不再只能看到截断的一行。筛选与分页在后端完成，跨区域扫描有上限，不会为了筛一页把全部日志读进内存。
- **CodeArts 请求积分不再恒为 0**（#866）：CodeArts 聊天 SSE 只返回 token，不返回逐请求 `credit`。网关现在在请求发出前读取账号累计已用积分，响应结束后按差值写入本次 usage 行；`chat/completions`、`responses`、`messages` 的流式与非流式共用同一结算点。采样失败、计数回退或上游已返回非零 `credit` 时不改写，且查询失败不会影响正常聊天。
- **计费头的宽松兜底**（`WB_SANITIZE_LOOSE_BILLING`，默认 `0` = 关闭）：#853 / #854 把清洗作用域收紧成「整块都是 `cc_*` / `cch` 元数据」的形态，误删最少；但客户端一旦改字段名或多塞一个未知键，`_billing_payload_is_metadata()` 就判它「不是元数据」，整行原样留下——而这类行每个请求都不同，留在 system 首部等于每轮把整段前缀的 prompt 缓存打掉，命中率静默归零、没有任何报错可循。开关打开后，严格解析认不出但首行看着就是计费头（≥2 个 `cc_*=` / `cch=` 键值，且≤400 字符）时整段删除；续行只在自身也是合法元数据行时才被带走。默认关闭，行为与现在逐字节一致。
- **Key 级日 token 限量**（`daily_token_limit`，单位 M，`0` = 不限）：新增按 Key 折叠的用量视图 `keytokens`（与账号维度的 `tokens` 是同一批行的两种折叠，不增加 I/O）。**先按 key 累加再判 uid 为空**：400 之类的失败行没有 `account` 字段，先在 uid 上跳过就会漏掉它们。超限时在**并发槽位之前**返回 `403 permission_error`（已超额的 Key 不该先排队等 `WB_CHAT_SLOT_WAIT` 秒再被拒），`/v1/messages` 走 Anthropic 错误信封。面板：编辑弹窗新增「日 token 限量 (M)」输入框与「日限 NM」徽标；`/settings/save` 在请求体缺该字段时沿用已存值，老面板保存不会把日限量清成 0。
- **Key 级并发上限改为有界排队**：`concurrency_limit` 占满时不再立刻返回 429，而是最多等待 `WB_CHAT_SLOT_WAIT` 秒（默认 30，与全局对话槽位同一预算）再判定；多进程客户端在工具调用密集时的瞬时超并发不再表现为「网关抽风」。信号量按 Key 懒创建，`limit` 变化时按当前占用重建，`limit <= 0`（不限）不建信号量；归还路径对多还、限流调小都做了幂等保护。
- **面板回显 `concurrency_limit`**：该字段上游只存不显，面板读不到就显示 0，用户再保存一次会把真实值写回 0。
- **单发 `/v1/messages` 的稳定亲和键**（`WB_MSGSTAT_SHARDS`，默认 `0` = 关闭）：Claude Code 等客户端的一次性调用是 `[system, user]`，user 文本每次不同；`affinity_route()` 用 `msgs[:2]` 派生会话键，于是每次调用都被当成新会话、被轮询派到不同账号。上游 prompt 缓存**按账号存放**，换号等于整段前缀重付。打开开关后，同一 *(API Key, 模型, system, tools)* 组合的调用按用户文本哈希分到 ≤N 个固定账号并持续复用，稳定前缀继续命中；流式主循环与已续轮请求仍走原有的前缀亲和，行为不变。
- **第 2 轮继承第 1 轮绑定**：`affinity_stable_key_enabled` 打开时第 1 轮哈希 `msgs[:2]`、第 2 轮哈希 `msgs[:3]`，中间必然换一次冷号。现在第 2 轮会把新键 prebind 到第 1 轮用过的账号（仅在客户端未自带会话键、且键确实变化时生效）。
- 两处改动都只作用于 `/v1/messages`；`/v1/chat/completions`、`/v1/responses`、`/v1/completions` 的派单路径一行未改。

<!-- release-download-block -->
#### 下载说明

- `workbuddy2api-hub-v2.1.2.zip`
  - 通用便携版（Python 源码 + 看板 + 启动脚本）
  - Windows / macOS / Linux
  - 需要 Python 3.9+
  - 内置 Windows amd64、macOS 与 Linux amd64 / arm64 的 Go/uTLS bridge
  - 未设置 TLS 模式时默认 auto；桥不可用时自动回退 Python，无需安装 Go
  - 解压后使用对应平台的启动脚本

- `workbuddy2api_2.1.2-1_all.ipk`
  - OpenWrt 的 opkg 系安装包
  - 适用于对应受支持的旧版 OpenWrt 路线

- `workbuddy2api-2.1.2-r1.apk`
  - OpenWrt 25.x+ 的 apk-tools 安装包

- `SHA256SUMS`
  - Release 资产的 SHA-256 校验值

---

### 2.1.1-build.1 (2026-11-12)

rootfs 维护
- docs: unify README layout and align real configs across all addons
- refactor(hubs): enforce unset-by-default env policy and document presets

---

### 2.1.1 (2026-11-12)

- **每日活跃自动模型回退**：国际版每日活跃在「自动化 → 国际版每日签到」新增「优先 DeepSeek Flash，失败切免费模型」开关，默认开启并即时保存。自动模式先试 `deepseek-v4.1-flash`，额度 / 限流 / 模型不可用时按当前渠道实时目录顺序切换免费模型；关闭后直接从免费模型开始。手工指定的候选序列仍严格按面板顺序执行。
- **桌面腿与网页腿共用候选序列**：桌面身份轻量对话此前失败不会换模型，网页建会话遇到 `14018` 也不会回退；现在两条链路都按同一候选序列切换，`11140` 账号封禁与 `401` 凭证失效仍立即停止，不会误换模型放大风控。
- **免费模型目录补全**：自动候选会合并实时 `/v3/config` 缓存、桌面缓存、网关最近一次成功目录存档与内置快照，并排除当前已按付费倍率计价的 `deepseek-v4.1-flash-sg`。
- **DSH 视觉模型声明保留**（#858）：修复 `yaml_refs_upsert()` 无法处理 DSH flow-map `refs` 的问题；只有目录标记支持视觉的模型才写入 `input: [text, image]`，纯文本模型不再被误标为视觉模型。

<!-- release-download-block -->
#### 下载说明

- `workbuddy2api-hub-v2.1.1.zip`
  - 通用便携版（Python 源码 + 看板 + 启动脚本）
  - Windows / macOS / Linux
  - 需要 Python 3.9+
  - 内置 Windows amd64、macOS 与 Linux amd64 / arm64 的 Go/uTLS bridge
  - 未设置 TLS 模式时默认 auto；桥不可用时自动回退 Python，无需安装 Go
  - 解压后使用对应平台的启动脚本

- `workbuddy2api_2.1.1-1_all.ipk`
  - OpenWrt 的 opkg 系安装包
  - 适用于对应受支持的旧版 OpenWrt 路线

- `workbuddy2api-2.1.1-r1.apk`
  - OpenWrt 25.x+ 的 apk-tools 安装包

- `SHA256SUMS`
  - Release 资产的 SHA-256 校验值

---

<!-- auto-generated by CI -->
