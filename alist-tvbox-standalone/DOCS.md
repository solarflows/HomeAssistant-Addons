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

- `/config/atv/config` — 应用配置文件
- `/data/store` — TvBox 数据

## 上游文档

- [power721/alist-tvbox](https://github.com/power721/alist-tvbox)
- 支持群组：Telegram @alist_chat
