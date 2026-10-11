report 73030576 "GSO ABC Item Movement"
{
    Caption = 'ABC Item Movement Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSOABCMovement.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", "Gen. Prod. Posting Group";

            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(ModelColumn; Format(Model)) { }
            column(RunDate; Format(CurrentDateTime(), 0, '<Standard Format,9>')) { }
            column(RunByUser; UserId()) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(CompareDateColumn; Format(CompareDate)) { }
            column(ItemNo; "No.") { }
            column(Description; Description) { }
            column(CurrentClass; Format(CurrentClass)) { }
            column(PreviousClass; Format(PreviousClass)) { }
            column(Movement; MovementText) { }
            column(CurrentValue; CurrentValue) { }

            trigger OnAfterGetRecord()
            begin
                CurrentClass := GetItemClass(Item, Model);
                PreviousClass := GetHistoricalClass(Item."No.", Model, CompareDate);

                if CurrentClass = PreviousClass then
                    CurrReport.Skip();

                MovementText := CopyStr(StrSubstNo(MovementFormatLbl, Format(PreviousClass), Format(CurrentClass)), 1, MaxStrLen(MovementText));
                CurrentValue := Mgt.CalcItemValue(Model, StartDate, EndDate, Item."No.");
            end;

            trigger OnPreDataItem()
            begin
                if CompareDate = 0D then
                    Error(CompareDateErr);
                Mgt.GetDefaultDates(Model, StartDate, EndDate);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ModelField; Model)
                    {
                        ApplicationArea = All;
                        Caption = 'ABC Model';
                        ToolTip = 'Specifies the ABC model to compare.';
                    }
                    field(CompareDateField; CompareDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Compare to Date';
                        ToolTip = 'Specifies the date whose last applied run is compared with the current class. Required.';
                    }
                }
                group(Note)
                {
                    Caption = 'Note';
                    InstructionalText = 'Shows items whose class differs between the last run applied on or before the comparison date and the class currently on the item.';
                }
            }
        }
    }

    var
        Mgt: Codeunit "GSO ABC Analysis Mgt.";
        Model: Enum "GSO ABC Model";
        CurrentClass: Enum "GSO ABC Class";
        PreviousClass: Enum "GSO ABC Class";
        CompareDate: Date;
        StartDate: Date;
        EndDate: Date;
        MovementText: Text[30];
        CurrentValue: Decimal;
        ReportTitleLbl: Label 'ABC Item Movement';
        MovementFormatLbl: Label '%1 -> %2', Locked = true;
        CompareDateErr: Label 'Please specify a comparison date.';

    local procedure GetItemClass(ItemRec: Record Item; ModelType: Enum "GSO ABC Model"): Enum "GSO ABC Class"
    begin
        case ModelType of
            ModelType::Revenue:
                exit(ItemRec."GSO Class (Revenue)");
            ModelType::"Gross Profit":
                exit(ItemRec."GSO Class (Gross Profit)");
            ModelType::COGS:
                exit(ItemRec."GSO Class (COGS)");
            ModelType::"Usage Value":
                exit(ItemRec."GSO Class (Usage Value)");
            ModelType::GMROII:
                exit(ItemRec."GSO Class (GMROII)");
            ModelType::"Pick Frequency":
                exit(ItemRec."GSO Class (Pick Frequency)");
        end;
    end;

    local procedure GetHistoricalClass(ItemNo: Code[20]; ModelType: Enum "GSO ABC Model"; HistDate: Date): Enum "GSO ABC Class"
    var
        HistHeader: Record "GSO ABC History Header";
        HistLine: Record "GSO ABC History Line";
    begin
        HistHeader.SetRange(Model, ModelType);
        HistHeader.SetFilter("Created At", '<=%1', CreateDateTime(HistDate, 235959T));
        if HistHeader.FindLast() then begin
            HistLine.SetRange("Entry No.", HistHeader."Entry No.");
            HistLine.SetRange("Item No.", ItemNo);
            if HistLine.FindFirst() then
                exit(HistLine.Class);
        end;
        exit(Enum::"GSO ABC Class"::Unknown);
    end;
}
