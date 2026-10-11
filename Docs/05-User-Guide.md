# ABC Analysis Extension - User Guide
**Comprehensive Guide for Microsoft Dynamics 365 Business Central**

---

## Table of Contents
1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Getting Started](#getting-started)
4. [ABC Worksheet](#abc-worksheet)
5. [Running Analysis](#running-analysis)
6. [Understanding Results](#understanding-results)
7. [Reports](#reports)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)
10. [FAQ](#faq)

---

## 1. Introduction

### What is ABC Analysis?
ABC Analysis is an inventory categorization technique based on the Pareto Principle (80/20 rule). It classifies inventory into three categories:

- **Class A**: High-value items (typically 20% of items, 80% of value)
  - Require tight control and accurate records
  - Frequent monitoring and review
  - Close supplier relationships

- **Class B**: Medium-value items (typically 30% of items, 15% of value)
  - Moderate control and monitoring
  - Regular review cycles
  - Balanced inventory management

- **Class C**: Low-value items (typically 50% of items, 5% of value)
  - Simple controls
  - Less frequent monitoring
  - Larger safety stocks acceptable

### What is XYZ Analysis?
XYZ Analysis classifies items based on demand variability (consistency):

- **Class X**: Stable demand (low variability)
  - Predictable consumption
  - Easy to forecast
  - Lower safety stock required

- **Class Y**: Variable demand (moderate variability)
  - Seasonal or trend-based
  - Moderate forecasting difficulty
  - Moderate safety stock

- **Class Z**: Highly variable demand (high variability)
  - Irregular or sporadic consumption
  - Difficult to forecast
  - Higher safety stock or special ordering

### The ABC-XYZ Matrix
Combining both creates a 9-zone strategic matrix:

| | X (Stable) | Y (Variable) | Z (Irregular) |
|---|---|---|---|
| **A (High Value)** | AX: Optimize with precision | AY: Monitor closely | AZ: Critical attention |
| **B (Medium Value)** | BX: Standard controls | BY: Regular review | BZ: Watch for changes |
| **C (Low Value)** | CX: Efficient replenishment | CY: Simple rules | CZ: Minimal effort |

### Business Benefits
- Reduce inventory carrying costs by 25-30%
- Improve cash flow and working capital
- Focus resources on high-impact items
- Optimize safety stock levels
- Reduce stockouts on critical items
- Minimize obsolescence

---

## 2. Installation

### From Microsoft AppSource

1. **Access AppSource**:
   - Open Business Central
   - Click the search icon (🔍) → "Extension Management"
   - Click "Manage" → "Browse AppSource"
   - Or visit: https://appsource.microsoft.com

2. **Find the Extension**:
   - Search for "ABC Analysis GMSOFT"
   - Click on the extension

3. **Install**:
   - Click "Get It Now"
   - Sign in with your Microsoft account
   - Select your Business Central environment
   - Accept terms and conditions
   - Click "Install"

4. **Wait for Installation**:
   - Installation takes 5-15 minutes
   - You'll receive a notification when complete

5. **Verify Installation**:
   - Search for "ABC Analysis" in Business Central
   - You should see "ABC Worksheet" page

### From Extension Management (CSP/Partner)

1. Open Business Central
2. Search → "Extension Management"
3. Click "Upload Extension"
4. Select the .app file provided by your partner
5. Click "Deploy" → "Install"

### Permissions Setup

After installation, assign permissions:

1. Search → "Permission Sets"
2. Find the ABC Inventory Analysis permission sets:
   - **GSO ABC ADMIN**: Full access (setup, analysis, reports)
   - **GSO ABC USER**: Standard user (run analysis, view reports)

3. Assign to users:
   - Search → "Users"
   - Select user → "User Permission Sets"
   - Add "GSO ABC USER" or "GSO ABC ADMIN"

---

## 3. Getting Started

### First-Time Setup

#### Step 1: Access ABC Worksheet
- Click search icon (🔍) or press Alt+Q
- Type "ABC Worksheet"
- Press Enter

#### Step 2: Set Parameters
On first use, you'll see the ABC Worksheet Parameters page:

**Date Filters**:
- **Date Filter**: Period for sales/consumption analysis
  - Recommended: Last 12 months for annual analysis
  - Example: 01/01/2024..12/31/2024

**Location Filters**:
- **Location Filter**: Specific warehouse/location
  - Leave blank for all locations
  - Or select specific location code

**Classification Thresholds** (ABC):
- **A Class Percentage**: Default 80%
  - Items representing top 80% of cumulative value
- **B Class Percentage**: Default 15%
  - Next 15% of cumulative value
- **C Class Percentage**: Default 5%
  - Remaining 5% of cumulative value

**Variability Thresholds** (XYZ):
- **X Class Variability**: Default 0-20%
  - Stable demand (coefficient of variation < 20%)
- **Y Class Variability**: Default 20-50%
  - Moderate variability (CV 20-50%)
- **Z Class Variability**: Default >50%
  - High variability (CV > 50%)

**Calculation Basis**:
- **Value Basis**: What to analyze
  - Sales Amount (recommended for most businesses)
  - Quantity Sold
  - Gross Profit
  - Inventory Value

#### Step 3: Run First Analysis
1. Click "Calculate ABC Classification"
2. Wait for processing (30 seconds to 2 minutes depending on item count)
3. Results appear in the worksheet

---

## 4. ABC Worksheet

### Worksheet Overview

The ABC Worksheet is your main interface for analysis and classification.

**Columns Explained**:

| Column | Description |
|--------|-------------|
| **No.** | Item number from Item Card |
| **Description** | Item description |
| **Sales (LCY)** | Total sales in local currency for the date range |
| **Sales Quantity** | Total quantity sold |
| **Cumulative %** | Running total percentage of total value |
| **ABC Classification** | A, B, or C class |
| **XYZ Classification** | X, Y, or Z class |
| **ABC-XYZ Zone** | Combined classification (AX, AY, AZ, etc.) |
| **Coefficient of Variation** | Demand variability percentage |
| **Avg Monthly Demand** | Average units sold per month |
| **Std Deviation** | Standard deviation of monthly demand |
| **Unit Cost** | Current unit cost |
| **Inventory** | Current on-hand quantity |
| **Inventory Value** | Inventory × Unit Cost |

### Filtering and Sorting

**Filter by Classification**:
- Click filter icon on "ABC Classification" column
- Select A, B, or C
- Click OK

**Filter by Zone**:
- Click filter icon on "ABC-XYZ Zone"
- Select specific zones (e.g., AX, AY)
- Useful for strategic analysis

**Sort by Value**:
- Click "Sales (LCY)" column header
- Items automatically sorted by value (high to low)

**Custom Filters**:
- Filter by Item Category
- Filter by Location
- Filter by Unit Cost range
- Combine multiple filters

### Actions Available

**Ribbon Actions**:

**Home Tab**:
- **Calculate ABC**: Run the classification analysis
- **Refresh Data**: Reload current data
- **Clear Classification**: Remove all classifications

**Navigate Tab**:
- **Item Card**: Open selected item's card
- **Ledger Entries**: View item ledger entries
- **Sales History**: View sales statistics
- **Inventory**: Check inventory details

**Report Tab**:
- **ABC Distribution**: Summary report
- **ABC Detail by Class**: Detailed breakdown
- **ABC Comparison**: Compare periods
- **ABC Movement**: Track classification changes
- **ABC Exceptions**: Identify outliers

**Process Tab**:
- **Update Parameters**: Change analysis settings
- **Export to Excel**: Export worksheet data
- **Save as History**: Store current analysis

---

## 5. Running Analysis

### Step-by-Step Analysis Process

#### Preparation
1. **Ensure data is current**:
   - Post all pending sales orders
   - Update inventory counts
   - Verify item costs

2. **Define analysis period**:
   - Annual analysis: Last 12 months
   - Quarterly analysis: Last 3 months
   - Seasonal business: Align with season

#### Running the Analysis

1. **Open ABC Worksheet**:
   - Search → "ABC Worksheet"

2. **Set Parameters**:
   - Click "Update Parameters" (if changing from last run)
   - **Date Filter**: `01/01/2024..12/31/2024`
   - **Location Filter**: Leave blank or select location
   - **ABC Thresholds**: Keep default (80/15/5) or adjust
   - **XYZ Thresholds**: Keep default or adjust
   - **Value Basis**: Select "Sales Amount"
   - Click OK

3. **Execute Calculation**:
   - Click "Calculate ABC Classification"
   - Progress bar appears
   - Processing time varies:
     - <1,000 items: 10-30 seconds
     - 1,000-5,000 items: 30-90 seconds
     - 5,000+ items: 1-3 minutes

4. **Review Results**:
   - Worksheet populates with classifications
   - Items sorted by cumulative value
   - ABC and XYZ classes assigned

#### Adjusting Parameters

If results don't look right:

**Too many A items?**
- Reduce A Class Percentage (try 70% instead of 80%)
- This makes classification more exclusive

**Too few A items?**
- Increase A Class Percentage (try 85%)
- This includes more items in top tier

**Want more granular analysis?**
- Create custom thresholds
- Consider adding A+, A, A- sub-classifications

### Multi-Location Analysis

**Option 1: Combined Analysis**
- Leave Location Filter blank
- Analyzes all locations together
- Good for overall strategy

**Option 2: Location-Specific Analysis**
- Set Location Filter to specific code
- Run separate analyses per location
- Good for warehouse-specific strategies

**Option 3: Comparison**
- Run analysis for Location A
- Save as History
- Run analysis for Location B
- Compare results

---

## 6. Understanding Results

### Interpreting ABC Classifications

#### Class A Items (High Value)
**Characteristics**:
- Top 20% of items by value
- Represent 80% of total value
- Critical to business success

**Management Strategies**:
- **Tight inventory control**: Count frequently (weekly/monthly)
- **Accurate demand forecasting**: Use advanced forecasting methods
- **Strong supplier relationships**: Negotiate better terms, ensure supply
- **Lower safety stock**: High carrying cost, minimize excess
- **Frequent ordering**: Smaller, more frequent orders (if EOQ allows)
- **Close monitoring**: Track daily/weekly

**Example A Items**:
- Best-selling products
- High-margin items
- Critical raw materials
- Fast-moving components

#### Class B Items (Medium Value)
**Characteristics**:
- Next 30% of items
- Represent 15% of total value
- Important but not critical

**Management Strategies**:
- **Moderate controls**: Count quarterly
- **Standard forecasting**: Use historical averages
- **Regular review**: Monitor monthly
- **Balanced safety stock**: Moderate buffer
- **Scheduled ordering**: Regular reorder cycles

**Example B Items**:
- Seasonal products
- Regular sellers
- Standard components

#### Class C Items (Low Value)
**Characteristics**:
- Remaining 50% of items
- Represent only 5% of total value
- Low individual impact

**Management Strategies**:
- **Simple controls**: Count annually or bi-annually
- **Minimal forecasting**: Basic reorder points
- **High safety stock**: Acceptable to overstock (low cost)
- **Bulk ordering**: Larger orders for discounts
- **Minimal monitoring**: Review only when issues arise

**Example C Items**:
- Slow-moving items
- Low-cost consumables
- Spare parts with low demand

### Interpreting XYZ Classifications

#### Class X Items (Stable Demand)
- **Coefficient of Variation < 20%**
- Predictable, consistent demand
- Easy to forecast and plan
- Lower safety stock required

**Examples**: Staple products, consumables

#### Class Y Items (Variable Demand)
- **Coefficient of Variation 20-50%**
- Moderate fluctuation
- Requires monitoring
- Moderate safety stock

**Examples**: Seasonal items, trending products

#### Class Z Items (Irregular Demand)
- **Coefficient of Variation > 50%**
- Highly unpredictable
- Difficult to forecast
- Higher safety stock or make-to-order

**Examples**: Specialty items, sporadic spare parts

### The Strategic Matrix

#### High-Priority Zones

**AX (High Value, Stable)**:
- Most important items
- Optimize with precision
- JIT or lean inventory possible
- Strong supplier partnerships
- Tight controls, accurate forecasting

**AY (High Value, Variable)**:
- Monitor closely
- Advanced forecasting (seasonality, trends)
- Flexible suppliers
- Regular demand reviews

**AZ (High Value, Irregular)**:
- Critical attention required
- Safety stock or make-to-order
- May require customer communication
- Consider alternative suppliers

#### Medium-Priority Zones

**BX, BY, BZ**:
- Standard controls
- Balanced approach
- Review regularly
- Adjust as needed

#### Low-Priority Zones

**CX, CY, CZ**:
- Minimal effort
- Bulk orders acceptable
- Overstock is low-risk
- Automate replenishment where possible

### Key Metrics

**Cumulative Percentage**:
- Shows running total of value
- Verify Pareto principle (80/20)
- A items should reach ~80% cumulative

**Coefficient of Variation**:
- Formula: (Std Deviation / Average) × 100
- Lower = more stable
- Higher = more variable

**Average Monthly Demand**:
- Total demand / number of months
- Used for reorder point calculations

**Inventory Turnover** (Calculate manually):
- Annual Sales / Average Inventory
- Higher turnover for A items expected

---

## 7. Reports

### ABC Distribution Report

**Purpose**: High-level overview of ABC classification results

**How to Run**:
1. From ABC Worksheet → Report → "ABC Distribution"
2. Set filters (optional):
   - Item Category Filter
   - Location Filter
3. Click "Preview" or "Print"

**Report Contents**:
- Summary table: Class, Item Count, Total Value, Percentage
- Pareto chart: Visual representation
- Pie chart: Distribution by class
- Value vs. Quantity comparison

**Use Cases**:
- Present to management
- Verify classification logic
- Track overall inventory composition

### ABC Detail by Class Report

**Purpose**: Detailed list of items within each class

**How to Run**:
1. ABC Worksheet → Report → "ABC Detail by Class"
2. Select class filter (A, B, or C)
3. Click "Preview"

**Report Contents**:
- Item-level details for selected class
- Sales value, quantity, unit cost
- Inventory levels
- Grouped by class

**Use Cases**:
- Review specific class items
- Identify opportunities for cost reduction (C items)
- Focus procurement on A items

### ABC Comparison Report

**Purpose**: Track classification changes over time

**How to Run**:
1. ABC Worksheet → Report → "ABC Comparison"
2. Set date ranges:
   - **Current Period**: Recent analysis
   - **Comparison Period**: Previous analysis
3. Click "Preview"

**Report Contents**:
- Items that changed class (A→B, B→C, etc.)
- Promoted items (moved up)
- Demoted items (moved down)
- Value change analysis

**Use Cases**:
- Identify trending products (C→B→A)
- Spot declining products (A→B→C)
- Adjust strategies based on changes

### ABC Movement Report

**Purpose**: Analyze demand trends and movement

**How to Run**:
1. ABC Worksheet → Report → "ABC Movement"
2. Set date filter
3. Click "Preview"

**Report Contents**:
- Monthly demand trends by class
- Movement velocity
- Turnover analysis
- Stockout risk assessment

**Use Cases**:
- Forecast future demand
- Identify seasonal patterns
- Adjust inventory policies

### ABC Exceptions Report

**Purpose**: Identify anomalies and outliers

**How to Run**:
1. ABC Worksheet → Report → "ABC Exceptions"
2. Click "Preview"

**Report Contents**:
- **High-value items with low turnover**: A items not selling
- **Low-value items with high stock**: C items overstocked
- **Negative margin items**: Items selling below cost
- **Dead stock**: No movement in analysis period
- **Fast movers with stockouts**: Undersupplied items

**Use Cases**:
- Identify problems
- Clean up dead stock
- Fix pricing issues
- Prevent stockouts

---

## 8. Best Practices

### Analysis Frequency

**Annual Strategic Review**:
- Full ABC/XYZ analysis
- Review thresholds
- Adjust overall strategy

**Quarterly Updates**:
- Refresh classifications
- Track changes
- Adjust for seasonality

**Monthly Monitoring**:
- Review A items only
- Check exceptions
- Address issues

### Threshold Guidelines

**Standard Thresholds** (recommended starting point):
- A: 80% of value
- B: 15% of value
- C: 5% of value

**Aggressive Thresholds** (focus on fewer items):
- A: 70%
- B: 20%
- C: 10%

**Conservative Thresholds** (broader A class):
- A: 85%
- B: 12%
- C: 3%

### Industry-Specific Tips

**Manufacturing**:
- Focus on raw materials and components
- Use A classification for critical components
- Consider lead time in safety stock calculations
- Analyze by BOM level

**Retail**:
- Seasonal adjustments critical
- Analyze by category and location
- Consider shelf space allocation
- Use XYZ for reorder strategies

**Distribution**:
- Multi-location analysis
- Customer-specific ABC for large accounts
- Focus on A items for fill rate targets
- Optimize warehouse layout by class

**Services**:
- Analyze spare parts separately
- Consider criticality beyond value
- Maintenance items may need special treatment

### Data Quality

**Ensure Accurate Costs**:
- Update standard costs regularly
- Use average cost if possible
- Post all cost adjustments

**Complete Sales History**:
- Minimum 6 months data
- 12 months preferred
- Post all invoices promptly

**Cleanse Data**:
- Remove obsolete items
- Consolidate duplicate items
- Update item categories

### Actioning Results

**For A Items**:
1. Review stock levels weekly
2. Set up demand forecasting
3. Negotiate volume discounts
4. Establish backup suppliers
5. Reduce safety stock if possible
6. Monitor daily in high season

**For B Items**:
1. Review monthly
2. Standard reorder points
3. Moderate safety stock
4. Regular supplier reviews

**For C Items**:
1. Bulk ordering for discounts
2. Higher safety stock acceptable
3. Annual review sufficient
4. Consider consignment
5. Evaluate discontinuation of slow movers

### Integration with BC

**Reorder Points**:
- Update item card "Reorder Point" based on class
- A items: Lower reorder point, frequent orders
- C items: Higher reorder point, bulk orders

**Safety Stock**:
- Update item card "Safety Stock Quantity"
- A items: Lower (cost consideration)
- C items: Higher (service level)

**Counting Frequency**:
- Use "Phys. Inventory Counting Period" on item card
- A items: Monthly
- B items: Quarterly
- C items: Annually

---

## 9. Troubleshooting

### Common Issues

#### Issue: No data appears in worksheet

**Possible Causes**:
- No sales in the date range
- Date filter incorrect
- Location filter excludes all data
- Permissions issue

**Solutions**:
1. Check date filter: Ensure format is correct (MM/DD/YYYY..MM/DD/YYYY)
2. Expand date range: Try last 12 months
3. Clear location filter: Test with no location filter
4. Verify permissions: Ensure you have "GSO ABC USER" permission set
5. Check item ledger entries: Verify sales exist in Item Ledger Entries page

#### Issue: All items classified as A or C

**Possible Causes**:
- Thresholds set incorrectly
- Too few items in analysis
- Data distribution issue

**Solutions**:
1. Review thresholds: Check that A+B+C = 100%
2. Verify calculation basis: Try different basis (Sales Amount vs. Quantity)
3. Increase item count: Remove filters that exclude items
4. Check for data anomalies: Very high-value item skewing results

#### Issue: Analysis is very slow

**Possible Causes**:
- Large dataset (>10,000 items)
- Complex date filter
- Multiple locations

**Solutions**:
1. Narrow date range: Analyze shorter periods
2. Filter by location: Run per-location analyses
3. Filter by item category: Analyze in batches
4. Run during off-peak hours

#### Issue: XYZ classifications seem wrong

**Possible Causes**:
- Insufficient data points
- Seasonal business
- New items without history

**Solutions**:
1. Ensure minimum 6 months data: XYZ needs sufficient history
2. Adjust variability thresholds: May need industry-specific thresholds
3. Exclude new items: Filter items with < 6 months history
4. Consider seasonality: Use full-year data for seasonal products

#### Issue: Results don't match expectations

**Possible Causes**:
- Value basis incorrect
- Costs not updated
- Sales not posted
- Filters applied

**Solutions**:
1. Verify value basis: Confirm Sales Amount vs. Quantity
2. Update costs: Post pending cost adjustments
3. Post all invoices: Ensure complete sales history
4. Clear all filters: Start with unfiltered analysis
5. Compare with Item Statistics: Cross-check with standard BC reports

---

## 10. FAQ

### General Questions

**Q: How often should I run ABC analysis?**
A: Quarterly for most businesses. Annually at minimum. Monthly for A items in fast-changing industries.

**Q: Can I change the 80/15/5 thresholds?**
A: Yes! Click "Update Parameters" and adjust percentages. Ensure they sum to 100%.

**Q: Should I analyze all items together or by category?**
A: Both approaches have merit. Start with all items, then drill down by category for detailed strategies.

**Q: What's the minimum data period needed?**
A: 6 months minimum for meaningful results. 12 months ideal for annual planning. More for seasonal businesses.

**Q: How do I handle seasonal items?**
A: Use a full year of data to capture all seasons. Or run separate analyses per season.

### Technical Questions

**Q: Does the extension modify my item master data?**
A: No, it only reads item data. Classifications are stored separately and don't affect item cards.

**Q: Can I export results to Excel?**
A: Yes, use the "Export to Excel" action from the worksheet.

**Q: Does it work with multiple companies in BC?**
A: Yes (Professional and Enterprise plans). Run analysis per company or switch between companies.

**Q: What BC versions are supported?**
A: Business Central version 26.0 and above (cloud and on-premises).

**Q: Can I automate the analysis?**
A: Yes (Enterprise plan), schedule with job queue to run automatically.

### Strategy Questions

**Q: Should I treat all A items the same?**
A: No. Combine with XYZ to differentiate (AX needs different strategy than AZ).

**Q: What if an A item becomes B or C?**
A: This indicates declining demand. Investigate why and adjust inventory/marketing strategy.

**Q: How do I use ABC for pricing?**
A: A items may have less pricing power (customer focus). C items might tolerate price increases without volume impact.

**Q: Can ABC help with warehouse layout?**
A: Yes! Place A items in most accessible locations. C items in back. Optimizes picking efficiency.

**Q: Should I discontinue C items?**
A: Not necessarily. Evaluate strategically:
- Necessary for product line completeness?
- Customer satisfaction impact?
- Margin acceptable despite low volume?
- Carrying cost too high?

---

## Appendix A: Calculation Formulas

### ABC Classification

1. **Calculate item value**:
   - Sales Amount = Σ(Sales Quantity × Unit Price) for date range

2. **Sort items by value** (descending)

3. **Calculate cumulative percentage**:
   - For each item: (Cumulative value up to this item / Total value) × 100

4. **Assign class**:
   - If cumulative% ≤ A threshold → Class A
   - Else if cumulative% ≤ (A + B) threshold → Class B
   - Else → Class C

### XYZ Classification

1. **Calculate monthly demand**:
   - Group sales by month for date range

2. **Calculate statistics**:
   - Average Demand = Σ(Monthly Demand) / Number of Months
   - Standard Deviation = √[Σ(Monthly Demand - Average)² / (N-1)]
   - Coefficient of Variation (CV) = (Std Dev / Average) × 100

3. **Assign class**:
   - If CV ≤ X threshold (default 20%) → Class X
   - Else if CV ≤ Y threshold (default 50%) → Class Y
   - Else → Class Z

### Combined ABC-XYZ Zone

Simply concatenate: ABC Class + XYZ Class
- Examples: AX, BY, CZ

---

## Appendix B: Quick Reference Card

### Keyboard Shortcuts
- **Alt+Q**: Open search
- **Ctrl+F**: Find in worksheet
- **Ctrl+E**: Export to Excel
- **F5**: Refresh data

### Default Thresholds
- **ABC**: 80% / 15% / 5%
- **XYZ**: 20% / 50%

### Recommended Review Frequency
- **A items**: Weekly
- **B items**: Monthly
- **C items**: Quarterly

### Standard Actions
1. Set parameters
2. Calculate classification
3. Review results
4. Run reports
5. Take action

---

## Support

**Documentation**: https://www.gmsoft.co.uk/abc_help/
**Email**: support@gmsoft.co.uk
**Response Time**:
- Basic: 48 hours
- Professional: 24 hours
- Enterprise: 4 hours

---

**Document Version**: 1.0
**Last Updated**: 2025
**Extension Version**: 1.1.0.0
