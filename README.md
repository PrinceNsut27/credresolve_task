# Collections Recovery Performance Analytics & ₹10 Cr Investment Strategy

**Author**: Antigravity Data Analytics Team  
**Platform Version**: Production Analytical Release (Part 1 & Part 2 Complete)  
**Golden Analytical Dataset**: `data/golden/golden_accounts_monthly.csv` (240,000 rows, Grain: `account_id × analysis_month`)  
**Executive Memo**: [`docs/executive_memo.md`](file:///c:/Users/Prince/Desktop/cred/docs/executive_memo.md) (2-Page CEO Memo)  
**Executive Dashboard**: [`dashboard/app.py`](file:///c:/Users/Prince/Desktop/cred/dashboard/app.py) (Streamlit One-Screen Cockpit)  

---

## 1. Executive Summary & North Star Findings

This repository contains the complete, production-grade analytical data platform, econometric models, and executive investment memorandum evaluating consumer collections recovery across a 30,000-account master portfolio.

### Core Business Findings

1. **Independent Audit of the "11% Month-on-Month Improvement" Claim**:
   - **Classification**: **PARTIALLY SUPPORTED (CALENDAR ARTIFACT / SINGLE-MONTH ANOMALY)**.
   - **Finding**: In **March 2026 vs. February 2026**, valid recovery grew by **+11.03%** (₹170.1M to ₹188.9M). However, February has 28 days and March has 31 days (+10.71% more days). On a **daily run-rate basis**, collections were virtually identical (**₹6.08M/day in Feb vs. ₹6.09M/day in Mar, a +0.29% change**). Across all 7 full operating months, cumulative growth was **+0.007% (flat)** with an arithmetic mean MoM change of **+0.29%**, not +11.0%.
2. **Data Quality & Financial Inflation Forensics**:
   - Raw payments overstated recovery by **+45.73% (+₹601.67M)** due to failed (₹283.5M), pending (₹194.9M), reversed (₹97.4M), and duplicate (₹25.9M) transactions.
   - True net settled recovery is **₹1,315,583,964.64** (17,534 clean payments).
3. **Driver Analysis & Shift-Share Mix Decomposition**:
   - Kitagawa decomposition confirms **portfolio mix shifts explain 0.0% of recovery variance**; recovery rates across DPD tiers (~7.7%) and products (~7.7%) remained constant.
   - Attempt frequency peaks at **2–3 outreach attempts (7.78%)** and suffers severe diminishing returns beyond 5 attempts (**5.08%**) due to negative selection bias.
4. **Targeting Counterfactual & Incremental Recovery**:
   - Accounts assigned to active campaigns outperform non-targeted organic controls by **+0.74% pts in recovery rate** and **+₹596/account in yield**, generating **+₹11.13M (+7.04%) in base incremental recovery**.
5. **₹10.00 Crore Executive Investment Strategy**:
   - **Single Chosen Investment Area**: **OPTION 4: BETTER BORROWER TARGETING (100% of ₹10.00 Cr)**.
   - **Strategic Guardrail**: **PILOT FIRST / INVEST WITH CONDITIONS**.
   - **Phase 1 Pilot (Months 1–3: ₹2.50 Cr)**: Fund a 90-day 1:1 Randomized Controlled Trial (RCT) across 30,000 accounts to measure unconfounded causal elasticity (>93% statistical power).
   - **Phase 2 Scale (Months 4–12: ₹7.50 Cr)**: Release remaining budget upon demonstrating $\ge 3.50\%$ incremental recovery uplift.
   - **Base-Case Financials**: **+₹7.61 Cr/year incremental recovery**, **15.8-month payback**, and **₹5.22 Cr net benefit over 2 years** (+52.2% 2-year ROI).

---

## 2. Repository Architecture & File Mapping

```
credresolve_task/
├── data/
│   ├── *.csv                                # 18 raw operational CSV files (639k rows, untouched)
│   ├── clean/*.csv                          # Cleansed, deduplicated, SCD2-harmonized tables
│   └── golden/golden_accounts_monthly.csv   # Master Cartesian analytical spine (240k rows)
├── sql/
│   ├── 01_staging.sql                       # Staging DDL contracts with explicit data types
│   ├── 02_cleaning.sql                      # Entity resolution, deduplication, payment filtering
│   ├── 03_golden.sql                        # Multi-window attribution & 240k Cartesian spine
│   ├── 04_metrics.sql                       # Governed recovery, funnel, productivity & cost queries
│   ├── 05_analysis.sql                      # Segment, driver, vendor, geography & attempt queries
│   ├── 06_counterfactual.sql                # Targeting counterfactual & incremental lift queries
│   └── 07_investment_model.sql              # ₹10 Cr Option 4 allocation & financial scenario model
├── notebooks/
│   └── analysis.ipynb                       # 24-cell executed master Jupyter analysis notebook
├── dashboard/
│   ├── app.py                               # Interactive Streamlit CEO One-Screen Cockpit
│   └── requirements.txt                     # Dashboard dependencies
├── docs/
│   ├── executive_memo.md                    # 2-Page Executive Decision Memorandum for CEO
│   ├── data_quality_report.md               # 12-Issue Forensic Matrix & -₹601.7M reconciliation
│   ├── data_inventory.md                    # Exhaustive 18-dataset profiling & schema dictionary
│   ├── golden_dataset.md                    # Technical spec of golden_accounts_monthly.csv
│   ├── metrics_definitions.md               # Numerator/Denominator formulas, biases & rationales
│   ├── 11_percent_claim.md                  # Mathematical audit of 11% claim & calendar artifact
│   ├── driver_analysis.md                   # 13-dimension driver analysis & Kitagawa decomposition
│   ├── statistical_analysis.md              # Multivariate Logit model & Simpson's paradox tests
│   ├── targeting_counterfactual.md          # DiD, quasi-experimental counterfactual & RCT design
│   ├── investment_recommendation.md         # Full ₹10 Cr Option 4 business case & ROI model
│   ├── investment_options.md                # Comprehensive 6-option evaluation matrix
│   └── production_architecture.md           # Implemented vs Proposed production lakehouse design
└── README.md                                # Platform overview & execution guide
```

---

## 3. How to Run & Reproduce

```bash
# 1. Launch Interactive Executive Dashboard
streamlit run dashboard/app.py

# 2. View Executed Jupyter Master Notebook
# Open notebooks/analysis.ipynb in Jupyter Lab / VS Code

# 3. Execute Production SQL Pipeline
# Run sql/01_staging.sql through sql/07_investment_model.sql in PostgreSQL / Snowflake / BigQuery

# 4. Review Key Executive Deliverables
# Open docs/executive_memo.md and docs/investment_recommendation.md
```

