# 推送代码到 GitHub

老板，按以下步骤操作：

## 步骤 1：创建 GitHub 仓库

1. 打开 https://github.com/new
2. 仓库名：`openclaw-mobile`
3. 设为公开或私有都可以
4. **不要** 勾选 "Add a README file"
5. 点击 **Create repository**

## 步骤 2：执行推送命令

在 PowerShell 中执行（替换 `你的用户名` 为你的 GitHub 用户名）：

```powershell
cd C:\Users\web3pc1\.openclaw\workspace\openclaw-mobile

# 关联远程仓库（替换为你的仓库地址）
git remote add origin https://github.com/你的用户名/openclaw-mobile.git

# 重命名分支为 main
git branch -M main

# 推送到 GitHub
git push -u origin main
```

## 步骤 3：查看构建进度

1. 打开你的 GitHub 仓库页面
2. 点击 **Actions** 标签
3. 看到构建任务正在运行
4. 等待约 10-15 分钟

## 步骤 4：下载 APK

构建完成后：

1. 在 Actions 页面点击最新的构建（绿色勾）
2. 滚动到页面底部
3. 找到 **Artifacts** 区域
4. 点击 `openclaw-mobile-apk` 下载
5. 解压后得到 `app-release.apk`

## 步骤 5：安装测试

1. 把 APK 传输到手机
2. 安装（可能需要允许"未知来源"）
3. 打开 APP 开始使用！

---

## 🔧 如果推送失败

### 错误：权限被拒绝

```bash
# 使用 HTTPS 方式（需要输入 GitHub 账号密码/Token）
git remote set-url origin https://github.com/你的用户名/openclaw-mobile.git
git push -u origin main
```

### 错误：仓库已存在

```bash
# 删除远程重新添加
git remote remove origin
git remote add origin https://github.com/你的用户名/openclaw-mobile.git
git push -u origin main
```

---

## 📱 后续更新代码后推送

```bash
cd openclaw-mobile
git add .
git commit -m "更新说明"
git push
```

会自动触发新的构建！

---

_祝部署成功！_ 🚀
