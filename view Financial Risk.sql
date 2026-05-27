CREATE OR ALTER VIEW vw_O2C_Financial_Risk AS
SELECT
	f.invoiceNumber,
    f.customerID,
    f.countryCode,
    c.CountryName,
    f.InvoiceAmount,
    f.Disputed,
    f.PaperlessBill,

    CAST(f.InvoiceDate AS DATE) AS InvoiceDate,
    CAST(f.DueDate AS DATE) AS DueDate,
    CAST(f.SettledDate AS DATE) AS SettledDate,

    DATEDIFF(DAY, CAST(f.DueDate AS DATE), COALESCE(CAST(f.SettledDate AS DATE), GETDATE())) AS ActualDaysLate,

    CASE 
        WHEN DATEDIFF(DAY, CAST(f.DueDate AS DATE), COALESCE(CAST(f.SettledDate AS DATE), GETDATE())) <= 0 THEN '0. On Time'
        WHEN DATEDIFF(DAY, CAST(f.DueDate AS DATE), COALESCE(CAST(f.SettledDate AS DATE), GETDATE())) BETWEEN 1 AND 30 THEN '1. 1-30 Days Late'
        WHEN DATEDIFF(DAY, CAST(f.DueDate AS DATE), COALESCE(CAST(f.SettledDate AS DATE), GETDATE())) BETWEEN 31 AND 60 THEN '2. 31-60 Days Late'
        WHEN DATEDIFF(DAY, CAST(f.DueDate AS DATE), COALESCE(CAST(f.SettledDate AS DATE), GETDATE())) BETWEEN 61 AND 90 THEN '3. 61-90 Days Late'
        ELSE '4. 90+ Days (Critical)'
    END AS AgingBucket,

    DATEDIFF(DAY, CAST(InvoiceDate AS DATE), CAST(SettledDate AS DATE)) AS DaysToPay,

    CASE 
        WHEN SettledDate IS NULL THEN 'Open'
        ELSE 'Closed'
    END AS InvoiceStatus,

    CASE WHEN SettledDate IS NULL THEN InvoiceAmount ELSE 0 END AS OpenAmount,
    CASE WHEN SettledDate IS NOT NULL THEN InvoiceAmount ELSE 0 END AS SettledAmount

FROM dbo.LatePaymentHistories AS f
LEFT JOIN Dim_Country AS c ON f.countryCode = c.countryCode;