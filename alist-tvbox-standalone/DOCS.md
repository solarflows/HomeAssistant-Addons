# AList-TvBox Standalone

独立版不含内置 AList 内核，适用于已有独立 AList 部署的场景。

> 如果需要开箱即用的完整 AList + TvBox 方案，请使用 `alist-tvbox`。

## 前置条件

1. 需要已部署的 AList 实例（任意版本）
2. 确认 AList 的地址和端口（默认 5244）

## 快速开始

1. 启动加载项
2. 访问管理后台：`http://<HA-IP>:4567`
3. 在管理后台配置外部 AList 连接信息

默认账号密码：`admin` / `admin`（首次登录后务必修改）

## TvBox 配置地址

```
http://<HA-IP>:4567/sub/0
```

## 与完整版的区别

| 特性 | alist-tvbox | standalone |
|------|:-----------:|:----------:|
| 内置 AList 内核 | ✅ | ❌ |
| 小雅一键集成 | ✅ | ❌ |
| 镜像体积 | ~500MB | ~350MB |
| 需外部 AList | ❌ | ✅ |
| 网盘管理 | 内置 | 外部 AList 管理 |

## 数据持久化

采用 Home Assistant 新版 `addon_config` 隔离存储规范：

- `/config/atv.mv.db` — H2 核心数据库（随 HA 备份持久化，直接读写零软链接）
- `/config/store` — TvBox 站点与订阅数据
- `/config/*.txt` — 用户自定义 Token 及配置（`mytoken.txt`, `tv.txt` 等）
- `/data/log` — 运行日志（私有存储，不污染 HA 备份）

## 上游文档

- [power721/alist-tvbox](https://github.com/power721/alist-tvbox)
- 支持群组：Telegram @alist_chat
