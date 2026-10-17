namespace GMSoft.ABCInventoryAnalysis.Tests;

using GMSoft.ABCInventoryAnalysis;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Inventory.Counting.Journal;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;
using System.Security.User;
using System.TestLibraries.Utilities;

/// <summary>
/// Tests for the ABC calculation, apply, history, counting policy and statistics logic.
/// Test data is posted directly as value entries and item ledger entries in 2099, so the
/// standard demo data never falls inside the analysis window.
/// </summary>
codeunit 50000 "GSO ABC Analysis Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "Library Assert";
        Mgt: Codeunit "GSO ABC Analysis Mgt.";
        LibraryInventory: Codeunit "Library - Inventory";
        TestDate: Date;
        TestCounter: Integer;
        NoLinesErr: Label 'There are no preview lines to apply. Run Calculate first.';
        ItemCheckMsg: Label '%1 of item %2', Comment = '%1 = checked value, %2 = item number', Locked = true;

    [Test]
    procedure RevenueClassesFollowCumulativeShare()
    var
        TempPreview: Record "GSO ABC Preview Line" temporary;
        ItemNo: array[4] of Code[20];
    begin
        // [GIVEN] Four items with revenue 700, 200, 60 and 40, thresholds A 80 % and B 95 %
        Initialize(false);
        ItemNo[1] := CreateItemWithSale(700, 0);
        ItemNo[2] := CreateItemWithSale(200, 0);
        ItemNo[3] := CreateItemWithSale(60, 0);
        ItemNo[4] := CreateItemWithSale(40, 0);

        // [WHEN] The Revenue preview is calculated
        Mgt.CalculatePreview(Enum::"GSO ABC Model"::Revenue, StartDate(), EndDate(), TempPreview);

        // [THEN] Cumulative 70 % is A, 90 % is B, 96 % and 100 % are C
        Assert.AreEqual(4, TempPreview.Count(), 'Only the items with revenue in the window are in the preview');
        VerifyPreviewLine(TempPreview, ItemNo[1], 700, 70, 70, Enum::"GSO ABC Class"::A);
        VerifyPreviewLine(TempPreview, ItemNo[2], 200, 20, 90, Enum::"GSO ABC Class"::B);
        VerifyPreviewLine(TempPreview, ItemNo[3], 60, 6, 96, Enum::"GSO ABC Class"::C);
        VerifyPreviewLine(TempPreview, ItemNo[4], 40, 4, 100, Enum::"GSO ABC Class"::C);
    end;

    [Test]
    procedure ItemWithoutActivityIsClassDWhenEnabled()
    var
        TempPreview: Record "GSO ABC Preview Line" temporary;
        ItemNo: Code[20];
    begin
        // [GIVEN] "Zero Consumption as D" is on and an item has no sales in the window
        Initialize(true);
        CreateItemWithSale(500, 0);
        ItemNo := CreateItem();

        // [WHEN] The Revenue preview is calculated
        Mgt.CalculatePreview(Enum::"GSO ABC Model"::Revenue, StartDate(), EndDate(), TempPreview);

        // [THEN] The item without sales is in the preview as class D with value 0
        TempPreview.SetRange("Item No.", ItemNo);
        Assert.IsTrue(TempPreview.FindFirst(), 'Item without activity must be in the preview');
        Assert.AreEqual(Enum::"GSO ABC Class"::D, TempPreview.Class, 'Item without activity must be class D');
        Assert.AreEqual(0, TempPreview.Value, 'Item without activity must have value 0');
    end;

    [Test]
    procedure ItemWithoutActivityIsLeftOutWhenDisabled()
    var
        TempPreview: Record "GSO ABC Preview Line" temporary;
        ItemNo: Code[20];
    begin
        // [GIVEN] "Zero Consumption as D" is off and an item has no sales in the window
        Initialize(false);
        CreateItemWithSale(500, 0);
        ItemNo := CreateItem();

        // [WHEN] The Revenue preview is calculated
        Mgt.CalculatePreview(Enum::"GSO ABC Model"::Revenue, StartDate(), EndDate(), TempPreview);

        // [THEN] The item is not in the preview
        TempPreview.SetRange("Item No.", ItemNo);
        Assert.RecordIsEmpty(TempPreview);
    end;

    [Test]
    procedure ExcludedItemIsLeftOut()
    var
        Item: Record Item;
        TempPreview: Record "GSO ABC Preview Line" temporary;
        ItemNo: Code[20];
    begin
        // [GIVEN] An item with sales that is marked "Exclude"
        Initialize(false);
        CreateItemWithSale(500, 0);
        ItemNo := CreateItemWithSale(300, 0);
        Item.Get(ItemNo);
        Item."GSO Exclude" := true;
        Item.Modify(false);

        // [WHEN] The Revenue preview is calculated
        Mgt.CalculatePreview(Enum::"GSO ABC Model"::Revenue, StartDate(), EndDate(), TempPreview);

        // [THEN] The excluded item is not in the preview
        TempPreview.SetRange("Item No.", ItemNo);
        Assert.RecordIsEmpty(TempPreview);
    end;

    [Test]
    procedure GrossProfitIsSalesMinusCost()
    var
        ItemNo: Code[20];
    begin
        // [GIVEN] An item sold for 1000 at a cost of 600
        Initialize(false);
        ItemNo := CreateItemWithSale(1000, 600);

        // [WHEN] [THEN] The Gross Profit value is 400
        Assert.AreEqual(400, Mgt.CalcItemValue(Enum::"GSO ABC Model"::"Gross Profit", StartDate(), EndDate(), ItemNo), 'Gross profit');
    end;

    [Test]
    procedure COGSAddsOutboundCostAsPositive()
    var
        ItemNo: Code[20];
    begin
        // [GIVEN] Two units in stock at 250 each; one is sold and one is written off
        Initialize(false);
        ItemNo := CreateItem();
        PostEntry(ItemNo, Enum::"Item Ledger Entry Type"::"Positive Adjmt.", 2, 250);
        PostEntry(ItemNo, Enum::"Item Ledger Entry Type"::Sale, 1, 900);
        PostEntry(ItemNo, Enum::"Item Ledger Entry Type"::"Negative Adjmt.", 1, 0);

        // [WHEN] [THEN] The COGS value is the outbound cost 500; the inbound adjustment does not count
        Assert.AreEqual(500, Mgt.CalcItemValue(Enum::"GSO ABC Model"::COGS, StartDate(), EndDate(), ItemNo), 'COGS');
    end;

    [Test]
    procedure PickFrequencyCountsSalesAndConsumption()
    var
        ItemNo: Code[20];
    begin
        // [GIVEN] An item with one inbound adjustment, two sales and one negative adjustment
        Initialize(false);
        ItemNo := CreateItem();
        PostEntry(ItemNo, Enum::"Item Ledger Entry Type"::"Positive Adjmt.", 5, 10);
        PostEntry(ItemNo, Enum::"Item Ledger Entry Type"::Sale, 1, 20);
        PostEntry(ItemNo, Enum::"Item Ledger Entry Type"::Sale, 1, 20);
        PostEntry(ItemNo, Enum::"Item Ledger Entry Type"::"Negative Adjmt.", 1, 0);

        // [WHEN] [THEN] Only the two sales count as picks
        Assert.AreEqual(2, Mgt.CalcItemValue(Enum::"GSO ABC Model"::"Pick Frequency", StartDate(), EndDate(), ItemNo), 'Pick frequency');
    end;

    [Test]
    procedure ApplyWritesClassToItemSKUAndHistory()
    var
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
        HistHdr: Record "GSO ABC History Header";
        HistLine: Record "GSO ABC History Line";
        TempPreview: Record "GSO ABC Preview Line" temporary;
        ItemNo: array[2] of Code[20];
        Updated: Integer;
    begin
        // [GIVEN] Two items with revenue 700 and 300; the first has a stockkeeping unit
        Initialize(false);
        ItemNo[1] := CreateItemWithSale(700, 0);
        ItemNo[2] := CreateItemWithSale(300, 0);
        CreateSKU(ItemNo[1]);
        Mgt.CalculatePreview(Enum::"GSO ABC Model"::Revenue, StartDate(), EndDate(), TempPreview);
        HistHdr.SetRange(Model, Enum::"GSO ABC Model"::Revenue);
        if HistHdr.FindLast() then;
        HistHdr.SetFilter("Entry No.", '>%1', HistHdr."Entry No.");

        // [WHEN] The preview is applied
        Updated := Mgt.ApplyPreview(TempPreview, Enum::"GSO ABC Model"::Revenue, StartDate(), EndDate());

        // [THEN] Both items are updated, the first is A on the item and on its SKU, the second is C
        Assert.AreEqual(2, Updated, 'Items updated');
        Item.Get(ItemNo[1]);
        Assert.AreEqual(Enum::"GSO ABC Class"::A, Item."GSO Class (Revenue)", 'Item class');
        Assert.AreNotEqual(0DT, Item."GSO Last Calc (Revenue)", 'Item calculation timestamp');
        SKU.SetRange("Item No.", ItemNo[1]);
        SKU.FindFirst();
        Assert.AreEqual(Enum::"GSO ABC Class"::A, SKU."GSO Class (Revenue)", 'SKU class');
        Item.Get(ItemNo[2]);
        Assert.AreEqual(Enum::"GSO ABC Class"::C, Item."GSO Class (Revenue)", 'Second item class');

        // [THEN] One history entry with two lines and the total amount
        Assert.AreEqual(1, HistHdr.Count(), 'History entries created');
        HistHdr.FindFirst();
        Assert.AreEqual(2, HistHdr."Items Count", 'History items count');
        Assert.AreEqual(1000, HistHdr."Total Amount", 'History total amount');
        HistLine.SetRange("Entry No.", HistHdr."Entry No.");
        Assert.RecordCount(HistLine, 2);
    end;

    [Test]
    procedure ApplyKeepsManualOverrideClass()
    var
        Item: Record Item;
        TempPreview: Record "GSO ABC Preview Line" temporary;
        ItemNo: Code[20];
        Updated: Integer;
    begin
        // [GIVEN] An item with class C and "Manual Override" that would calculate as A
        Initialize(false);
        ItemNo := CreateItemWithSale(700, 0);
        CreateItemWithSale(300, 0);
        Item.Get(ItemNo);
        Item."GSO Class (Revenue)" := Enum::"GSO ABC Class"::C;
        Item."GSO Manual Override" := true;
        Item.Modify(false);
        Mgt.CalculatePreview(Enum::"GSO ABC Model"::Revenue, StartDate(), EndDate(), TempPreview);

        // [WHEN] The preview is applied
        Updated := Mgt.ApplyPreview(TempPreview, Enum::"GSO ABC Model"::Revenue, StartDate(), EndDate());

        // [THEN] The protected item keeps class C and is not counted as updated
        Assert.AreEqual(1, Updated, 'Only the item without override is updated');
        Item.Get(ItemNo);
        Assert.AreEqual(Enum::"GSO ABC Class"::C, Item."GSO Class (Revenue)", 'Manual override class must be kept');
    end;

    [Test]
    procedure ApplyWithoutPreviewLinesFails()
    var
        TempPreview: Record "GSO ABC Preview Line" temporary;
    begin
        // [GIVEN] An empty preview
        Initialize(false);

        // [WHEN] The preview is applied
        asserterror Mgt.ApplyPreview(TempPreview, Enum::"GSO ABC Model"::Revenue, StartDate(), EndDate());

        // [THEN] The apply stops with the "no preview lines" error
        Assert.ExpectedError(NoLinesErr);
    end;

    [Test]
    procedure ApplySetsCountingPeriodFromPolicy()
    var
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
        Setup: Record "GSO ABC Analysis Setup";
        PolicyLine: Record "GSO ABC Counting Policy Line";
        TempPreview: Record "GSO ABC Preview Line" temporary;
        ItemNo: Code[20];
        PeriodCode: Code[10];
    begin
        // [GIVEN] A counting policy that maps Revenue class A to a monthly counting period
        Initialize(false);
        PeriodCode := CreateCountingPeriod();
        Mgt.EnsureSetup(Setup);
        Setup."Counting Code Mapping ID" := 'ABCTPOL';
        Setup."Update Counting Codes" := true;
        Setup."Update SKU" := true;
        Setup.Modify(false);
        Mgt.EnsurePolicyExists('ABCTPOL');
        PolicyLine.Get('ABCTPOL', Enum::"GSO ABC Model"::Revenue, Enum::"GSO ABC Class"::A);
        PolicyLine."Counting Period Code" := PeriodCode;
        PolicyLine.Modify(false);

        // [GIVEN] An item that calculates as class A and has a stockkeeping unit
        ItemNo := CreateItemWithSale(700, 0);
        CreateItemWithSale(300, 0);
        CreateSKU(ItemNo);
        Mgt.CalculatePreview(Enum::"GSO ABC Model"::Revenue, StartDate(), EndDate(), TempPreview);

        // [WHEN] The preview is applied
        Mgt.ApplyPreview(TempPreview, Enum::"GSO ABC Model"::Revenue, StartDate(), EndDate());

        // [THEN] The item and its SKU get the counting period of class A
        Item.Get(ItemNo);
        Assert.AreEqual(PeriodCode, Item."Phys Invt Counting Period Code", 'Item counting period');
        SKU.SetRange("Item No.", ItemNo);
        SKU.FindFirst();
        Assert.AreEqual(PeriodCode, SKU."Phys Invt Counting Period Code", 'SKU counting period');
    end;

    [Test]
    procedure EnsurePolicyCreatesLinePerModelAndClass()
    var
        PolicyHeader: Record "GSO ABC Counting Policy Header";
        PolicyLine: Record "GSO ABC Counting Policy Line";
        Model: Enum "GSO ABC Model";
    begin
        // [GIVEN] No policy with code ABCTNEW
        Initialize(false);

        // [WHEN] The policy is ensured
        Assert.IsTrue(Mgt.EnsurePolicyExists('ABCTNEW'), 'EnsurePolicyExists must succeed');

        // [THEN] The header exists with one line per model for classes A, B, C and D
        Assert.IsTrue(PolicyHeader.Get('ABCTNEW'), 'Policy header');
        PolicyLine.SetRange("Header Code", 'ABCTNEW');
        Assert.RecordCount(PolicyLine, Model.Ordinals().Count() * 4);
        PolicyLine.SetRange(Class, Enum::"GSO ABC Class"::Unknown);
        Assert.RecordIsEmpty(PolicyLine);
    end;

    [Test]
    procedure DefaultDatesUseModelPeriod()
    var
        Setup: Record "GSO ABC Analysis Setup";
        StartDt: Date;
        EndDt: Date;
    begin
        // [GIVEN] A Revenue period of 30 days
        Initialize(false);
        Mgt.EnsureSetup(Setup);
        Setup."Rev Period (Days)" := 30;
        Setup.Modify(false);

        // [WHEN] The default dates are requested
        Mgt.GetDefaultDates(Enum::"GSO ABC Model"::Revenue, StartDt, EndDt);

        // [THEN] The window ends on the work date and starts 30 days earlier
        Assert.AreEqual(WorkDate(), EndDt, 'End date');
        Assert.AreEqual(WorkDate() - 30, StartDt, 'Start date');
    end;

    [Test]
    procedure StatisticsSumCountsAndShares()
    var
        TempPreview: Record "GSO ABC Preview Line" temporary;
        TempStats: Record "GSO ABC Stats" temporary;
        Stats: Codeunit "GSO ABC Worksheet Stats";
    begin
        // [GIVEN] Preview lines A 700, B 200, C 100 and D 0
        AddPreviewLine(TempPreview, 700, Enum::"GSO ABC Class"::A);
        AddPreviewLine(TempPreview, 200, Enum::"GSO ABC Class"::B);
        AddPreviewLine(TempPreview, 100, Enum::"GSO ABC Class"::C);
        AddPreviewLine(TempPreview, 0, Enum::"GSO ABC Class"::D);

        // [WHEN] The statistics are built
        Stats.BuildStats(TempPreview, TempStats);

        // [THEN] One line per class with counts, amount shares and cumulative shares
        Assert.RecordCount(TempStats, 4);
        TempStats.SetRange(Class, Enum::"GSO ABC Class"::A);
        TempStats.FindFirst();
        Assert.AreEqual(1, TempStats."Item Count", 'A count');
        Assert.AreEqual(70, TempStats."Amount %", 'A amount %');
        Assert.AreEqual(25, TempStats."Count %", 'A count %');
        TempStats.SetRange(Class, Enum::"GSO ABC Class"::C);
        TempStats.FindFirst();
        Assert.AreEqual(100, TempStats."Cum. Amount %", 'Cumulative amount % after C');
        TempStats.SetRange(Class, Enum::"GSO ABC Class"::D);
        TempStats.FindFirst();
        Assert.AreEqual(100, TempStats."Cum. Count %", 'Cumulative count % after D');
    end;

    // ---- helpers ----

    local procedure Initialize(ZeroAsD: Boolean)
    var
        Setup: Record "GSO ABC Analysis Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
    begin
        TestCounter += 1;
        TestDate := DMY2Date(1, 1, 2099) + TestCounter;

        // Test entries are posted in 2099; lift any allowed posting date range for this test
        GeneralLedgerSetup.Get();
        GeneralLedgerSetup."Allow Posting From" := 0D;
        GeneralLedgerSetup."Allow Posting To" := 0D;
        GeneralLedgerSetup.Modify(false);
        if UserSetup.Get(UserId()) then begin
            UserSetup."Allow Posting From" := 0D;
            UserSetup."Allow Posting To" := 0D;
            UserSetup.Modify(false);
        end;

        Mgt.EnsureSetup(Setup);
        Setup."Rev A %" := 80;
        Setup."Rev B %" := 95;
        Setup."Zero Consumption as D" := ZeroAsD;
        Setup."Exclude Non-Inventory" := false;
        Setup."Update Counting Codes" := false;
        Setup.Modify(false);
    end;

    // The test runner rolls back only after the whole codeunit, so every test posts on its own
    // day in 2099 and analyses only that day. Entries from earlier tests stay outside the window.
    local procedure StartDate(): Date
    begin
        exit(TestDate);
    end;

    local procedure EndDate(): Date
    begin
        exit(TestDate);
    end;

    local procedure CreateItem(): Code[20]
    var
        Item: Record Item;
    begin
        LibraryInventory.CreateItemSimple(Item, Enum::"Costing Method"::FIFO, 0);
        exit(Item."No.");
    end;

    /// <summary>
    /// Creates an item, brings one unit into stock at the given cost and sells it at the given price,
    /// so the sale has Sales Amount (Actual) = SalesAmount and Cost Amount (Actual) = -UnitCost.
    /// </summary>
    local procedure CreateItemWithSale(SalesAmount: Decimal; UnitCost: Decimal): Code[20]
    var
        ItemNo: Code[20];
    begin
        ItemNo := CreateItem();
        PostEntry(ItemNo, Enum::"Item Ledger Entry Type"::"Positive Adjmt.", 1, UnitCost);
        PostEntry(ItemNo, Enum::"Item Ledger Entry Type"::Sale, 1, SalesAmount);
        exit(ItemNo);
    end;

    local procedure PostEntry(ItemNo: Code[20]; EntryType: Enum "Item Ledger Entry Type"; Qty: Decimal; UnitAmount: Decimal)
    var
        Item: Record Item;
        ItemJournalTemplate: Record "Item Journal Template";
    begin
        Item.Get(ItemNo);
        LibraryInventory.PostItemJournalLine(
            ItemJournalTemplate.Type::Item, EntryType, Item, '', '', '', Qty, TestDate, UnitAmount);
    end;

    local procedure CreateSKU(ItemNo: Code[20])
    var
        SKU: Record "Stockkeeping Unit";
    begin
        SKU.Init();
        SKU."Location Code" := 'ABCTLOC';
        SKU."Item No." := ItemNo;
        SKU.Insert(false);
    end;

    local procedure CreateCountingPeriod(): Code[10]
    var
        CountingPeriod: Record "Phys. Invt. Counting Period";
    begin
        CountingPeriod.Init();
        CountingPeriod.Code := 'ABCT-A';
        CountingPeriod.Description := 'ABC test monthly';
        CountingPeriod."Count Frequency per Year" := 12;
        CountingPeriod.Insert(false);
        exit(CountingPeriod.Code);
    end;

    local procedure AddPreviewLine(var TempPreview: Record "GSO ABC Preview Line" temporary; Value: Decimal; Class: Enum "GSO ABC Class")
    var
        LineNo: Integer;
    begin
        TempPreview.Reset();
        if TempPreview.FindLast() then
            LineNo := TempPreview."Line No.";
        TempPreview.Init();
        TempPreview."Line No." := LineNo + 10000;
        TempPreview.Value := Value;
        TempPreview.Class := Class;
        TempPreview.Insert();
    end;

    local procedure VerifyPreviewLine(var TempPreview: Record "GSO ABC Preview Line" temporary; ItemNo: Code[20]; ExpectedValue: Decimal; ExpectedValuePct: Decimal; ExpectedCumPct: Decimal; ExpectedClass: Enum "GSO ABC Class")
    begin
        TempPreview.Reset();
        TempPreview.SetRange("Item No.", ItemNo);
        Assert.IsTrue(TempPreview.FindFirst(), StrSubstNo(ItemCheckMsg, 'Preview line', ItemNo));
        Assert.AreEqual(ExpectedValue, TempPreview.Value, StrSubstNo(ItemCheckMsg, 'Value', ItemNo));
        Assert.AreNearlyEqual(ExpectedValuePct, TempPreview."Value %", 0.001, StrSubstNo(ItemCheckMsg, 'Value %', ItemNo));
        Assert.AreNearlyEqual(ExpectedCumPct, TempPreview."Cum. %", 0.001, StrSubstNo(ItemCheckMsg, 'Cumulative %', ItemNo));
        Assert.AreEqual(ExpectedClass, TempPreview.Class, StrSubstNo(ItemCheckMsg, 'Class', ItemNo));
        TempPreview.Reset();
    end;
}
