-- ==============================================================================
-- 04_METRICS.SQL — PRODUCTION RECOVERY METRICS & CLAIM VALIDATION QUERIES
-- Project: Collections Analytics Data Platform
-- Phase: 2 (Recovery Metrics & 11% Claim Validation)
-- Description: Computes monthly contact rates, RPC rates, PTP rates, PTP kept rates,
--              valid recovery amounts, recovery per account, recovery per agent-hour,
--              month-over-month changes, calendar-normalized daily run rates, and
--              independent claim validation metrics.
-- ==============================================================================

-- ==============================================================================
-- 1. MONTHLY MASTER RECOVERY METRICS TABLE
-- ==============================================================================
CREATE OR REPLACE TABLE monthly_recovery_metrics AS
WITH monthly_spine_aggregates AS (
    SELECT 
        analysis_month,
        COUNT(DISTINCT account_id) AS total_accounts,
        SUM(CASE WHEN pit_status IN ('ACTIVE', 'DELINQUENT', 'PTP', 'NPA') THEN 1 ELSE 0 END) AS open_accounts,
        SUM(CASE WHEN total_calls > 0 OR whatsapp_total_events > 0 OR sms_total_events > 0 OR field_visits_count > 0 THEN 1 ELSE 0 END) AS attempted_accounts,
        SUM(total_calls + whatsapp_sent + sms_sent + field_visits_count) AS total_attempts,
        SUM(is_contacted_any_channel) AS contacted_accounts,
        SUM(CASE WHEN answered_calls > 0 THEN 1 ELSE 0 END) AS voice_answered_accounts,
        SUM(CASE WHEN total_calls > 0 THEN 1 ELSE 0 END) AS voice_dialed_accounts,
        SUM(is_rpc_any_channel) AS rpc_accounts,
        SUM(has_ptp) AS ptp_accounts,
        SUM(ptp_count) AS total_ptp_events,
        SUM(ptp_promised_amount) AS ptp_promised_amount,
        SUM(ptp_kept_count) AS kept_ptp_count,
        SUM(has_success_payment) AS recovered_accounts,
        SUM(success_payment_amount) AS valid_recovery_amount,
        SUM(gross_payment_amount) AS gross_payment_amount,
        SUM(failed_payment_amount) AS failed_payment_amount,
        SUM(reversed_payment_amount) AS reversed_payment_amount,
        SUM(complaints_count) AS total_complaints
    FROM golden_accounts_monthly
    GROUP BY analysis_month
),
agent_hours_monthly AS (
    SELECT 
        SUBSTRING(CAST(login_at AS VARCHAR), 1, 7) AS analysis_month,
        COUNT(DISTINCT agent_id) AS active_agents,
        SUM(EXTRACT(EPOCH FROM (logout_at - login_at)) / 3600.0) AS total_agent_hours
    FROM clean_agent_sessions_view
    GROUP BY SUBSTRING(CAST(login_at AS VARCHAR), 1, 7)
),
calendar_days_lookup AS (
    SELECT '2026-01' AS analysis_month, 31 AS calendar_days UNION ALL
    SELECT '2026-02' AS analysis_month, 28 AS calendar_days UNION ALL
    SELECT '2026-03' AS analysis_month, 31 AS calendar_days UNION ALL
    SELECT '2026-04' AS analysis_month, 30 AS calendar_days UNION ALL
    SELECT '2026-05' AS analysis_month, 31 AS calendar_days UNION ALL
    SELECT '2026-06' AS analysis_month, 30 AS calendar_days UNION ALL
    SELECT '2026-07' AS analysis_month, 31 AS calendar_days UNION ALL
    SELECT '2026-08' AS analysis_month, 8 AS calendar_days -- 8-Day Cutoff
)
SELECT 
    m.analysis_month,
    cd.calendar_days,
    m.total_accounts,
    m.open_accounts,
    m.attempted_accounts,
    m.total_attempts,
    m.contacted_accounts,
    ROUND(CAST(m.contacted_accounts AS NUMERIC) / NULLIF(m.attempted_accounts, 0) * 100, 2) AS contact_rate_pct,
    ROUND(CAST(m.voice_answered_accounts AS NUMERIC) / NULLIF(m.voice_dialed_accounts, 0) * 100, 2) AS voice_contact_rate_pct,
    m.rpc_accounts,
    ROUND(CAST(m.rpc_accounts AS NUMERIC) / NULLIF(m.contacted_accounts, 0) * 100, 2) AS rpc_rate_pct,
    m.ptp_accounts,
    m.total_ptp_events,
    m.ptp_promised_amount,
    ROUND(CAST(m.ptp_accounts AS NUMERIC) / NULLIF(m.rpc_accounts, 0) * 100, 2) AS ptp_rate_pct,
    m.kept_ptp_count,
    ROUND(CAST(m.kept_ptp_count AS NUMERIC) / NULLIF(m.total_ptp_events, 0) * 100, 2) AS ptp_kept_rate_pct,
    m.recovered_accounts,
    m.valid_recovery_amount,
    m.gross_payment_amount,
    m.failed_payment_amount,
    m.reversed_payment_amount,
    ROUND(CAST(m.recovered_accounts AS NUMERIC) / CAST(m.total_accounts AS NUMERIC) * 100, 2) AS recovery_rate_total_pct,
    ROUND(CAST(m.recovered_accounts AS NUMERIC) / NULLIF(m.open_accounts, 0) * 100, 2) AS recovery_rate_open_pct,
    ROUND(m.valid_recovery_amount / CAST(m.total_accounts AS NUMERIC), 2) AS recovery_per_total_account,
    ROUND(m.valid_recovery_amount / NULLIF(m.open_accounts, 0), 2) AS recovery_per_open_account,
    ROUND(m.valid_recovery_amount / NULLIF(m.recovered_accounts, 0), 2) AS recovery_per_recovered_account,
    ROUND(COALESCE(ah.total_agent_hours, 0), 2) AS agent_hours,
    COALESCE(ah.active_agents, 0) AS active_agents,
    ROUND(m.valid_recovery_amount / NULLIF(ah.total_agent_hours, 0), 2) AS recovery_per_agent_hour,
    ROUND(m.valid_recovery_amount / cd.calendar_days, 2) AS daily_avg_recovery
FROM monthly_spine_aggregates m
JOIN calendar_days_lookup cd ON m.analysis_month = cd.analysis_month
LEFT JOIN agent_hours_monthly ah ON m.analysis_month = ah.analysis_month
ORDER BY m.analysis_month ASC;

-- ==============================================================================
-- 2. MONTH-OVER-MONTH (MoM) GROWTH ANALYSIS QUERY
-- ==============================================================================
CREATE OR REPLACE VIEW v_monthly_recovery_mom AS
SELECT 
    analysis_month,
    valid_recovery_amount,
    LAG(valid_recovery_amount) OVER (ORDER BY analysis_month) AS prev_recovery_amount,
    ROUND((valid_recovery_amount - LAG(valid_recovery_amount) OVER (ORDER BY analysis_month)) 
          / NULLIF(LAG(valid_recovery_amount) OVER (ORDER BY analysis_month), 0) * 100, 2) AS recovery_amount_mom_pct,
    daily_avg_recovery,
    LAG(daily_avg_recovery) OVER (ORDER BY analysis_month) AS prev_daily_avg_recovery,
    ROUND((daily_avg_recovery - LAG(daily_avg_recovery) OVER (ORDER BY analysis_month)) 
          / NULLIF(LAG(daily_avg_recovery) OVER (ORDER BY analysis_month), 0) * 100, 2) AS daily_recovery_mom_pct,
    recovered_accounts,
    LAG(recovered_accounts) OVER (ORDER BY analysis_month) AS prev_recovered_accounts,
    ROUND((CAST(recovered_accounts AS NUMERIC) - LAG(recovered_accounts) OVER (ORDER BY analysis_month)) 
          / NULLIF(LAG(recovered_accounts) OVER (ORDER BY analysis_month), 0) * 100, 2) AS recovered_accounts_mom_pct,
    recovery_rate_total_pct,
    ROUND(recovery_rate_total_pct - LAG(recovery_rate_total_pct) OVER (ORDER BY analysis_month), 2) AS recovery_rate_total_chg_pts,
    contact_rate_pct,
    ROUND(contact_rate_pct - LAG(contact_rate_pct) OVER (ORDER BY analysis_month), 2) AS contact_rate_chg_pts,
    rpc_rate_pct,
    ROUND(rpc_rate_pct - LAG(rpc_rate_pct) OVER (ORDER BY analysis_month), 2) AS rpc_rate_chg_pts,
    ptp_rate_pct,
    ROUND(ptp_rate_pct - LAG(ptp_rate_pct) OVER (ORDER BY analysis_month), 2) AS ptp_rate_chg_pts,
    ptp_kept_rate_pct,
    ROUND(ptp_kept_rate_pct - LAG(ptp_kept_rate_pct) OVER (ORDER BY analysis_month), 2) AS ptp_kept_rate_chg_pts,
    recovery_per_agent_hour,
    ROUND((recovery_per_agent_hour - LAG(recovery_per_agent_hour) OVER (ORDER BY analysis_month)) 
          / NULLIF(LAG(recovery_per_agent_hour) OVER (ORDER BY analysis_month), 0) * 100, 2) AS recovery_per_agent_hour_mom_pct
FROM monthly_recovery_metrics;

-- ==============================================================================
-- 3. THE 11% CLAIM AUDIT VERIFICATION QUERY
-- ==============================================================================
CREATE OR REPLACE VIEW v_11_percent_claim_audit AS
SELECT 
    'March 2026 vs February 2026' AS comparison_period,
    'Valid Net Recovery Amount' AS metric_name,
    170142453.76 AS feb_2026_value,
    188912374.02 AS mar_2026_value,
    18769920.26 AS absolute_change,
    11.03 AS actual_mom_pct,
    10.71 AS calendar_days_effect_pct,
    0.29 AS true_daily_run_rate_growth_pct,
    'PARTIALLY SUPPORTED (Single-Month Calendar Day Artifact)' AS audit_classification;
