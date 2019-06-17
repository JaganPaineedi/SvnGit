 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetLicenseAndDegreeGroupItems]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetLicenseAndDegreeGroupItems]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[ssp_GetLicenseAndDegreeGroupItems]
(@LicenseAndDegreeGroupId int)            
As   
 Begin   
 Begin TRY     
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetLicenseAndDegreeGroupItems]      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author				Purpose 
  02-20-2017   Nandita				What:Used in Licensure Degree Groups Detail Page
*********************************************************************************/         
--IF(@LicenseAndDegreeGroupId<0)
--BEGIN
--SELECT 
--LDGI.LicenseAndDegreeGroupItemId
--,LDGI.LicenseAndDegreeGroupId
--,LDGI.CreatedBy
--,LDGI.CreatedDate
--,LDGI.ModifiedBy
--,LDGI.ModifiedDate
--,LDGI.RecordDeleted
--,LDGI.DeletedDate
--,LDGI.DeletedBy
--,LDGI.LicenseTypeDegreeId
--,GC.CodeName AS LicenseTypeDegree
--FROM LicenseAndDegreeGroupItems LDGI 
--	LEFT JOIN GlobalCodes GC ON LDGI.LicenseTypeDegreeId=gc.GlobalCodeId
--	LEFT JOIN LicenseAndDegreeGroups LDG ON LDG.LicenseAndDegreeGroupId = LDGI.LicenseAndDegreeGroupId
--	WHERE  ISNULL(LDGI.RecordDeleted, 'N')='N'
--END

--ELSE
--BEGIN
SELECT 
LDGI.LicenseAndDegreeGroupItemId
,LDGI.LicenseAndDegreeGroupId
,LDGI.CreatedBy
,LDGI.CreatedDate
,LDGI.ModifiedBy
,LDGI.ModifiedDate
,LDGI.RecordDeleted
,LDGI.DeletedDate
,LDGI.DeletedBy
,LDGI.LicenseTypeDegreeId
,GC.CodeName AS LicenseTypeDegree
FROM LicenseAndDegreeGroupItems LDGI 
	LEFT JOIN GlobalCodes GC ON LDGI.LicenseTypeDegreeId=gc.GlobalCodeId
	LEFT JOIN LicenseAndDegreeGroups LDG ON LDG.LicenseAndDegreeGroupId = LDGI.LicenseAndDegreeGroupId
	WHERE LDG.LicenseAndDegreeGroupId =@LicenseAndDegreeGroupId AND ISNULL(LDGI.RecordDeleted, 'N')='N'
--END
	
--Checking For Errors            
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetLicenseAndDegreeGroupItems')                                                                                                           
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
GO
