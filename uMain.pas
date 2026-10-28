unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.ODBC, FireDAC.Phys.ODBCDef; // Units do FireDAC

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    procedure Button2Click(Sender: TObject);
    { Função para gerar o CSV corretamente (lendo tudo, inclusive os Memos .MB) }
   procedure ExportarParaCSV(DataSet: TDataSet; const CaminhoArquivo: string);
   { Função para converter o texto da tabela DOS/Paradox (OEM) para o padrão Windows (ANSI) }
   { Evento genérico para corrigir acentos e forçar a exibição do texto Memo no DBGrid }
   procedure CampoGetText(Sender: TField; var Text: string; DisplayText: Boolean);
   function CorrigeAcentosOEM(const Texto: string): string;
    procedure Button1Click(Sender: TObject);
    function ReverterConversaoODBC(const Texto: string): string;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

function TfrmMain.ReverterConversaoODBC(const Texto: string): string;
var
  AnsiBuf: AnsiString;
begin
  if Texto = '' then Exit('');
  // Transformamos a String do Delphi em formato Ansi
  AnsiBuf := AnsiString(Texto);
  // Executamos a API do Windows que reverte a conversão "ANSI -> OEM"
  CharToOemA(PAnsiChar(AnsiBuf), PAnsiChar(AnsiBuf));
  // Devolvemos o texto já com os acentos reais (á, é, ç, õ, etc.)
  Result := string(AnsiBuf);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  SaveDialog1.Filter := 'Arquivo CSV (*.csv)|*.csv|Arquivo de Texto (*.txt)|*.txt';
  SaveDialog1.DefaultExt := 'csv';
  if SaveDialog1.Execute then
  begin
    ExportarParaCSV(FDQuery1, SaveDialog1.FileName);
  end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  CaminhoPasta, NomeTabela: string;
  I: Integer;
begin
  OpenDialog1.Filter := 'Arquivos Paradox (*.DB)|*.DB';
  if OpenDialog1.Execute then
  begin
    CaminhoPasta := ExtractFilePath(OpenDialog1.FileName);
    NomeTabela := ExtractFileName(OpenDialog1.FileName);
    FDQuery1.Close;
    FDConnection1.Close;
    FDConnection1.Params.Clear;
    FDConnection1.Params.Add('DriverID=ODBC');
    FDConnection1.Params.Add('ODBCDriver=Microsoft Paradox Driver (*.db )');
    FDConnection1.Params.Add('Database=' + CaminhoPasta);
    FDConnection1.LoginPrompt := False;
    try
      FDConnection1.Open;
      FDQuery1.Connection := FDConnection1;
      FDQuery1.SQL.Text := 'SELECT * FROM [' + NomeTabela + ']';
      FDQuery1.Open;
      // 1. Traz todos os registros da memória de uma vez para contar direito (> 1000)
      FDQuery1.FetchAll;
      // 2. Aplica o OnGetText em TODOS os campos de texto ou MEMO para reparar a acentuação e mostrar no Grid
      for I := 0 to FDQuery1.FieldCount - 1 do
      begin
        if (FDQuery1.Fields[I].DataType in [ftString, ftMemo, ftBlob, ftWideString, ftWideMemo]) then
          FDQuery1.Fields[I].OnGetText := CampoGetText;
      end;
      ShowMessage(Format('Tabela carregada com sucesso! %d registros encontrados.', [FDQuery1.RecordCount]));
    except
      on E: Exception do
        ShowMessage('Falha ao abrir a tabela: ' + E.Message);
    end;
  end;
end;

procedure TfrmMain.CampoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  // Sender.AsString lê inclusive campos MEMO. E logo em seguida revertemos o acento
  Text := ReverterConversaoODBC(Sender.AsString);
end;

function TfrmMain.CorrigeAcentosOEM(const Texto: string): string;
var
  AnsiBuf: AnsiString;
begin
  if Texto = '' then Exit('');
  AnsiBuf := AnsiString(Texto);
  OemToCharA(PAnsiChar(AnsiBuf), PAnsiChar(AnsiBuf)); // Converte diretamente no buffer de memória
  Result := string(AnsiBuf);
end;

procedure TfrmMain.ExportarParaCSV(DataSet: TDataSet;
  const CaminhoArquivo: string);
var
  Linhas: TStringList;
  Linha: string;
  I: Integer;
  ValorCampo: string;
begin
  if not DataSet.Active or DataSet.IsEmpty then
  begin
    ShowMessage('A tabela está vazia ou não foi carregada!');
    Exit;
  end;
  Linhas := TStringList.Create;
  try
    DataSet.DisableControls;
    try
      // 1. Gera o cabeçalho (Nomes das colunas)
      Linha := '';
      for I := 0 to DataSet.FieldCount - 1 do
      begin
        if I > 0 then Linha := Linha + ';';
        Linha := Linha + '"' + DataSet.Fields[I].FieldName + '"';
      end;
      Linhas.Add(Linha);
      // 2. Exporta os registros
      DataSet.First;
      while not DataSet.Eof do
      begin
        Linha := '';
        for I := 0 to DataSet.FieldCount - 1 do
        begin
          if I > 0 then Linha := Linha + ';';
          // Usamos o .DisplayText para forçar a passagem pelo Evento CampoGetText que arruma os acentos
          ValorCampo := DataSet.Fields[I].DisplayText;
          // Substitui quebras de linha e aspas para que o Excel abra as colunas perfeitamente
          ValorCampo := StringReplace(ValorCampo, '"', '""', [rfReplaceAll]);
          ValorCampo := StringReplace(ValorCampo, #13#10, ' ', [rfReplaceAll]);
          ValorCampo := StringReplace(ValorCampo, #10, ' ', [rfReplaceAll]);
          Linha := Linha + '"' + ValorCampo + '"';
        end;
        Linhas.Add(Linha);
        DataSet.Next;
      end;
      // 3. Salva em disco em UTF-8 com BOM, para que o Excel leia os acentos brasileiros nativamente sem precisar ir na aba "Obter Dados"
      Linhas.SaveToFile(CaminhoArquivo, TEncoding.UTF8);
      ShowMessage(Format('Exportação de %d linhas concluída com sucesso!', [Linhas.Count - 1]));
    finally
      DataSet.EnableControls;
    end;
  finally
    Linhas.Free;
  end;
end;

end.
