#!/bin/zsh
set -eu

ROOT_DIR="${0:A:h}"
BIN_DIR="$HOME/.local/bin"
SERVICES_DIR="$HOME/Library/Services"

ZIP_WORKFLOW="$SERVICES_DIR/干净压缩.workflow"
COPY_WORKFLOW="$SERVICES_DIR/干净复制到U盘.workflow"

mkdir -p "$BIN_DIR" "$ZIP_WORKFLOW/Contents/Resources" "$COPY_WORKFLOW/Contents/Resources"

install -m 755 "$ROOT_DIR/bin/macos-clean-zip" "$BIN_DIR/macos-clean-zip"
install -m 755 "$ROOT_DIR/bin/macos-clean-copy-usb" "$BIN_DIR/macos-clean-copy-usb"

cat > "$ZIP_WORKFLOW/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>zh_CN</string>
  <key>CFBundleIdentifier</key>
  <string>io.github.macos-clean-export.clean-zip</string>
  <key>CFBundleName</key>
  <string>干净压缩</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>NSServices</key>
  <array>
    <dict>
      <key>NSMenuItem</key>
      <dict>
        <key>default</key>
        <string>干净压缩</string>
      </dict>
      <key>NSMessage</key>
      <string>runWorkflowAsService</string>
      <key>NSSendFileTypes</key>
      <array>
        <string>public.folder</string>
      </array>
    </dict>
  </array>
</dict>
</plist>
PLIST

cat > "$COPY_WORKFLOW/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>zh_CN</string>
  <key>CFBundleIdentifier</key>
  <string>io.github.macos-clean-export.clean-copy-usb</string>
  <key>CFBundleName</key>
  <string>干净复制到U盘</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>NSServices</key>
  <array>
    <dict>
      <key>NSMenuItem</key>
      <dict>
        <key>default</key>
        <string>干净复制到U盘</string>
      </dict>
      <key>NSMessage</key>
      <string>runWorkflowAsService</string>
      <key>NSSendFileTypes</key>
      <array>
        <string>public.folder</string>
      </array>
    </dict>
  </array>
</dict>
</plist>
PLIST

write_workflow() {
  local output_path="$1"
  local command="$2"

  cat > "$output_path" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>AMApplicationBuild</key>
  <string>346</string>
  <key>AMApplicationVersion</key>
  <string>2.3</string>
  <key>AMDocumentVersion</key>
  <string>2</string>
  <key>actions</key>
  <array>
    <dict>
      <key>action</key>
      <dict>
        <key>ActionBundlePath</key>
        <string>/System/Library/Automator/Run Shell Script.action</string>
        <key>ActionName</key>
        <string>Run Shell Script</string>
        <key>ActionParameters</key>
        <dict>
          <key>CheckedForUserDefaultShell</key>
          <true/>
          <key>COMMAND_STRING</key>
          <string>${command}</string>
          <key>inputMethod</key>
          <integer>1</integer>
          <key>shell</key>
          <string>/bin/zsh</string>
          <key>source</key>
          <string></string>
        </dict>
        <key>AMAccepts</key>
        <dict>
          <key>Container</key>
          <string>List</string>
          <key>Optional</key>
          <true/>
          <key>Types</key>
          <array>
            <string>com.apple.cocoa.path</string>
          </array>
        </dict>
        <key>AMActionVersion</key>
        <string>2.0.3</string>
        <key>AMApplication</key>
        <array>
          <string>Automator</string>
        </array>
        <key>AMParameterProperties</key>
        <dict>
          <key>CheckedForUserDefaultShell</key>
          <dict/>
          <key>COMMAND_STRING</key>
          <dict/>
          <key>inputMethod</key>
          <dict/>
          <key>shell</key>
          <dict/>
          <key>source</key>
          <dict/>
        </dict>
        <key>AMProvides</key>
        <dict>
          <key>Container</key>
          <string>List</string>
          <key>Types</key>
          <array>
            <string>com.apple.cocoa.string</string>
          </array>
        </dict>
        <key>BundleIdentifier</key>
        <string>com.apple.RunShellScript</string>
        <key>CanShowSelectedItemsWhenRun</key>
        <false/>
        <key>CanShowWhenRun</key>
        <true/>
        <key>Category</key>
        <array>
          <string>AMCategoryUtilities</string>
        </array>
        <key>CFBundleVersion</key>
        <string>2.0.3</string>
        <key>Class Name</key>
        <string>RunShellScriptAction</string>
        <key>InputUUID</key>
        <string>F9B5E48B-BDD4-4A20-956E-A0F71A791B8E</string>
        <key>OutputUUID</key>
        <string>C53FF493-75C3-4CF0-80C3-613D2B8DDF15</string>
        <key>UUID</key>
        <string>A5E6F90A-81F2-4810-95D5-902665C28B5B</string>
        <key>UnlocalizedApplications</key>
        <array>
          <string>Automator</string>
        </array>
      </dict>
    </dict>
  </array>
  <key>connectors</key>
  <dict/>
  <key>workflowMetaData</key>
  <dict>
    <key>serviceApplicationBundleID</key>
    <string>com.apple.finder</string>
    <key>serviceApplicationPath</key>
    <string>/System/Library/CoreServices/Finder.app</string>
    <key>serviceInputTypeIdentifier</key>
    <string>com.apple.Automator.fileSystemObject.folder</string>
    <key>serviceOutputTypeIdentifier</key>
    <string>com.apple.Automator.nothing</string>
    <key>serviceProcessesInput</key>
    <integer>1</integer>
    <key>workflowTypeIdentifier</key>
    <string>com.apple.Automator.servicesMenu</string>
  </dict>
</dict>
</plist>
PLIST
}

write_workflow "$ZIP_WORKFLOW/Contents/document.wflow" 'exec "$HOME/.local/bin/macos-clean-zip" "$@"'
cp "$ZIP_WORKFLOW/Contents/document.wflow" "$ZIP_WORKFLOW/Contents/Resources/document.wflow"

write_workflow "$COPY_WORKFLOW/Contents/document.wflow" 'exec "$HOME/.local/bin/macos-clean-copy-usb" "$@"'
cp "$COPY_WORKFLOW/Contents/document.wflow" "$COPY_WORKFLOW/Contents/Resources/document.wflow"

plutil -lint \
  "$ZIP_WORKFLOW/Contents/Info.plist" \
  "$ZIP_WORKFLOW/Contents/document.wflow" \
  "$COPY_WORKFLOW/Contents/Info.plist" \
  "$COPY_WORKFLOW/Contents/document.wflow" >/dev/null

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool TRUE

/System/Library/CoreServices/pbs -flush zh_CN en >/dev/null 2>&1 || true
/System/Library/CoreServices/pbs -update zh_CN en >/dev/null 2>&1 || true

echo "Installed Finder Quick Actions:"
echo "  - 干净压缩"
echo "  - 干净复制到U盘"
echo
echo "If they do not appear immediately, restart Finder or log out and log back in."
