# FileBrowser Quantum

现代化响应式 Web 文件管理器，支持多源文件浏览、高级认证和实时索引。

## 上游

[gtsteffaniak/filebrowser](https://github.com/gtsteffaniak/filebrowser)

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `8080/tcp` | FileBrowser Quantum Web UI |

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `TZ` | `Asia/Shanghai` | 时区 |

## 数据映射

| 路径 | 说明 |
|---|---|
| `/config` | 持久化配置（数据库、配置文件） |
| `/ssl` | SSL 证书（只读） |
| `/share` | Home Assistant 共享目录（读写） |

## 特色功能

- 📁 多源文件浏览（本地 / S3 / WebDAV / SFTP 等）
- 🔐 高级认证（OAuth2 / OIDC / 双因素）
- 🔍 实时全文索引
- 🎨 现代化 UI，移动端适配
- 📤 拖拽上传 / 批量操作
