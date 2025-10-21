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

            column(CompanyName; CompanyProperty.DisplayName())
            {
            }
            column(ModelColumn; Format(this.Model))
            {
            }
            column(RunDate; Format(CurrentDateTime, 0, '<Standard Format,9>'))
            {
            }
            column(RunByUser; UserId)
            {
            }
            column(ReportTitle; this.ReportTitleLbl)
            {
            }
            column(CompareDateColumn; Format(this.CompareDate))
            {
            }
            column(ItemNo; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(CurrentClass; Format(this.CurrentClass))
            {
            }
            column(PreviousClass; Format(this.PreviousClass))
            {
            }
            column(Movement; this.MovementText)
            {
            }
            column(CurrentValue; this.CurrentValue)
            {
            }

            trigger OnAfterGetRecord()
            begin
                this.CurrentClass := this.GetItemClass(Item, this.Model);
                this.PreviousClass := this.GetHistoricalClass(Item."No.", this.Model, this.CompareDate);

                if this.CurrentClass = this.PreviousClass then
                    CurrReport.Skip();

                this.MovementText := this.GetMovementText(this.PreviousClass, this.CurrentClass);
                this.CurrentValue := this.GetItemCurrentValue(Item, this.Model);
            end;

            trigger OnPreDataItem()
            begin
                if this.CompareDate = 0D then
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
                        ToolTip = 'Historical date to compare against current classification. Required field.';
                    }
                }
                group(Note)
                {
                    Caption = 'Note';
                    InstructionalText = 'This report shows items whose ABC classification changed between the comparison date and today. A comparison date is required.';
                }
            }
        }
    }

    var
        Model: Enum "GSO ABC Model";
        CompareDate: Date;
        CurrentClass: Enum "GSO ABC Class";
        PreviousClass: Enum "GSO ABC Class";
        MovementText: Text[30];
        CurrentValue: Decimal;
        ReportTitleLbl: Label 'ABC Item Movement';
        MovementFormatLbl: Label '%1 → %2', Locked = true;

    trigger OnPreReport()
    begin
        // No license check needed
    end;

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
        HistHeader.Reset();
        HistHeader.SetRange(HistHeader.Model, ModelType);
        HistHeader.SetFilter("Created At", '<=%1', CreateDateTime(HistDate, 235959T));
        if HistHeader.FindLast() then begin
            HistLine.SetRange("Entry No.", HistHeader."Entry No.");
            HistLine.SetRange("Item No.", ItemNo);
            if HistLine.FindFirst() then
                exit(HistLine.Class);
        end;
        exit(this.CurrentClass::C);
    end;

    local procedure GetMovementText(OldClass: Enum "GSO ABC Class"; NewClass: Enum "GSO ABC Class"): Text[30]
    begin
        exit(StrSubstNo(this.MovementFormatLbl, Format(OldClass), Format(NewClass)));
    end;

    local procedure GetItemCurrentValue(ItemRec: Record Item; ModelType: Enum "GSO ABC Model"): Decimal
    var
        VE: Record "Value Entry";
        Total: Decimal;
        Margin: Decimal;
        AvgInv: Decimal;
        ILE: Record "Item Ledger Entry";
        PickCount: Integer;
    begin
        Total := 0;
        VE.SetRange("Item No.", ItemRec."No.");

        // Gross Profit should only use Sales entries
        if ModelType = ModelType::"Gross Profit" then
            VE.SetRange("Item Ledger Entry Type", VE."Item Ledger Entry Type"::Sale)
        else
            // Include: Sale, Consumption, Negative Adjmt (for scrap)
            // Exclude: Output, Purchase, Positive Adjmt, Transfer, etc.
            VE.SetFilter("Item Ledger Entry Type", '%1|%2|%3',
                VE."Item Ledger Entry Type"::Sale,
                VE."Item Ledger Entry Type"::Consumption,
                VE."Item Ledger Entry Type"::"Negative Adjmt.");

        VE.SetFilter("Posting Date", '%1..%2', CalcDate('<-1Y>', WorkDate()), WorkDate());

        case ModelType of
            ModelType::Revenue,
            ModelType::"Gross Profit",
            ModelType::COGS,
            ModelType::"Usage Value":
                begin
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
                                ModelType::"Usage Value":
                                    if VE."Cost Amount (Actual)" < 0 then
                                        Total += -VE."Cost Amount (Actual)";
                            end;
                        until VE.Next() = 0;
                end;
            ModelType::GMROII:
                begin
                    // Calculate GMROII = Gross Margin / Average Inventory Value
                    Margin := 0;
                    if VE.FindSet() then
                        repeat
                            Margin += VE."Sales Amount (Actual)" + VE."Cost Amount (Actual)";
                        until VE.Next() = 0;

                    ItemRec.CalcFields(Inventory);
                    AvgInv := ItemRec.Inventory * ItemRec."Unit Cost";
                    if AvgInv > 0 then
                        Total := (Margin / AvgInv) * 100
                    else
                        Total := 0;
                end;
            ModelType::"Pick Frequency":
                begin
                    // Count number of pick/issue transactions
                    ILE.Reset();
                    ILE.SetRange("Item No.", ItemRec."No.");
                    ILE.SetFilter("Entry Type", '%1|%2',
                        ILE."Entry Type"::Sale,
                        ILE."Entry Type"::Consumption);
                    ILE.SetFilter("Posting Date", '%1..%2', CalcDate('<-1Y>', WorkDate()), WorkDate());
                    PickCount := ILE.Count();
                    Total := PickCount;
                end;
        end;
        exit(Total);
    end;
}