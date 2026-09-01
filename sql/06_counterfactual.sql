-- ==============================================================================
-- 06_COUNTERFACTUAL.SQL — PRODUCTION TARGETING COUNTERFACTUAL & INCREMENTAL RECOVERY
-- Project: Collections Analytics Data Platform
-- Phase: 4 (Targeting Counterfactual & Incremental Recovery Simulation)
-- Description: Computes observed vs counterfactual recovery under targeted and non-targeted
--              regimes, evaluates campaign strategy versions, and models incremental lift.
-- ==============================================================================

-- ==============================================================================
-- 1. TARGETED VS NON-TARGETED OVERALL PERFORMANCE
-- ==============================================================================
CREATE OR REPLACE VIEW v_targeting_performance_summary AS
WITH account_targeting_mapped AS (
    SELECT 
        gam.account_id,
        gam.analysis_month,
        gam.has_success_payment,
        gam.success_payment_amount,
        CASE WHEN dt.target_id IS NOT NULL THEN 1 ELSE 0 END AS is_targeted,
        COALESCE(c.strategy_version, 'NOT_TARGETED') AS strategy_version,
        COALESCE(dt.recommended_channel, 'NOT_TARGETED') AS recommended_channel
    FROM golden_accounts_monthly gam
    LEFT JOIN clean_daily_targeting dt 
        ON gam.account_id = dt.account_id 
       AND gam.analysis_month = SUBSTRING(CAST(dt.target_date AS VARCHAR), 1, 7)
    LEFT JOIN clean_campaigns c 
        ON dt.campaign_id = c.campaign_id
)
SELECT 
    is_targeted,
    COUNT(account_id) AS total_account_observations,
    SUM(has_success_payment) AS recovered_accounts,
    ROUND(SUM(has_success_payment) * 100.0 / COUNT(account_id), 2) AS recovery_rate_pct,
    SUM(success_payment_amount) AS total_recovery_amount,
    ROUND(SUM(success_payment_amount) / COUNT(account_id), 2) AS recovery_per_account
FROM account_targeting_mapped
GROUP BY is_targeted;

-- ==============================================================================
-- 2. PERFORMANCE BY CAMPAIGN STRATEGY VERSION
-- ==============================================================================
CREATE OR REPLACE VIEW v_strategy_version_performance AS
WITH account_strategy_mapped AS (
    SELECT 
        gam.account_id,
        gam.analysis_month,
        gam.has_success_payment,
        gam.success_payment_amount,
        COALESCE(c.strategy_version, 'NOT_TARGETED') AS strategy_version
    FROM golden_accounts_monthly gam
    LEFT JOIN clean_daily_targeting dt 
        ON gam.account_id = dt.account_id 
       AND gam.analysis_month = SUBSTRING(CAST(dt.target_date AS VARCHAR), 1, 7)
    LEFT JOIN clean_campaigns c 
        ON dt.campaign_id = c.campaign_id
)
SELECT 
    strategy_version,
    COUNT(account_id) AS total_account_observations,
    SUM(has_success_payment) AS recovered_accounts,
    ROUND(SUM(has_success_payment) * 100.0 / COUNT(account_id), 2) AS recovery_rate_pct,
    SUM(success_payment_amount) AS total_recovery_amount,
    ROUND(SUM(success_payment_amount) / COUNT(account_id), 2) AS recovery_per_account
FROM account_strategy_mapped
GROUP BY strategy_version
ORDER BY recovery_per_account DESC;

-- ==============================================================================
-- 3. INCREMENTAL RECOVERY COUNTERFACTUAL SIMULATION QUERY
-- ==============================================================================
CREATE OR REPLACE VIEW v_incremental_recovery_simulation AS
WITH baseline_organic AS (
    SELECT 
        ROUND(SUM(success_payment_amount) / COUNT(account_id), 2) AS organic_yield_per_account
    FROM golden_accounts_monthly gam
    LEFT JOIN clean_daily_targeting dt 
        ON gam.account_id = dt.account_id 
       AND gam.analysis_month = SUBSTRING(CAST(dt.target_date AS VARCHAR), 1, 7)
    WHERE dt.target_id IS NULL
),
modern_campaign_observed AS (
    SELECT 
        COUNT(gam.account_id) AS modern_targeted_accounts,
        SUM(gam.success_payment_amount) AS observed_recovery_amount
    FROM golden_accounts_monthly gam
    JOIN clean_daily_targeting dt 
        ON gam.account_id = dt.account_id 
       AND gam.analysis_month = SUBSTRING(CAST(dt.target_date AS VARCHAR), 1, 7)
    JOIN clean_campaigns c 
        ON dt.campaign_id = c.campaign_id
    WHERE c.strategy_version IN ('v1', 'v2', 'v3')
)
SELECT 
    m.modern_targeted_accounts,
    m.observed_recovery_amount,
    ROUND(m.modern_targeted_accounts * b.organic_yield_per_account, 2) AS counterfactual_recovery_amount,
    ROUND(m.observed_recovery_amount - (m.modern_targeted_accounts * b.organic_yield_per_account), 2) AS incremental_recovery_amount,
    ROUND((m.observed_recovery_amount - (m.modern_targeted_accounts * b.organic_yield_per_account)) 
          / (m.modern_targeted_accounts * b.organic_yield_per_account) * 100, 2) AS incremental_lift_pct,
    'QUASI-EXPERIMENTAL (Organic Non-Targeted Counterfactual Baseline)' AS causal_classification
FROM modern_campaign_observed m
CROSS JOIN baseline_organic b;
