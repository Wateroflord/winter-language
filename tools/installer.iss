; Установщик Winter Language для Windows (Inno Setup 6), ставится в профиль пользователя.
#define BuildNo GetEnv("BUILD_NO")
#if BuildNo == ""
  #define BuildNo "0"
#endif

[Setup]
AppId={{1036D815-75C2-4087-ABC3-5E25A44DE0F4}
AppName=Winter Language
AppVersion=1.0.{#BuildNo}
AppPublisher=Winter Hub
DefaultDirName={localappdata}\Programs\Winter Language
DefaultGroupName=Winter Language
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir=..\dist
OutputBaseFilename=Winter-Language-Setup
Compression=lzma2
SolidCompression=yes
SetupIconFile=..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\winter_language.exe
CloseApplications=force
RestartApplications=no
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "en"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Winter Language"; Filename: "{app}\winter_language.exe"
Name: "{group}\{cm:UninstallProgram,Winter Language}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\Winter Language"; Filename: "{app}\winter_language.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\winter_language.exe"; Description: "{cm:LaunchProgram,Winter Language}"; Flags: nowait postinstall skipifsilent
Filename: "{app}\winter_language.exe"; Flags: nowait; Check: WizardSilent
