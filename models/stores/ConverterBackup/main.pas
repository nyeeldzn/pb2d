unit main;

interface

uses
  Client,
  Services.Utils.Dtos,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    ClientInstance: PBClient;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  result: string;
begin
  ClientInstance := PBClient.Create('https://pocketbase.io/demo/');
  result         := ClientInstance
    .Collection('users')
    .GetList();

  // ClientInstance

  // ClientInstance
  // .Collections('')
  // .GetList<CollectionModel>;
end;

end.
