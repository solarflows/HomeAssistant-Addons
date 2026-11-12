# WorkBuddy2API Hub for HA

WorkBuddy / CodeBuddy 多账号池化反代网关与管理面板，基于上游源码在 Home Assistant `debian-base` + S6 环境下从头自构建。

- 上游仓库：[ardeyouxipianyi/workbuddy2api-hub](https://github.com/ardeyouxipianyi/workbuddy2api-hub)
- 开源协议：MIT

---

## 1. 构建与进程管理说明

- **多阶段源码编译**：CI 在构建期直接拉取上游 Release Tag 源码，交叉编译对应架构的 Go `/app/bin/wb-tls-bridge`，并组装至 `ghcr.io/hassio-addons/debian-base:9.3.0`。
- **S6 进程监督与面板自更新闭环**：
  - 主服务 `workbuddy2api-hub` 以 `exec python3 -m wb_proxy --host 0.0.0.0 --port 8788 --lan` 前台运行；若在面板顶栏触发关闭服务（`/shutdown`），S6 会自动拉起重启。
  - 伴生服务 `workbuddy2api-hub-updater` 启用官方 `wb_update_external.py`（`WB_UPDATE_EXECUTOR=external`, `profile=app`）：面板触发一键更新/回退后，由更新器完成 SHA256 校验、备份（落于 `/data/updates`）与优雅停机，主服务等落盘结束再由 S6 拉起并完成 `/health` 验收。
  - **注意**：面板热更新仅作用于当前运行容器层；当涉及 Go `wb-tls-bridge` 升级或加载项重构/重装时，仍以 HA 商店推送的新镜像为准。
- **独立双并行**：使用独立 slug `workbuddy2api-hub` 与独立端口 `8788`，不与 `workbuddy2api-panel`（`7863`）冲突。

## 2. 首次启动与密钥安全

- 默认开启 `--lan` 监听 `0.0.0.0:8788`，未设置 `API_KEY` 时首次启动会按上游优先级从 `/app/accounts/settings.json` 提取现有可用密钥（若已启用多 Key `api_keys` 列表，优先取 `id="ha-option"` 或首个未删除且启用的 Key；否则依次检查传统 `api_key` / `launcher_key`），无存量时**自动生成随机 `wb-` Bearer Key**，保存于 `/app/accounts/api_key.txt`、在加载项日志打印，并调用 Supervisor API **自动回填至 HA 加载项配置界面**。
- 借助 `/app/accounts/options_applied.json` 双向同步机制：未改动 HA 选项时，用户在 Web 面板内修改的多 Key 列表、单 Key 与面板密码均会跨重启保留；当 HA 配置页面填入新的非空 `API_KEY` 时，若面板已启用 `api_keys` 多 Key 列表，仅非破坏性地更新/插入 `id="ha-option"` 条目（保留其余自建分域/限模型 Key 及软删除审计记录）。
- 面板默认登录密码为 `admin`。如在配置项填入 `PANEL_PASSWORD`，在变更后首次启动时同步写入 `settings.json`。
- 管理面板大量使用根路径 API（`/health`、`/panel/status`、`/accounts/export`），故不启用 HA Ingress，请直接通过 **打开 Web UI** 或 `http://<你的HA>:8788` 访问。

> ⚠️ 合规提示：请勿将公网或未受信任局域网直接暴露至 `8788` 端口，并遵守上游服务条款使用自有合规账号。

## 3. 常用客户端端点

| 端点 | 用途 |
|---|---|
| `http://<你的HA>:8788/` | Web 管理面板 |
| `http://<你的HA>:8788/v1` | OpenAI 兼容 Base URL |
| `http://<你的HA>:8788/v1/messages` | Anthropic Messages 兼容端点（需开启 `WB_ENABLE_ANTHROPIC_MESSAGES`） |
| `http://<你的HA>:8788/health` | 健康探针（固定返回 200） |

## 4. 持久化存储规划

| 容器路径 | HA 映射来源 | 内容 | 是否随 HA 备份 |
|---|---|---|---|
| `/app/accounts` | `app_config` (`/addon_configs/workbuddy2api-hub`) | 账号 JSON、密钥、`settings.json` | ✅ |
| `/data/usage` | `/data/usage` | 调用统计 JSONL、限流事件、`logs.sqlite3` | ❌ |
| `/data/catalog` | `/data/catalog` | 模型/产品目录缓存 | ❌ |
| `/data/subbridge-data` | `/data/subbridge-data` | 可选 Mihomo 订阅桥配置与状态 | ❌ |
| `/data/updates` | `/data/updates`（软链至 `/app/updates`） | 面板一键更新备份快照 | ❌ |

如曾手动在 `/config/workbuddy2api-hub` 放置旧版账号文件且 `/app/accounts` 为空，首次启动时会自动完成单向迁入。

## 5. 故障排查

1. **升级或重装后界面无法打开 / 端口被占用**
   - 确认宿主机 `8788` 端口未被其它容器占用，或已在加载项「网络」设置中映射到自定义端口。
2. **忘记面板密码或 API Key**
   - 查看加载项「日志」检索自动生成的 `launcher_key`；或填写 `PANEL_PASSWORD` 重启一次重设面板密码。
3. **海外区域连接超时**
   - 如网络无法直连国际区接口，可在配置项填入 `HTTPS_PROXY`（如 `http://192.168.1.2:7890`），或将 `WB_PROXY_DEFAULT_REALM` 设为 `cn`。
