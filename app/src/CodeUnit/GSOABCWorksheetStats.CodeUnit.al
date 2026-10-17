namespace GMSoft.ABCInventoryAnalysis;

codeunit 73033676 "GSO ABC Worksheet Stats"
{
    procedure BuildStats(var TempPreview: Record "GSO ABC Preview Line" temporary; var TempStats: Record "GSO ABC Stats" temporary)
    var
        Amount: array[4] of Decimal;
        Count: array[4] of Integer;
        TotAmount: Decimal;
        TotCount: Integer;
        CumAmtPct: Decimal;
        CumCntPct: Decimal;
        LineNo: Integer;
        Idx: Integer;
    begin
        TempStats.Reset();
        TempStats.DeleteAll();

        TempPreview.Reset();
        if TempPreview.FindSet() then
            repeat
                Idx := ClassIndex(TempPreview.Class);
                Count[Idx] += 1;
                Amount[Idx] += TempPreview.Value;
                TotCount += 1;
                TotAmount += TempPreview.Value;
            until TempPreview.Next() = 0;

        AddLine(TempStats, LineNo, Enum::"GSO ABC Class"::A, Count[1], Amount[1], TotCount, TotAmount, CumCntPct, CumAmtPct);
        AddLine(TempStats, LineNo, Enum::"GSO ABC Class"::B, Count[2], Amount[2], TotCount, TotAmount, CumCntPct, CumAmtPct);
        AddLine(TempStats, LineNo, Enum::"GSO ABC Class"::C, Count[3], Amount[3], TotCount, TotAmount, CumCntPct, CumAmtPct);
        if Count[4] > 0 then
            AddLine(TempStats, LineNo, Enum::"GSO ABC Class"::D, Count[4], Amount[4], TotCount, TotAmount, CumCntPct, CumAmtPct);
    end;

    local procedure ClassIndex(Class: Enum "GSO ABC Class"): Integer
    begin
        case Class of
            Class::A:
                exit(1);
            Class::B:
                exit(2);
            Class::D:
                exit(4);
            else
                exit(3);
        end;
    end;

    local procedure AddLine(var TempStats: Record "GSO ABC Stats" temporary; var LineNo: Integer; Class: Enum "GSO ABC Class"; Cnt: Integer; Amt: Decimal; TotCnt: Integer; TotAmt: Decimal; var CumCntPct: Decimal; var CumAmtPct: Decimal)
    var
        AmtPct: Decimal;
        CntPct: Decimal;
    begin
        LineNo += 1;
        if TotCnt > 0 then
            CntPct := Round(Cnt / TotCnt * 100, 0.00001);
        if TotAmt > 0 then
            AmtPct := Round(Amt / TotAmt * 100, 0.00001);
        CumCntPct := Round(CumCntPct + CntPct, 0.00001);
        CumAmtPct := Round(CumAmtPct + AmtPct, 0.00001);

        TempStats.Init();
        TempStats."Line No." := LineNo;
        TempStats.Class := Class;
        TempStats."Item Count" := Cnt;
        TempStats."Count %" := CntPct;
        TempStats.Amount := Round(Amt, 0.01);
        TempStats."Amount %" := AmtPct;
        TempStats."Cum. Count %" := CumCntPct;
        TempStats."Cum. Amount %" := CumAmtPct;
        TempStats.Insert();
    end;
}
