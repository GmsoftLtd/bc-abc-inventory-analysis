codeunit 73030643 "GMO Worksheet Stats"
{
    
    procedure BuildStats(var TempPreview: Record "GMO ABC Preview Line" temporary; var TempStats: Record "GMO ABC Stats" temporary)
    var ACount,BCount,CCount,TotCount: Integer; AAmount,BAmount,CAmount,TotAmount: Decimal; LineNo: Integer; CumCntPct, CumAmtPct: Decimal;
    begin
        TempStats.DeleteAll();
        TempPreview.Reset();
        if TempPreview.FindSet() then
            repeat
                case TempPreview.Class of
                    TempPreview.Class::A: begin ACount += 1; AAmount += TempPreview.Value; end;
                    TempPreview.Class::B: begin BCount += 1; BAmount += TempPreview.Value; end;
                    else                 begin CCount += 1; CAmount += TempPreview.Value; end;
                end;
                TotCount += 1; TotAmount += TempPreview.Value;
            until TempPreview.Next() = 0;

        AddLine(TempStats, LineNo, TempPreview.Class::A, ACount, AAmount, TotCount, TotAmount, CumCntPct, CumAmtPct);
        AddLine(TempStats, LineNo, TempPreview.Class::B, BCount, BAmount, TotCount, TotAmount, CumCntPct, CumAmtPct);
        AddLine(TempStats, LineNo, TempPreview.Class::C, CCount, CAmount, TotCount, TotAmount, CumCntPct, CumAmtPct);
    end;

    local procedure AddLine(var TempStats: Record "GMO ABC Stats" temporary; var LineNo: Integer; C: Enum "GMO Class"; Cnt: Integer; Amt: Decimal; TotCnt: Integer; TotAmt: Decimal; var CumCntPct: Decimal; var CumAmtPct: Decimal)
    var CntPct, AmtPct: Decimal;
    begin
        LineNo += 1;
        if TotCnt > 0 then CntPct := Round(Cnt / TotCnt * 100, 0.00001);
        if TotAmt > 0 then AmtPct := Round(AmountSafe(Amt) / TotAmt * 100, 0.00001);
        CumCntPct := Round(CumCntPct + CntPct, 0.00001);
        CumAmtPct := Round(CumAmtPct + AmtPct, 0.00001);

        TempStats.Init();
        TempStats."Line No." := LineNo;
        TempStats.Class := C;
        TempStats."Item Count" := Cnt;
        TempStats."Count %" := CntPct;
        TempStats.Amount := Round(AmountSafe(Amt), 0.01);
        TempStats."Amount %" := AmtPct;
        TempStats."Cum. Count %" := CumCntPct;
        TempStats."Cum. Amount %" := CumAmtPct;
        TempStats.Insert();
    end;

    local procedure AmountSafe(v: Decimal): Decimal
    begin
        if v < 0 then exit(0); exit(v);
    end;
}