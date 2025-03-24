# 开眼

一个使用 Flutter 开发的 开眼 第三方客户端应用，提供了 开眼 App 的主要功能和内容展示。

## 开始使用

### 环境要求

- Flutter 3.29.2 或更高版本
- Dart 3.7.2 或更高版本
- DevTools 2.42.3 或更高版本

### 安装步骤

#### 方法一：使用 FVM（推荐）

本项目使用 Flutter Version Management (FVM) 管理 Flutter SDK 版本，确保所有开发者使用相同的 Flutter 版本。

1. 安装 FVM：
   ```bash
   # macOS/Linux 使用 Homebrew
   brew tap leoafarias/fvm
   brew install fvm
   
   # 或使用 pub 全局安装
   dart pub global activate fvm
   ```

2. 克隆项目
   ```bash
   git clone https://github.com/JWInCoding/flutter_eyepetizer.git
   ```

3. 进入项目目录
   ```bash
   cd flutter_eyepetizer
   ```

4. 使用 FVM 安装指定的 Flutter 版本
   ```bash
   fvm install
   # 或者指定版本 
   # fvm use 3.29.2
   ```

5. 使用 FVM 获取依赖
   ```bash
   fvm flutter pub get
   ```

6. 生成多语言文件
   ```bash
   fvm flutter gen-l10n
   ```

7. 运行项目
   ```bash
   fvm flutter run
   ```

#### 方法二：直接使用 Flutter

如果您不想使用 FVM，也可以直接使用全局安装的 Flutter：

1. 确保您的 Flutter 版本为 3.29.2 或以上
   ```bash
   flutter --version
   ```

2. 克隆项目
   ```bash
   git clone https://github.com/JWInCoding/flutter_eyepetizer.git
   ```

3. 进入项目目录
   ```bash
   cd flutter_eyepetizer
   ```

4. 获取依赖
   ```bash
   flutter pub get
   ```

5. 生成多语言文件
   ```bash
   flutter gen-l10n
   ```

6. 运行项目
   ```bash
   flutter run
   ```

### IDE 配置（可选）

#### VS Code 用户

本项目已配置 VS Code 设置。如果您使用 VS Code 并安装了 FVM，无需额外配置。

#### Android Studio / IntelliJ 用户

如果使用 FVM，请在 IDE 中配置 Flutter SDK 路径指向：
`.fvm/flutter_sdk`

[参考 开眼 API](https://github.com/huanghui0906/API/blob/master/Eyepetizer.md)

### 体验应用

安卓用户可以直接从 [GitHub Releases页面](https://github.com/JWInCoding/flutter_eyepetizer/releases) 下载最新APK体验。

iOS 需要自行编译