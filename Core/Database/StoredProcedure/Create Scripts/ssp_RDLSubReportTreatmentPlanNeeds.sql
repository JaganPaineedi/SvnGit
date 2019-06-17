/****** Object:  StoredProcedure [dbo].[ssp_RDLSubReportTreatmentPlanNeeds]    Script Date: 25 Oct 2016  ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSubReportTreatmentPlanNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSubReportTreatmentPlanNeeds]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE  [dbo].[ssp_RDLSubReportTreatmentPlanNeeds]  (@DocumentVersionId INT)                        
                                 
As          
BEGIN                   
/**************************************************************    
Created By   : Ajay          Name of SP:ssp_RDLSubReportTreatmentPlanNeeds 11169154  
Created Date :  25 Oct 2016    
Description  : To Get Needs
Change Log  
--------------  
Date         Author      Description  
-------------------------------------------------------------------  
 **************************************************************/                      
BEGIN TRY    

	SELECT DomainName
		,NeedName
		,NeedDescription
		,CASE AddressOnCarePlan
			WHEN 'Y'
				THEN 'Address on Treatment Plan'
			WHEN 'N'
				THEN 'Defer'
			ELSE ''
			END AS AddressOnCarePlan
	FROM CarePlanDomainNeeds CPDN
	LEFT JOIN CarePlanNeeds CPN ON CPDN.CarePlanDomainNeedId = CPN.CarePlanDomainNeedId
	LEFT JOIN CarePlanDomains CPD ON CPDN.CarePlanDomainId = CPD.CarePlanDomainId
	WHERE CPN.DocumentVersionId = @DocumentVersionId
		AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'
		AND ISNULL(CPD.RecordDeleted, 'N') = 'N'
		AND ISNULL(CPN.RecordDeleted, 'N') = 'N'
		 
  END TRY                                                                          
BEGIN CATCH                              
DECLARE @Error varchar(8000)                                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLSubReportTreatmentPlanNeeds')                                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())         
    + '*****' + Convert(varchar,ERROR_STATE())                                                      
 RAISERROR                                                                                                         
 (                                                                           
  @Error, -- Message text.                                                                                                        
  16, -- Severity.                                                                                                        
  1 -- State.                                                                                                        
 );                                                                                                      
END CATCH                                                     
END       

  
 