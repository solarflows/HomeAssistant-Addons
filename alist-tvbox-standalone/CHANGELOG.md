### 1.46.1 (2026-08-15)
# Release Notes - 1.46.1

## 修复

- 修复播放记录同步问题：更新内置同步引擎，进一步修复播放记录同步

# Release Notes - 1.46.0

## 修复

- 修复播放记录同步的坐标问题：续播 ID 携带多级导航信息（分组、源、子分组），网盘资源换端续播可准确定位到对应剧集
- 播放历史新增记录网盘路径，多播放线路切换后同步不丢进度
- 修复播放记录数据迁移的序列水位问题，避免历史记录重复迁移

## 优化

- 订阅配置编辑界面：站点分组和上游解析接口新增 全选 / 全不选 / 反选 批量操作按钮

### 1.45.2 (2026-08-15)
# Release Notes - 1.45.2

## 修复

- 修复原生镜像（native image）版本缺少播放记录相关数据库迁移的问题，避免升级后启动报错

### 1.45.1 (2026-08-14)
# Release Notes - 1.45.1

## 新增

- 新增多端播放记录同步：安卓手机、安卓 TV、桌面端、网页端的观看进度和播放记录可自动同步，换设备续看不丢进度
- 安卓端（FongMi / OK影视 等）通过更新后的爬虫 jar 自动上报播放记录，无需额外配置
- 播放记录支持跨设备删除同步，一端删除、多端生效

## 优化

- 升级数据库结构，历史播放记录自动平滑迁移，无需手动处理

### 1.44.0 (2026-08-11)
# Release Notes - 1.44.0

## 新增

- 新增百度分享免转存开关，可自行选择百度分享是否走免转存直链
- 新增夸克、UC 分享免转存开关，默认开启

## 修复
- 修复strm

## 优化

- 网盘相关配置从「配置」页面移到「网盘账号」页面，并按代理配置、免转存直链、跨网盘秒传、转存策略、校验清理、离线下载分组展示

### 1.43.0 (2026-08-09)
# Release Notes - 1.43.0

## 修复

- 修复B站

### 1.42.0 (2026-08-08)
# Release Notes - 1.42.0

## 新增

- 获取网盘账号详情

### 1.41.1 (2026-08-08)
# Release Notes - 1.41.1

## 修复

- 修复网盘播放历史标题

## 优化
- 优化桌面端API

### 1.41.0 (2026-08-07)
# Release Notes - 1.41.0

## 修复

- 修复网盘播放历史标题

### 1.40.2 (2026-08-05)
# Release Notes - 1.40.2

## 优化

- 优化插件剧名识别
- 优化剧名识别

## 其他

- 更新豆瓣电影数据

### 1.40.0 (2026-08-05)
# Release Notes - 1.40.0

## 优化

- 优化插件剧名识别

### 1.38.0 (2026-08-03)
# Release Notes - 1.38.0

## 新增

- 夸父逐日

### 1.37.1 (2026-08-03)
# Release Notes - 1.37.1

## 优化

- 优化多线程代理

## 修复

- 修复账号负载均衡

### 1.37.0 (2026-08-02)
# Release Notes - 1.37.0

## 优化

- 优化多线程代理

### 1.36.0 (2026-08-01)
# Release Notes - 1.36.0

## 优化

- 优化123免转存

### 1.35.1 (2026-08-01)
# Release Notes - 1.35.1

## 新增

- Spider 插件支持自声明配置结构：插件可通过 `PLUGIN_CONFIG_SCHEMA` 声明自身需要的配置项（站点、账号、密码、Cookie 等），订阅页自动渲染配置表单，免手写 extend JSON；加密 `.txt` 也可通过明文 `//@config-schema:` 头声明配置结构
- 播放配置新增独立「盘检地址」与「盘检超时」：盘检（网盘链接有效性检测）不再硬编码到 PanSou，改为按优先级回退选择检测后端——盘检地址（PanCheck）> TG-Search > PanSou；盘检超时（ms）可选，仅对 TG-Search 生效

### 1.33.0 (2026-08-01)
# Release Notes - 1.33.0

## 修复

- 修复多线程代理

### 1.32.0 (2026-07-30)
# Release Notes - 1.32.0

## 新增

- 片单导航支持配置首页内容
- 片单导航新增「分类模式」开关（全部/精简），精简模式合并子分类与筛选下钻（豆瓣分类/榜单、TMDB 电影/剧集），浏览、电影片库、剧集片库保持独立

### 1.31.0 (2026-07-30)
# Release Notes - 1.31.0

## 新增

- 新增 123 Open 网盘驱动，支持阿里云盘、115、光鸭网盘秒传到 123 网盘

## 修复

- 修复 123 分享链接解析失败的问题

### 1.30.0 (2026-07-28)
# Release Notes - 1.30.0

## 新增

- 盘搜网盘分组
- 观影网盘分组

### 1.29.1 (2026-07-27)
# Release Notes - 1.29.1

## 新增

- 新增「片单」导航源，可作为订阅站点浏览分类、首页与列表内容，支持 token 访问校验
- 更多TMDB分类
- 百度网盘账号支持「自动签到」，可在网盘账号中开启

## 修复

- 修复片单内容项无法触发搜索的问题

### 1.29.0 (2026-07-27)
# Release Notes - 1.29.0

## 新增

- 新增「片单」导航源，可作为订阅站点浏览分类、首页与列表内容，支持 token 访问校验
- 百度网盘账号支持「自动签到」，可在网盘账号中开启

## 修复

- 修复片单内容项无法触发搜索的问题

### 1.28.0-build.12 (2026-07-26)
rootfs 变更
- 修复 alist-tvbox 容器启动失败问题
- build(alist-tvbox-standalone): rootfs 变更 → 1.28.0-build.11

### 1.28.0-build.11 (2026-07-25)
rootfs 变更
- fix: standalone 创建 /data/atv/config/ + baihu /app/data 持久化 symlink

### 1.28.0-build.10 (2026-07-25)
CI 变更

### 1.28.0-build.9 (2026-07-25)
CI 变更

### 1.28.0-build.8 (2026-07-25)
CI 工作流变更
无提交信息

### 1.28.0-build.7 (2026-07-25)
CI 工作流变更
无提交信息

### 1.28.0-build.6 (2026-07-25)
CI 工作流变更
无提交信息

### 1.28.0-build.5 (2026-07-25)
rootfs 脚本/配置变更
无提交信息

### 1.28.0-build.4 (2026-07-25)
rootfs 脚本/配置变更
无提交信息

### 1.28.0-build.3 (2026-07-25)
Dockerfile 变更
无提交信息

### 1.28.0-build.2 (2026-07-25)
Dockerfile 变更
无提交信息

### 1.28.0-build.1 (2026-07-25)
Dockerfile 变更
无提交信息

### 1.28.0 (2026-07-25)
# Release Notes - 1.28.0

## 修复

- 修复剧集季目录（如 `S01`）在播放列表详情中显示为季标记或误匹配其他影视名称的问题，并兼容点号分隔的中文目录名
- 修复 Atvp 对延迟解析分享链接处理不完整，导致部分分享内容无法正确打开的问题

### 1.27.0-build.4 (2026-07-24)
CI 工作流变更
无提交信息

### 1.27.0-build.3 (2026-07-24)
CI 工作流变更
fix(baihu): add BH_SERVER_URL_PREFIX for Ingress support; fix(ci): config/version.yaml changes no longer trigger rebuild

### 1.27.0-build.2 (2026-07-24)
CI 工作流变更
fix(ci): show per-architecture compressed size using regctl in build summary

### 1.27.0-build.1 (2026-07-24)
CI 工作流变更
fix(ci): list built architectures in summary using jq from raw manifest

### 1.27.0 (2026-07-24)
# Release Notes - 1.27.0

## 新增

- 新增「盘搜配置」独立页面，支持配置搜索并发数、刷新、返回结果数、过滤等参数，并持久化保存
- 盘搜链接检测支持按网盘类型选择检测范围，可单独勾选需要检测的盘类型
- 新增本地资源自动更新功能，定时检查并自动下载 packages / index / douban / 115 资源（含夜间随机抖动，避免高峰）

## 优化

- 盘搜「链接检测」入口调整至基础配置，标签页重命名为「盘搜配置」
- 优化电报频道展示效果
- 更新百度网盘 UA

## 修复

- 修复电报标题装饰前缀未正确剥离的问题

### 1.26.0-build.16 (2026-07-24)
Dockerfile 变更
feat: ja3 curl-impersonate + pycurl-ja3 + sign labels

### 1.26.0-build.15 (2026-07-24)
CI 工作流变更
fix(ci): 过滤 bot 提交避免 CI 自触发 config.yaml 循环重建

### 1.26.0-build.14 (2026-07-24)
CI 工作流变更
fix(ci): file_sha 在 commit 后更新，避免 CI 自触发的 config.yaml 循环重建

### 1.26.0-build.13 (2026-07-23)
config.yaml/version.yaml 变更
build(qdtoday): Dockerfile 变更 → 20250803-build.14

### 1.26.0-build.12 (2026-07-23)
CI 工作流变更
fix(s6): stage2_hook 后台轮询等待 legacy-services 就绪

### 1.26.0-build.11 (2026-07-23)
Dockerfile 变更
feat: S6_STAGE2_HOOK for all S6 addons

### 1.26.0-build.10 (2026-07-23)
config.yaml/version.yaml 变更
build(filebrowser-quantum): CI 工作流变更 → 1.5.0-stable-build.8

### 1.26.0-build.9 (2026-07-23)
CI 工作流变更
fix(s6): cont-init 末尾 rm down 文件，修复 legacy-services 不自动启动

### 1.26.0-build.8 (2026-07-23)
CI 工作流变更\nMerge branch 'main' of https://github.com/solarflows/HomeAssistant-Addons

### 2026-07-23 - rootfs 脚本/配置变更: fix(s6): run 脚本添加 SIGTERM trap，防止停止时产生孤儿进程

### 2026-07-23 - config.yaml/version.yaml 变更: build(lucky): CI 工作流变更 → 2.27.2-build.6

### 2026-07-23 - CI 工作流变更: docs(skills): ha-addon-conventions 精简为英文核心模式 (220→110行)

### 2026-07-23 - fix(ci): 三处增强保证 rootfs/workflow 变更触发构建

### 2026-07-23 - 手动触发强制重建

### 2026-07-23 - 手动触发强制重建

### 2026-07-22 - 底包更新至 v9.3.0，无功能变更


### 1.26.0 (2026-07-21)
# Release Notes - 1.26.0

## 新增

- 支持 UC 网盘、夸克网盘分享链接的「免转存」直链播放
