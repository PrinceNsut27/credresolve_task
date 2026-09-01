# Financial Model & Return on Investment (ROI) Projections

**Project**: Collections Recovery Analytics Platform  
**Phase**: 5 — ₹10 Cr Investment Recommendation & Financial Model  
**Investment Capital**: **₹10.00 Crore (INR 100,000,000.00)**  
**Observation Horizon**: 12-Month Financial Projections  

---

## 1. Baseline Financial Inputs & Assumptions

All financial metrics are rigorously classified into one of four standard input types:
- `[OBSERVED]`: Directly extracted from validated Golden Dataset tables.
- `[DERIVED]`: Mathematically computed from observed data without external assumptions.
- `[ASSUMED]`: Capital budget or operational cost constraints set by business parameters.
- `[SCENARIO]`: Modeled scenario assumptions based on empirical spread intervals.

### Baseline Data Table

| Financial Parameter | Value | Unit | Input Classification | Description / Source |
| :--- | :--- | :--- | :--- | :--- |
| **Observed 7-Month Net Recovery** | ₹1,268,474,269.33 | INR | `[OBSERVED]` | Sum of clean SUCCESS payments (Jan 2026 – Jul 2026) |
| **Monthly Baseline Run-Rate** | ₹181,210,609.90 | INR / month | `[DERIVED]` | Average monthly collections across full months |
| **Annualized Baseline Recovery** | **₹2,174,527,318.80** | **INR (₹217.45 Cr)** | `[DERIVED]` | $\text{Monthly Baseline} \times 12$ |
| **Total Master Account Portfolio** | 30,000 | Accounts | `[OBSERVED]` | Unique loan accounts in master database |
| **Annual Baseline Yield / Account** | ₹72,484.24 | INR / account | `[DERIVED]` | $\text{Annual Baseline} / 30,000$ |
| **Total Capital Investment** | **₹100,000,000.00** | **INR (₹10.00 Cr)** | `[ASSUMED]` | Total allocated transformation budget |

---

## 2. 12-Month Scenario Modeling: Conservative, Base & Upside

$${\text{Net Benefit}} = {\text{Annual Incremental Recovery}} - {\text{Total Investment Cost}}$$
$${\text{ROI}}_{1\text{-Year}} (\%) = \frac{{\text{Net Benefit}}}{{\text{Total Investment Cost}}} \times 100$$
$${\text{Payback Period (Months)}} = \frac{{\text{Total Investment Cost}}}{{\text{Monthly Incremental Recovery}}}$$

### Financial Scenario Matrix

| Metric | Conservative Scenario | Base Case (Central) | Upside Scenario | Input Label |
| :--- | :--- | :--- | :--- | :--- |
| **Annual Portfolio Uplift (%)** | **+1.50%** | **+3.50%** | **+6.00%** | `[SCENARIO]` |
| **Annual Baseline Recovery (₹ Cr)** | ₹217.45 Cr | ₹217.45 Cr | ₹217.45 Cr | `[DERIVED]` |
| **Annual Incremental Recovery (₹ Cr)**| **+₹3.26 Cr** | **+₹7.61 Cr** | **+₹13.05 Cr** | `[DERIVED]` |
| **Total Projected Annual Recovery (₹ Cr)**| **₹220.71 Cr** | **₹225.06 Cr** | **₹230.50 Cr** | `[DERIVED]` |
| **Capital Investment Cost (₹ Cr)** | ₹10.00 Cr | ₹10.00 Cr | ₹10.00 Cr | `[ASSUMED]` |
| **1-Year Net Benefit (₹ Cr)** | **-₹6.74 Cr** | **-₹2.39 Cr** | **+₹3.05 Cr** | `[DERIVED]` |
| **2-Year Cumulative Net Benefit (₹ Cr)**| **-₹3.48 Cr** | **+₹5.22 Cr** | **+₹16.09 Cr** | `[DERIVED]` |
| **1-Year Accounting ROI (%)** | **-67.38%** | **-23.89%** | **+30.47%** | `[DERIVED]` |
| **2-Year Cumulative ROI (%)** | **-34.76%** | **+52.22%** | **+160.94%** | `[DERIVED]` |
| **Recovery per ₹ Invested (Year 1)**| **₹0.33** | **₹0.76** | **₹1.30** | `[DERIVED]` |
| **Recovery per ₹ Invested (Year 2)**| **₹0.65** | **₹1.52** | **₹2.61** | `[DERIVED]` |
| **Payback Period (Months)** | **36.8 Months** (3.1 yrs) | **15.8 Months** (1.3 yrs) | **9.2 Months** (<1 yr) | `[DERIVED]` |

---

## 3. Break-Even Analysis

### Break-Even Formula & Thresholds
To recover the entire ₹10.00 Cr capital investment within exactly 12 operating months:
$$\text{Break-Even Annual Recovery} = ₹100,000,000.00 = \mathbf{₹10.00\text{ Cr}}$$
$$\text{Break-Even Monthly Recovery} = \frac{₹100,000,000.00}{12} = \mathbf{₹8,333,333.33\text{ (₹0.83 Cr / month)}}$$
$$\text{Break-Even Portfolio Uplift} = \frac{₹100,000,000.00}{₹2,174,527,318.80} \times 100 = \mathbf{4.60\%}$$

- **Conclusion**: If the transformation achieves an incremental recovery uplift of **$\ge 4.60\%$**, the ₹10 Cr investment fully amortizes within 12 months. In the Base Case (+3.50% uplift), full payback is achieved in **15.8 months**.
