# WorkBuddy2API Panel for HA

把腾讯 **CodeBuddy / WorkBuddy** 账号变成 OpenAI 兼容 API 的多账号网关，附 Web 管理面板（账号池可视化 / 积分任务 / 配置热更新）。

> ## ⚠️ 使用前必读（合规与风险）
>
> - 本项目是**非官方**网关：通过逆向协议把上游平台账号接入 API，**违反目标平台服务条款**，可能带来**账号封禁**等风险，请仅用于**本人授权账号**。
> - 上游原始仓库（Sliverkiss/workbuddy2api）**已被删除过一次**；本分支作者声明如滥用持续可能随时停止维护/关库。
> - 严禁批量注册小号、对外售卖 API、二次加壳收费等行为（上游声明的明确反对项）。
> - `auths/` 保存明文 accessToken / refreshToken，请妥善保管备份文件。

## 上游

[linguo2625469/workbuddy2api-panel](https://github.com/linguo2625469/workbuddy2api-panel)（MIT）

## 支持架构

- `aarch64` (ARM64)
- `amd64` (x86_64)

## 端口

| 端口 | 说明 |
|---|---|
| `7863/tcp` | API（`/v1/chat/completions`、`/v1/models`）+ Web 管理面板（`/panel/`） |

## 快速开始

1. 启动加载项，打开面板 `http://<你的HA>:7863/panel/`。
2. 用**网关密钥**登录（浏览器本地记住）：
   - 设置了 `API_KEY` 选项 → 使用该值；
   - 未设置 → 随机生成，保存于 `/config/workbuddy2api-panel/api_key.txt` 并打印在日志中。
3. 面板右上「添加账号」→ 浏览器完成 OAuth 登录 → 凭证自动落盘并热加载进池。
4. 客户端把 API 地址指向 `http://<你的HA>:7863/v1`，密钥填网关密钥。

## 配置项

| 配置项 | 默认值 | 说明 |
|---|---|---|
| `API_KEY` | 空 | 网关访问密钥；留空则随机生成（仅首次生成配置时生效） |
| `TZ` | `Asia/Shanghai` | 定时任务（签到/保活/活跃）使用的本地时区 |

## 数据目录

| 容器路径 | 内容 | 随 HA 备份 |
|---|---|---|
| `/config/workbuddy2api-panel/config.json` | 主配置 | ✅ |
| `/config/workbuddy2api-panel/auths/` | 账号凭据（明文 token，注意保护） | ✅ |
| `/config/workbuddy2api-panel/api_key.txt` | 网关密钥副本 | ✅ |
| `/data/workbuddy2api-panel/data/` | 池状态 / 请求归档（可再生） | ❌ |

## 说明

- 本加载项打包的是上游**官方 release 二进制**（`wb2api` 主程序），支持面板内全部功能。
- 上游附带 CLI 辅助脚本（`login.sh` / `signin.sh` / `credit.sh`）未包含；请使用面板操作。

详细说明见 [DOCS.md](DOCS.md)。