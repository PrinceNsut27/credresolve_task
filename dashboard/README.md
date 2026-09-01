# Collections Recovery Executive Dashboard

**Platform**: Streamlit-based Interactive Analytics & Decision-Support Application  
**Data Sources**: `analytics/monthly_recovery_metrics.csv`, `analytics/driver_accounts_monthly.csv`, `analytics/targeting_counterfactual_accounts.csv`  

---

## 1. How to Launch the Dashboard Locally

Run the following command from the project root:

```bash
# From workspace root (c:\Users\Prince\Desktop\cred\)
streamlit run dashboard/app.py
```

The application will open in your default browser at `http://localhost:8501`.

---

## 2. Dashboard Feature Overview

1. **📊 Executive Cockpit**:
   - High-level KPI cards (Total Net Collections, Daily Run-Rate Yield, Contact Rate, Recovery per Agent-Hour).
   - Dual-mode chart displaying Monthly Net Recovery alongside the calendar-normalized Daily Run-Rate.
   - Conversion Funnel and 7-Day Attribution Breakdown.

2. **🔍 11% Claim Audit**:
   - Dedicated forensic audit panel detailing the empirical finding behind the "+11% MoM" claim.
   - Decomposition of the March vs. February jump (+10.71% calendar days effect vs. +0.29% daily operational gain).
   - Multi-metric testing matrix across all recovery definitions.

3. **📈 Driver & Mix Analysis**:
   - Recovery rates by DPD Delinquency Tiers (1–30 DPD, 31–60 DPD, 61–90 DPD, 91–180 DPD).
   - Attempt frequency analysis illustrating the peak at 2–3 attempts and sharp diminishing returns beyond 5 attempts (negative selection bias).
   - Kitagawa shift-share mix decomposition verifying that 0.0% of growth was driven by portfolio mix.

4. **🎯 Targeting Counterfactual**:
   - Quasi-experimental comparison of targeted accounts vs. organic non-targeted control benchmarks.
   - Incremental recovery scenario modeling (+₹11.13M Base Case uplift on modern campaigns).

5. **💰 ₹10 Cr Investment Strategy**:
   - Interactive ₹10.00 Cr capital allocation breakdown across the 5 prioritized operational levers.
   - 12-month scenario model (Conservative, Base, Upside) with ROI and payback calculators.
   - Break-even portfolio uplift threshold (4.60% uplift / ₹10.00 Cr annual incremental recovery).

6. **📋 Data Governance & Lineage**:
   - End-to-end Medallion pipeline DAG (Raw → Staging → Clean → Golden → Analytics).
   - Mathematical QA matrix confirming zero join explosion, 100% unique primary keys, and exact payment reconciliation.
