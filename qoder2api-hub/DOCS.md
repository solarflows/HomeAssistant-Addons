# Qoder2API Hub for HA

Qoder 多账号池化反代网关与管理面板，基于上游源码在 Home Assistant `debian-base` + S6 环境下从头自构建。

- 上游仓库：[shuishuipingan/qoder2api-hub](https://github.com/shuishuipingan/qoder2api-hub)
- 开源协议：MIT

---

## 1. 构建与进程管理说明

- **多阶段源码自构建**：CI 构建期拉取上游 Release Tag 源码，运行 `_install_umid.py` 提取对应架构的 Linux glibc ELF `/app/umid/runtime-info`；运行时采用 `ghcr.io/hassio-addons/debian-base:9.3.0` 原生 glibc（无需 `gcompat`）与 `python3-pil`。
- **上游启动脚本与升级策略**：
  - 默认 S6 `run` 导出 HA 配置环境变量后直接 `exec /app/start-qoder-proxy-lan.sh 8790` 前台接管。
  - 上游 `qoder_updater.py` 在容器环境下按设计主动禁用面板一键自替换（避免 `Popen` 新进程与 S6 双重启动冲突端口 `8790`），保留面板内新版本检测提示；实际升级统一交由 Home Assistant 商店（`Version_Check` + `Release`）推送新镜像平滑升级。

## 2. 首次启动与密钥安全

- 默认开启 `--lan` 监听 `0.0.0.0:8790`。
- **管理面板默认密码**：上游原生默认密码为 `admin`。密码由 Web 控制台自身管理与持久化（保存在 `settings.json` 中，重启稳定保留），不在加载项选项暴露；登录后请在面板中及时修改。
- **API 密钥管理**：留空表示由 Web 控制台自主管理 API 密钥；在 HA 配置页面填入非空 `API_KEY` 时，若面板已启用 `api_keys` 多 Key 列表，仅非破坏性地更新/插入 `id="ha-option"` 条目（保留其余自建分域/限账号 Key）。
- 容器时区自动同步 Home Assistant 主机时区（零选项自动继承）。
- 管理面板大量使用根路径请求（`/credits/probe`、`/panel/status`、`/admin/routing`），故不启用 HA Ingress，请通过 **打开 Web UI** 或 `http://<你的HA>:8790` 访问。

> ⚠️ 合规提示：请仅在受信任内网或反向代理鉴权保护下使用，勿将 `8790` 端口直接暴露于公网，并遵守上游服务条款。

## 3. 环境变量与默认策略（unset vs 预置）

S6 启动脚本通过 `_export_str` 仅在配置非空且不为 `null` 时导出环境变量：

- **容器固定预置（非用户选项）**：`HOST=0.0.0.0`、`PORT=8790`、`QD_LOG_DIR=/data/logs`、`QD_PROXY_USAGE_DIR=/data/usage`、`QD_PROXY_PYTHON=/usr/bin/python3`。
- **冷启动与网络选项（用户 options）**：`API_KEY`（写入 `settings.json`）、`HTTPS_PROXY`（可选出站代理）。
- **折叠高级 Schema 覆盖项**：`QD_CN_VPC_ENDPOINT`、`QD_PROXY_DEFAULT_REALM`（未设由上游默认 `cn`）、`QD_SESSION_CACHE`（未设由上游默认 `off`）、`QD_ANTHROPIC_THINKING`（未设时跟随面板全局与单 Key 配置）。

## 4. 常用客户端端点

| 端点 | 用途 |
|---|---|
| `http://<你的HA>:8790/` | Web 管理面板 |
| `http://<你的HA>:8790/v1` | OpenAI 兼容 Base URL |
| `http://<你的HA>:8790/v1/messages` | Anthropic Messages 兼容端点 |
| `http://<你的HA>:8790/ping` | 健康探针（固定返回 200） |

## 5. 持久化存储规划

| 容器路径 | HA 映射来源 | 内容 | 是否随 HA 备份 |
|---|---|---|---|
| `/app/accounts` | `app_config` (`/addon_configs/qoder2api-hub`) | 账号 JSON、`settings.json`、`machine_identity.json`、`scheduler/` | ✅ |
| `/data/logs` | `/data/logs` | 运行日志（`gateway.log`、`gateway.err.log`） | ❌ |
| `/data/usage` | `/data/usage` | 用量统计 JSONL 与汇总缓存 | ❌ |

如曾手动在 `/config/qoder2api-hub` 放置旧版账号文件且 `/app/accounts` 为空，首次启动时会自动完成单向迁入。

## 6. 故障排查

1. **国际区无法连接或超时**
   - 检查网络连通性；需要走代理时请在配置项填入 `HTTPS_PROXY`（如 `http://192.168.1.2:7890`）。
2. **忘记面板密码或 API Key**
   - 面板原生默认密码为 `admin`，若曾修改可在 `/app/accounts/settings.json` 中查看或编辑重置；API Key 亦可在该文件中查阅或在 Web 控制台重新生成。
3. **企业内网专用网关接入**
   - 如使用企业 VPC 专用域且触发私网 SSRF 拦截，请将专用地址填入 `QD_CN_VPC_ENDPOINT`。
