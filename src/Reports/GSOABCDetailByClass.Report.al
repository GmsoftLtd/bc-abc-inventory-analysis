report 73030580 "GSO ABC Detail by Class"
{
    Caption = 'ABC Detail by Class Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSOABCDetailByClass.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", "Gen. Prod. Posting Group";
            DataItemTableView = sorting("No.");

            column(CompanyName; CompanyProperty.DisplayName())
            {
            }
            column(ModelColumn; Format(Model))
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
            column(StartDate; Format(StartDate))
            {
            }
            column(EndDate; Format(EndDate))
            {
            }
            column(ItemNo; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(ABCClass; Format(ABCClass))
            {
            }
            column(ItemValue; ItemValue)
            {
            }
            column(ValuePercent; ValuePercent)
            {
            }
            column(CumulativePercent; CumulativePercent)
            {
            }
            column(LastCalculated; Format(LastCalculated))
            {
            }
            column(ClassFilter; ClassFilterText)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ABCClass := GetItemClass(Item, Model);

                if ClassFilter <> ClassFilter::Unknown then
                    if ABCClass <> ClassFilter then
                        CurrReport.Skip();

                ItemValue := CalculateItemValue(Item."No.", Model, StartDate, EndDate);

                if ItemValue = 0 then
                    CurrReport.Skip();

                // Calculate percentages on the fly
                if TotalValue <> 0 then begin
                    ValuePercent := (ItemValue / TotalValue) * 100;
                    CumulativeValue += ItemValue;
                    CumulativePercent := (CumulativeValue / TotalValue) * 100;
                end;
            end;

            trigger OnPreDataItem()
            var
                ItemRec: Record Item;
            begin
                if StartDate = 0D then
                    StartDate := CalcDate('<-1Y>', WorkDate());
                if EndDate = 0D then
                    EndDate := WorkDate();

                // First pass: calculate total value
                TotalValue := 0;
                ItemRec.CopyFilters(Item);
                if ItemRec.FindSet() then
                    repeat
                        ABCClass := GetItemClass(ItemRec, Model);
                        if ClassFilter <> ClassFilter::Unknown then
                            if ABCClass <> ClassFilter then
                                continue;

                        ItemValue := CalculateItemValue(ItemRec."No.", Model, StartDate, EndDate);
                        if ItemValue > 0 then
                            TotalValue += ItemValue;
                    until ItemRec.Next() = 0;

                // Reset for the main loop
                CumulativeValue := 0;
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
                    field(ClassFilterField; ClassFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Class Filter';
                        ToolTip = 'Filter by specific ABC class (leave blank for all).';
                    }
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
        Model: Enum "GSO ABC Model";
        ClassFilter: Enum "GSO ABC Class";
        StartDate: Date;
        EndDate: Date;
        ABCClass: Enum "GSO ABC Class";
        ItemValue: Decimal;
        ValuePercent: Decimal;
        CumulativePercent: Decimal;
        TotalValue: Decimal;
        CumulativeValue: Decimal;
        LastCalculated: DateTime;
        ClassFilterText: Text[20];
        ReportTitleLbl: Label 'ABC Detail by Class';

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

    local procedure CalculateItemValue(ItemNo: Code[20]; ModelType: Enum "GSO ABC Model"; FromDate: Date; ToDate: Date): Decimal
    var
        VE: Record "Value Entry";
        Total: Decimal;
        Margin: Decimal;
        AvgInv: Decimal;
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

                    AvgInv := GetAverageInventoryValue(ItemNo, FromDate, ToDate);
                    if AvgInv > 0 then
                        Total := (Margin / AvgInv) * 100  // Return as percentage
                    else
                        Total := 0;
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

    local procedure GetAverageInventoryValue(ItemNo: Code[20]; FromDate: Date; ToDate: Date): Decimal
    var
        Item: Record Item;
    begin
        // Simplified: use current inventory value as approximation
        if Item.Get(ItemNo) then begin
            Item.CalcFields(Inventory);
            exit(Item.Inventory * Item."Unit Cost");
        end;
        exit(0);
    end;

    trigger OnPreReport()
    begin
        if ClassFilter = ClassFilter::Unknown then
            ClassFilterText := 'All'
        else
            ClassFilterText := Format(ClassFilter);
    end;
}