# Create Excel file using PowerShell and Excel COM objects

# Data extracted from the codebase
$objects = @(
    @{Type="Codeunit"; ID=73030575; Name="GMO Load Test Data - Inventory"},
    @{Type="Codeunit"; ID=73030576; Name="GMO ABC Analysis Job"},
    @{Type="Codeunit"; ID=73030577; Name="GMO ABC Install"},
    @{Type="Codeunit"; ID=73030578; Name="GMO ABC Upgrade"},
    @{Type="Codeunit"; ID=73030579; Name="GMO ABC Upgrade Helper"},
    @{Type="Codeunit"; ID=73030580; Name="GMO ABC Job Queue Helper"},
    @{Type="Codeunit"; ID=73030581; Name="GMO ABC Telemetry"},
    @{Type="Codeunit"; ID=73030582; Name="GMO ABC Analysis Mgt."},
    @{Type="Codeunit"; ID=73030583; Name="GMO ABC Worksheet Export"},
    @{Type="Codeunit"; ID=73030584; Name="GMO ABC Worksheet Stats"},
    @{Type="Codeunit"; ID=73030585; Name="GMO ABC Upgrade v2"},
    @{Type="Codeunit"; ID=73030586; Name="GMO ABC Upgrade Helper v2"},
    @{Type="Enum"; ID=73030575; Name="GMO ABC Class"},
    @{Type="Enum"; ID=73030576; Name="GMO ABC Model"},
    @{Type="Page"; ID=73030575; Name="GMO ABC Analysis Setup"},
    @{Type="Page"; ID=73030576; Name="GMO ABC Counting Policy List"},
    @{Type="Page"; ID=73030577; Name="GMO ABC Count Policy Subform"},
    @{Type="Page"; ID=73030578; Name="GMO ABC Counting Policy Card"},
    @{Type="Page"; ID=73030579; Name="GMO ABC Counting Policy Lines"},
    @{Type="Page"; ID=73030580; Name="GMO ABC Worksheet"},
    @{Type="Page"; ID=73030581; Name="GMO ABC Worksheet Params"},
    @{Type="Page"; ID=73030582; Name="GMO ABC Stats Part"},
    @{Type="Page"; ID=73030583; Name="GMO ABC History"},
    @{Type="Page"; ID=73030584; Name="GMO ABC History Lines"},
    @{Type="Page"; ID=73030585; Name="GMO ABC History Card"},
    @{Type="Page"; ID=73030586; Name="GMO Load Test Runner"},
    @{Type="PageExtension"; ID=73030575; Name="GMO Item Card Ext."},
    @{Type="PageExtension"; ID=73030576; Name="GMO Item List Ext."},
    @{Type="PageExtension"; ID=73030577; Name="GMO ABC Inventory Manager RC"},
    @{Type="PageExtension"; ID=73030578; Name="GMO SKU Card Ext."},
    @{Type="PermissionSet"; ID=73030575; Name="GMO ABC ANALYSIS"},
    @{Type="PermissionSet"; ID=73030576; Name="GMO ABC MANAGER"},
    @{Type="PermissionSet"; ID=73030577; Name="GMO ABC ADMIN"},
    @{Type="PermissionSet"; ID=73030578; Name="GMO ABC USER"},
    @{Type="Report"; ID=73030575; Name="GMO ABC Distribution"},
    @{Type="Report"; ID=73030576; Name="GMO ABC Item Movement"},
    @{Type="Report"; ID=73030577; Name="GMO ABC Analysis"},
    @{Type="Report"; ID=73030578; Name="GMO ABC Exceptions"},
    @{Type="Report"; ID=73030579; Name="GMO ABC Comparison"},
    @{Type="Report"; ID=73030580; Name="GMO ABC Detail by Class"},
    @{Type="Table"; ID=73030575; Name="GMO ABC Analysis Setup"},
    @{Type="Table"; ID=73030576; Name="GMO ABC Upgrade Tag"},
    @{Type="Table"; ID=73030577; Name="GMO ABC Counting Policy Header"},
    @{Type="Table"; ID=73030578; Name="GMO ABC Counting Policy Line"},
    @{Type="Table"; ID=73030579; Name="GMO ABC Preview Line"},
    @{Type="Table"; ID=73030580; Name="GMO ABC History Header"},
    @{Type="Table"; ID=73030581; Name="GMO ABC History Line"},
    @{Type="Table"; ID=73030582; Name="GMO ABC Stats"},
    @{Type="TableExtension"; ID=73030575; Name="GMO ABC Item Ext."},
    @{Type="TableExtension"; ID=73030576; Name="GMO ABC SKU Ext."}
)

# Sort objects by type and then by ID
$objects = $objects | Sort-Object -Property Type, ID

# Create Excel COM object
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$workbook = $excel.Workbooks.Add()

# Remove extra sheets, keep only the first one
while ($workbook.Worksheets.Count -gt 1) {
    $workbook.Worksheets.Item(2).Delete()
}

# Rename first sheet
$sheet = $workbook.Worksheets.Item(1)
$sheet.Name = "ABC Basic"

# Add headers
$sheet.Cells.Item(1, 1) = "Object Type"
$sheet.Cells.Item(1, 2) = "ID"
$sheet.Cells.Item(1, 3) = "Object Name"

# Format headers
$headerRange = $sheet.Range("A1:C1")
$headerRange.Font.Bold = $true
$headerRange.Font.Color = 16777215  # White
$headerRange.Interior.Color = 4474052  # Blue
$headerRange.HorizontalAlignment = -4108  # Center

# Add data
$row = 2
foreach ($obj in $objects) {
    $sheet.Cells.Item($row, 1) = $obj.Type
    $sheet.Cells.Item($row, 2) = $obj.ID
    $sheet.Cells.Item($row, 3) = $obj.Name
    $row++
}

# Auto-fit columns
$sheet.Columns.Item(1).ColumnWidth = 20
$sheet.Columns.Item(2).ColumnWidth = 15
$sheet.Columns.Item(3).ColumnWidth = 40

# Create summary worksheet
$summarySheet = $workbook.Worksheets.Add()
$summarySheet.Name = "ABC Summary"

# Add summary headers
$summarySheet.Cells.Item(1, 1) = "Object Type"
$summarySheet.Cells.Item(1, 2) = "Count"
$summarySheet.Cells.Item(1, 3) = "First ID"
$summarySheet.Cells.Item(1, 4) = "Last ID"

# Format summary headers
$summaryHeaderRange = $summarySheet.Range("A1:D1")
$summaryHeaderRange.Font.Bold = $true
$summaryHeaderRange.Font.Color = 16777215  # White
$summaryHeaderRange.Interior.Color = 4474052  # Blue
$summaryHeaderRange.HorizontalAlignment = -4108  # Center

# Calculate summary by object type
$summary = @{}
foreach ($obj in $objects) {
    if (-not $summary.ContainsKey($obj.Type)) {
        $summary[$obj.Type] = @{
            Count = 0
            IDs = @()
        }
    }
    $summary[$obj.Type].Count++
    $summary[$obj.Type].IDs += $obj.ID
}

# Add summary data
$row = 2
foreach ($type in ($summary.Keys | Sort-Object)) {
    $summarySheet.Cells.Item($row, 1) = $type
    $summarySheet.Cells.Item($row, 2) = $summary[$type].Count
    $summarySheet.Cells.Item($row, 3) = ($summary[$type].IDs | Measure-Object -Minimum).Minimum
    $summarySheet.Cells.Item($row, 4) = ($summary[$type].IDs | Measure-Object -Maximum).Maximum
    $row++
}

# Auto-fit columns for summary
$summarySheet.Columns.Item(1).ColumnWidth = 20
$summarySheet.Columns.Item(2).ColumnWidth = 12
$summarySheet.Columns.Item(3).ColumnWidth = 15
$summarySheet.Columns.Item(4).ColumnWidth = 15

# Move "ABC Basic" sheet to the first position
$sheet.Move($workbook.Worksheets.Item(1))

# Save the file
$outputPath = "C:\GMSoft\OneDrive - Gmsoft\Applications\GMSOFT Apps.xlsx"
$workbook.SaveAs($outputPath)
$workbook.Close()
$excel.Quit()

# Release COM objects
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($summarySheet) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheet) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

Write-Host "Excel file created successfully at: $outputPath"
Write-Host "Total objects: $($objects.Count)"
Write-Host "Object types: $($summary.Count)"
