---
name: addon-editing
description: "修改或创建 Home Assistant 加载项规范：CI托管字段保护、Ingress 决策、00-init 退出码与上游脚本复用。"
applyTo: "**/config.yaml **/00-init.sh **/run **/Dockerfile"
---

# 加载项编辑规范

## CI 托管字段（严禁手动修改）

以下字段由 CI 工作流自动更新，严禁人工手动修改：
- `config.yaml` 中的 `version`：由 `Release.yml` 自动计算并递增构建号。
- `CHANGELOG.md`：由 CI 从 Git 提交记录或上游 Release 说明自动生成。
- `version.yaml` 中的 `tracking` 节点（`file_sha`、`build_num`）：由 `Version_Check.yml` 自动维护。

仅在以下场景允许修改版本字段：
- 新建加载项骨架时，在模板中初始化为 `version: "0.0.0-build.0"`。
- 修复已损坏的 CI 追踪状态，且必须先与用户确认。

## Ingress 支持决策

启用 Ingress 前必须验证子路径支持能力；未验证前优先使用 `webui` 与直接端口访问。

### 允许启用 Ingress
- 应用原生支持 `baseURL` 或相对路径前缀配置。
- 能够通过轻量 Nginx 反向代理层重写请求路径。
- 上游官方文档明确声明支持反向代理与子路径。

### 禁止启用 Ingress
- 应用硬编码根路径 `/`（如 `/assets`、`/api` 绝对寻址）。
- 实测出现无限重定向循环，或静态资源报 404。
- WebSocket 连接断开且添加 `ingress_stream: true` 仍无法恢复。

### Ingress 故障特征与回退
- 浏览器报 "Too many redirects"：应用未正确处理 `baseURL`。
- 静态资源 404：前端静态资源使用了绝对根路径。
- WebSocket 握手失败：缺少 `ingress_stream: true` 配置。
- **回退策略**：从 `config.yaml` 移除 `ingress` 与 `ingress_port`，清理脚本中的 `baseURL` 逻辑，仅保留端口与 `webui: "[PROTO:http]://[HOST]:[PORT:xxxx]"`。

## 优先复用上游入口脚本

上游提供 `entrypoint.sh` 或启动脚本时，必须优先复用，避免盲目重写 S6 包装逻辑：
- 上游存在 `exec <app>`：将初始化步骤剥离入 `00-init.sh`，将最终 `exec` 语句保留在 S6 `run` 脚本。
- 上游入口脚本无后台分叉：直接在 S6 `run` 中 `exec` 调用上游入口。
- 仅在上游完全无启动脚本时，才独立编写全量初始化与运行逻辑。

## 00-init.sh 退出码处理

- 捕获非致命步骤退出码并记录警告日志，禁止无条件阻断 S6 `cont-init` 阶段。
- 严禁隐式使用 `|| true` 吞掉错误；必须显式打印退出码与失败原因。

## config.yaml 字段规范

- 移除未使用的冗余配置字段，保持清单精简清晰。
- 遇到未知字段时查阅官方规范：`https://developers.home-assistant.io/docs/apps/configuration`。

## map 目录映射对象化规范

- **禁止简写语法**：严禁使用 `addon_config:rw` 或 `config:rw` 等字符串简写，必须采用 Dict 对象格式。
- **正规军类型**：使用官方最新 `type: app_config`（旧称 `addon_config` 已被 Supervisor 弃用告警）。
- **显式可写声明**：Supervisor Schema 对 `read_only` 的默认值为 `true`；任何需要读写的挂载必须显式配置 `read_only: false`，严防容器只读故障。
- **原生路径直挂**：通过 `path: <upstream_path>` 将数据直接挂载至应用原生工作路径，彻底消灭 `00-init.sh` 中的 `ln -s` 软链胶水，防止原子写 `rename()` 断链。
- **双轨存量自愈**：统一声明 `type: homeassistant_config, path: /legacy_ha, read_only: false`，专供 `00-init.sh` 探测历史 Core 存量数据并执行一次性平滑迁移。
