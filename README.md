# macos-clean-export

用于干净导出 macOS 文件夹的 Finder 快速操作工具。

安装后，Finder 右键菜单会增加两个操作：

- `干净压缩`：在所选文件夹旁边生成一个干净的 zip 压缩包。
- `干净复制到U盘`：将所选文件夹干净复制到 U 盘或其他外部目标位置。

导出的结果会排除常见的 macOS 元数据文件：

- `.DS_Store`
- `._*` AppleDouble 文件
- `__MACOSX`

## 为什么需要这个工具

macOS 会保存 Finder 视图状态、资源分叉、标签、隔离属性等元数据。这些信息对 macOS 有用，但把文件夹发给 Windows、Linux、NAS、U 盘或线上提交系统时，往往会变成多余文件。

常见例子包括：

```text
.DS_Store
._filename
__MACOSX/
```

`DSDontWriteNetworkStores` 之类的系统设置只能减少部分网络共享场景下的 `.DS_Store`，不能完整解决压缩包和 U 盘导出问题。这个项目只处理“导出结果”：原始文件夹保持不变，复制出去或压缩出来的结果保持干净。

## 系统要求

- macOS
- Finder
- 支持 Automator / 快速操作
- 系统自带命令行工具：`zsh`、`zip`、`zipinfo`、`rsync`、`osascript`、`plutil`

不需要安装 Homebrew。

## 安装

克隆仓库：

```bash
git clone https://github.com/<你的账号>/macos-clean-export.git
cd macos-clean-export
```

请把 `<你的账号>` 替换为实际拥有这个仓库的 GitHub 账号或组织名。

运行安装脚本：

```bash
zsh install.sh
```

安装脚本会把命令行脚本复制到：

```text
~/.local/bin/macos-clean-zip
~/.local/bin/macos-clean-copy-usb
```

同时会在下面的位置创建 Finder 快速操作：

```text
~/Library/Services/干净压缩.workflow
~/Library/Services/干净复制到U盘.workflow
```

如果右键菜单里没有立刻出现这两个操作，可以重启 Finder：

```bash
killall Finder
```

如果仍然没有出现，退出登录后重新登录一次。

## 使用方法

### 干净压缩

1. 在 Finder 中右键点击一个文件夹。
2. 选择 `快速操作`。
3. 选择 `干净压缩`。

工具会在所选文件夹旁边生成压缩包：

```text
FolderName_clean.zip
```

如果同名压缩包已经存在，工具会自动追加时间戳，避免覆盖旧文件。

### 干净复制到 U 盘

1. 在 Finder 中右键点击一个文件夹。
2. 选择 `快速操作`。
3. 选择 `干净复制到U盘`。
4. 在系统文件夹选择器中选择 U 盘或目标文件夹。

这里保留系统文件夹选择器是有意设计。现代 macOS 可能会阻止快速操作直接写入可移动磁盘；由用户手动选择目标位置后，系统会给本次操作授予写入权限。

如果目标位置已经有同名文件夹，工具会自动写入一个带时间戳的新文件夹，避免覆盖已有内容。

## 预览图

下面的预览图展示了安装后的 Finder 服务菜单。示例使用通用演示文件夹名，不依赖任何私人本机路径。

![Finder 服务菜单中显示干净复制和干净压缩操作](docs/images/finder-services-menu.svg)

## 命令行用法

也可以直接运行脚本。

创建干净压缩包：

```bash
~/.local/bin/macos-clean-zip /path/to/folder
```

复制到指定目标位置：

```bash
CLEAN_COPY_TARGET=/Volumes/USB ~/.local/bin/macos-clean-copy-usb /path/to/folder
```

`CLEAN_COPY_TARGET` 主要用于测试和脚本化场景。通过 Finder 快速操作使用时，通常会弹出目标文件夹选择器。

## 验证导出结果

检查 zip 压缩包：

```bash
zipinfo -1 FolderName_clean.zip | grep -E '(^|/)(__MACOSX(/|$)|\.DS_Store$|\._[^/]*$)'
```

没有输出就表示没有发现匹配的 macOS 元数据文件。

检查复制后的文件夹：

```bash
find /Volumes/USB/FolderName \( -name '.DS_Store' -o -name '._*' -o -name '__MACOSX' \) -print
```

没有输出就表示复制结果是干净的。

## 常见问题

### 右键菜单里没有出现快速操作

先重启 Finder：

```bash
killall Finder
```

如果还不行，退出登录后重新登录。

也可以检查工作流文件夹是否已经存在：

```bash
ls ~/Library/Services
```

### 干净复制提示“Operation Not Permitted”

请使用弹出的目标文件夹选择器，并在里面选择 U 盘或 U 盘里的某个文件夹。这样 macOS 会给快速操作授予对该位置的访问权限。

如果 macOS 仍然阻止写入，请打开：

```text
系统设置 -> 隐私与安全性
```

然后检查 `文件和文件夹`、`可移动宗卷` 或 `完全磁盘访问权限`，看是否有 Automator 相关项目，例如：

```text
Automator
Automator Workflow Runner
WorkflowServiceRunner
```

具体名称会随 macOS 版本不同而变化。

### Finder 仍然会在本地生成 .DS_Store

这是正常现象。本工具不尝试禁止 Finder 的本地行为，只保证导出的压缩包或复制后的文件夹是干净的。

安装脚本也会设置下面两个低风险偏好项：

```bash
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool TRUE
```

它们可以减少网络共享和 U 盘上的 `.DS_Store`，但不能替代这里的干净导出操作。

## 卸载

运行：

```bash
zsh uninstall.sh
```

该脚本会删除已安装的命令行脚本和 Finder 快速操作。

卸载脚本不会重置 `com.apple.desktopservices` 偏好项。如果需要手动重置，可以执行：

```bash
defaults delete com.apple.desktopservices DSDontWriteNetworkStores 2>/dev/null || true
defaults delete com.apple.desktopservices DSDontWriteUSBStores 2>/dev/null || true
killall Finder
```

## 导出时会移除什么

无论是创建 zip 还是复制到 U 盘，导出结果都会排除或删除下面这些路径：

```text
.DS_Store
._*
__MACOSX
```

源文件夹不会被修改。

## 许可证

MIT
