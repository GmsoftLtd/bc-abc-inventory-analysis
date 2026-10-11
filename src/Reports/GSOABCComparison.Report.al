report 73033674 "GSO ABC Comparison"
{
    Caption = 'ABC Multi-Model Comparison';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSOABCComparison.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", "Gen. Prod. Posting Group";

            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(RunDate; Format(CurrentDateTime(), 0, '<Standard Format,9>')) { }
            column(RunByUser; UserId()) { }
            column(ItemNo; "No.") { }
            column(Description; Description) { }
            column(RevenueClass; Format("GSO Class (Revenue)")) { }
            column(GrossProfitClass; Format("GSO Class (Gross Profit)")) { }
            column(COGSClass; Format("GSO Class (COGS)")) { }
            column(UsageValueClass; Format("GSO Class (Usage Value)")) { }
            column(GMROIIClass; Format("GSO Class (GMROII)")) { }
            column(PickFrequencyClass; Format("GSO Class (Pick Frequency)")) { }
            column(RevenueValue; RevenueValue) { }
            column(GrossProfitValue; GrossProfitValue) { }
            column(COGSValue; COGSValue) { }
            column(UsageValueValue; UsageValueValue) { }
            column(GMROIIValue; GMROIIValue) { }
            column(PickFrequencyValue; PickFrequencyValue) { }
            column(ConsistencyIndicator; ConsistencyIndicator) { }
            column(StartDate; Format(StartDate)) { }
            column(EndDate; Format(EndDate)) { }

            trigger OnAfterGetRecord()
            begin
                RevenueValue := Mgt.CalcItemValue(Enum::"GSO ABC Model"::Revenue, StartDate, EndDate, Item."No.");
                GrossProfitValue := Mgt.CalcItemValue(Enum::"GSO ABC Model"::"Gross Profit", StartDate, EndDate, Item."No.");
                COGSValue := Mgt.CalcItemValue(Enum::"GSO ABC Model"::COGS, StartDate, EndDate, Item."No.");
                UsageValueValue := Mgt.CalcItemValue(Enum::"GSO ABC Model"::"Usage Value", StartDate, EndDate, Item."No.");
                GMROIIValue := Mgt.CalcItemValue(Enum::"GSO ABC Model"::GMROII, StartDate, EndDate, Item."No.");
                PickFrequencyValue := Mgt.CalcItemValue(Enum::"GSO ABC Model"::"Pick Frequency", StartDate, EndDate, Item."No.");

                ConsistencyIndicator := GetConsistencyIndicator(Item);

                if (RevenueValue = 0) and (GrossProfitValue = 0) and (COGSValue = 0) and (UsageValueValue = 0) and
                   (GMROIIValue = 0) and (PickFrequencyValue = 0)
                then
                    CurrReport.Skip();
            end;

            trigger OnPreDataItem()
            var
                DefaultStart: Date;
                DefaultEnd: Date;
            begin
                Mgt.GetDefaultDates(Enum::"GSO ABC Model"::Revenue, DefaultStart, DefaultEnd);
                if StartDate = 0D then
                    StartDate := DefaultStart;
                if EndDate = 0D then
                    EndDate := DefaultEnd;
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
                    field(StartDateField; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the first posting date included. Leave blank to use the Revenue period configured in ABC Analysis Setup.';
                    }
                    field(EndDateField; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the last posting date included. Leave blank to use the work date.';
                    }
                }
            }
        }
    }

    var
        Mgt: Codeunit "GSO ABC Analysis Mgt.";
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
        ConsistentLbl: Label 'Consistent', MaxLength = 20;
        MinorVarianceLbl: Label 'Minor Variance', MaxLength = 20;
        InconsistentLbl: Label 'Inconsistent', MaxLength = 20;
        NotComparableLbl: Label 'n/a', MaxLength = 20;

    /// <summary>
    /// Compares the classes that have actually been calculated. Models never applied (class blank) are ignored.
    /// </summary>
    local procedure GetConsistencyIndicator(ItemRec: Record Item): Text[20]
    var
        Classes: array[6] of Integer;
        Idx: Integer;
        Calculated: Integer;
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
                Calculated += 1;
                if Classes[Idx] < MinClass then
                    MinClass := Classes[Idx];
                if Classes[Idx] > MaxClass then
                    MaxClass := Classes[Idx];
            end;

        if Calculated <= 1 then
            exit(NotComparableLbl);
        if MaxClass = MinClass then
            exit(ConsistentLbl);
        if MaxClass - MinClass <= 1 then
            exit(MinorVarianceLbl);
        exit(InconsistentLbl);
    end;
}
