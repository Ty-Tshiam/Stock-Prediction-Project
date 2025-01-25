WITH 
    aEarnings AS (
        SELECT DISTINCT 
            [AnnualEarnings], 
            (SELECT MIN(p.[Date]) FROM Stock AS p WHERE p.[Date] >= a.[Date]) AS tradingDay
        FROM AnnualEarnings AS a 
        WHERE (SELECT MIN(p.[Date]) FROM Stock AS p) <= a.[Date] 
    ),
    MatchedTradingDays AS (
        SELECT DISTINCT
            o.[Date] AS oDate,
            o.[overall_sentiment_score] AS sentimentScore,
            (SELECT MIN(p.[Date]) 
             FROM Stock AS p 
             WHERE p.[Date] >= o.[Date]) AS tradingDay
        FROM Sentiments AS o
    ),
    AggregatedByTradingDay AS (
        SELECT DISTINCT
            mtd.tradingDay,
            AVG(mtd.sentimentScore) AS overallScore
        FROM MatchedTradingDays AS mtd
        WHERE mtd.tradingDay IS NOT NULL
        GROUP BY mtd.tradingDay
    ),
    oSentiment AS (
        SELECT DISTINCT
            abtd.tradingDay,
            abtd.overallScore
        FROM AggregatedByTradingDay AS abtd
    ),
    Commodity AS (
        SELECT DISTINCT 
            [Commodities_Index], 
            (SELECT MIN(p.[Date]) FROM Stock AS p WHERE p.[Date] >= c.[Date]) AS tradingDay
        FROM Commodities AS c
        WHERE (SELECT MIN(p.[Date]) FROM Stock AS p) <= c.[Date] 
    ),
    DividendValues AS (
        SELECT DISTINCT 
            [Dividend], 
            (SELECT MIN(p.[Date]) FROM Stock AS p WHERE p.[Date] >= d.[Date]) AS tradingDay
        FROM Dividends AS d
        WHERE (SELECT MIN(p.[Date]) FROM Stock AS p) <= d.[Date] 
    ),
    FedRate AS (
        SELECT DISTINCT 
            [Fed_Rate], 
            [Date] 
        FROM FederalFundsRate AS f
        WHERE (SELECT MIN(p.[Date]) FROM Stock AS p) <= f.[Date] 
    ),
    inflationValue AS (
        SELECT DISTINCT 
            [Inflation], 
            (SELECT MIN(p.[Date]) FROM Stock AS p WHERE p.[Date] >= i.[Date]) AS tradingDay
        FROM Inflation AS i
        WHERE (SELECT MIN(p.[Date]) FROM Stock AS p) <= i.[Date] 
    ),
    sectorPerformance AS (
        SELECT DISTINCT 
            [SectorOpen],
            [SectorHigh],
            [SectorLow],
            [SectorClose],
            [SectorVolume], 
            (SELECT MIN(p.[Date]) FROM Stock AS p WHERE p.[Date] >= sp.[Date]) AS tradingDay
        FROM SectorPrices AS sp
        WHERE (SELECT MIN(p.[Date]) FROM Stock AS p) <= sp.[Date] 
    ),
    QuaterEarnings AS (
        SELECT DISTINCT 
            [QuarterEarnings],
            [EstimatedQuarterEarnings],
            [QuarterSurprise],
            [QuarterSurprisePercentage],
            [QuarterReportTime], 
            (SELECT MIN(p.[Date]) FROM Stock AS p WHERE p.[Date] >= q.[Date]) AS tradingDay
        FROM QuarterlyEarnings AS q
        WHERE (SELECT MIN(p.[Date]) FROM Stock AS p) <= q.[Date] 
    ),
    Splits AS (
        SELECT DISTINCT 
            [split_factor], 
            (SELECT MIN(p.[Date]) FROM Stock AS p WHERE p.[Date] >= s.[Date]) AS tradingDay
        FROM Split AS s
        WHERE (SELECT MIN(p.[Date]) FROM Stock AS p) <= s.[Date] 
    ),
    Unemployments AS (
        SELECT DISTINCT 
            [UnemploymentRate], 
            (SELECT MIN(p.[Date]) FROM Stock AS p WHERE p.[Date] >= u.[Date]) AS tradingDay
        FROM Unemployment AS u
        WHERE (SELECT MIN(p.[Date]) FROM Stock AS p) <= u.[Date] 
    )

SELECT 
    p.*,
    ae.[AnnualEarnings],
    os.[overallScore],
    c.[Commodities_Index],
    d.[Dividend],
    f.[Fed_Rate],
    iv.[Inflation],
    sp.[SectorOpen],
    sp.[SectorHigh],
    sp.[SectorLow],
    sp.[SectorClose],
    sp.[SectorVolume],
    q.[QuarterEarnings],
    q.[EstimatedQuarterEarnings],
    q.[QuarterSurprise],
    q.[QuarterSurprisePercentage],
    q.[QuarterReportTime],
    s.[split_factor],
    u.[UnemploymentRate]
FROM Stock AS p
LEFT JOIN aEarnings AS ae ON p.[Date] = ae.[tradingDay] 
LEFT JOIN oSentiment AS os ON p.[Date] = os.[tradingDay]
LEFT JOIN Commodity AS c ON p.[Date] = c.[tradingDay]
LEFT JOIN DividendValues AS d ON p.[Date] = d.[tradingDay]
LEFT JOIN FedRate AS f ON p.[Date] = f.[Date]
LEFT JOIN inflationValue AS iv ON p.[Date] = iv.[tradingDay]
LEFT JOIN sectorPerformance AS sp ON p.[Date] = sp.[tradingDay]
LEFT JOIN QuaterEarnings AS q ON p.[Date] = q.[tradingDay]
LEFT JOIN Splits AS s ON p.[Date] = s.[tradingDay]
LEFT JOIN Unemployments AS u ON p.[Date] = u.[tradingDay]
ORDER BY p.[Date];