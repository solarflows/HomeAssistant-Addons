---
name: update-addon
description: 手动更新已有 HA 加载项。上游版本变更、架构调整或构建失败时人工介入。
---

# 加载项手动更新指南

## 适用场景
- CI 触发 `version_changed` 但构建失败中断。
- 上游引入破坏性变更（新依赖、基础镜像更换、VOLUME 变动）。
- 需要调整持久化软链接或初始化脚本。
- 需要手动介入版本发布与调优。

## 操作步骤

### 1. 排查 CI 失败原因
- 查看 `Release.yml` 工作流的运行日志。
- 定位失败的加载项与具体阶段（`docker buildx`、`push` 或 `git commit`）。
- 常见根因：缺失构建 ARG、工具链版本不兼容、构建期网络中断。

### 2. 对比上游代码变更
- 通过 GitHub Compare 查看版本间差异：`https://github.com/<owner>/<repo>/compare/<old>...<new>`。
- 重点比对上游 `Dockerfile` 与 `entrypoint.sh` 的变动。
- 检查是否存在新增或移动的 VOLUME、环境变量及依赖库。

### 3. 适配加载项文件
- 上游路径变动：同步更新 `00-init.sh` 中的软链接目标。
- 构建工具链升级：在 `Dockerfile` 中切换匹配的 builder 镜像。
- 新增配置项：在 `config.yaml` 的 `options` 与 `schema` 中追加声明。

### 4. 触发更新发布
- 通过 GitHub Actions 手动执行 `Version_Check.yml`（选择对应加载项），或更新 `version.yaml` 后推送。

### 5. 沉淀排查经验
将排查出的典型故障与解决方案追加至 `.github/instructions/addon-troubleshooting.instructions.md`。
