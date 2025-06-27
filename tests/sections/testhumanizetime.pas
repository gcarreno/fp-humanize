unit TestHumanizeTime;

{$mode objfpc}{$H+}

interface

uses
  Classes
, SysUtils
, fpcunit
//, testutils
, testregistry
;

type
{ TTestTime }
  TTestTime= class(TTestCase)
  private
    FRet: String;
  protected
  public
  published
    procedure TestTime;
  end;

implementation

uses
  humanize
;

{ TTestTime }

procedure TTestTime.TestTime;
begin
  FRet:= THumanize.RelativeTime(1,1);
  AssertEquals('Time 1s', 'now', FRet);
  FRet:= THumanize.RelativeTime(1,2);
  AssertEquals('Time 2s', '1 second from now', FRet);
  FRet:= THumanize.RelativeTime(2, 1);
  AssertEquals('Time -2s', '1 second ago', FRet);
end;

initialization

  RegisterTest(TTestTime);
end.

