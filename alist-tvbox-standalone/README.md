# AList-TvBox Standalone

AList-TvBox 独立精简版，**不含内置 AList 内核与小雅集成**，适用于已有独立 AList 实例的场景，镜像体积更小。

> ⚠️ 本加载项依赖外部已部署的 AList 实例（默认连接端口参考 `5244`），内置源码来自 `power721/alist-tvbox`（PowerList 纯净分支）。

## 上游

[power721/alist-tvbox](https://github.com/power721/alist-tvbox)（MIT）· 在 `ghcr.io/hassio-addons/debian-base` + S6 overlay 上多阶段构建（仅保留 TvBox 管理服务）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `4567/tcp` | 管理后台 Web UI（TvBox 配置、订阅管理） |

## 快速开始

1. 确认局域网或本机已部署好外部 AList 实例。
2. 启动加载项，打开 Web UI 或访问 `http://<你的HA>:4567`。
3. 使用默认账号 `admin` / 密码 `admin` 登录（首次登录后请务必修改），在后台配置外部 AList 连接地址。
4. 将 TvBox 订阅地址设为 `http://<你的HA>:4567/sub/0`。

## 配置项

环境变量与运行参数采用精简 UI 项映射（镜像固定内置 `INSTALL=new`、`ALIST_PORT=5244` 与 JVM 时区 `Asia/Shanghai`）：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `LOW_MEMORY` | `true` *(预置)* | 开启时限制 JVM 堆内存 `MEM_OPT=-Xmx512M`，关闭为 `-Xmx1024M` |
| `ATV_DEBUG` | `false` *(预置)* | 开启时为 Spring Boot 追加 `--debug` 诊断参数；排查启动问题时启用 |

## 与 `alist-tvbox` 的区别

| | `alist-tvbox`（完整版） | `alist-tvbox-standalone`（本版） |
|---|---|---|
| 内置 AList 内核 | ✅（PowerList :5344） | ❌（需连接外部 AList） |
| 小雅集成（`xiaoya`） | ✅ | ❌ |
| 镜像体积 | 较大 | 较小 |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/config/` | H2 数据库 `atv.mv.db`、`store/` 及自定义 `*.txt`（`app_config` 直挂） | ✅ |
| `/data/log/` | 初始化与运行日志 | ❌ |

详细说明见 [DOCS.md](DOCS.md)。
