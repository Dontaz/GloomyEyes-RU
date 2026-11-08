; ============================================================================
; Установщик русификатора
; Автор: Dontaz
; ============================================================================

#define MyAppName "Русификатор для Gloomy Eyes"
#define MyAppVersion "1.1"
#define MyAppPublisher "Dontaz"
#define MyAppURL "https://github.com/Dontaz/GloomyEyes-RU/releases/latest"
#define MyAppBoosty "https://boosty.to/dontaz"
#define MyAppDonationAlerts "https://www.donationalerts.com/r/dontaz"
#define GameName "Gloomy Eyes - The Game"
#define Title "Gloomy Eyes"

[Setup]
AppId={{Dontaz-Gloomy_Eyes}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={code:GetGamePath}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=.
OutputBaseFilename=Gloomy.Eyes.RU
SolidCompression=yes
WizardStyle=modern dynamic
WizardSizePercent=140
UsePreviousAppDir=no
DisableDirPage=no
DirExistsWarning=no
AppendDefaultDirName=no
UninstallDisplayName=Удаление русификатора для {#Title}
UninstallFilesDir={app}\Удаление русификатора
WizardImageFile=sidebar.png
WizardSmallImageFile=small.png
WizardImageFileDynamicDark=sidebar.png
WizardSmallImageFileDynamicDark=small.png
SetupIconFile=Gloomy.Eyes.RU.ico
DisableWelcomePage=no
VersionInfoCompany=Dontaz
VersionInfoDescription={#MyAppURL}
VersionInfoVersion=1.1.0.0
VersionInfoProductName={#MyAppName}
VersionInfoCopyright=MIT License
SignTool=mysigntool

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "Installer\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[UninstallDelete]
Type: filesandordirs; Name: "{app}\BepInEx"

[CustomMessages]
WelcomeTitle=Вас приветствует мастер установки русификатора для Gloomy Eyes
WelcomeText=Данный мастер установки поможет вам установить русификатор (версия {#MyAppVersion}) для игры {#Title}.%n%nАвтор перевода: {#MyAppPublisher}.%nПри публикации на сторонних ресурсах просьба указывать авторство.%n%nНажимая «Далее», вы соглашаетесь с условиями использования.
VisitLink=🌐 Найти самую актуальную версию (GitHub)
BoostyLink=🧡 Поддержать автора перевода
DisclaimerLink=⚠️ Условия использования (Читать)
DisclaimerFullText=УСЛОВИЯ ИСПОЛЬЗОВАНИЯ:%n%n1. Данный перевод является неофициальным и фанатским. Он создан исключительно в ознакомительных целях и распространяется бесплатно. Автор не преследует коммерческих целей.%n%n2. Все права на игру принадлежат её компании-разработчику и издателю. Пожалуйста, поддержите разработчиков покупкой лицензионной копии.%n%n3. Установка, использование или модификация файлов осуществляется пользователем добровольно, по собственной инициативе и под его личную ответственность.%n%n4. Автор перевода не несёт ответственности за возможные последствия, технические неполадки или утрату данных. Используя данный материал, вы подтверждаете, что принимаете на себя все риски.
WarningText=Важно: после установки русификатора первый запуск игры займёт больше времени, чем обычно. После установки в папке с игрой появится файл «Возможные ошибки.txt», куда вы можете заглянуть при возникновении проблем с русификатором.

[Code]
var
  VisitLabel: TNewStaticText;
  BoostyLabel: TNewStaticText;
  DisclaimerLabel: TNewStaticText;
  SupportForm: TForm;
  LinkColor: TColor;

// ============================================================================
// КОНСТАНТЫ ДЛЯ UI
// ============================================================================
const
  SUPPORT_WINDOW_WIDTH = 340;
  SUPPORT_WINDOW_HEIGHT = 260;
  SUPPORT_BUTTON_WIDTH = 280;
  SUPPORT_BUTTON_HEIGHT = 40;
  WELCOME_BOTTOM_MARGIN = 100;
  LINK_SPACING = 10;

// ============================================================================
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
// ============================================================================

procedure OpenUrl(Url: String);
var
  ErrorCode: Integer;
begin
  ShellExec('open', Url, '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

{ Возвращает цвет ссылки в зависимости от темы }
function GetLinkColor(): TColor;
begin
  if WizardForm.Font.Color = clWhite then
    Result := $00A5FF  // Светло-синий для тёмной темы
  else
    Result := clBlue;  // Синий для светлой темы
end;

{ Возвращает приглушённый цвет для дополнительного текста }
function GetMutedColor(BaseColor: TColor): TColor;
begin
  if BaseColor = clWhite then
    Result := $C0C0C0  // Светло-серый для тёмной темы
  else
    Result := $808080;  // Тёмно-серый для светлой темы
end;

{ Создаёт кликабельную ссылку на странице Welcome }
function CreateClickableLink(Parent: TWinControl; Caption: String; 
  Top: Integer; OnClickProc: TNotifyEvent): TNewStaticText;
var
  LinkLabel: TNewStaticText;
begin
  LinkLabel := TNewStaticText.Create(WizardForm);
  LinkLabel.Parent := Parent;
  LinkLabel.Caption := Caption;
  LinkLabel.Font.Color := LinkColor;
  LinkLabel.Font.Style := [fsUnderline];
  LinkLabel.Cursor := crHandPoint;
  LinkLabel.OnClick := OnClickProc;
  LinkLabel.Left := WizardForm.WelcomeLabel2.Left;
  LinkLabel.Top := Top;
  LinkLabel.Width := WizardForm.WelcomeLabel2.Width;
  Result := LinkLabel;
end;

// ============================================================================
// ОБРАБОТЧИКИ СОБЫТИЙ UI
// ============================================================================

procedure BoostyBtnClick(Sender: TObject);
begin
  OpenUrl(ExpandConstant('{#MyAppBoosty}'));
  if SupportForm <> nil then 
    SupportForm.Close;
end;

procedure DABtnClick(Sender: TObject);
begin
  OpenUrl(ExpandConstant('{#MyAppDonationAlerts}'));
  if SupportForm <> nil then 
    SupportForm.Close;
end;

procedure CloseSupportClick(Sender: TObject);
begin
  if SupportForm <> nil then 
    SupportForm.Close;
end;

procedure LinkLabelClick(Sender: TObject);
begin
  OpenUrl(ExpandConstant('{#MyAppURL}'));
end;

procedure DisclaimerLabelClick(Sender: TObject);
begin
  MsgBox(CustomMessage('DisclaimerFullText'), mbInformation, MB_OK);
end;

// ============================================================================
// ОКНО ПОДДЕРЖКИ
// ============================================================================

{ Создаёт и отображает модальное окно с вариантами поддержки автора }
procedure ShowSupportWindow;
var
  TitleLabel, DescLabel, CloseLabel: TLabel;
  BtnBoosty, BtnDA, DummyBtn: TNewButton;
begin
  SupportForm := TForm.Create(WizardForm);
  try
    SupportForm.ClientWidth := ScaleX(SUPPORT_WINDOW_WIDTH);
    SupportForm.ClientHeight := ScaleY(SUPPORT_WINDOW_HEIGHT);
    SupportForm.Caption := 'Поддержать автора';
    SupportForm.Position := poMainFormCenter;
    SupportForm.BorderStyle := bsDialog;
    SupportForm.Color := WizardForm.Color;
    SupportForm.Font.Color := WizardForm.Font.Color;

    // Dummy кнопка для предотвращения автоматического закрытия по Enter
    DummyBtn := TNewButton.Create(SupportForm);
    DummyBtn.Parent := SupportForm;
    DummyBtn.Width := 0;
    DummyBtn.Height := 0;
    DummyBtn.Left := -100;
    DummyBtn.Default := True;

    // Заголовок
    TitleLabel := TLabel.Create(SupportForm);
    TitleLabel.Parent := SupportForm;
    TitleLabel.Caption := 'Хотите поддержать меня?';
    TitleLabel.Font.Name := 'Segoe UI';
    TitleLabel.Font.Size := 14;
    TitleLabel.Font.Style := [fsBold];
    TitleLabel.Font.Color := SupportForm.Font.Color;
    TitleLabel.AutoSize := False;
    TitleLabel.Alignment := taCenter;
    TitleLabel.Left := 0;
    TitleLabel.Width := SupportForm.ClientWidth;
    TitleLabel.Top := ScaleY(25);
    TitleLabel.Transparent := True;

    // Описание
    DescLabel := TLabel.Create(SupportForm);
    DescLabel.Parent := SupportForm;
    DescLabel.Caption := 'Выберите удобный способ поддержки:';
    DescLabel.Font.Color := SupportForm.Font.Color;
    DescLabel.Font.Size := 9;
    DescLabel.WordWrap := True;
    DescLabel.AutoSize := False;
    DescLabel.Alignment := taCenter;
    DescLabel.Left := ScaleX(10);
    DescLabel.Width := SupportForm.ClientWidth - ScaleX(20);
    DescLabel.Top := ScaleY(60);
    DescLabel.Height := ScaleY(40);
    DescLabel.Transparent := True;

    // Кнопка Boosty
    BtnBoosty := TNewButton.Create(SupportForm);
    BtnBoosty.Parent := SupportForm;
    BtnBoosty.Width := ScaleX(SUPPORT_BUTTON_WIDTH);
    BtnBoosty.Height := ScaleY(SUPPORT_BUTTON_HEIGHT);
    BtnBoosty.Left := (SupportForm.ClientWidth - BtnBoosty.Width) div 2;
    BtnBoosty.Top := ScaleY(110);
    BtnBoosty.Caption := '🧡  Поддержать на Boosty';
    BtnBoosty.Cursor := crHandPoint;
    BtnBoosty.Font.Style := [fsBold];
    BtnBoosty.Font.Size := 10;
    BtnBoosty.OnClick := @BoostyBtnClick;
    BtnBoosty.TabOrder := 1;

    // Кнопка DonationAlerts
    BtnDA := TNewButton.Create(SupportForm);
    BtnDA.Parent := SupportForm;
    BtnDA.Width := ScaleX(SUPPORT_BUTTON_WIDTH);
    BtnDA.Height := ScaleY(SUPPORT_BUTTON_HEIGHT);
    BtnDA.Left := (SupportForm.ClientWidth - BtnDA.Width) div 2;
    BtnDA.Top := ScaleY(160);
    BtnDA.Caption := '🧡  Поддержать на DonationAlerts';
    BtnDA.Cursor := crHandPoint;
    BtnDA.Font.Style := [fsBold];
    BtnDA.Font.Size := 10;
    BtnDA.OnClick := @DABtnClick;
    BtnDA.TabOrder := 2;

    // Ссылка "Закрыть"
    CloseLabel := TLabel.Create(SupportForm);
    CloseLabel.Parent := SupportForm;
    CloseLabel.Caption := 'Спасибо, но в другой раз';
    CloseLabel.Cursor := crHandPoint;
    CloseLabel.Font.Color := GetMutedColor(SupportForm.Font.Color);
    CloseLabel.Font.Style := [fsUnderline];
    CloseLabel.Font.Size := 9;
    CloseLabel.OnClick := @CloseSupportClick;
    CloseLabel.AutoSize := False;
    CloseLabel.Alignment := taCenter;
    CloseLabel.Left := 0;
    CloseLabel.Width := SupportForm.ClientWidth;
    CloseLabel.Top := ScaleY(225);
    CloseLabel.Transparent := True;

    SupportForm.ShowModal;
  finally
    SupportForm.Free;
    SupportForm := nil;
  end;
end;

procedure BoostyLabelClick(Sender: TObject);
begin
  ShowSupportWindow();
end;

// ============================================================================
// ПРЕДУПРЕЖДЕНИЕ НА СТРАНИЦЕ WELCOME
// ============================================================================

{ Блок предупреждения: фон, рамка и текст рисуются на одном битмапе }
procedure CreateWarningPanel(Parent: TWinControl; Top: Integer);
var
  Bg: TBitmapImage;
  Text, Word, Cur, Test: String;
  Lines: TArrayOfString;
  PanelColor, TextColor, BorderColor: TColor;
  Pad, Frame, W, InnerW, LineH, Count, i: Integer;
  R: TRect;
begin
  if IsDarkInstallMode then
  begin
    PanelColor  := $00203848;  // тёмный фон
    TextColor   := $0080D4FF;  // светло-оранжевый текст
    BorderColor := $0040A0FF;  // оранжевая рамка
  end
  else
  begin
    PanelColor  := $00CCE5FF;  // светлый фон
    TextColor   := $00003380;  // тёмный текст
    BorderColor := $000066CC;  // оранжевая рамка
  end;

  Pad    := ScaleX(12);
  Frame  := ScaleX(2);
  W      := WizardForm.WelcomeLabel2.Width;
  InnerW := W - (Frame + Pad) * 2;

  Bg := TBitmapImage.Create(WizardForm);
  Bg.Parent := Parent;
  Bg.Left := WizardForm.WelcomeLabel2.Left;
  Bg.Top := Top;
  Bg.Width := W;
  Bg.Stretch := False;

  // Шрифт задаём ДО замеров, иначе ширина строк посчитается другим шрифтом
  Bg.Bitmap.Canvas.Font.Name  := WizardForm.Font.Name;
  Bg.Bitmap.Canvas.Font.Size  := 9;
  Bg.Bitmap.Canvas.Font.Style := [fsBold];
  Bg.Bitmap.Canvas.Font.Color := TextColor;

  LineH := Bg.Bitmap.Canvas.TextHeight('Wg');

  // ---- Ручной перенос по словам ----
  Text := CustomMessage('WarningText');
  SetArrayLength(Lines, 0);
  Count := 0;
  Cur := '';
  Word := '';

  for i := 1 to Length(Text) do
  begin
    if (Text[i] = ' ') or (Text[i] = #9) or (Text[i] = #13) or (Text[i] = #10) then
    begin
      if Word <> '' then
      begin
        if Cur = '' then
          Test := Word
        else
          Test := Cur + ' ' + Word;

        if (Cur <> '') and (Bg.Bitmap.Canvas.TextWidth(Test) > InnerW) then
        begin
          SetArrayLength(Lines, Count + 1);
          Lines[Count] := Cur;
          Count := Count + 1;
          Cur := Word;
        end
        else
          Cur := Test;
        Word := '';
      end;

      // принудительный перевод строки из %n в CustomMessages
      if ((Text[i] = #13) or (Text[i] = #10)) and (Cur <> '') then
      begin
        SetArrayLength(Lines, Count + 1);
        Lines[Count] := Cur;
        Count := Count + 1;
        Cur := '';
      end;
    end
    else
      Word := Word + Text[i];
  end;

  // хвост
  if Word <> '' then
  begin
    if Cur = '' then
      Cur := Word
    else
      Cur := Cur + ' ' + Word;
  end;
  if Cur <> '' then
  begin
    SetArrayLength(Lines, Count + 1);
    Lines[Count] := Cur;
    Count := Count + 1;
  end;

  if Count = 0 then
  begin
    SetArrayLength(Lines, 1);
    Lines[0] := Text;
    Count := 1;
  end;

  // ---- Размер и отрисовка ----
  Bg.Height := Frame * 2 + Pad * 2 + Count * LineH;
  Bg.Bitmap.Width  := W;
  Bg.Bitmap.Height := Bg.Height;

  R.Left := 0;  R.Top := 0;  R.Right := W;  R.Bottom := Bg.Height;
  Bg.Bitmap.Canvas.Brush.Style := bsSolid;
  Bg.Bitmap.Canvas.Brush.Color := BorderColor;
  Bg.Bitmap.Canvas.FillRect(R);

  R.Left := Frame;  R.Top := Frame;
  R.Right := W - Frame;  R.Bottom := Bg.Height - Frame;
  Bg.Bitmap.Canvas.Brush.Color := PanelColor;
  Bg.Bitmap.Canvas.FillRect(R);

  for i := 0 to Count - 1 do
    Bg.Bitmap.Canvas.TextOut(Frame + Pad, Frame + Pad + i * LineH, Lines[i]);
end;

// ============================================================================
// ИНИЦИАЛИЗАЦИЯ МАСТЕРА УСТАНОВКИ
// ============================================================================

procedure InitializeWizard;
var
  LinkH, LinksTop: Integer;
begin
  LinkColor := GetLinkColor();

  WizardForm.WelcomeLabel1.Caption := CustomMessage('WelcomeTitle');
  WizardForm.WelcomeLabel2.Caption := CustomMessage('WelcomeText');
  WizardForm.WelcomeLabel2.AdjustHeight();

  // Предупреждение сразу под текстом
  CreateWarningPanel(WizardForm.WelcomePage,
    WizardForm.WelcomeLabel2.Top + WizardForm.WelcomeLabel2.Height + ScaleY(16));

  VisitLabel := CreateClickableLink(WizardForm.WelcomePage,
    CustomMessage('VisitLink'), 0, @LinkLabelClick);
  BoostyLabel := CreateClickableLink(WizardForm.WelcomePage,
    CustomMessage('BoostyLink'), 0, @BoostyLabelClick);
  DisclaimerLabel := CreateClickableLink(WizardForm.WelcomePage,
    CustomMessage('DisclaimerLink'), 0, @DisclaimerLabelClick);

  LinkH := VisitLabel.Height;
  LinksTop := WizardForm.WelcomePage.Height
    - (LinkH * 3 + ScaleY(LINK_SPACING) * 2) - ScaleY(15);

  VisitLabel.Top := LinksTop;
  BoostyLabel.Top := VisitLabel.Top + LinkH + ScaleY(LINK_SPACING);
  DisclaimerLabel.Top := BoostyLabel.Top + LinkH + ScaleY(LINK_SPACING);
end;

// ============================================================================
// ФУНКЦИИ ПОИСКА ИГРЫ
// ============================================================================

{ Получает путь установки Steam из реестра }
function GetSteamPath(): String;
var
  RegPath: String;
begin
  Result := '';
  
  // Проверяем 64-битный реестр
  if RegQueryStringValue(HKLM64, 'SOFTWARE\Valve\Steam', 'InstallPath', RegPath) then
  begin
    Result := RegPath;
    Exit;
  end;
  
  // Проверяем 32-битный реестр
  if RegQueryStringValue(HKLM, 'SOFTWARE\Valve\Steam', 'InstallPath', RegPath) then
  begin
    Result := RegPath;
    Exit;
  end;
  
  // Путь по умолчанию
  Result := ExpandConstant('{commonpf}\Steam');
end;

{ Парсит значение из строки VDF файла вида "key" "value" }
function GetValueFromVDFLine(const Line: String): String;
var
  TrimmedLine: String;
  FirstQuote, SecondQuote, ThirdQuote, FourthQuote: Integer;
begin
  Result := '';
  TrimmedLine := Trim(Line);
  
  // Находим четыре кавычки: "key" "value"
  FirstQuote := Pos('"', TrimmedLine);
  if FirstQuote = 0 then Exit;
  
  SecondQuote := Pos('"', Copy(TrimmedLine, FirstQuote + 1, Length(TrimmedLine)));
  if SecondQuote = 0 then Exit;
  SecondQuote := SecondQuote + FirstQuote;
  
  ThirdQuote := Pos('"', Copy(TrimmedLine, SecondQuote + 1, Length(TrimmedLine)));
  if ThirdQuote = 0 then Exit;
  ThirdQuote := ThirdQuote + SecondQuote;
  
  FourthQuote := Pos('"', Copy(TrimmedLine, ThirdQuote + 1, Length(TrimmedLine)));
  if FourthQuote = 0 then Exit;
  FourthQuote := FourthQuote + ThirdQuote;
  
  // Извлекаем значение между третьей и четвёртой кавычками
  Result := Copy(TrimmedLine, ThirdQuote + 1, FourthQuote - ThirdQuote - 1);
end;

{ Проверяет существование игры по заданному пути }
function CheckGamePath(BasePath: String): String;
var
  GamePath: String;
begin
  Result := '';
  GamePath := AddBackslash(BasePath) + 'steamapps\common\{#GameName}';
  if DirExists(GamePath) then
    Result := GamePath;
end;

{ Ищет игру в библиотеках Steam через файл libraryfolders.vdf }
function FindGameInSteamLibraries(SteamPath: String): String;
var
  LibraryFoldersFile: String;
  FileLines: TArrayOfString;
  i, LineCount: Integer;
  Line, LibraryPath, GamePath: String;
begin
  Result := '';
  LibraryFoldersFile := AddBackslash(SteamPath) + 'steamapps\libraryfolders.vdf';
  
  if not FileExists(LibraryFoldersFile) then Exit;
  
  if LoadStringsFromFile(LibraryFoldersFile, FileLines) then
  begin
    LineCount := GetArrayLength(FileLines);
    for i := 0 to LineCount - 1 do
    begin
      Line := FileLines[i];
      if Pos('"path"', Line) > 0 then
      begin
        LibraryPath := GetValueFromVDFLine(Line);
        if LibraryPath <> '' then
        begin
          // Нормализуем двойные слэши
          StringChange(LibraryPath, '\\', '\');
          GamePath := CheckGamePath(LibraryPath);
          if GamePath <> '' then
          begin
            Result := GamePath;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

{ Проверяет распространённые места установки нелицензионных версий }
function CheckCommonGameLocations(): String;
var
  i: Integer;
  Drive: String;
  Paths: array of String;
  PathTemplates: array[0..9] of String;
  j: Integer;
begin
  Result := '';
  
  // Шаблоны путей для проверки
  PathTemplates[0] := '\{#GameName}';
  PathTemplates[1] := '\Games\{#GameName}';
  PathTemplates[2] := '\Игры\{#GameName}';
  PathTemplates[3] := '\Игра\{#GameName}';
  PathTemplates[4] := '\Game\{#GameName}';
  PathTemplates[5] := '\Games\{#Title}';
  PathTemplates[6] := '\Игры\{#Title}';
  PathTemplates[7] := '\{#Title}';
  PathTemplates[8] := '\Игра\{#Title}';
  PathTemplates[9] := '\Game\{#Title}';
  
  // Фиксированные пути
  SetArrayLength(Paths, 10);
  Paths[0] := 'C:\Games\{#GameName}';
  Paths[1] := 'C:\Игры\{#GameName}';
  Paths[2] := 'C:\Program Files\{#GameName}';
  Paths[3] := 'C:\Program Files (x86)\{#GameName}';
  Paths[4] := 'C:\{#GameName}';
  Paths[5] := 'D:\Games\{#GameName}';
  Paths[6] := 'D:\Игры\{#GameName}';
  Paths[7] := 'D:\{#GameName}';
  Paths[8] := 'E:\Games\{#GameName}';
  Paths[9] := ExpandConstant('{userdesktop}\{#GameName}');
  
  // Проверяем фиксированные пути
  for i := 0 to GetArrayLength(Paths) - 1 do
  begin
    if DirExists(Paths[i]) then
    begin
      Result := Paths[i];
      Exit;
    end;
  end;
  
  // Проверяем все диски с шаблонами путей
  for i := 65 to 90 do  // A-Z
  begin
    Drive := Chr(i) + ':';
    if DirExists(Drive) then
    begin
      for j := 0 to 9 do
      begin
        if DirExists(Drive + PathTemplates[j]) then
        begin
          Result := Drive + PathTemplates[j];
          Exit;
        end;
      end;
    end;
  end;
end;

{ Главная функция определения пути к игре }
function GetGamePath(Param: String): String;
var
  SteamPath, GamePath: String;
begin
  SteamPath := GetSteamPath();
  
  // 1. Проверяем стандартный путь Steam
  GamePath := CheckGamePath(SteamPath);
  if GamePath <> '' then
  begin
    Result := GamePath;
    Exit;
  end;
  
  // 2. Проверяем Steam Deck
  if DirExists('\home\deck\.local\share\Steam') then
  begin
    GamePath := CheckGamePath('\home\deck\.local\share\Steam');
    if GamePath <> '' then
    begin
      Result := GamePath;
      Exit;
    end;
  end;
  
  // 3. Ищем в дополнительных библиотеках Steam
  GamePath := FindGameInSteamLibraries(SteamPath);
  if GamePath <> '' then
  begin
    Result := GamePath;
    Exit;
  end;
  
  // 4. Проверяем распространённые пути для нелицензионных версий
  GamePath := CheckCommonGameLocations();
  if GamePath <> '' then
  begin
    Result := GamePath;
    Exit;
  end;
  
  // 5. Путь по умолчанию, если ничего не найдено
  Result := ExpandConstant('{commonpf}\Steam\steamapps\common\{#GameName}');
end;
