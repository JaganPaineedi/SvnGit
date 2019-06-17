
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLSummaryOfCareProcedures]    Script Date: 06/09/2015 05:22:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSummaryOfCareProcedures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSummaryOfCareProcedures]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLSummaryOfCareProcedures]    Script Date: 06/09/2015 05:22:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLSummaryOfCareProcedures] --null,14860,null
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
AS
/******************************************************************************                      
**  File: ssp_RDLSummaryOfCareProcedures.sql    
**  Name: ssp_RDLSummaryOfCareProcedures    
**  Desc:     
**                      
**  Return values: <Return Values>                     
**                       
**  Called by: <Code file that calls>                        
**                                    
**  Parameters:                      
**  Input   Output                      
**  ServiceId      -----------                      
**                      
**  Created By: Veena S Mani   
**  Date:  Feb 25 2014    
*******************************************************************************                      
**  Change History                      
*******************************************************************************                      
**  Date:		Author:				Description:                      
**  --------	--------			------------------------------------------- 
**  02/05/2014   Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18            
**  019/05/2014  Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.              
                     
*******************************************************************************/
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
 /* commented by Shankha  
    
  SELECT DISTINCT pc.ProcedureCodeName AS Description  
   ,ISNULL(PR.BillingCode, '') + ' ' + ISNULL(PR.Modifier1, '') + ' ' + ISNULL(PR.Modifier2, '') + ' ' + ISNULL(PR.Modifier3, '') + ' ' + ISNULL(PR.Modifier4, '') AS BillingCodeModifiers  
   ,(CONVERT(VARCHAR(10), s.DateofService, 101) + ' ' + SUBSTRING(CONVERT(VARCHAR(20), s.DateofService, 9), 13, 5) + ' ' + SUBSTRING(CONVERT(VARCHAR(30), s.DateofService, 9), 25, 2)) AS ServiceDate  
  FROM dbo.Services AS s  
  INNER JOIN dbo.ProcedureCodes AS pc ON pc.ProcedureCodeId = s.ProcedureCodeId  
  LEFT JOIN ProcedureRates PR ON pr.ProcedureCodeId = pc.ProcedureCodeId  
  WHERE CAST(S.DateofService AS DATE) <= CAST(Getdate() AS DATE)  
   AND CAST(S.DateofService AS DATE) >= DATEADD(mm, - 6, CAST(Getdate() AS DATE))  
   AND Isnull(S.RecordDeleted, 'N') <> 'Y'  
   AND Isnull(pc.RecordDeleted, 'N') <> 'Y'  
   AND s.Clientid = @ClientId  
   AND pr.coverageplanid IS NULL  
   AND (  
    s.procedurerateid IS NULL  
    OR s.procedurerateid = pr.procedurerateid  
    )  
   --and CAST(fromdate AS DATE) <= CAST(S.DateofService AS DATE)    
   --AND CAST(todate AS DATE) >= CAST(S.DateofService AS DATE) --and pr.priority=max(priority)    
   --s.ServiceId = @ServiceId   
  */   
  /* Added by shankha to refer the clientprocedures table instead of services */      
     
  SELECT DISTINCT PC.ProcedureCode AS BillingCodeModifiers  
    ,CONVERT(VARCHAR(12), CP.OrderDate, 107) AS ServiceDate  
    ,PC.DisplayAs AS Description  
   FROM ClientProcedures CP  
   LEFT JOIN PCProcedureCodes PC ON PC.PCProcedureCodeId = CP.ProcedureId  
    AND ISNULL(PC.RecordDeleted, 'N') = 'N'  
    AND PC.Active = 'Y'  
   WHERE ISNULL(CP.RecordDeleted, 'N') = 'N'  
    AND CP.ClientId = @ClientId  
    --AND (CAST(CP.OrderDate AS DATE)  = CAST(@EffectiveDate AS DATE))  
    --AND CAST(CP.OrderDate AS DATE) <= CAST(Getdate() AS DATE)  
   --AND CAST(CP.OrderDate AS DATE) >= DATEADD(mm, - 6, CAST(Getdate() AS DATE))  
   ORDER BY PC.ProcedureCode DESC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSummaryOfCareProcedures') + '*****' 
		+ CONVERT(VARCHAR, ERROR_LINE()) + '*****'
		 + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' 
		 + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                   
				16
				,-- Severity.                                                          
				1 -- State.                                                       
				);
	END CATCH
END
GO

