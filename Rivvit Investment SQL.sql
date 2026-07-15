SELECT TOP 10 *
FROM dbo.V_POS_LOT_WIDE
;

-- Get distinct portfolios
SELECT DISTINCT Portfolio_Short_Name
FROM dbo.V_POS_LOT_WIDE
ORDER BY Portfolio_Short_Name;
 
-- Get distinct asset classes
SELECT DISTINCT Asset_Class
FROM dbo.V_POS_LOT_WIDE
ORDER BY Asset_Class;

-- All holdings with a book value over $100,000,000
SELECT As_Of_Date,
	Portfolio_Short_Name,
	Sec_Description,
	Trade_Date,
	SAA_SECTOR_1,
	SAA_SECTOR_2, 
	SAA_SECTOR_3,
	STAT_Book_Value,
	Sec_Description
FROM dbo.V_POS_LOT_WIDE
ORDER BY STAT_Book_Value DESC
;

-- Top 10 issuers by book value
SELECT TOP 10 SUM(STAT_BOOK_VALUE) AS Total_Book_Value,
	Issuer_Name
FROM dbo.V_POS_LOT_WIDE
GROUP BY Issuer_Name
ORDER BY SUM(STAT_BOOK_VALUE) DESC
;

-- Top 10 and bottom 10 by unrealized gain/loss
SELECT TOP 10 STAT_Unrealized_GL
FROM dbo.V_POS_LOT_WIDE
ORDER BY STAT_Unrealized_GL DESC;

UNION ALL

SELECT TOP 10 STAT_Unrealized_GL
FROM dbo.V_POS_LOT_WIDE
ORDER BY STAT_Unrealized_GL ASC;
--Count holdings by asset class
SELECT Asset_Class,
	COUNT(*) AS Holding_Count
FROM dbo.V_POS_LOT_WIDE
GROUP BY Asset_Class
;

-- Average yield by credit rating
SELECT Sp_rating,
	AVG(STAT_Book_Yield) AS Avg_Yield
FROM dbo.V_POS_LOT_WIDE
GROUP BY Sp_rating 
;

-- Holdings maturing within the next 12 months
SELECT
    ID,
    Issuer_Name,
    Maturity_Date,
    MV_Full_USD,
    Current_Face_Amount
FROM f_pos_lot_wide
WHERE Balance_Sheet_Line_Item = 'Mortgage Loans'
  AND Maturity_Date <= (
        CAST(REPLACE(CONVERT(VARCHAR(10), CAST(As_Of_Date AS DATE), 23), '-', '') AS INT) + 10000
      )
  AND Maturity_Date >= CAST(REPLACE(CONVERT(VARCHAR(10), CAST(As_Of_Date AS DATE), 23), '-', '') AS INT)
ORDER BY Maturity_Date ASC;

-- Sector breakdown by market value
SELECT SUM(MV_Flat_USD) AS Total_Market_Value,
	SAA_SECTOR_3
FROM dbo.V_POS_LOT_WIDE
GROUP BY SAA_SECTOR_3
ORDER BY Total_Market_Value DESC
;

--Issuers where average duration exceeds 4 but average yield is below 6
SELECT Issuer_Name,
	AVG(D_Effective_Duration) AS Avg_Duration,
	AVG(N_STAT_Book_Yield) AS Avg_Yield
FROM dbo.V_POS_LOT_WIDE
GROUP BY Issuer_Name
HAVING AVG(D_Effective_Duration) > 4 AND AVG(N_STAT_Book_Yield) < 6
;

-- Rank issuers by book value within each sector — RANK() or OVER (PARTITION BY sector ORDER BY book_value DESC)
SELECT 
    Issuer_Name,
    SAA_Sector_1,
    ROUND(SUM(STAT_Book_Value), 2) AS Sum_Book_Val,
    RANK() OVER (
        PARTITION BY SAA_Sector_1 
        ORDER BY SUM(STAT_Book_Value) DESC
    ) AS Issuer_Rank
FROM dbo.V_POS_LOT_WIDE
GROUP BY 
    Issuer_Name,
    SAA_Sector_1        
ORDER BY 
    SAA_Sector_1,
    Issuer_Rank;

-- Running total of book value sorted by maturity date — SUM(book_value) OVER (ORDER BY maturity_date)
SELECT
    [Issuer_Name],
    [Portfolio_Short_Name],
    [Maturity_Date],
    ROUND(STAT_Book_Value, 2) AS STAT_Book_Value,
    ROUND(
    SUM(STAT_Book_Value) OVER (ORDER BY [Maturity_Date]
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
    2
) AS Running_Total_Book_Value
FROM [dbo].[V_POS_LOT_WIDE]
WHERE Maturity_Date IS NOT NULL
ORDER BY [Maturity_Date];