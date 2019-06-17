CREATE    PROCEDURE  [dbo].[ssp_SCProviderInsurers]
(    
 @LoggedInStaffId int, 
 @ProviderId int   
)    
  
As                 
/*********************************************************************/                            
/* Stored Procedure: dbo.ssp_SCProviderInsurers						   */                            
/* Creation	21-October-2016															*/                            
/* Author:	Manjunath K															*/                            
/* Purpose: Used in the provider rates screen to fill dropdowns			*/                           
/*																		*/   
/*																		*/                            
/* Updates:																*/                            
/* Date				Author			Purpose                             */     
/************************************************************************/  
  
BEGIN   
	BEGIN TRY  
		-- For Insurer    
		SELECT DISTINCT CT.InsurerId, IR.InsurerName, PR.ProviderId  
		FROM Contracts CT   
		INNER JOIN Insurers IR ON IR.InsurerId = CT.InsurerId  
		INNER JOIN Providers PR ON PR.ProviderId = CT.ProviderId  
		LEFT JOIN StaffInsurers SI ON SI.InsurerId = IR.InsurerId  
		INNER JOIN Staff SA On SA.StaffId= @LoggedInStaffId
		WHERE (IsNull(SA.AllInsurers,'N') = 'Y' OR SI.StaffId = @LoggedInStaffId)
		AND PR.ProviderId = @ProviderId
		AND  ISNULL(CT.RecordDeleted,'N') = 'N'   
		AND  ISNULL(IR.RecordDeleted,'N') = 'N'  
		ORDER by IR.InsurerName  
	END TRY  
   
	BEGIN CATCH  
		DECLARE @Error VARCHAR(8000)   
		SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'   
		  + CONVERT(VARCHAR(4000), ERROR_MESSAGE())   
		  + '*****'   
		  + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),   
		  'ssp_SCProviderInsurers' )   
		  + '*****' + CONVERT(VARCHAR, ERROR_LINE())   
		  + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())   
		  + '*****' + CONVERT(VARCHAR, ERROR_STATE())   

		RAISERROR ( @Error,-- Message text.                
		  16,-- Severity.                
		  1 -- State.                
		);   
	END CATCH  
END  