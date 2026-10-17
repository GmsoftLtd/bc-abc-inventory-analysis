namespace GMSoft.ABCInventoryAnalysis;

using System.IO;

codeunit 73033675 "GSO ABC Worksheet Export"
{
    var
        BookNameLbl: Label 'ABC Preview';
        PreviewSheetLbl: Label 'Preview';
        StatsSheetLbl: Label 'Statistics';
        ItemNoLbl: Label 'Item No.';
        DescriptionLbl: Label 'Description';
        ModelLbl: Label 'Model';
        ValueLbl: Label 'Value';
        ValuePctLbl: Label 'Value %';
        CumPctLbl: Label 'Cum. %';
        ClassLbl: Label 'Class';
        ItemCountLbl: Label 'Item Count';
        CountPctLbl: Label 'Count %';
        AmountLbl: Label 'Amount';
        AmountPctLbl: Label 'Amount %';
        CumCountPctLbl: Label 'Cum. Count %';
        CumAmountPctLbl: Label 'Cum. Amount %';

    procedure ExportPreviewAndStats(var TempPreview: Record "GSO ABC Preview Line" temporary; var TempStats: Record "GSO ABC Stats" temporary)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
    begin
        WritePreviewSheet(TempExcelBuffer, TempPreview);
        TempExcelBuffer.CreateNewBook(PreviewSheetLbl);
        TempExcelBuffer.WriteSheet(PreviewSheetLbl, CompanyName(), UserId());

        TempExcelBuffer.DeleteAll();
        WriteStatsSheet(TempExcelBuffer, TempStats);
        TempExcelBuffer.SelectOrAddSheet(StatsSheetLbl);
        TempExcelBuffer.WriteSheet(StatsSheetLbl, CompanyName(), UserId());

        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(BookNameLbl);
        TempExcelBuffer.OpenExcel();
    end;

    local procedure WritePreviewSheet(var TempExcelBuffer: Record "Excel Buffer" temporary; var TempPreview: Record "GSO ABC Preview Line" temporary)
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(ItemNoLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DescriptionLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ModelLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ValueLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ValuePctLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CumPctLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ClassLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        TempPreview.Reset();
        if TempPreview.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(TempPreview."Item No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(TempPreview.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Format(TempPreview.Model), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(TempPreview.Value, false, '', false, false, false, '#,##0.00', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(TempPreview."Value %", false, '', false, false, false, '0.00000', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(TempPreview."Cum. %", false, '', false, false, false, '0.00000', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(Format(TempPreview.Class), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until TempPreview.Next() = 0;
    end;

    local procedure WriteStatsSheet(var TempExcelBuffer: Record "Excel Buffer" temporary; var TempStats: Record "GSO ABC Stats" temporary)
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(ClassLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ItemCountLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CountPctLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AmountLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AmountPctLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CumCountPctLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CumAmountPctLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        TempStats.Reset();
        if TempStats.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(Format(TempStats.Class), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(TempStats."Item Count", false, '', false, false, false, '0', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(TempStats."Count %", false, '', false, false, false, '0.00000', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(TempStats.Amount, false, '', false, false, false, '#,##0.00', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(TempStats."Amount %", false, '', false, false, false, '0.00000', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(TempStats."Cum. Count %", false, '', false, false, false, '0.00000', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(TempStats."Cum. Amount %", false, '', false, false, false, '0.00000', TempExcelBuffer."Cell Type"::Number);
            until TempStats.Next() = 0;
    end;
}
