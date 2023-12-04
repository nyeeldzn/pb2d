unit main;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses

  {$IFNDEF FPC}

  Winapi.Windows,

  {$ENDIF}

  Forms,
  Graphics,
  Controls,
  Dialogs,
  sysutils,
  Variants,
  Classes,
  Messages,
  Client,
  StdCtrls,
  Generics.Collections,
  Services.Utils.Dtos,
  Services.RecordService,
  Demo.Post;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;

    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ClientInstance: PBClient;
  public
    { Public declarations }

  end;

function FormatarJSON(const JSONString: string): string;

var
  Form1: TForm1;

implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

procedure TForm1.Button1Click(Sender: TObject);
var
  Post, post2, post3, post4: TPosts;
  ResultDeleteError        : string;
  ListaPosts               : TObjectList<TPosts>;
begin
  // Post         := TPosts.Create;
  // Post.title   := 'teste 1';
  // Post.content := 'teststsas';
  //
  // post2         := TPosts.Create;
  // post2.title   := 'teste 1';
  // post2.content := 'teststsas';
  //
  // post3         := TPosts.Create;
  // post3.title   := 'teste 1';
  // post3.content := 'teststsas';
  //
  // post4         := TPosts.Create;
  // post4.title   := 'teste 1';
  // post4.content := 'teststsas';
  //
  // Post := ClientInstance
  // .Collection
  // .Insert<TPosts>(Post);
  //
  // post2 := ClientInstance
  // .Collection
  // .Insert<TPosts>(post2);
  //
  // post3 := ClientInstance
  // .Collection
  // .Insert<TPosts>(post3);
  //
  // post4 := ClientInstance
  // .Collection
  // .Insert<TPosts>(post4);
  //
  // ListaPosts := ClientInstance
  // .Collection
  // .GetList<TPosts>;
  //
  // ClientInstance
  // .Collection
  // .GetById<TPosts>('Teste123');
  //
  // Post         := TPosts.Create;
  // Post.title   := 'Daniel Soares';
  // Post.content := 'Lorem Ipsum Doret';
  // Post         := ClientInstance
  // .Collection
  // .Insert<TPosts>(Post);
  //
  // post2 := ClientInstance
  // .Collection
  // .GetById<TPosts>(Post.id);
  //
  // post2.title   := 'Daniel Soares Alterado';
  // post2.content := '123';
  //
  // post3 := ClientInstance
  // .Collection
  // .Update<TPosts>(post2);
  //
  // if
  // not ClientInstance
  // .Collection
  // .TryDelete<TPosts>(post3, ResultDeleteError)
  // then
  // raise Exception.Create(ResultDeleteError);
  //
  //

  ClientInstance
    .Collection
    .Subscribe(
    procedure(AData: string)
    begin
      ShowMessage(AData);
    end);
end;

function FormatarJSON(const JSONString: string): string;
const
  IndentSize = 2;
var
  Indent  : integer;
  Index   : integer;
  InQuote : boolean;
  LastChar: char;
begin
  Result  := '';
  Indent  := 0;
  InQuote := False;

  for Index := 1 to Length(JSONString) do
  begin
    if InQuote then
    begin
      Result := Result + JSONString[Index];
      if (JSONString[Index] = '"') and (LastChar <> '\') then
        InQuote := False;
    end
    else
    begin
      case JSONString[Index] of
        '{', '[':
          begin
            Inc(Indent);
            Result := Result + JSONString[Index] + sLineBreak +
              StringOfChar(' ', Indent * IndentSize);
          end;
        '}', ']':
          begin
            Dec(Indent);
            Result := Result + sLineBreak + StringOfChar(' ', Indent * IndentSize) +
              JSONString[Index];
          end;
        ',':
          begin
            Result := Result + ',' + sLineBreak + StringOfChar(' ', Indent * IndentSize);
          end;
        ':':
          begin
            Result := Result + ': ';
          end;
        '"':
          begin
            Result  := Result + '"';
            InQuote := True;
          end;
      else
        Result := Result + JSONString[Index];
      end;
    end;

    LastChar := JSONString[Index];
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ClientInstance := PBClient.Create('https://greencloud.pockethost.io/');
end;

end.
