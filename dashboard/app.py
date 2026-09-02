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
    .main { background-color: #0e1117; font-family: 'Inter', sans-serif; }
    .metric-card {
        background: linear-gradient(135deg, #1e222d 0%, #262c3a 100%);
        border-radius: 10px;
        padding: 16px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        border: 1px solid #363d4e;
        margin-bottom: 12px;
    }
    .metric-title { font-size: 0.82rem; font-weight: 600; color: #8e99b0; text-transform: uppercase; letter-spacing: 0.5px; }
    .metric-value { font-size: 1.6rem; font-weight: 700; color: #ffffff; margin: 4px 0; }
    .metric-delta { font-size: 0.8rem; font-weight: 600; }
    .delta-pos { color: #00e676; }
    .delta-neg { color: #ff5252; }
    .delta-neutral { color: #ffb300; }
    .ceo-grid-card {
        background: #1e222d;
        border-radius: 10px;
        padding: 18px;
        border: 1px solid #363d4e;
        height: 100%;
    }
    .ceo-grid-header {
        font-size: 1.05rem;
        font-weight: 700;
        margin-bottom: 12px;
        padding-bottom: 6px;
        border-bottom: 2px solid #363d4e;
    }
    .verdict-box {
        background: linear-gradient(135deg, #1c2b36 0%, #153243 100%);
        border-left: 6px solid #ffb300;
        padding: 16px;
        border-radius: 8px;
        margin-bottom: 20px;
    }
    .stTabs [data-baseweb="tab-list"] { gap: 8px; }
    .stTabs [data-baseweb="tab"] {
        background-color: #1e222d;
        border-radius: 8px 8px 0px 0px;
        padding: 8px 18px;
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
st.sidebar.title("Navigation & Scope")
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
**Executive Quick Reference**:
- **Dataset Coverage**: Jan 1 to Aug 8, 2026 (7.25 Months)
- **Net Collections**: ₹1,315.58M (17,534 valid payments)
- **Annual Baseline**: ₹217.45 Cr
- **11% Claim**: Partially Supported (Calendar Artifact)
- **₹10 Cr Capital**: Option 4 Better Borrower Targeting
- **RCT Guardrail**: Phase 1 (₹2.5 Cr) -> Phase 2 (₹7.5 Cr)
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
st.caption("CEO Executive Cockpit | Production Analytical Release | Phase-Gated ₹10 Cr Capital Allocation")
st.markdown("---")

# Main Navigation Tabs
tab1, tab2, tab3, tab4, tab5, tab6 = st.tabs([
    "👑 60-Second CEO Cockpit",
    "🔍 11% Claim Audit",
    "📈 Driver & Mix Decomposition",
    "🎯 Targeting Counterfactual",
    "💰 ₹10 Cr Investment Decision",
    "📋 Data Lineage & Governance"
])

# ==============================================================================
# TAB 1: 60-SECOND CEO COCKPIT (TRUE ONE-SCREEN EXECUTIVE DASHBOARD)
# ==============================================================================
with tab1:
    # 1. Top Executive KPI Bar
    k1, k2, k3, k4, k5 = st.columns(5)
    
    tot_rec = filtered_metrics["valid_recovery_amount"].sum()
    avg_daily_rec = filtered_metrics["daily_avg_recovery"].mean()
    
    with k1:
        st.markdown(f"""
        <div class="metric-card">
            <div class="metric-title">Actual Net Collections</div>
            <div class="metric-value">₹{tot_rec/1e6:,.1f}M</div>
            <div class="metric-delta delta-pos">✔ 17,534 Valid Payments</div>
        </div>
        """, unsafe_allow_html=True)
    with k2:
        st.markdown(f"""
        <div class="metric-card">
            <div class="metric-title">Daily Run-Rate</div>
            <div class="metric-value">₹{avg_daily_rec/1e6:,.2f}M/d</div>
            <div class="metric-delta delta-neutral">● Flat (+0.29% 7-Mo Trend)</div>
        </div>
        """, unsafe_allow_html=True)
    with k3:
        st.markdown(f"""
        <div class="metric-card">
            <div class="metric-title">11% MoM Claim Verdict</div>
            <div class="metric-value" style="font-size:1.25rem; color:#ffb300;">Calendar Artifact</div>
            <div class="metric-delta delta-neutral">31 vs 28 Days (+10.7%)</div>
        </div>
        """, unsafe_allow_html=True)
    with k4:
        st.markdown(f"""
        <div class="metric-card">
            <div class="metric-title">Data Quality Warning</div>
            <div class="metric-value" style="font-size:1.25rem; color:#ff5252;">-₹601.7M Excluded</div>
            <div class="metric-delta delta-neg">Raw +45.7% Gross Inflation</div>
        </div>
        """, unsafe_allow_html=True)
    with k5:
        st.markdown(f"""
        <div class="metric-card">
            <div class="metric-title">₹10 Cr Capital Lever</div>
            <div class="metric-value" style="font-size:1.15rem; color:#00e676;">Better Targeting</div>
            <div class="metric-delta delta-pos">+₹7.61 Cr/yr | 15.8m Payback</div>
        </div>
        """, unsafe_allow_html=True)

    st.markdown("<div style='height: 10px;'></div>", unsafe_allow_html=True)

    # 2. Executive 4-Quadrant Decision Matrix (Answers: WHAT HAPPENED? WHY? SO WHAT? WHAT SHOULD WE DO?)
    q_col1, q_col2 = st.columns(2)
    
    # Quadrant 1: WHAT HAPPENED?
    with q_col1:
        st.markdown("""
        <div class="ceo-grid-card">
            <div class="ceo-grid-header" style="color: #64b5f6;">
                1. WHAT HAPPENED? — Flat Recovery & Calendar Disparity
            </div>
        """, unsafe_allow_html=True)
        
        fig_trend = go.Figure()
        fig_trend.add_trace(go.Bar(
            x=filtered_metrics["month"],
            y=filtered_metrics["valid_recovery_amount"] / 1e6,
            name="Monthly Net Recovery (₹M)",
            marker=dict(color="#1f77b4", line=dict(color="#2980b9", width=1)),
            text=[f"₹{x:.1f}M" for x in filtered_metrics["valid_recovery_amount"]/1e6],
            textposition="inside",
            textfont=dict(color="#ffffff", size=10),
            yaxis="y1"
        ))
        fig_trend.add_trace(go.Scatter(
            x=filtered_metrics["month"],
            y=filtered_metrics["daily_avg_recovery"] / 1e6,
            name="Daily Run-Rate (₹M/day)",
            mode="lines+markers",
            line=dict(color="#ff9f1c", width=2.5),
            marker=dict(size=6, color="#ffe49e"),
            yaxis="y2"
        ))
        fig_trend.update_layout(
            template="plotly_dark",
            height=260,
            margin=dict(l=30, r=30, t=10, b=20),
            legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="center", x=0.5, font=dict(size=10)),
            yaxis=dict(title="Monthly (₹M)", range=[0, 220], gridcolor="#262c3a", title_font=dict(size=10)),
            yaxis2=dict(title="Daily (₹M/d)", overlaying="y", side="right", range=[0, 8.0], gridcolor="rgba(0,0,0,0)", title_font=dict(size=10)),
            hovermode="x unified"
        )
        st.plotly_chart(fig_trend, use_container_width=True)
        st.caption("📌 **Takeaway**: Collections stayed flat at ~₹6.0M/day. The March +11% jump was driven by 3 extra operating days.")
        st.markdown("</div>", unsafe_allow_html=True)

    # Quadrant 2: WHY DID IT HAPPEN?
    with q_col2:
        st.markdown("""
        <div class="ceo-grid-card">
            <div class="ceo-grid-header" style="color: #81c784;">
                2. WHY DID IT HAPPEN? — Drivers & Diminishing Returns
            </div>
        """, unsafe_allow_html=True)
        
        att_data = pd.DataFrame({
            "Attempts": ["0", "1", "2-3", "4-5", "6-10"],
            "Recovery_Rate": [6.89, 7.35, 7.78, 6.92, 5.08]
        })
        fig_att = px.bar(att_data, x="Attempts", y="Recovery_Rate", text="Recovery_Rate", template="plotly_dark",
                         color="Recovery_Rate", color_continuous_scale="Viridis")
        fig_att.update_traces(texttemplate='%{text:.2f}%', textposition='outside', textfont=dict(size=10))
        fig_att.update_layout(
            height=260,
            margin=dict(l=30, r=20, t=10, b=20),
            coloraxis_showscale=False,
            yaxis=dict(title="Recovery Rate (%)", range=[0, 9.5], gridcolor="#262c3a", title_font=dict(size=10)),
            xaxis=dict(title="Contact Attempts / Account", title_font=dict(size=10))
        )
        st.plotly_chart(fig_att, use_container_width=True)
        st.caption("📌 **Takeaway**: Outreach peaks at 2–3 touches (7.78%) and drops to 5.08% at >5 touches. Mix shift was 0.0%.")
        st.markdown("</div>", unsafe_allow_html=True)

    st.markdown("<div style='height: 10px;'></div>", unsafe_allow_html=True)

    q_col3, q_col4 = st.columns(2)
    
    # Quadrant 3: SO WHAT? (FORENSICS & CLAIM AUDIT)
    with q_col3:
        st.markdown("""
        <div class="ceo-grid-card">
            <div class="ceo-grid-header" style="color: #ffb74d;">
                3. SO WHAT? — Data Quality & Financial Reconciliation
            </div>
        """, unsafe_allow_html=True)
        
        waterfall_df = pd.DataFrame({
            "Stage": ["Gross Raw", "Failed", "Pending", "Reversed", "Dups", "Net Valid"],
            "Amount_Cr": [191.73, -28.35, -19.49, -9.74, -2.59, 131.56]
        })
        fig_wf = px.bar(waterfall_df, x="Stage", y="Amount_Cr", text="Amount_Cr", template="plotly_dark",
                        color="Amount_Cr", color_continuous_scale="Tealgrn")
        fig_wf.update_traces(texttemplate='₹%{text:.1f}Cr', textposition='outside', textfont=dict(size=10))
        fig_wf.update_layout(
            height=260,
            margin=dict(l=30, r=20, t=10, b=20),
            coloraxis_showscale=False,
            yaxis=dict(title="INR Crores", range=[-40, 220], gridcolor="#262c3a", title_font=dict(size=10)),
            xaxis=dict(title="Financial Cleansing Waterfall", title_font=dict(size=10))
        )
        st.plotly_chart(fig_wf, use_container_width=True)
        st.caption("📌 **Takeaway**: Raw data overstated cash by +45.73%. True net settled recovery is strictly ₹1,315.58M.")
        st.markdown("</div>", unsafe_allow_html=True)

    # Quadrant 4: WHAT SHOULD WE DO? (₹10 CR INVESTMENT)
    with q_col4:
        st.markdown("""
        <div class="ceo-grid-card">
            <div class="ceo-grid-header" style="color: #ba68c8;">
                4. WHAT SHOULD WE DO? — Option 4: Better Borrower Targeting
            </div>
        """, unsafe_allow_html=True)
        
        scen_summary_df = pd.DataFrame({
            "Scenario": ["Conservative (+1.5%)", "Base Case (+3.5%)", "Upside (+6.0%)"],
            "Annual_Incremental_Cr": [3.26, 7.61, 13.05],
            "Payback_Months": [36.8, 15.8, 9.2]
        })
        fig_scen = px.bar(scen_summary_df, x="Scenario", y="Annual_Incremental_Cr", text="Annual_Incremental_Cr", template="plotly_dark",
                          color="Scenario", color_discrete_sequence=["#90a4ae", "#00e676", "#4fc3f7"])
        fig_scen.update_traces(texttemplate='+₹%{text:.2f}Cr/yr', textposition='outside', textfont=dict(size=10))
        fig_scen.update_layout(
            height=260,
            margin=dict(l=30, r=20, t=10, b=20),
            showlegend=False,
            yaxis=dict(title="Incremental Recovery (₹ Cr/yr)", range=[0, 16], gridcolor="#262c3a", title_font=dict(size=10)),
            xaxis=dict(title="Scenario Model", title_font=dict(size=10))
        )
        st.plotly_chart(fig_scen, use_container_width=True)
        st.caption("📌 **Takeaway**: Allocate ₹10 Cr to Option 4 (Phase 1 RCT: ₹2.5 Cr; Phase 2 Scale: ₹7.5 Cr gated on ≥3.5% uplift).")
        st.markdown("</div>", unsafe_allow_html=True)

# ==============================================================================
# TAB 2: 11% CLAIM AUDIT
# ==============================================================================
with tab2:
    st.subheader("Independent Audit of the Business Claim")
    
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
        st.markdown("### Audit Decision Matrix")
        audit_table = pd.DataFrame({
            "Metric Evaluated": [
                "Valid Net Recovery (INR)",
                "Daily Average Recovery (INR/day)",
                "Operating Calendar Days",
                "Unique Recovered Accounts",
                "Portfolio Recovery Rate (%)",
                "Recovery per Recovered Account (₹)",
                "Recovery per Agent-Hour (₹/hr)"
            ],
            "Feb 2026": ["₹170.14M", "₹6.08M/d", "28 Days", "2,173", "7.24%", "₹78,300", "₹15,081"],
            "Mar 2026": ["₹188.91M", "₹6.09M/d", "31 Days", "2,419", "8.06%", "₹78,095", "₹15,876"],
            "MoM Change (%)": ["+11.03%", "+0.29%", "+10.71%", "+11.32%", "+11.33%", "-0.26%", "+5.27%"],
            "Status / Alignment": [
                "MATCHES 11% (Monthly Sum)",
                "FLAT (Underlying Reality)",
                "PRIMARY DRIVER",
                "MATCHES 11% (Calendar Effect)",
                "MATCHES 11% (Fixed Spine)",
                "FLAT TICKET SIZE",
                "MODEST (+5.3% only)"
            ]
        })
        st.dataframe(audit_table, use_container_width=True)

# ==============================================================================
# TAB 3: DRIVER & MIX DECOMPOSITION
# ==============================================================================
with tab3:
    st.subheader("Multidimensional Recovery Drivers & Shift-Share Decomposition")
    
    col_d1, col_d2 = st.columns(2)
    with col_d1:
        st.markdown("### Recovery Rate by Loan Product")
        prod_data = filtered_driver.groupby("loan_type").agg(
            Accts=("account_id", "count"),
            Recovered=("has_success_payment", "sum"),
            Amount=("success_payment_amount", "sum")
        ).reset_index()
        prod_data["Recovery_Rate_Pct"] = prod_data["Recovered"] / prod_data["Accts"] * 100
        
        fig_prod = px.bar(prod_data, x="loan_type", y="Recovery_Rate_Pct", text="Recovery_Rate_Pct", template="plotly_dark",
                          color="loan_type", color_discrete_sequence=["#1f77b4", "#00e676", "#ff7f0e", "#9467bd"])
        fig_prod.update_traces(texttemplate='%{text:.2f}%', textposition='outside')
        fig_prod.update_layout(height=350, yaxis_range=[0, 10], showlegend=False, yaxis_title="Recovery Rate (%)", xaxis_title="Loan Product")
        st.plotly_chart(fig_prod, use_container_width=True)
        
    with col_d2:
        st.markdown("### Recovery Rate by Delinquency Tier (DPD)")
        dpd_data = filtered_driver.groupby("dpd_bucket").agg(
            Accts=("account_id", "count"),
            Recovered=("has_success_payment", "sum")
        ).reset_index()
        dpd_data["Recovery_Rate_Pct"] = dpd_data["Recovered"] / dpd_data["Accts"] * 100
        
        fig_dpd = px.bar(dpd_data, x="dpd_bucket", y="Recovery_Rate_Pct", text="Recovery_Rate_Pct", template="plotly_dark",
                         color="dpd_bucket", color_discrete_sequence=["#00e676", "#1f77b4", "#ff7f0e", "#d62728"])
        fig_dpd.update_traces(texttemplate='%{text:.2f}%', textposition='outside')
        fig_dpd.update_layout(height=350, yaxis_range=[0, 10], showlegend=False, yaxis_title="Recovery Rate (%)", xaxis_title="DPD Bucket")
        st.plotly_chart(fig_dpd, use_container_width=True)
        
    st.markdown("### Kitagawa Shift-Share Mix Effect Decomposition")
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
    st.subheader("Targeting Strategy Counterfactual & Incremental Lift Simulation")
    
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
            "Scenario": ["Downside", "Base (Central)", "Upside"],
            "Incremental_M": [-15.64, 11.13, 18.51]
        })
        fig_scen_p = px.bar(scen_plot, x="Scenario", y="Incremental_M", text="Incremental_M", template="plotly_dark",
                            color="Scenario", color_discrete_sequence=["#7f7f7f", "#00e676", "#1f77b4"])
        fig_scen_p.update_traces(texttemplate='₹%{text:+.2f}M', textposition='outside')
        fig_scen_p.update_layout(height=350, yaxis_title="Incremental Recovery (₹ Millions)", yaxis_range=[-20, 24], showlegend=False)
        st.plotly_chart(fig_scen_p, use_container_width=True)
        
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
            "QUASI-EXPERIMENTAL / STRONG EVIDENCE"
        ]
    })
    st.dataframe(cf_summary_table, use_container_width=True)

# ==============================================================================
# TAB 5: ₹10 CR INVESTMENT DECISION
# ==============================================================================
with tab5:
    st.subheader("₹10.00 Crore Capital Allocation: Option 4 Better Borrower Targeting")
    
    st.markdown("""
    <div class="verdict-box" style="border-left-color: #00e676;">
        <h3 style="margin-top:0; color:#00e676;">CHOSEN SINGLE INVESTMENT AREA: OPTION 4 — BETTER BORROWER TARGETING</h3>
        <p>We recommend dedicating <b>100% of the ₹10.00 Crore capital</b> to <b>Option 4: Better Borrower Targeting</b> under a 2-phase release:
        <b>Phase 1 Pilot RCT (Months 1–3: ₹2.50 Cr)</b> to prove unconfounded causal lift, followed by <b>Phase 2 Scale-Out (Months 4–12: ₹7.50 Cr)</b> gated on achieving <b>≥+3.50% portfolio uplift</b>.</p>
    </div>
    """, unsafe_allow_html=True)
    
    st.markdown("### Head-to-Head Comparison Across the 6 Leadership Options")
    options_df = pd.DataFrame({
        "Option #": ["1", "2", "3", "4", "5", "6"],
        "Investment Category": [
            "Better Telephony Infrastructure",
            "More Collection Agents",
            "AI Voice Automation",
            "BETTER BORROWER TARGETING (CHOSEN)",
            "WhatsApp / Digital Engagement Only",
            "Field Operations Expansion"
        ],
        "Historical Evidence / Limitation": [
            "All 15 vendors have identical ~20% connection rate; carrier piping is not the bottleneck.",
            "Agent productivity flat across tenure (~₹111k); touches >3 drop recovery to 5.08%.",
            "Dialer connection rates flat across all 24h; voice bots face same call screening.",
            "Targeted accounts yield +₹596/acct (+0.74% pts recovery rate); +₹11.13M lift.",
            "Digital is a delivery channel, not intelligence; unguided broadcasts cause spam blocks.",
            "Field visits cost ₹350/visit for only 10% volume; negative unit margins."
        ],
        "Decision Verdict": ["REJECTED", "REJECTED", "REJECTED", "CHOSEN (100% OF ₹10 CR)", "REJECTED AS STANDALONE", "REJECTED"]
    })
    st.dataframe(options_df, use_container_width=True)
    
    col_i1, col_i2 = st.columns(2)
    with col_i1:
        st.markdown("### Phased Deployment Breakdown (₹10.00 Cr)")
        phased_df = pd.DataFrame({
            "Deployment Phase": ["Phase 1: Pilot RCT & Infrastructure", "Phase 2: Scale ML Decisioning & Auto-Pacing"],
            "Capital_Cr": [2.50, 7.50],
            "Share_Pct": [25.0, 75.0]
        })
        fig_phase = px.pie(phased_df, names="Deployment Phase", values="Capital_Cr", hole=0.45, template="plotly_dark",
                           color_discrete_sequence=["#ff9f1c", "#00e676"])
        fig_phase.update_layout(height=350, margin=dict(l=20, r=20, t=30, b=20))
        st.plotly_chart(fig_phase, use_container_width=True)
        
    with col_i2:
        st.markdown("### Financial Scenario Projections (₹217.45 Cr Baseline)")
        fin_scen_df = pd.DataFrame({
            "Scenario Parameter": [
                "Portfolio Recovery Uplift (%)",
                "Gross Annual Incremental Recovery",
                "Capital Investment (Capex)",
                "Net 1-Year Financial Benefit",
                "Cumulative 2-Year Net Benefit",
                "1-Year Return on Investment (ROI)",
                "Payback Period (Months)",
                "Recovery per ₹1.00 Invested (2-Yr)"
            ],
            "Conservative": ["+1.50%", "+₹3.26 Cr", "₹10.00 Cr", "-₹6.74 Cr", "-₹3.48 Cr", "-67.4%", "36.8 Months", "₹0.65"],
            "Base (Central)": ["+3.50%", "+₹7.61 Cr", "₹10.00 Cr", "-₹2.39 Cr", "+₹5.22 Cr", "-23.9%", "15.8 Months", "₹1.52"],
            "Upside": ["+6.00%", "+₹13.05 Cr", "₹10.00 Cr", "+₹3.05 Cr", "+₹16.10 Cr", "+30.5%", "9.2 Months", "₹2.61"]
        })
        st.dataframe(fin_scen_df, use_container_width=True)

# ==============================================================================
# TAB 6: DATA LINEAGE & GOVERNANCE
# ==============================================================================
with tab6:
    st.subheader("Data Lineage, Production Contracts & Quality Governance")
    
    st.markdown("""
    ### Implemented Architecture vs. Proposed Production Design
    - **`[IMPLEMENTED IN REPOSITORY]`**:
      - Staging DDL (`sql/01_staging.sql`)
      - Cleansing & Entity Resolution (`sql/02_cleaning.sql` -> `data/clean/`)
      - Golden Analytical Cartesian Spine (`sql/03_golden.sql` -> `golden_accounts_monthly.csv`, 240k rows)
      - Metric & Driver Models (`sql/04_metrics.sql`, `sql/05_analysis.sql`, `sql/06_counterfactual.sql`, `sql/07_investment_model.sql`)
      - Executive Streamlit Dashboard (`dashboard/app.py`)
      - Master Jupyter Notebook (`notebooks/analysis.ipynb`)
    - **`[PROPOSED ENTERPRISE ARCHITECTURE]`**:
      - Apache Kafka / AWS Kinesis real-time stream ingestion
      - Apache Airflow / Prefect automated batch orchestrator
      - dbt semantic layer / metric store
      - Databricks Delta Lake / Snowflake cloud lakehouse
      - Automated PagerDuty anomaly alerting on recovery run-rate drops
    """)
    
    st.markdown("### Financial Cleansing Reconciliation")
    dq_table = pd.DataFrame({
        "Cleansing Stage": [
            "1. Raw Ingestion (payments.csv)",
            "2. Exclude Failed Transactions",
            "3. Exclude Pending Transactions",
            "4. Exclude Reversed Transactions",
            "5. Exclude Duplicate SUCCESS Records",
            "6. Golden Clean Valid Net Recovery"
        ],
        "Record Count": ["25,500", "3,744", "2,592", "1,284", "346", "17,534"],
        "Amount (INR)": ["₹1,917,258,617.15", "-₹283,506,324.89", "-₹194,867,950.33", "-₹97,398,415.60", "-₹25,901,961.69", "₹1,315,583,964.64"],
        "Status": ["Raw Gross", "Excluded", "Excluded", "Excluded", "Excluded", "Net Settled Valid"]
    })
    st.dataframe(dq_table, use_container_width=True)
