unit Model.Stores.LocalAuthStore;

interface

uses
  {$IFNDEF FPC}
  System.JSON,
  {$ELSE}
  fpjson, jsonparser,
  {$ENDIF}
  Generics.Collections,
  Model.Store.BaseAuthStore;

type
  LocalAuthStore = class(BaseAuthStore)
  private
    FStorageFallback: TDictionary<string, Variant>;
    FStorageKey     : string;



//    function StorageGet(const Key: string): Variant;
//    procedure StorageSet(const Key: string; const Value: Variant);
//    procedure StorageRemove(const Key: string);
    procedure BindStorageEvent;
  public
    constructor Create(const StorageKey: string = 'pocketbase_auth');
    function GetToken: string;
    function GetModel: AuthModel;
    procedure Save(const Token: string; const Model: AuthModel = nil);
    procedure Clear;
  end;

implementation

uses
  System.SysUtils;

constructor LocalAuthStore.Create(const StorageKey: string);
begin
  FStorageKey      := StorageKey;
  FStorageFallback := TDictionary<string, Variant>.Create;
  BindStorageEvent;
end;

function LocalAuthStore.GetToken: string;
var
  Data: AuthModel;
begin
  // Data := GetModel;
  // if
  // Assigned(Data) and
  // // TJSONObject(Data).TryGetValue<stirng>('token')
  // then
  // // Result := Data['token'].AsString
  // else
  // Result := '';
end;

function LocalAuthStore.GetModel: AuthModel;
var
  Data: AuthModel;
begin
  // Data := StorageGet(FStorageKey).AsType<AuthModel>;
  // if not Assigned(Data) then
  // Result := AuthModel.Create
  // else
  // Result := Data;
end;

procedure LocalAuthStore.Save(const Token: string; const Model: AuthModel);
var
  Data: AuthModel;
begin
  // Data := AuthModel.Create;
  // Data.Add('token', Token);
  // if Assigned(Model) then
  // Data.Add('model', Model);
  //
  // StorageSet(FStorageKey, Variant.From<AuthModel>(Data));
end;

procedure LocalAuthStore.Clear;
begin
  // StorageRemove(FStorageKey);
end;

//function LocalAuthStore.StorageGet(const Key: string): Variant;
//begin
//  // if (Key = FStorageKey) and (not FStorageFallback.ContainsKey(Key)) then
//  // Exit(Variant.Empty);
//  //
//  // if Key = FStorageKey then
//  // Result := FStorageFallback[Key]
//  // else
//  // Result := Variant.Empty; // Implemente a l�gica para obter do armazenamento local, se dispon�vel
//end;

//procedure LocalAuthStore.StorageSet(const Key: string; const Value: Variant);
//begin
//  // if Key = FStorageKey then
//  // FStorageFallback[Key] := Value
//  // else
//  // Exit; // Implemente a l�gica para armazenar no armazenamento local, se dispon�vel
//end;

//procedure LocalAuthStore.StorageRemove(const Key: string);
//begin
//  // if Key = FStorageKey then
//  // FStorageFallback.Remove(Key)
//  // else
//  // Exit; // Implemente a l�gica para remover do armazenamento local, se dispon�vel
//end;
//
procedure LocalAuthStore.BindStorageEvent;
begin
  // Implemente a l�gica para vincular o evento de armazenamento local, se necess�rio
end;

end.
