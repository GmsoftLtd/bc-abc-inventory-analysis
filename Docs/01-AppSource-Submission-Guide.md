# AppSource Submission Guide - ABC Analysis Extension
**Complete Step-by-Step Process for Microsoft AppSource**

---

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Partner Center Setup](#partner-center-setup)
3. [Creating Your Offer](#creating-your-offer)
4. [Offer Configuration](#offer-configuration)
5. [Technical Validation](#technical-validation)
6. [Publishing Process](#publishing-process)
7. [Post-Publication](#post-publication)

---

## 1. Prerequisites

### Required Accounts & Registrations
- [ ] **Microsoft Partner Network (MPN) Account**
  - Register at: https://partner.microsoft.com
  - Complete company verification
  - Note your MPN ID

- [ ] **Partner Center Account**
  - Access: https://partner.microsoft.com/dashboard
  - Enroll in Commercial Marketplace program
  - Complete tax and payout profiles

- [ ] **Azure Active Directory**
  - Create or use existing Azure AD tenant
  - Add users who will manage the offer

### Technical Requirements
- [ ] **Object ID Range Registered**
  - Current range: 73030575 - 73031574
  - Verify registration at: https://aka.ms/BCPublisherRange

- [ ] **Publisher Prefix Registered**
  - Current prefix: GSO
  - Register at: https://aka.ms/BCPublisherAffixes

- [ ] **Code Validation**
  - Run AppSourceCop analyzer
  - Pass all validation rules
  - Test in BC sandbox environment

---

## 2. Partner Center Setup

### Step 1: Create Commercial Marketplace Account
1. Sign in to [Partner Center](https://partner.microsoft.com/dashboard)
2. Navigate to **Settings** (gear icon) → **Account settings**
3. Select **Programs** → **Enrollment**
4. Click **Get Started** under Commercial Marketplace
5. Complete enrollment:
   - Accept Marketplace Publisher Agreement
   - Provide tax information (W-9 or W-8 form)
   - Set up payout account (bank details)

### Step 2: Configure Publisher Profile
1. Go to **Account settings** → **Organization profile**
2. Update **Publisher profile**:
   - Legal business name: **GMSOFT**
   - Publisher display name: **GMSOFT**
   - Contact email: your-support@gmsoft.co.uk
   - Support URL: https://www.gmsoft.co.uk/support

### Step 3: Set Up Lead Management (Optional)
1. Navigate to **Referrals** → **Lead management**
2. Configure CRM connection:
   - Dynamics 365 Customer Engagement
   - Salesforce
   - Marketo
   - Azure Table Storage
   - HTTPS Endpoint

---

## 3. Creating Your Offer

### Step 1: Initiate New Offer
1. Go to **Marketplace offers** in Partner Center
2. Click **+ New offer**
3. Select **Dynamics 365 Business Central**
4. Fill in the dialog:
   ```
   Offer ID: abc-analysis-gmsoft
   (Lowercase, no spaces, max 40 chars - CANNOT be changed)

   Offer alias: ABC Analysis for Business Central
   (Internal name - can be changed)
   ```
5. Click **Create**

### Step 2: Choose Offer Type
- **Package type**: Add-on app
- **Transaction method**: Sell through Microsoft (Transactable)

---

## 4. Offer Configuration

### Offer Setup Tab
1. **Alias**: ABC Analysis for Business Central
2. **Test drive**: Not enabled (optional)
3. **Customer leads**: Configure if using CRM
4. **Properties**:
   - Categories: Operations & Supply Chain → Inventory
   - Industries: Manufacturing, Retail, Wholesale
   - Legal: Standard Contract

### Properties Tab
1. **Category**:
   - Primary: Operations & Supply Chain
   - Sub-category: Inventory Management
2. **Industries** (select up to 2):
   - Manufacturing
   - Retail
3. **App version**: 1.1.0.0
4. **Legal**:
   - [ ] Use Standard Contract for Microsoft's commercial marketplace
   - EULA URL: https://www.GMsoft.co.uk/abc_eula/
   - Privacy Policy URL: https://www.GMsoft.co.uk/privacy_statement/

### Offer Listing Tab

#### Listing Details
```
Name: ABC Analysis - Inventory Optimization Suite

Search results summary (50-100 chars):
Advanced ABC & XYZ analysis to optimize inventory, reduce costs, and improve stock efficiency

Description (3000-5000 chars):
# Transform Your Inventory Management

ABC Analysis - Inventory Optimization Suite brings enterprise-level inventory classification to Microsoft Dynamics 365 Business Central. Reduce carrying costs by 25-30% while improving service levels through intelligent, data-driven inventory categorization.

## Key Features

### ABC Classification
- **Value-Based Analysis**: Automatically classify inventory based on annual consumption value
- **Pareto Principle**: Focus on the vital few items that drive 80% of your value
- **Multi-Dimensional**: Analyze by value, quantity, margin, or custom criteria

### XYZ Matrix Analysis
- **Demand Variability**: Classify items by consumption consistency
- **Predictability Scoring**: Identify stable vs. volatile demand patterns
- **Strategic Planning**: Combine ABC/XYZ for 9-zone strategic matrix

### Powerful Reporting Suite
- **ABC Distribution Report**: Visual breakdown of inventory classes
- **ABC Detail by Class**: Deep dive into each classification
- **ABC Comparison Report**: Track classification changes over time
- **ABC Movement Analysis**: Understand item transitions
- **Exception Reports**: Identify outliers and anomalies

### Business Benefits
✓ Reduce inventory carrying costs by 25-30%
✓ Optimize stock levels based on item importance
✓ Improve cash flow through better working capital management
✓ Focus purchasing efforts on high-value items
✓ Reduce stockouts on critical items
✓ Minimize obsolescence on slow-moving inventory

## Perfect For
- Manufacturing companies managing raw materials and components
- Distributors and wholesalers with diverse product portfolios
- Retail businesses optimizing stock across multiple locations
- Any organization seeking data-driven inventory optimization

## Multi-Language Support
Fully localized for: English (US), German, French, Dutch, Italian, Greek

## Pricing
- **30-Day Free Trial** - Full functionality, no credit card required
- **Basic**: $49.99/month - Essential features for single company
- **Professional**: $99.99/month - Multi-company with advanced analytics
- **Enterprise**: $199.99/month - Complete solution with premium support

## Support & Resources
- Comprehensive documentation and user guides
- Video tutorials and training materials
- Email support (Priority support for Pro/Enterprise)
- Regular updates and feature enhancements

Start your free trial today and transform your inventory management!
```

#### Supporting Links
- **Privacy policy URL**: https://www.GMsoft.co.uk/privacy_statement/
- **Support URL**: https://www.GMsoft.co.uk/abc_help/
- **Help link**: https://www.GMsoft.co.uk/abc_help/

#### Contact Information
- **Engineering contact**:
  - Name: [Your Name]
  - Email: support@gmsoft.co.uk
  - Phone: [Your Phone]

- **Support contact**:
  - Name: GMSOFT Support Team
  - Email: support@gmsoft.co.uk
  - Phone: [Support Phone]

#### Marketing Assets

**Logos** (PNG format, transparent background):
- Small: 48×48 px (abc-inventory-48.png)
- Medium: 90×90 px (abc-inventory-90.png)
- Large: 216×216 px (abc-inventory-216.png)
- Wide: 255×115 px (abc-inventory-wide.png)

**Screenshots** (1280×720 px, PNG):
1. ABC Worksheet - Main analysis interface
2. XYZ Matrix - Demand variability grid
3. ABC Distribution Report - Visual charts
4. ABC Comparison - Historical trends
5. Exception Report - Outlier identification

**Videos** (Optional but recommended):
- Product overview (60-90 seconds)
- Feature demonstration (2-3 minutes)
- Customer testimonial (if available)
- Upload to YouTube/Vimeo, provide URL

**Documents** (PDF format):
- Product brochure
- User guide overview
- Implementation checklist
- ROI calculator

### Plan Overview (Pricing)

#### Plan 1: Basic
- **Plan ID**: basic-plan
- **Plan name**: Basic
- **Description**: Essential ABC Analysis for single company
- **Pricing model**: Flat rate
- **Monthly price**: $49.99 USD
- **Annual price**: $499.99 USD (16% discount)
- **Free trial**: 30 days
- **Markets**: All available markets

**Features included**:
- ABC Classification (Value-based)
- XYZ Matrix Analysis
- Up to 5,000 items
- Basic reports and exports
- Email support

#### Plan 2: Professional
- **Plan ID**: professional-plan
- **Plan name**: Professional
- **Description**: Advanced analytics for growing businesses
- **Pricing model**: Flat rate
- **Monthly price**: $99.99 USD
- **Annual price**: $999.99 USD (16% discount)
- **Free trial**: 30 days
- **Markets**: All available markets

**Features included**:
- All Basic features
- Multi-company support
- Unlimited items
- Advanced reporting suite (5 reports)
- Historical trend analysis
- Priority email support

#### Plan 3: Enterprise
- **Plan ID**: enterprise-plan
- **Plan name**: Enterprise
- **Description**: Complete solution with premium support
- **Pricing model**: Flat rate
- **Monthly price**: $199.99 USD
- **Annual price**: $1,999.99 USD (16% discount)
- **Free trial**: 30 days
- **Markets**: All available markets

**Features included**:
- All Professional features
- Custom classification rules
- API access for integrations
- Automated scheduling
- Dedicated support
- Training and onboarding included

### Markets Tab
Select target markets:
- [ ] United States
- [ ] United Kingdom
- [ ] Canada
- [ ] Germany
- [ ] France
- [ ] Netherlands
- [ ] Italy
- [ ] Greece
- [ ] Australia
- [ ] (Select all applicable markets)

---

## 5. Technical Validation

### Pre-Submission Checklist
- [ ] App compiles without errors
- [ ] AppSourceCop validation passes
- [ ] All objects within registered ID range (73030575-73031574)
- [ ] All objects use GSO prefix
- [ ] Permission sets defined (no SUPER required)
- [ ] Data sensitivity labels applied
- [ ] Translation files included
- [ ] Help links functional
- [ ] Privacy policy published
- [ ] EULA published
- [ ] Support documentation available

### Validation Commands
```powershell
# Install AL Development Tools
Install-Module -Name BcContainerHelper

# Run validation
Run-AlValidation `
    -appFile "C:\path\to\GMSOFT_ABC_ANALYSIS_1.1.0.0.app" `
    -countries "US,UK,DE,FR,IT,NL,GR" `
    -validateCurrent `
    -validateNextMinor `
    -validateNextMajor
```

### Package Upload
1. Navigate to **Technical configuration** tab
2. Upload your .app file:
   - File: `GMSOFT_ABC_ANALYSIS_1.1.0.0.app`
   - Version: 1.1.0.0
   - Supported BC versions: 26.0 and above
3. Add app dependencies (if any)
4. Configure app settings:
   - Runtime version: 15.0
   - Platform version: 26.0.0.0

---

## 6. Publishing Process

### Step 1: Review and Publish
1. Click **Review and publish** in Partner Center
2. Verify all sections have green checkmarks:
   - [ ] Offer setup
   - [ ] Properties
   - [ ] Offer listing
   - [ ] Plan overview
   - [ ] Technical configuration
3. Click **Publish**

### Step 2: Validation Process
**Microsoft performs automated validation (2-5 business days)**:
1. Security scan
2. Malware detection
3. AppSourceCop validation
4. Compatibility testing across BC versions
5. Performance testing
6. Accessibility compliance

### Step 3: Certification
**Microsoft manual review (3-7 business days)**:
1. Functionality testing
2. Documentation review
3. Compliance verification
4. Brand/trademark check
5. Content appropriateness

### Step 4: Publishing
Once approved:
1. Receive approval notification
2. Offer goes live within 4 hours
3. Available on AppSource marketplace
4. Listed in BC App marketplace

**Total Timeline**: 7-14 business days typical

---

## 7. Post-Publication

### Monitor Performance
1. **Analytics Dashboard** (Partner Center):
   - Downloads and installations
   - Trial conversions
   - Revenue metrics
   - Customer demographics

2. **Customer Reviews**:
   - Monitor AppSource reviews
   - Respond to feedback promptly
   - Address issues quickly

### Updates & Maintenance
**Publishing Updates**:
1. Create new version in Partner Center
2. Upload updated .app file
3. Update version notes
4. Submit for validation
5. Automatic update for existing customers

**Best Practices**:
- Maintain backward compatibility
- Test thoroughly before updates
- Communicate changes to customers
- Follow semantic versioning (Major.Minor.Patch)

### Marketing & Promotion
- Share AppSource link on website
- Email existing customers
- Social media announcements
- Blog posts about features
- Customer success stories
- Partner with Microsoft field sellers

---

## Important URLs

- **Partner Center**: https://partner.microsoft.com/dashboard
- **AppSource**: https://appsource.microsoft.com
- **Documentation**: https://learn.microsoft.com/dynamics365/business-central/dev-itpro/developer/devenv-checklist-submission
- **Object ID Registration**: https://aka.ms/BCPublisherRange
- **Prefix Registration**: https://aka.ms/BCPublisherAffixes
- **Technical Validation**: https://aka.ms/BcAlValidation

---

## Support Contacts

**Microsoft Partner Support**:
- Phone: 1-800-PARTNER (US)
- Email: mpnsupport@microsoft.com
- Hours: 24/7 for technical issues

**AppSource Support**:
- Partner Center → Help + Support
- Submit support request for publishing issues

---

## Checklist Summary

### Before Starting
- [ ] MPN account created and verified
- [ ] Partner Center enrollment complete
- [ ] Tax and payout information submitted
- [ ] Object IDs and prefix registered
- [ ] App tested and validated

### Offer Creation
- [ ] Offer created with unique ID
- [ ] All listing details completed
- [ ] Logos prepared and uploaded (4 sizes)
- [ ] Screenshots prepared (5 images, 1280×720)
- [ ] Video created and URL added
- [ ] Support documents prepared (PDFs)
- [ ] Pricing plans configured
- [ ] Markets selected
- [ ] .app file uploaded

### Publication
- [ ] All validation checks passed
- [ ] Review and publish submitted
- [ ] Microsoft validation approved
- [ ] Offer live on AppSource

### Post-Launch
- [ ] Monitor analytics dashboard
- [ ] Respond to customer reviews
- [ ] Plan update schedule
- [ ] Market and promote offer

---

**Document Version**: 1.0
**Last Updated**: 2025
**Contact**: support@gmsoft.co.uk
