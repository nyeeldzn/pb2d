unit Model.Stores.Utils.Jwt;

interface

uses
  DateUtils,
  SysUtils,
  {$IFNDEF FPC}
  System.JSON;
  {$ELSE}
  fpjson, jsonparser;
  {$ENDIF}

type
  TJWTUtils = class
  private
    class function AtobPolyfill(const Input: string): string; static;
  public
    class function getTokenPayload(const Token: string): TJSONObject; static;
    class function IsTokenExpired(const Token: string; ExpirationThreshold: Integer = 0): Boolean; static;
  end;

implementation

class function TJWTUtils.AtobPolyfill(const Input: string): string;
const
  Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
var
  Buffer, Bs: Integer;
  Bc        : Integer;
  Str       : string;
  Idx       : Integer;
begin
{  Str := TNetEncoding.URL.Decode(Input);
  if Length(Str) mod 4 = 1 then
    raise Exception.Create('''atob'' failed: The string to be decoded is not correctly encoded.');

  Bc     := 0;
  Result := '';
  Idx    := 1;
  while Idx <= Length(Str) do
  begin
    Buffer := Ord(Str[Idx]);
    Inc(Idx);

    if
      Buffer = Ord('=')
    then
      Break;

    Buffer := Pos(Str[Idx], Chars) - 1;
    Inc(Idx);

    if
      Buffer < 0
    then
      Continue;

    Bs := Bc mod 4;

    if
      Bs <> 0
    then
    begin
      Bs := Bs * 64 + Buffer
    end
    else
    begin
      Bs := Buffer;
    end;

    if
      (Bc mod 4) <> 0
    then
      Result := Result + Chr(255 and (Bs shr ((-2 * Bc) and 6)));

    Inc(Bc);
  end;
  }
end;

class function TJWTUtils.getTokenPayload(const Token: string): TJSONObject;
var
  EncodedPayload, Payload: string;
  CharCode : Char;
begin
  EncodedPayload := TJWTUtils.AtobPolyfill(Token.Split(['.'])[1]);
  Payload        := '';

  for CharCode in EncodedPayload.ToCharArray do
    Payload := Payload + '%' + Format('%.2x', [CharCode]);

  try
   // Result := TJSONObject.ParseJSONValue(TNetEncoding.URL.Decode(Payload)) as TJSONObject;
  except
    Result := TJSONObject.Create;
  end;
end;

class function TJWTUtils.IsTokenExpired(const Token: string; ExpirationThreshold: Integer): Boolean;
var
  Payload : TJSONObject;
  ExpValue: Integer;
begin
  Payload := TJWTUtils.getTokenPayload(Token);

  try
    if
      Payload.Count > 0
    then
    begin
//      if
//       not Payload.TryGetValue<Integer>('exp', ExpValue)
//      then
//        ExpValue := 0;

      if
        (ExpValue = 0) or ((ExpValue - ExpirationThreshold) > (DateTimeToUnix(Now) div 1000))
      then
        Exit(False);
    end;
  finally
    Payload.Free;
  end;

  Result := True;
end;

end.
