# Collections Optimization Investment Options & Lever Prioritization

**Project**: Collections Recovery Analytics Platform  
**Phase**: 5 — ₹10 Cr Investment Recommendation & Financial Model  
**Status**: COMPLETE & VERIFIED  

---

## 1. Comprehensive Lever Evaluation Matrix

The table below evaluates all candidate operational, technical, and workforce interventions identified during Phases 1–4, ranking them by empirical evidence strength, expected incremental recovery, implementation complexity, operational risk, and data confidence.

| Lever / Intervention | Evidence Level | Expected Mechanism | Expected Benefit | Implementation Complexity | Operational Risk | Data Confidence | Recommendation Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1. Digital Omnichannel Orchestration** | **STRONG EVIDENCE** `[DERIVED]` | WhatsApp & SMS automated payment reminders with direct UPI payment links | High engagement at negligible marginal cost; self-cure conversion | **LOW** (API integration) | **LOW** | **HIGH** | **PRIORITY 1 (RECOMMENDED)** |
| **2. ML Dynamic Targeting & RCT Engine** | **STRONG EVIDENCE** `[DERIVED]` | Account prioritization based on DPD and payment likelihood; 1:1 holdout testing | +₹596/account yield over organic; eliminates negative selection bias | **MEDIUM** (ML pipeline + control holdout) | **LOW** | **HIGH** | **PRIORITY 2 (RECOMMENDED)** |
| **3. PTP Fulfillment & Settlement Gateway** | **OBSERVED** `[OBSERVED]` | Automated SMS/WhatsApp reminders 24h before PTP due date with 1-click settlement | Recovers broken PTPs (currently 75% break rate, ₹675M at risk) | **LOW** (Webhook / CRM triggers) | **LOW** | **HIGH** | **PRIORITY 3 (RECOMMENDED)** |
| **4. Dialer Pacing & Attempt Capping** | **OBSERVED** `[OBSERVED]` | Cap repetitive voice dials at 3 attempts; reallocate excess capacity | Eliminates wasted telephony cost; prevents borrower harassment | **LOW** (Dialer configuration rule) | **LOW** | **HIGH** | **PRIORITY 4 (RECOMMENDED)** |
| **5. Continuous Data Quality & Audit Layer**| **OBSERVED** `[OBSERVED]` | Automated ingestion schemas, payment settlement reconciliation, SCD2 agent tables | Eliminates ₹601M phantom recovery reporting; ensures auditability | **LOW** (dbt / SQL pipelines) | **LOW** | **HIGH** | **PRIORITY 5 (RECOMMENDED)** |
| **6. Increasing Manual Agent Headcount** | **STRONG EVIDENCE** `[DERIVED]` | Hiring more human collectors | High fixed payroll cost; agent productivity invariant to tenure (~₹111k) | **HIGH** (Recruiting, training, seating) | **HIGH** (Fixed cost overhang) | **HIGH** | **NOT RECOMMENDED** |
| **7. Calling Time Window Shifts** | **FACT** `[OBSERVED]` | Shifting calling hours to evenings or weekends | Historical connection rate is invariant (~20%) across all 24 hours | **LOW** (Shift scheduling) | **LOW** | **HIGH** | **NOT RECOMMENDED** |
| **8. Telephony Carrier Vendor Switching** | **FACT** `[OBSERVED]` | Reallocating minutes across the 15 carrier vendors | All 15 vendors exhibit identical ~20% connection and ~69% RPC rates | **MEDIUM** (Carrier contracting) | **LOW** | **HIGH** | **NOT RECOMMENDED** |

---

## 2. Lever Prioritization & Selection Rationale

1. **Top Priority: Digital First (Levers 1 & 3)**:
   - Consumer collections in digital lending achieves peak ROI through frictionless payment links delivered via WhatsApp and SMS rather than brute-force manual dialing.
2. **Second Priority: Dynamic Targeting & Experimentation (Lever 2)**:
   - Moving from static rules to dynamic machine learning targeting prevents wasted effort on unrecoverable accounts and protects portfolio holdouts.
3. **Deprioritized Levers (Levers 6, 7, 8)**:
   - Increasing manual agent headcount is strictly rejected because historical agent productivity is flat across tenure tiers and human calling represents the highest unit cost.
