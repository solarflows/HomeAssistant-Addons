# 白虎面板

轻量级定时任务管理面板，Go 编写，支持任意可执行脚本语言。

## 快速开始

启动后访问管理面板：`http://<HA-IP>:8052`

> 首次启动自动初始化数据库，无需手动配置。

## 支持的脚本语言

直接运行任意可执行文件或脚本：

| 语言 | 示例 |
|------|------|
| Python | `python3 /config/scripts/task.py` |
| Node.js | `node /config/scripts/task.js` |
| Shell | `bash /config/scripts/task.sh` |
| Go | `/config/scripts/task` |
| Rust | `/config/scripts/task` |
| PHP | `php /config/scripts/task.php` |

## 功能特点

- 🔥 Go 编译为单一二进制，内存占用 < 20MB
- ⏱ 秒级定时任务调度
- 📦 不限语言，凡是可执行文件均可管理
- 🔔 系统通知（邮件 / Bark / Server 酱等）
- 📱 移动端适配
- 🛡️ 多用户权限管理

## 数据持久化

- `/config/baihu/data` — SQLite 数据库
- `/config/baihu/configs` — 配置文件
- `/app/envs` — 环境变量文件

> 脚本文件建议放在 `/share` 或 `/config` 目录中通过绝对路径引用。

## 上游文档

- [engigu/baihu-panel](https://github.com/engigu/baihu-panel)
