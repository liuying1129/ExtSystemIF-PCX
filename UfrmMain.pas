unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, Grids, DBGrids,
  Buttons, ADODB,IniFiles,StrUtils, VirtualTable,
  ActnList, DosMove, ComCtrls, MemDS;

//==Ϊ��ͨ��������Ϣ����������״̬��������==//
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
    //==Ϊ��ͨ��������Ϣ����������״̬��������==//
    procedure WMUpdateTextStatus(var message:twmupdatetextstatus);  {WM_UPDATETEXTSTATUS��Ϣ������}
                                              message WM_UPDATETEXTSTATUS;
    procedure updatestatusBar(const text:string);//TextΪ�ø�ʽ#$2+'0:abc'+#$2+'1:def'��ʾ״̬����0����ʾabc,��1����ʾdef,��������
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
function DeCryptStr(aStr: Pchar; aKey: Pchar): Pchar;stdcall;external 'LYFunction.dll';//����
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

  PreWorkGroup:String;//�ñ�������:�����湤�����һ����¼��������

  PreDate,PreCheckID:String;
begin
  if key<>13 then exit;

  if trim((Sender as TLabeledEdit).Text)='' then exit;

  PreWorkGroup:='��һ��������';//��ʼ��Ϊʵ����������ܳ��ֵĹ��������Ƽ���

  (Sender as TLabeledEdit).Enabled:=false;//Ϊ�˷�ֹû��������ɨ����һ������

  UniQryTemp22:=TADOQuery.Create(nil);
  UniQryTemp22.Connection:=UniConnection1;
  UniQryTemp22.Close;
  UniQryTemp22.SQL.Clear;
  UniQryTemp22.SQL.Text:='select * from v_HIS_Lis_pat where ����=:barcode';
  UniQryTemp22.Parameters.ParamByName('barcode').Value:=(Sender as TLabeledEdit).Text;
  UniQryTemp22.Open;

  (Sender as TLabeledEdit).Clear;

  LabeledEdit2.Text:=UniQryTemp22.fieldbyname('��������').AsString;
  LabeledEdit3.Text:=UniQryTemp22.fieldbyname('�����Ա�').AsString;
  LabeledEdit4.Text:=UniQryTemp22.fieldbyname('��������').AsString;
  Edit2.Text:=UniQryTemp22.fieldbyname('�������䵥λ').AsString;
  LabeledEdit5.Text:=UniQryTemp22.fieldbyname('��������').AsString;
  LabeledEdit6.Text:=UniQryTemp22.fieldbyname('����ҽ��').AsString;
  LabeledEdit7.Text:=UniQryTemp22.fieldbyname('����').AsString;
  LabeledEdit8.Text:=FormatDateTime('yyyy-mm-dd hh:nn:ss',UniQryTemp22.fieldbyname('����ʱ��').AsDateTime);
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
    ADOTemp22.Parameters.ParamByName('HisItem').Value:=UniQryTemp22.fieldbyname('���������Ŀ����').AsString;
    ADOTemp22.Open;

    //LIS��û�����Ӧ����Ŀ
    if ADOTemp22.RecordCount<=0 then Memo1.Lines.Add(UniQryTemp22.fieldbyname('���������Ŀ����').AsString+'��'+UniQryTemp22.fieldbyname('HIS���������Ŀ����').AsString+'����LIS��û�ж���'); 

    while not ADOTemp22.Eof do
    begin
      //�繤����Ϊ��,ini.ReadString����ntdll.dll,�Ҳ���������Ա�Ҳ���������Ϣ������
      if trim(ADOTemp22.FieldByName('dept_DfValue').AsString)='' then
      begin
        Memo1.Lines.Add(ADOTemp22.FieldByName('Id').AsString+'��'+ADOTemp22.FieldByName('Name').AsString+'��δ����Ĭ�Ϲ�����');
        ADOTemp22.Next;
        continue;
      end;

      ini:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
      PreDate:=ini.ReadString(ADOTemp22.FieldByName('dept_DfValue').AsString,'�������','');
      PreCheckID:=ini.ReadString(ADOTemp22.FieldByName('dept_DfValue').AsString,'������','');
      ini.Free;

      VirtualTable1.Append;
      VirtualTable1.FieldByName('�ⲿϵͳ��Ŀ������').AsString:='';//UniQryTemp22.FieldByName('REQUEST_NO').AsString;
      VirtualTable1.FieldByName('HIS��Ŀ����').AsString:=UniQryTemp22.FieldByName('���������Ŀ����').AsString;
      VirtualTable1.FieldByName('HIS��Ŀ����').AsString:=UniQryTemp22.FieldByName('HIS���������Ŀ����').AsString;
      VirtualTable1.FieldByName('LIS��Ŀ����').AsString:=ADOTemp22.FieldByName('Id').AsString;
      VirtualTable1.FieldByName('LIS��Ŀ����').AsString:=ADOTemp22.FieldByName('Name').AsString;
      VirtualTable1.FieldByName('������').AsString:=ADOTemp22.FieldByName('dept_DfValue').AsString;
      VirtualTable1.FieldByName('��������').AsString:=UniQryTemp22.FieldByName('��������').AsString;
      VirtualTable1.FieldByName('������').AsString:=GetMaxCheckId(PChar(ADOTemp22.FieldByName('dept_DfValue').AsString),PChar(PreDate),PChar(PreCheckID));
      VirtualTable1.Post;

      ADOTemp22.Next;
    end;
    ADOTemp22.Free;

    UniQryTemp22.Next;
  end;
  UniQryTemp22.Free;

  for i:=0 to (DBGrid1.columns.count-2) do DBGrid1.columns[i].readonly:=True;//���������1��(������)�ɱ༭

  if CheckBox1.Checked then
  begin
    VTTemp:=TVirtualTable.Create(nil);
    VTTemp.Assign(VirtualTable1);//clone���ݼ�
    VTTemp.Open;
    while not VTTemp.Eof do
    begin
      SingleRequestForm2Lis(
        VTTemp.fieldbyname('������').AsString,
        LabeledEdit11.Text,
        LabeledEdit2.Text,
        LabeledEdit3.Text,
        LabeledEdit4.Text,
        Edit2.Text,
        LabeledEdit5.Text,
        LabeledEdit6.Text,
        LabeledEdit8.Text,
        LabeledEdit7.Text,
        VTTemp.fieldbyname('�ⲿϵͳ��Ŀ������').AsString,
        VTTemp.fieldbyname('������').AsString,
        VTTemp.fieldbyname('��������').AsString,
        VTTemp.fieldbyname('LIS��Ŀ����').AsString,
        '',
        operator_name
      );

      //���浱ǰ������
      if (trim(VTTemp.fieldbyname('������').AsString)<>'')and(VTTemp.fieldbyname('������').AsString<>PreWorkGroup) then
      begin
        PreWorkGroup:=VTTemp.fieldbyname('������').AsString;
        ini:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
        ini.WriteString(VTTemp.fieldbyname('������').AsString,'�������',FormatDateTime('YYYY-MM-DD',Date));
        ini.WriteString(VTTemp.fieldbyname('������').AsString,'������',VTTemp.fieldbyname('������').AsString);
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

  //���������VirtualTable�ֶ�
  VirtualTable1.IndexFieldNames:='������,��������';//�������顢������������
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
  ifIntegrated:boolean;//�Ƿ񼯳ɵ�¼ģʽ

  pInStr,pDeStr:Pchar;
  i:integer;
  Label labReadIni;
begin
  result:=false;

  labReadIni:
  Ini := tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  datasource := Ini.ReadString('����LIS���ݿ�', '������', '');
  initialcatalog := Ini.ReadString('����LIS���ݿ�', '���ݿ�', '');
  ifIntegrated:=ini.ReadBool('����LIS���ݿ�','���ɵ�¼ģʽ',false);
  userid := Ini.ReadString('����LIS���ݿ�', '�û�', '');
  password := Ini.ReadString('����LIS���ݿ�', '����', '107DFC967CDCFAAF');
  Ini.Free;
  //======����password
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
  //Persist Security Info,��ʾADO�����ݿ����ӳɹ����Ƿ񱣴�������Ϣ
  //ADOȱʡΪTrue,ADO.netȱʡΪFalse
  //�����лᴫADOConnection��Ϣ��TADOLYQuery,������ΪTrue
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
    ss:='������'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '���ݿ�'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '���ɵ�¼ģʽ'+#2+'CheckListBox'+#2+#2+'0'+#2+'���ø�ģʽ,���û�������������д'+#2+#3+
        '�û�'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '����'+#2+'Edit'+#2+#2+'0'+#2+#2+'1';
    if ShowOptionForm('����LIS���ݿ�','����LIS���ݿ�',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
      goto labReadIni else application.Terminate;
  end;
end;

function TfrmMain.MakeHISDBConn: boolean;
var
  newconnstr,ss: string;
  Ini: tinifile;
  userid, password, datasource, initialcatalog: string;{, provider}
  ifIntegrated:boolean;//�Ƿ񼯳ɵ�¼ģʽ

  pInStr,pDeStr:Pchar;
  i:integer;
  Label labReadIni;
begin
  result:=false;

  labReadIni:
  Ini := tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  datasource := Ini.ReadString('����HIS���ݿ�', '������', '');
  initialcatalog := Ini.ReadString('����HIS���ݿ�', '���ݿ�', '');
  ifIntegrated:=ini.ReadBool('����HIS���ݿ�','���ɵ�¼ģʽ',false);
  userid := Ini.ReadString('����HIS���ݿ�', '�û�', '');
  password := Ini.ReadString('����HIS���ݿ�', '����', '107DFC967CDCFAAF');
  Ini.Free;
  //======����password
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
  //Persist Security Info,��ʾADO�����ݿ����ӳɹ����Ƿ񱣴�������Ϣ
  //ADOȱʡΪTrue,ADO.netȱʡΪFalse
  //�����лᴫADOConnection��Ϣ��TADOLYQuery,������ΪTrue
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
    ss:='������'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '���ݿ�'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '���ɵ�¼ģʽ'+#2+'CheckListBox'+#2+#2+'0'+#2+'���ø�ģʽ,���û�������������д'+#2+#3+
        '�û�'+#2+'Edit'+#2+#2+'0'+#2+#2+#3+
        '����'+#2+'Edit'+#2+#2+'0'+#2+#2+'1';
    if ShowOptionForm('����HIS���ݿ�','����HIS���ݿ�',Pchar(ss),Pchar(ChangeFileExt(Application.ExeName,'.ini'))) then
      goto labReadIni else application.Terminate;
  end;
end;

procedure TfrmMain.VirtualTable1AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;
   
  DBGrid1.Columns[0].Width:=30;//�ⲿϵͳ��Ŀ������
  DBGrid1.Columns[1].Width:=77;//HIS��Ŀ����
  DBGrid1.Columns[2].Width:=100;//HIS��Ŀ����
  DBGrid1.Columns[3].Width:=77;//LIS��Ŀ����
  DBGrid1.Columns[4].Width:=100;//LIS��Ŀ����
  DBGrid1.Columns[5].Width:=80;//������
  DBGrid1.Columns[6].Width:=57;//��������
  DBGrid1.Columns[7].Width:=90;//������
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var
  VTTemp:TVirtualTable;
  ini:TIniFile;

  PreWorkGroup:String;//�ñ�������:�����湤�����һ����¼��������
begin
  if not VirtualTable1.Active then exit;
  if VirtualTable1.RecordCount<=0 then exit;

  PreWorkGroup:='��һ��������';//��ʼ��Ϊʵ����������ܳ��ֵĹ��������Ƽ���

  LabeledEdit1.Enabled:=false;//Ϊ�˷�ֹû��������ɨ����һ������
  BitBtn1.Enabled:=false;//Ϊ�˷�ֹû�������ֵ������//������ShortCut,�ʲ���ʹ��(Sender as TBitBtn)

  VTTemp:=TVirtualTable.Create(nil);
  VTTemp.Assign(VirtualTable1);//clone���ݼ�
  VTTemp.Open;
  while not VTTemp.Eof do
  begin
    SingleRequestForm2Lis(
      VTTemp.fieldbyname('������').AsString,
      LabeledEdit11.Text,
      LabeledEdit2.Text,
      LabeledEdit3.Text,
      LabeledEdit4.Text,
      Edit2.Text,
      LabeledEdit5.Text,
      LabeledEdit6.Text,
      LabeledEdit8.Text,
      LabeledEdit7.Text,
      VTTemp.fieldbyname('�ⲿϵͳ��Ŀ������').AsString,
      VTTemp.fieldbyname('������').AsString,
      VTTemp.fieldbyname('��������').AsString,
      VTTemp.fieldbyname('LIS��Ŀ����').AsString,
      '',
      operator_name
    );

    //���浱ǰ������
    if (trim(VTTemp.fieldbyname('������').AsString)<>'')and(VTTemp.fieldbyname('������').AsString<>PreWorkGroup) then
    begin
      PreWorkGroup:=VTTemp.fieldbyname('������').AsString;
      ini:=tinifile.Create(ChangeFileExt(Application.ExeName,'.ini'));
      ini.WriteString(VTTemp.fieldbyname('������').AsString,'�������',FormatDateTime('YYYY-MM-DD',Date));
      ini.WriteString(VTTemp.fieldbyname('������').AsString,'������',VTTemp.fieldbyname('������').AsString);
      ini.Free;
    end;
    //==============

    VTTemp.Next;
  end;
  VTTemp.Close;
  VTTemp.Free;

  LabeledEdit1.Enabled:=true;
  if LabeledEdit1.CanFocus then LabeledEdit1.SetFocus; 
  BitBtn1.Enabled:=true;//������ShortCut,�ʲ���ʹ��(Sender as TBitBtn)
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
  ObjectYZMZ.S['������'] := checkid;
  ObjectYZMZ.S['LIS�����Ŀ����'] := pkcombin_id;
  ObjectYZMZ.S['�����'] := ABarcode;
  ObjectYZMZ.S['�ⲿϵͳ��Ŀ������'] := Surem1;
  ObjectYZMZ.S['��������'] := SampleType;

  ArrayYZMX.AsArray.Add(ObjectYZMZ);
  ObjectYZMZ:=nil;

  ObjectJYYZ:=SO;
  ObjectJYYZ.S['��������']:=patientname;
  ObjectJYYZ.S['�����Ա�']:=sex;
  ObjectJYYZ.S['��������']:=age+age_unit;
  ObjectJYYZ.S['�������']:=deptname;
  ObjectJYYZ.S['����ҽ��']:=check_doctor;
  ObjectJYYZ.S['��������']:=RequestDate;
  ObjectJYYZ.S['�ⲿϵͳΨһ���']:=His_Unid;
  ObjectJYYZ.S['�������']:=His_MzOrZy;
  ObjectJYYZ.S['����������']:=PullPress;
  ObjectJYYZ.O['ҽ����ϸ']:=ArrayYZMX;
  ArrayYZMX:=nil;

  ArrayJYYZ:=SA([]);
  ArrayJYYZ.AsArray.Add(ObjectJYYZ);
  ObjectJYYZ:=nil;

  BigObjectJYYZ:=SO;
  BigObjectJYYZ.S['JSON����Դ']:='HIS';
  BigObjectJYYZ.O['����ҽ��']:=ArrayJYYZ;
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

  configini.WriteBool('Interface','ifDirect2LIS',CheckBox1.Checked);{��¼�Ƿ�ɨ���ֱ�ӵ���LIS}

  configini.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  configini:tinifile;
begin
  frmLogin.ShowModal;

  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  CheckBox1.Checked:=configini.ReadBool('Interface','ifDirect2LIS',false);{��¼�Ƿ�ɨ���ֱ�ӵ���LIS}

  configini.Free;
  
  BitBtn1.Enabled:=not CheckBox1.Checked;
end;

procedure TfrmMain.updatestatusBar(const text: string);
//TextΪ�ø�ʽ#$2+'0:abc'+#$2+'1:def'��ʾ״̬����0����ʾabc,��1����ʾdef,��������
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
