unit UfrmLogin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, DBTables, DBCtrls, Grids,
  DBGrids, ADODB, DosMove,inifiles, ActnList, jpeg;

type
  TfrmLogin = class(TForm)
    ADOQuery1: TADOQuery;
    DosMove1: TDosMove;
    ActionList1: TActionList;
    Action1: TAction;
    suiForm1: TPanel;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    suiButton3: TBitBtn;
    suiButton4: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LabeledEdit4Exit(Sender: TObject);
    procedure suiButton3Click(Sender: TObject);
    procedure suiButton3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure suiButton4Click(Sender: TObject);
    
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
function  frmLogin: TfrmLogin;

implementation

uses UfrmMain;

var
  ffrmLogin: TfrmLogin;

{$R *.dfm}

////////////////////////////////////////////////////////////////////////////////
function  frmLogin: TfrmLogin;        {动态创建窗体函数}
begin
  if ffrmLogin=nil then ffrmLogin:=TfrmLogin.Create(application.mainform);
  result:=ffrmLogin;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=cafree;
  if ffrmLogin=self then ffrmLogin:=nil;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  ADOQuery1.Connection:=frmMain.ADOConnection1;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
var
  ini:tinifile;
begin
  ini:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));
  Label1.Caption:='版权所有:'+ini.ReadString('Interface','companyname','广东誉凯软件工作室');
  Label2.Caption:='联系电话:'+ini.ReadString('Interface','companytel','13710248644');
  ini.Free;
  if FileExists(ExtractFilePath(application.ExeName)+'logo.bmp') then
    Image1.Picture.LoadFromFile(ExtractFilePath(application.ExeName)+'logo.bmp')
    else if FileExists(ExtractFilePath(application.ExeName)+'logo.jpg') then
      Image1.Picture.LoadFromFile(ExtractFilePath(application.ExeName)+'logo.jpg')
      else Image1.Picture:=nil;

  LabeledEdit2.Clear;
end;

procedure TfrmLogin.LabeledEdit4Exit(Sender: TObject);
begin
    ADOQuery1.Close;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Text:='select * from worker ';
    ADOQuery1.Open;

    if not ADOQuery1.Locate('id',LabeledEdit4.Text,[loCaseInsensitive]) then
    begin
      LABELEDEDIT5.Text:='';
      exit;
    end;
    LABELEDEDIT5.Text:=TRIM(ADOQuery1.FIELDBYNAME('NAME').AsString);
end;

procedure TfrmLogin.suiButton3Click(Sender: TObject);
var
  PWD,PWDfromDB:STRING;
begin
  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Text:='select * from worker ';
  ADOQuery1.Open;

  if not ADOQuery1.Locate('id',LabeledEdit4.Text,[loCaseInsensitive]) then
  begin
    messagedlg('无此用户',mtError,[mbok],0);
    exit;
  end;

  PWD:=trim(uppercase(LabeledEdit2.Text));

  PWDfromDB:=ADOQuery1.fieldbyname('passwd').AsString;

  if uppercase(trim(PWD))<>uppercase(TRIM(PWDfromDB)) then
  begin
      messagedlg('密码错误！',mtError,[mbok],0);    
      LabeledEdit2.SetFocus;
  end
  else   //成功登录
  begin
    close;
    operator_name:=trim(labelededit5.Text);
    operator_id:=trim(labelededit4.Text);
    SendNotifyMessage(application.mainform.handle,WM_UPDATETEXTSTATUS,0,integer(pchar(#$2+'2:'+operator_id+#$2+'4:'+operator_name)));
  end;
end;

procedure TfrmLogin.suiButton3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=13 then suiButton3Click(nil);
end;

procedure TfrmLogin.suiButton4Click(Sender: TObject);
begin
  application.Terminate;
end;

initialization
  ffrmLogin:=nil;

end.
