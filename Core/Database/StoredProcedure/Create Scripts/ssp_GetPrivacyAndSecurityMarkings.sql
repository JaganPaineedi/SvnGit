/****** Object:  StoredProcedure [dbo].[ssp_GetPrivacyAndSecurityMarkings]    Script Date: 10/09/2017 18:00:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPrivacyAndSecurityMarkings]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPrivacyAndSecurityMarkings]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetPrivacyAndSecurityMarkings]    Script Date: 10/09/2017 18:00:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetPrivacyAndSecurityMarkings] @ClientId INT = NULL    
 ,@Type VARCHAR(10) = NULL    
 ,@DocumentVersionId INT = NULL    
 ,@FromDate DATETIME = NULL    
 ,@ToDate DATETIME = NULL      
AS    
-- =============================================            
-- Author:  Vijay            
-- Create date: Oct 09, 2017            
-- Description: Retrieves Privacy And Security Markings details
-- Task:   MUS3 - Task#25.4           
/*            
 Author   Modified Date   Reason           
*/    
-- =============================================            
BEGIN    
 BEGIN TRY    
         
   SELECT DISTINCT c.ClientId    
		  ,sf.FirstName    
		  ,sf.LastName    
		  ,A.AgencyName       
		  ,A.Address        
		  ,A.City        
		  ,A.State       
		  ,A.ZipCode		     
		  ,CASE WHEN ISNULL(A.MainPhone,'') <> ''        
			 THEN '('+SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(A.MainPhone, '(', ''), ')', ''), '-', ''),' ', ''), 1, 3) +')'       
			  + ' '       
			  + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(A.MainPhone, '(', ''), ')', ''), '-', ''),' ', ''), 4, 3)        
			  + '-'       
			  + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(A.MainPhone, '(', ''), ')', ''), '-', ''),' ', ''), 7, 4)        
			  ELSE ''      
			  END AS [Phone]
		  ,CASE T.ConfidentialityCode
			WHEN 'N'
				THEN 'Normal'
			WHEN 'R'
				THEN 'Restricted'
			WHEN 'V'
				THEN 'Very Restricted'
			END as ConfidentialityCode
		 ,CASE WHEN ISNULL(T.ConfidentialityCode,'')='N' THEN (SELECT Value  FROM SystemConfigurationKeys WHERE [Key] = 'TextForNormalConfidentialityCodeOnSummaryOfCare') 
			 WHEN ISNULL(T.ConfidentialityCode,'')='R' THEN (SELECT Value  FROM SystemConfigurationKeys WHERE [Key] = 'TextForRestrictedConfidentialityCodeOnSummaryOfCare' )     
			 WHEN ISNULL(T.ConfidentialityCode,'')='V' THEN (SELECT Value  FROM SystemConfigurationKeys WHERE [Key] = 'TextForVeryRestrictedConfidentialityCodeOnSummaryOfCare' )   
			 ELSE ''      
			 END AS TextForConfidentialityCode       
	  FROM Clients c    
	   LEFT JOIN Staff sf ON sf.StaffId = c.PrimaryClinicianId AND  sf.Prescriber = 'Y'
	   JOIN DOCUMENTS D ON D.ClientId = c.ClientId
	   JOIN DocumentVersions Dv ON Dv.DocumentId = D.DocumentId
	   JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = Dv.DocumentVersionId
	   CROSS JOIN  Agency A               
	   WHERE c.ClientId = @ClientId 
	   AND T.DocumentVersionId = @DocumentVersionId  
	   AND c.Active = 'Y'
	   AND ISNULL(c.RecordDeleted,'N')='N'         
      
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetPrivacyAndSecurityMarkings') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' +     
   CONVERT(VARCHAR, ERROR_STATE())    
    
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