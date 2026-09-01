# Executive Investment Memorandum: ₹10 Crore Collections Optimization

**Project**: Collections Recovery Analytics Platform  
**Phase**: 5 — ₹10 Cr Investment Recommendation & Financial Model  
**Investment Capital**: **₹10.00 Crore (INR 100,000,000.00)**  
**Final Strategic Decision**: **PILOT FIRST / INVEST WITH CONDITIONS (Phase-Gated Deployment)**  

---

## 1. Executive Summary: The Investment Decision

We recommend that leadership **APPROVE A PHASE-GATED ALLOCATION OF THE ₹10.00 CRORE BUDGET**, structured as:
1. **Phase 1 Pilot Commitment (Months 1–3: ₹2.50 Cr)**: Fund the deployment of a 90-day 1:1 Randomized Controlled Trial (RCT) across 30,000 accounts alongside digital WhatsApp/SMS automated payment gateways.
2. **Phase 2 Scale-Out (Months 4–12: ₹7.50 Cr)**: Released only if the Phase 1 RCT demonstrates a statistically significant incremental portfolio recovery uplift of $\ge 3.50\%$.

```
================================================================================
EXECUTIVE SUMMARY: KEY FINANCIAL & OPERATIONAL METRICS
================================================================================
1. Annual Baseline Portfolio Recovery:       INR 217.45 Cr [OBSERVED / DERIVED]
2. Total Capital Investment:                 INR 10.00 Cr  [ASSUMED]
3. Base-Case Annual Incremental Recovery:    +INR 7.61 Cr (+3.50% uplift) [DERIVED]
4. Base-Case Payback Period:                 15.8 Months  [DERIVED]
5. Break-Even Portfolio Recovery Uplift:     4.60% (INR 10.00 Cr / year) [DERIVED]
6. Upside Annual Incremental Recovery:       +INR 13.05 Cr (+6.00% uplift, 9.2m payback)
================================================================================
```

---

## 2. ₹10.00 Crore Budget Allocation Breakdown

The ₹10.00 Cr investment is allocated strictly according to empirical evidence from Phases 1–4:

| Investment Category | Allocation (₹ Cr) | Budget Share (%) | Input Label | Strategic Rationale & Empirical Justification |
| :--- | :--- | :--- | :--- | :--- |
| **1. Digital Omnichannel Orchestration** | **₹3.50 Cr** | **35.0%** | `[DERIVED]` | WhatsApp & SMS APIs, interactive payment links, and webhook infrastructure. Digital channels deliver high conversion with near-zero marginal variable cost. |
| **2. ML Targeting Engine & Production RCT Platform** | **₹2.50 Cr** | **25.0%** | `[DERIVED]` | Cloud ML decisioning pipeline and automated 1:1 holdout trial infrastructure to eliminate selection bias and optimize contact sequence. |
| **3. PTP Fulfillment & Settlement Gateway** | **₹2.00 Cr** | **20.0%** | `[OBSERVED]` | Automated settlement links and conversational WhatsApp bots triggered 24h before commitment date to recover broken PTPs (currently 75% break rate). |
| **4. Dialer Pacing & Attempt Capping System** | **₹1.00 Cr** | **10.0%** | `[OBSERVED]` | Predictive dialer rules to cap voice attempts at 3 touches, eliminating wasted carrier minutes and diminishing returns (5.08% vs 7.78%). |
| **5. Continuous Data Quality & Audit Infrastructure** | **₹1.00 Cr** | **10.0%** | `[OBSERVED]` | Production ETL pipelines, payment ledger reconciliations, and SCD2 agent dimension tracking to prevent phantom financial reporting. |
| **TOTAL CAPITAL ALLOCATION** | **₹10.00 Cr** | **100.0%** | `[ASSUMED]` | **100.0% Evidence-Based Allocation** |

---

## 3. Operational Feasibility & Initiative Governance

| Initiative | Operational Owner | Required Data | Required Systems | Implementation Complexity | Time to Deploy | Primary Risk |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Digital WhatsApp/SMS** | VP Digital Collections | Real-time DPD, phone, payment URLs | WhatsApp BSP, SMS Gateway, UPI Switch | **LOW** | 30 Days | Template approval & carrier deliverability |
| **ML Targeting Engine** | Head of Data Science | Account history, DPD, historical touches | AWS/GCP Feature Store, ML Inference API | **MEDIUM** | 45 Days | Model drift & non-random training data |
| **PTP Settlement Bot** | Collections Operations Head| PTP commitment dates, promised amounts | Conversational AI Engine, Payment Webhook | **LOW** | 30 Days | Borrower opt-out / message fatigue |
| **Dialer Attempt Capping** | Contact Center Director | Real-time call logs, daily attempt counts | Vicidial / Genesys Cloud Dialer Rules | **LOW** | 15 Days | Dialer configuration mismatch |
| **Data Quality Pipeline** | Lead Data Engineer | Source CSVs, Core Banking, Gateway logs | dbt, Snowflake / PostgreSQL, Great Expectations | **LOW** | 30 Days | Schema version drift |

---

## 4. Risk Analysis & Mitigation Framework

| Risk Description | Severity | Probability | Empirical Context | Mitigation Strategy |
| :--- | :--- | :--- | :--- | :--- |
| **1. Causal Uplift Shortfall** | **HIGH** | Moderate | Observational data may overstate true targeting elasticity | Deploy Phase 1 RCT pilot (₹2.5 Cr) with 1:1 control holdout before releasing remaining ₹7.5 Cr. |
| **2. Channel Fatigue / Spam Flagging** | **MEDIUM** | Moderate | Excessive WhatsApp dispatches lead to account blocks | Implement frequency capping (max 2 digital touches/week) and verified Meta Green Tick channels. |
| **3. Non-Success Payment Contamination** | **HIGH** | Low | Failed/reversed payments pollute live operational dashboards | Enforce Phase 1 Golden payment validation rules (`payment_status == 'SUCCESS'`). |
| **4. Regulatory / Compliance Scrutiny** | **HIGH** | Low | Calling outside permissible hours or excessive dialing | Hard-lock dialer pacing to compliant hours (08:00 to 19:00 IST) and max 3 attempts/account. |

---

## 5. Management Action Plan: 30 / 60 / 90-Day Execution Roadmap

```
================================================================================
30 / 60 / 90-DAY MANAGEMENT ACTION ROADMAP
================================================================================
[DAYS 1 – 30: INSTRUMENTATION & PILOT FOUNDATION]
- Deploy Phase 1 Data Quality ingestion contracts and real-time payment reconciliation.
- Configure dialer attempt capping rules (max 3 voice attempts per account-month).
- Integrate WhatsApp Business API and automated UPI 1-click settlement gateway.
- Finalize 1:1 randomized holdout design for the 30,000-account master portfolio.

[DAYS 31 – 60: CONTROLLED PILOT EXECUTION & MONITORING]
- Launch Phase 1 Pilot RCT across 15,000 Treatment vs 15,000 Control accounts.
- Deploy automated PTP reminder bot 24 hours prior to promise fulfillment date.
- Monitor weekly contact rates, RPC rates, PTP kept rates, and payment link click-throughs.
- Track guardrail metrics: borrower complaint rate (<0.1%) and payment reversal rate.

[DAYS 61 – 90: FORMAL STAGE-GATE EVALUATION & FULL ROLLOUT]
- Execute formal 60-day econometric evaluation of the RCT Treatment vs Control spread.
- Stage-Gate Decision: If Treatment achieves >= 3.50% incremental recovery uplift,
  release remaining INR 7.50 Cr to fully scale digital ML orchestration across all portfolios.
- Transition legacy manual dialer teams to complex late-stage (>90 DPD) and field escalation.
================================================================================
```
