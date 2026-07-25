# HomeAssistant-Addons

[![Version Check](https://img.shields.io/github/actions/workflow/status/solarflows/HomeAssistant-Addons/Version_Check.yml?label=Version%20Check&logo=githubactions&logoColor=white)](https://github.com/solarflows/HomeAssistant-Addons/actions/workflows/Version_Check.yml)
[![Release](https://img.shields.io/github/actions/workflow/status/solarflows/HomeAssistant-Addons/Release.yml?label=Release&logo=githubactions&logoColor=white)](https://github.com/solarflows/HomeAssistant-Addons/actions/workflows/Release.yml)
[![License](https://img.shields.io/github/license/solarflows/HomeAssistant-Addons)](LICENSE)

> Home Assistant 自定义 Add-on 仓库 · Maintained by [solarflows](https://github.com/solarflows)

---

## 📦 Add-ons

| Add-on | 版本 | 下载量 | 架构 | 描述 |
|:---|:---:|:---:|:---:|:---|
| [AList-TvBox](alist-tvbox/) | ![](https://img.shields.io/badge/dynamic/yaml?color=blue&label=&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/alist-tvbox/config.yaml) | ![](https://img.shields.io/badge/dynamic/json?color=blue&label=&query=%24.package_version_downloads&url=https%3A%2F%2Fipkgghcr01.azurefd.net%2Fdownloads%2Fsolarflows%2Falist-tvbox%2Flatest.json) | amd64 · arm64 | AList proxy server for TvBox |
| [AList-TvBox Standalone](alist-tvbox-standalone/) | ![](https://img.shields.io/badge/dynamic/yaml?color=blue&label=&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/alist-tvbox-standalone/config.yaml) | ![](https://img.shields.io/badge/dynamic/json?color=blue&label=&query=%24.package_version_downloads&url=https%3A%2F%2Fipkgghcr01.azurefd.net%2Fdownloads%2Fsolarflows%2Falist-tvbox-standalone%2Flatest.json) | amd64 · arm64 | AList-TvBox without embedded AList kernel |
| [Lucky](lucky/) | ![](https://img.shields.io/badge/dynamic/yaml?color=blue&label=&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/lucky/config.yaml) | ![](https://img.shields.io/badge/dynamic/json?color=blue&label=&query=%24.package_version_downloads&url=https%3A%2F%2Fipkgghcr01.azurefd.net%2Fdownloads%2Fsolarflows%2Flucky%2Flatest.json) | amd64 · arm64 | IPv6/IPv4 端口转发 · DDNS · 内网穿透 |
| [FlareSolverr](flaresolverr/) | ![](https://img.shields.io/badge/dynamic/yaml?color=blue&label=&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/flaresolverr/config.yaml) | ![](https://img.shields.io/badge/dynamic/json?color=blue&label=&query=%24.package_version_downloads&url=https%3A%2F%2Fipkgghcr01.azurefd.net%2Fdownloads%2Fsolarflows%2Fflaresolverr%2Flatest.json) | amd64 · arm64 | Bypass Cloudflare anti-bot protection |
| [QD-Today](qdtoday/) | ![](https://img.shields.io/badge/dynamic/yaml?color=blue&label=&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/qdtoday/config.yaml) | ![](https://img.shields.io/badge/dynamic/json?color=blue&label=&query=%24.package_version_downloads&url=https%3A%2F%2Fipkgghcr01.azurefd.net%2Fdownloads%2Fsolarflows%2Fqdtoday%2Flatest.json) | amd64 · arm64 | HTTP 请求定时任务自动执行框架 |
| [青龙面板](qinglong/) | ![](https://img.shields.io/badge/dynamic/yaml?color=blue&label=&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/qinglong/config.yaml) | ![](https://img.shields.io/badge/dynamic/json?color=blue&label=&query=%24.package_version_downloads&url=https%3A%2F%2Fipkgghcr01.azurefd.net%2Fdownloads%2Fsolarflows%2Fqinglong%2Flatest.json) | amd64 · arm64 | 支持 Python/JS/Shell/TS 的定时任务管理平台 |
| [白虎面板](baihu-panel/) | ![](https://img.shields.io/badge/dynamic/yaml?color=blue&label=&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/baihu-panel/config.yaml) | ![](https://img.shields.io/badge/dynamic/json?color=blue&label=&query=%24.package_version_downloads&url=https%3A%2F%2Fipkgghcr01.azurefd.net%2Fdownloads%2Fsolarflows%2Fbaihu-panel%2Flatest.json) | amd64 · arm64 | 轻量级定时任务管理系统 |
| [FileBrowser Quantum](filebrowser-quantum/) | ![](https://img.shields.io/badge/dynamic/yaml?color=blue&label=&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/filebrowser-quantum/config.yaml) | ![](https://img.shields.io/badge/dynamic/json?color=blue&label=&query=%24.package_version_downloads&url=https%3A%2F%2Fipkgghcr01.azurefd.net%2Fdownloads%2Fsolarflows%2Ffilebrowser-quantum%2Flatest.json) | amd64 · arm64 | 现代化 Web 文件管理器 |
| [Uptime Kuma](uptime-kuma/) | ![](https://img.shields.io/badge/dynamic/yaml?color=blue&label=&query=$.version&url=https://raw.githubusercontent.com/solarflows/HomeAssistant-Addons/main/uptime-kuma/config.yaml) | ![](https://img.shields.io/badge/dynamic/json?color=blue&label=&query=%24.package_version_downloads&url=https%3A%2F%2Fipkgghcr01.azurefd.net%2Fdownloads%2Fsolarflows%2Fuptime-kuma%2Flatest.json) | amd64 · arm64 | 自托管监控工具 |

---

## ✨ 特性

- 🏗️ 基于 HA 标准底包 (`debian-base:9.3.0` + S6 overlay)
- 💾 支持 HA 原生备份和文件管理
- 🏥 Docker HEALTHCHECK 健康检查
- 🔀 Ingress 反向代理（部分 addon）
- 🔄 自动版本检测和 CI 构建（每 6 小时）
- 🏛️ 多架构支持 (`amd64` / `arm64`)

## 🚀 安装

1. 在 Home Assistant 中添加此仓库 URL：
   ```
   https://github.com/solarflows/HomeAssistant-Addons
   ```
2. 在 **Add-on Store** 中找到需要的 Add-on
3. 安装并配置

## 📖 文档

每个 Add-on 目录下包含：
- `DOCS.md` — 使用说明和配置指南
- `CHANGELOG.md` — 版本变更记录
- `translations/` — 多语言翻译（en / zh-Hans）

## 📄 License

[MIT](LICENSE)