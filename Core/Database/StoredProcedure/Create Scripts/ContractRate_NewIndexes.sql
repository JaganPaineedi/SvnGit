
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='ContractRates_BillingCodeId' AND object_id = OBJECT_ID('[dbo].[ContractRates]'))
	DROP INDEX ContractRates_BillingCodeId ON [dbo].ContractRates

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='ContractRates_StartDate_EndDate_RecordDeleted' AND object_id = OBJECT_ID('[dbo].[ContractRates]'))
	DROP INDEX ContractRates_StartDate_EndDate_RecordDeleted ON [dbo].ContractRates

IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='Contracts_StartDate_EndDate_RecordDeleted' AND object_id = OBJECT_ID('[dbo].[Contracts]'))
	DROP INDEX Contracts_StartDate_EndDate_RecordDeleted ON [dbo].Contracts


CREATE NONCLUSTERED INDEX ContractRates_BillingCodeId ON dbo.ContractRates(BillingCodeId)

CREATE NONCLUSTERED INDEX ContractRates_StartDate_EndDate_RecordDeleted ON dbo.ContractRates(StartDate,EndDate) INCLUDE (RecordDeleted)

CREATE NONCLUSTERED INDEX Contracts_StartDate_EndDate_RecordDeleted ON dbo.Contracts(StartDate,EndDate) INCLUDE (RecordDeleted)

