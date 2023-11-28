unit Services.Utils.Options;

interface

uses
  Generics.Collections,
  {$IfNDef FPC}
  System.JSON;
  {$ELSE}
   fpjson, jsonparser;
  {$EndIf}

type
//  FetchFunc = function(url: string; config: RequestInit): TJSONObject of object;

  Headers = TDictionary<string, string>;

  QueryParams = TDictionary<string, Variant>;

  SendOptions = class
//    fetch: FetchFunc;
    Headers: Headers;
    body: Variant;
    query: QueryParams;
    requestKey: string;
    // Other deprecated fields can be omitted or marked as deprecated.
  end;

  CommonOptions = class(SendOptions)
  private
    FFields: string;
  public
    property Fields: string read FFields write FFields;
  end;

implementation

end.
