report 73030575 "GMO ABC Distribution"
{
    Caption = 'ABC Class Distribution Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Layouts/GMOABCDistribution.rdl';

    dataset
    {
        dataitem(ClassGroup; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = filter(0 .. 2));

            column(CompanyName; CompanyProperty.DisplayName())
            {
            }
            column(ModelColumn; Format(Model))
            {
            }
            column(ReportTitle; ReportTitleLbl)
            {
            }
            column(FilterText; ItemFilter)
            {
            }
            column(ClassName; ClassName)
            {
            }
            column(ItemCount; ItemCount)
            {
            }
            column(TotalValue; TotalValue)
            {
            }
            column(ValuePercent; ValuePercent)
            {
            }
            column(ItemPercent; ItemPercent)
            {
            }

            trigger OnPreDataItem()
            begin
                CalculateGrandTotals();
                SetItemFilters();
            end;

            trigger OnAfterGetRecord()
            begin
                ClassName := GetClassName(Number);
                CalculateClassMetrics(Number, ItemCount, TotalValue);

                if GrandTotalValue <> 0 then
                    ValuePercent := (TotalValue / GrandTotalValue) * 100
                else
                    ValuePercent := 0;

                if GrandItemCount <> 0 then
                    ItemPercent := (ItemCount / GrandItemCount) * 100
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
                        ToolTip = 'Select the ABC model to analyze.';
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
                        ToolTip = 'Filter by item number.';

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
                        ToolTip = 'Filter by item category.';

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
        Model: Enum "GMO ABC Model";
        GrandTotalValue: Decimal;
        GrandItemCount: Integer;
        ItemCount: Integer;
        TotalValue: Decimal;
        ValuePercent: Decimal;
        ItemPercent: Decimal;
        ClassName: Text[10];
        ItemFilter: Text;
        ReportTitleLbl: Label 'ABC Class Distribution Report';

    trigger OnPreReport()
    begin
        // No license check needed
    end;

    local procedure GetClassName(ClassNum: Integer): Text[10]
    begin
        case ClassNum of
            0:
                exit('A');
            1:
                exit('B');
            2:
                exit('C');
        end;
    end;

    local procedure SetItemFilters()
    begin
        ItemFilter := Item.GetFilters();
    end;

    local procedure CalculateClassMetrics(ClassNum: Integer; var Count: Integer; var Value: Decimal)
    var
        ItemRec: Record Item;
        ClassEnum: Enum "GMO ABC Class";
    begin
        Count := 0;
        Value := 0;

        ItemRec.CopyFilters(Item);
        if ItemRec.FindSet() then
            repeat
                ClassEnum := GetItemClass(ItemRec, Model);
                if ClassEnum.AsInteger() = ClassNum then begin
                    Count += 1;
                    Value += GetItemValue(ItemRec);
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
                GrandItemCount += 1;
                GrandTotalValue += GetItemValue(ItemRec);
            until ItemRec.Next() = 0;
    end;

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

    local procedure GetItemValue(ItemRec: Record Item): Decimal
    begin
        ItemRec.CalcFields(Inventory);
        exit(ItemRec.Inventory * ItemRec."Unit Cost");
    end;
}