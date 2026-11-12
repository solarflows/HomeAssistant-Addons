---
name: fix-ci
description: 调试和修复 GitHub Actions CI/CD 问题。构建失败、工作流语法错误、发布管道异常时使用。
---

# CI/CD 故障排查与修复指南

## CI 架构流水线
```
Version_Check (6h 定时巡检 / push 变更触发 / 手动 dispatch) → workflow_call → Release → 各加载项多架构构建 → 推送 ghcr.io → 原子回写提交
```

## 工作流关键契约

### Version_Check.yml
- **触发源**：`push`（限定核心构建文件与 workflow 路径）、定时任务（`cron: 0 */6 * * *`）与手动调度（`workflow_dispatch`）。
- **职责**：侦测上游 Release/Tag/Date/Commit/Asset 变更、多依赖组件更新、debian-base 底包变动及各插件自身构建文件改动，生成构建 matrix JSON。
- **权限需求**：`contents: write, actions: write, packages: write`。
- **防滚木死循环红线（独立指针隔离）**：
  - 在 `schedule` / `workflow_dispatch` 模式下，每个插件必须且只能以**自己 `version.yaml` 中的 `tracking.file_sha..HEAD`** 作为基准，筛选修改了自己 `${ADDON_DIR}/Dockerfile` 或 `${ADDON_DIR}/rootfs/` 的非 bot（排除 `github-actions[bot]`）提交。
  - **严禁选取某一个插件的 `file_sha` 作为全局基线**去 diff 全部插件，否则只要低频插件不构建导致旧 SHA 滞留，所有后续修改过的插件都会每 6 小时被反复误判为 `rootfs` 变更引发滚木更新。
- **全量 Git 历史要求**：`Version_Check.yml` 与 `Release.yml` 的 `actions/checkout@v4` 必须保留 `fetch-depth: 0`（禁止浅克隆），防止超过 100 commits 后低频插件丢失其 `file_sha` 对象。
- **触发优先级与复合原因**：`version_changed` > `base_updated` > `file_changed` > `force_rebuild`；多个文件变动时用逗号拼接（如 `dockerfile,rootfs`）。
- **多依赖监控**：`version.yaml` 声明 `dependencies:`；当任意副依赖更新时，生成包含 `updated_deps` 的 matrix。
- **安全逃生阀 (`[skip-rebuild]`)**：当 `push` 修改了 `.github/workflows/Release.yml` 但无需全仓重建镜像时，提交信息中务必携带 `[skip-rebuild]`。

### Release.yml
- **触发源**：`workflow_call`（由 Version_Check 派发）。
- **执行任务**：matrix 并行构建多架构镜像，自动拼接 `version_template`，渲染 CHANGELOG，回写更新自身 `tracking.file_sha` 与 `build_num` 并原子提交。
- **版本号计算**：由 upstream 版本、可选前缀/后缀或模板控制，经正则过滤满足 HA 要求并与推送到 ghcr.io 的 tag 严格一致。
- **复合触发判断**：先按逗号拆分 `REASON` 提取 `IS_VERSION_CHANGE` 与 `IS_FILE_TRIGGER`，严禁使用前缀匹配。
- **不可回退红线**：已构建发布到 GHCR 的 `-build.N` 版本号与 `config.yaml.version` **禁止手动降级回退**，否则已升级设备的 HA Supervisor 将拒绝更新或校验失败。

## GitHub Actions 常见陷阱与规范
- 严禁在 `run: |` 脚本中直接内嵌动态表达式（如 `${{ github.event... }}`）；必须通过 step 的 `env:` 映射后消费。
- `${{ }}` 表达式内部的字符串字面量强制使用单引号（禁止双引号字面量如 `"{}"`）。
- 跨步骤多行变量输出强制使用 heredoc 格式输出至 `$GITHUB_OUTPUT`：
```bash
{
  echo "matrix<<EOF"
  echo "${JSON}"
  echo "EOF"
} >> "${GITHUB_OUTPUT}"
```

## 提交与推送重试
- 各加载项独立原子提交：`chore(${ADDON}): update to ${VERSION}`。
- 推送冲突防范：设置 3 次指数退避拉取与重试（`git pull --rebase`），最终重试失败必须显式 `exit 1`，严禁静默吞掉报错。
