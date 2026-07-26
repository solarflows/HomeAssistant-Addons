# AList-TvBox

AList 代理服务器，支持 TvBox 订阅和搜索。基于 [power721/alist-tvbox](https://github.com/power721/alist-tvbox)。

## 快速开始

启动后访问管理后台：`http://<HA-IP>:4567`

默认账号密码：`admin` / `admin`（首次登录后务必修改）

### TvBox 订阅地址

```
http://<HA-IP>:4567/sub/0
```

## 安装模式

| 模式 | 说明 |
|------|------|
| 小雅集成版 | 一键安装小雅 AList + 海量网盘资源，首次启动自动初始化 |
| 纯净版 | 仅 AList 内核 + TvBox 管理，需自行配置网盘 |

可在加载项配置中修改（需重启）。

## 功能

- **TvBox 订阅管理**：生成订阅链接、聚合订阅、安全订阅
- **多网盘支持**：阿里云盘、百度网盘、夸克、UC、115、123、天翼、139、迅雷、PikPak
- **站点管理**：多站点配置、自动签到、Token 刷新
- **离线下载**：115 / 迅雷 / 广雅
- **爬虫插件**：Python 爬虫管理、本地代理加速

## 端口

| 端口 | 服务 |
|------|------|
| 4567 | 管理后台（HA ingress 入口） |
| 80 → 5344 | AList 面板 |

## 数据持久化

| 路径 | 说明 |
|------|------|
| `/config` | 随 HA 备份 |
| `/data` | 持久但不备份（数据库、索引、配置） |

清空 `/data` 后重启，addon 会自动从零初始化（资源文件在镜像层，不受影响）。

## 上游参考

- [power721/alist-tvbox](https://github.com/power721/alist-tvbox)
- [power721/PowerList](https://github.com/power721/PowerList)（AList 内核）
- 支持群组：Telegram @alist_chat
