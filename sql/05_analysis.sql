-- ==============================================================================
-- 05_ANALYSIS.SQL — PRODUCTION DRIVER ANALYSIS & SEGMENT PERFORMANCE QUERIES
-- Project: Collections Analytics Data Platform
-- Phase: 3 (Driver Analysis, Mix Effects & Statistical Investigation)
-- Description: Detailed multidimensional performance queries across DPD buckets,
--              loan products, risk segments, attempt frequencies, agent tenure,
--              telephony vendors, and calling schedules.
-- ==============================================================================

-- ==============================================================================
-- 1. ENRICHED DRIVER ACCOUNTS MONTHLY VIEW
-- ==============================================================================
CREATE OR REPLACE VIEW v_driver_accounts_monthly AS
SELECT 
    gam.*,
    COALESCE(b.city, 'UNKNOWN_CITY') AS borrower_city,
    COALESCE(b.state, 'UNKNOWN_STATE') AS borrower_state,
    CASE 
        WHEN gam.dpd <= 30 THEN '1-30 DPD'
        WHEN gam.dpd <= 60 THEN '31-60 DPD'
        WHEN gam.dpd <= 90 THEN '61-90 DPD'
        WHEN gam.dpd <= 180 THEN '91-180 DPD'
        ELSE '180+ DPD'
    END AS dpd_bucket,
    CASE 
        WHEN gam.outstanding_amount < 25000 THEN '<25k'
        WHEN gam.outstanding_amount < 50000 THEN '25k-50k'
        WHEN gam.outstanding_amount < 100000 THEN '50k-100k'
        WHEN gam.outstanding_amount < 200000 THEN '100k-200k'
        ELSE '200k+'
    END AS balance_tier,
    (gam.total_calls + gam.whatsapp_sent + gam.sms_sent + gam.field_visits_count) AS total_attempts_account,
    CASE 
        WHEN (gam.total_calls + gam.whatsapp_sent + gam.sms_sent + gam.field_visits_count) = 0 THEN '0 attempts'
        WHEN (gam.total_calls + gam.whatsapp_sent + gam.sms_sent + gam.field_visits_count) = 1 THEN '1 attempt'
        WHEN (gam.total_calls + gam.whatsapp_sent + gam.sms_sent + gam.field_visits_count) <= 3 THEN '2-3 attempts'
        WHEN (gam.total_calls + gam.whatsapp_sent + gam.sms_sent + gam.field_visits_count) <= 5 THEN '4-5 attempts'
        WHEN (gam.total_calls + gam.whatsapp_sent + gam.sms_sent + gam.field_visits_count) <= 10 THEN '6-10 attempts'
        ELSE '10+ attempts'
    END AS attempt_bucket
FROM golden_accounts_monthly gam
LEFT JOIN golden_borrowers_dim b ON gam.borrower_id_clean = b.borrower_id;

-- ==============================================================================
-- 2. DPD BUCKET PERFORMANCE BREAKDOWN
-- ==============================================================================
CREATE OR REPLACE VIEW v_dpd_performance_monthly AS
SELECT 
    analysis_month,
    dpd_bucket,
    COUNT(account_id) AS total_accounts,
    SUM(has_success_payment) AS recovered_accounts,
    ROUND(SUM(has_success_payment) * 100.0 / COUNT(account_id), 2) AS recovery_rate_pct,
    SUM(success_payment_amount) AS valid_recovery_amount,
    ROUND(SUM(success_payment_amount) / COUNT(account_id), 2) AS recovery_per_account,
    ROUND(SUM(is_contacted_any_channel) * 100.0 / COUNT(account_id), 2) AS contact_rate_pct,
    ROUND(SUM(is_rpc_any_channel) * 100.0 / NULLIF(SUM(is_contacted_any_channel), 0), 2) AS rpc_rate_pct,
    ROUND(SUM(has_ptp) * 100.0 / NULLIF(SUM(is_rpc_any_channel), 0), 2) AS ptp_rate_pct,
    ROUND(SUM(ptp_kept_count) * 100.0 / NULLIF(SUM(ptp_count), 0), 2) AS ptp_kept_rate_pct
FROM v_driver_accounts_monthly
GROUP BY analysis_month, dpd_bucket
ORDER BY analysis_month ASC, dpd_bucket ASC;

-- ==============================================================================
-- 3. PRODUCT / LOAN TYPE PERFORMANCE BREAKDOWN
-- ==============================================================================
CREATE OR REPLACE VIEW v_product_performance_monthly AS
SELECT 
    analysis_month,
    loan_type,
    COUNT(account_id) AS total_accounts,
    SUM(has_success_payment) AS recovered_accounts,
    ROUND(SUM(has_success_payment) * 100.0 / COUNT(account_id), 2) AS recovery_rate_pct,
    SUM(success_payment_amount) AS valid_recovery_amount,
    ROUND(SUM(success_payment_amount) / COUNT(account_id), 2) AS recovery_per_account
FROM v_driver_accounts_monthly
GROUP BY analysis_month, loan_type
ORDER BY analysis_month ASC, loan_type ASC;

-- ==============================================================================
-- 4. ATTEMPT FREQUENCY & DIMINISHING RETURNS QUERY
-- ==============================================================================
CREATE OR REPLACE VIEW v_attempt_frequency_performance AS
SELECT 
    attempt_bucket,
    COUNT(account_id) AS account_observations,
    SUM(has_success_payment) AS recovered_accounts,
    ROUND(SUM(has_success_payment) * 100.0 / COUNT(account_id), 2) AS recovery_rate_pct,
    SUM(success_payment_amount) AS valid_recovery_amount,
    ROUND(SUM(success_payment_amount) / COUNT(account_id), 2) AS recovery_per_account,
    ROUND(SUM(is_contacted_any_channel) * 100.0 / COUNT(account_id), 2) AS contact_rate_pct
FROM v_driver_accounts_monthly
GROUP BY attempt_bucket
ORDER BY MIN(total_attempts_account) ASC;

-- ==============================================================================
-- 5. AGENT TENURE PERFORMANCE QUERY
-- ==============================================================================
CREATE OR REPLACE VIEW v_agent_tenure_performance AS
WITH agent_tenure_calc AS (
    SELECT 
        a.agent_id,
        a.agent_name,
        a.team,
        a.vendor_id,
        a.joined_at,
        CASE 
            WHEN EXTRACT(EPOCH FROM (TIMESTAMP '2026-08-01' - a.joined_at)) / (30.4375 * 86400) < 3 THEN '0-3m (New)'
            WHEN EXTRACT(EPOCH FROM (TIMESTAMP '2026-08-01' - a.joined_at)) / (30.4375 * 86400) < 6 THEN '3-6m'
            WHEN EXTRACT(EPOCH FROM (TIMESTAMP '2026-08-01' - a.joined_at)) / (30.4375 * 86400) < 12 THEN '6-12m'
            WHEN EXTRACT(EPOCH FROM (TIMESTAMP '2026-08-01' - a.joined_at)) / (30.4375 * 86400) < 24 THEN '12-24m'
            ELSE '24m+ (Veteran)'
        END AS tenure_bucket
    FROM golden_agents_dim a
),
agent_attributed_recovery AS (
    SELECT 
        attr_agent_7d AS agent_id,
        COUNT(payment_id) AS attributed_payments,
        SUM(amount) AS attributed_recovery_amount
    FROM golden_payments_attributed
    WHERE attr_agent_7d != 'NONE'
    GROUP BY attr_agent_7d
),
agent_call_stats AS (
    SELECT 
        agent_id_clean AS agent_id,
        COUNT(call_id) AS total_calls,
        SUM(is_rpc) AS rpc_calls
    FROM golden_calls_clean
    GROUP BY agent_id_clean
)
SELECT 
    t.tenure_bucket,
    COUNT(t.agent_id) AS total_agents,
    SUM(COALESCE(c.total_calls, 0)) AS total_calls,
    SUM(COALESCE(c.rpc_calls, 0)) AS rpc_calls,
    ROUND(SUM(COALESCE(c.rpc_calls, 0)) * 100.0 / NULLIF(SUM(COALESCE(c.total_calls, 0)), 0), 2) AS rpc_rate_pct,
    SUM(COALESCE(r.attributed_payments, 0)) AS attributed_payments,
    SUM(COALESCE(r.attributed_recovery_amount, 0.00)) AS attributed_recovery_amount,
    ROUND(SUM(COALESCE(r.attributed_recovery_amount, 0.00)) / COUNT(t.agent_id), 2) AS recovery_per_agent
FROM agent_tenure_calc t
LEFT JOIN agent_call_stats c ON t.agent_id = c.agent_id
LEFT JOIN agent_attributed_recovery r ON t.agent_id = r.agent_id
GROUP BY t.tenure_bucket
ORDER BY t.tenure_bucket ASC;

-- ==============================================================================
-- 6. TELEPHONY VENDOR CONNECTIVITY & RPC PERFORMANCE QUERY
-- ==============================================================================
CREATE OR REPLACE VIEW v_vendor_telephony_performance AS
SELECT 
    vendor_id,
    COUNT(call_id) AS total_calls,
    SUM(CASE WHEN call_status = 'ANSWERED' THEN 1 ELSE 0 END) AS answered_calls,
    ROUND(SUM(CASE WHEN call_status = 'ANSWERED' THEN 1 ELSE 0 END) * 100.0 / COUNT(call_id), 2) AS connection_rate_pct,
    SUM(is_rpc) AS rpc_calls,
    ROUND(SUM(is_rpc) * 100.0 / NULLIF(SUM(CASE WHEN call_status = 'ANSWERED' THEN 1 ELSE 0 END), 0), 2) AS rpc_rate_pct,
    ROUND(AVG(duration_sec), 1) AS avg_duration_sec
FROM golden_calls_clean
GROUP BY vendor_id
ORDER BY total_calls DESC;
