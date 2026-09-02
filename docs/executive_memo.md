# Executive Decision Memorandum: Collections Recovery Optimization & ₹10 Cr Capital Strategy

**Prepared for**: CredResolve Leadership & Board of Directors  
**From**: Head of Analytics & Recovery Strategy  
**Date**: September 2, 2026  
**Subject**: Empirical Audit of Recovery Performance, 11% Claim Verdict & ₹10.00 Cr Capital Allocation  
**Core Recommendation**: **INVEST ₹10.00 CR IN OPTION 4: BETTER BORROWER TARGETING (PHASE-GATED PILOT FIRST)**  

---

## 1. What Happened? (Actual Recovery Trajectory)
- **Net Collections Stability**: Across the 7 complete operating months (January–July 2026), true net settled recovery totaled **₹1,268,474,269.33**, averaging **₹181.21M/month** (annualized baseline of **₹217.45 Cr**).
- **Zero Growth**: Net monthly recovery was **₹187.23M in Jan 2026** and **₹187.24M in Jul 2026** (**+0.007% cumulative growth**). Daily run-rate was flat at **~₹6.0M/day**.
- **Data Quality Reality**: Raw payment logs overstated cash collections by **+45.73% (+₹601.67M)** due to ₹283.5M in failed, ₹194.9M in pending, ₹97.4M in reversed, and ₹25.9M in duplicate payments. Clean net recovery is **₹1,315,583,964.64** through Aug 8, 2026.

---

## 2. Why Did It Happen? (Major Drivers)
1. **0.0% Portfolio Mix Shift `[FACT]`**: Kitagawa decomposition proves loan product and DPD risk mix remained identical across months; macro recovery fluctuations were 100% calendar-driven.
2. **Outreach Diminishing Returns `[FACT]`**: Recovery peaks at **2–3 contact attempts (7.78%)** and falls to **5.08% at >5 touches** due to dialers repeatedly redialing unresponsive accounts.
3. **Agent Tenure Invariance `[FACT]`**: Agent recovery productivity is flat across tenure tiers (~₹111k/month), disproving human hiring as a scalable recovery lever.
4. **Telephony Carrier Parity `[FACT]`**: All 15 carrier vendors exhibit identical ~20% connection rates; non-connection is driven by borrower call screening, not carrier routing.

---

## 3. Is the 11% Month-on-Month Claim True?
**Verdict: PARTIALLY TRUE (Calendar Artifact / Single-Month Anomaly)**.
- **The Observation**: Valid collections did increase by **+11.03%** in March 2026 (₹188.91M) vs. February 2026 (₹170.14M).
- **The Cause**: February had **28 days** while March had **31 days** (**+10.71% more operating days**).
- **The Reality**: Daily average collections were **₹6.077M/day in Feb vs. ₹6.094M/day in Mar (+0.29% change)**. Performance immediately dropped by **-7.29% in April**. The 11% improvement was an illusion of the calendar.

---

## 4. How Confident Are We?
- **Data & Forensics**: **HIGH CONFIDENCE (100% RECONCILED)**. Reconciled across 240,000 Cartesian account-months with ₹0.00 ledger delta.
- **Targeting Lift**: **STRONG EVIDENCE (QUASI-EXPERIMENTAL)**. Targeted accounts generated **+₹596/account yield premium (+0.74% pts recovery rate)** yielding **+₹11.13M incremental recovery**.
- **Causal Guarantee**: An initial 90-day Randomized Controlled Trial (RCT) is required to eliminate unobserved debtor behavioral confounders before full-scale capital deployment.

---

## 5. What Should Leadership Do?
1. **Stop Brute-Force Dialing**: Enforce an automated cap of **3 outreach touches per account-month** to eliminate wasted carrier minutes and borrower harassment.
2. **Lock Ingestion Contracts**: Enforce bank-settlement deduplication to prevent non-success payments from inflating operational reports.
3. **Transition to Dynamic ML Targeting**: Replace static rule-based queues with predictive propensity decisioning.

---

## 6. Where Should the ₹10.00 Crore Go?
Allocate **100% of the ₹10.00 Cr budget to OPTION 4: BETTER BORROWER TARGETING**, structured as a **Phase-Gated Capital Release**:
- **Why it beats all 5 alternatives**:
  - *Beats Telephony*: Carrier connection rates are identical (~20%); carrier upgrades yield 0.0% lift.
  - *Beats Hiring Agents*: Human productivity is flat across tenure (~₹111k) with high fixed loaded cost (₹250/hr).
  - *Beats AI Voice*: Voice bots hit the same ~20% borrower screening barrier as live agents.
  - *Beats WhatsApp-Only*: Digital without predictive account prioritization triggers spam blocks.
  - *Beats Field Operations*: Field visits cost ₹350/visit for only 10% volume, creating negative unit margins.
- **Phase 1 Pilot Commitment (Months 1–3: ₹2.50 Cr)**: Fund a 90-day 1:1 RCT across 30,000 accounts to prove causal elasticity.
- **Phase 2 Enterprise Scale-Out (Months 4–12: ₹7.50 Cr)**: Unlocked if and only if Phase 1 demonstrates $\ge +3.50\%$ incremental recovery uplift.

---

## 7. Expected Financial Impact

| Scenario | Portfolio Uplift (%) | Annual Incremental Recovery | Capital Invested | Payback Period | 2-Year Net Benefit |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Conservative (Downside)** | +1.50% | +₹3.26 Cr / year | ₹10.00 Cr | 36.8 Months | -₹3.48 Cr |
| **Base Case (Central)** | **+3.50%** | **+₹7.61 Cr / year** | **₹10.00 Cr** | **15.8 Months** | **+₹5.22 Cr (ROI: +52.2%)** |
| **Upside (Optimistic)** | +6.00% | +₹13.05 Cr / year | ₹10.00 Cr | 9.2 Months | +₹16.10 Cr (ROI: +161.0%) |

- **Break-Even Threshold**: **4.60% 1-year uplift (₹10.00 Cr)** or **2.30% 2-year uplift (₹5.00 Cr/year)**.

---

## 8. Key Risks & Mitigation Strategy
1. **Causal Uplift Shortfall**: If real-world RCT uplift is $<+2.30\%$, **halt Phase 2 immediately**, preserving ₹7.50 Cr of capital.
2. **Borrower Message Fatigue**: Enforce a hard frequency cap of $\le 2$ digital touches/week to keep complaint rates $<0.10\%$.
3. **Data Ledger Contamination**: Enforce automated Silver-to-Gold validation contracts (`payment_status == 'SUCCESS'`).

