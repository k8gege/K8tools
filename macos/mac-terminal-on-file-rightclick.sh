#!/bin/bash
# macOS：为「任意文件 / 文件夹」右键添加「在终端中打开」快速操作
# 选中的是文件 -> 打开该文件所在目录；选中的是文件夹 -> 打开该文件夹
# 运行： bash mac-terminal-on-file-rightclick.sh

set -e

if [ "$(uname -s)" != "Darwin" ]; then
  echo "错误：此脚本只能在 macOS 上运行。" >&2
  exit 1
fi

NAME="在终端中打开"              # 右键菜单显示名
BUNDLE="Open Terminal Here"      # workflow 包名（英文，避免路径编码问题）
DEST="$HOME/Library/Services/$BUNDLE.workflow"
CONTENTS="$DEST/Contents"
HELPER_DIR="$HOME/.local/bin"
HELPER="$HELPER_DIR/open-terminal-here.sh"

echo "=== 1/5 准备目录（同名旧版本自动备份）==="
if [ -e "$DEST" ]; then
  BACKUP="${DEST}.bak.$(date +%Y%m%d%H%M%S)"
  mv "$DEST" "$BACKUP"
  echo "旧版本已备份到: $BACKUP"
fi
mkdir -p "$CONTENTS" "$HELPER_DIR"

# ---- 真正的处理脚本：接收 Automator 传入的选中项路径 ----
echo "=== 2/5 写入处理脚本 ==="
cat > "$HELPER" <<'SH'
#!/bin/bash
# "$@" = Finder 中选中的文件/文件夹路径（已正确处理空格与中文）
seen="|"
for f in "$@"; do
  [ -e "$f" ] || continue
  if [ -d "$f" ]; then
    dir="$f"
  else
    dir="$(dirname "$f")"
  fi
  # 多选同一目录下的文件时只开一个窗口
  case "$seen" in
    *"|$dir|"*) continue ;;
  esac
  seen="$seen$dir|"
  open -a Terminal "$dir"
done
SH
chmod +x "$HELPER"

# ---- Info.plist：让菜单出现在 Finder 右键「快速操作」中 ----
echo "=== 3/5 写入 workflow 元数据 ==="
cat > "$CONTENTS/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>NSServices</key>
  <array>
    <dict>
      <key>NSBackgroundColorName</key>
      <string>background</string>
      <key>NSIconName</key>
      <string>NSTouchBarGetInfoTemplate</string>
      <key>NSMenuItem</key>
      <dict>
        <key>default</key>
        <string>$NAME</string>
      </dict>
      <key>NSMessage</key>
      <string>runWorkflowAsService</string>
      <key>NSRequiredContext</key>
      <dict>
        <key>NSApplicationIdentifier</key>
        <string>com.apple.finder</string>
      </dict>
      <key>NSSendFileTypes</key>
      <array>
        <string>public.item</string>
      </array>
    </dict>
  </array>
</dict>
</plist>
PLIST

# ---- document.wflow：一个 Run Shell Script action，输入 as arguments ----
cat > "$CONTENTS/document.wflow" <<'WFLOW'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>AMApplicationBuild</key><string>521</string>
  <key>AMApplicationVersion</key><string>2.10</string>
  <key>AMDocumentVersion</key><string>2</string>
  <key>actions</key>
  <array>
    <dict>
      <key>action</key>
      <dict>
        <key>AMAccepts</key>
        <dict>
          <key>Container</key><string>List</string>
          <key>Optional</key><true/>
          <key>Types</key><array><string>com.apple.cocoa.path</string></array>
        </dict>
        <key>AMActionVersion</key><string>2.0.3</string>
        <key>AMApplication</key><array><string>Automator</string></array>
        <key>AMParameterProperties</key>
        <dict>
          <key>COMMAND_STRING</key><dict/>
          <key>CheckedForUserDefaultShell</key><dict/>
          <key>inputMethod</key><dict/>
          <key>shell</key><dict/>
          <key>source</key><dict/>
        </dict>
        <key>AMProvides</key>
        <dict>
          <key>Container</key><string>List</string>
          <key>Types</key><array><string>com.apple.cocoa.string</string></array>
        </dict>
        <key>ActionBundlePath</key><string>/System/Library/Automator/Run Shell Script.action</string>
        <key>ActionName</key><string>Run Shell Script</string>
        <key>ActionParameters</key>
        <dict>
          <key>COMMAND_STRING</key><string>/bin/bash "$HOME/.local/bin/open-terminal-here.sh" "$@"</string>
          <key>CheckedForUserDefaultShell</key><true/>
          <key>inputMethod</key><integer>1</integer>
          <key>shell</key><string>/bin/bash</string>
          <key>source</key><string></string>
        </dict>
        <key>BundleIdentifier</key><string>com.apple.RunShellScript</string>
        <key>CFBundleVersion</key><string>2.0.3</string>
        <key>CanShowSelectedItemsWhenRun</key><false/>
        <key>CanShowWhenRun</key><true/>
        <key>Category</key><array><string>AMCategoryUtilities</string></array>
        <key>Class Name</key><string>RunShellScriptAction</string>
        <key>InputUUID</key><string>11111111-1111-1111-1111-111111111111</string>
        <key>Keywords</key><array>
          <string>Shell</string><string>Script</string><string>Command</string><string>Run</string><string>Unix</string>
        </array>
        <key>OutputUUID</key><string>22222222-2222-2222-2222-222222222222</string>
        <key>UUID</key><string>33333333-3333-3333-3333-333333333333</string>
        <key>UnlocalizedApplications</key><array><string>Automator</string></array>
        <key>isViewVisible</key><integer>1</integer>
        <key>location</key><string>309.000000:253.000000</string>
        <key>nibPath</key><string>/System/Library/Automator/Run Shell Script.action/Contents/Resources/Base.lproj/main.nib</string>
      </dict>
      <key>isViewVisible</key><integer>1</integer>
    </dict>
  </array>
  <key>connectors</key><dict/>
  <key>workflowMetaData</key>
  <dict>
    <key>applicationBundleIDsByPath</key><dict/>
    <key>applicationPaths</key><array/>
    <key>inputTypeIdentifier</key><string>com.apple.Automator.fileSystemObject</string>
    <key>outputTypeIdentifier</key><string>com.apple.Automator.nothing</string>
    <key>presentationMode</key><integer>15</integer>
    <key>processesInput</key><integer>0</integer>
    <key>serviceApplicationBundleID</key><string>com.apple.finder</string>
    <key>serviceInputTypeIdentifier</key><string>com.apple.Automator.fileSystemObject</string>
    <key>serviceOutputTypeIdentifier</key><string>com.apple.Automator.nothing</string>
    <key>serviceProcessesInput</key><integer>0</integer>
    <key>systemImageName</key><string>NSActionTemplate</string>
    <key>useAutomaticInputType</key><integer>0</integer>
    <key>workflowTypeIdentifier</key><string>com.apple.Automator.servicesMenu</string>
  </dict>
</dict>
</plist>
WFLOW

echo "=== 4/5 校验 plist 并注册服务 ==="
plutil -lint "$CONTENTS/Info.plist"
plutil -lint "$CONTENTS/document.wflow"

# key 以 "(" 开头必须带引号，否则 defaults 会误当数组解析；
# value 必须是真布尔的 XML plist，老式 { ContextMenu = 1; } 会被 pbs 忽略。
defaults write pbs NSServicesStatus -dict-add \
  "\"(null) - $NAME - runWorkflowAsService\"" \
  '<dict><key>enabled_context_menu</key><true/><key>enabled_services_menu</key><true/><key>presentation_modes</key><dict><key>ContextMenu</key><true/><key>FinderPreview</key><true/><key>ServicesMenu</key><true/><key>TouchBar</key><true/></dict></dict>'

/System/Library/CoreServices/pbs -update 2>/dev/null || true
killall pbs 2>/dev/null || true
/System/Library/CoreServices/pbs -flush 2>/dev/null || true
killall Finder 2>/dev/null || true

echo "=== 5/5 完成 ==="
cat <<MSG

已安装「$NAME」快速操作。

用法：
  在 Finder 中右键【任意文件】-> 快速操作 -> $NAME
    -> 打开该文件所在目录的终端
  右键【文件夹】-> 快速操作 -> $NAME
    -> 打开该文件夹的终端
  多选同一目录下的多个文件 -> 只开一个终端窗口

如果右键菜单里暂时没出现：
  1) 右键菜单 -> 快速操作 -> 自定… -> 勾选「$NAME」
  2) 或执行： open -a Automator "$DEST"  然后在 Automator 里按 Cmd+S
  3) 再执行： killall Finder

MSG
