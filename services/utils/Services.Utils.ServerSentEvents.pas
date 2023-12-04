unit Services.Utils.ServerSentEvents;

interface

uses
  System.Generics.Collections,
  IdHTTP,
  IdGlobal,
  SysUtils;

type

  { TIndySSEClient }

  TMessageEvent = class;

  TEventListenerProcedure = reference to procedure(AEvent: TMessageEvent);

  TMessageEvent = class
  private
    FId   : string;
    FEvent: string;
    FData : string;
  public
    property id   : string read FId write FId;
    property event: string read FEvent write FEvent;
    property data : string read FData write FData;
  end;

  TEventListener = class
  private
    FElementId: string;
  public
    constructor Create(const AElementId: String);
    procedure HandleEvent(Sender: TObject);
  end;

  TIndySSEClient = class(TObject)
  private
    FEventsSubscribed: TDictionary<string, TEventListenerProcedure>;
    EventStream      : TIdEventStream;
    IdHTTP           : TIdHTTP;
    ChunkCount       : Integer;
    SSE_URL          : string;
  protected
    procedure MyOnWrite(const ABuffer: TIdBytes; AOffset, ACount: Longint; var VResult: Longint);
  public
    constructor Create(const URL: string);
    destructor Destroy; override;

    procedure AddEventListener(AEvent: string; AToDo: TEventListenerProcedure);

    procedure Run;
    procedure Stop;
  end;

procedure RunTest(URL: string);

implementation

uses
  Utils.RTTI;

procedure RunTest;
var
  Client: TIndySSEClient;
begin
  WriteLn('URL for Server-sent events: ' + URL);

  Client := TIndySSEClient.Create(URL);
  try
    try
      Client.Run;
    except
      on E: Exception do
        WriteLn(E.Message);
    end;
  finally
    Client.Free;
  end;
end;

{ TIndySSEClient }

procedure TIndySSEClient.AddEventListener(AEvent: string;
  AToDo: TEventListenerProcedure);
begin
  FEventsSubscribed.Add(AEvent, AToDo);
end;

constructor TIndySSEClient.Create;
begin
  inherited Create;

  SSE_URL := URL;

  FEventsSubscribed := TDictionary<string, TEventListenerProcedure>.Create;

  EventStream         := TIdEventStream.Create;
  EventStream.OnWrite := MyOnWrite;

  IdHTTP                      := TIdHTTP.Create;
  IdHTTP.Request.Accept       := 'text/event-stream';
  IdHTTP.Request.CacheControl := 'no-store';
end;

destructor TIndySSEClient.Destroy;
begin
  IdHTTP.Free;
  EventStream.Free;

  inherited;
end;

procedure TIndySSEClient.Run;
begin
  IdHTTP.Get(SSE_URL, EventStream);
end;

procedure TIndySSEClient.Stop;
begin
  IdHTTP.Disconnect;
end;

procedure TIndySSEClient.MyOnWrite;
var
  ReceivedEventData: string;
  ReceivedEvent    : TMessageEvent;
begin
  ReceivedEventData := IndyTextEncoding_UTF8.GetString(ABuffer);

  ReceivedEvent := ObjectHelper.DeserializeJson<TMessageEvent>(ReceivedEventData);

  Inc(ChunkCount);

  try
    if
      FEventsSubscribed.ContainsKey(ReceivedEvent.event)
    then
      FEventsSubscribed[ReceivedEvent.event](ReceivedEvent);
  finally
    FreeAndNil(ReceivedEvent)
  end;

end;

{ TEventListener }

constructor TEventListener.Create(const AElementId: String);
begin
  FElementId := AElementId;
end;

procedure TEventListener.HandleEvent(Sender: TObject);
begin
  //
end;

end.