# OpenClaw Termux 自动部署脚本

在安卓手机上自动部署完整的 OpenClaw 环境。

## 使用方法

### 方式 1：手动执行

```bash
# 在 Termux 中运行
curl -fsSL https://raw.githubusercontent.com/your-repo/openclaw-mobile/main/termux/install.sh | bash
```

### 方式 2：APP 自动推送

安卓 APP 通过 Termux API 自动执行此脚本。

## 脚本功能

1. ✅ 更新 Termux 包
2. ✅ 安装 Python 3.12
3. ✅ 安装 Node.js LTS
4. ✅ 安装 Git
5. ✅ 安装 OpenClaw Gateway
6. ✅ 安装 Agent Reach
7. ✅ 配置环境变量
8. ✅ 启动 Gateway 服务
9. ✅ 生成访问 Token
10. ✅ 返回连接信息给 APP

## 输出

脚本执行完成后输出 JSON 格式的连接信息：

```json
{
  "success": true,
  "gateway_host": "127.0.0.1",
  "gateway_port": 18789,
  "gateway_token": "xxx-xxx-xxx",
  "status": "running"
}
```
