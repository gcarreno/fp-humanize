unit Forms.Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ActnList,
  StdActns, ExtCtrls, StdCtrls;

type
{ TfrmMain }
  TfrmMain = class(TForm)
    actHumanizeBytes: TAction;
    actHumanizeComma: TAction;
    actHumanizeOrdinal: TAction;
    actHumanizeTime: TAction;
    ActionList: TActionList;
    actFileExit: TFileExit;
    btnHumanizeBytes: TButton;
    btnFileExit: TButton;
    btnHumanizeComma: TButton;
    btnHumanizeOrdinal: TButton;
    btnHumanizeOrdinal1: TButton;
    MainMenu: TMainMenu;
    memLog: TMemo;
    mnuHumanizeTime: TMenuItem;
    mnuHUmanizeOrdinal: TMenuItem;
    mnuHumanizeComma: TMenuItem;
    mnuFile: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuHumanize: TMenuItem;
    mnuHumanizeBytes: TMenuItem;
    panButtons: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actHumanizeBytesExecute(Sender: TObject);
    procedure actHumanizeCommaExecute(Sender: TObject);
    procedure actHumanizeOrdinalExecute(Sender: TObject);
    procedure actHumanizeTimeExecute(Sender: TObject);
  private
    procedure InitShortCuts;
  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

uses
  LCLType
, DateUtils
, humanize
;

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  InitShortCuts;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin

end;

procedure TfrmMain.InitShortCuts;
begin
{$IFDEF UNIX}
  actFileExit.ShortCut := KeyToShortCut(VK_Q, [ssCtrl]);
{$ENDIF}
{$IFDEF WINDOWS}
  actFileExit.ShortCut := KeyToShortCut(VK_X, [ssAlt]);
{$ENDIF}
end;

procedure TfrmMain.actHumanizeBytesExecute(Sender: TObject);
const
  cSizes: array of Int64 = (
    100,
    1024,
    10000,
    120000,
    30000000,
    69000000000,
    42000000000000);
var
  size: Int64;
begin
  memLog.Clear;
  memLog.Append('=== Bytes Example ===');
  memLog.Append(' Base 10');
  for size in cSizes do
  begin
    memLog.Append(Format('  %d: %s', [size, THumanize.Bytes(size, 1, True)]));
  end;
  memLog.Append(' Base 2');
  for size in cSizes do
  begin
    memLog.Append(Format('  %d: %s', [size, THumanize.Bytes(size, 1)]));
  end;
end;

procedure TfrmMain.actHumanizeCommaExecute(Sender: TObject);
const
  cStrings: array of String = ('One', 'two', 'apple', 'cat', 'dog');
begin
  memLog.Clear;
  memLog.Append('=== Comma Example ===');
  memLog.Append(Format('  %d: %s', [10000000, THumanize.Comma(10000000)]));
  memLog.Append(Format('  %.2f: %s', [10000000.42, THumanize.Comma(10000000.42)]));
  memLog.Append(Format('  %.2f Precision 3: %s', [10000000.42, THumanize.Comma(10000000.42, 3)]));
  memLog.Append(Format('  Strings: "%s"', [THumanize.Comma(cStrings)]));
  memLog.Append(Format('  Strings Sorted: "%s"', [THumanize.Comma(cStrings, True)]));
  memLog.Append(Format('  Strings And: "%s"', [THumanize.CommaAnd(cStrings)]));
  memLog.Append(Format('  Strings And Sorted: "%s"', [THumanize.CommaAnd(cStrings, True)]));
end;

procedure TfrmMain.actHumanizeOrdinalExecute(Sender: TObject);
const
  cNumbers: array of Integer = (
    1,
    2,
    3,
    11,
    12,
    13,
    15,
    100,
    2001,
    2002,
    2003);
var
  number: Integer;
begin
  memLog.Clear;
  memLog.Append('=== Ordinal Example ===');
  for number in cNumbers do
    memLog.Append(Format('  %d: %s', [number, THumanize.Ordinal(number)]));
end;

procedure TfrmMain.actHumanizeTimeExecute(Sender: TObject);
const
  cDurations: array of Integer = (
    1,
    2,
    2 * -1,
    3,
    59,
    60,
    60 * 2,
    60 * 3,
    60 * 60,
    60 * 60 * 2 * -1,
    60 * 60 * 3,
    60 * 60 * 24,
    60 * 60 * 24 * 2 * -1,
    60 * 60 * 24 * 3,
    60 * 60 * 24 * 7,
    60 * 60 * 24 * 7 * 2 * -1,
    60 * 60 * 24 * 7 * 3,
    60 * 60 * 24 * 365,
    60 * 60 * 24 * 365 * 2 * -1,
    60 * 60 * 24 * 365 * 3,
    60 * 60 * 24 * 365 * 49,
    60 * 60 * 24 * 365 * 50
  );
var
  duration: Integer;
  nowUnix: INt64;
begin
  memLog.Clear;
  memLog.Append('=== Time Example ===');
  memLog.Append(' Seconds');
  nowUnix:= DateTimeToUnix(Now);
  for duration in cDurations do
    memLog.Append(Format('  %d: %s', [duration, THumanize.RelativeTime(
      nowUnix,
      nowUnix + duration
      )]));
  memLog.Append(' DateTime');
  memLog.Append(Format('  ["%s", "%s"]: %s', [
    DateTimeToStr(Now),
    DateTimeToStr(Tomorrow),
    THumanize.RelativeTime(
      Now,
      Tomorrow
    )]));
  memLog.Append(Format('  ["%s", "%s"]: %s', [
  DateTimeToStr(Now),
  DateTimeToStr(Yesterday),
    THumanize.RelativeTime(
      Now,
      Yesterday
    )]));
end;

end.

