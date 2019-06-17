 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetLicenseAndDegreeGroups]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetLicenseAndDegreeGroups]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[ssp_GetLicenseAndDegreeGroups]
(@LicenseAndDegreeId int)            
As   
 Begin   
 Begin TRY     
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetLicenseAndDegreeGroups]      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author				Purpose 
  02-20-2017   Nandita				What:Used in Licensure Degree Groups Detail Page
  02-27-2017   Wasif				Update table selection join and reordered the column list.

*********************************************************************************/         

CREATE TABLE #Licenses         
 (          
  LicenseAndDegreeGroupId  INT,  
  LicenseAndDegreeGroupName  VARCHAR(100),
  StartDate DATETIME,
  EndDate DATETIME,
  Active CHAR(1),
  CreatedBy VARCHAR(250),
  CreatedDate DATETIME,
  ModifiedBy VARCHAR(250),
  ModifiedDate DATETIME,
  RecordDeleted  CHAR(1),
  DeletedDate DATETIME,
  DeletedBy VARCHAR(250),
  LicenseTypeDegreeId INT,
  Licenses varchar(250)             
 )   

 INSERT INTO #Licenses      
  (    
  LicenseAndDegreeGroupId,  
  LicenseAndDegreeGroupName,
  StartDate,
  EndDate,
  Active,
  CreatedBy,
  CreatedDate,
  ModifiedBy,
  ModifiedDate,
  RecordDeleted,
  DeletedDate,
  DeletedBy,
  LicenseTypeDegreeId,
  Licenses    
  )      
SELECT 
LDG.LicenseAndDegreeGroupId
,LDG.LicenseAndDegreeGroupName
,LDG.StartDate
,LDG.EndDate
,LDG.Active
,LDG.CreatedBy
,LDG.CreatedDate
,LDG.ModifiedBy
,LDG.ModifiedDate
,LDG.RecordDeleted
,LDG.DeletedDate
,LDG.DeletedBy
,LDGI.LicenseTypeDegreeId
,GC.CodeName AS LicenseTypeDegree 
FROM LicenseAndDegreeGroups LDG 
	LEFT JOIN LicenseAndDegreeGroupItems LDGI ON LDG.LicenseAndDegreeGroupId = LDGI.LicenseAndDegreeGroupId
	LEFT JOIN GlobalCodes GC ON LDGI.LicenseTypeDegreeId=gc.GlobalCodeId
	WHERE ISNULL(LDG.RecordDeleted, 'N') <> 'Y' AND (LDG.EndDate IS NULL OR (GETDATE() BETWEEN LDG.StartDate AND LDG.EndDate) OR (LDG.EndDate IS NULL AND LDG.StartDate IS NULL)
	OR (LDG.StartDate > GETDATE() AND LDG.EndDate > GETDATE())
	OR (LDG.StartDate < GETDATE() AND LDG.EndDate < GETDATE() AND LDG.StartDate < LDG.EndDate))

DECLARE @CreateDate DATETIME = '1900-01-01 00:00:00';
SET @CreateDate =DATEADD(year, -150, GETDATE())

select  1 as LicenseAndDegreeId
     , 'sa' as CreatedBy
     , @CreateDate  as CreatedDate
     , 'sa' as ModifiedBy
     , @CreateDate as ModifiedDate

SELECT a.[LicenseAndDegreeGroupId],a.CreatedBy,a.CreatedDate,a.ModifiedBy,a.ModifiedDate,a.RecordDeleted,a.DeletedDate,a.DeletedBy,a.LicenseAndDegreeGroupName ,a.StartDate,a.EndDate,a.Active
        ,d.Licenses
FROM
        (
            SELECT DISTINCT [LicenseAndDegreeGroupId],LicenseAndDegreeGroupName,StartDate,EndDate,Active,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy
            FROM #Licenses
        ) a
        CROSS APPLY
        (
            SELECT [B].[Licenses] + ', ' 
            FROM #Licenses AS B 
            WHERE A.[LicenseAndDegreeGroupId] = B.[LicenseAndDegreeGroupId]
            FOR XML PATH('')
        ) D (Licenses) 


DROP TABLE #Licenses

--Checking For Errors            
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetLicenseAndDegreeGroups')                                                                                                           
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
