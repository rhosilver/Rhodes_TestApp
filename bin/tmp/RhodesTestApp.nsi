;======================================================
; Include
 
  !include "MUI.nsh"
  !include "LogicLib.nsh"
 
;======================================================
; Installer Information
 
  Name RhodesTestApp
  OutFile "C:/RMS-Testing/manual/other/2.2_API_Test/RhodesTestApp/bin/target/win32/RhodesTestApp-setup.exe"
  InstallDir C:\RhodesTestApp
  BrandingText " "

;======================================================
; Modern Interface Configuration
 
  !define MUI_ICON icon.ico
  !define MUI_UNICON icon.ico
  !define MUI_HEADERIMAGE
  !define MUI_ABORTWARNING
  !define MUI_COMPONENTSPAGE_SMALLDESC
  !define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
  #!define MUI_FINISHPAGE_SHOWREADME $INSTDIR\README.html
  !define MUI_FINISHPAGE
  !define MUI_FINISHPAGE_TEXT "Thank you for installing RhodesTestApp \r\n\n\n"
  
;======================================================
; Pages
 
  !insertmacro MUI_PAGE_WELCOME
  #!insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  #Page custom customerConfig
  !insertmacro MUI_PAGE_FINISH
 
;======================================================
; Languages
 
  !insertmacro MUI_LANGUAGE "English"
 
;======================================================
; Reserve Files 

;======================================================
; Sections

RequestExecutionLevel admin #NOTE: You still need to check user rights with UserInfo!

# start default section
section
    SetShellVarContext all

    # set the installation directory as the destination for the following actions
    setOutPath $INSTDIR
 
    # create the uninstaller
    writeUninstaller "$INSTDIR\uninstall.exe"
 
    SetOutPath "$SMPROGRAMS\rhomobile"

    # create shortcuts
    createShortCut "$SMPROGRAMS\rhomobile\RhodesTestApp.lnk" "$INSTDIR\RhodesTestApp.exe"
    createShortCut "$SMPROGRAMS\rhomobile\Uninstall RhodesTestApp.lnk" "$INSTDIR\uninstall.exe"
    createShortCut "$DESKTOP\RhodesTestApp.lnk" "$INSTDIR\RhodesTestApp.exe" "" "$INSTDIR\icon.ico" 0

    # added information in 'unistall programs' in contorol panel
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\RhodesTestApp" \
                 "DisplayName" "RhodesTestApp 1.0"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\RhodesTestApp" \
                 "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\RhodesTestApp" \
                 "DisplayIcon" "$\"$INSTDIR\uninstall.exe$\""
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\RhodesTestApp" \
                 "Publisher" "rhomobile"
    WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\RhodesTestApp" \
                 "NoModify" 1
    WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\RhodesTestApp" \
                 "NoRepair" 1

    # update installed rhodes applications catalogue
    #WriteRegStr HKCU "Software\Rhomobile\RhodesTestApp" "" ""
    WriteRegStr HKCU "Software\rhomobile\RhodesTestApp" "InstallDir" "$INSTDIR"
    WriteRegStr HKCU "Software\rhomobile\RhodesTestApp" "Executable" "$INSTDIR\RhodesTestApp.exe"
    WriteRegStr HKCU "Software\rhomobile\RhodesTestApp" "Uninstaller" "$INSTDIR\uninstall.exe"
    WriteRegStr HKCU "Software\rhomobile\RhodesTestApp" "DisplayName" "RhodesTestApp 1.0"

sectionEnd
 
# uninstaller section start
section "uninstall"
    SetShellVarContext all

    # confirmation dialog
    MessageBox MB_YESNO|MB_ICONQUESTION "Do you want to uninstall RhodesTestApp?" IDNO NoUninstallLabel

    # first, delete the uninstaller
    delete "$INSTDIR\uninstall.exe"
 
    # second, remove the link from the start menu    
    delete "$SMPROGRAMS\rhomobile\RhodesTestApp.lnk"
    delete "$SMPROGRAMS\rhomobile\Uninstall RhodesTestApp.lnk"
    delete "$DESKTOP\RhodesTestApp.lnk"
    RMDir "$SMPROGRAMS\rhomobile"

    # remove information in 'unistall programs' in contorol panel
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\RhodesTestApp"

    # remove app from installed rhodes applications catalogue
    DeleteRegKey HKCU "Software\Rhomobile\RhodesTestApp"

    # remove $INSTDIR
    RMDir /r /REBOOTOK $INSTDIR

    NoUninstallLabel:

# uninstaller section end
sectionEnd


Section "RhodesTestApp" appSection
  SetOutPath $INSTDIR
 
  
  #
  File /r "rho"
  File RhodesTestApp.exe
  File *.dll
  File /r "imageformats"
  File /r "platforms"
  File *.manifest
  File "icon.ico"
  File "icon.png"

  System::Call 'Shell32::SHChangeNotify(i 0x8000000, i 0, i 0, i 0)'

SectionEnd

;======================================================
;Descriptions
 
  ;Language strings
  LangString DESC_InstallApp ${LANG_ENGLISH} "This installs RhodesTestApp"
  
  ;Assign language strings to sections
  
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${appSection} $(DESC_InstallApp)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;======================================================
;Functions
