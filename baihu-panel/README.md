# 白虎面板

轻量级定时任务管理系统，Go 语言编译为单一二进制，内存占用低，支持 Python、Node.js、Go、Rust、PHP、Shell 等主流语言脚本调度。

## 上游

[engigu/baihu-panel](https://github.com/engigu/baihu-panel)（MIT）· 在 `ghcr.io/hassio-addons/debian-base` + S6 overlay 上由 Go 多阶段源码编译并集成 `mise` 运行时

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8052/tcp` | Web 管理面板端口 |

## 快速开始

1. 启动加载项，通过 **打开 Web UI** 或访问 `http://<你的HA>:8052`。
2. 首次启动自动初始化 SQLite 数据库，在面板中完成初始账号设置与任务编排。
3. 定时任务脚本建议存放于 `/app/data/scripts` 或 `/share`，在任务命令中使用绝对路径调用。

## 配置项

本加载项无 HA UI 配置项（`options` 为空），所有业务设置在 Web 面板内完成。容器内部固定预置以下运行环境变量：

| 环境变量 | 预置值 | 说明 |
|---|---|---|
| `BH_SERVER_PORT` | `8052` | 服务监听端口 |
| `BH_SERVER_HOST` | `0.0.0.0` | 服务监听地址 |
| `BH_DB_PATH` | `/app/data/baihu.db` | SQLite 数据库路径 |
| `MISE_DATA_DIR` / `MISE_CONFIG_DIR` | `/data/mise` | `mise` 运行时数据与工具链缓存目录 |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/app/data/` | 数据库 `baihu.db`、脚本与面板核心数据（`app_config` 原生直挂） | ✅ |
| `/share/` | HA 共享目录（`share` 挂载，跨加载项脚本交换） | ❌ *(属 HA 共享卷)* |
| `/data/mise/` | `mise` 语言运行时与依赖缓存 | ❌ |

详细说明见 [DOCS.md](DOCS.md)。
