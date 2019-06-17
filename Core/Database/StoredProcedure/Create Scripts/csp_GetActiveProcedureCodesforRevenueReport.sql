IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetActiveProcedureCodesforRevenueReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].csp_GetActiveProcedureCodesforRevenueReport
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Robert Caffrey  
-- Create date: 26 Aug 2013  
-- Description: Added for Binding dropdown for Revenue Report  
-- =============================================  

Create Procedure [dbo].csp_GetActiveProcedureCodesforRevenueReport

AS

Select 
ProcedureCodes.DisplayAs,
ProcedureCodes.ProcedureCodeId
 from ProcedureCodes
 where Active = 'y'
 AND ISNULL(ProcedureCodes.RecordDeleted,'N') = 'N'
 union Select '<All Programs>', null
 
 Order by 1
 
GO

