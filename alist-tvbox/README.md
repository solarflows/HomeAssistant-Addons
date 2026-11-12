# AList-TvBox

AList 代理服务器，专为 TvBox 设计，支持订阅聚合、多网盘挂载与搜索功能；内置 PowerList 纯净分支 AList 内核，开箱即用。

> ⚠️ 本加载项内置的是 `power721/PowerList` 纯净分支，**不使用**上游 `alist-org/alist`。

## 上游

[power721/alist-tvbox](https://github.com/power721/alist-tvbox)（MIT）· 在 `ghcr.io/hassio-addons/debian-base` + S6 overlay 上多阶段构建（含上游 Spring Boot 包与 `haroldli/alist` 二进制）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `4567/tcp` | 管理后台 Web UI（TvBox 配置、订阅管理） |
| `80/tcp` → `5344` | 内置 AList Web UI（文件浏览、网盘管理） |

## 快速开始

1. 启动加载项，打开 Web UI 或访问 `http://<你的HA>:4567`。
2. 使用默认账号 `admin` / 密码 `admin` 登录（首次登录后请务必修改）。
3. 将 TvBox 订阅地址设为 `http://<你的HA>:4567/sub/0`。
4. 如需使用内部 AList 面板，访问 `http://<你的HA>:5344`。

## 配置项

环境变量与运行参数采用精简 UI 项映射（镜像固定内置 `INSTALL=xiaoya`、`ALIST_PORT=5344` 与 JVM 时区 `Asia/Shanghai`）：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `LOW_MEMORY` | `true` *(预置)* | 开启时限制 JVM 堆内存 `MEM_OPT=-Xmx512M`，关闭为 `-Xmx1024M` |
| `ATV_DEBUG` | `false` *(预置)* | 开启时为 Spring Boot 追加 `--debug` 诊断参数；排查启动问题时启用 |

## 与 `alist-tvbox-standalone` 的区别

| | `alist-tvbox`（本版） | `alist-tvbox-standalone` |
|---|---|---|
| 内置 AList 内核 | ✅（PowerList :5344） | ❌（需连接外部 AList） |
| 小雅集成（`xiaoya`） | ✅ | ❌ |
| 镜像体积 | 较大 | 较小 |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/config/` | H2 数据库 `atv.mv.db`、`/config/alist/` 及自定义 `*.txt`（`app_config` 直挂） | ✅ |
| `/data/index/` | 小雅大体积索引与下载缓存 | ❌ |
| `/data/log/` | 初始化与运行日志 | ❌ |

详细说明见 [DOCS.md](DOCS.md)。
