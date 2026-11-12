# MCPHub for HA

自托管 **MCP（Model Context Protocol）网关与控制台**，将本地（stdio）与远程 MCP 服务器统一路由为稳定 HTTP/SSE 端点，集中管理认证、分组、智能路由与运行监控。

## 上游

[samanhappy/mcphub](https://github.com/samanhappy/mcphub)（Apache-2.0）· 基于官方标准版镜像（含 Node / Python / uv / Git，不含 Rust/DinD）+ `ha-entrypoint.sh` / `dumb-init`

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `3000/tcp` | Web 控制台与 MCP 端点（`/mcp`、`/mcp/{group}`、`/mcp/{server}`、`/mcp/$smart`） |

## 快速开始

1. 启动加载项，通过 **打开 Web UI** 或访问 `http://<你的HA>:3000`。
2. 使用用户名 `admin` 登录：
   - 若已填写 `ADMIN_PASSWORD`，直接使用该密码；
   - 若留空，首次启动由上游随机生成初始密码并打印在加载项日志中（请及时登录后修改）。
3. 在面板中添加 MCP 服务器，或直接通过 `/app/data/mcp_settings.json` 预置配置。
4. 在 AI 客户端（Claude Code / Cursor / Cherry Studio / OpenWebUI 等）中接入 `http://<你的HA>:3000/mcp`（全部服务器）或 `http://<你的HA>:3000/mcp/$smart`（智能路由）。

## 配置项

`ha-entrypoint.sh` 仅在配置项**非 null 且非空**时导出为环境变量（留空保持 `unset`，采用 `shlex.quote` 安全转义后链入上游 entrypoint）：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `ADMIN_PASSWORD` | `""`（`unset`） | 面板 `admin` 登录密码；留空则首次启动由上游随机生成并打印到日志 |
| `NPM_REGISTRY` | `https://registry.npmjs.org/` *(预置)* | `npx` 拉取 stdio MCP 服务包时使用的 npm 源（国内可改为 `https://registry.npmmirror.com`） |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/app/data/` | 面板设置、用户、`mcp_settings.json` 与 `uploads/`（`app_config` 原生直挂） | ✅ |
| `/data/mcphub/` | npm / uv 缓存与 MCPHub CLI profile（持久化加速冷启动） | ❌ |

详细说明见 [DOCS.md](DOCS.md)。
