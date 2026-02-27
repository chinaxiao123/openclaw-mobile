#!/bin/bash
# 重置 Flutter Android Embedding 到 V2

echo "清理 Flutter 缓存..."
flutter clean

echo "重新获取依赖..."
flutter pub get

echo "重新创建 Android 配置..."
flutter create --platforms=android .

echo "完成！请重新构建。"
