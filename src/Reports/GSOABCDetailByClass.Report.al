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

            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(ModelColumn; Format(Model)) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(RunDate; Format(CurrentDateTime(), 0, '<Standard Format,9>')) { }
            column(RunByUser; UserId()) { }
            column(StartDate; Format(StartDate)) { }
            column(EndDate; Format(EndDate)) { }
            column(ItemNo; "No.") { }
            column(Description; Description) { }
            column(ABCClass; Format(ABCClass)) { }
            column(ItemValue; ItemValue) { }
            column(ValuePercent; ValuePercent) { }
            column(CumulativePercent; CumulativePercent) { }
            column(LastCalculated; Format(LastCalculated)) { }
            column(ClassFilter; ClassFilterText) { }

            trigger OnAfterGetRecord()
            begin
                ABCClass := GetItemClass(Item, Model);
                if ClassFilter <> ClassFilter::Unknown then
                    if ABCClass <> ClassFilter then
                        CurrReport.Skip();

                // Values and shares come from a full ranking of all items for the period,
                // so Value % and Cumulative % are the same figures the worksheet shows.
                TempPreview.SetRange("Item No.", Item."No.");
                if not TempPreview.FindFirst() then
                    CurrReport.Skip();
                if TempPreview.Value = 0 then
                    CurrReport.Skip();

                ItemValue := TempPreview.Value;
                ValuePercent := TempPreview."Value %";
                CumulativePercent := TempPreview."Cum. %";
                LastCalculated := GetItemLastCalc(Item, Model);
            end;

            trigger OnPreDataItem()
            var
                Mgt: Codeunit "GSO ABC Analysis Mgt.";
                DefaultStart: Date;
                DefaultEnd: Date;
            begin
                Mgt.GetDefaultDates(Model, DefaultStart, DefaultEnd);
                if StartDate = 0D then
                    StartDate := DefaultStart;
                if EndDate = 0D then
                    EndDate := DefaultEnd;

                Mgt.CalculatePreview(Model, StartDate, EndDate, TempPreview);
                TempPreview.SetCurrentKey("Item No.");
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
                    field(ModelField; Model)
                    {
                        ApplicationArea = All;
                        Caption = 'ABC Model';
                        ToolTip = 'Specifies the ABC model whose class and value are shown.';
                    }
                    field(ClassFilterField; ClassFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Class Filter';
                        ToolTip = 'Specifies a single class to print. Leave blank for all classes.';
                    }
                    field(StartDateField; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the first posting date included. Leave blank to use the period configured for the model in ABC Analysis Setup.';
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
        TempPreview: Record "GSO ABC Preview Line" temporary;
        Model: Enum "GSO ABC Model";
        ClassFilter: Enum "GSO ABC Class";
        ABCClass: Enum "GSO ABC Class";
        StartDate: Date;
        EndDate: Date;
        ItemValue: Decimal;
        ValuePercent: Decimal;
        CumulativePercent: Decimal;
        LastCalculated: DateTime;
        ClassFilterText: Text[20];
        ReportTitleLbl: Label 'ABC Detail by Class';
        AllClassesLbl: Label 'All', MaxLength = 20;

    trigger OnPreReport()
    begin
        if ClassFilter = ClassFilter::Unknown then
            ClassFilterText := AllClassesLbl
        else
            ClassFilterText := CopyStr(Format(ClassFilter), 1, MaxStrLen(ClassFilterText));
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

    local procedure GetItemLastCalc(ItemRec: Record Item; ModelType: Enum "GSO ABC Model"): DateTime
    begin
        case ModelType of
            ModelType::Revenue:
                exit(ItemRec."GSO Last Calc (Revenue)");
            ModelType::"Gross Profit":
                exit(ItemRec."GSO Last Calc (GP)");
            ModelType::COGS:
                exit(ItemRec."GSO Last Calc (COGS)");
            ModelType::"Usage Value":
                exit(ItemRec."GSO Last Calc (Usage Value)");
            ModelType::GMROII:
                exit(ItemRec."GSO Last Calc (GMROII)");
            ModelType::"Pick Frequency":
                exit(ItemRec."GSO Last Calc (Pick Freq)");
        end;
    end;
}
