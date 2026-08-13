# -Mortgage-Loan-Portfolio-Risk-Analytics-Dashboard-Recreation-SQL-Reporting-
This project involved recreating a real estate and mortgage loan risk dashboard that was originally built in Rivvit's Dasboard AI where I worked as a Data Analyst intern. Putting my own spin on it using Power BI I also analyzed the datasource with SQL. This project was done with using a position/lot-level investment holdings dataset as the underlying data source.

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

## SQL Analysis

The SQL analysis queries the underlying loan-level data to surface portfolio insights and risk signals.

### Example Queries

**Average LTV and DSCR by Region**
```sql
SELECT
    Region,
    AVG(LTV) AS Avg_LTV,
    AVG(DSCR) AS Avg_DSCR,
    COUNT(*) AS Loan_Count
FROM Loans
GROUP BY Region
ORDER BY Avg_LTV DESC;
```

**Delinquency Summary by Loan Type**
```sql
SELECT
    LoanType,
    DelinquencyStatus,
    COUNT(*) AS Loan_Count,
    SUM(MarketValue) AS Total_Market_Value
FROM Loans
GROUP BY LoanType, DelinquencyStatus
ORDER BY LoanType, Loan_Count DESC;
```

**Top Issuers by Unrealized Loss**
```sql
SELECT TOP 10
    IssuerName,
    SUM(UnrealizedGL) AS Total_Unrealized_GL,
    SUM(MarketValue) AS Total_Market_Value
FROM Loans
GROUP BY IssuerName
ORDER BY Total_Unrealized_GL ASC;
```

**Occupancy Rate by Property Type**
```sql
SELECT
    PropertyType,
    AVG(OccupancyRate) AS Avg_Occupancy,
    AVG(LTV) AS Avg_LTV,
    SUM(MarketValue) AS Total_Market_Value
FROM Loans
GROUP BY PropertyType
ORDER BY Avg_Occupancy DESC;
```

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
