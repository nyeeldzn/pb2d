unit Demo.Post;

interface


type
  TPosts = class
  private
    FID     : string;
    FTitle  : string;
    FContent: string;
    FCreated: string;
    FUpdated: string;
  public
    property id     : string read FID write FID;
    property title  : string read FTitle write FTitle;
    property content: string read FContent write FContent;
    property created: string read FCreated write FCreated;
    property updated: string read FUpdated write FUpdated;

    function Equals(APost: TPosts): boolean; reintroduce;
  end;

implementation

{ TPosts }

function TPosts.Equals(APost: TPosts): boolean;
begin
  Result := (self.FID = APost.FID) and
    (self.FTitle = APost.FTitle) and
    (self.FContent = APost.FContent) and
    (self.FCreated = APost.FCreated);
end;

end.
