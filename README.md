# HomeAssistant-Addons

Home Assistant 自定义 Add-on 仓库

## Add-ons

| Add-on | 描述 | 版本 | 上游 |
|---|---|---|---|
| [AList-TvBox](alist-tvbox/) | AList proxy server for TvBox, support playlist and search | ![](https://img.shields.io/badge/dynamic/yaml?label=version&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/alist-tvbox/config.yaml) | [power721/alist-tvbox](https://github.com/power721/alist-tvbox) |
| [AList-TvBox Standalone](alist-tvbox-standalone/) | AList-TvBox without embedded AList kernel | ![](https://img.shields.io/badge/dynamic/yaml?label=version&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/alist-tvbox-standalone/config.yaml) | [power721/alist-tvbox](https://github.com/power721/alist-tvbox) |
| [Lucky](lucky/) | IPv6/IPv4 端口转发, DDNS, Stun 内网穿透 | ![](https://img.shields.io/badge/dynamic/yaml?label=version&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/lucky/config.yaml) | [gdy666/lucky](https://github.com/gdy666/lucky) |
| [FlareSolverr](flaresolverr/) | Bypass Cloudflare protection | ![](https://img.shields.io/badge/dynamic/yaml?label=version&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/flaresolverr/config.yaml) | [FlareSolverr/FlareSolverr](https://github.com/FlareSolverr/FlareSolverr) |
| [QD-Today](qdtoday/) | HTTP请求定时任务自动执行框架 | ![](https://img.shields.io/badge/dynamic/yaml?label=version&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/qdtoday/config.yaml) | [qd-today/qd](https://github.com/qd-today/qd) |
| [青龙面板](qinglong/) | 定时任务管理平台 | ![](https://img.shields.io/badge/dynamic/yaml?label=version&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/qinglong/config.yaml) | [whyour/qinglong](https://github.com/whyour/qinglong) |
| [白虎面板](baihu-panel/) | 轻量级定时任务管理系统 | ![](https://img.shields.io/badge/dynamic/yaml?label=version&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/baihu-panel/config.yaml) | [engigu/baihu-panel](https://github.com/engigu/baihu-panel) |
| [FileBrowser Quantum](filebrowser-quantum/) | 现代化 Web 文件管理器 | ![](https://img.shields.io/badge/dynamic/yaml?label=version&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/filebrowser-quantum/config.yaml) | [gtsteffaniak/filebrowser](https://github.com/gtsteffaniak/filebrowser) |

## 特性

- 所有 addon 使用 HA 标准底包 (`ghcr.io/hassio-addons/debian-base`)
- 支持 HA 原生备份和文件管理
- 支持 Healthcheck 健康检查
- 支持 Ingress 反向代理
- 自动版本检测和更新（每6小时检查一次）
- 多架构支持 (amd64/arm64)

## 安装

1. 在 Home Assistant 中添加此仓库 URL: `https://github.com/solarflows/HomeAssistant-Addons`
2. 在 Add-on Store 中找到需要的 Add-on
3. 安装并配置