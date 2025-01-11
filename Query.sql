SELECT DISTINCT TOP 1000 p.[Date],
    [Open],
    [High],
    [Low],
    [Close],
    [Volume],
    [SMA_10],
    [SMA_50],
    [SMA_100],
    [SMA_200],
    [EMA_10],
    [EMA_50],
    [EMA_100],
    [EMA_200],
    [RSI],
    [MACD],
    [MACD_Signal],
    [Stochastic],
    [Bollinger_High],
    [Bollinger_Low],
    [ATR],
    [OBV],
    [Chaikin], 
    [ADX],
    [SAR_Down],
    [SAR_Up],
    [MA_Crossover],
    [BB_Width],
    [Lag 1],
    [7 Day Avg],
    [Daily Returns],
    [Price to Volume Ratio],
    [Day of the Week],
    [Quarter],
    [Daily Return],
    [Volatility],
    [Price Volume Interaction],
    [RSI * Volume],
    [MACD / Bollinger Band Width],
    [AnnualEarnings],
    [Commodities_Index],
    [Dividend],
    [Fed_Rate],
    [Inflation],
    [QuarterEarnings],
    [EstimatedQuarterEarnings],
    [QuarterSurprise],
    [QuarterSurprisePercentage],
    [QuarterReportTime],
    [SectorOpen],
    [SectorHigh]
    [SectorLow],
    [SectorClose],
    [SectorVolume],
    [overall_sentiment_score],
    [split_factor],
    [UnemploymentRate]
FROM Stock AS p
LEFT JOIN AnnualEarnings AS a ON p.[Date] = a.[Date]
LEFT JOIN Commodities AS c ON p.[Date] = c.[Date]
LEFT JOIN Dividends AS d ON p.[Date] = d.[Date]
LEFT JOIN FederalFundsRate AS f ON p.[Date] = f.[Date]
LEFT JOIN Inflation AS i ON p.[Date] = i.[Date]
LEFT JOIN QuarterlyEarnings AS q ON p.[Date] = q.[Date]
LEFT JOIN SectorPrices AS s ON p.[Date] = s.[Date]
LEFT JOIN Split AS sp ON p.[Date] = sp.[Date]
LEFT JOIN Unemployment AS u ON p.[Date] = u.[Date]
LEFT JOIN Sentiments AS o ON p.[Date] = s.[Date]