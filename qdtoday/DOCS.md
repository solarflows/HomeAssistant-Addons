# QD-Today

基于 HAR Editor 和 Tornado Server 的 HTTP 请求定时任务自动执行框架。

## 快速开始

启动后访问：`http://<HA-IP>:8923`

默认账户：首次访问时自动进入注册页面，首个用户为管理员。

## 核心功能

### HAR 编辑器
从浏览器开发者工具导出的 HAR 文件导入 HTTP 请求模板：
1. 打开浏览器 F12 → Network → Export HAR
2. 在 QD 中 `新建模板` → `HAR 编辑器` → 粘贴 HAR 内容
3. 解析后可编辑请求头、Cookie、Body 等参数

### 定时任务
- Cron 表达式定时
- 间隔执行
- 倒计时执行
- 手动触发

### 模板变量
支持 Jinja2 模板语法，可实现：
- 请求参数动态化
- Cookie 自动更新
- 多步骤流程编排

## 配置说明

常用配置在加载项 UI 中直接修改；高级配置需手动编辑 YAML：

```yaml
USE_PYCURL: true        # 启用 PycURL 加速 HTTP 请求
DNS_SERVER: "8.8.8.8"   # 指定 DNS 服务器
PROXIES: "socks5://127.0.0.1:1080|http://127.0.0.1:8080"
MAIL_SMTP: "smtp.gmail.com"
MAIL_PORT: 465
MAIL_USER: "user@gmail.com"
MAIL_PASSWORD: "app-password"
```

## 数据持久化

- `/config/qd` — QD 数据库和配置文件

## 上游文档

- [qd-today/qd](https://github.com/qd-today/qd)
- [部署指南](https://github.com/qd-today/qd/tree/master/web/docs/zh_CN/guide)
