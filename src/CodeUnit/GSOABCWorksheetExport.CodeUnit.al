codeunit 73030583 "GSO ABC Worksheet Export"
{
    procedure ExportPreviewAndStats(var TempPreview: Record "GSO ABC Preview Line" temporary; var TempStats: Record "GSO ABC Stats" temporary)
    var
        ExcelBuf: Record "Excel Buffer";
    begin
        ExcelBuf.DeleteAll();

        WritePreviewSheet(ExcelBuf, TempPreview);
        WriteStatsSheet(ExcelBuf, TempStats);

        ExcelBuf.CreateNewBook('GSO ABC Preview');
        ExcelBuf.WriteSheet('Preview', CompanyName, UserId);
        ExcelBuf.WriteSheet('Statistics', CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
    end;

    local procedure WritePreviewSheet(var ExcelBuf: Record "Excel Buffer"; var TempPreview: Record "GSO ABC Preview Line" temporary)
    var
        // Fallback for environments without Enum "Excel Buffer Cell Type"
        CellType: Option "Text","Number","Date","Time","DateTime","Boolean";
    begin
        // Header
        ExcelBuf.AddColumn('Item No.', false, '', true, false, false, '', CellType::Text);
        ExcelBuf.AddColumn('Description', false, '', true, false, false, '', CellType::Text);
        ExcelBuf.AddColumn('Model', false, '', true, false, false, '', CellType::Text);
        ExcelBuf.AddColumn('Value', false, '', true, false, false, '0.00', CellType::Number);
        ExcelBuf.AddColumn('Value %', false, '', true, false, false, '0.00000', CellType::Number);
        ExcelBuf.AddColumn('Cum. %', false, '', true, false, false, '0.00000', CellType::Number);
        ExcelBuf.AddColumn('Class', false, '', true, false, false, '', CellType::Text);
        ExcelBuf.NewRow();

        // Data
        TempPreview.Reset();
        if TempPreview.FindSet() then
            repeat
                ExcelBuf.AddColumn(TempPreview."Item No.", false, '', false, false, false, '', CellType::Text);
                ExcelBuf.AddColumn(TempPreview.Description, false, '', false, false, false, '', CellType::Text);
                ExcelBuf.AddColumn(Format(TempPreview.Model), false, '', false, false, false, '', CellType::Text);
                ExcelBuf.AddColumn(TempPreview.Value, false, '', false, false, false, '0.00', CellType::Number);
                ExcelBuf.AddColumn(TempPreview."Value %", false, '', false, false, false, '0.00000', CellType::Number);
                ExcelBuf.AddColumn(TempPreview."Cum. %", false, '', false, false, false, '0.00000', CellType::Number);
                ExcelBuf.AddColumn(Format(TempPreview.Class), false, '', false, false, false, '', CellType::Text);
                ExcelBuf.NewRow();
            until TempPreview.Next() = 0;
    end;

    local procedure WriteStatsSheet(var ExcelBuf: Record "Excel Buffer"; var TempStats: Record "GSO ABC Stats" temporary)
    var
        CellType: Option "Text","Number","Date","Time","DateTime","Boolean";
    begin
        // Header
        ExcelBuf.AddColumn('Class', false, '', true, false, false, '', CellType::Text);
        ExcelBuf.AddColumn('Item Count', false, '', true, false, false, '0', CellType::Number);
        ExcelBuf.AddColumn('Count %', false, '', true, false, false, '0.00000', CellType::Number);
        ExcelBuf.AddColumn('Amount', false, '', true, false, false, '0.00', CellType::Number);
        ExcelBuf.AddColumn('Amount %', false, '', true, false, false, '0.00000', CellType::Number);
        ExcelBuf.AddColumn('Cum. Count %', false, '', true, false, false, '0.00000', CellType::Number);
        ExcelBuf.AddColumn('Cum. Amount %', false, '', true, false, false, '0.00000', CellType::Number);
        ExcelBuf.NewRow();

        // Data
        TempStats.Reset();
        if TempStats.FindSet() then
            repeat
                ExcelBuf.AddColumn(Format(TempStats.Class), false, '', false, false, false, '', CellType::Text);
                ExcelBuf.AddColumn(TempStats."Item Count", false, '', false, false, false, '0', CellType::Number);
                ExcelBuf.AddColumn(TempStats."Count %", false, '', false, false, false, '0.00000', CellType::Number);
                ExcelBuf.AddColumn(TempStats.Amount, false, '', false, false, false, '0.00', CellType::Number);
                ExcelBuf.AddColumn(TempStats."Amount %", false, '', false, false, false, '0.00000', CellType::Number);
                ExcelBuf.AddColumn(TempStats."Cum. Count %", false, '', false, false, false, '0.00000', CellType::Number);
                ExcelBuf.AddColumn(TempStats."Cum. Amount %", false, '', false, false, false, '0.00000', CellType::Number);
                ExcelBuf.NewRow();
            until TempStats.Next() = 0;
    end;
}