unit humanize;

{$mode ObjFPC}{$H+}

interface

uses
  Classes
, SysUtils
, Translations
;

type
{ THumanize }
  THumanize = class(TObject)
  private
  protected
  public
    class function Bytes(ABytes: UInt64; Aprecision: Integer = 2; AUseBase10: Boolean = False): String;
    { #todo -ogcarreno : Attempt ParseBytes }

    class function Comma(AInteger: Int64): String;
    class function Comma(ADouble: Double; APrecision: Integer = 2): String;
    class function Comma(AStrings: array of String; AOrder: Boolean = False): String;

    class function CommaAnd(AStrings: array of String; AOrder: Boolean = False): String;

    class function Ordinal(AInteger: UInt64): String;

    class function RelativeTime(ASecondsA, AsecondsB: Int64): String;
    class function RelativeTime(ADateTimeA, ADateTimeB: TDateTime): String;
  published
  end;

resourcestring
  rBytesUnknown = '?';
  rBytesB       = 'B';
  rBytesB2KB    = 'KiB';
  rBytesB10KB   = 'KB';
  rBytesB2MB    = 'MiB';
  rBytesB10MB   = 'MB';
  rBytesB2GB    = 'GiB';
  rBytesB10GB   = 'GB';
  rBytesB2TB    = 'TiB';
  rBytesB10TB   = 'TB';

  rComma = ', ';

  rCommaAnd = '%s and %s';

  rOrdinalTH = 'th';
  rOrdinalST = 'st';
  rOrdinalND = 'nd';
  rOrdinalRD = 'rd';

  rPeriodAgo     = 'ago';
  rPeriodFromNow = 'from now';
  rPeriodNow     = 'now';
  rPeriodSecond  = '1 second %s';
  rPeriodSeconds = '%d seconds %s';
  rPeriodMinute  = '1 minute %s';
  rPeriodMinutes = '%d minutes %s';
  rPeriodHour    = '1 hour %s';
  rPeriodHours   = '%d hours %s';
  rPeriodDay     = '1 day %s';
  rPeriodDays    = '%d days %s';
  rPeriodWeek    = '1 week %s';
  rPeriodWeeks   = '%d weeks %s';
  rPeriodMonth   = '1 month %s';
  rPeriodMonths  = '%d months %s';
  rPeriodYear    = '1 year %s';
  rPeriodYears   = '%d years %s';
  rPeriodYears2  = '2 years %s';
  rPeriodLongAgo = 'a long while %s';

implementation

uses
  DateUtils
;

{ THumanize }

class function THumanize.Bytes(ABytes: UInt64; Aprecision: Integer;
  AUseBase10: Boolean): String;
var
  index: Integer;
  bytesTMP: Double;
  precision: String;
begin
  Result:= EmptyStr;

  if (APrecision > 0) and (APrecision < 20) then
  begin
    precision:= EmptyStr;
    for index:= 1 to APrecision do
    begin
      precision:= precision + '0';
    end;
  end
  else
    precision:= '00';

  bytesTMP:= ABytes;

  index:= 0;
  if AUseBase10 then
  begin
    while bytesTMP >= 1000 do
    begin
      Inc(index);
      bytesTMP:= bytesTMP / 1000;
    end;
    Result:= FormatFloat('#,#.' + precision, bytesTMP);
    case index of
      0: Result:= Format('%s %s', [Result, rBytesB]);
      1: Result:= Format('%s %s', [Result, rBytesB10KB]);
      2: Result:= Format('%s %s', [Result, rBytesB10MB]);
      3: Result:= Format('%s %s', [Result, rBytesB10GB]);
      4: Result:= Format('%s %s', [Result, rBytesB10TB]);
    otherwise
      Result:= Format('%s %s', [Result, rBytesUnknown]);
    end;
  end
  else
  begin
    while bytesTMP >= 1024 do
    begin
      Inc(index);
      bytesTMP:= bytesTMP / 1024;
    end;
    Result:= FormatFloat('#,#.' + precision, bytesTMP);
    case index of
      0: Result:= Format('%s %s', [Result, rBytesB]);
      1: Result:= Format('%s %s', [Result, rBytesB2KB]);
      2: Result:= Format('%s %s', [Result, rBytesB2MB]);
      3: Result:= Format('%s %s', [Result, rBytesB2GB]);
      4: Result:= Format('%s %s', [Result, rBytesB2TB]);
    otherwise
      Result:= Format('%s %s', [Result, rBytesUnknown]);
    end;
  end;
end;

class function THumanize.Comma(AInteger: Int64): String;
begin
  Result:= FormatFloat('#,#', AInteger);
end;

class function THumanize.Comma(ADouble: Double; APrecision: Integer): String;
var
  precision: String;
  index: Integer;
begin
  if (APrecision > 0) and (APrecision < 20) then
  begin
    precision:= EmptyStr;
    for index:= 1 to APrecision do
    begin
      precision:= precision + '0';
    end;
  end
  else
    precision:= '00';

  Result:= FormatFloat('#,#.' + precision, ADouble);
end;

class function THumanize.Comma(AStrings: array of String;
  AOrder: Boolean): String;
var
  item: String;
  stringList: TStringList;
begin
  Result:= EmptyStr;
  stringList:= TStringList.Create;
  try
    stringList.Delimiter:= ',';
    stringList.QuoteChar:= #0;
    for item in AStrings do
      stringList.Append(' ' + item);
    if AOrder then
      stringList.Sort;
    Result:= Trim(stringList.DelimitedText);
  finally
    stringList.Free;
  end;
end;

class function THumanize.CommaAnd(AStrings: array of String;
  AOrder: Boolean): String;
var
  item, items: String;
  index: Integer;
  stringList: TStringList;
begin
  Result:= EmptyStr;
  stringList:= TStringList.Create;
  try
    for item in AStrings do
      stringList.Append(item);
    if AOrder then
      stringList.Sort;
    items:= EmptyStr;
    for index:= 0 to stringList.Count - 2 do
      items:= items + stringList[index] + rComma;
    SetLength(items, Length(items) - 2);
    items:= Format(rCommaAnd, [items, stringList[stringList.Count-1]]);
    Result:= Trim(items);
  finally
    stringList.Free;
  end;
end;

class function THumanize.Ordinal(AInteger: UInt64): String;
begin
  Result:= rOrdinalTH;
  case AInteger mod 10 of
    1: begin
      if (AInteger mod 100) <> 11 then
        Result:= rOrdinalST;
    end;
    2: begin
      if (AInteger mod 100) <> 12 then
        Result:= rOrdinalND
    end;
    3: begin
      if (AInteger mod 100) <> 13 then
        Result:= rOrdinalRD;
    end;
  end;
  Result:= Format('%d%s', [AInteger, Result]);
end;

type
  TRelativePeriod = record
    Duration: UInt64;
    DivideBy: UInt64;
    Format: String;
  end;
const
  Second = 1;
  Minute = Second * 60;
  Hour = Minute *  60;
  Day = Hour * 24;
  Week = Day * 7;
  Month = Day * 30;
  Year = Day * 365;
  LongTime = Year * 50;
var
  relativePeriods: array [1..17] of TRelativePeriod;

procedure BuildRelativePeriods;
begin
  relativePeriods[1].Duration:= Second;
  relativePeriods[1].Format:= rPeriodNow;
  relativePeriods[1].DivideBy:= Second;

  relativePeriods[2].Duration:= 2 * Second;
  relativePeriods[2].Format:= rPeriodSecond;
  relativePeriods[2].DivideBy:= 1;

  relativePeriods[3].Duration:= Minute;
  relativePeriods[3].Format:= rPeriodSeconds;
  relativePeriods[3].DivideBy:= Second;

  relativePeriods[4].Duration:= 2 * Minute;
  relativePeriods[4].Format:= rPeriodMinute;
  relativePeriods[4].DivideBy:= 1;

  relativePeriods[5].Duration:= Hour;
  relativePeriods[5].Format:= rPeriodMinutes;
  relativePeriods[5].DivideBy:= Minute;

  relativePeriods[6].Duration:= 2 * Hour;
  relativePeriods[6].Format:= rPeriodHour;
  relativePeriods[6].DivideBy:= 1;

  relativePeriods[7].Duration:= Day;
  relativePeriods[7].Format:= rPeriodHours;
  relativePeriods[7].DivideBy:= Hour;

  relativePeriods[8].Duration:= 2 * Day;
  relativePeriods[8].Format:= rPeriodDay;
  relativePeriods[8].DivideBy:= 1;

  relativePeriods[9].Duration:= Week;
  relativePeriods[9].Format:= rPeriodDays;
  relativePeriods[9].DivideBy:= Day;

  relativePeriods[10].Duration:= 2 * Week;
  relativePeriods[10].Format:= rPeriodWeek;
  relativePeriods[10].DivideBy:= 1;

  relativePeriods[11].Duration:= Month;
  relativePeriods[11].Format:= rPeriodWeeks;
  relativePeriods[11].DivideBy:= Week;

  relativePeriods[12].Duration:= 2 * Month;
  relativePeriods[12].Format:= rPeriodMonth;
  relativePeriods[12].DivideBy:= 1;

  relativePeriods[13].Duration:= Year;
  relativePeriods[13].Format:= rPeriodMonths;
  relativePeriods[13].DivideBy:= Month;

  relativePeriods[14].Duration:= 365 * Day;
  relativePeriods[14].Format:= rPeriodYear;
  relativePeriods[14].DivideBy:= 1;

  relativePeriods[15].Duration:= 2 * Year;
  relativePeriods[15].Format:= rPeriodYears2;
  relativePeriods[15].DivideBy:= 1;

  relativePeriods[16].Duration:= LongTime;
  relativePeriods[16].Format:= rPeriodYears;
  relativePeriods[16].DivideBy:= Year;

  relativePeriods[17].Duration:= MaxInt;
  relativePeriods[17].Format:= rPeriodLongAgo;
  relativePeriods[17].DivideBy:= 1;
end;

function FormatSeconds(ASeconds: Int64): String;
var
  suffix: String;
  index: Integer;
begin
  if ASeconds < 0 then
    suffix:= rPeriodFromNow
  else
    suffix:= rPeriodAgo;

  for index:= Low(relativePeriods) to High(relativePeriods) do
  begin
    if relativePeriods[index].Duration > Abs(ASeconds) then
    begin
      if Pos('%d', relativePeriods[index].Format) > 0 then
        Result:= Format(relativePeriods[index].Format, [
          Abs(ASeconds) div relativePeriods[index].DivideBy,
          suffix
        ])
      else
        Result:= Format(relativePeriods[index].Format, [
          suffix
        ]);
      break;
    end;
  end;
end;

class function THumanize.RelativeTime(ASecondsA, AsecondsB: Int64): String;
var
  diff: Int64;
begin
  Result:= EmptyStr;
  diff:= ASecondsA - AsecondsB;
  Result:= FormatSeconds(diff);
end;

class function THumanize.RelativeTime(ADateTimeA,
  ADateTimeB: TDateTime): String;
var
  diff: Int64;
begin
  Result:= EmptyStr;
  diff:= DateTimeToUnix(ADateTimeA) - DateTimeToUnix(ADateTimeB);
  Result:= FormatSeconds(diff);
end;

procedure Translate(ALang: string);
var
  folder: String;
begin
  if ALang = EmptyStr then exit;

  folder:= EmptyStr;
  if DirectoryExists('locale') then
    folder:= 'locale';
  if DirectoryExists('languages') then
    folder:= 'languages';
  if folder = EmptyStr then exit;

  TranslateUnitResourceStrings('humanize', Format('%s/humanize.%s.po', [
    folder,
    ALang
  ]));
end;

function GetLanguageFromCommandLine: String;
var
  index: Integer;
begin
  Result:= EmptyStr;
  for index:= 0 to ParamCount do
  begin
    if ParamStr(index) = '-l' then
    begin
      Result:= ParamStr(index + 1);
      break;
    end;
    if Pos('--lang', ParamStr(index)) > 0 then
    begin
      if Pos('=', ParamStr(index)) > 0 then
      begin
        Result:= Copy(ParamStr(index), Pos('=', ParamStr(index)) + 1, Length(ParamStr(index)));
        break;
      end
      else
      begin
        Result:= ParamStr(index + 1);
        break;
      end;
    end;
  end;
  if Result = EmptyStr then
    Result:= GetLanguageID.LanguageCode;
end;

initialization

  // Get current language and translate strings to it
  Translate(GetLanguageFromCommandLine);

  // Build the relative periods array
  BuildRelativePeriods;

end.

