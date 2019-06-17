If Exists (Select * From   sys.Objects 
           Where  Object_Id = Object_Id(N'dbo.csp_GetCoveragePlans') 
                  And Type In ( N'P', N'PC' )) 
	Drop Procedure dbo.csp_GetCoveragePlans
Go


Create Procedure [dbo].[csp_GetCoveragePlans]

-- =============================================  
-- Author:  Robert Caffrey  
-- Create date: 12 Apr 2013  
-- Description: Added for Binding dropdown for Revenue Report  
-- =============================================  
AS

Select 
CoveragePlans.CoveragePlanName,
CoveragePlans.CoveragePlanId
 from CoveragePlans
 where Active = 'y'
 AND ISNULL(CoveragePlans.RecordDeleted,'N') = 'N'
 union Select '<All Coverage Plans>', null
 
 Order by 1
