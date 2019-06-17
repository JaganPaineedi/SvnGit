/****** Object:  StoredProcedure [dbo].[ssp_GetStaffAsscoiatedProvider]    Script Date: 02-11-2016  ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetStaffAsscoiatedProvider]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetStaffAsscoiatedProvider]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetStaffAsscoiatedProvider]    Script Date: 02-11-2016  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************/  
/* Stored Procedure: [ssp_GetStaffAsscoiatedProvider]    550, N'Net'         */  
/*       Date              Author                  Purpose           */  
/*      02-11-2016        Alok Kumar               To Get Provider Associated with Staff   */  
/*      05-08-2017        Alok Kumar               Modified where clause to get records if AllProviders or AllowAccessToAllScannedDocuments from Staff Details screen is checked
													 Ref:task#1198 SWMBH - Support  
																									*/  
/****************************************************************************************************/  
  
CREATE PROCEDURE [dbo].[ssp_GetStaffAsscoiatedProvider]  
    @StaffId INT,  
    @ProviderNameFilter VARCHAR(150)  
      
AS  
BEGIN  
 BEGIN TRY  
   
  SELECT ProviderId, ProviderName  
  FROM (  
   SELECT ProviderId  
    ,(  
     ProviderName + CASE   
      WHEN ProviderType = 'I'  
       THEN ', ' + isnull(FirstName, '')  
      ELSE ''  
      END  
     ) AS ProviderName  
   FROM Providers  
   WHERE isnull(RecordDeleted, 'N') <> 'Y'  
    AND UsesProviderAccess = 'Y'  
    AND Active = 'Y'  
    AND (EXISTS (  
     SELECT ProviderId  
     FROM StaffProviders  
     WHERE StaffId = @StaffId  
      AND isnull(RecordDeleted, 'N') <> 'Y'  
      AND StaffProviders.ProviderId = Providers.ProviderId  
     ))														--05-08-2017        Alok Kumar
     OR ( EXISTS( Select 1 From Staff 
					 WHERE StaffId = @StaffId AND isnull(AllProviders, 'N') = 'Y' 
					 AND isnull(Active, 'N') = 'Y' AND isnull(RecordDeleted, 'N') <> 'Y'))
	 OR ( EXISTS( Select 1 From Staff 
					 WHERE StaffId = @StaffId AND isnull(AllowAccessToAllScannedDocuments, 'N') = 'Y' 
					 AND isnull(Active, 'N') = 'Y' AND isnull(RecordDeleted, 'N') <> 'Y'))
     ) AS TempProviders  
  WHERE ProviderName LIKE '%' + @ProviderNameFilter + '%'  
    
    
END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetStaffAsscoiatedProvider') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.    
    16  
    ,-- Severity.    
    1 -- State.    
    );  
 END CATCH  
END  