unit TestHumanizeOrdinals;

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
{ TTestOrdinals }
  TTestOrdinals= class(TTestCase)
  private
    FRet: String;
  protected
  public
  published
    procedure TestOrdinals;
  end;

implementation

uses
  humanize
;

{ TTestOrdinals }

procedure TTestOrdinals.TestOrdinals;
begin
  FRet:= THumanize.Ordinal(1);
  AssertEquals('Ordinals 1st', '1st', FRet);
end;

initialization

  RegisterTest(TTestOrdinals);
end.

