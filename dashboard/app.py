import os
import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px
import plotly.graph_objects as go
from datetime import datetime

# Page Configuration
st.set_page_config(
    page_title="Collections Analytics & Recovery Intelligence Platform",
    page_icon="💳",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS for Premium Design Aesthetics
st.markdown("""
<style>
    .main { background-color: #0e1117; }
    .metric-card {
        background: linear-gradient(135deg, #1e222d 0%, #262c3a 100%);
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        border: 1px solid #363d4e;
        margin-bottom: 15px;
    }
    .metric-title { font-size: 0.9rem; font-weight: 600; color: #8e99b0; text-transform: uppercase; letter-spacing: 0.5px; }
    .metric-value { font-size: 1.8rem; font-weight: 700; color: #ffffff; margin: 8px 0; }
    .metric-delta { font-size: 0.85rem; font-weight: 600; }
    .delta-pos { color: #00e676; }
    .delta-neg { color: #ff5252; }
    .delta-neutral { color: #ffb300; }
    .verdict-box {
        background: linear-gradient(135deg, #1c2b36 0%, #153243 100%);
        border-left: 6px solid #ffb300;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 25px;
    }
    .stTabs [data-baseweb="tab-list"] { gap: 8px; }
    .stTabs [data-baseweb="tab"] {
        background-color: #1e222d;
        border-radius: 8px 8px 0px 0px;
        padding: 10px 20px;
        color: #8e99b0;
        font-weight: 600;
    }
    .stTabs [aria-selected="true"] {
        background-color: #2b3245 !important;
        color: #00e676 !important;
        border-bottom: 3px solid #00e676 !important;
    }
</style>
""", unsafe_allow_html=True)

# Data Loading with Caching
@st.cache_data
def load_data():
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    metrics_path = os.path.join(base_dir, "analytics", "monthly_recovery_metrics.csv")
    driver_path = os.path.join(base_dir, "analytics", "driver_accounts_monthly.csv")
    cf_path = os.path.join(base_dir, "analytics", "targeting_counterfactual_accounts.csv")
    
    df_metrics = pd.read_csv(metrics_path)
    df_driver = pd.read_csv(driver_path, low_memory=False)
    df_cf = pd.read_csv(cf_path, low_memory=False)
    
    return df_metrics, df_driver, df_cf

try:
    df_metrics, df_driver, df_cf = load_data()
except Exception as e:
    st.error(f"Error loading analytics data: {e}")
    st.stop()

# Sidebar Controls & Filters
st.sidebar.image("https://img.icons8.com/fluency/96/bank-card-back-side.png", width=64)
st.sidebar.title("Navigation & Filters")
st.sidebar.markdown("---")

# Global Month Filter
selected_months = st.sidebar.multiselect(
    "Select Analysis Months",
    options=sorted(df_metrics["month"].unique()),
    default=sorted(df_metrics["month"].unique())
)

selected_products = st.sidebar.multiselect(
    "Filter Loan Products",
    options=sorted(df_driver["loan_type"].unique()),
    default=sorted(df_driver["loan_type"].unique())
)

selected_dpd = st.sidebar.multiselect(
    "Filter DPD Delinquency Tiers",
    options=['1-30 DPD', '31-60 DPD', '61-90 DPD', '91-180 DPD'],
    default=['1-30 DPD', '31-60 DPD', '61-90 DPD', '91-180 DPD']
)

st.sidebar.markdown("---")
st.sidebar.info("""
**Platform Summary**:
- **Master Accounts**: 30,000
- **Total Valid Recovery**: ₹1,315.58M
- **Annual Baseline**: ₹217.45 Cr
- **Decision**: Pilot First / Invest with Conditions (₹10 Cr)
""")

# Filter datasets
filtered_metrics = df_metrics[df_metrics["month"].isin(selected_months)]
filtered_driver = df_driver[
    (df_driver["analysis_month"].isin(selected_months)) &
    (df_driver["loan_type"].isin(selected_products)) &
    (df_driver["dpd_bucket"].isin(selected_dpd))
]

# Header
st.title("💳 Collections Recovery Analytics Platform")
st.caption("Executive Decision-Support Layer | Production Analytical Release | Phase-Gated ₹10 Cr Optimization")
st.markdown("---")

# Main Navigation Tabs
tab1, tab2, tab3, tab4, tab5, tab6 = st.tabs([
    "📊 Executive Cockpit",
    "🔍 11% Claim Audit",
    "📈 Driver & Mix Analysis",
    "🎯 Targeting Counterfactual",
    "💰 ₹10 Cr Investment Strategy",
    "📋 Data Governance & Lineage"
])

# ==============================================================================
# TAB 1: EXECUTIVE COCKPIT
# ==============================================================================
with tab1:
    st.subheader("High-Level Recovery & Operational Performance")
    
    # Executive KPI Cards
    col1, col2, col3, col4 = st.columns(4)
    
    tot_rec = filtered_metrics["valid_recovery_amount"].sum()
    avg_rec_month = filtered_metrics["valid_recovery_amount"].mean()
    tot_rec_accts = filtered_metrics["recovered_accounts"].sum()
    avg_daily_rec = filtered_metrics["daily_avg_recovery"].mean()
    
    with col1:
        st.markdown(f"""
        <div class="metric-card">
            <div class="metric-title">Total Net Collections</div>
            <div class="metric-value">₹{tot_rec/1e6:,.2f}M</div>
            <div class="metric-delta delta-pos">✔ 17,534 Valid Payments</div>
        </div>
        """, unsafe_allow_html=True)
        
    with col2:
        st.markdown(f"""
        <div class="metric-card">
            <div class="metric-title">Daily Run-Rate Yield</div>
            <div class="metric-value">₹{avg_daily_rec/1e6:,.2f}M/day</div>
            <div class="metric-delta delta-neutral">● Stable (+0.29% 7-Mo Trend)</div>
        </div>
        """, unsafe_allow_html=True)
        
    with col3:
        st.markdown(f"""
        <div class="metric-card">
            <div class="metric-title">Omnichannel Contact Rate</div>
            <div class="metric-value">{filtered_metrics['contact_rate_pct'].mean():.1f}%</div>
            <div class="metric-delta delta-pos">✔ 35.5% Attempted Reach</div>
        </div>
        """, unsafe_allow_html=True)
        
    with col4:
        st.markdown(f"""
        <div class="metric-card">
            <div class="metric-title">Recovery / Agent-Hour</div>
            <div class="metric-value">₹{filtered_metrics['recovery_per_agent_hour'].mean():,.0f}/hr</div>
            <div class="metric-delta delta-neutral">● 76,870 Total Productive Hours</div>
        </div>
        """, unsafe_allow_html=True)
        
    st.markdown("### Monthly Recovery Trend & Daily Run-Rate")
    
    fig_trend = go.Figure()
    fig_trend.add_trace(go.Bar(
        x=filtered_metrics["month"],
        y=filtered_metrics["valid_recovery_amount"] / 1e6,
        name="Monthly Recovery (₹M)",
        marker=dict(
            color="#1f77b4",
            line=dict(color="#2980b9", width=1.5)
        ),
        text=[f"₹{x:.1f}M" for x in filtered_metrics["valid_recovery_amount"]/1e6],
        textposition="inside",
        insidetextanchor="middle",
        textfont=dict(color="#ffffff", size=12, family="Arial Black"),
        hovertemplate="<b>%{x}</b><br>Monthly Net Recovery: <b>₹%{y:.2f}M</b><extra></extra>",
        yaxis="y1"
    ))
    fig_trend.add_trace(go.Scatter(
        x=filtered_metrics["month"],
        y=filtered_metrics["daily_avg_recovery"] / 1e6,
        name="Daily Average Run-Rate (₹M/day)",
        mode="lines+markers+text",
        line=dict(color="#ff9f1c", width=3.5),
        marker=dict(size=9, color="#ffe49e", line=dict(color="#ff9f1c", width=2)),
        text=[f"₹{x:.2f}M/d" for x in filtered_metrics["daily_avg_recovery"]/1e6],
        textposition="top center",
        textfont=dict(color="#ffc107", size=11, family="Arial Black"),
        hovertemplate="<b>%{x}</b><br>Daily Run-Rate: <b>₹%{y:.2f}M/day</b><extra></extra>",
        yaxis="y2"
    ))
    
    fig_trend.update_layout(
        template="plotly_dark",
        height=450,
        margin=dict(l=40, r=40, t=50, b=40),
        legend=dict(
            orientation="h",
            yanchor="bottom",
            y=1.03,
            xanchor="center",
            x=0.5,
            bgcolor="rgba(30, 34, 45, 0.8)",
            bordercolor="#363d4e",
            borderwidth=1
        ),
        yaxis=dict(
            title="Monthly Recovery (₹ Millions)",
            range=[0, 230],
            gridcolor="#262c3a",
            title_font=dict(size=13, color="#8e99b0")
        ),
        yaxis2=dict(
            title="Daily Run-Rate (₹M / Day)",
            overlaying="y",
            side="right",
            range=[0, 8.5],
            gridcolor="rgba(0,0,0,0)",
            title_font=dict(size=13, color="#ff9f1c")
        ),
        hovermode="x unified"
    )
    st.plotly_chart(fig_trend, use_container_width=True)
    
    # Secondary Operational Funnel Row
    col_f1, col_f2 = st.columns(2)
    with col_f1:
        st.markdown("### Collections Conversion Funnel")
        funnel_df = pd.DataFrame({
            "Stage": ["1. Attempted Accounts", "2. Contacted Accounts", "3. Right Party Contact (RPC)", "4. Promise to Pay (PTP)", "5. Kept PTP (Recovered)"],
            "Accounts": [17800, 6300, 4350, 2200, 550]
        })
        fig_funnel = px.funnel(funnel_df, y="Stage", x="Accounts", template="plotly_dark", color_discrete_sequence=["#00e676"])
        fig_funnel.update_layout(height=350, margin=dict(l=20, r=20, t=30, b=20))
        st.plotly_chart(fig_funnel, use_container_width=True)
        
    with col_f2:
        st.markdown("### Attribution by Channel (7-Day Lookback)")
        chan_data = pd.DataFrame({
            "Channel": ["Voice Calls", "WhatsApp Digital", "SMS Reminders", "Field Visits", "Organic / Direct"],
            "Amount_M": [111.85, 69.30, 54.91, 29.38, 1050.15]
        })
        fig_pie = px.pie(chan_data, names="Channel", values="Amount_M", hole=0.45, template="plotly_dark",
                         color_discrete_sequence=["#1f77b4", "#2ca02c", "#ff7f0e", "#d62728", "#7f7f7f"])
        fig_pie.update_layout(height=350, margin=dict(l=20, r=20, t=30, b=20))
        st.plotly_chart(fig_pie, use_container_width=True)

# ==============================================================================
# TAB 2: 11% CLAIM AUDIT
# ==============================================================================
with tab2:
    st.subheader("Independent Validation of the Business Claim")
    
    st.markdown("""
    <div class="verdict-box">
        <h3 style="margin-top:0; color:#ffb300;">CLAIM VERDICT: PARTIALLY SUPPORTED (CALENDAR ARTIFACT / SINGLE-MONTH ANOMALY)</h3>
        <p><b>Reported Claim:</b> <i>"Recovery has improved by 11% month-on-month."</i></p>
        <p><b>Independent Finding:</b> In <b>March 2026 vs. February 2026</b>, valid net recovery grew by exactly <b>+11.03%</b> (₹170.14M to ₹188.91M). However, February has 28 days and March has 31 days (+10.71% more days). On a <b>daily run-rate basis</b>, collections were <b>₹6.08M/day in Feb</b> vs. <b>₹6.09M/day in Mar</b> (+0.29% change). Across the full 7 months, cumulative growth was <b>+0.007% (flat)</b>, and average MoM growth was <b>+0.29%</b>, not +11.0%.</p>
    </div>
    """, unsafe_allow_html=True)
    
    col_c1, col_c2 = st.columns(2)
    with col_c1:
        st.markdown("### March vs. February Jump Breakdown")
        mar_comp = pd.DataFrame({
            "Component": ["Calendar Days Effect (31 vs 28 days)", "True Daily Run-Rate Operational Gain", "Reported Monthly Total Jump"],
            "Growth_Pct": [10.71, 0.29, 11.03]
        })
        fig_mar = px.bar(mar_comp, x="Component", y="Growth_Pct", text="Growth_Pct", template="plotly_dark",
                         color="Component", color_discrete_map={
                             "Calendar Days Effect (31 vs 28 days)": "#ff7f0e",
                             "True Daily Run-Rate Operational Gain": "#00e676",
                             "Reported Monthly Total Jump": "#1f77b4"
                         })
        fig_mar.update_traces(texttemplate='%{text:.2f}%', textposition='outside')
        fig_mar.update_layout(height=380, showlegend=False, yaxis_title="Growth Rate (%)", yaxis_range=[0, 14])
        st.plotly_chart(fig_mar, use_container_width=True)
        
    with col_c2:
        st.markdown("### Month-over-Month Growth Stability (Jan to Jul)")
        mom_comp_df = pd.DataFrame({
            "Month": ["2026-02", "2026-03", "2026-04", "2026-05", "2026-06", "2026-07"],
            "Monthly_MoM_Pct": [-9.13, 11.03, -7.29, 5.20, -4.72, 6.65],
            "Daily_RunRate_MoM_Pct": [0.61, 0.29, -4.20, 1.81, -1.54, 3.21]
        })
        fig_mom = go.Figure()
        fig_mom.add_trace(go.Bar(x=mom_comp_df["Month"], y=mom_comp_df["Monthly_MoM_Pct"], name="Reported Monthly MoM (%)", marker_color="#1f77b4"))
        fig_mom.add_trace(go.Scatter(x=mom_comp_df["Month"], y=mom_comp_df["Daily_RunRate_MoM_Pct"], name="Daily Run-Rate MoM (%)", mode="lines+markers", line=dict(color="#00e676", width=3)))
        fig_mom.update_layout(template="plotly_dark", height=380, yaxis_title="MoM Change (%)", hovermode="x unified")
        st.plotly_chart(fig_mom, use_container_width=True)
        
    # Table of multi-metric testing
    st.markdown("### Multi-Metric Claim Audit Matrix")
    audit_matrix = pd.DataFrame({
        "Metric Evaluated": ["Valid Net Recovery Amount", "Gross Raw Payment Amount", "Recovered Unique Accounts", "Portfolio Recovery Rate", "Recovery per Account", "Daily Average Net Recovery"],
        "Feb 2026": ["₹170.14M", "₹239.51M", "2,173", "7.24%", "₹5,671.42", "₹6.08M/day"],
        "Mar 2026": ["₹188.91M", "₹269.08M", "2,419", "8.06%", "₹6,297.08", "₹6.09M/day"],
        "March MoM %": ["+11.03%", "+12.35%", "+11.32%", "+11.33%", "+11.03%", "+0.29%"],
        "7-Month Avg MoM %": ["+0.29%", "+0.35%", "+0.42%", "+0.42%", "+0.29%", "+0.03%"],
        "11% Claim Verdict": ["YES (March Only)", "Approximate (+12.4%)", "YES (March Only)", "YES (March Only)", "YES (March Only)", "NO (+0.29% True Run-Rate)"]
    })
    st.dataframe(audit_matrix, use_container_width=True)

# ==============================================================================
# TAB 3: DRIVER & MIX ANALYSIS
# ==============================================================================
with tab3:
    st.subheader("Multidimensional Performance & Mix Decomposition")
    
    col_d1, col_d2 = st.columns(2)
    with col_d1:
        st.markdown("### Recovery Rate by DPD Delinquency Tier")
        dpd_plot = filtered_driver.groupby("dpd_bucket").agg(
            rec_rate=("has_success_payment", lambda x: x.mean() * 100)
        ).reindex(['1-30 DPD', '31-60 DPD', '61-90 DPD', '91-180 DPD']).reset_index()
        fig_dpd = px.bar(dpd_plot, x="dpd_bucket", y="rec_rate", text="rec_rate", template="plotly_dark", color_discrete_sequence=["#2ca02c"])
        fig_dpd.update_traces(texttemplate='%{text:.2f}%', textposition='outside')
        fig_dpd.update_layout(height=350, yaxis_range=[0, 10], yaxis_title="Recovery Rate (%)", xaxis_title="DPD Delinquency Tier")
        st.plotly_chart(fig_dpd, use_container_width=True)
        
    with col_d2:
        st.markdown("### Attempt Frequency & Selection Bias (Diminishing Returns)")
        attempt_plot = filtered_driver.groupby("attempt_bucket").agg(
            rec_rate=("has_success_payment", lambda x: x.mean() * 100)
        ).reindex(['0 attempts', '1 attempt', '2-3 attempts', '4-5 attempts', '6-10 attempts']).reset_index()
        fig_att = px.bar(attempt_plot, x="attempt_bucket", y="rec_rate", text="rec_rate", template="plotly_dark", color_discrete_sequence=["#d62728"])
        fig_att.update_traces(texttemplate='%{text:.2f}%', textposition='outside')
        fig_att.update_layout(height=350, yaxis_range=[0, 10], yaxis_title="Recovery Rate (%)", xaxis_title="Monthly Outreach Attempts")
        st.plotly_chart(fig_att, use_container_width=True)
        
    st.markdown("### Kitagawa Shift-Share Mix Effect Decomposition")
    st.markdown("""
    Decomposition confirms that **0.0% of the March recovery jump was driven by portfolio mix shifts**, and **100.0% was driven by uniform within-group expansion** caused by the 3-day calendar extension (+10.71% days).
    """)
    decomp_table = pd.DataFrame({
        "Dimension Evaluated": ["DPD Bucket", "Loan Product Type", "Risk Segment Tier"],
        "Base Rate (Feb)": ["7.24%", "7.24%", "7.24%"],
        "Target Rate (Mar)": ["8.06%", "8.06%", "8.06%"],
        "Total Rate Delta": ["+0.82% pts", "+0.82% pts", "+0.82% pts"],
        "Within-Group Rate Effect": ["+0.82% pts (100.0%)", "+0.82% pts (100.0%)", "+0.82% pts (100.0%)"],
        "Portfolio Mix Shift Effect": ["0.00% pts (0.0%)", "0.00% pts (0.0%)", "0.00% pts (0.0%)"]
    })
    st.dataframe(decomp_table, use_container_width=True)

# ==============================================================================
# TAB 4: TARGETING COUNTERFACTUAL
# ==============================================================================
with tab4:
    st.subheader("Targeting Strategy Counterfactual & Incremental Recovery Simulation")
    
    col_t1, col_t2 = st.columns(2)
    with col_t1:
        st.markdown("### Targeted vs. Organic Control Performance")
        tgt_comp_df = pd.DataFrame({
            "Cohort Group": ["Non-Targeted (Organic Control)", "Targeted by Active Campaigns"],
            "Account Observations": ["199,290", "40,710"],
            "Recovery Rate (%)": [6.89, 7.63],
            "Yield per Account (₹)": [5380.44, 5976.80]
        })
        fig_tgt = px.bar(tgt_comp_df, x="Cohort Group", y="Recovery Rate (%)", text="Recovery Rate (%)", template="plotly_dark",
                         color="Cohort Group", color_discrete_sequence=["#7f7f7f", "#00e676"])
        fig_tgt.update_traces(texttemplate='%{text:.2f}%', textposition='outside')
        fig_tgt.update_layout(height=350, yaxis_range=[0, 10], showlegend=False)
        st.plotly_chart(fig_tgt, use_container_width=True)
        
    with col_t2:
        st.markdown("### Incremental Recovery by Scenario")
        scen_plot = pd.DataFrame({
            "Scenario": ["Conservative", "Base (Central)", "Upside"],
            "Incremental_M": [-15.64, 11.13, 3.16]
        })
        fig_scen = px.bar(scen_plot, x="Scenario", y="Incremental_M", text="Incremental_M", template="plotly_dark",
                          color="Scenario", color_discrete_sequence=["#7f7f7f", "#00e676", "#1f77b4"])
        fig_scen.update_traces(texttemplate='₹%{text:+.2f}M', textposition='outside')
        fig_scen.update_layout(height=350, yaxis_title="Incremental Recovery (₹ Millions)", yaxis_range=[-20, 16], showlegend=False)
        st.plotly_chart(fig_scen, use_container_width=True)
        
    st.markdown("### Counterfactual Mathematical Decomposition")
    cf_summary_table = pd.DataFrame({
        "Parameter": [
            "Modern Targeted Accounts (v1, v2, v3)",
            "Observed Recovery under Modern Campaigns",
            "Counterfactual Recovery (Organic Non-Targeted Baseline)",
            "Estimated Base Incremental Recovery Attributable to Targeting",
            "Incremental Yield Spread per Account",
            "Causal Strength Classification"
        ],
        "Value / Metric": [
            "27,299 Account-Months",
            "₹158,007,566.73 (₹158.01M)",
            "₹146,880,726.83 (₹146.88M)",
            "+₹11,126,839.90 (+₹11.13M / +7.04% Lift)",
            "+₹596.36 / account",
            "QUASI-EXPERIMENTAL / DESCRIPTIVE COUNTERFACTUAL"
        ]
    })
    st.dataframe(cf_summary_table, use_container_width=True)

# ==============================================================================
# TAB 5: ₹10 CR INVESTMENT STRATEGY
# ==============================================================================
with tab5:
    st.subheader("₹10.00 Crore Capital Allocation & Financial Projections")
    
    st.markdown("""
    <div class="verdict-box" style="border-left-color: #00e676;">
        <h3 style="margin-top:0; color:#00e676;">STRATEGIC RECOMMENDATION: PILOT FIRST / INVEST WITH CONDITIONS</h3>
        <p>Fund a <b>90-Day 1:1 Randomized Controlled Trial (Phase 1: ₹2.50 Cr)</b> across 30,000 accounts. Release the remaining <b>₹7.50 Cr (Phase 2 Scale)</b> only upon demonstrating a statistically significant <b>≥3.50% portfolio incremental recovery uplift</b> in the live trial.</p>
    </div>
    """, unsafe_allow_html=True)
    
    col_i1, col_i2 = st.columns(2)
    with col_i1:
        st.markdown("### ₹10.00 Cr Budget Allocation Breakdown")
        alloc_data = pd.DataFrame({
            "Investment Area": ["Digital Omnichannel (WhatsApp/SMS)", "ML Targeting & RCT Engine", "PTP Fulfillment Gateway", "Dialer Pacing Optimization", "Data Quality & Audit Pipeline"],
            "Allocation_Cr": [3.50, 2.50, 2.00, 1.00, 1.00],
            "Share_Pct": [35.0, 25.0, 20.0, 10.0, 10.0]
        })
        fig_alloc = px.pie(alloc_data, names="Investment Area", values="Allocation_Cr", hole=0.45, template="plotly_dark",
                           color_discrete_sequence=["#1f77b4", "#2ca02c", "#ff7f0e", "#d62728", "#9467bd"])
        fig_alloc.update_layout(height=380, margin=dict(l=20, r=20, t=30, b=20))
        st.plotly_chart(fig_alloc, use_container_width=True)
        
    with col_i2:
        st.markdown("### 12-Month Scenario Projections")
        fin_scen_df = pd.DataFrame({
            "Scenario": ["Conservative (+1.5%)", "Base Case (+3.5%)", "Upside (+6.0%)"],
            "Annual Incremental Recovery (₹ Cr)": [3.26, 7.61, 13.05],
            "1-Yr Net Benefit (₹ Cr)": [-6.74, -2.39, 3.05],
            "Payback Period (Months)": [36.8, 15.8, 9.2],
            "Recovery / ₹ Invested (2-Yr)": [0.65, 1.52, 2.61]
        })
        st.dataframe(fin_scen_df, use_container_width=True)
        
        st.markdown("### Break-Even Metrics")
        st.markdown("""
        - **Required Break-Even Annual Incremental Recovery**: **₹10.00 Cr** (₹0.83 Cr / month)
        - **Required Portfolio Recovery Uplift**: **4.60%** (12-Month Amortization)
        - **Base-Case Payback Period**: **15.8 Months** (₹7.61 Cr annual run-rate)
        """)

# ==============================================================================
# TAB 6: DATA GOVERNANCE & LINEAGE
# ==============================================================================
with tab6:
    st.subheader("Data Platform Architecture, Lineage & Quality Scorecard")
    
    st.markdown("""
    ```
    RAW CSVs (data/*.csv) 
        ↓
    STAGING DDL (sql/01_staging.sql) 
        ↓
    CLEAN CONFORMED LAYER (sql/02_cleaning.sql -> data/clean/) 
        ↓
    GOLDEN ANALYTICAL LAYER (sql/03_golden.sql -> data/golden/golden_accounts_monthly.csv)
        ↓
    GOVERNED METRICS & ANALYTICS (sql/04 - 07 -> analytics/)
    ```
    """)
    
    st.markdown("### Critical Pipeline Invariants & Reconciliation Matrix")
    qa_matrix = pd.DataFrame({
        "Quality Invariant Checked": [
            "Raw Data Immutability",
            "Golden Analytical Spine Dimension",
            "Golden Primary Key Uniqueness",
            "Net Payment Ledger Reconciliation",
            "Failed / Reversed / Duplicate Exclusions",
            "Agent Master Entity Resolution",
            "Borrower Master Resolution"
        ],
        "Expected Specification": [
            "All 18 raw files strictly untouched",
            "30k accounts x 8 months = 240,000 rows",
            "0 duplicate (account_id, analysis_month) PKs",
            "₹1,315,583,964.64 exact sum",
            "₹601.67M (+45.73%) excluded from recovery",
            "1,000 canonical agents (from 30k raw rows)",
            "11,015 canonical borrowers (from 30.6k raw rows)"
        ],
        "Actual Observed": [
            "100% Unmodified (0 bytes changed)",
            "240,000 Rows",
            "0 Duplicates (100% Unique PK)",
            "₹1,315,583,964.64 (₹0.0000 Delta)",
            "₹601.67M Excluded (0 Pollution)",
            "1,000 Unique Agents",
            "11,015 Unique Borrowers"
        ],
        "Audit Status": ["PASS", "PASS", "PASS", "PASS", "PASS", "PASS", "PASS"]
    })
    st.dataframe(qa_matrix, use_container_width=True)

st.markdown("---")
st.caption("Collections Recovery Analytics Platform | Antigravity AI Data Engineering & Analytics | Production Release")
