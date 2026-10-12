report 73033675 "GSO ABC Detail by Class"
{
    Caption = 'ABC Detail by Class Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSOABCDetailByClass.rdl';

    dataset
    {
        // Carries the request page filters only. It never outputs rows; the ranked preview below does.
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", "Gen. Prod. Posting Group";
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem()
            begin
                ItemFilterView := Item.GetView(false);
                CurrReport.Break();
            end;
        }
        // Items ranked by value for the model and period, so Value % and Cum. % read top down as in the worksheet.
        dataitem(PreviewLine; "GSO ABC Preview Line")
        {
            UseTemporary = true;
            DataItemTableView = sorting(Value) order(descending);

            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(ModelColumn; Format(Model)) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(RunDate; Format(CurrentDateTime(), 0, '<Standard Format,9>')) { }
            column(RunByUser; UserId()) { }
            column(StartDate; Format(StartDate)) { }
            column(EndDate; Format(EndDate)) { }
            column(ItemNo; "Item No.") { }
            column(Description; Description) { }
            column(ABCClass; Format(ABCClass)) { }
            column(ItemValue; ItemValue) { }
            column(ValuePercent; ValuePercent) { }
            column(CumulativePercent; CumulativePercent) { }
            column(LastCalculated; Format(LastCalculated)) { }
            column(ClassFilter; ClassFilterText) { }

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

                Mgt.CalculatePreview(Model, StartDate, EndDate, PreviewLine);
                PreviewLine.SetCurrentKey(Value);
                PreviewLine.Ascending(false);
            end;

            trigger OnAfterGetRecord()
            var
                ItemRec: Record Item;
            begin
                if PreviewLine.Value = 0 then
                    CurrReport.Skip();
                if not ItemRec.Get(PreviewLine."Item No.") then
                    CurrReport.Skip();
                if not ItemMatchesFilters(PreviewLine."Item No.") then
                    CurrReport.Skip();

                ABCClass := GetItemClass(ItemRec, Model);
                if ClassFilter <> ClassFilter::Unknown then
                    if ABCClass <> ClassFilter then
                        CurrReport.Skip();

                ItemValue := PreviewLine.Value;
                ValuePercent := PreviewLine."Value %";
                CumulativePercent := PreviewLine."Cum. %";
                LastCalculated := GetItemLastCalc(ItemRec, Model);
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
        ItemFilterView: Text;
        ReportTitleLbl: Label 'ABC Detail by Class';
        AllClassesLbl: Label 'All', MaxLength = 20;

    trigger OnPreReport()
    begin
        if ClassFilter = ClassFilter::Unknown then
            ClassFilterText := AllClassesLbl
        else
            ClassFilterText := CopyStr(Format(ClassFilter), 1, MaxStrLen(ClassFilterText));
    end;

    local procedure ItemMatchesFilters(ItemNo: Code[20]): Boolean
    var
        FilteredItem: Record Item;
    begin
        if ItemFilterView = '' then
            exit(true);
        FilteredItem.SetView(ItemFilterView);
        FilteredItem.SetRange("No.", ItemNo);
        exit(not FilteredItem.IsEmpty());
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
