unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, Grids, DBGrids,
  Buttons, ADODB,IniFiles,StrUtils, VirtualTable,
  ActnList, DosMove, ComCtrls, MemDS;

//==为了通过发送消息更新主窗体状态栏而增加==//
const
  WM_UPDATETEXTSTATUS=WM_USER+1;
TYPE
  TWMUpdateTextStatus=TWMSetText;
//=========================================//

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    LabeledEdit1: TLabeledEdit;
    ADOConnection1: TADOConnection;
    SpeedButton1: TSpeedButton;
    GroupBox1: TGroupBox;
    DataSource1: TDataSource;
    VirtualTable1: TVirtualTable;
    Panel3: TPanel;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    LabeledEdit11: TLabeledEdit;
    Edit2: TEdit;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    ActionList1: TActionList;
    Action1: TAction;
    CheckBox1: TCheckBox;
    DosMove1: TDosMove;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    UniConnection1: TADOConnection;
    procedure LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure VirtualTable1AfterOpen(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function MakeAdoDBConn:boolean;
    function MakeHISDBConn:boolean;
    procedure SingleRequestForm2Lis(const WorkGroup,His_Unid,patientname,sex,age,age_unit,deptname,check_doctor,RequestDate:String;const ABarcode,Surem1,checkid,SampleType,pkcombin_id,His_MzOrZy,PullPress:String);
    //==为了通过发送消息更新主窗体状态栏而增加==//
    procedure WMUpdateTextStatus(var message:twmupdatetextstatus);  {WM_UPDATETEXTSTATUS消息处理函数}
                                              message WM_UPDATETEXTSTATUS;
    procedure updatestatusBar(const text:string);//Text为该格式#$2+'0:abc'+#$2+'1:def'表示状态栏第0格显示abc,第1格显示def,依此类推
    //==========================================//
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

  operator_name:string;
  operator_id:string;

implementation

uses superobject, UfrmRequestInfo, UfrmLogin;

{$R *.dfm}

procedure RequestForm2Lis(const AAdoconnstr,ARequestJSON,CurrentWorkGroup:PChar);stdcall;external 'Request2Lis.dll';
function UnicodeToChinese(const AUnicodeStr:PChar):PChar;stdcall;external 'LYFunction.dll';
procedure WriteLog(const ALogStr: Pchar);stdcall;external 'LYFunction.dll';
function DeCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'LYFunction.dll';//解密
function ShowOptionForm(const pCaption,pTabSheetCaption,pItemInfo,pInifile:Pchar):boolean;stdcall;external 'OptionSetForm.dll';
function GetMaxCheckID(const AWorkGroup,APreDate,APreCheckID:PChar):PChar;stdcall;external 'LYFunction.dll';

const
  CryptStr='lc';
  
procedure TfrmMain.LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  UniQryTemp22:TADOQuery;
  ADOTemp22:TADOQuery;

  i:Integer;

  VTTemp:TVirtualTable;

  ini:TIniFile;

  PreWorkGroup:String;//该变量作用:仅保存工作组第一条记录的联机号

  PreDate,PreCheckID:String;
begin
  if key<>13 then exit;

  if trim((Sender as TLabeledEdit).Text)='' then exit;

  PreWorkGroup:='上一个工作组';//初始化为实际情况不可能出现的工作组名称即可

  (Sender as TLabeledEdit).Enabled:=false;//为了防止没处理完又扫描下一个条码

  UniQryTemp22:=TADOQuery.Create(nil);
  UniQryTemp22.Connection:=UniConnection1;
  UniQryTemp22.Close;
  UniQryTemp22.SQL.Clear;
  UniQryTemp22.SQL.Text:='select * from v_HIS_Lis_pat where 条码=:barcode';
  UniQryTemp22.Parameters.ParamByName('barcode').Value:=(Sender as TLabeledEdit).Text;
  UniQryTemp22.Open;

  (Sender as TLabeledEdit).Clear;

  LabeledEdit2.Text:=UniQryTemp22.fieldbyname('患者姓名').AsString;
  LabeledEdit3.Text:=UniQryTemp22.fieldbyname('患者性别').AsString;
  LabeledEdit4.Text:=UniQryTemp22.fieldbyname('患者年龄').AsString;
  Edit2.Text:=UniQryTemp22.fieldbyname('患者年龄单位').AsString;
  LabeledEdit5.Text:=UniQryTemp22.fieldbyname('开单科室').AsString;
  LabeledEdit6.Text:=UniQryTemp22.fieldbyname('开单医生').AsString;
  LabeledEdit7.Text:=UniQryTemp22.fieldbyname('条码').AsString;
  LabeledEdit8.Text:=FormatDateTime('yyyy-mm-dd hh:nn:ss',UniQryTemp22.fieldbyname('开单时间').AsDateTime);
  //LabeledEdit11.Text:=UniQryTemp22.fieldbyname('REG_ID').AsString;

  VirtualTable1.Clear;
  for i:=0 to (DBGrid1.columns.count-1) do DBGrid1.columns[i].readonly:=False;

  while not UniQryTemp22.Eof do
  begin
    ADOTemp22:=TADOQuery.Create(nil);
    ADOTemp22.Connection:=ADOConnection1;
    ADOTemp22.Close;
    ADOTemp22.SQL.Clear;
    ADOTemp22.SQL.Text:='select ci.Id,ci.Name,ci.dept_DfValue '+
                        'from combinitem ci,HisCombItem hci '+
                        'where ci.Unid=hci.CombUnid and hci.ExtSystemId=''HIS'' '+
                        'and hci.HisItem=:HisItem';
    ADOTemp22.Parameters.ParamByName('HisItem').Value:=UniQryTemp22.fieldbyname('检验组合项目代码').AsString;
    ADOTemp22.Open;

    //LIS中没有相对应的项目
    if ADOTemp22.RecordCount<=0 then Memo1.Lines.Add(UniQryTemp22.fieldbyname('检验组合项目代码').AsString+'【'+UniQryTemp22.fieldbyname('HIS检验组合项目名称').AsString+'】在LIS中没有对照'); 

    while not ADOTemp22.Eof do
    begin
      //如工作组为空,ini.ReadString报错ntdll.dll,且产生操作人员找不到病人信息的问题
      if trim(ADOTemp22.FieldByName('dept_DfValue').AsString)='' then
      begin
        Memo1.Lines.Add(ADOTemp22.FieldByName('Id').AsString+'【'+ADOTemp22.FieldByName('Name').AsString+'】未设置默认工作组');
        ADOTemp22.Next;
        continue;
      end;

      ini:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
      PreDate:=ini.ReadString(ADOTemp22.FieldByName('dept_DfValue').AsString,'检查日期','');
      PreCheckID:=ini.ReadString(ADOTemp22.FieldByName('dept_DfValue').AsString,'联机号','');
      ini.Free;

      VirtualTable1.Append;
      VirtualTable1.FieldByName('外部系统项目申请编号').AsString:='';//UniQryTemp22.FieldByName('REQUEST_NO').AsString;
      VirtualTable1.FieldByName('HIS项目代码').AsString:=UniQryTemp22.FieldByName('检验组合项目代码').AsString;
      VirtualTable1.FieldByName('HIS项目名称').AsString:=UniQryTemp22.FieldByName('HIS检验组合项目名称').AsString;
      VirtualTable1.FieldByName('LIS项目代码').AsString:=ADOTemp22.FieldByName('Id').AsString;
      VirtualTable1.FieldByName('LIS项目名称').AsString:=ADOTemp22.FieldByName('Name').AsString;
      VirtualTable1.FieldByName('工作组').AsString:=ADOTemp22.FieldByName('dept_DfValue').AsString;
      VirtualTable1.FieldByName('样本类型').AsString:=UniQryTemp22.FieldByName('样本类型').AsString;
      VirtualTable1.FieldByName('联机号').AsString:=GetMaxCheckId(PChar(ADOTemp22.FieldByName('dept_DfValue').AsString),PChar(PreDate),PChar(PreCheckID));
      VirtualTable1.Post;

      ADOTemp22.Next;
    end;
    ADOTemp22.Free;

    UniQryTemp22.Next;
  end;
  UniQryTemp22.Free;

  for i:=0 to (DBGrid1.columns.count-2) do DBGrid1.columns[i].readonly:=True;//仅保留最后1列(联机号)可编辑

  if CheckBox1.Checked then
  begin
    VTTemp:=TVirtualTable.Create(nil);
    VTTemp.Assign(VirtualTable1);//clone数据集
    VTTemp.Open;
    while not VTTemp.Eof do
    begin
      SingleRequestForm2Lis(
        VTTemp.fieldbyname('工作组').AsString,
        LabeledEdit11.Text,
        LabeledEdit2.Text,
        LabeledEdit3.Text,
        LabeledEdit4.Text,
        Edit2.Text,
        LabeledEdit5.Text,
        LabeledEdit6.Text,
        LabeledEdit8.Text,
        LabeledEdit7.Text,
        VTTemp.fieldbyname('外部系统项目申请编号').AsString,
        VTTemp.fieldbyname('联机号').AsString,
        VTTemp.fieldbyname('样本类型').AsString,
        VTTemp.fieldbyname('LIS项目代码').AsString,
        '',
        operator_name
      );

      //保存当前联机号
      if (trim(VTTemp.fieldbyname('工作组').AsString)<>'')and(VTTemp.fieldbyname('工作组').AsString<>PreWorkGroup) then
      begin
        PreWorkGroup:=VTTemp.fieldbyname('工作组').AsString;
        ini:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
        ini.WriteString(VTTemp.fieldbyname('工作组').AsString,'检查日期',FormatDateTime('YYYY-MM-DD',Date));
        ini.WriteString(VTTemp.fieldbyname('工作组').AsString,'联机号',VTTemp.fieldbyname('联机号').AsString);
        ini.Free;
      end;
      //==============

      VTTemp.Next;
    end;
    VTTemp.Close;
    VTTemp.Free;
  end;

  (Sender as TLabeledEdit).Enabled:=true;
  if (Sender as TLabeledEdit).CanFocus then (Sender as TLabeledEdit).SetFocus;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  MakeHISDBConn;
  MakeAdoDBConn;

  //设计期设置VirtualTable字段
  VirtualTable1.IndexFieldNames:='工作组,样本类型';//按工作组、样本类型排序
  VirtualTable1.Open;
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  frmRequestInfo.ShowModal;
end;

function TfrmMain.MakeAdoDBConn: boolean;
var
  newconnstr,ss: string;
  Ini: tinifile;
  userid, password, datasource, initialcatalog: string;{, provider}
  ifIntegrated:boolean;//是否集成登录模式

  pInStr,pDeStr:Pchar;
  i:integer;
  Label labReadIni;
begin
  result:=false;

  labReadIni:
  Ini := tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  datasource := Ini.ReadString('连接LIS数据库', '服务器', '');
  initialcatalog := Ini.ReadString('连接LIS数据库', '数据库', '');
  ifIntegrated:=ini.ReadBool('连接LIS数据库','集成登录模式',false);
  userid := Ini.ReadString('连接LIS数据库', '用户', '');
  password := Ini.ReadString('连接LIS数据库', '口令', '107DFC967CDCFAAF');
  Ini.Free;
  //======解密password
  pInStr:=pchar(password);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(password,length(pDeStr));
  for i :=1  to length(pDeStr) do password[i]:=pDeStr[i-1];
  //==========

  newconnstr :='';
  newconnstr := newconnstr + 'user id=' + UserID + ';';
  newconnstr := newconnstr + 'password=' + Password + ';';
  newconnstr := newconnstr + 'data source=' + datasource + ';';
  newconnstr := newconnstr + 'Initial Catalog=' + initialcatalog + ';';
  newconnstr := newconnstr + 'provider=' + 'SQLOLEDB.1' + ';';
  //Persist Security Info,表示ADO在数据库连接成功后是否保存密码信息
  //ADO缺省为True,ADO.net缺省为False
  //程序中会传ADOConnection信息给TADOLYQuery,故设置为True
  newconnstr := newconnstr + 'Persist Security Info=True;';
  if ifIntegrated then
    newconnstr := newconnstr + 'Integrated Security=SSPI;';
  try
    ADOConnection1.Connected := false;
    ADOConnection1.ConnectionString := newconnstr;
    ADOConnection1.Connected := true;
    result:=true;
  except
  end;
  if not result then
  begin
    ss:='服务器'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '数据库'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '集成登录模式'+#2+'CheckListBox'+#2+#2+'0'+#2+'启用该模式,则用户及口令无需填写'+#2+#3+
        '用户'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '口令'+#2+'Edit'+#2+#2+'0'+#2+#2+'1';
    if ShowOptionForm('连接LIS数据库','连接LIS数据库',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
      goto labReadIni else application.Terminate;
  end;
end;

function TfrmMain.MakeHISDBConn: boolean;
var
  newconnstr,ss: string;
  Ini: tinifile;
  userid, password, datasource, initialcatalog: string;{, provider}
  ifIntegrated:boolean;//是否集成登录模式

  pInStr,pDeStr:Pchar;
  i:integer;
  Label labReadIni;
begin
  result:=false;

  labReadIni:
  Ini := tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  datasource := Ini.ReadString('连接HIS数据库', '服务器', '');
  initialcatalog := Ini.ReadString('连接HIS数据库', '数据库', '');
  ifIntegrated:=ini.ReadBool('连接HIS数据库','集成登录模式',false);
  userid := Ini.ReadString('连接HIS数据库', '用户', '');
  password := Ini.ReadString('连接HIS数据库', '口令', '107DFC967CDCFAAF');
  Ini.Free;
  //======解密password
  pInStr:=pchar(password);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(password,length(pDeStr));
  for i :=1  to length(pDeStr) do password[i]:=pDeStr[i-1];
  //==========

  newconnstr :='';
  newconnstr := newconnstr + 'user id=' + UserID + ';';
  newconnstr := newconnstr + 'password=' + Password + ';';
  newconnstr := newconnstr + 'data source=' + datasource + ';';
  newconnstr := newconnstr + 'Initial Catalog=' + initialcatalog + ';';
  newconnstr := newconnstr + 'provider=' + 'SQLOLEDB.1' + ';';
  //Persist Security Info,表示ADO在数据库连接成功后是否保存密码信息
  //ADO缺省为True,ADO.net缺省为False
  //程序中会传ADOConnection信息给TADOLYQuery,故设置为True
  newconnstr := newconnstr + 'Persist Security Info=True;';
  if ifIntegrated then
    newconnstr := newconnstr + 'Integrated Security=SSPI;';
  try
    UniConnection1.Connected := false;
    UniConnection1.ConnectionString := newconnstr;
    UniConnection1.Connected := true;
    result:=true;
  except
  end;
  if not result then
  begin
    ss:='服务器'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '数据库'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '集成登录模式'+#2+'CheckListBox'+#2+#2+'0'+#2+'启用该模式,则用户及口令无需填写'+#2+#3+
        '用户'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '口令'+#2+'Edit'+#2+#2+'0'+#2+#2+'1';
    if ShowOptionForm('连接HIS数据库','连接HIS数据库',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
      goto labReadIni else application.Terminate;
  end;
end;

procedure TfrmMain.VirtualTable1AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;
   
  DBGrid1.Columns[0].Width:=30;//外部系统项目申请编号
  DBGrid1.Columns[1].Width:=77;//HIS项目代码
  DBGrid1.Columns[2].Width:=100;//HIS项目名称
  DBGrid1.Columns[3].Width:=77;//LIS项目代码
  DBGrid1.Columns[4].Width:=100;//LIS项目名称
  DBGrid1.Columns[5].Width:=80;//工作组
  DBGrid1.Columns[6].Width:=57;//样本类型
  DBGrid1.Columns[7].Width:=90;//联机号
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var
  VTTemp:TVirtualTable;
  ini:TIniFile;

  PreWorkGroup:String;//该变量作用:仅保存工作组第一条记录的联机号
begin
  if not VirtualTable1.Active then exit;
  if VirtualTable1.RecordCount<=0 then exit;

  PreWorkGroup:='上一个工作组';//初始化为实际情况不可能出现的工作组名称即可

  LabeledEdit1.Enabled:=false;//为了防止没处理完又扫描下一个条码
  BitBtn1.Enabled:=false;//为了防止没处理完又点击导入//因定义了ShortCut,故不能使用(Sender as TBitBtn)

  VTTemp:=TVirtualTable.Create(nil);
  VTTemp.Assign(VirtualTable1);//clone数据集
  VTTemp.Open;
  while not VTTemp.Eof do
  begin
    SingleRequestForm2Lis(
      VTTemp.fieldbyname('工作组').AsString,
      LabeledEdit11.Text,
      LabeledEdit2.Text,
      LabeledEdit3.Text,
      LabeledEdit4.Text,
      Edit2.Text,
      LabeledEdit5.Text,
      LabeledEdit6.Text,
      LabeledEdit8.Text,
      LabeledEdit7.Text,
      VTTemp.fieldbyname('外部系统项目申请编号').AsString,
      VTTemp.fieldbyname('联机号').AsString,
      VTTemp.fieldbyname('样本类型').AsString,
      VTTemp.fieldbyname('LIS项目代码').AsString,
      '',
      operator_name
    );

    //保存当前联机号
    if (trim(VTTemp.fieldbyname('工作组').AsString)<>'')and(VTTemp.fieldbyname('工作组').AsString<>PreWorkGroup) then
    begin
      PreWorkGroup:=VTTemp.fieldbyname('工作组').AsString;
      ini:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
      ini.WriteString(VTTemp.fieldbyname('工作组').AsString,'检查日期',FormatDateTime('YYYY-MM-DD',Date));
      ini.WriteString(VTTemp.fieldbyname('工作组').AsString,'联机号',VTTemp.fieldbyname('联机号').AsString);
      ini.Free;
    end;
    //==============

    VTTemp.Next;
  end;
  VTTemp.Close;
  VTTemp.Free;

  LabeledEdit1.Enabled:=true;
  if LabeledEdit1.CanFocus then LabeledEdit1.SetFocus; 
  BitBtn1.Enabled:=true;//因定义了ShortCut,故不能使用(Sender as TBitBtn)
end;

procedure TfrmMain.SingleRequestForm2Lis(const WorkGroup, His_Unid, patientname, sex,
  age, age_unit, deptname, check_doctor, RequestDate, ABarcode, Surem1,
  checkid, SampleType, pkcombin_id, His_MzOrZy, PullPress: String);
var
  ObjectYZMZ:ISuperObject;
  ArrayYZMX:ISuperObject;
  ObjectJYYZ:ISuperObject;
  ArrayJYYZ:ISuperObject;
  BigObjectJYYZ:ISuperObject;
begin
  if trim(WorkGroup)='' then exit;
  if trim(pkcombin_id)='' then exit;

  ArrayYZMX:=SA([]);

  ObjectYZMZ:=SO;
  ObjectYZMZ.S['联机号'] := checkid;
  ObjectYZMZ.S['LIS组合项目代码'] := pkcombin_id;
  ObjectYZMZ.S['条码号'] := ABarcode;
  ObjectYZMZ.S['外部系统项目申请编号'] := Surem1;
  ObjectYZMZ.S['样本类型'] := SampleType;

  ArrayYZMX.AsArray.Add(ObjectYZMZ);
  ObjectYZMZ:=nil;

  ObjectJYYZ:=SO;
  ObjectJYYZ.S['患者姓名']:=patientname;
  ObjectJYYZ.S['患者性别']:=sex;
  ObjectJYYZ.S['患者年龄']:=age+age_unit;
  ObjectJYYZ.S['申请科室']:=deptname;
  ObjectJYYZ.S['申请医生']:=check_doctor;
  ObjectJYYZ.S['申请日期']:=RequestDate;
  ObjectJYYZ.S['外部系统唯一编号']:=His_Unid;
  ObjectJYYZ.S['患者类别']:=His_MzOrZy;
  ObjectJYYZ.S['样本接收人']:=PullPress;
  ObjectJYYZ.O['医嘱明细']:=ArrayYZMX;
  ArrayYZMX:=nil;

  ArrayJYYZ:=SA([]);
  ArrayJYYZ.AsArray.Add(ObjectJYYZ);
  ObjectJYYZ:=nil;

  BigObjectJYYZ:=SO;
  BigObjectJYYZ.S['JSON数据源']:='HIS';
  BigObjectJYYZ.O['检验医嘱']:=ArrayJYYZ;
  ArrayJYYZ:=nil;

  RequestForm2Lis(PChar(AnsiString(ADOConnection1.ConnectionString)),UnicodeToChinese(PChar(AnsiString(BigObjectJYYZ.AsJson))),'');
  BigObjectJYYZ:=nil;
end;

procedure TfrmMain.CheckBox1Click(Sender: TObject);
begin
  BitBtn1.Enabled:=not (Sender as TCheckBox).Checked;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  ConfigIni:tinifile;
begin
  ConfigIni:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));

  configini.WriteBool('Interface','ifDirect2LIS',CheckBox1.Checked);{记录是否扫描后直接导入LIS}

  configini.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  configini:tinifile;
begin
  frmLogin.ShowModal;

  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  CheckBox1.Checked:=configini.ReadBool('Interface','ifDirect2LIS',false);{记录是否扫描后直接导入LIS}

  configini.Free;
  
  BitBtn1.Enabled:=not CheckBox1.Checked;
end;

procedure TfrmMain.updatestatusBar(const text: string);
//Text为该格式#$2+'0:abc'+#$2+'1:def'表示状态栏第0格显示abc,第1格显示def,依此类推
var
  i,J2Pos,J2Len,TextLen,j:integer;
  tmpText:string;
begin
  TextLen:=length(text);
  for i :=0 to StatusBar1.Panels.Count-1 do
  begin
    J2Pos:=pos(#$2+inttostr(i)+':',text);
    J2Len:=length(#$2+inttostr(i)+':');
    if J2Pos<>0 then
    begin
      tmpText:=text;
      tmpText:=copy(tmpText,J2Pos+J2Len,TextLen-J2Pos-J2Len+1);
      j:=pos(#$2,tmpText);
      if j<>0 then tmpText:=leftstr(tmpText,j-1);
      StatusBar1.Panels[i].Text:=tmpText;
    end;
  end;
end;

procedure TfrmMain.WMUpdateTextStatus(var message: twmupdatetextstatus);
begin
  UpdateStatusBar(pchar(message.Text));
  message.Result:=-1;
end;

end.
