page 73030596  "GMO Load Test Runner"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Load Test Runner';

    layout
    {
        area(content)
        {
            group(Setup)
            {
                field(ItemsToCreate; ItemsToCreate) { ApplicationArea = All; ToolTip = 'Number of INVENTORY items to create.'; }
                field(InvoicesToPost; InvoicesToPost) { ApplicationArea = All; ToolTip = 'Number of sales invoices to post.'; }
                field(MinLinesPerInv; MinLinesPerInv) { ApplicationArea = All; ToolTip = 'Minimum lines per invoice.'; }
                field(MaxLinesPerInv; MaxLinesPerInv) { ApplicationArea = All; ToolTip = 'Maximum lines per invoice.'; }
            }
            group(Stocking)
            {
                field(StockQtyPerItem; StockQtyPerItem) { ApplicationArea = All; ToolTip = 'Quantity to add as positive adjustment for each item.'; }
                field(LocationCode; LocationCode) { ApplicationArea = All; ToolTip = 'Optional location code for stock. Leave blank for no location.'; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RunLoad)
            {
                Caption = 'Run Load Test';
                Image = Start;
                ApplicationArea = All;
                trigger OnAction()
                var
                    Loader: Codeunit "gmo Load Test Data - Inventory";
                begin
                    Loader.RunLoadTestWithStock(ItemsToCreate, InvoicesToPost, MinLinesPerInv, MaxLinesPerInv, StockQtyPerItem, LocationCode);
                end;
            }
        }
    }

    var
        ItemsToCreate: Integer;
        InvoicesToPost: Integer;
        MinLinesPerInv: Integer;
        MaxLinesPerInv: Integer;
        StockQtyPerItem: Decimal;
        LocationCode: Code[10];

    trigger OnOpenPage()
    begin
        // Defaults per your ask
        if ItemsToCreate = 0 then ItemsToCreate := 6000;
        if InvoicesToPost = 0 then InvoicesToPost := 20000;
        if MinLinesPerInv = 0 then MinLinesPerInv := 20;
        if MaxLinesPerInv = 0 then MaxLinesPerInv := 100;
        if StockQtyPerItem = 0 then StockQtyPerItem := 10000;
    end;
}
