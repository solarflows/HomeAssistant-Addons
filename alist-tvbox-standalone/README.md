# AList-TvBox Standalone

AList-TvBox 独立版，**不含内置 AList 内核**，需连接外部 AList 实例。适用于已有独立 AList 部署的场景，镜像更轻量。

## 上游

[power721/alist-tvbox](https://github.com/power721/alist-tvbox)（PowerList 纯净分支，AGPL-3.0）

> ⚠️ 本项目使用的是 `power721/PowerList` 纯净分支。

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `4567/tcp` | 管理后台 Web UI（TvBox 配置、订阅管理） |
| `5244/tcp` | AList 端口（连接外部 AList 实例时使用） |

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `INSTALL` | `new` | 安装模式（独立版固定为 `new`） |
| `ALIST_PORT` | `5244` | 外部 AList 端口 |
| `MEM_OPT` | `-Xmx512M` | JVM 内存限制 |
| `TZ` | `Asia/Shanghai` | 时区 |
| `no_proxy` | `*.aliyundrive.com` | 阿里云盘不走代理 |

## 与完整版区别

| 特性 | alist-tvbox | alist-tvbox-standalone |
|---|---|---|
| 内置 AList | ✅ | ❌ |
| 镜像体积 | 较大 | 较小 |
| 小雅集成 | ✅ | ❌ |
| 外部 AList | ✅ | ✅ |
