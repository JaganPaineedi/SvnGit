/****** Object:  StoredProcedure [dbo].[ssp_GetClientPlansAndTimeSpans]    Script Date: 11/18/2011 16:25:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientPlansAndTimeSpans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientPlansAndTimeSpans]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientPlansAndTimeSpans]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  Procedure [dbo].[ssp_GetClientPlansAndTimeSpans]                            
 /* Param List */                            
 @ClientId INT                            
AS                            
                            
/******************************************************************************                            
**  File:                             
**  Name: ssp_GetClientPlansAndTimeSpans                            
**  Desc:                             
**                            
**  This template can be customized:                            
**                                          
**  Return values:                            
**                             
**  Called by:                               
**             ClientPlansTimeSpans.cs                             
**  Parameters:                            
**  Input       Output                            
**  ----------  -----------                            
**  @ClientId            
**            
**  Auth: Jaspreet Singh                          
**  Date: 01-Nov-2007                            
*******************************************************************************                            
**  Change History                            
*******************************************************************************                            
**  Date:  Author:    Description:                            
**  --------  --------    -------------------------------------------                            
**  3 March Pradeep   Made changes as per task#102     
**  20 Oct 2015	Revathi   what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.           
							why:task #609, Network180 Customization                                
*******************************************************************************/                             
BEGIN TRY              
               
 SELECT  CP.DisplayAs AS PlanName, CCP.ClientCoveragePlanId,CCP.InsuredId,                           
   CASE WHEN CCP.ClientIsSubscriber=''Y'' THEN ''Self''                       
  ELSE GC.CodeName END AS Insured                  
                   
 FROM ClientCoveragePlans CCP                          
 --INNER JOIN Clients C ON C.ClientId = CCP.ClientId                       
 INNER JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId AND (CP.RecordDeleted = ''N'' OR CP.RecordDeleted IS NULL)                  
 LEFT JOIN ClientContacts CC ON CC.ClientContactId=CCP.SubscriberContactId AND (CC.RecordDeleted = ''N'' OR CC.RecordDeleted IS NULL)                  
 LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=CC.Relationship AND (GC.RecordDeleted = ''N'' OR GC.RecordDeleted IS NULL)                  
 WHERE CCP.ClientId=@ClientId                   
 AND (CCP.RecordDeleted = ''N'' OR CCP.RecordDeleted IS NULL)     
 --Adeed By Pradeep as per task#101    
 order by PlanName ASC                  
                   
                   
 --Client''s Copayments for Today                  
 SELECT CCP.ClientCoveragePlanId, CCO.ProcedureCap,CCO.DailyCap,CCO.WeeklyCap,CCO.MonthlyCap,CCO.YearlyCap                  
 FROM ClientCoveragePlans CCP                   
 LEFT JOIN ClientCopayments CCO ON CCP.ClientCoveragePlanId=CCO.ClientCoveragePlanId                  
 AND CAST(CONVERT(Varchar(10),startDate,101) AS DateTime) <= CAST(CONVERT(Varchar(10),GetDate(),101) AS DateTime) and CAST(CONVERT(Varchar(10),EndDate,101) AS DateTime)>= CAST(CONVERT(Varchar(10),GetDate(),101) AS DateTime)                        
 WHERE CCP.ClientId=@ClientId                   
 AND (CCP.RecordDeleted = ''N'' OR CCP.RecordDeleted IS NULL)                  
 AND (CCO.RecordDeleted = ''N'' OR CCO.RecordDeleted IS NULL)                  
                   
                    
 SELECT DISTINCT StartDate,EndDate FROM ClientCoverageHistory CCH                          
 INNER JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId                          
 WHERE CCP.ClientId=@ClientId                         
 AND (CCH.RecordDeleted = ''N'' OR CCH.RecordDeleted IS NULL)                   
 AND (CCP.RecordDeleted = ''N'' OR CCP.RecordDeleted IS NULL)                   
 ORDER BY StartDate DESC,EndDate DESC                          
                           
                   
 SELECT ClientCoverageHistoryId, CONVERT(VARCHAR,StartDate,101) AS StartDateFormat, CONVERT(VARCHAR,EndDate,101)AS EndDateFormat,                   
 StartDate, EndDate,COBOrder, CCH.CreatedBy, CCH.CreatedDate ,                  
 CCH.ModifiedBy, CCH.ModifiedDate, CCH.RecordDeleted, CCH.DeletedDate,                   
 CCH.DeletedBy, CP.DisplayAs AS PlanName,CP.AddressDisplay, CCP.InsuredId AS InsuredId,                  
  --Added by Revathi 20 Oct 2015                  
 case when  ISNULL(C.ClientType,''I'')=''I'' then ISNULL(C.LastName,'''') + '', '' + ISNULL(C.FirstName,'''') else ISNULL(C.OrganizationName,'''') end AS ClientName,                        
 CCP.ClientCoveragePlanId AS ClientCoveragePlanId                         
 FROM ClientCoveragePlans CCP                            
 LEFT JOIN ClientCoverageHistory CCH ON CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId AND (CCH.RecordDeleted = ''N'' OR CCH.RecordDeleted IS NULL)                            
 LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId AND (CP.RecordDeleted = ''N'' OR CP.RecordDeleted IS NULL)                            
 LEFT JOIN Clients C ON C.ClientId = CCP.ClientId   AND (C.RecordDeleted = ''N'' OR C.RecordDeleted IS NULL)                                    
 WHERE CCP.ClientId  = @ClientId AND (CCP.RecordDeleted = ''N'' OR CCP.RecordDeleted IS NULL)                 
END TRY              
BEGIN CATCH                  
 declare @Error varchar(8000)                  
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_GetClientPlansAndTimeSpans'')                   
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                    
    + ''*****'' + Convert(varchar,ERROR_STATE())                  
                    
 RAISERROR                   
 (                  
  @Error, -- Message text.                  
  16, -- Severity.                  
  1 -- State.                  
 );                  
                  
END CATCH
' 
END
GO
