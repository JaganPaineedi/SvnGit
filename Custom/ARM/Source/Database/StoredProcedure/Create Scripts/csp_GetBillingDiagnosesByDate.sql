/****** Object:  StoredProcedure [dbo].[csp_GetBillingDiagnosesByDate]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetBillingDiagnosesByDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetBillingDiagnosesByDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetBillingDiagnosesByDate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_GetBillingDiagnosesByDate]
	@ClientId int,
	@ServiceDate datetime
/************************************************************************/
/* Proc: csp_GetBillingDiagnosesByDate									*/
/*																		*/
/* Purpose: Use the CustomDegreePriorities table to determine which		*/
/* diagnosis document takes precedence when more than one dx doc is		*/
/* available for the period.											*/
/*																		*/
/* Called by: [ssp_PMGetBillingDiagnosisByDate] and						*/
/* [ssp_SCBillingDiagnosiServiceNote]									*/
/*																		*/
/* Created by: TER														*/
/*																		*/
/* Created on: 1/4/2008													*/
/*																		*/
/************************************************************************/
as



return 0
' 
END
GO
