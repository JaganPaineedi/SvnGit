/****** Object:  StoredProcedure [dbo].[csp_RDLMITS]    Script Date: 2018-08-09 11:45:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLMITS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLMITS]
GO


/****** Object:  StoredProcedure [dbo].[csp_RDLMITS]    Script Date: 2018-08-09 11:45:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO    
  
CREATE PROC [dbo].[csp_RDLMITS]  
@BeginDate date  
, @EndDate date  
AS  
/**********************************************************************  
  
Stored Procedure: dbo.csp_RDLMITS  
  
Purpose:   TBD  
  
Updates:  
Date         Author             Purpose  
2018-08-09   JStedman Created ; ARM Enh 322 
11/15/2018   Rajeshwari S       Added code to display Client Name instead of to display separate First Name and Last Name of client on report 'Mits Report'. Task: A Renewed Mind - Support #1018
**********************************************************************/  
BEGIN  
  
 /* Test  
   
 EXEC dbo.csp_RDLMITS @BeginDate='2018-07-01', @EndDate='2018-07-31'  
  
 */  
  
 --DECLARE @BeginDate date = '2018-07-01', @EndDate date = '2018-07-31'  --Test code  
 SELECT  
  c.ClientId  
  ,c.LastName+', '+c.FirstName AS ClientName   
  --, c.LastName AS ClientLName  
  , CONVERT(date, c.DOB) AS ClientDOB  
  , c.SSN  
  , cp.CoveragePlanName  
  , ISNULL(ccp.InsuredId, '') AS MedicaidInsID  
 FROM  
  dbo.Clients AS c  
   INNER JOIN dbo.ClientCoveragePlans AS ccp ON ccp.ClientId = c.ClientId AND ISNULL(ccp.RecordDeleted, 'N') = 'N'  
   INNER JOIN dbo.CoveragePlans AS cp ON cp.CoveragePlanId = ccp.CoveragePlanId AND ISNULL(cp.RecordDeleted, 'N') = 'N' AND ISNULL(cp.MedicaidPlan, 'N') = 'Y'  
 WHERE  
  ( c.RecordDeleted IS NULL OR c.RecordDeleted = 'N' )  
   AND c.Active = 'Y'  
   AND EXISTS (  
    SELECT  
     *  
    FROM  
     dbo.ClientCoverageHistory AS cch  
    WHERE  
     ( cch.RecordDeleted IS NULL OR cch.RecordDeleted = 'N' )  
      AND cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId  
      AND ISNULL(cch.EndDate, @EndDate) BETWEEN @BeginDate AND @EndDate  
   )  
   --AND c.ClientId = 21  --Test Code  
 ;  
  
END;  
  