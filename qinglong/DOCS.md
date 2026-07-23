# 青龙面板

支持 Python3、JavaScript、Shell、TypeScript 的定时任务管理平台。

## 快速开始

启动后访问：`http://<HA-IP>:5700`

> 首次启动自动初始化，在终端日志中查看初始密码，或执行：
> ```bash
> docker exec <container> cat /ql/data/config/auth.json
> ```

## 使用方式

### Web 管理
直接在 Web UI 中管理脚本、环境变量、定时任务。

### 命令行
进入容器终端后可使用：

```bash
task <脚本文件>       # 执行脚本
ql update            # 更新青龙面板
ql bot               # 启动机器人
ql extra             # 执行自定义脚本
```

## 数据持久化

- `/config/qinglong/data` — 所有数据（脚本、数据库、配置、日志）
- `/share` — HA 共享目录（读写），可与其他 addon 交换脚本

## 通知推送

支持 20+ 通知渠道：Bark、Server 酱、Telegram、钉钉、企业微信、PushPlus、IGot 等。

在 Web UI → 系统设置 → 通知设置 中配置。

## 定时任务类型

| 类型 | 说明 |
|------|------|
| Cron 表达式 | 标准 Linux Cron |
| 定时 | 固定时间点执行 |
| 间隔 | 每隔 N 秒/分/时 |
| 手动 | 仅在 Web UI 手动触发 |

## 上游文档

- [whyour/qinglong](https://github.com/whyour/qinglong)
- [官方文档](https://qinglong.online)
