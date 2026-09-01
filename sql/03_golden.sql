-- ==============================================================================
-- 03_GOLDEN.SQL — PRODUCTION GOLDEN ANALYTICAL DATASET LAYER
-- Project: Collections Analytics Data Platform
-- Phase: 1 (Data Quality, Forensics & Golden Dataset)
-- Description: Builds the definitive Golden analytical tables with strict primary keys,
--              zero join multiplication, multi-window channel attribution, and
--              account x analysis_month monthly performance aggregation.
-- ==============================================================================

-- ==============================================================================
-- TABLE 1: GOLDEN PAYMENTS ATTRIBUTED (Grain: payment_id)
-- ==============================================================================
CREATE OR REPLACE TABLE golden_payments_attributed AS
WITH all_touches AS (
    -- Voice Calls
    SELECT account_id, event_at AS touch_dt, 'VOICE' AS channel, agent_id AS agent_id
    FROM clean_calls_view
    UNION ALL
    -- WhatsApp Digital Touches
    SELECT account_id, event_at AS touch_dt, 'WHATSAPP' AS channel, 'SYSTEM_BOT' AS agent_id
    FROM clean_whatsapp_events_view
    UNION ALL
    -- SMS Digital Touches
    SELECT account_id, event_at AS touch_dt, 'SMS' AS channel, 'SYSTEM_BOT' AS agent_id
    FROM clean_sms_events_view
    UNION ALL
    -- Field Visits
    SELECT account_id, event_at AS touch_dt, 'FIELD' AS channel, agent_id AS agent_id
    FROM clean_field_visits_view
),
payments_base AS (
    SELECT 
        payment_id,
        account_id,
        borrower_id,
        CAST(event_at AS DATE) AS payment_date,
        SUBSTRING(CAST(event_at AS VARCHAR), 1, 7) AS payment_month,
        event_at,
        amount,
        payment_status,
        payment_method,
        provider_id
    FROM clean_payments_success_view
),
attributed_touches AS (
    SELECT 
        p.payment_id,
        t.channel,
        t.agent_id,
        t.touch_dt,
        EXTRACT(EPOCH FROM (p.event_at - t.touch_dt)) / 3600.0 AS lag_hours,
        ROW_NUMBER() OVER (PARTITION BY p.payment_id ORDER BY t.touch_dt DESC) AS touch_rank_latest
    FROM payments_base p
    JOIN all_touches t
        ON p.account_id = t.account_id
       AND t.touch_dt <= p.event_at
       AND t.touch_dt >= p.event_at - INTERVAL '7 DAYS' -- Baseline 7-Day Window
)
SELECT 
    p.payment_id,
    p.account_id,
    p.borrower_id,
    p.payment_date,
    p.payment_month,
    p.event_at,
    p.amount,
    p.payment_status,
    p.payment_method,
    p.provider_id,
    COALESCE(att.channel, 'ORGANIC') AS attr_channel_7d,
    COALESCE(att.agent_id, 'NONE') AS attr_agent_7d,
    ROUND(att.lag_hours, 2) AS attr_lag_hours_7d
FROM payments_base p
LEFT JOIN attributed_touches att
    ON p.payment_id = att.payment_id
   AND att.touch_rank_latest = 1;

-- ==============================================================================
-- TABLE 2: GOLDEN ACCOUNTS MONTHLY (Grain: account_id x analysis_month)
-- ==============================================================================
CREATE OR REPLACE TABLE golden_accounts_monthly AS
WITH analysis_months AS (
    SELECT '2026-01' AS analysis_month UNION ALL
    SELECT '2026-02' AS analysis_month UNION ALL
    SELECT '2026-03' AS analysis_month UNION ALL
    SELECT '2026-04' AS analysis_month UNION ALL
    SELECT '2026-05' AS analysis_month UNION ALL
    SELECT '2026-06' AS analysis_month UNION ALL
    SELECT '2026-07' AS analysis_month UNION ALL
    SELECT '2026-08' AS analysis_month
),
-- 1. Base Spine: 30,000 Accounts x 8 Months = 240,000 Cartesian Rows
account_spine AS (
    SELECT 
        a.account_id,
        a.borrower_id,
        a.loan_type,
        a.principal_amount,
        a.outstanding_amount,
        a.dpd,
        a.risk_segment,
        a.status,
        a.opened_at,
        a.timezone,
        a.schema_version,
        m.analysis_month
    FROM clean_accounts_view a
    CROSS JOIN analysis_months m
),
-- 2. Pre-aggregated Call Metrics
agg_calls AS (
    SELECT 
        c.account_id,
        SUBSTRING(CAST(c.event_at AS VARCHAR), 1, 7) AS analysis_month,
        COUNT(c.call_id) AS total_calls,
        SUM(c.is_answered) AS answered_calls,
        SUM(COALESCE(cd.is_rpc, 0)) AS rpc_calls,
        SUM(c.duration_sec) AS total_call_duration_sec
    FROM clean_calls_view c
    LEFT JOIN clean_call_dispositions_view cd ON c.call_id = cd.call_id
    GROUP BY c.account_id, SUBSTRING(CAST(c.event_at AS VARCHAR), 1, 7)
),
-- 3. Pre-aggregated WhatsApp Metrics
agg_wa AS (
    SELECT 
        account_id,
        SUBSTRING(CAST(event_at AS VARCHAR), 1, 7) AS analysis_month,
        SUM(is_sent) AS whatsapp_sent,
        SUM(is_delivered) AS whatsapp_delivered,
        SUM(is_read) AS whatsapp_read,
        SUM(is_click) AS whatsapp_clicks,
        COUNT(whatsapp_event_id) AS whatsapp_total_events
    FROM clean_whatsapp_events_view
    GROUP BY account_id, SUBSTRING(CAST(event_at AS VARCHAR), 1, 7)
),
-- 4. Pre-aggregated SMS Metrics
agg_sms AS (
    SELECT 
        account_id,
        SUBSTRING(CAST(event_at AS VARCHAR), 1, 7) AS analysis_month,
        SUM(is_sent) AS sms_sent,
        SUM(is_delivered) AS sms_delivered,
        SUM(is_click) AS sms_clicks,
        COUNT(sms_event_id) AS sms_total_events
    FROM clean_sms_events_view
    GROUP BY account_id, SUBSTRING(CAST(event_at AS VARCHAR), 1, 7)
),
-- 5. Pre-aggregated Field Operations Metrics
agg_fv AS (
    SELECT 
        account_id,
        SUBSTRING(CAST(event_at AS VARCHAR), 1, 7) AS analysis_month,
        COUNT(visit_id) AS field_visits_count,
        SUM(is_contacted) AS field_contacts_count,
        SUM(is_ptp) AS field_ptp_count,
        SUM(is_paid) AS field_paid_count
    FROM clean_field_visits_view
    GROUP BY account_id, SUBSTRING(CAST(event_at AS VARCHAR), 1, 7)
),
-- 6. Pre-aggregated Promises to Pay (PTP) Metrics
agg_ptp AS (
    SELECT 
        account_id,
        SUBSTRING(CAST(event_at AS VARCHAR), 1, 7) AS analysis_month,
        COUNT(ptp_id) AS ptp_count,
        SUM(promised_amount) AS ptp_promised_amount,
        SUM(is_kept) AS ptp_kept_count,
        SUM(is_broken) AS ptp_broken_count
    FROM clean_promises_to_pay_view
    GROUP BY account_id, SUBSTRING(CAST(event_at AS VARCHAR), 1, 7)
),
-- 7. Pre-aggregated Net Settlement SUCCESS Payments
agg_pay_success AS (
    SELECT 
        account_id,
        SUBSTRING(CAST(event_at AS VARCHAR), 1, 7) AS analysis_month,
        COUNT(payment_id) AS success_payment_count,
        SUM(amount) AS success_payment_amount
    FROM clean_payments_success_view
    GROUP BY account_id, SUBSTRING(CAST(event_at AS VARCHAR), 1, 7)
),
-- 8. Pre-aggregated Gross / Failed / Reversed Payments for Reconciliation
agg_pay_gross AS (
    SELECT 
        account_id,
        SUBSTRING(CAST(event_at AS VARCHAR), 1, 7) AS analysis_month,
        COUNT(payment_id) AS gross_payment_count,
        SUM(amount) AS gross_payment_amount,
        SUM(CASE WHEN is_failed = 1 THEN amount ELSE 0 END) AS failed_payment_amount,
        SUM(CASE WHEN is_reversed = 1 THEN amount ELSE 0 END) AS reversed_payment_amount
    FROM clean_payments_all_status_view
    GROUP BY account_id, SUBSTRING(CAST(event_at AS VARCHAR), 1, 7)
),
-- 9. Pre-aggregated Complaints Metrics
agg_comp AS (
    SELECT 
        account_id,
        SUBSTRING(CAST(event_at AS VARCHAR), 1, 7) AS analysis_month,
        COUNT(complaint_id) AS complaints_count
    FROM clean_complaints
    GROUP BY account_id, SUBSTRING(CAST(event_at AS VARCHAR), 1, 7)
),
-- 10. Pre-aggregated Daily Targeting Allocations
agg_dt AS (
    SELECT 
        account_id,
        SUBSTRING(CAST(target_date AS VARCHAR), 1, 7) AS analysis_month,
        COUNT(target_id) AS targeted_days_count
    FROM clean_daily_targeting
    GROUP BY account_id, SUBSTRING(CAST(target_date AS VARCHAR), 1, 7)
),
-- 11. Point-in-Time Account Lifecycle Status at Month End
ranked_status_history AS (
    SELECT 
        account_id,
        status AS pit_status,
        event_at,
        SUBSTRING(CAST(event_at AS VARCHAR), 1, 7) AS event_month,
        ROW_NUMBER() OVER (
            PARTITION BY account_id, SUBSTRING(CAST(event_at AS VARCHAR), 1, 7)
            ORDER BY event_at DESC
        ) AS rn
    FROM clean_account_status_history_view
)
SELECT 
    s.account_id,
    s.borrower_id,
    s.analysis_month,
    s.loan_type,
    s.principal_amount,
    s.outstanding_amount,
    s.dpd,
    s.risk_segment,
    s.status AS initial_status,
    COALESCE(rsh.pit_status, s.status) AS pit_status,
    s.opened_at,
    s.timezone,
    s.schema_version,
    -- Telephony Voice Metrics
    COALESCE(c.total_calls, 0) AS total_calls,
    COALESCE(c.answered_calls, 0) AS answered_calls,
    COALESCE(c.rpc_calls, 0) AS rpc_calls,
    COALESCE(c.total_call_duration_sec, 0) AS total_call_duration_sec,
    -- Digital WhatsApp Metrics
    COALESCE(wa.whatsapp_sent, 0) AS whatsapp_sent,
    COALESCE(wa.whatsapp_delivered, 0) AS whatsapp_delivered,
    COALESCE(wa.whatsapp_read, 0) AS whatsapp_read,
    COALESCE(wa.whatsapp_clicks, 0) AS whatsapp_clicks,
    COALESCE(wa.whatsapp_total_events, 0) AS whatsapp_total_events,
    -- Digital SMS Metrics
    COALESCE(sms.sms_sent, 0) AS sms_sent,
    COALESCE(sms.sms_delivered, 0) AS sms_delivered,
    COALESCE(sms.sms_clicks, 0) AS sms_clicks,
    COALESCE(sms.sms_total_events, 0) AS sms_total_events,
    -- Field Operations Metrics
    COALESCE(fv.field_visits_count, 0) AS field_visits_count,
    COALESCE(fv.field_contacts_count, 0) AS field_contacts_count,
    COALESCE(fv.field_ptp_count, 0) AS field_ptp_count,
    COALESCE(fv.field_paid_count, 0) AS field_paid_count,
    -- Commitment (PTP) Metrics
    COALESCE(ptp.ptp_count, 0) AS ptp_count,
    COALESCE(ptp.ptp_promised_amount, 0.00) AS ptp_promised_amount,
    COALESCE(ptp.ptp_kept_count, 0) AS ptp_kept_count,
    COALESCE(ptp.ptp_broken_count, 0) AS ptp_broken_count,
    -- Net Financial Collections (Clean SUCCESS)
    COALESCE(pay_s.success_payment_count, 0) AS success_payment_count,
    COALESCE(pay_s.success_payment_amount, 0.00) AS success_payment_amount,
    -- Gross Financial Reconciliation Metrics
    COALESCE(pay_g.gross_payment_count, 0) AS gross_payment_count,
    COALESCE(pay_g.gross_payment_amount, 0.00) AS gross_payment_amount,
    COALESCE(pay_g.failed_payment_amount, 0.00) AS failed_payment_amount,
    COALESCE(pay_g.reversed_payment_amount, 0.00) AS reversed_payment_amount,
    -- Operational Governance Metrics
    COALESCE(comp.complaints_count, 0) AS complaints_count,
    COALESCE(dt.targeted_days_count, 0) AS targeted_days_count,
    -- Binary Performance Flags
    CASE WHEN COALESCE(c.answered_calls, 0) > 0 OR COALESCE(fv.field_contacts_count, 0) > 0 OR COALESCE(wa.whatsapp_clicks, 0) > 0 OR COALESCE(sms.sms_clicks, 0) > 0 THEN 1 ELSE 0 END AS is_contacted_any_channel,
    CASE WHEN COALESCE(c.rpc_calls, 0) > 0 OR COALESCE(fv.field_contacts_count, 0) > 0 THEN 1 ELSE 0 END AS is_rpc_any_channel,
    CASE WHEN COALESCE(ptp.ptp_count, 0) > 0 THEN 1 ELSE 0 END AS has_ptp,
    CASE WHEN COALESCE(pay_s.success_payment_count, 0) > 0 THEN 1 ELSE 0 END AS has_success_payment
FROM account_spine s
LEFT JOIN agg_calls c ON s.account_id = c.account_id AND s.analysis_month = c.analysis_month
LEFT JOIN agg_wa wa ON s.account_id = wa.account_id AND s.analysis_month = wa.analysis_month
LEFT JOIN agg_sms sms ON s.account_id = sms.account_id AND s.analysis_month = sms.analysis_month
LEFT JOIN agg_fv fv ON s.account_id = fv.account_id AND s.analysis_month = fv.analysis_month
LEFT JOIN agg_ptp ptp ON s.account_id = ptp.account_id AND s.analysis_month = ptp.analysis_month
LEFT JOIN agg_pay_success pay_s ON s.account_id = pay_s.account_id AND s.analysis_month = pay_s.analysis_month
LEFT JOIN agg_pay_gross pay_g ON s.account_id = pay_g.account_id AND s.analysis_month = pay_g.analysis_month
LEFT JOIN agg_comp comp ON s.account_id = comp.account_id AND s.analysis_month = comp.analysis_month
LEFT JOIN agg_dt dt ON s.account_id = dt.account_id AND s.analysis_month = dt.analysis_month
LEFT JOIN ranked_status_history rsh ON s.account_id = rsh.account_id AND s.analysis_month = rsh.event_month AND rsh.rn = 1;
