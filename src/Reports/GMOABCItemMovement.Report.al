report 73030576 "GMO ABC Item Movement"
{
    Caption = 'ABC Item Movement Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GMOABCMovement.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", "Gen. Prod. Posting Group";

            column(CompanyName; CompanyProperty.DisplayName())
            {
            }
            column(ModelColumn; Format(Model))
            {
            }
            column(ReportTitle; ReportTitleLbl)
            {
            }
            column(CompareDateColumn; Format(CompareDate))
            {
            }
            column(ItemNo; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(CurrentClass; Format(CurrentClass))
            {
            }
            column(PreviousClass; Format(PreviousClass))
            {
            }
            column(Movement; MovementText)
            {
            }
            column(CurrentValue; CurrentValue)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CurrentClass := GetItemClass(Item, Model);
                PreviousClass := GetHistoricalClass(Item."No.", Model, CompareDate);

                if CurrentClass = PreviousClass then
                    CurrReport.Skip();

                MovementText := GetMovementText(PreviousClass, CurrentClass);
                CurrentValue := GetItemCurrentValue(Item, Model);
            end;

            trigger OnPreDataItem()
            begin
                if CompareDate = 0D then
                    Error('Please specify a comparison date.');
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
                        ToolTip = 'Select the ABC model to analyze.';
                    }
                    field(CompareDateField; CompareDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Compare to Date';
                        ToolTip = 'Historical date to compare against current classification.';
                    }
                }
            }
        }
    }

    var
        Model: Enum "GMO ABC Model";
        CompareDate: Date;
        CurrentClass: Enum "GMO ABC Class";
        PreviousClass: Enum "GMO ABC Class";
        MovementText: Text[30];
        CurrentValue: Decimal;
        ReportTitleLbl: Label 'ABC Item Movement Report';
        MovementFormatLbl: Label '%1 → %2', Locked = true;

    local procedure GetItemClass(ItemRec: Record Item; ModelType: Enum "GMO ABC Model"): Enum "GMO ABC Class"
    begin
        case ModelType of
            ModelType::Revenue:
                exit(ItemRec."GMO Class (Revenue)");
            ModelType::"Gross Profit":
                exit(ItemRec."GMO Class (Gross Profit)");
            ModelType::COGS:
                exit(ItemRec."GMO Class (COGS)");
        end;
    end;

    local procedure GetHistoricalClass(ItemNo: Code[20]; ModelType: Enum "GMO ABC Model"; HistDate: Date): Enum "GMO ABC Class"
    var
        HistHeader: Record "GMO ABC History Header";
        HistLine: Record "GMO ABC History Line";
    begin
        HistHeader.Reset();
        HistHeader.SetRange(HistHeader.Model, ModelType);
        HistHeader.SetFilter("Created At", '<=%1', CreateDateTime(HistDate, 235959T));
        if HistHeader.FindLast() then begin
            HistLine.SetRange("Entry No.", HistHeader."Entry No.");
            HistLine.SetRange("Item No.", ItemNo);
            if HistLine.FindFirst() then
                exit(HistLine.Class);
        end;
        exit(CurrentClass::C);
    end;

    local procedure GetMovementText(OldClass: Enum "GMO ABC Class"; NewClass: Enum "GMO ABC Class"): Text[30]
    begin
        exit(StrSubstNo(MovementFormatLbl, Format(OldClass), Format(NewClass)));
    end;

    local procedure GetItemCurrentValue(ItemRec: Record Item; ModelType: Enum "GMO ABC Model"): Decimal
    var
        VE: Record "Value Entry";
        Total: Decimal;
    begin
        Total := 0;
        VE.SetRange("Item No.", ItemRec."No.");
        VE.SetFilter("Posting Date", '%1..%2', CalcDate('<-1Y>', WorkDate()), WorkDate());
        if VE.FindSet() then
            repeat
                case ModelType of
                    ModelType::Revenue:
                        Total += VE."Sales Amount (Actual)";
                    ModelType::"Gross Profit":
                        Total += VE."Sales Amount (Actual)" + VE."Cost Amount (Actual)";
                    ModelType::COGS:
                        if VE."Cost Amount (Actual)" < 0 then
                            Total += -VE."Cost Amount (Actual)";
                end;
            until VE.Next() = 0;
        exit(Total);
    end;
}