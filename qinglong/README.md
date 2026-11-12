# 青龙面板

支持 Python3、JavaScript、Shell、TypeScript 的定时任务管理平台（Node.js 实现），提供在线脚本编辑、环境变量管理、实时日志与 20+ 通知渠道。

## 上游

[whyour/qinglong](https://github.com/whyour/qinglong)（MIT）· 基于 `ghcr.io/hassio-addons/debian-base` + S6 overlay 多阶段源码构建

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `5700/tcp` | 青龙面板 Web UI（支持 HA Ingress 侧边栏） |

## 快速开始

1. 启动加载项，通过 HA 侧边栏（Ingress）、**打开 Web UI** 或访问 `http://<你的HA>:5700`。
2. 首次启动自动初始化，按 Web 初始化向导完成管理员账户创建与通知配置（初始凭据也可查看 `/ql/data/config/auth.json`）。
3. 在面板中管理定时任务、订阅仓库、脚本与青龙环境变量，或在容器终端使用 `task` / `ql` 命令。

## 配置项

本加载项无 HA UI 配置项（`options` 为空），所有青龙环境变量与任务设置均在 Web 面板内操作。容器内部固定预置以下运行环境变量：

| 环境变量 | 预置值 | 说明 |
|---|---|---|
| `QL_DIR` | `/ql` | 青龙程序根目录（只读镜像层） |
| `QL_DATA_DIR` | `/ql/data` | 持久化数据目录 |
| `NODE_ENV` | `production` | Node.js 生产运行环境 |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/ql/data/` | 脚本、数据库、`config/` 与运行日志（`app_config` 原生直挂） | ✅ |
| `/share/` | Home Assistant 共享目录（`share` 挂载，跨加载项脚本/文件交换） | ❌ *(宿主机共享卷)* |

详细说明见 [DOCS.md](DOCS.md)。
