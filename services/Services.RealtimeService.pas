unit Services.RealtimeService;

interface

uses
  Classes,
  Variants,
  System.Generics.Collections,
  Services.Utils.BaseService,
  IdHTTP,
  IdGlobal,
  Sysutils,
  Services.Utils.ServerSentEvents;

type
  UnsubscribeFunction = reference to procedure();
  TProcCallback       = reference to procedure(AData: string);

  RealtimeService = class(BaseService)
  private
    FUrl                         : string;
    FEndpoint                    : string;
    FClientID                    : string;
    FLastSentTopics              : TStringList;
    FConnectTimeoutId            : variant;
    FMaxConnectTimeout           : Integer;
    FReconnectTimeoutId          : variant;
    FReconnectAttempts           : Integer;
    FMaxReconnectAttempts        : Integer;
    FPredefinedReconnectIntervals: TStringList;
    FSubscriptions               : TDictionary<String, TObjectList<TEventListener>>;
    // FPendingConnects: TObjectList<PromisseCallbacks>;

    FEventSource: TIndySSEClient;

    procedure AddAllSubscriptionsListeners();
    procedure RemoveAllSubscriptionListeners();
  public
    constructor Create(const AURL: string; const AEndpoint: string); reintroduce;
    function IsConnected(): boolean;
    procedure Subscribe(ATopic: string; ACallback: TProcCallback);
    procedure SubmitSubscriptions();
    procedure Connect();
    procedure InitConnect();
    procedure Disconnect(AFromReconnect: boolean = false);

  end;

implementation

uses
  Utils.RTTI;

{ RealtimeService }

procedure RealtimeService.AddAllSubscriptionsListeners;
begin
  if
    Assigned(FEventSource)
  then
    exit;

  RemoveAllSubscriptionListeners();

  for var topic in FSubscriptions do
  begin
    for var listener in FSubscriptions[topic.Key] do
    begin
      FEventSource.AddEventListener(topic.Key,
        procedure(AEvent: TMessageEvent)
        begin
          listener.HandleEvent(FEventSource)
        end
        );
    end;
  end;
end;

procedure RealtimeService.Connect;
begin
  if
    FReconnectAttempts > 0
  then
    exit;

  InitConnect();
end;

constructor RealtimeService.Create(const AURL: string; const AEndpoint: string);
begin
  FUrl      := AURL;
  FEndpoint := AEndpoint;

  FSubscriptions := TDictionary < String, TObjectList < TEventListener >>.Create;
end;

procedure RealtimeService.Disconnect(AFromReconnect: boolean = false);
begin
  FEventSource.Stop;
end;

procedure RealtimeService.InitConnect;
var
  ReceivedEventsCount: Integer;
begin

  Disconnect(True);

  FEventSource := TIndySSEClient.Create(FUrl + '/api/realtime');
  FEventSource.AddEventListener('PB_CONNECT',
    procedure(AEvent: TMessageEvent)
    begin
      inc(ReceivedEventsCount);

      if
        AEvent.id <> ''
      then
        FClientID := AEvent.id;

      try
        SubmitSubscriptions();
      finally

      end;

    end
    );

  FEventSource.Run;
end;

function RealtimeService.IsConnected: boolean;
begin

end;

procedure RealtimeService.RemoveAllSubscriptionListeners;
begin
  if 
    not Assigned(FEventSource)
  then
    exit;

  for var topic in FSubscriptions do
  begin
    for var listener in FSubscriptions[topic.Key] do
    begin
      // FEventSource.RemoveEventListener(topic, listener)
    end;
  end;

end;

procedure RealtimeService.SubmitSubscriptions;
begin
  if
    FClientID = ''
  then
    exit;

end;

procedure RealtimeService.Subscribe(ATopic: string; ACallback: TProcCallback);
begin
  if 
    ATopic = ''
  then
    raise Exception.Create('Topic must be set');

      
end;

end.
