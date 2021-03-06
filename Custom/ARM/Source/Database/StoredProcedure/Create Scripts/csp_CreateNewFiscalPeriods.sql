/****** Object:  StoredProcedure [dbo].[csp_CreateNewFiscalPeriods]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateNewFiscalPeriods]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CreateNewFiscalPeriods]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateNewFiscalPeriods]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[csp_CreateNewFiscalPeriods]


AS
/**********************************************************************
csp_CreateNewFiscalPeriods

Inserts new Fiscal Year and Accounting Periods on the start of the
new fiscal year.

Modifications:
	
	Date		User			Description
	---------	---------		------------------------------------
	10/03/2011	dharvey			Created

**********************************************************************/

DECLARE @FiscalMonthStart int
, @FiscalStartDate datetime

SET @FiscalMonthStart = isnull((Select FiscalMonth From SystemConfigurations),10)

SET @FiscalStartDate = CONVERT(varchar(2),@FiscalMonthStart)+''/01/''+convert(varchar(4),DATEPART(yyyy,getdate()))

	--
	-- Fiscal Year
	--
	IF not exists (Select 1 From FiscalYears
					Where FiscalYear = DATEPART(yyyy,@FiscalStartDate)+1
					and DATEPART(mm,getdate()) = @FiscalMonthStart
					)
		BEGIN
			Insert into FiscalYears
			(FiscalYear, StartDate, EndDate, RowIdentifier)
			Select FiscalYear + 1, @FiscalStartDate
				, dateadd(day,-1,dateadd(yyyy,1,@FiscalStartDate))
				, newid()
			From FiscalYears 
			Where FiscalYear = DATEPART(yyyy,@FiscalStartDate)
		END


	--
	-- Account Periods
	--
	IF not exists (Select 1 From AccountingPeriods
					Where FiscalYear = DATEPART(yyyy,@FiscalStartDate)+1
					and DATEPART(mm,getdate()) = @FiscalMonthStart
					)
		BEGIN
			Insert into AccountingPeriods
			(FiscalYear, SequenceNumber, StartDate, EndDate, Description, OpenPeriod, RowIdentifier)
			Select FiscalYear + 1, SequenceNumber, dateadd(month,SequenceNumber-1,@FiscalStartDate)
				, dateadd(day,-1,dateadd(month,SequenceNumber,@FiscalStartDate))
				, datename(month,dateadd(month,SequenceNumber-1,@FiscalStartDate))
				, ''Y'', newid()
			From AccountingPeriods 
			Where FiscalYear = DATEPART(yyyy,@FiscalStartDate)
		END


			' 
END
GO
