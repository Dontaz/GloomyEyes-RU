; ============================================================================
; Утилита удаления русификатора для Gloomy Eyes
; Для тех, кто ставил русификатор ВРУЧНУЮ (распаковав архив в папку игры)
; ============================================================================

#define CleanerName "Удаление русификатора для Gloomy Eyes"
#define CleanerShortName "Удаление русификатора"
#define CleanerVersion "1.1"
#define AppPublisher "Dontaz"
#define AppURL "https://github.com/Dontaz/GloomyEyes-RU/releases/latest"

[Setup]
AppId={{Dontaz-Gloomy_Eyes_Cleaner}
AppName={#CleanerName}
AppVersion={#CleanerVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
DefaultDirName={src}
UsePreviousAppDir=no
AppendDefaultDirName=no
DirExistsWarning=no
DisableDirPage=yes
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=commandline
OutputDir=.
OutputBaseFilename=Удалить русификатор
SolidCompression=yes
WizardStyle=modern dynamic
Uninstallable=no
DisableWelcomePage=no
WizardImageFile=sidebar.png
WizardSmallImageFile=small.png
WizardImageFileDynamicDark=sidebar.png
WizardSmallImageFileDynamicDark=small.png
SetupIconFile=Gloomy.Eyes.RU.ico
VersionInfoCompany=Dontaz
VersionInfoDescription={#AppURL}
VersionInfoVersion=1.1.0.0
VersionInfoProductName={#CleanerName}
VersionInfoCopyright=MIT License
SignTool=mysigntool

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[CustomMessages]
CleanerWelcomeTitle=Удаление русификатора для Gloomy Eyes
CleanerWelcomeText=Эта утилита удалит файлы русификатора из папки игры.%n%nБудут удалены:%n• папка BepInEx%n• папка dotnet%n• .doorstop_version%n• doorstop_config.ini%n• fontasset%n• winhttp.dll%n• Возможные ошибки.txt%n• ИНСТРУКЦИЯ.txt%n%nВажно: перед удалением закройте игру.

[Messages]
SetupAppTitle=Удаление русификатора
SetupWindowTitle=%1
WizardReady=Всё готово к удалению
WizardPreparing=Подготовка к удалению
PreparingDesc=Подготовка к удалению файлов русификатора.
WizardInstalling=Удаление
InstallingLabel=Пожалуйста, подождите — удаляем файлы русификатора.
StatusExtractFiles=Удаление файлов...
FinishedHeadingLabel=Очистка завершена
FinishedLabel=Готово.
ButtonInstall=Удалить
ReadyLabel1=Файлы русификатора будут удалены из папки игры.
ReadyLabel2a=Нажмите «Удалить», чтобы очистить папку игры от файлов русификатора, или «Назад», чтобы изменить параметры.
ReadyLabel2b=Нажмите «Удалить», чтобы очистить папку игры от файлов русификатора.
ExitSetupTitle=Выход
ExitSetupMessage=Удаление не завершено. Если выйти сейчас, файлы русификатора останутся на месте.%n%nВыйти?

[Code]
var
  DeletedCount: Integer;
  FailedList: String;
  ReportText: String;

// ============================================================================
// УДАЛЕНИЕ
// ============================================================================

function DelFile(const FileName: String): Boolean;
begin
  Result := True;
  if not FileExists(FileName) then Exit;
  if DeleteFile(FileName) then
    DeletedCount := DeletedCount + 1
  else
  begin
    FailedList := FailedList + '  - ' + ExtractFileName(FileName) + #13#10;
    Result := False;
  end;
end;

function DelFolder(const DirName: String): Boolean;
begin
  Result := False;
  if not DirExists(DirName) then Exit;

  if DelTree(DirName, True, True, True) then
  begin
    DeletedCount := DeletedCount + 1;
    Result := True;
  end
  else
  begin
    FailedList := FailedList + '  - ' + ExtractFileName(DirName) +
                  ' (папка не удалена полностью)' + #13#10;
    Result := False;
  end;
end;

procedure DeleteEverything;
var
  P: String;
begin
  P := ExpandConstant('{app}');

  // Папки
  DelFolder(P + '\BepInEx');
  DelFolder(P + '\dotnet');

  // Файлы
  DelFile(P + '\.doorstop_version');
  DelFile(P + '\doorstop_config.ini');
  DelFile(P + '\fontasset');
  DelFile(P + '\winhttp.dll');
  DelFile(P + '\Возможные ошибки.txt');
  DelFile(P + '\ИНСТРУКЦИЯ.txt');
end;

// ============================================================================
// ОТЧЁТ
// ============================================================================

function BuildReport: String;
begin
  if (DeletedCount = 0) and (FailedList = '') then
    Result := 'Файлы русификатора не найдены — похоже, они уже удалены.'
  else if FailedList = '' then
    Result := 'Готово. Удалено объектов: ' + IntToStr(DeletedCount) + '.' + #13#10#13#10 +
              'Игра вернулась в оригинальное состояние.'
  else
    Result := 'Удалено объектов: ' + IntToStr(DeletedCount) + '.' + #13#10#13#10 +
              'Не удалось удалить:' + #13#10 + FailedList + #13#10 +
              'Скорее всего игра сейчас запущена. Закройте её и запустите утилиту ещё раз.';
end;

// ============================================================================
// СОБЫТИЯ МАСТЕРА
// ============================================================================

function InitializeSetup: Boolean;
begin
  DeletedCount := 0;
  FailedList := '';
  ReportText := '';
  Result := True;
end;

procedure InitializeWizard;
begin
  WizardForm.WelcomeLabel1.Caption := CustomMessage('CleanerWelcomeTitle');
  WizardForm.WelcomeLabel2.Caption := CustomMessage('CleanerWelcomeText');
  WizardForm.WelcomeLabel2.AdjustHeight();
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  P: String;
begin
  Result := True;

  if CurPageID = wpReady then
  begin
    P := ExpandConstant('{app}');
    if (not DirExists(P + '\BepInEx')) and (not DirExists(P + '\dotnet')) then
    begin
      if MsgBox('В папке нет ни BepInEx, ни dotnet:' + #13#10 + P + #13#10#13#10 +
                'Возможно, русификатор уже удалён или программа лежит не в папке игры. Продолжить?',
                mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDNO then
        Result := False;
    end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    DeleteEverything;
    ReportText := BuildReport;
  end;
end;

{ Если удалить не получилось и прав администратора нет — предложить перезапуск }
procedure OfferElevatedRetry;
var
  ErrorCode: Integer;
begin
  if IsAdmin then Exit;
  if MsgBox('Часть файлов удалить не удалось. Возможно, папка игры защищена ' +
            '(например, находится в Program Files).' + #13#10#13#10 +
            'Перезапустить утилиту от имени администратора?',
            mbConfirmation, MB_YESNO or MB_DEFBUTTON1) = IDYES then
  begin
    ShellExec('runas', ExpandConstant('{srcexe}'), '',
      ExpandConstant('{src}'), SW_SHOWNORMAL, ewNoWait, ErrorCode);
  end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpFinished then
  begin
    WizardForm.FinishedHeadingLabel.Caption := 'Очистка завершена';
    WizardForm.FinishedLabel.Caption := ReportText;
    if FailedList <> '' then
      OfferElevatedRetry;
  end;
end;