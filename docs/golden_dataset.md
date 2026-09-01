# Golden Dataset Architecture & Technical Specification

**Project**: Collections Recovery Analytics Platform  
**Phase**: 1 — Data Quality, Forensics & Golden Dataset Layer  
**Status**: READY FOR ANALYTICS  

---

## 1. Architectural Overview & Design Principles

The Golden Dataset establishes a production-grade, highly structured analytical layer designed to eliminate data duplication, prevent join explosion, standardize timestamps, and provide unambiguous metric grains for all downstream recovery analysis.

### Pipeline Lineage Architecture

```
RAW CSVs (data/*.csv)
    │
    ▼
STAGING LAYER (sql/01_staging.sql)
    │
    ▼
CLEANSED & HARMONIZED LAYER (sql/02_cleaning.sql -> data/clean/*.csv)
    │
    ▼
GOLDEN ANALYTICAL LAYER (sql/03_golden.sql -> data/golden/*.csv)
    ├── golden_accounts_monthly (Primary Analytical Grain: account_id x analysis_month)
    ├── golden_payments_attributed (Transaction Grain: payment_id)
    ├── golden_calls_clean (Telephony Grain: call_id)
    ├── golden_ptp_clean (Commitment Grain: ptp_id)
    ├── golden_agents_dim (Dimension Grain: agent_id)
    └── golden_borrowers_dim (Dimension Grain: borrower_id)
```

---

## 2. Core Analytical Grain: `golden_accounts_monthly`

### 2.1 Definition & Rationale
- **Analytical Grain**: Exactly **`account_id × analysis_month`** (One row per loan account per calendar month).
- **Spine Construction**: Cartesian product of **30,000 master accounts × 8 analysis months (2026-01 to 2026-08)** = **240,000 total rows**.
- **Primary Key**: `(account_id, analysis_month)` — 100% unique, 0 nulls.
- **Rationale**: 
  - Prevents 1-to-many join explosion when linking multi-event operational tables (calls, WhatsApp, SMS, visits, payments).
  - Preserves inactive/zero-touch accounts in the denominator, completely eliminating survivorship bias and denominator manipulation.
  - Allows seamless cohort, risk segment, product mix, and channel transition modeling.

### 2.2 Data Dictionary (`golden_accounts_monthly.csv`)

| Column Name | Data Type | Null % | Description |
| :--- | :--- | :--- | :--- |
| `account_id` | `VARCHAR(64)` | 0.00% | Primary key component; unique loan account identifier |
| `analysis_month` | `VARCHAR(7)` | 0.00% | Primary key component; operational calendar month (`YYYY-MM`) |
| `borrower_id_clean` | `VARCHAR(64)` | 0.00% | Foreign key referencing `golden_borrowers_dim` |
| `loan_type` | `VARCHAR(32)` | 0.00% | Credit product (CREDIT_CARD, PERSONAL, AUTO, CONSUMER, BNPL) |
| `principal_amount` | `NUMERIC(15,2)`| 0.00% | Sanctioned loan principal amount (INR) |
| `outstanding_amount` | `NUMERIC(15,2)`| 0.00% | Outstanding balance at origination/observation (INR) |
| `dpd` | `INTEGER` | 0.00% | Days Past Due at baseline observation |
| `risk_segment` | `VARCHAR(16)` | 0.00% | Risk tier (HIGH, MEDIUM, LOW, NPA) |
| `status` | `VARCHAR(32)` | 0.00% | Static origination status in accounts master |
| `pit_status` | `VARCHAR(32)` | 0.00% | Reconstructed Point-in-Time status as of month-end |
| `opened_at` | `TIMESTAMP` | 0.00% | Account origination timestamp |
| `timezone` | `VARCHAR(32)` | 0.00% | Account operational timezone |
| `schema_version` | `VARCHAR(16)` | 0.00% | Source schema version |
| `total_calls` | `INTEGER` | 0.00% | Total voice dial attempts resulting in call records during the month |
| `answered_calls` | `INTEGER` | 0.00% | Total connected voice calls (`call_status == 'ANSWERED'`) |
| `rpc_calls` | `INTEGER` | 0.00% | Total Right Party Contacts (`PTP`, `CALLBACK`, `DISPUTE`, `REFUSED`, `PAID`) |
| `total_call_duration_sec`| `INTEGER` | 0.00% | Cumulative talk time in seconds |
| `whatsapp_sent` | `INTEGER` | 0.00% | WhatsApp messages dispatched (`SENT`) |
| `whatsapp_delivered` | `INTEGER` | 0.00% | WhatsApp messages confirmed delivered |
| `whatsapp_read` | `INTEGER` | 0.00% | WhatsApp messages read by borrower |
| `whatsapp_clicks` | `INTEGER` | 0.00% | Payment link clicks recorded via WhatsApp |
| `whatsapp_total_events`| `INTEGER` | 0.00% | Total WhatsApp interaction events |
| `sms_sent` | `INTEGER` | 0.00% | SMS messages dispatched (`SENT`) |
| `sms_delivered` | `INTEGER` | 0.00% | SMS messages confirmed delivered |
| `sms_clicks` | `INTEGER` | 0.00% | Payment link clicks recorded via SMS |
| `sms_total_events` | `INTEGER` | 0.00% | Total SMS interaction events |
| `field_visits_count` | `INTEGER` | 0.00% | Total physical field visits conducted |
| `field_contacts_count` | `INTEGER` | 0.00% | Field visits where borrower was contacted |
| `field_ptp_count` | `INTEGER` | 0.00% | Field visits resulting in a Promise to Pay |
| `field_paid_count` | `INTEGER` | 0.00% | Field visits resulting in direct on-spot payment |
| `ptp_count` | `INTEGER` | 0.00% | Total commitments to pay logged in month |
| `ptp_promised_amount`| `NUMERIC(15,2)`| 0.00% | Cumulative promised amount in INR |
| `ptp_kept_count` | `INTEGER` | 0.00% | Commitments marked as `KEPT` |
| `ptp_broken_count` | `INTEGER` | 0.00% | Commitments marked as `BROKEN` |
| `success_payment_count`| `INTEGER` | 0.00% | Total deduplicated successful payment transactions |
| `success_payment_amount`| `NUMERIC(15,2)`| 0.00% | Total net collections recovered in INR |
| `gross_payment_count` | `INTEGER` | 0.00% | Total raw payment transaction attempts (all statuses) |
| `gross_payment_amount`| `NUMERIC(15,2)`| 0.00% | Total gross transaction amount (all statuses) |
| `failed_payment_amount`| `NUMERIC(15,2)`| 0.00% | Total failed payment amount in INR |
| `reversed_payment_amount`| `NUMERIC(15,2)`| 0.00% | Total reversed/chargeback payment amount in INR |
| `complaints_count` | `INTEGER` | 0.00% | Total grievances registered in month |
| `targeted_days_count` | `INTEGER` | 0.00% | Total days account was allocated to active campaigns |
| `is_contacted_any_channel`| `INTEGER` | 0.00% | Binary flag: 1 if contacted via Call, Field, WhatsApp click, or SMS click |
| `is_rpc_any_channel` | `INTEGER` | 0.00% | Binary flag: 1 if Right Party Contact achieved via Call or Field |
| `has_ptp` | `INTEGER` | 0.00% | Binary flag: 1 if account made a PTP in month |
| `has_success_payment` | `INTEGER` | 0.00% | Binary flag: 1 if account paid successfully in month |

---

## 3. Supporting Analytical Datasets

### 3.1 `golden_payments_attributed.csv` (Grain: `payment_id`)
- **Total Records**: **17,534 clean SUCCESS payments**.
- **Total Net Amount**: **₹1,315,583,964.64**.
- **Key Columns**: `payment_id`, `account_id`, `borrower_id`, `payment_date`, `payment_month`, `amount`, `payment_method`, `provider_id`, `attr_channel_7d`, `attr_agent_7d`, `attr_lag_hours_7d` (along with 1d, 3d, 14d, 30d window attributes).

### 3.2 `golden_calls_clean.csv` (Grain: `call_id`)
- **Total Records**: **90,000 unique calls** (96,029 merged with dispositions).
- **Key Columns**: `call_id`, `account_id`, `event_at`, `agent_id_clean`, `direction`, `call_status`, `duration_sec`, `disposition_code_clean`, `is_rpc`.

### 3.3 `golden_ptp_clean.csv` (Grain: `ptp_id`)
- **Total Records**: **18,000 commitments**.
- **Total Promised Amount**: **₹904,209,098.00**.
- **Key Columns**: `ptp_id`, `account_id`, `event_at`, `agent_id`, `promised_amount`, `promised_date`, `status`, `source`, `is_kept`, `is_broken`.

### 3.4 `golden_agents_dim.csv` (Grain: `agent_id`)
- **Total Records**: **1,000 canonical agents**.
- **Key Columns**: `agent_id`, `employee_code`, `agent_name`, `vendor_id`, `team`, `status`, `joined_at`, `updated_at`.

### 3.5 `golden_borrowers_dim.csv` (Grain: `borrower_id`)
- **Total Records**: **11,015 canonical borrowers**.
- **Key Columns**: `borrower_id`, `name`, `phone`, `email`, `city`, `state`, `created_at`, `updated_at`.

---

## 4. Invariant Verification & Mathematical Reconciliation

```
INVARIANT CHECK 1: Net Payment Reconciliation
  golden_payments_attributed Amount: INR 1,315,583,964.64
  golden_accounts_monthly Amount:    INR 1,315,583,964.64
  Reconciliation Delta:              INR 0.0000 (EXACT MATCH)

INVARIANT CHECK 2: Account Spine Integrity
  Total Master Accounts: 30,000
  Total Analysis Months: 8 (2026-01 to 2026-08)
  Expected Golden Spine: 30,000 x 8 = 240,000 rows
  Actual Golden Spine:   240,000 rows (100% MATCH, 0 Duplicate PKs)

INVARIANT CHECK 3: PTP Commitment Count
  golden_ptp_clean rows:             18,000
  golden_accounts_monthly sum(ptp):  18,000
  Reconciliation Delta:              0 (EXACT MATCH)
```

The Golden analytical layer is now fully generated, validated, and ready for Phase 2–5 metric computations.
