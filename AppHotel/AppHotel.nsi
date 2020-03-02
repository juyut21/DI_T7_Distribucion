!include "ZipDLL.nsh"
!include "MUI2.nsh"

; The name of the installer
Name "AppHotel"

; The file to write
OutFile "AppHotel.exe"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

; Build Unicode installer
Unicode True

; The default installation directory
InstallDir $PROGRAMFILES\AppHotel

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\NSIS_AppHotel" "Install_Dir"

;--------------------------------
;Variables

Var StartMenuFolder

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\win.bmp" ; optional
!define MUI_ABORTWARNING

;--------------------------------

; Pages
!insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY

;Start Menu Folder Page Configuration
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\AppHotel" 
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"

!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder

!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "Spanish"

;--------------------------------

; The stuff to install
Section "AppHotel (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File AppHotel.7z
  Nsis7z::ExtractWithCallback "$INSTDIR\AppHotel.7z"
  Delete "$OUTDIR\AppHotel.7z"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\NSIS_AppHotel "Install_Dir" "$INSTDIR"
  
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  
  CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
  CreateShortcut "$SMPROGRAMS\$StartMenuFolder\uninstallAppHotel.lnk" "$INSTDIR\uninstallAppHotel.exe"
  CreateShortcut "$SMPROGRAMS\$StartMenuFolder\AppHotel.lnk" "$INSTDIR\AppHotel.jar"
  !insertmacro MUI_STARTMENU_WRITE_END
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AppHotel" "DisplayName" "NSIS AppHotel"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AppHotel" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AppHotel" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AppHotel" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstallAppHotel.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\AppHotel"
  CreateShortcut "$SMPROGRAMS\AppHotel\uninstallAppHotel.lnk" "$INSTDIR\uninstallAppHotel.exe" "" "$INSTDIR\uninstallAppHotel.exe" 0
  CreateShortcut "$SMPROGRAMS\AppHotel\AppHotel (MakeNSISW).lnk" "$INSTDIR\AppHotel.jar" "" "$INSTDIR\AppHotel.jar" 0
  
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AppHotel"
  DeleteRegKey HKLM SOFTWARE\NSIS_AppHotel

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\AppHotel\*.*"
  Delete "$SMPROGRAMS\$StartMenuFolder\uninstallAppHotel.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\AppHotel.lnk"
  RMDir "$SMPROGRAMS\$StartMenuFolder"

  ; Remove directories used
  RMDir "$SMPROGRAMS\AppHotel"
  RMDir /r "$INSTDIR"

SectionEnd