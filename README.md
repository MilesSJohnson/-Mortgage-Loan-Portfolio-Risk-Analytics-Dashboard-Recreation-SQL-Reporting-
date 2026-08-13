# Real Estate Risk Dashboard & SQL Analysis

A Power BI dashboard and SQL analysis project focused on real estate investment portfolio risk, covering **$446B+ in market value** across commercial mortgages, residential mortgages, and mezzanine loans.

---

## Dashboard Overview

The **Real Estate Risk Dashboard** provides an interactive view of key portfolio metrics and risk indicators across geographic regions and property types.

### Key KPIs

| Metric | Value |
|---|---|
| Market Value | $446B |
| Book Yield | 5.95% |
| LTV (WAV) | 59.6% |
| DSCR (WAV) | 4.10 |
| Occupancy Rate | 74.7% |
| Unrealized G/L | -$16.08B |

### Portfolio Breakdown

| Loan Type | Market Value | Book Yield | LTV | DSCR |
|---|---|---|---|---|
| Commercial Mortgages | $40.0B | 5.12% | 58.36% | 3.01 |
| Residential Mortgages | $9.1B | 5.73% | 68.10% | 3.00 |
| Mezzanine Loans | $1.4B | 10.06% | 52.06% | 3.09 |

### Dashboard Pages

- **Occupancy Rate, LTV, and DSCR by Region** — Breaks down risk metrics across regions including Pacific, Mountain, Atlantic, and Central divisions
- **Occupancy, LTV, and DSCR by Property Type** — Compares performance across asset classes (Data Center, Multi-Family, Industrial, Retail, Hospitality, Office, etc.)
- **Unrealized G/L by Issuer** — Ranks top gainers and losers including Federal National Mortgage Association, Federal Home Loan Mortgage Corp, and others
- **Delinquency Tracking** — Monitors loan status from Current through 90+ Days Past Due and REO & Foreclosure

---

## Tools & Technologies

- **Power BI Desktop** — Dashboard design, DAX measures, interactive filtering
- **DAX** — Weighted average calculations for LTV, DSCR, WAL, and Effective Duration
- **SQL Server** — Loan-level data querying, aggregation, and analysis

---

## Key Metrics Explained

- **LTV (Loan-to-Value)** — Lower is safer; portfolio WAV of 59.6% indicates moderate leverage
- **DSCR (Debt Service Coverage Ratio)** — Above 1.0 means income covers debt payments; portfolio WAV of 4.10 is strong
- **Book Yield** — The yield earned on the portfolio at book value (5.95%)
- **Unrealized G/L** — Difference between market value and book value; -$16.08B reflects current rate environment impact on fixed-income assets
- **WAL (Weighted Average Life)** — Average time until principal is repaid; 4.87 years for the total portfolio
