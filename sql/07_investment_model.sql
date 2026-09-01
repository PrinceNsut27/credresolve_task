-- ==============================================================================
-- 07_INVESTMENT_MODEL.SQL — PRODUCTION FINANCIAL MODEL & ₹10 CR ALLOCATION LAYER
-- Project: Collections Analytics Data Platform
-- Phase: 5 (Investment Recommendation & Financial Model)
-- Description: Computes annualized baseline portfolio recovery, records the ₹10 Cr
--              capital allocation, models Conservative/Base/Upside scenarios, and
--              calculates ROI, payback periods, and break-even thresholds.
-- ==============================================================================

-- ==============================================================================
-- 1. ANNUALIZED BASELINE PORTFOLIO RECOVERY VIEW
-- ==============================================================================
CREATE OR REPLACE VIEW v_annualized_baseline_recovery AS
WITH monthly_clean_baseline AS (
    SELECT 
        analysis_month,
        SUM(success_payment_amount) AS monthly_net_recovery
    FROM golden_accounts_monthly
    WHERE analysis_month <= '2026-07' -- Full 7 operating months
    GROUP BY analysis_month
)
SELECT 
    COUNT(analysis_month) AS full_months_observed,
    ROUND(SUM(monthly_net_recovery), 2) AS observed_7m_recovery,
    ROUND(AVG(monthly_net_recovery), 2) AS avg_monthly_recovery,
    ROUND(AVG(monthly_net_recovery) * 12, 2) AS annualized_baseline_recovery,
    30000 AS total_master_accounts,
    ROUND((AVG(monthly_net_recovery) * 12) / 30000.0, 2) AS annual_yield_per_account
FROM monthly_clean_baseline;

-- ==============================================================================
-- 2. ₹10.00 CRORE INVESTMENT ALLOCATION TABLE
-- ==============================================================================
CREATE OR REPLACE TABLE investment_budget_allocation AS
SELECT * FROM (
    SELECT 
        1 AS lever_rank,
        'Digital Omnichannel Orchestration (WhatsApp/SMS Pacing Engine)' AS investment_area,
        3.50 AS allocation_inr_cr,
        35.0 AS share_pct,
        'DERIVED' AS input_label,
        'Scalable automated digital reminders and 1-click UPI links with near-zero marginal cost.' AS strategic_rationale
    UNION ALL
    SELECT 
        2,
        'ML Dynamic Targeting Engine & Production RCT Platform',
        2.50,
        25.0,
        'DERIVED',
        'Account prioritization to capture +₹596/acct targeting spread and 1:1 randomized holdout testing.'
    UNION ALL
    SELECT 
        3,
        'PTP Fulfillment & Automated Settlement Gateway',
        2.00,
        20.0,
        'OBSERVED',
        'Automated reminders 24h prior to commitment date to recover broken PTPs (75% current break rate).'
    UNION ALL
    SELECT 
        4,
        'Dialer Pacing Optimization & Attempt Capping',
        1.00,
        10.0,
        'OBSERVED',
        'Predictive dialer rules capping attempts at 3 touches, eliminating diminishing returns (5.08% vs 7.78%).'
    UNION ALL
    SELECT 
        5,
        'Data Quality, Real-Time Ingestion & Forensic Auditing Pipeline',
        1.00,
        10.0,
        'OBSERVED',
        'Continuous data contracts preventing phantom financial reporting and reconciling bank settlements.'
) alloc;

-- ==============================================================================
-- 3. FINANCIAL SCENARIO PROJECTION & ROI MODEL
-- ==============================================================================
CREATE OR REPLACE VIEW v_financial_scenario_model AS
WITH baseline_val AS (
    SELECT annualized_baseline_recovery FROM v_annualized_baseline_recovery
),
scenario_inputs AS (
    SELECT 'CONSERVATIVE' AS scenario_name, 1.50 AS uplift_pct, 10.00 AS capex_cr, 'SCENARIO' AS input_label UNION ALL
    SELECT 'BASE (CENTRAL)' AS scenario_name, 3.50 AS uplift_pct, 10.00 AS capex_cr, 'SCENARIO' AS input_label UNION ALL
    SELECT 'UPSIDE' AS scenario_name, 6.00 AS uplift_pct, 10.00 AS capex_cr, 'SCENARIO' AS input_label
)
SELECT 
    s.scenario_name,
    s.uplift_pct,
    s.input_label,
    ROUND(b.annualized_baseline_recovery / 10000000.0, 2) AS baseline_recovery_cr,
    ROUND((b.annualized_baseline_recovery * (s.uplift_pct / 100.0)) / 10000000.0, 2) AS annual_incremental_recovery_cr,
    s.capex_cr AS investment_cost_cr,
    ROUND(((b.annualized_baseline_recovery * (s.uplift_pct / 100.0)) - (s.capex_cr * 10000000.0)) / 10000000.0, 2) AS net_benefit_1yr_cr,
    ROUND((((b.annualized_baseline_recovery * (s.uplift_pct / 100.0)) - (s.capex_cr * 10000000.0)) / (s.capex_cr * 10000000.0)) * 100, 2) AS roi_1yr_pct,
    ROUND(((b.annualized_baseline_recovery * (s.uplift_pct / 100.0))) / (s.capex_cr * 10000000.0), 2) AS recovery_per_rupee_invested,
    ROUND((s.capex_cr * 10000000.0) / ((b.annualized_baseline_recovery * (s.uplift_pct / 100.0)) / 12.0), 1) AS payback_period_months
FROM scenario_inputs s
CROSS JOIN baseline_val b;

-- ==============================================================================
-- 4. BREAK-EVEN CALCULATION QUERY
-- ==============================================================================
CREATE OR REPLACE VIEW v_breakeven_analysis AS
WITH baseline_val AS (
    SELECT annualized_baseline_recovery FROM v_annualized_baseline_recovery
)
SELECT 
    10.00 AS required_breakeven_recovery_cr,
    ROUND(10.00 / 12.0, 2) AS required_monthly_recovery_cr,
    ROUND((100000000.00 / b.annualized_baseline_recovery) * 100, 2) AS breakeven_portfolio_uplift_pct,
    'PILOT FIRST / INVEST WITH CONDITIONS' AS strategic_recommendation
FROM baseline_val b;
