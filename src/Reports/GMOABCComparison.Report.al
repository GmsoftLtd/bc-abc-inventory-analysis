report 73030579 "GMO ABC Comparison"
{
    Caption = 'ABC Multi-Model Comparison';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GMOABCComparison.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", "Gen. Prod. Posting Group";

            column(CompanyName; CompanyProperty.DisplayName())
            {
            }
            column(ReportTitle; ReportTitleLbl)
            {
            }
            column(RunDate; Format(CurrentDateTime, 0, '<Standard Format,9>'))
            {
            }
            column(RunByUser; UserId)
            {
            }
            column(ItemNo; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(RevenueClass; Format("GMO Class (Revenue)"))
            {
            }
            column(GrossProfitClass; Format("GMO Class (Gross Profit)"))
            {
            }
            column(COGSClass; Format("GMO Class (COGS)"))
            {
            }
            column(UsageValueClass; Format("GMO Class (Usage Value)"))
            {
            }
            column(GMROIIClass; Format("GMO Class (GMROII)"))
            {
            }
            column(PickFrequencyClass; Format("GMO Class (Pick Frequency)"))
            {
            }
            column(RevenueValue; RevenueValue)
            {
            }
            column(GrossProfitValue; GrossProfitValue)
            {
            }
            column(COGSValue; COGSValue)
            {
            }
            column(UsageValueValue; UsageValueValue)
            {
            }
            column(GMROIIValue; GMROIIValue)
            {
            }
            column(PickFrequencyValue; PickFrequencyValue)
            {
            }
            column(ConsistencyIndicator; ConsistencyIndicator)
            {
            }
            column(StartDate; Format(StartDate))
            {
            }
            column(EndDate; Format(EndDate))
            {
            }

            trigger OnAfterGetRecord()
            begin
                RevenueValue := CalculateItemValue(Item."No.", ModelEnum::Revenue, StartDate, EndDate);
                GrossProfitValue := CalculateItemValue(Item."No.", ModelEnum::"Gross Profit", StartDate, EndDate);
                COGSValue := CalculateItemValue(Item."No.", ModelEnum::COGS, StartDate, EndDate);
                UsageValueValue := CalculateItemValue(Item."No.", ModelEnum::"Usage Value", StartDate, EndDate);
                GMROIIValue := CalculateItemValue(Item."No.", ModelEnum::GMROII, StartDate, EndDate);
                PickFrequencyValue := CalculateItemValue(Item."No.", ModelEnum::"Pick Frequency", StartDate, EndDate);

                ConsistencyIndicator := GetConsistencyIndicator(Item);

                // Skip items with no values
                if (RevenueValue = 0) and (GrossProfitValue = 0) and (COGSValue = 0) and (UsageValueValue = 0) and
                   (GMROIIValue = 0) and (PickFrequencyValue = 0) then
                    CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            begin
                if StartDate = 0D then
                    StartDate := CalcDate('<-1Y>', WorkDate());
                if EndDate = 0D then
                    EndDate := WorkDate();
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
                    field(StartDateField; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Start date for value calculation. If not specified, the system will calculate it as today minus the lookback days from setup.';
                    }
                    field(EndDateField; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'End date for value calculation. If not specified, the system will use today''s date.';
                    }
                }
                group(Note)
                {
                    Caption = 'Note';
                    InstructionalText = 'If dates are not specified, the system will use today as the end date and calculate the start date by subtracting the lookback days configured in ABC Analysis Setup.';
                }
            }
        }
    }

    var
        ModelEnum: Enum "GMO ABC Model";
        StartDate: Date;
        EndDate: Date;
        RevenueValue: Decimal;
        GrossProfitValue: Decimal;
        COGSValue: Decimal;
        UsageValueValue: Decimal;
        GMROIIValue: Decimal;
        PickFrequencyValue: Decimal;
        ConsistencyIndicator: Text[20];
        ReportTitleLbl: Label 'ABC Multi-Model Comparison';

    trigger OnPreReport()
    begin
        // No license check needed
    end;

    local procedure CalculateItemValue(ItemNo: Code[20]; ModelType: Enum "GMO ABC Model"; FromDate: Date; ToDate: Date): Decimal
    var
        VE: Record "Value Entry";
        Total: Decimal;
        Margin: Decimal;
        AvgInv: Decimal;
        Item: Record Item;
        ILE: Record "Item Ledger Entry";
        PickCount: Integer;
    begin
        Total := 0;
        VE.SetRange("Item No.", ItemNo);

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

        VE.SetRange("Posting Date", FromDate, ToDate);

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

                    if Item.Get(ItemNo) then begin
                        Item.CalcFields(Inventory);
                        AvgInv := Item.Inventory * Item."Unit Cost";
                        if AvgInv > 0 then
                            Total := (Margin / AvgInv) * 100
                        else
                            Total := 0;
                    end;
                end;
            ModelType::"Pick Frequency":
                begin
                    // Count number of pick/issue transactions
                    ILE.Reset();
                    ILE.SetRange("Item No.", ItemNo);
                    ILE.SetFilter("Entry Type", '%1|%2',
                        ILE."Entry Type"::Sale,
                        ILE."Entry Type"::Consumption);
                    ILE.SetRange("Posting Date", FromDate, ToDate);
                    PickCount := ILE.Count();
                    Total := PickCount;
                end;
        end;
        exit(Total);
    end;

    local procedure GetConsistencyIndicator(ItemRec: Record Item): Text[20]
    var
        RevClass: Integer;
        GPClass: Integer;
        COGSClass: Integer;
        UsageValueClass: Integer;
        GMROIIClass: Integer;
        PickFreqClass: Integer;
        MaxDiff: Integer;
    begin
        RevClass := ItemRec."GMO Class (Revenue)".AsInteger();
        GPClass := ItemRec."GMO Class (Gross Profit)".AsInteger();
        COGSClass := ItemRec."GMO Class (COGS)".AsInteger();
        UsageValueClass := ItemRec."GMO Class (Usage Value)".AsInteger();
        GMROIIClass := ItemRec."GMO Class (GMROII)".AsInteger();
        PickFreqClass := ItemRec."GMO Class (Pick Frequency)".AsInteger();

        // Check if all classifications are the same
        if (RevClass = GPClass) and (RevClass = COGSClass) and (RevClass = UsageValueClass) and
           (RevClass = GMROIIClass) and (RevClass = PickFreqClass) then
            exit('✓ Consistent')
        else begin
            // Calculate maximum difference between any two classifications
            MaxDiff := 0;
            MaxDiff := MaxInt(MaxDiff, Abs(RevClass - GPClass));
            MaxDiff := MaxInt(MaxDiff, Abs(RevClass - COGSClass));
            MaxDiff := MaxInt(MaxDiff, Abs(RevClass - UsageValueClass));
            MaxDiff := MaxInt(MaxDiff, Abs(RevClass - GMROIIClass));
            MaxDiff := MaxInt(MaxDiff, Abs(RevClass - PickFreqClass));

            if MaxDiff <= 1 then
                exit('≈ Minor Variance')
            else
                exit('⚠ Inconsistent');
        end;
    end;

    local procedure MaxInt(A: Integer; B: Integer): Integer
    begin
        if A > B then
            exit(A)
        else
            exit(B);
    end;
}