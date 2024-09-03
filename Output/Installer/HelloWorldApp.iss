[Setup]
AppName=HelloWorldApp
AppVersion=1.0
DefaultDirName={pf}\HelloWorldApp
DefaultGroupName=HelloWorldApp
OutputBaseFilename=HelloWorldAppSetup
OutputDir=C:\Users\Lenovo\Documents\Projects\InnoSetup\Output\Installer
Compression=lzma
SolidCompression=yes

[Files]
Source: "C:\Users\Lenovo\Documents\Projects\InnoSetup\HelloWorldApp\bin\Release\HelloWorldApp.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\HelloWorldApp"; Filename: "{app}\HelloWorldApp.exe"

[Run]
Filename: "{app}\HelloWorldApp.exe"; Description: "Launch HelloWorldApp"; Flags: nowait postinstall skipifsilent

