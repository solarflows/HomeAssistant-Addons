# FileBrowser Quantum

现代化响应式 Web 文件管理器，支持多源文件浏览、全文检索和高级认证。

## 快速开始

启动后访问：`http://<HA-IP>:8080`

> 首次启动通过 Web UI 进行初始化配置。

## 支持的存储后端

- 📁 本地文件系统
- ☁️ Amazon S3 / MinIO / 兼容 S3 协议
- 🔗 WebDAV
- 🔐 SFTP
- 其他可挂载存储

## 认证方式

在加载项配置中选择认证方式：

| 方式 | 说明 |
|------|------|
| `password` | 用户名 + 密码（默认） |
| `noauth` | 无认证（不推荐公网使用） |
| `proxy` | 反向代理认证头 |
| `oidc` | OpenID Connect（支持 Google/GitHub 等） |

## 功能特点

- 🔍 全文实时索引与搜索
- 🎨 现代化 UI，支持桌面+移动端
- 📤 拖拽上传 / 批量操作
- 🔐 基于路径的权限控制
- 📦 支持创建文件分享链接

## 目录映射

| 容器路径 | 说明 |
|---------|------|
| `/config` | FileBrowser Quantum 数据库与核心配置（`app_config`，读写 + 随 HA 备份） |
| `/homeassistant` | Home Assistant 主配置目录（`homeassistant_config`，读写） |
| `/app_configs` | 宿主机全部 Add-on 独立配置目录汇总（`all_app_configs`，读写） |
| `/share` | HA 共享目录（`share`，读写），可跨 addon 访问 |
| `/media` | HA 媒体目录（`media`，读写） |
| `/ssl` | SSL 证书目录（`ssl`，只读） |

> 默认配置已直挂上述全部核心挂载点，可直接通过 Web 界面统一浏览与管理 Home Assistant 及各加载项的持久化文件。

## 上游文档

- [gtsteffaniak/filebrowser](https://github.com/gtsteffaniak/filebrowser)
