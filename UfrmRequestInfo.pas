unit UfrmRequestInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, Grids, DBGrids,
  ComCtrls, ADODB;

type
  TfrmRequestInfo = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    UniQuery1: TADOQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UniQuery1AfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
function  frmRequestInfo: TfrmRequestInfo;

implementation

uses UfrmMain;

var
  ffrmRequestInfo: TfrmRequestInfo;
  
{$R *.dfm}

function  frmRequestInfo: TfrmRequestInfo;
begin
  if ffrmRequestInfo=nil then ffrmRequestInfo:=TfrmRequestInfo.Create(application.mainform);
  result:=ffrmRequestInfo;
end;

procedure TfrmRequestInfo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action:=cafree;
  if ffrmRequestInfo=self then ffrmRequestInfo:=nil;
end;

procedure TfrmRequestInfo.BitBtn1Click(Sender: TObject);
var
  ssName,ssBarcode:String;
begin
  ssName:='';
  ssBarcode:='';
  
  if trim(LabeledEdit1.Text)<>'' then ssName:=' and 患者姓名='''+LabeledEdit1.Text+''' ';
  if trim(LabeledEdit2.Text)<>'' then ssBarcode:=' and 条码='''+LabeledEdit2.Text+''' ';

  UniQuery1.Close;
  UniQuery1.SQL.Clear;
  UniQuery1.SQL.Text:='select * from v_HIS_Lis_pat where 开单时间 between :DateTimePicker1 and :DateTimePicker2'+ssName+ssBarcode;
  UniQuery1.Parameters.ParamByName('DateTimePicker1').Value:=DateTimePicker1.DateTime;
  UniQuery1.Parameters.ParamByName('DateTimePicker2').Value:=DateTimePicker2.DateTime;
  UniQuery1.Open;
end;

procedure TfrmRequestInfo.FormShow(Sender: TObject);
begin
  UniQuery1.Connection:=frmMain.UniConnection1;
  
  DateTimePicker1.Date:=Date-1;
  DateTimePicker2.Date:=Date;
end;

procedure TfrmRequestInfo.UniQuery1AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;
  
  dbgrid1.Columns[0].Width:=60;//Order_ID,HIS组合项目代码
  dbgrid1.Columns[1].Width:=42;//姓名
  dbgrid1.Columns[2].Width:=30;
  dbgrid1.Columns[3].Width:=30;
  dbgrid1.Columns[4].Width:=30;
  dbgrid1.Columns[5].Width:=72;
  dbgrid1.Columns[6].Width:=72;
  dbgrid1.Columns[7].Width:=60;
  dbgrid1.Columns[8].Width:=20;//送检医生代码
  dbgrid1.Columns[9].Width:=42;//送检医生名称
  dbgrid1.Columns[10].Width:=20;//Order_Code
  dbgrid1.Columns[11].Width:=80;
  dbgrid1.Columns[12].Width:=80;
  dbgrid1.Columns[13].Width:=80;
  dbgrid1.Columns[14].Width:=80;
  dbgrid1.Columns[15].Width:=57;//样本类型
end;

initialization
  ffrmRequestInfo:=nil;

end.
