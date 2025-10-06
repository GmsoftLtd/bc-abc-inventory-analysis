import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.utils import get_column_letter

# Data extracted from the codebase
objects = [
    ("Codeunit", 73030575, "GMO Load Test Data - Inventory"),
    ("Codeunit", 73030576, "GMO ABC Analysis Job"),
    ("Codeunit", 73030577, "GMO ABC Install"),
    ("Codeunit", 73030578, "GMO ABC Upgrade"),
    ("Codeunit", 73030579, "GMO ABC Upgrade Helper"),
    ("Codeunit", 73030580, "GMO ABC Job Queue Helper"),
    ("Codeunit", 73030581, "GMO ABC Telemetry"),
    ("Codeunit", 73030582, "GMO ABC Analysis Mgt."),
    ("Codeunit", 73030583, "GMO ABC Worksheet Export"),
    ("Codeunit", 73030584, "GMO ABC Worksheet Stats"),
    ("Codeunit", 73030585, "GMO ABC Upgrade v2"),
    ("Codeunit", 73030586, "GMO ABC Upgrade Helper v2"),
    ("Enum", 73030575, "GMO ABC Class"),
    ("Enum", 73030576, "GMO ABC Model"),
    ("Page", 73030575, "GMO ABC Analysis Setup"),
    ("Page", 73030576, "GMO ABC Counting Policy List"),
    ("Page", 73030577, "GMO ABC Count Policy Subform"),
    ("Page", 73030578, "GMO ABC Counting Policy Card"),
    ("Page", 73030579, "GMO ABC Counting Policy Lines"),
    ("Page", 73030580, "GMO ABC Worksheet"),
    ("Page", 73030581, "GMO ABC Worksheet Params"),
    ("Page", 73030582, "GMO ABC Stats Part"),
    ("Page", 73030583, "GMO ABC History"),
    ("Page", 73030584, "GMO ABC History Lines"),
    ("Page", 73030585, "GMO ABC History Card"),
    ("Page", 73030586, "GMO Load Test Runner"),
    ("PageExtension", 73030575, "GMO Item Card Ext."),
    ("PageExtension", 73030576, "GMO Item List Ext."),
    ("PageExtension", 73030577, "GMO ABC Inventory Manager RC"),
    ("PageExtension", 73030578, "GMO SKU Card Ext."),
    ("PermissionSet", 73030575, "GMO ABC ANALYSIS"),
    ("PermissionSet", 73030576, "GMO ABC MANAGER"),
    ("PermissionSet", 73030577, "GMO ABC ADMIN"),
    ("PermissionSet", 73030578, "GMO ABC USER"),
    ("Report", 73030575, "GMO ABC Distribution"),
    ("Report", 73030576, "GMO ABC Item Movement"),
    ("Report", 73030577, "GMO ABC Analysis"),
    ("Report", 73030578, "GMO ABC Exceptions"),
    ("Report", 73030579, "GMO ABC Comparison"),
    ("Report", 73030580, "GMO ABC Detail by Class"),
    ("Table", 73030575, "GMO ABC Analysis Setup"),
    ("Table", 73030576, "GMO ABC Upgrade Tag"),
    ("Table", 73030577, "GMO ABC Counting Policy Header"),
    ("Table", 73030578, "GMO ABC Counting Policy Line"),
    ("Table", 73030579, "GMO ABC Preview Line"),
    ("Table", 73030580, "GMO ABC History Header"),
    ("Table", 73030581, "GMO ABC History Line"),
    ("Table", 73030582, "GMO ABC Stats"),
    ("TableExtension", 73030575, "GMO ABC Item Ext."),
    ("TableExtension", 73030576, "GMO ABC SKU Ext."),
]

# Sort objects by type and then by ID
objects.sort(key=lambda x: (x[0], x[1]))

# Create workbook
wb = openpyxl.Workbook()
ws = wb.active
ws.title = "ABC Basic"

# Header styling
header_fill = PatternFill(start_color="4472C4", end_color="4472C4", fill_type="solid")
header_font = Font(color="FFFFFF", bold=True, size=11)
header_alignment = Alignment(horizontal="center", vertical="center")

# Add headers
ws['A1'] = "Object Type"
ws['B1'] = "ID"
ws['C1'] = "Object Name"

for cell in ['A1', 'B1', 'C1']:
    ws[cell].fill = header_fill
    ws[cell].font = header_font
    ws[cell].alignment = header_alignment

# Add data
row = 2
for obj_type, obj_id, obj_name in objects:
    ws[f'A{row}'] = obj_type
    ws[f'B{row}'] = obj_id
    ws[f'C{row}'] = obj_name
    row += 1

# Adjust column widths
ws.column_dimensions['A'].width = 20
ws.column_dimensions['B'].width = 15
ws.column_dimensions['C'].width = 40

# Create summary worksheet
ws_summary = wb.create_sheet("Summary by Object Type")

# Add summary headers
ws_summary['A1'] = "Object Type"
ws_summary['B1'] = "Count"
ws_summary['C1'] = "First ID"
ws_summary['D1'] = "Last ID"

for cell in ['A1', 'B1', 'C1', 'D1']:
    ws_summary[cell].fill = header_fill
    ws_summary[cell].font = header_font
    ws_summary[cell].alignment = header_alignment

# Calculate summary by object type
summary = {}
for obj_type, obj_id, obj_name in objects:
    if obj_type not in summary:
        summary[obj_type] = {"count": 0, "ids": []}
    summary[obj_type]["count"] += 1
    summary[obj_type]["ids"].append(obj_id)

# Add summary data
row = 2
for obj_type in sorted(summary.keys()):
    ws_summary[f'A{row}'] = obj_type
    ws_summary[f'B{row}'] = summary[obj_type]["count"]
    ws_summary[f'C{row}'] = min(summary[obj_type]["ids"])
    ws_summary[f'D{row}'] = max(summary[obj_type]["ids"])
    row += 1

# Adjust column widths for summary
ws_summary.column_dimensions['A'].width = 20
ws_summary.column_dimensions['B'].width = 12
ws_summary.column_dimensions['C'].width = 15
ws_summary.column_dimensions['D'].width = 15

# Save the file
output_path = r"C:\GMSoft\OneDrive - Gmsoft\Applications\GMSOFT Apps.xlsx"
wb.save(output_path)
print(f"Excel file created successfully at: {output_path}")
print(f"Total objects: {len(objects)}")
print(f"Object types: {len(summary)}")
