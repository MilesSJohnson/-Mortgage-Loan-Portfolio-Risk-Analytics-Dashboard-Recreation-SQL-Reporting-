SELECT TOP 10 *
FROM dbo.V_POS_LOT_WIDE
;

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
WHERE STAT_Book_Value > 100000000
ORDER BY Trade_Date DESC
;

-- Top 10 issuers by book value
SELECT TOP 10 SUM(STAT_BOOK_VALUE) AS Total_Book_Value,
	Issuer_Name
FROM dbo.V_POS_LOT_WIDE
GROUP BY Issuer_Name
ORDER BY SUM(STAT_BOOK_VALUE) DESC
;

-- Top 20 and bottom 20 by unrealized gain/loss
SELECT Issuer_Name, STAT_Unrealized_GL, 'Top 20 Losers' AS Category
FROM (
    SELECT TOP 20 STAT_Unrealized_GL, Issuer_Name
    FROM dbo.V_POS_LOT_WIDE
    ORDER BY STAT_Unrealized_GL ASC
) AS Losers

UNION ALL

SELECT Issuer_Name, STAT_Unrealized_GL, 'Top 20 Winners' AS Category
FROM (
    SELECT TOP 20 STAT_Unrealized_GL, Issuer_Name
    FROM dbo.V_POS_LOT_WIDE
    ORDER BY STAT_Unrealized_GL DESC
) AS Winners;
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
ORDER BY Sp_Rating
;

-- Sector breakdown by market value
SELECT SUM(MV_Flat_USD) AS Total_Market_Value,
	SAA_SECTOR_3
FROM dbo.V_POS_LOT_WIDE
GROUP BY SAA_SECTOR_3
ORDER BY Total_Market_Value DESC
;

--Issuers where average duration exceeds 4 but average yield is below 6
SELECT
    Issuer_Name,
    SUM(N_Effective_Duration) / NULLIF(SUM(D_Effective_Duration), 0) AS Avg_Duration,
    SUM(N_STAT_Book_Yield) / NULLIF(SUM(D_STAT_Book_Yield), 0)       AS Avg_Yield
FROM dbo.V_POS_LOT_WIDE
GROUP BY Issuer_Name
HAVING
    SUM(N_Effective_Duration) / NULLIF(SUM(D_Effective_Duration), 0) > 4
    AND SUM(N_STAT_Book_Yield) / NULLIF(SUM(D_STAT_Book_Yield), 0) < 6;

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
    Issuer_Name,
    Portfolio_Short_Name,
    Maturity_Date,
    ROUND(STAT_Book_Value, 2) AS STAT_Book_Value,
    ROUND(
    SUM(STAT_Book_Value) OVER (ORDER BY Maturity_Date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
    2
) AS Running_Total_Book_Value
FROM dbo.V_POS_LOT_WIDE
WHERE Maturity_Date IS NOT NULL
ORDER BY Maturity_Date;