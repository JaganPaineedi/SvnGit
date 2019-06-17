IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_GetAllAcademicTerms]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetAllAcademicTerms] 

go 

SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 
CREATE PROCEDURE ssp_GetAllAcademicTerms  
As								
  
 /********************************************************************************                                                
-- Stored Procedure: ssp_GetAllAcademicTerms                                                
--                                                
-- Copyright: Streamline Healthcare Solutions                                                
--                                                
-- Purpose: Used By Classroom Assignments List page for filling the AcademicTerms dropdown                                              
--                                                
-- Updates:                                                                                                       
-- Date         Author                  Purpose                                                
-- 15.03.2018   Pradeep Kumar Yadav     CREATED.      
                 
*********************************************************************************/ 
Begin
	BEGIN TRY   
SELECT   AT.AcademicTermId
		,AT.CreatedBy
		,AT.CreatedDate
		,AT.ModifiedBy
		,AT.ModifiedDate
		,AT.RecordDeleted
		,AT.DeletedBy
		,AT.DeletedDate
		,AT.AcademicYearId
		,AT.QuarterOrSemester
		,AT.Active
		,AT.StartDate
		,AT.EndDate
		,AT.AcademicTermName     
FROM AcademicTerms AT INNER JOIN
     AcademicYears AY ON AT.AcademicYearId = AY.AcademicYearId
	 WHERE AT.Active='Y' AND IsNull(AT.RecordDeleted,'N')='N' and AY.Active='Y' AND IsNull(AY.RecordDeleted,'N')='N' 
      END TRY  
  BEGIN CATCH  
    DECLARE @Error varchar(8000)  
  
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), '[ssp_GetAllAcademicTerms]') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())  
  
    RAISERROR (  
    @Error  
    ,-- Message text.                                                                                                                
    16  
    ,-- Severity.                                                                                                                
    1 -- State.                                                                                                                
    );  
  END CATCH  
END
  
