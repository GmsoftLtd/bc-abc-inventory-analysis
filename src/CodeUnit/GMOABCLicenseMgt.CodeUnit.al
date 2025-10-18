codeunit 73030590 "GMO ABC License Mgt."
{
    Access = Public;

    var
        LicenseNotActiveErr: Label 'You do not have an active license for ABC Inventory Optimizer. Please purchase a subscription through Microsoft AppSource.';
        LicenseExpiredErr: Label 'Your ABC Inventory Optimizer license has expired. Please renew your subscription through Microsoft AppSource.';
        NoLicenseErr: Label 'No valid license found for ABC Inventory Optimizer. Please contact your administrator or purchase a subscription through Microsoft AppSource.';

    /// <summary>
    /// Checks if the current user has a valid license for ABC Inventory Optimizer.
    /// </summary>
    /// <returns>True if the user has a valid license, false otherwise.</returns>
    procedure HasValidLicense(): Boolean
    begin
        // For Cloud apps, entitlement checking is automatic through the permission system
        // If user has access to this codeunit, they have the entitlement
        // The entitlement object defines which objects users can access
        // So we check if user has permission to key objects
        exit(HasPermissionToAnalysis());
    end;

    local procedure HasPermissionToAnalysis(): Boolean
    var
        Setup: Record "GMO ABC Analysis Setup";
    begin
        // If user can read the setup table (which is part of the entitlement permission set),
        // then they have the license. This is implicit entitlement checking.
        exit(Setup.ReadPermission());
    end;

    /// <summary>
    /// Validates that the current user has a valid license and throws an error if not.
    /// Use this at the entry point of premium features.
    /// </summary>
    procedure ValidateLicense()
    begin
        if not HasValidLicense() then
            Error(NoLicenseErr);
    end;

    /// <summary>
    /// Gets the current license status for display purposes.
    /// </summary>
    /// <returns>License status enum value.</returns>
    procedure GetLicenseStatus(): Enum "GMO ABC License Status"
    begin
        if HasValidLicense() then
            exit("GMO ABC License Status"::Active)
        else
            exit("GMO ABC License Status"::Unknown);
    end;

    /// <summary>
    /// Gets a text description of the current license status.
    /// </summary>
    /// <returns>Human-readable license status text.</returns>
    procedure GetLicenseStatusText(): Text[50]
    var
        Status: Enum "GMO ABC License Status";
    begin
        Status := GetLicenseStatus();
        exit(Format(Status));
    end;

    /// <summary>
    /// Check if user has access to run ABC analysis features.
    /// </summary>
    procedure CanRunAnalysis(): Boolean
    begin
        exit(HasValidLicense());
    end;

    /// <summary>
    /// Check if user has access to view ABC reports.
    /// </summary>
    procedure CanViewReports(): Boolean
    begin
        exit(HasValidLicense());
    end;

    /// <summary>
    /// Check if user has access to modify ABC setup.
    /// </summary>
    procedure CanModifySetup(): Boolean
    begin
        exit(HasValidLicense());
    end;
}
