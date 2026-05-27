SELECT AgingBucket, InvoiceStatus, COUNT(*) AS InvoiceCount, SUM(InvoiceAmount) AS TotalAmount
FROM dbo.vw_O2C_Financial_Risk
GROUP BY AgingBucket, InvoiceStatus;