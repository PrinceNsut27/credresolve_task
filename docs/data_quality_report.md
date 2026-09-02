# Data Quality & Forensics Report

**Project**: Collections Recovery Analytics  
**Phase**: 1 — Data Quality, Forensics & Golden Dataset Layer  
**Status**: COMPLETE  
**Scope**: Read-Only Raw Evaluation → Forensic Root-Cause Analysis → Cleansing & Standardization Rules  

---

## 1. Executive Data Quality Scorecard

The table below catalogs the critical data-quality risks, forensic anomalies, and structural integrity failures detected across the 17 raw datasets, accompanied by severity ratings, empirical row/financial counts, and standardized treatment rules.

| Issue / Anomaly | Severity | Empirical Evidence | Records Affected | Financial Impact | Standard Treatment Rule | Confidence |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Duplicate Payment Ingestion** | **CRITICAL** | `payments.csv` contains exact duplicate rows and duplicate `payment_id`s | 486 exact dups; 500 duplicate `payment_id` pairs (1,000 rows) | **+₹25,901,961.69** artificial gross inflation | Deduplicate strictly on `payment_id`; keep earliest transaction record | **HIGH** |
| **Non-Success Settlement Mix** | **CRITICAL** | `payments.csv` contains `FAILED`, `PENDING`, and `REVERSED` transaction records | 3,744 Failed; 2,592 Pending; 1,284 Reversed (7,620 non-success rows, 29.9% of table) | **+₹575,772,690.82** uncollected revenue | Filter strictly for `payment_status == 'SUCCESS'` for net collections | **HIGH** |
| **Duplicate Voice Calls** | **HIGH** | `calls.csv` contains exact clones and duplicate `call_id`s | 1,271 exact dups; 1,350 duplicate `call_id` pairs (2,700 rows) | Overstates contact volume, handle time, and dial attempts | Deduplicate on `call_id`; retain single unique call transaction | **HIGH** |
| **Borrower Entity Collisions** | **HIGH** | `borrowers.csv` contains conflicting personal profiles per `borrower_id` | 30,000 clean rows mapping to only 11,015 distinct IDs | Misallocates borrower demographic & state-level analytics | Deduplicate on `borrower_id` ordering by `updated_at DESC` | **HIGH** |
| **Orphaned Borrower FKs** | **HIGH** | `accounts.csv` and event tables reference `borrower_id`s missing from `borrowers.csv` | 455 nulls in accounts; 2,458 unlinked accounts (8.19%); ~8.2% orphan events | Unallocated borrower demographics; incomplete KYC lineage | Impute missing borrower IDs with `UNKNOWN_BORROWER`; preserve accounts | **HIGH** |
| **Agent Profile Multi-Grain** | **HIGH** | `agents.csv` contains 30 historical records per agent with varying employee codes | 30,000 rows for 1,000 unique `agent_id`s (1,099 employee codes) | Multiplies agent capacity & distorts agent productivity metrics | Resolve canonical agent dimension by latest `updated_at` | **HIGH** |
| **Unassigned Voice Calls** | **MEDIUM** | `calls.csv` contains `NULL` `agent_id` records | 1,827 calls (2.00% of calls) | Distorts human agent productivity vs bot/IVR calling | Impute `agent_id` with `SYSTEM_IVR` | **HIGH** |
| **Unassigned Carrier Vendors** | **MEDIUM** | `call_attempts.csv` contains `NULL` `vendor_id` records | 2,400 attempts (2.00% of attempts) | Understates carrier-level dialer connectivity benchmarks | Impute `vendor_id` with `UNKNOWN_VENDOR` | **HIGH** |
| **Heterogeneous Timezones** | **MEDIUM** | Timestamps recorded across `UTC`, `Asia/Kolkata` (+05:30), `Asia/Dubai` (+04:00) | Distributed across accounts, calls, sessions, and vendors | Shifts daily cutoff boundaries and hour-of-day calling volume | Standardize all timestamps to UTC/IST across operational tables | **HIGH** |
| **Inverted Audit Timestamps** | **MEDIUM** | In `account_status_history.csv`, `recorded_at` precedes `event_at` | 29,880 records (49.8% of table) | Distorts state duration and transition latency calculations | Order lifecycle states primarily by `event_at` rather than `recorded_at` | **HIGH** |
| **Duplicate WhatsApp Events** | **LOW** | `whatsapp_events.csv` contains exact duplicate rows | 600 exact dups; 600 duplicate `whatsapp_event_id` pairs | Artificially inflates digital delivery & read rates | Deduplicate on `whatsapp_event_id` | **HIGH** |
| **Incomplete August Horizon** | **CRITICAL** | Operational data terminates abruptly on August 8, 2026 | August has only ~8 days of activity (1,223 calls, 942 payments) | Severe false >70% month-over-month drop-off if unadjusted | Treat August 2026 strictly as a partial month / normalize run-rate | **HIGH** |

---

## 2. Deep-Dive Forensic Investigations

### 2.1 Duplicate Payment & Settlement Forensics

#### Forensic Problem Statement
Unvalidated aggregation of `payments.csv` produces a massive false inflation of collections recovery.

#### Empirical Findings
1. **Raw Payment Volume**: 25,500 rows totaling **₹1,917,258,617.15**.
2. **Settlement Status Breakdown**:
   - `SUCCESS`: 17,880 rows | **₹1,341,485,926.33** (69.97% of total amount)
   - `FAILED`: 3,744 rows | **₹283,506,324.89** (14.79% of total amount)
   - `PENDING`: 2,592 rows | **₹194,867,950.33** (10.16% of total amount)
   - `REVERSED`: 1,284 rows | **₹97,398,415.60** (5.08% of total amount)
3. **Injected Ingestion Duplicates**:
   - Within `SUCCESS` records, **346 duplicate `payment_id` rows** (335 exact clones + 11 non-exact duplicates) were identified, totaling **₹25,901,961.69**.
   - Identical natural keys (`account_id + amount + event_at`) matched the 346 duplicate `payment_id` rows with 100% precision.
4. **Financial Reconciliation**:
   - **Gross Raw Payments**: ₹1,917,258,617.15 (25,500 rows)
   - **Less Failed Transactions**: -₹283,506,324.89 (3,744 rows)
   - **Less Pending Transactions**: -₹194,867,950.33 (2,592 rows)
   - **Less Reversed Transactions**: -₹97,398,415.60 (1,284 rows)
   - **Less Duplicate Success Payments**: -₹25,901,961.69 (346 rows)
   - **True Net Collections (Golden Layer)**: **₹1,315,583,964.64** (17,534 rows)
   - **Total Excluded Amount**: **₹601,674,652.51** (31.38% total exclusion; raw data overstates recovery by **+45.73%**).

---

### 2.2 Payment Attribution & Channel Lookback Forensics

#### Forensic Problem Statement
Evaluating channel recovery efficacy requires linking payments back to prior interventions (calls, SMS, WhatsApp, field visits). Naive single-touch or arbitrary lookback windows radically alter perceived channel ROI.

#### Empirical Lookback Window Comparison
Every clean `SUCCESS` payment (17,534 records totaling ₹1.315B) was mapped against all 220,000 prior operational touches across 5 standardized lookback windows (Last-Touch model):

| Attribution Window | Voice Calls (₹) | WhatsApp (₹) | SMS (₹) | Field Visits (₹) | Organic / Direct (₹) | Total Attributed % |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1-Day Window** | ₹17.42M (245 txns) | ₹12.16M (157 txns) | ₹7.89M (108 txns) | ₹4.44M (58 txns) | ₹1,273.67M (16,966 txns) | **3.24%** |
| **3-Day Window** | ₹52.57M (703 txns) | ₹32.63M (436 txns) | ₹23.38M (314 txns) | ₹13.96M (185 txns) | ₹1,193.05M (15,896 txns) | **9.34%** |
| **7-Day Window (Baseline)** | **₹111.85M** (1,483 txns) | **₹69.30M** (924 txns) | **₹54.91M** (728 txns) | **₹29.38M** (400 txns) | **₹1,050.15M** (13,999 txns) | **20.16%** |
| **14-Day Window** | ₹193.87M (2,567 txns) | ₹127.93M (1,680 txns) | ₹99.55M (1,323 txns) | ₹56.09M (735 txns) | ₹838.15M (11,229 txns) | **35.94%** |
| **30-Day Window** | ₹322.16M (4,280 txns) | ₹211.84M (2,815 txns) | ₹163.52M (2,181 txns) | ₹91.71M (1,206 txns) | ₹526.35M (7,052 txns) | **59.78%** |

#### Attribution Policy for Golden Dataset
- **Primary Operational Attribution**: Standardized on the **7-Day Lookback Window** (industry benchmark for consumer loan collections).
- **Multi-Window Persistence**: `golden_payments_attributed` persists 1d, 3d, 7d, 14d, and 30d attributed channels and lag hours side-by-side to enable rigorous sensitivity testing in Phase 4 & Phase 5.

---

### 2.3 Agent Identity & Capacity Forensics

#### Forensic Problem Statement
`agents.csv` contains 30,000 records for only 1,000 unique `agent_id`s, with 1,099 `employee_code`s and timestamp anomalies (`joined_at > updated_at` in 4,078 records). Joining this table 1:N multiplies agent counts and inflates capacity.

#### Empirical Findings & Resolution
1. **Canonical Master Resolution**: By selecting `ROW_NUMBER() OVER (PARTITION BY agent_id ORDER BY updated_at DESC) = 1`, all 30,000 rows resolve to **exactly 1,000 unique collection agents**.
2. **Canonical Workforce Composition**:
   - **Operational Status**: 317 ACTIVE, 331 INACTIVE, 352 SUSPENDED
   - **Team Allocation**: 220 Field Operations, 203 Tier 1 Calls, 197 Tier 2 Calls, 192 Digital Operations, 188 Tier 3 Calls
   - **Telephony Vendor Distribution**: Evenly distributed across 15 vendors (55 to 77 agents per vendor)
3. **Timestamp Standardization**: Where `joined_at > updated_at`, `joined_at` was standardized to `updated_at` to ensure historical consistency.

---

### 2.4 Borrower Entity Deduplication & KYC Reconciliation

#### Forensic Problem Statement
`borrowers.csv` contains 30,600 raw rows (600 exact clones) mapping to only 11,015 unique `borrower_id`s, where different names and locations share the same ID. Furthermore, 2,458 accounts in `accounts.csv` (8.19%) reference missing borrower IDs.

#### Empirical Findings & Resolution
1. **Deduplication**: 30,600 raw rows -> 11,015 canonical borrower profiles by ordering by `updated_at DESC`.
2. **Missing Reference Handling**: Accounts with unlinked borrower IDs are retained with `borrower_id = 'UNKNOWN_BORROWER'` to preserve 100% of financial balance and loan exposure.

---

### 2.5 Telephony Dispositions & RPC Taxonomies

#### Forensic Problem Statement
Dispositions span three version taxonomies (`legacy`, `v1`, `v2`). Codes must be harmonized to determine Right Party Contact (RPC) and Contact Rates.

#### Empirical Harmonization
1. **Taxonomy Consistency**: All 9 codes (`CALLBACK`, `DISPUTE`, `NO_CONTACT`, `PAID`, `PROMISE_TO_PAY` / `PTP`, `PTP_BROKEN`, `REFUSED`, `WRONG_NUMBER`) are present across all 3 versions (~1,250 to 1,350 instances each).
2. **Standardization Rule**: `PROMISE_TO_PAY` is standardized to `PTP`.
3. **RPC Classification**: `is_rpc = 1` for `PTP`, `CALLBACK`, `DISPUTE`, `REFUSED`, and `PAID` (meaningful borrower interaction).

---

### 2.6 Account Lifecycle History & Point-in-Time Reconstruction

#### Forensic Problem Statement
In `account_status_history.csv`, 49.8% of records show `recorded_at < event_at` (database commit timestamp earlier than event timestamp by up to 24 hours).

#### Resolution
State transitions are ordered strictly by `event_at ASC`. Point-in-time account status is reconstructed for the end of each month (Jan 2026 to Aug 2026), capturing the evolution of accounts across `ACTIVE`, `PTP`, `DELINQUENT`, `NPA`, `PAID`, `CLOSED`, and `WRITEOFF`.

---

---

## 3. Systematic 12-Issue Forensic Audit Matrix

Every potential data integrity failure cited in the forensic mandate was independently tested against empirical operational records. The table below classifies each issue, detailing detection methodology, evidence, treatment, and business impact.

| # | Forensic Issue | Classification | Detection Method | Empirical Evidence | Standard Treatment | Business Impact |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | **Duplicate Payments** | **DETECTED** | Natural key (`account_id + amount + event_at`) and PK collision check | 486 exact dups; 500 duplicate `payment_id` pairs (1,000 rows); 346 duplicate SUCCESS txns totaling **₹25.90M** | Deduplicate strictly on `payment_id` keeping earliest settled record | Eliminates false revenue overstatement (+₹25.9M) |
| **2** | **Incorrect Payment Attribution** | **DETECTED** | Multi-window lookback evaluation (1d, 3d, 7d, 14d, 30d) against 220k operational touches | Attributed share varies wildly from 3.24% (1d) to 59.78% (30d); 79.84% organic at 7d baseline | Persist multi-window attributes in Golden layer; standardize 7d baseline | Prevents unearned channel ROI claims (Voice gets 54% of attributed, 8.5% of total) |
| **3** | **Timezone Inconsistencies** | **DETECTED** | Column frequency profiling across `accounts`, `calls`, `agent_sessions`, `vendor_telephony` | Distributed across `UTC` (33.7%), `Asia/Kolkata` (33.3%), `Asia/Dubai` (33.0%) | Normalize all operational event timestamps to unified ISO UTC/IST | Eliminates calendar boundary shifting and hour-of-day distortion |
| **4** | **Telephony Vendor / Disposition Changes** | **DETECTED** | Cross-tabulation of `disposition_code` across `disposition_version` (legacy, v1, v2) | Code definitions (`PTP`, `CALLBACK`, `DISPUTE`, etc.) are stable across versions, but `PROMISE_TO_PAY` exists alongside `PTP` | Map `PROMISE_TO_PAY` to canonical `PTP`; classify meaningful contacts as `is_rpc = 1` | Standardizes Right Party Contact (RPC) and commitment tracking |
| **5** | **Agent Identity Duplication** | **DETECTED** | Cardinality and collision check on `agents.csv` (`agent_id` vs `employee_code`) | 30,000 rows for exactly 1,000 unique `agent_id`s; 1,099 employee codes; 4,078 rows have `joined_at > updated_at` | Resolve canonical SCD by `ROW_NUMBER() OVER (PARTITION BY agent_id ORDER BY updated_at DESC) = 1` | Prevents 30x overstatement of workforce capacity and headcount |
| **6** | **Portfolio Mix Changes** | **NOT DETECTED (INVESTIGATED)** | Longitudinal distribution audit of `loan_type`, `risk_segment`, `dpd` across 8 months | Loan products (~20% each), risk segments (~25% each), and DPD buckets (~25% each) remained constant across all months | Static master portfolio spine in Golden layer; Kitagawa shift-share decomposition | Confirms that portfolio mix shifts explain 0.0% of recovery variance |
| **7** | **Denominator Manipulation** | **DETECTED (RISK MITIGATED)** | Comparison of fixed master portfolio (30k) vs daily targeted (23.3k) vs open active (9.9k–15.8k) | Open active delinquent denominator expands from 9.9k in Jan to 15.8k in Jul, creating false recovery rate drop (24% -> 15%) | Anchor macro recovery metrics strictly to the **Fixed 30,000 Master Portfolio** | Prevents artificial inflation or suppression of recovery rates |
| **8** | **Late-Arriving Events & Inverted Timestamps** | **DETECTED** | Delta check between `event_at` (operational) and `recorded_at` (database commit) | In `account_status_history.csv`, 30,191 rows (50.32%) show `recorded_at < event_at` by up to 24 hours | Sequence account lifecycle states strictly by `event_at ASC` | Ensures accurate point-in-time account status reconstruction |
| **9** | **Duplicate Calls / Events** | **DETECTED** | Exact row hashing and event PK collision check across event streams | 1,271 exact duplicate calls (2,700 total rows with duplicate `call_id`); 600 exact duplicate WhatsApp events | Deduplicate event tables on unique event PKs (`call_id`, `whatsapp_event_id`) | Prevents distortion of call volumes, agent handle times, and digital reach |
| **10** | **Overwritten Historical Records** | **DETECTED** | Row-to-entity ratio audit in `borrowers.csv` and `agents.csv` | `borrowers.csv` contains 30,600 rows mapping to 11,015 IDs (multi-profile overwriting) | Deduplicate on `borrower_id` selecting latest `updated_at` | Preserves deterministic demographic and location assignment |
| **11** | **Inconsistent IDs & Orphan Foreign Keys** | **DETECTED** | Referential integrity foreign key join audits between accounts/events and dimensions | `accounts.csv` contains 455 null `borrower_id`s; 897 borrower IDs in accounts missing from `borrowers.csv` | Impute missing borrower IDs with `UNKNOWN_BORROWER`; preserve 100% of account financials | Prevents loss of ₹ balance or accounts in downstream reporting |
| **12** | **Changed Campaign Definitions** | **DETECTED** | Temporal audit of `campaigns.csv` across 4 `strategy_version`s (legacy, v1, v2, v3) | 120 campaigns across 5 targeting rules (`DPD>=60`, `HIGH_RISK`, `PROMISE_BROKEN`, `DPD>=30`, `NPA`) | Standardize campaign dimension linking `campaign_id` to targeting allocations | Enables rigorous campaign attribution and counterfactual modeling |

---

## 4. Data Transformation & Pipeline Traceability

The table below summarizes the transition from Raw records to Clean and Golden layers across all 17 datasets.

| Dataset | Raw Rows | Rejected (Duplicates / Invalid) | Corrected / Harmonized | Clean / Golden Rows | Primary Cleansing Logic |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `accounts` | 30,000 | 0 | 455 | 30,000 | Imputed null `borrower_id` with `UNKNOWN_BORROWER` |
| `borrowers` | 30,600 | 19,585 | 1,509 | 11,015 | Removed 600 exact dups; resolved 11,015 unique profiles by latest `updated_at` |
| `agents` | 30,000 | 29,000 | 4,078 | 1,000 | Resolved 1,000 canonical agents; corrected `joined_at > updated_at` inversions |
| `agent_sessions` | 15,000 | 0 | 0 | 15,000 | Validated session grain and duration |
| `campaigns` | 120 | 0 | 0 | 120 | Validated strategy versions and date horizons |
| `daily_targeting` | 45,000 | 0 | 0 | 45,000 | Validated allocation priority and recommended channels |
| `calls` | 91,350 | 1,350 | 1,827 | 90,000 | Removed 1,271 exact dups & 79 ID dups; imputed null `agent_id` with `SYSTEM_IVR` |
| `call_attempts` | 120,000 | 0 | 2,400 | 120,000 | Imputed null `vendor_id` with `UNKNOWN_VENDOR` |
| `call_dispositions` | 35,000 | 0 | 11,726 | 35,000 | Standardized `PROMISE_TO_PAY` to `PTP`; tagged RPC flags |
| `whatsapp_events` | 60,600 | 600 | 0 | 60,000 | Removed 600 exact duplicate message events |
| `sms_events` | 45,000 | 0 | 0 | 45,000 | Validated 4 lifecycle states and template codes |
| `field_visits` | 25,000 | 0 | 250 | 25,000 | Imputed null `scheduled_at` with `event_at`; tagged contact flags |
| `promises_to_pay` | 18,000 | 0 | 0 | 18,000 | Validated commitment grain and status flags |
| `payments` (Success) | 25,500 | 7,966 | 0 | 17,534 | Filtered non-success (7,620 rows) and removed duplicate `payment_id`s (346 rows) |
| `vendor_telephony` | 15 | 0 | 0 | 15 | Validated 15 vendor integration profiles |
| `complaints` | 8,000 | 0 | 0 | 8,000 | Validated grievance types and resolution tracking |
| `account_status_history` | 60,000 | 0 | 29,880 | 60,000 | Reordered transitions by `event_at ASC` for point-in-time reconstruction |
| **Total Pipeline** | **639,185** | **58,501** | **52,125** | **548,684** | **100% Traceable & Reproducible** |

---

## 5. Final Quality Assurance & Invariant Verification

- [x] **Raw CSV Data Unchanged**: All raw files in `data/` remain strictly unmodified with identical file hashes.
- [x] **Zero Join Multiplication**: Joining operational touches and payments onto the `account_id × analysis_month` spine produced exactly **240,000 rows** with zero duplicate keys.
- [x] **Exact Financial Reconciliation**: `golden_payments_attributed` total (₹1,315,583,964.64) equals `golden_accounts_monthly` payment sum with ₹0.00 difference.
- [x] **Referential Integrity**: 100% of accounts and event records resolve against clean dimensions without orphaned primary keys.

