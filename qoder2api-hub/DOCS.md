# Qoder2API Hub for HA

Qoder 多账号池化反代网关与管理面板，基于上游源码在 Home Assistant `debian-base` + S6 环境下从头自构建。

- 上游仓库：[shuishuipingan/qoder2api-hub](https://github.com/shuishuipingan/qoder2api-hub)
- 开源协议：MIT

---

## 1. 构建与进程管理说明

- **多阶段源码自构建**：CI 构建期拉取上游 Release Tag 源码，运行 `_install_umid.py` 提取对应架构的 Linux glibc ELF `/app/umid/runtime-info`；运行时采用 `ghcr.io/hassio-addons/debian-base:9.3.0` 原生 glibc（无需 `gcompat`）与 `python3-pil`。
- **上游启动脚本与升级策略**：
  - 默认 S6 `run` 导出 HA 配置环境变量后直接 `exec /app/start-qoder-proxy-lan.sh 8790` 前台接管（配置了 `PANEL_PASSWORD` 时自动切换 `python3 /app/qoder_proxy.py --port 8790 --lan --panel-password ...`）。
  - 上游 `qoder_updater.py` 在容器环境下按设计主动禁用面板一键自替换（避免 `Popen` 新进程与 S6 双重启动冲突端口 `8790`），保留面板内新版本检测提示；实际升级统一交由 Home Assistant 商店（`Version_Check` + `Release`）推送新镜像平滑升级。

## 2. 首次启动与密钥安全

- 默认开启 `--lan` 监听 `0.0.0.0:8790`，未设置 `API_KEY` 时首次启动会按上游优先级从 `/app/accounts/settings.json` 提取现有可用密钥（若已启用多 Key `api_keys` 列表，优先取 `id="ha-option"` 或首个启用的 Key；否则依次检查传统 `api_key` / `launcher_key`），无存量时**自动生成随机 `qd-` Bearer Key**，保存于 `/app/accounts/api_key.txt`、在加载项日志打印，并调用 Supervisor API **自动回填至 HA 加载项配置界面**。
- 借助 `/app/accounts/options_applied.json` 双向同步机制：未改动 HA 选项时，用户在 Web 面板内修改的多 Key 列表、单 Key 与面板密码均会跨重启保留；当 HA 配置页面填入新的非空 `API_KEY` 时，若面板已启用 `api_keys` 多 Key 列表，仅非破坏性地更新/插入 `id="ha-option"` 条目（保留其余自建分域/限账号 Key）。
- 面板默认登录密码为 `admin`。如配置项设置了 `PANEL_PASSWORD`，在变更后首次启动时同步写入 `settings.json`。
- 管理面板大量使用根路径请求（`/credits/probe`、`/panel/status`、`/admin/routing`），故不启用 HA Ingress，请通过 **打开 Web UI** 或 `http://<你的HA>:8790` 访问。

> ⚠️ 合规提示：请仅在受信任内网或反向代理鉴权保护下使用，勿将 `8790` 端口直接暴露于公网，并遵守上游服务条款。

## 3. 常用客户端端点

| 端点 | 用途 |
|---|---|
| `http://<你的HA>:8790/` | Web 管理面板 |
| `http://<你的HA>:8790/v1` | OpenAI 兼容 Base URL |
| `http://<你的HA>:8790/v1/messages` | Anthropic Messages 兼容端点 |
| `http://<你的HA>:8790/ping` | 健康探针（固定返回 200） |

## 4. 持久化存储规划

| 容器路径 | HA 映射来源 | 内容 | 是否随 HA 备份 |
|---|---|---|---|
| `/app/accounts` | `app_config` (`/addon_configs/qoder2api-hub`) | 账号 JSON、`settings.json`、`machine_identity.json`、`scheduler/` | ✅ |
| `/data/logs` | `/data/logs` | 运行日志（`gateway.log`、`gateway.err.log`） | ❌ |
| `/data/usage` | `/data/usage` | 用量统计 JSONL 与汇总缓存 | ❌ |

如曾手动在 `/config/qoder2api-hub` 放置旧版账号文件且 `/app/accounts` 为空，首次启动时会自动完成单向迁入。

## 5. 故障排查

1. **国际区无法连接或超时**
   - 检查网络连通性；需要走代理时请在配置项填入 `HTTPS_PROXY`（如 `http://192.168.1.2:7890`）。
2. **忘记面板密码或 API Key**
   - 查看加载项启动日志检索初始生成的密钥；或填写 `PANEL_PASSWORD` 并重启一次完成密码重置。
3. **企业内网专用网关接入**
   - 如使用企业 VPC 专用域且触发私网 SSRF 拦截，请将专用地址填入 `QD_CN_VPC_ENDPOINT`。
