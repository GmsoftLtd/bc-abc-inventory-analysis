report 73030575 "GSO ABC Distribution"
{
    Caption = 'ABC Class Distribution Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GSOABCDistribution.rdl';

    dataset
    {
        dataitem(ClassGroup; Integer)
        {
            // One row per class: 1 = A, 2 = B, 3 = C, 4 = D (enum ordinals)
            DataItemTableView = sorting(Number) where(Number = filter(1 .. 4));

            column(CompanyName; CompanyProperty.DisplayName()) { }
            column(ModelColumn; Format(Model)) { }
            column(ReportTitle; ReportTitleLbl) { }
            column(RunDate; Format(CurrentDateTime(), 0, '<Standard Format,9>')) { }
            column(RunByUser; UserId()) { }
            column(FilterText; ItemFilter) { }
            column(ClassName; ClassName) { }
            column(ItemCount; ItemCount) { }
            column(TotalValue; TotalValue) { }
            column(ValuePercent; ValuePercent) { }
            column(ItemPercent; ItemPercent) { }

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
                ItemFilter := Item.GetFilters();
                CalculateGrandTotals();
            end;

            trigger OnAfterGetRecord()
            var
                Class: Enum "GSO ABC Class";
            begin
                Class := Enum::"GSO ABC Class".FromInteger(Number);
                ClassName := CopyStr(Format(Class), 1, MaxStrLen(ClassName));
                CalculateClassMetrics(Class, ItemCount, TotalValue);

                if (Class = Class::D) and (ItemCount = 0) then
                    CurrReport.Skip();

                if GrandTotalValue <> 0 then
                    ValuePercent := TotalValue / GrandTotalValue * 100
                else
                    ValuePercent := 0;

                if GrandItemCount <> 0 then
                    ItemPercent := ItemCount / GrandItemCount * 100
                else
                    ItemPercent := 0;
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
                        ToolTip = 'Specifies the ABC model whose classes are summarized.';
                    }
                    field(StartDateField; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the first posting date included in the value. Leave blank to use the period configured for the model in ABC Analysis Setup.';
                    }
                    field(EndDateField; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the last posting date included in the value. Leave blank to use the work date.';
                    }
                }
                group(Filters)
                {
                    Caption = 'Filters';
                    field(ItemNoFilter; Item."No.")
                    {
                        ApplicationArea = All;
                        Caption = 'Item No.';
                        TableRelation = Item;
                        ToolTip = 'Specifies an item number filter.';

                        trigger OnValidate()
                        begin
                            Item.SetFilter("No.", Item."No.");
                        end;
                    }
                    field(CategoryFilter; Item."Item Category Code")
                    {
                        ApplicationArea = All;
                        Caption = 'Item Category';
                        TableRelation = "Item Category";
                        ToolTip = 'Specifies an item category filter.';

                        trigger OnValidate()
                        begin
                            Item.SetFilter("Item Category Code", Item."Item Category Code");
                        end;
                    }
                }
            }
        }
    }

    var
        Item: Record Item;
        TempPreview: Record "GSO ABC Preview Line" temporary;
        Model: Enum "GSO ABC Model";
        StartDate: Date;
        EndDate: Date;
        GrandTotalValue: Decimal;
        GrandItemCount: Integer;
        ItemCount: Integer;
        TotalValue: Decimal;
        ValuePercent: Decimal;
        ItemPercent: Decimal;
        ClassName: Text[10];
        ItemFilter: Text;
        ReportTitleLbl: Label 'ABC Class Distribution';

    local procedure CalculateClassMetrics(Class: Enum "GSO ABC Class"; var Count: Integer; var Value: Decimal)
    var
        ItemRec: Record Item;
    begin
        Count := 0;
        Value := 0;

        ItemRec.CopyFilters(Item);
        if ItemRec.FindSet() then
            repeat
                if GetItemClass(ItemRec, Model) = Class then begin
                    Count += 1;
                    Value += GetItemValue(ItemRec."No.");
                end;
            until ItemRec.Next() = 0;
    end;

    local procedure CalculateGrandTotals()
    var
        ItemRec: Record Item;
    begin
        GrandItemCount := 0;
        GrandTotalValue := 0;

        ItemRec.CopyFilters(Item);
        if ItemRec.FindSet() then
            repeat
                if GetItemClass(ItemRec, Model) <> Enum::"GSO ABC Class"::Unknown then begin
                    GrandItemCount += 1;
                    GrandTotalValue += GetItemValue(ItemRec."No.");
                end;
            until ItemRec.Next() = 0;
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

    local procedure GetItemValue(ItemNo: Code[20]): Decimal
    begin
        TempPreview.SetRange("Item No.", ItemNo);
        if TempPreview.FindFirst() then
            exit(TempPreview.Value);
        exit(0);
    end;
}
