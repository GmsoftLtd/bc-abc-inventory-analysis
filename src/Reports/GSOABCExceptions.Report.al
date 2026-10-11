report 73033673 "GSO ABC Exceptions"
{
    Caption = 'ABC Exception Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSOABCExceptions.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code";

            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(RunDate; Format(CurrentDateTime(), 0, '<Standard Format,9>')) { }
            column(RunByUser; UserId()) { }
            column(ItemNo; "No.") { }
            column(Description; Description) { }
            column(ExceptionType; ExceptionType) { }
            column(ExceptionDetails; ExceptionDetails) { }
            column(RevenueClass; Format("GSO Class (Revenue)")) { }
            column(GPClass; Format("GSO Class (Gross Profit)")) { }
            column(COGSClass; Format("GSO Class (COGS)")) { }
            column(UsageValueClass; Format("GSO Class (Usage Value)")) { }
            column(LastCalcRev; Format("GSO Last Calc (Revenue)")) { }

            trigger OnAfterGetRecord()
            begin
                ExceptionType := '';
                ExceptionDetails := '';

                case true of
                    IsNeverCalculated(Item):
                        begin
                            ExceptionType := NeverCalculatedLbl;
                            ExceptionDetails := NeverCalculatedDetailsLbl;
                        end;
                    IsOutdated(Item):
                        begin
                            ExceptionType := OutdatedLbl;
                            ExceptionDetails := CopyStr(StrSubstNo(OutdatedDetailsLbl, DaysThreshold), 1, MaxStrLen(ExceptionDetails));
                        end;
                    HasInconsistentClasses(Item):
                        begin
                            ExceptionType := InconsistentLbl;
                            ExceptionDetails := InconsistentDetailsLbl;
                        end;
                    IsHighInventoryLowClass(Item):
                        begin
                            ExceptionType := InventoryMismatchLbl;
                            ExceptionDetails := CopyStr(StrSubstNo(InventoryMismatchDetailsLbl, InventoryThreshold), 1, MaxStrLen(ExceptionDetails));
                        end;
                    HasZeroActivity(Item):
                        begin
                            ExceptionType := NoActivityLbl;
                            ExceptionDetails := NoActivityDetailsLbl;
                        end;
                    else
                        CurrReport.Skip();
                end;
            end;

            trigger OnPreDataItem()
            var
                Mgt: Codeunit "GSO ABC Analysis Mgt.";
            begin
                Mgt.GetDefaultDates(Enum::"GSO ABC Model"::Revenue, ActivityStartDate, ActivityEndDate);
            end;
        }
    }

    requestpage
    {
        ContextSensitiveHelpPage = 'reports';
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DaysThresholdField; DaysThreshold)
                    {
                        ApplicationArea = All;
                        Caption = 'Outdated Threshold (Days)';
                        ToolTip = 'Specifies after how many days a classification counts as outdated. Default: 90.';
                    }
                    field(InventoryThresholdField; InventoryThreshold)
                    {
                        ApplicationArea = All;
                        Caption = 'Inventory Value Threshold';
                        ToolTip = 'Specifies the inventory value above which a class C item is flagged. Default: 10,000.';
                    }
                }
                group(Note)
                {
                    Caption = 'Note';
                    InstructionalText = 'Lists items that were never classified, have an outdated classification, differ between models, carry high inventory with class C, or had no activity in the Revenue analysis period.';
                }
            }
        }
    }

    var
        DaysThreshold: Integer;
        InventoryThreshold: Decimal;
        ActivityStartDate: Date;
        ActivityEndDate: Date;
        ExceptionType: Text[50];
        ExceptionDetails: Text[250];
        ReportTitleLbl: Label 'ABC Exception Report';
        NeverCalculatedLbl: Label 'Never Calculated', MaxLength = 50;
        NeverCalculatedDetailsLbl: Label 'The item has never been classified.', MaxLength = 250;
        OutdatedLbl: Label 'Outdated', MaxLength = 50;
        OutdatedDetailsLbl: Label 'The last classification is more than %1 days old.', Comment = '%1 = number of days';
        InconsistentLbl: Label 'Inconsistent', MaxLength = 50;
        InconsistentDetailsLbl: Label 'The classes differ by more than one step between models.', MaxLength = 250;
        InventoryMismatchLbl: Label 'Inventory Mismatch', MaxLength = 50;
        InventoryMismatchDetailsLbl: Label 'Inventory value above %1 but Revenue class C.', Comment = '%1 = inventory value threshold';
        NoActivityLbl: Label 'No Activity', MaxLength = 50;
        NoActivityDetailsLbl: Label 'No value entries in the Revenue analysis period.', MaxLength = 250;
        DateFormulaTok: Label '<-%1D>', Locked = true;

    trigger OnPreReport()
    begin
        if DaysThreshold = 0 then
            DaysThreshold := 90;
        if InventoryThreshold = 0 then
            InventoryThreshold := 10000;
    end;

    local procedure IsNeverCalculated(ItemRec: Record Item): Boolean
    begin
        exit(GetLatestCalc(ItemRec) = 0DT);
    end;

    local procedure GetLatestCalc(ItemRec: Record Item) LatestCalc: DateTime
    begin
        LatestCalc := ItemRec."GSO Last Calc (Revenue)";
        if ItemRec."GSO Last Calc (GP)" > LatestCalc then
            LatestCalc := ItemRec."GSO Last Calc (GP)";
        if ItemRec."GSO Last Calc (COGS)" > LatestCalc then
            LatestCalc := ItemRec."GSO Last Calc (COGS)";
        if ItemRec."GSO Last Calc (Usage Value)" > LatestCalc then
            LatestCalc := ItemRec."GSO Last Calc (Usage Value)";
        if ItemRec."GSO Last Calc (GMROII)" > LatestCalc then
            LatestCalc := ItemRec."GSO Last Calc (GMROII)";
        if ItemRec."GSO Last Calc (Pick Freq)" > LatestCalc then
            LatestCalc := ItemRec."GSO Last Calc (Pick Freq)";
    end;

    local procedure IsOutdated(ItemRec: Record Item): Boolean
    var
        LatestCalc: DateTime;
    begin
        LatestCalc := GetLatestCalc(ItemRec);
        if LatestCalc = 0DT then
            exit(false);
        exit(DT2Date(LatestCalc) < CalcDate(StrSubstNo(DateFormulaTok, DaysThreshold), Today()));
    end;

    /// <summary>
    /// True when calculated classes differ by more than one step. Models never applied are ignored.
    /// </summary>
    local procedure HasInconsistentClasses(ItemRec: Record Item): Boolean
    var
        Classes: array[6] of Integer;
        Idx: Integer;
        MinClass: Integer;
        MaxClass: Integer;
    begin
        Classes[1] := ItemRec."GSO Class (Revenue)".AsInteger();
        Classes[2] := ItemRec."GSO Class (Gross Profit)".AsInteger();
        Classes[3] := ItemRec."GSO Class (COGS)".AsInteger();
        Classes[4] := ItemRec."GSO Class (Usage Value)".AsInteger();
        Classes[5] := ItemRec."GSO Class (GMROII)".AsInteger();
        Classes[6] := ItemRec."GSO Class (Pick Frequency)".AsInteger();

        MinClass := 999;
        MaxClass := 0;
        for Idx := 1 to ArrayLen(Classes) do
            if Classes[Idx] <> 0 then begin
                if Classes[Idx] < MinClass then
                    MinClass := Classes[Idx];
                if Classes[Idx] > MaxClass then
                    MaxClass := Classes[Idx];
            end;

        if MaxClass = 0 then
            exit(false);
        exit(MaxClass - MinClass > 1);
    end;

    local procedure IsHighInventoryLowClass(ItemRec: Record Item): Boolean
    begin
        if ItemRec."GSO Class (Revenue)" <> ItemRec."GSO Class (Revenue)"::C then
            exit(false);
        ItemRec.CalcFields(Inventory);
        exit(ItemRec.Inventory * ItemRec."Unit Cost" > InventoryThreshold);
    end;

    local procedure HasZeroActivity(ItemRec: Record Item): Boolean
    var
        ValueEntry: Record "Value Entry";
    begin
        ValueEntry.SetRange("Item No.", ItemRec."No.");
        ValueEntry.SetRange("Posting Date", ActivityStartDate, ActivityEndDate);
        exit(ValueEntry.IsEmpty());
    end;
}
