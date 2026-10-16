# SparkNest Salesforce Capstone — 15-Minute Live Evaluation Script

**Candidate / Presenter:** Shweta Singh  
**Org:** `SparkNestDevOrg` (`singhshweta3024.584f9afd844e@agentforce.com`)  
**Evaluation Standard:** 100-Point Scoring Rubric  

---

## ⏱️ Evaluation Time Allocation (15 Minutes Total)
- **Minute 0:00 – 3:00:** Scene 1 — Data Model, Junction Object & Security
- **Minute 3:00 – 6:00:** Scene 2 — Lightning UI, Dynamic Forms & List Views
- **Minute 6:00 – 9:00:** Scene 3 — Automation Flows & Queue Assignment
- **Minute 9:00 – 12:00:** Scene 4 — Apex Architecture, Code Coverage & APIs
- **Minute 12:00 – 15:00:** Scene 5 — Analytics, Dashboards & Agentforce

---

## 🎬 Scene 1: Data Model & Security (3 mins)
### 1. Data Model & Junction Object
- **Navigate to:** `Setup -> Object Manager -> Enquiry__c` and `Enquiry_Product__c`.
- **Key Talking Points:**
  - `Enquiry__c` is the central custom object with auto-number `ENQ-{0000}`.
  - `Enquiry_Product__c` is a many-to-many junction object linking `Enquiry__c` and standard `Product2`.
  - Custom field `Total_Products_Interested__c` on `Enquiry__c` calculates rollups via bulk-safe Apex triggers across insert, update (reparenting), delete, and undelete.
  - Show 8 loaded products across 4 categories (Personal Devices, Smart Home, Accessories, Care Plans) and 10 contacts with duplicate rules blocking duplicate emails.

### 2. OWD, Role Hierarchy & Profiles
- **Navigate to:** `Setup -> Sharing Settings` and `Setup -> Roles`.
- **Show:**
  - `Enquiry__c` Organization-Wide Default is **Private**.
  - Role Hierarchy: `CEO -> Sales Manager -> Sales Rep (Hyderabad/Mumbai)` and `Support Manager -> Support Agent (Hyderabad/Mumbai)`.
  - Criteria-Based Sharing Rule: Enquiries where `Enquiry_Type__c == 'Care Plan Enquiry'` are shared Read-Only with Support Agent roles.
  - **Arjun Sharma** has profile `SparkNest Sales Rep` + Permission Set `Senior_Sales_Rep` granting `Delete` on `Enquiry__c`, `Read` on `Case`, and Custom Permission `View_Customer_Budget`.
  - **Sneha Nair** has profile `SparkNest Support Agent` with Read on Enquiry and no access to Customer Budget.

---

## 🎬 Scene 2: Lightning UI Experience (3 mins)
### 1. Lightning Apps
- **Navigate to:** App Launcher -> `SparkNest Sales` and `SparkNest Support`.
- Show customized navigation tabs: Home, Enquiries, Contacts, Products, Reports, Dashboards.

### 2. Dynamic Forms & Conditional Visibility
- Open any `Enquiry__c` record in Lightning Experience:
  - **Plan Duration Field:** Point out it is **visible only** when `Enquiry Type == 'Care Plan Enquiry'`.
  - **Source Field:** Point out it is **visible only** when `Enquiry Type == 'Product Enquiry'`.
  - **Customer Budget Field:** Point out it is **visible only** to Arjun Sharma (possessing the `View_Customer_Budget` custom permission).
  - **Related List:** Show `Enquiry Products` related list reflecting interested products and live rollup count.

### 3. List Views & Search Layouts
- Show customized list views: `My Open Enquiries`, `Care Plan Enquiries`, `This Week's Enquiries`.
- Search for an enquiry using the Global Search bar to show customized search columns (`Subject`, `Enquiry Type`, `Status`, `Priority`, `Owner`).

---

## 🎬 Scene 3: Automation Flows (3 mins)
### 1. Screen Flow — Convert Enquiry to Case
- On an open Enquiry record, click the **Convert to Case** quick action button.
- **Show Screen:** Pre-populated Enquiry Subject and Contact, dropdown for Priority (`High`/`Medium`/`Low`), and Description input.
- Click **Next**:
  - The flow routes automatically to `Care_Plan_Support` queue if `Care Plan Enquiry`, or `General_Support` queue otherwise.
  - Generates a new `Case` with Origin `'Internal'` and displays confirmation screen with `CaseNumber`.
  - Automatically updates Enquiry `Status__c` to `'Closed'`.

### 2. Record-Triggered Flow — Auto-close Follow-up Tasks
- Show the Activity Timeline on the Enquiry:
  - The initial follow-up task created upon enquiry creation is now automatically changed to **Completed** by the record-triggered flow `Auto_close_Follow_up_Tasks`.

### 3. Scheduled Flow — Weekly Enquiry Summary
- Navigate to `Setup -> Flows -> Weekly_Enquiry_Summary`.
- Explain how it aggregates enquiries created in the last 7 days every Monday at 8:00 AM and assigns a summary task to Sales Manager **Vikram Kumar**.

---

## 🎬 Scene 4: Apex Architecture & APIs (3 mins)
### 1. Apex Trigger Framework & Service Layer
- **Architecture Highlights:**
  - Single trigger per object (`EnquiryTrigger`, `EnquiryProductTrigger`).
  - Separation of concerns: Thin trigger -> `TriggerDispatcher` -> `EnquiryTriggerHandler` -> `EnquiryService`.
  - `EnquiryService` enforces:
    - Default status `'New'` if blank.
    - Budget validation >= ₹1,000.
    - Automatic 3-day follow-up task generation on insert.
    - Automatic `Closed_Date__c = System.today()` stamping on closure.
  - Zero SOQL/DML in loops (100% bulk-safe, verified by 200-record bulk tests).
  - Nightly scheduled batch `CloseStaleEnquiriesBatch` closing inactive enquiries older than 30 days.

### 2. Unit Testing & Code Coverage
- Open Apex Test Results:
  - **Total Tests:** 17 tests across 4 test classes.
  - **Pass Rate:** 100% (0 failures).
  - **Org-Wide Coverage:** 96% (exceeds the 75% rubric requirement).

### 3. Integrations (Postman Collection)
- Open Postman collection `SparkNest`:
  - **Custom REST API (`/services/apexrest/SparkNestEnquiry/`):**
    - Scenario 1 (New Customer): Creates Contact + Enquiry -> 201 Created.
    - Scenario 2 (Existing Customer): Matches existing Contact by email -> 201 Created.
    - Scenario 3 (Missing Email): Returns HTTP 400 with `'Email is required'`.
  - **Composite API (`/services/data/v68.0/composite`):**
    - Atomic insert using `@{refContact.id}` with `allOrNone: true`.
    - Rollback demonstration with budget < 1,000 proving Contact creation rolls back cleanly.

---

## 🎬 Scene 5: Analytics & Agentforce (3 mins)
### 1. Reports & Dynamic Dashboard
- Navigate to `Analytics -> Dashboards -> SparkNest Sales Overview`.
- Show that this is a **Dynamic Dashboard** running as the logged-in user (`LoggedInUser`).
- Highlight the 4 components:
  1. **Donut Chart:** Enquiries by Type.
  2. **Stacked Column Chart:** Conversion Rate by Source.
  3. **Metric Card:** My Open Enquiries.
  4. **Line Chart:** Weekly Enquiry Volume.

### 2. Agentforce Topic & Invocable Action
- Show `Setup -> Agentforce / GenAI -> Enquiry_Status_Check` topic.
- Show classification instructions and connected Invocable Action `GetEnquiryStatusAction` (`checkStatus`).
- Demonstrate how a user or agent querying `"What is the status of enquiry ENQ-0002?"` or `"Check my enquiry for rajesh.kumar@sparknest.test"` receives real-time status and owner information.

---

## 💯 Evaluation Rubric Checklist
| Component | Weight | Status |
| :--- | :--- | :--- |
| **Data Model & Junction Object (Task 1)** | 10 pts | Verified (Junction, Rollup Trigger, SKU, Constraints) |
| **Security & Sharing Model (Task 2)** | 15 pts | Verified (OWD Private, Roles, Perm Sets, Sharing Rule) |
| **Lightning Experience & Dynamic Forms (Task 3)** | 10 pts | Verified (Apps, Dynamic Forms, List Views) |
| **Data Load & Deduplication (Task 4)** | 10 pts | Verified (8 Products, 10 Contacts, Duplicate Rule) |
| **Process Automation Flows (Task 5)** | 15 pts | Verified (Screen Flow, Auto-close, Scheduled Flow) |
| **Apex Architecture & Batch (Task 6)** | 15 pts | Verified (Dispatcher, Handler, Service, Batch, 96% coverage) |
| **Integration & Composite APIs (Task 7)** | 10 pts | Verified (Custom REST, Composite, Postman Collection) |
| **Reports & Dynamic Dashboard (Task 8)** | 10 pts | Verified (4 Reports, Dynamic Dashboard) |
| **Agentforce Topic (Task 9)** | 5 pts | Verified (Enquiry Status Check topic & Invocable Action) |
| **Git Repository Management (Task 10)** | 5 pts | Verified (3 daily sequential commits) |
| **Total** | **100 pts** | **Ready for Full Score** |
