# Analytical Assumption Register

**Project**: Collections Recovery Analytics Platform  
**Phase**: 6 — Final Analytics Pipeline, SQL, Notebook & Reproducibility  
**Status**: COMPLETE & VERIFIED  

---

## 1. Comprehensive Assumption Register

Every critical input, parameter, and modeling assumption across Phases 1–5 is documented below with its formal classification:
- `[OBSERVED]`: Directly measured and verified in source data.
- `[DERIVED]`: Calculated mathematically from observed data without external assumptions.
- `[ASSUMED]`: Business parameter or operational constraint set by domain requirements.
- `[SCENARIO]`: Modeled scenario variation for sensitivity analysis.

| Assumption / Input Parameter | Classification | Value / Rule | Source / File Reference | Analytical Impact | Confidence |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Valid Recovery Definition** | `[OBSERVED]` | `payment_status == 'SUCCESS'` & deduplicated on `payment_id` | `clean_payments.csv`, `sql/02_cleaning.sql` | Eliminates ₹601.7M (+45.7%) in false payment inflation | **HIGH** |
| **Primary Analytical Grain** | `[DERIVED]` | `account_id × analysis_month` (30k accounts × 8 months = 240k rows) | `golden_accounts_monthly.csv`, `sql/03_golden.sql` | Prevents 1-to-many join explosion and eliminates denominator bias | **HIGH** |
| **Primary Baseline Lookback Window**| `[DERIVED]` | 7-day lookback window for last-touch attribution | `golden_payments_attributed.csv` | Attributes 20.16% of recovery to direct operational touch | **HIGH** |
| **August 2026 Horizon Truncation** | `[OBSERVED]` | Operations terminate on 2026-08-08 (8 days of data) | `daily_avg_recovery`, `docs/11_percent_claim.md` | Prevents false -74.8% month-over-month drop-off interpretation | **HIGH** |
| **Annualized Baseline Recovery** | `[DERIVED]` | ₹2,174,527,318.80 (₹217.45 Cr / year) | `monthly_recovery_metrics.csv` | Establishes the portfolio baseline yield for financial modeling | **HIGH** |
| **Capital Investment Budget** | `[ASSUMED]` | ₹10.00 Crore (INR 100,000,000.00) | `TASK.md`, `GOAL.md` | Fixed capital expenditure budget for optimization | **HIGH** |
| **Targeting Base Incremental Uplift**| `[DERIVED]` | +₹11.13M on modern campaigns (+7.04% vs organic baseline) | `targeting_counterfactual_accounts.csv` | Establishes the empirical anchor for base-case ROI (+3.50% portfolio lift) | **HIGH** |
| **Conservative Scenario Uplift** | `[SCENARIO]` | +1.50% annual portfolio recovery lift | `docs/financial_model.md` | Generates +₹3.26 Cr incremental recovery (36.8m payback) | **HIGH** |
| **Base Case Scenario Uplift** | `[SCENARIO]` | +3.50% annual portfolio recovery lift | `docs/financial_model.md` | Generates +₹7.61 Cr incremental recovery (15.8m payback) | **HIGH** |
| **Upside Scenario Uplift** | `[SCENARIO]` | +6.00% annual portfolio recovery lift | `docs/financial_model.md` | Generates +₹13.05 Cr incremental recovery (9.2m payback) | **MODERATE** |
| **Digital Channel Marginal Cost** | `[ASSUMED]` | Near-zero variable marginal cost (<₹0.20/msg) | `docs/investment_recommendation.md` | Justifies digital-first investment allocation (35% share) | **HIGH** |
| **Voice Attempt Cap** | `[DERIVED]` | Cap at 3 attempts/account-month | `driver_accounts_monthly.csv` | Eliminates diminishing returns and reallocates agent capacity | **HIGH** |
