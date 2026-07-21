# FileBrowser Quantum HA Addon

## 概述

FileBrowser Quantum 是一个现代化、响应式的 Web 文件管理器，支持多源文件浏览、高级认证选项和实时索引。

上游项目: [gtsteffaniak/filebrowser](https://github.com/gtsteffaniak/filebrowser)

## 功能特性

- ✅ 现代化响应式 UI
- ✅ 多源文件支持（本地、S3、WebDAV、FTP）
- ✅ 实时搜索和索引
- ✅ 多种认证方式（密码、OIDC、LDAP、JWT、代理）
- ✅ 文件预览（PDF、Markdown、Office、视频、音频）
- ✅ 文件共享和权限管理
- ✅ 目录级访问控制
- ✅ API 支持（Swagger 文档）

## 默认凭据

- 用户名: `admin`
- 密码: `admin`

**重要**: 首次登录后请立即修改默认密码！

## 配置选项

| 选项 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `auth_method` | string | `password` | 认证方式 (password/noauth/proxy/oidc) |
| `default_user_scope` | string | `/` | 默认用户文件浏览根目录 |
| `localdisks` | string | | 本地磁盘挂载 (如 sda1,sdb1) |
| `networkdisks` | string | | SMB 共享挂载 (如 //SERVER/SHARE) |

## 持久化数据

- `/config` - 配置文件和数据库
- `/share` - 共享文件目录

## 端口

- `8080` - Web UI 端口

## Ingress

支持 HA Ingress，可通过侧边栏直接访问。
