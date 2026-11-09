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

采用 Home Assistant 新版 `addon_config` 隔离存储规范：

| 路径 | 说明 |
|------|------|
| `/config/atv.mv.db` | ATV 核心数据库（随 HA 备份持久化，直接读写零软链接） |
| `/config/alist` | AList 配置文件与 SQLite 数据库 |
| `/config/*.txt` | 用户自定义 Token、代理及配置（`mytoken.txt`, `tv.txt`, `proxy.txt` 等） |
| `/data/index` | 小雅大体积索引与下载临时目录（私有存储，不污染 HA 备份） |
| `/data/log` | 运行日志（私有存储） |

清空 `/data` 后重启，addon 会自动从零初始化；用户在 `/config` 下的数据始终安全保留。

## 上游参考

- [power721/alist-tvbox](https://github.com/power721/alist-tvbox)
- [power721/PowerList](https://github.com/power721/PowerList)（AList 内核）
- 支持群组：Telegram @alist_chat
