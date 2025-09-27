page 73030636 "GMO ABC Charts FactBox"
{
    PageType = CardPart;
    Caption = 'ABC Charts';
    ApplicationArea = All;
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(content)
        {
            group(Container)
            {
                ShowCaption = false;

                usercontrol(Chart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    // Public methods for the worksheet to bind/refresh the chart
    procedure LoadChart(var ChartBuf: Record "Business Chart Buffer" temporary)
    begin
        // Initial bind with the Business Chart Buffer
      //  CurrPage.Chart.page. LoadChart(ChartBuf);
    end;

    procedure RefreshChart(var ChartBuf: Record "Business Chart Buffer" temporary)
    begin
        // Refresh chart with updated buffer after recalculation
       //  CurrPage.Chart.Update(ChartBuf);
    end;
}
