unit Client;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses
  Variants,
  Generics.Collections,
  StrUtils,
  Services.Utils.Options,
  // Services.SettingsService,
  Model.Store.BaseAuthStore,
  Services.CollectionServices,
  Services.RecordService,
  Model.Stores.LocalAuthStore,
  Services.RealtimeService;

const
  DEFAULT_LANG     = 'en-US';
  DEFAULT_BASE_URL = '/';

type
  TOptions            = TDictionary<string, Variant>;
  TBeforeSendResult   = TDictionary<string, Variant>;
  TBeforeSendDelegate = function(url: string; Options: QueryOptions): TBeforeSendResult of object;
  TAfterSendFunc      = function(response: string; data: string)         : string of object;

  PBClient = class
  private
    FBaseURL           : string;
    FBeforeSendDelegate: TBeforeSendDelegate;
    FAfterSendFunc     : TAfterSendFunc;
    FLang              : string;
    FAuthStore         : BaseAuthStore;
    // FSettings          : SettingsService;
    FCollections     : CollectionService;
    FRecordServices  : TDictionary<string, RecordService>;

  public
    constructor Create(
      ABaseURL: string = DEFAULT_BASE_URL;
      AAuthStore: BaseAuthStore = nil;
      ALang: string = DEFAULT_LANG
      );

    function Collection: RecordService;
  end;

implementation

{ PBClient }

function PBClient.Collection: RecordService;
begin
  // if
  // not FRecordServices.ContainsKey(ANameOrId)
  // then
  // FRecordServices.Add(ANameOrId, );
  //
  // result := FRecordServices[ANameOrId];
  //

  result := RecordService.Create(Self, FBaseURL)
end;

constructor PBClient.Create(
  ABaseURL: string = DEFAULT_BASE_URL;
  AAuthStore: BaseAuthStore = nil;
  ALang: string = DEFAULT_LANG
  );
begin
  FBaseURL := ABaseURL;
  FLang    := ALang;

  if
    Assigned(AAuthStore)
  then
    FAuthStore := AAuthStore
  else
    FAuthStore := LocalAuthStore.Create();

  FCollections      := CollectionService.Create(Self);
  FRecordServices   := TDictionary<string, RecordService>.Create;
  // FSettings    := SettingsService.Create(Self);
end;

end.
