---
name: create-addon
description: 新建 HA 加载项。从模板创建骨架目录，后续由 plan-addon 填充上游分析数据。
---

# 新建加载项指南

> **步骤 1**：按策略复制模板目录 → `cp -r .github/templates/<binary|upstream-image|source>/ <addon-slug>/`
> **步骤 2**：全局替换 `ADDON_SLUG` 为实际 slug
> **步骤 3**：运行 `plan-addon` 技能分析上游并核验 `analysis.yaml`
> **步骤 4**：依据 `analysis.yaml` 补齐 `config.yaml`、`Dockerfile` 及 `rootfs` 脚本
> **步骤 5**：本地 buildx 验证后推送到 main 分支，CI 自动触发构建

## 架构模板选型

仓库在 `.github/templates/` 维护 3 套生产级骨架模板（详见 [.github/templates/README.md](.github/templates/README.md)）：

| 模板路径 | 适用场景 | 核心特征 |
|---|---|---|
| `.github/templates/binary/` | 上游 Release 提供预编译二进制（推荐首选） | debian-base + S6 overlay + 自动多架构映射与下载重试 |
| `.github/templates/upstream-image/` | 上游环境极其复杂且已提供优质 Docker 镜像 | 无 S6 + dumb-init + ha-entrypoint 注入环境 |
| `.github/templates/source/` | 上游仅提供源码，需自主编译 | 多阶段构建（内置 GOPROXY 多代理容灾）+ debian-base 运行时 |

## 目录骨架结构 (以 binary 模板为例)

所有占位符统一使用 `ADDON_SLUG`：

```
.github/templates/binary/
├── analysis.yaml              # 上游分析产物（由 plan-addon 填充）
├── config.yaml                # 加载项基础清单
├── Dockerfile                 # 多架构下载与装配文件
├── version.yaml               # 版本与依赖追踪
├── rootfs/etc/cont-init.d/
│   └── 00-init.sh             # 目录初始化与软链接建立
├── rootfs/etc/s6-overlay/
│   ├── scripts/
│   │   └── stage2_hook.sh     # S6 stage2 启动钩子
│   └── s6-rc.d/ADDON_SLUG/    # 需重命名为目标 <slug>
│       ├── run                # 前台启动脚本 (longrun)
│       └── type               # 文件内容为: longrun
├── translations/
│   ├── en.yaml
│   └── zh-Hans.yaml
├── README.md
└── CHANGELOG.md               # 由 CI 自动生成与维护
```

## 快速上手命令

```bash
# 1. 复制模板（根据策略选用 binary, upstream-image 或 source）
cp -r .github/templates/binary/ <addon-slug>/

# 2. 全局替换占位符（config.yaml slug, Dockerfile, 00-init.sh, run, translations, README）

# 3. 若使用 binary 或 source 模板，重命名 S6 服务目录：
mv <addon-slug>/rootfs/etc/s6-overlay/s6-rc.d/ADDON_SLUG \
   <addon-slug>/rootfs/etc/s6-overlay/s6-rc.d/<slug>/

# 4. 完善 config.yaml（url, webui, ports, description）
# 5. 完善 Dockerfile 与脚本
# 6. 本地验证无误后登记至 AGENTS.md 列表
```

# 4. 完善 config.yaml（url, webui, ports, description）
# 5. 实现 Dockerfile 构建逻辑
# 6. 配置 00-init.sh 建立持久化软链接
# 7. 配置 run 脚本前台 exec 主程序
# 8. 登记至 AGENTS.md 列表
```

## version.yaml 声明范例
```yaml
version: "0.0.0"
repo: owner/repo
# strategy: release (默认) | tags | date (无版本号/滚动更新) | commits | asset
build_args:
  APP_VERSION: "${version}"
# 可选：多仓库组合版本号拼接控制 (可自由控制组件次序与分隔符，如 "${PANEL_VERSION}-${version}")
# version_template: "${version}-${PANEL_VERSION}"
# version_suffix: "${PANEL_VERSION}"  # 旧版语法，向后兼容
# dependencies:
#   PANEL_VERSION:
#     repo: owner/panel-repo
#     strategy: release
changelog:
  source: release_body
```
