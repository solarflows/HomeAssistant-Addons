# FileBrowser Quantum

现代化响应式 Web 文件管理器，支持多源文件浏览、全文实时索引与多种认证模式，预挂载 Home Assistant 与各加载项配置目录以便统一管理。

## 上游

[gtsteffaniak/filebrowser](https://github.com/gtsteffaniak/filebrowser)（MIT）· 基于 `ghcr.io/hassio-addons/debian-base` + S6 overlay 打包官方二进制

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8080/tcp` | FileBrowser Quantum Web UI |

## 快速开始

1. 启动加载项，通过 **打开 Web UI** 或访问 `http://<你的HA>:8080`。
2. 首次启动按页面向导初始化管理员账号与存储源。
3. 如需切换无密码或 OIDC/反向代理认证，可在加载项 **配置** 中调整 `auth_method` 后重启生效。

## 配置项

本加载项通过 `00-init.sh` 将选项写入 `/config/config.yaml`（运行时固定导出 `FILEBROWSER_CONFIG=/config/config.yaml`）：

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `auth_method` | `password` *(预置)* | 认证模式：`password`（账号密码）/ `noauth`（无认证）/ `proxy`（反向代理头）/ `oidc` |
| `default_user_scope` | `/` *(预置)* | 新建/默认用户可访问的默认起始路径（`/` 表示完整可见根目录） |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/config/` | 主配置 `config.yaml` 与数据库 `database.db`（`app_config` 直挂） | ✅ |
| `/homeassistant/` | Home Assistant 主配置目录（读写） | ❌ *(宿主机系统卷)* |
| `/app_configs/` | 宿主机全部 Add-on 独立配置汇总目录（读写） | ❌ *(宿主机系统卷)* |
| `/share/` | Home Assistant 共享目录（读写） | ❌ *(宿主机系统卷)* |
| `/media/` | Home Assistant 媒体目录（读写） | ❌ *(宿主机系统卷)* |
| `/ssl/` | SSL 证书目录（只读） | ❌ *(只读系统卷)* |

详细说明见 [DOCS.md](DOCS.md)。
