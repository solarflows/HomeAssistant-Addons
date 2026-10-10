# MCPHub for HA

自托管 MCP（Model Context Protocol）网关与控制台：一次接入、随处暴露——把本地/远程 MCP 服务器统一路由为稳定端点，集中管理认证、分组、可见性与监控。

适配 Home Assistant 加载项：数据持久化到 `/config/mcphub`，软件包缓存持久化到 `/data/mcphub`。

## 上游

[samanhappy/mcphub](https://github.com/samanhappy/mcphub)（Apache-2.0）

- 文档：[docs.mcphub.app](https://docs.mcphub.app/)
- 使用标准版镜像（含 Node/Python/uv/Git，覆盖大多数 MCP server）；不含 Rust/Docker-in-Docker 变体

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `3000/tcp` | Web 面板 / MCP 端点（`/mcp`、`/mcp/{group}`、`/mcp/{server}`、`/mcp/$smart`） |

## 快速开始

1. 启动加载项，打开 Web 面板 `http://<你的HA>:3000`。
2. 用 `admin` 登录：
   - 已设置 `ADMIN_PASSWORD` 选项 → 使用该密码；
   - 未设置 → 首次启动生成随机密码并**打印在加载项日志**中（请及时修改）。
3. 在面板中添加 MCP 服务器，或用 `data/mcp_settings.json`（即 `/config/mcphub/mcp_settings.json`）预置。
4. 其他 AI 客户端（Claude Code / Cursor / Cherry Studio / OpenWebUI 等）连接：
   - `http://<你的HA>:3000/mcp`（全部服务器）
   - `http://<你的HA>:3000/mcp/$smart`（智能路由）

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `ADMIN_PASSWORD` | 空 | 面板 admin 密码；留空则随机生成并打印到日志 |
| `NPM_REGISTRY` | `https://registry.npmjs.org/` | npm 源（国内可改为镜像源） |

## 数据目录

| 容器路径 | 说明 | 随 HA 备份 |
|---|---|---|
| `/config/mcphub/` | 设置、用户、凭据绑定、`mcp_settings.json`、`uploads/`（MCPB 上传包） | ✅ |
| `/data/mcphub/` | npm / uv 缓存、CLI profile | ❌ |

详细说明见 [DOCS.md](DOCS.md)。