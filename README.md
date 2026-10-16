# SparkNest Salesforce Capstone Project

Complete enterprise implementation for **SparkNest**, a direct-to-consumer and B2B electronics and smart home retailer, built on Salesforce Developer Edition.

## 🚀 Overview

- **Target Org:** `SparkNestDevOrg` (`singhshweta3024.584f9afd844e@agentforce.com`)
- **API Version:** 68.0 / 60.0
- **Apex Code Coverage:** 96% org-wide (17/17 tests passing)
- **Live Demo Script:** See [`DEMO_SCRIPT.md`](./DEMO_SCRIPT.md) for the 15-minute presentation guide.

---

## 🛠️ Architecture & Features

### 1. Data Model & Junction Object (Task 1 & 4)
- **`Enquiry__c`**: Core custom object (`ENQ-{0000}`) tracking pre-sales and care plan queries.
- **`Enquiry_Product__c`**: Junction object linking `Enquiry__c` to standard `Product2` with fields `Product__c`, `Quantity_Interested__c`, and `Notes__c`.
- **Custom Rollup Trigger**: `EnquiryProductTrigger` delegating to `EnquiryProductService` dynamically calculates and updates `Total_Products_Interested__c` across insert, update (reparenting), delete, and undelete operations.
- **Seed Data**: 8 products across 4 categories (Personal Devices, Smart Home, Accessories, Annual Care Plans) with unique `SKU__c` external IDs; 10 contacts with duplicate rules on matching email.

### 2. Security & Sharing Model (Task 2)
- **OWD**: `Enquiry__c` is **Private**, `Case` is **Public Read Only**, `Contact` is **Public Read Only**.
- **Role Hierarchy**: Structured strictly under `CEO`:
  - `Sales Manager` -> `Sales Rep — Hyderabad` & `Sales Rep — Mumbai`
  - `Support Manager` -> `Support Agent — Hyderabad` & `Support Agent — Mumbai`
- **Profiles & Permission Sets**:
  - `SparkNest Sales Rep` (CRED on `Enquiry__c`, no Case access)
  - `SparkNest Support Agent` (Read on `Enquiry__c`, Read/Edit on `Case`)
  - `Senior_Sales_Rep` Permission Set assigned to **Arjun Sharma** adding Delete on `Enquiry__c`, Read on `Case`, and Custom Permission `View_Customer_Budget`.
- **Criteria-Based Sharing Rule**: Shares `Care Plan Enquiry` records with Support Agent roles (Read Only).

### 3. Lightning Experience & Dynamic Forms (Task 3)
- **Apps**: `SparkNest Sales` and `SparkNest Support` customized with relevant tabs.
- **Dynamic Forms**:
  - `Plan_Duration__c` visible only when `Enquiry_Type__c == 'Care Plan Enquiry'`.
  - `Source__c` visible only when `Enquiry_Type__c == 'Product Enquiry'`.
  - `Customer_Budget__c` conditionally visible only to users with custom permission `View_Customer_Budget`.
  - `Enquiry Products` related list configured with quick actions.
- **List Views & Search Layouts**: `My Open Enquiries`, `Care Plan Enquiries`, `This Week's Enquiries`.

### 4. Process Automation & Flows (Task 5)
- **Screen Flow (`Convert_Enquiry_to_Case`)**: Launched via Quick Action `Convert to Case` on `Enquiry__c`. Collects Priority & Description, routes case automatically to `Care_Plan_Support` or `General_Support` queue, auto-updates Enquiry `Status__c = 'Closed'`, and shows confirmation screen with generated `CaseNumber`.
- **Record-Triggered Flow (`Auto_close_Follow_up_Tasks`)**: Fires after Enquiry status changes to `Closed`, automatically completing open tasks.
- **Scheduled Flow (`Weekly_Enquiry_Summary`)**: Runs weekly, aggregating enquiries created over the past 7 days and assigning an overview task to Sales Manager **Vikram Kumar**.

### 5. Apex Framework & Batch Apex (Task 6)
- **Trigger Framework**: Thin triggers (`EnquiryTrigger`, `EnquiryProductTrigger`) -> `TriggerDispatcher` -> `EnquiryTriggerHandler` -> `EnquiryService`.
- **Business Logic Enforced**:
  - Blank `Status__c` defaults to `'New'`.
  - Customer budget validated >= ₹1,000.
  - Auto-creation of 3-day follow-up tasks on insert.
  - Auto-stamping of `Closed_Date__c = System.today()` on closure.
- **Batch & Scheduler**: `CloseStaleEnquiriesBatch` closes inactive enquiries older than 30 days; scheduled nightly via `CloseStaleEnquiriesScheduler`.

### 6. Integrations & APIs (Task 7)
- **Custom REST API (`SparkNestEnquiryAPI`)**: Exposed at `/services/apexrest/SparkNestEnquiry/`:
  - Scenario 1 (New Customer): Creates Contact + Enquiry -> 201 Created.
  - Scenario 2 (Existing Customer): Matches existing Contact by email -> 201 Created.
  - Scenario 3 (Missing Email): Validates input, returns structured HTTP 400 with `'Email is required'`.
- **Composite API**: Atomic creation of Contact + Enquiry linked via `@{refContact.id}` with `allOrNone: true`, including rollback verification.
- **Postman Collection**: Located in [`postman/SparkNest.postman_collection.json`](./postman/SparkNest.postman_collection.json).

### 7. Reports & Dynamic Dashboards (Task 8)
- **Folder**: `SparkNest Reports` (public folder).
- **Reports**:
  1. `Enquiries by Type` (Summary report with Donut chart).
  2. `My Open Enquiries` (Tabular report filtered to active enquiries).
  3. `Conversion Rate by Source` (Summary/Stacked Column report).
  4. `Weekly Enquiry Volume` (Summary report with Line chart).
- **Dynamic Dashboard**: `SparkNest Sales Overview` running as the logged-in user (`LoggedInUser`).

### 8. Agentforce AI Topic (Task 9)
- **Topic**: `Enquiry_Status_Check` (`GenAiPlugin`).
- **Invocable Apex Action**: `GetEnquiryStatusAction` enabling real-time enquiry lookup by auto-number or customer email.

---

## 🧪 Testing

Run all unit tests with code coverage:
```bash
sf apex run test --code-coverage --result-format human --target-org SparkNestDevOrg
```
