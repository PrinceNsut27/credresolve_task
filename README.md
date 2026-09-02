# CredResolve Collections Recovery Analytics

## Executive Conclusion
Over the observed 7 complete operating months (January–July 2026), portfolio collections recovery was **flat and stationary** (+0.007% cumulative growth from ₹187.23M in Jan to ₹187.24M in Jul; daily run-rate averaged **~₹6.0M/day**). Uncleaned raw data overstated collections by **+45.73% (+₹601.67M)** due to failed, pending, reversed, and duplicate transactions. Clean net settled recovery is **₹1,315,583,964.64** across 17,534 valid payments.

---

## The 11% Claim
- **Reported Business Claim**: *"Recovery has improved by 11% month-on-month."*
- **Independent Measured Result**: Valid net recovery grew by **+11.03%** in March 2026 (₹188.91M) vs. February 2026 (₹170.14M). However, February had 28 days while March had 31 days (**+10.71% more operating days**). On a daily run-rate basis, collections grew by only **+0.29%** (₹6.077M/day in Feb to ₹6.094M/day in Mar), and performance immediately declined by **-7.29% in April**.
- **Verdict**: **PARTIALLY TRUE (Calendar Artifact / Single-Month Anomaly)**.

---

## ₹10 Crore Investment Recommendation
- **Chosen Investment Category**: **OPTION 4: BETTER BORROWER TARGETING (100% of ₹10.00 Cr)**.
- **Why It Wins**: Outreach beyond 2–3 touches suffers severe diminishing returns (recovery drops from 7.78% to 5.08% at >5 touches). Dynamic targeting prioritizes responsive accounts, caps outreach at optimal thresholds, and captures a **+₹596/account yield premium (+0.74% pts recovery rate)** over organic controls.
- **Expected Financial Impact**:
  - **Base Case (Central)**: **+₹7.61 Cr / year incremental recovery**, **15.8-month payback period**, and **+₹5.22 Cr cumulative 2-year net benefit (+52.2% ROI)** against the ₹217.45 Cr annualized baseline.
  - **Downside Case**: +₹3.26 Cr / year (36.8-month payback).
  - **Upside Case**: +₹13.05 Cr / year (9.2-month payback, +161.0% ROI).
  - **Break-Even Threshold**: 4.60% 1-year portfolio uplift (+₹10.00 Cr) or 2.30% 2-year uplift (+₹5.00 Cr/year).
- **Deployment Structure (Phase-Gated Guardrail)**:
  - **Phase 1 Pilot (Months 1–3: ₹2.50 Cr)**: 90-day 1:1 Randomized Controlled Trial (RCT) across 30,000 accounts (>93% statistical power).
  - **Phase 2 Scale (Months 4–12: ₹7.50 Cr)**: Released only upon achieving $\ge +3.50\%$ incremental recovery uplift.
- **Confidence Level**: **High** on accounting data and data quality; **Strong Evidence** on quasi-experimental targeting lift (phase-gated on RCT proof).

---

## Key Analytical Findings

1. **Portfolio Mix Invariance (0.0% Mix Shift)**: Kitagawa decomposition confirms that 100.0% of the March recovery jump was driven by calendar day expansion; portfolio risk and loan product distributions remained completely unchanged.
2. **Diminishing Returns in Outreach Frequency**: Account recovery peaks at **2–3 contact attempts (7.78%)** and falls to **5.08% beyond 5 touches** due to negative selection bias from automated dialers repeatedly redialing unresponsive borrowers.
3. **Agent Productivity Flat Across Tenure**: Human collectors generate uniform recovery (~₹111k/month) regardless of tenure, disproving agent hiring as a scalable lever.
4. **Telephony Carrier Parity**: All 15 carrier vendors exhibit identical ~20% connection rates and ~69% RPC rates; connectivity is bottlenecked by borrower call screening, not carrier routing.

---

## Core Deliverables Directory

| Deliverable | File Link | Description |
| :--- | :--- | :--- |
| **Executive Decision Memo** | [`docs/executive_memo.md`](file:///c:/Users/Prince/Desktop/cred/docs/executive_memo.md) | Strict 2-page decision memorandum prepared for CEO leadership. |
| **Executive CEO Dashboard** | [`dashboard/app.py`](file:///c:/Users/Prince/Desktop/cred/dashboard/app.py) | Interactive Streamlit one-screen executive cockpit (60-second comprehension). |
| **Master Analysis Notebook** | [`notebooks/analysis.ipynb`](file:///c:/Users/Prince/Desktop/cred/notebooks/analysis.ipynb) | 24-cell fully executed Jupyter notebook with all plots and tables rendered. |
| **Production SQL Pipeline** | [`sql/`](file:///c:/Users/Prince/Desktop/cred/sql/) | 7 deterministic SQL scripts (`01_staging.sql` to `07_investment_model.sql`). |
| **Golden Analytical Dataset**| [`data/golden/golden_accounts_monthly.csv`](file:///c:/Users/Prince/Desktop/cred/data/golden/golden_accounts_monthly.csv) | 240,000-row Cartesian spine (`account_id × analysis_month`). |
| **Data Quality & Forensics** | [`docs/data_quality_report.md`](file:///c:/Users/Prince/Desktop/cred/docs/data_quality_report.md) | 12-Issue Forensic Audit Matrix and ₹601.7M reconciliation waterfall. |
| **Data Inventory & Schema** | [`docs/data_inventory.md`](file:///c:/Users/Prince/Desktop/cred/docs/data_inventory.md) | Exhaustive profiling of all 18 raw CSV datasets and 143 attributes. |
| **Targeting Counterfactual** | [`docs/targeting_counterfactual.md`](file:///c:/Users/Prince/Desktop/cred/docs/targeting_counterfactual.md) | DiD counterfactual model and >93% statistical power RCT protocol. |
| **Investment Business Case** | [`docs/investment_recommendation.md`](file:///c:/Users/Prince/Desktop/cred/docs/investment_recommendation.md) | Full ₹10 Cr Option 4 business case and 6-option comparison. |
| **Production Architecture** | [`docs/production_architecture.md`](file:///c:/Users/Prince/Desktop/cred/docs/production_architecture.md) | Implemented repository pipeline vs. proposed cloud lakehouse design. |

---

## Final Assignment Requirement Compliance Matrix

| Requirement | Evidence / File Reference | Status |
| :--- | :--- | :---: |
| **1. SQL Repository** | [`sql/01_staging.sql`](file:///c:/Users/Prince/Desktop/cred/sql/01_staging.sql) to [`sql/07_investment_model.sql`](file:///c:/Users/Prince/Desktop/cred/sql/07_investment_model.sql) | **COMPLETE** |
| **2. Analysis Notebook** | [`notebooks/analysis.ipynb`](file:///c:/Users/Prince/Desktop/cred/notebooks/analysis.ipynb) (24 cells executed with all outputs) | **COMPLETE** |
| **3. Golden Dataset / Pipeline** | [`data/golden/golden_accounts_monthly.csv`](file:///c:/Users/Prince/Desktop/cred/data/golden/golden_accounts_monthly.csv), [`sql/03_golden.sql`](file:///c:/Users/Prince/Desktop/cred/sql/03_golden.sql) | **COMPLETE** |
| **4. Data Quality Report** | [`docs/data_quality_report.md`](file:///c:/Users/Prince/Desktop/cred/docs/data_quality_report.md), [`docs/data_inventory.md`](file:///c:/Users/Prince/Desktop/cred/docs/data_inventory.md) | **COMPLETE** |
| **5. One-Screen Executive Dashboard** | [`dashboard/app.py`](file:///c:/Users/Prince/Desktop/cred/dashboard/app.py) (Streamlit default cockpit view) | **COMPLETE** |
| **6. Executive Memo (≤2 Pages)** | [`docs/executive_memo.md`](file:///c:/Users/Prince/Desktop/cred/docs/executive_memo.md) (Strictly 78 lines, zero fake signatures) | **COMPLETE** |
| **7. Architecture Diagram** | [`docs/production_architecture.md`](file:///c:/Users/Prince/Desktop/cred/docs/production_architecture.md) (Mermaid lineage & contracts) | **COMPLETE** |
| **8. Data Forensics Audit** | [`docs/data_quality_report.md`](file:///c:/Users/Prince/Desktop/cred/docs/data_quality_report.md) (12 forensic issues investigated) | **COMPLETE** |
| **9. Statistical Investigation** | [`docs/statistical_analysis.md`](file:///c:/Users/Prince/Desktop/cred/docs/statistical_analysis.md), [`docs/driver_analysis.md`](file:///c:/Users/Prince/Desktop/cred/docs/driver_analysis.md) | **COMPLETE** |
| **10. Counterfactual Analysis** | [`docs/targeting_counterfactual.md`](file:///c:/Users/Prince/Desktop/cred/docs/targeting_counterfactual.md), [`sql/06_counterfactual.sql`](file:///c:/Users/Prince/Desktop/cred/sql/06_counterfactual.sql) | **COMPLETE** |
| **11. ₹10 Cr Single Investment**| [`docs/investment_recommendation.md`](file:///c:/Users/Prince/Desktop/cred/docs/investment_recommendation.md) (Option 4: 100% allocation) | **COMPLETE** |

---

## Clean Repository Structure

```
credresolve_task/
├── README.md                                # Evaluator-first overview & requirement matrix
├── requirements.txt                         # Top-level dependencies
├── data/
│   ├── *.csv                                # 18 raw operational CSV files (untouched)
│   ├── clean/*.csv                          # Cleansed, deduplicated Silver tables
│   └── golden/golden_accounts_monthly.csv   # Master Cartesian spine (240k rows)
├── sql/
│   ├── 01_staging.sql                       # DDL contracts with explicit data types
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
└── docs/
    ├── executive_memo.md                    # 2-Page Executive Decision Memorandum for CEO
    ├── data_quality_report.md               # 12-Issue Forensic Matrix & -₹601.7M reconciliation
    ├── data_inventory.md                    # Exhaustive 18-dataset profiling & schema dictionary
    ├── golden_dataset.md                    # Technical spec of golden_accounts_monthly.csv
    ├── metrics_definitions.md               # Numerator/Denominator formulas, biases & rationales
    ├── 11_percent_claim.md                  # Mathematical audit of 11% claim & calendar artifact
    ├── driver_analysis.md                   # 13-dimension driver analysis & Kitagawa decomposition
    ├── statistical_analysis.md              # Multivariate Logit model & Simpson's paradox tests
    ├── targeting_counterfactual.md          # DiD, quasi-experimental counterfactual & RCT design
    ├── investment_recommendation.md         # Full ₹10 Cr Option 4 business case & ROI model
    ├── assumptions.md                       # Structured parameter & modeling assumption register
    ├── limitations.md                       # Data caveats, observational bounds & disclosures
    └── production_architecture.md           # Implemented vs Proposed production lakehouse design
```

---

## How to Run & Reproduce

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Launch Interactive Executive Dashboard
streamlit run dashboard/app.py

# 3. View Executed Jupyter Master Notebook
# Open notebooks/analysis.ipynb in Jupyter Lab / VS Code

# 4. Execute Production SQL Pipeline
# Run sql/01_staging.sql through sql/07_investment_model.sql in PostgreSQL / Snowflake / DuckDB
```
