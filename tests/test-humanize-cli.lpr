program testhumanizecli;

{$mode objfpc}{$H+}

uses
  Classes
, consoletestrunner
, TestHumanizeBytes
, TestHumanizeComma
, TestHumanizeOrdinals
, TestHumanizeTime
;

type

  { TMyTestRunner }

  TMyTestRunner = class(TTestRunner)
  protected
  // override the protected methods of TTestRunner to customize its behavior
  end;

var
  Application: TMyTestRunner;

begin
  DefaultRunAllTests:=True;
  DefaultFormat:=fPlain;
  Application := TMyTestRunner.Create(nil);
  Application.Initialize;
  Application.Title := 'Humanize package tests';
  Application.Run;
  Application.Free;
end.
