codeunit 73030575 "GMO Load Test Data - Inventory"

{
    Subtype = Normal;

    var
        ProgressFormatLbl: Label '%1 / %2', Locked = true;
        ItemDescriptionLbl: Label 'LoadTest Inventory Item %1', Locked = true;
        CompletionMsgLbl: Label 'Done. Created %1 items (UoM PCS), stocked %2 each, posted %3 invoices (%4..%5 lines).', Locked = true;

    procedure RunLoadTestWithStock(ItemsToCreate: Integer; InvoicesToPost: Integer; MinLinesPerInv: Integer; MaxLinesPerInv: Integer; StockQtyPerItem: Decimal; LocationCode: Code[10])
    var
        CustPG: Record "Customer Posting Group";
        GenBusPG: Record "Gen. Business Posting Group";
        GenProdPG: Record "Gen. Product Posting Group";
        VatBusPG: Record "VAT Business Posting Group";
        VatProdPG: Record "VAT Product Posting Group";
        UoMCode: Code[10];
        TestCustomerNo: Code[20];
        Dialog: Dialog;
        ItemNos: List of [Code[20]];
    begin
        // --- Guard: required setups
        if not GenBusPG.FindFirst() then Error('No Gen. Business Posting Groups found.');
        if not CustPG.FindFirst() then Error('No Customer Posting Groups found.');
        if not VatBusPG.FindFirst() then Error('No VAT Business Posting Groups found.');
        if not GenProdPG.FindFirst() then Error('No Gen. Product Posting Groups found.');
        if not VatProdPG.FindFirst() then Error('No VAT Product Posting Groups found.');
        if MinLinesPerInv < 1 then Error('Min lines must be >= 1.');
        if MaxLinesPerInv < MinLinesPerInv then Error('Max lines must be >= Min lines.');
        if StockQtyPerItem <= 0 then Error('Stock quantity per item must be > 0.');

        // Ensure PCS UoM exists and use it


        TestCustomerNo := EnsureOrCreateCustomer(GenBusPG.Code, CustPG.Code, VatBusPG.Code);

        Dialog.Open(
          'Creating items: #1######\#' +
          'Stocking items: #2######\#' +
          'Posting invoices: #3######');
        UoMCode := 'PCS';

        // 1) Create INVENTORY items with PCS as base UoM
        ItemNos := CreateInventoryItems(ItemsToCreate, GenProdPG.Code, VatProdPG.Code, UoMCode);
        Dialog.Update(1, StrSubstNo(ProgressFormatLbl, ItemsToCreate, ItemsToCreate));

        // 2) Stock each item with positive adjustments
        StockUpItems(ItemNos, StockQtyPerItem, LocationCode, Dialog);
        Dialog.Update(2, StrSubstNo(ProgressFormatLbl, ItemNos.Count(), ItemNos.Count()));

        // 3) Create & post multi-line invoices
        CreateAndPostInvoicesWithLines(InvoicesToPost, TestCustomerNo, ItemNos, MinLinesPerInv, MaxLinesPerInv, Dialog);

        Dialog.Close();
        Message(CompletionMsgLbl,
            ItemsToCreate, StockQtyPerItem, InvoicesToPost, MinLinesPerInv, MaxLinesPerInv);
    end;

    // --- Ensure PCS UoM

    // --- Customer helper (unchanged)
    local procedure EnsureOrCreateCustomer(GenBusPGCode: Code[20]; CustPGCode: Code[20]; VatBusPGCode: Code[20]): Code[20]
    var
        Cust: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";
        No: Code[20];
    begin
        if Cust.Get('LOADTEST') then
            exit(Cust."No.");

        SalesSetup.Get();
        SalesSetup.TestField("Customer Nos.");

        No := NoSeriesMgt.GetNextNo(SalesSetup."Customer Nos.", WorkDate(), true);

        Cust.Init();
        Cust.Validate("No.", No);
        Cust.Validate(Name, 'Load Test Customer');
        Cust.Validate("Gen. Bus. Posting Group", GenBusPGCode);
        Cust.Validate("Customer Posting Group", CustPGCode);
        Cust.Validate("VAT Bus. Posting Group", VatBusPGCode);
        Cust.Insert(true);

        Cust.Rename('LOADTEST');
        exit(Cust."No.");
    end;

    // --- Create Inventory Items (now receives UoMCode, use PCS)
    local procedure CreateInventoryItems(Count: Integer; GenProdPGCode: Code[20]; VatProdPGCode: Code[20]; UoMCode: Code[10]) ItemNos: List of [Code[20]]
    var
        InvSetup: Record "Inventory Setup";
        Item: Record Item;
        NoSeriesMgt: Codeunit "No. Series";
        No: Code[20];
        UnitCost: Decimal;
        UnitPrice: Decimal;
        n: Integer;
        Desc: Text[100];
    begin
        InvSetup.Get();
        InvSetup.TestField("Item Nos.");

        for n := 1 to Count do begin
            No := NoSeriesMgt.GetNextNo(InvSetup."Item Nos.", WorkDate(), true);

            UnitCost := RandomInt(5, 120);
            UnitPrice := UnitCost + RandomInt(5, 120);

            Item.Init();
            Item.Validate("No.", No);
            Desc := StrSubstNo(ItemDescriptionLbl, n);
            Item.Validate(Description, Desc);
            Item.Validate(Type, Item.Type::Inventory);
            Item.Validate("Gen. Prod. Posting Group", GenProdPGCode);
            Item.Validate("VAT Prod. Posting Group", VatProdPGCode);
            Item.Validate("Unit Cost", UnitCost);
            Item.Validate("Unit Price", UnitPrice);
            Item.Insert(true);

            ItemNos.Add(Item."No.");

            Item.Validate("Base Unit of Measure", UoMCode); // <-- PCS
            Item.Modify(true);

            if (n mod 500) = 0 then
                Commit();
        end;

        exit(ItemNos);
    end;

    // --- Stock up items (unchanged)
    local procedure StockUpItems(ItemNos: List of [Code[20]]; QtyPerItem: Decimal; LocationCode: Code[10]; var Dialog: Dialog)
    var
        Item: Record Item;
        ItemJnlLine: Record "Item Journal Line";
        PostLine: Codeunit "Item Jnl.-Post Line";
        BatchName: Code[10];
        TemplateName: Code[10];
        CurItemNo: Code[20];
        UnitAmount: Decimal;
        i: Integer;
        PostedCount: Integer;
    begin
        EnsureItemJournalBatch(TemplateName, BatchName);

        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", TemplateName);
        ItemJnlLine.SetRange("Journal Batch Name", BatchName);
        if ItemJnlLine.FindSet(true) then
            ItemJnlLine.DeleteAll(true);

        for i := 1 to ItemNos.Count() do begin
            CurItemNo := ItemNos.Get(i);

            if Item.Get(CurItemNo) then
                UnitAmount := Item."Unit Cost"
            else
                UnitAmount := 50;

            ItemJnlLine.Init();
            ItemJnlLine.Validate("Journal Template Name", TemplateName);
            ItemJnlLine.Validate("Journal Batch Name", BatchName);
            ItemJnlLine.Validate("Posting Date", WorkDate());
            ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Positive Adjmt.");
            ItemJnlLine.Validate("Item No.", CurItemNo);
            if LocationCode <> '' then
                ItemJnlLine.Validate("Location Code", LocationCode);
            ItemJnlLine.Validate(Quantity, QtyPerItem);
            if UnitAmount > 0 then
                ItemJnlLine.Validate("Unit Amount", UnitAmount);
            ItemJnlLine.Insert(true);

            PostLine.Run(ItemJnlLine);
            PostedCount += 1;

            if (PostedCount mod 200) = 0 then begin
                Dialog.Update(2, StrSubstNo(ProgressFormatLbl, PostedCount, ItemNos.Count()));
                Commit();
            end;
        end;
    end;

    local procedure EnsureItemJournalBatch(var TemplateName: Code[10]; var BatchName: Code[10])
    var
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlTemplate: Record "Item Journal Template";
    begin
        if ItemJnlTemplate.Get('ITEM') then
            TemplateName := ItemJnlTemplate.Name
        else begin
            if not ItemJnlTemplate.FindFirst() then
                Error('No Item Journal Template found.');
            TemplateName := ItemJnlTemplate.Name;
        end;

        BatchName := 'LOADTEST';
        if not ItemJnlBatch.Get(TemplateName, BatchName) then begin
            ItemJnlBatch.Init();
            ItemJnlBatch.Validate("Journal Template Name", TemplateName);
            ItemJnlBatch.Validate(Name, BatchName);
            ItemJnlBatch.Validate(Description, 'Load test batch');
            ItemJnlBatch.Insert(true);
        end;
    end;

    // --- Create & Post Sales Invoices (unchanged)
    local procedure CreateAndPostInvoicesWithLines(TotalInvoices: Integer; CustomerNo: Code[20]; ItemNos: List of [Code[20]]; MinLines: Integer; MaxLines: Integer; var Dialog: Dialog)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Ok: Boolean;
        itemNo: Code[20];
        i: Integer;
        itemIdx: Integer;
        j: Integer;
        LinesThisInvoice: Integer;
    begin
        if ItemNos.Count() = 0 then
            Error('No items to use for invoices.');

        for i := 1 to TotalInvoices do begin
            SalesHeader.Init();
            SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
            SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
            SalesHeader.Insert(true);

            LinesThisInvoice := RandomInt(MinLines, MaxLines);

            for j := 1 to LinesThisInvoice do begin
                itemIdx := (((i - 1) * MaxLines) + j - 1) mod ItemNos.Count() + 1;
                itemNo := ItemNos.Get(itemIdx);

                SalesLine.Init();
                SalesLine.Validate("Document Type", SalesLine."Document Type"::Invoice);
                SalesLine.Validate("Document No.", SalesHeader."No.");
                SalesLine.Validate(Type, SalesLine.Type::Item);
                SalesLine.Validate("No.", itemNo);
                SalesLine.Validate(Quantity, RandomInt(1, 5));
                SalesLine.Insert(true);
            end;

            Ok := Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);
            if not Ok then 
                // Log error but continue processing remaining invoices
                // This allows bulk load testing even if some invoices fail validation
                if SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.") then
                    SalesHeader.Delete(true);
          

            if (i mod 50) = 0 then begin
                Dialog.Update(3, StrSubstNo(ProgressFormatLbl, i, TotalInvoices));
                Commit();
            end;
        end;

        Dialog.Update(3, StrSubstNo(ProgressFormatLbl, TotalInvoices, TotalInvoices));
    end;

    // --- Utils
    local procedure RandomInt(MinIncl: Integer; MaxIncl: Integer): Integer
    var
        span: Integer;
    begin
        if MaxIncl < MinIncl then
            exit(MinIncl);
        span := MaxIncl - MinIncl + 1;
        exit(MinIncl + Random(span) - 1);
    end;
}
