# MCPHub for HA

自托管 MCP 网关与控制台。本文档覆盖首次使用、数据路径、端点与故障排查。

- 上游项目：[samanhappy/mcphub](https://github.com/samanhappy/mcphub)
- 官方文档：[docs.mcphub.app](https://docs.mcphub.app/)

---

## 1. 这是什么

MCPHub 是 AI 客户端与 MCP 服务器之间的统一控制面：连接本地（stdio、npx/uvx 拉起）与远程（SSE / Streamable HTTP）MCP 服务器，按服务器、分组或 Smart Routing 暴露稳定端点，并统一管理认证、凭据、可见性与监控。

兼容 Claude Code、Cursor、Cherry Studio、OpenWebUI 等 MCP 客户端。

## 2. 首次使用

1. 启动加载项，打开 `http://<你的HA>:3000`。
2. 使用 `admin` 登录：
   - 设置了 `ADMIN_PASSWORD` 选项 → 用该密码；
   - 未设置 → 随机密码**仅在首次启动日志打印一次**，请及时在面板中修改。
3. 添加 MCP 服务器（面板 → Servers），或编辑 `/config/mcphub/mcp_settings.json` 后重启加载项。

## 3. 客户端接入端点

| 端点 | 用途 |
|---|---|
| `http://<你的HA>:3000/mcp` | 全部服务器 |
| `http://<你的HA>:3000/mcp/{group}` | 指定分组 |
| `http://<你的HA>:3000/mcp/{server}` | 单个服务器 |
| `http://<你的HA>:3000/mcp/$smart` | Smart Routing（语义检索工具） |

> MCP 端点默认要求 Bearer 认证（面板 Keys 页可管理）。仅在受信任的局域网中使用。

## 4. 配置项

| 配置项 | 说明 |
|---|---|
| `ADMIN_PASSWORD` | 面板 admin 密码。留空 → 随机生成并打印到日志 |
| `NPM_REGISTRY` | npm 源，供 npx 安装 MCP server 使用；国内网络可改为 https://registry.npmmirror.com |

## 5. 数据与缓存

| 容器路径 | 内容 | 是否随 HA 备份 |
|---|---|---|
| `/config/mcphub/` | 设置、用户、凭据绑定、`mcp_settings.json`、`uploads/`（MCPB 上传包） | ✅ |
| `/data/mcphub/npm` | npm 包缓存（npx 拉取的 server 包） | ❌ |
| `/data/mcphub/cache` | uv/uvx 等其他缓存 | ❌ |
| `/data/mcphub/cli-*` | mcphub CLI 的配置与凭据（仅交互式 CLI 使用） | ❌ |

- 数据目录通过 `/app/data` 软链到 `/config/mcphub`，卸载/升级加载项不丢失。
- 缓存持久化后，加载项更新不会导致 npx/uvx 包全部重新下载。

## 6. Python / Node 工具链

镜像内置 Node.js（22）、pnpm、Python、uv/uvx、Git 与编译工具，面板中直接填写 `npx` / `uvx` 命令即可拉起常见 MCP server。

> 不含 Rust 工具链与 Docker-in-Docker（官方 `latest-full` 变体内容）。若你的 MCP server 需要 Rust 或容器内再起容器，请改用官方完整镜像自行构建。

## 7. 故障排查

- **看不到随机密码** → 加载项日志页从启动处查看，或先在配置中显式设置 `ADMIN_PASSWORD` 后重启。
- **stdio server 启动失败** → 检查服务器命令是否可执行（加载项日志会打印）；国内网络可切换 `NPM_REGISTRY` 镜像源。
- **数据库模式（PostgreSQL）** → 本加载项未启用；如需生产级 DB 模式，请参考官方文档自行扩展。
- **更新加载项后设置丢失？** → 不会。设置位于 `/config/mcphub`（HA 快照亦覆盖）。

## 8. 安全提示

- 面板与 MCP 端点默认监听局域网可访问端口，请使用强密码并保持在可信网络内。
- 凭据绑定（per-user credentials）在存储时加密；备份文件请妥善保管。