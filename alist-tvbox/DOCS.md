# AList-TvBox

## 快速开始

启动后访问管理后台：`http://<HA-IP>:4567`

默认账号密码：`admin` / `admin`（首次登录后务必修改）

## TvBox 配置地址

在 TvBox 类应用中填入以下订阅地址：

```
http://<HA-IP>:4567/sub/0
```

## 安装模式

| 模式 | `INSTALL` 值 | 说明 |
|------|-------------|------|
| 小雅集成版 | `xiaoya` | 一键安装小雅 AList + 海量网盘资源，首次启动自动初始化 |
| 纯净版 | `new` | 仅 AList 内核 + TvBox 管理，需自行配置网盘 |

可在加载项配置中修改 `INSTALL` 环境变量切换模式（需重启）。

## 功能说明

### 管理后台 (4567)
- 订阅管理：生成 TvBox 订阅链接、聚合订阅、安全订阅
- 站点管理：多站点配置、自动签到、Token 刷新
- 爬虫插件：Python 爬虫管理、本地代理加速

### AList 面板 (80→5344)
- 文件浏览：阿里云盘、百度网盘、夸克、UC、115、123、天翼、139、迅雷、PikPak 等
- 网盘账号管理、分享链接管理
- 离线下载（115/迅雷/广雅）

## 数据持久化

- `/config/atv/config` — 应用配置文件
- `/data/alist` — AList 数据库与元数据
- `/data/store` — TvBox 数据

> `/config` 随 HA 备份；`/data` 持久但不随备份。

## 上游文档

- [power721/alist-tvbox](https://github.com/power721/alist-tvbox)
- 支持群组：Telegram @alist_chat
