# AList-TvBox

AList 代理服务器，专为 TvBox 设计，支持订阅和搜索功能。内置 AList 内核，开箱即用。

## 上游

[power721/alist-tvbox](https://github.com/power721/alist-tvbox)（PowerList 纯净分支，AGPL-3.0）

> ⚠️ 本项目使用的是 `power721/PowerList` 纯净分支，**不使用**已被投毒的 `alist-org/alist`。

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `4567/tcp` | 管理后台 Web UI（TvBox 配置、订阅管理） |
| `80/tcp` → `5344` | AList Web UI（文件浏览、网盘管理） |

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `INSTALL` | `xiaoya` | 安装模式：`xiaoya` 小雅集成版 / `new` 纯净版 |
| `ALIST_PORT` | `5344` | AList 服务端口 |
| `MEM_OPT` | `-Xmx512M` | JVM 内存限制 |
| `TZ` | `Asia/Shanghai` | 时区 |
| `no_proxy` | `*.aliyundrive.com` | 阿里云盘不走代理 |

## 特色功能

- 小雅 AList 集成（一键安装）
- 多站点 / 多网盘账号管理
- TvBox 订阅聚合与安全订阅
- 阿里云盘 / PikPak 分享支持
- 自动签到、自动刷新 Token
- 海报墙展示
