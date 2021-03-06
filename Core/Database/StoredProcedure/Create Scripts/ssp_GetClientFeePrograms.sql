 /****** Object:  StoredProcedure [dbo].[ssp_GetClientFeeProgram]    Script Date: 11/nov/2018  ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientFeePrograms]')
			AND type IN (
				N'P'
				, N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClientFeePrograms];
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientFeePrograms]    ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[ssp_GetClientFeePrograms] 
 /*=================================================================================================                           
-- Stored Procedure: dbo.ssp_GetClientFeeProgram                              
--                            
--Copyright: Streamline Healthcate Solutions 
/*       Date              Author                  Purpose                   */
         Dec/12/2018        Neethu          Used to Get Programs based on Recodes set up in Client Fee List page, Comprehensive SGL #11
                                  
========================================================================================================================================*/    
AS    
BEGIN    
 BEGIN TRY    
   
  IF EXISTS (SELECT 1 FROM Recodes R WHERE ISNULL(R.RecordDeleted, 'N') = 'N' 
    and exists( SELECT RC.RecodeCategoryId FROM RecodeCategories RC WHERE R.RecodeCategoryId =RC.RecodeCategoryId and
RC.CategoryCode = 'ClientFeeListProgramType'and ISNULL(RC.RecordDeleted, 'N') = 'N'))  
       BEGIN 
      SELECT DISTINCT P.ProgramId	,P.ProgramName	
FROM Programs P
LEFT JOIN Recodes R ON R.IntegerCodeId = P.ProgramType
INNER JOIN GlobalCodes G on G.GlobalCodeId=P.ProgramType
WHERE ISNULL(P.RecordDeleted, 'N') = 'N'  and ISNULL(R.RecordDeleted, 'N') = 'N'  and   ISNULL(P.Active,'N')='Y'
and exists(Select 1 from  Recodes R1 WHERE ISNULL(R1.RecordDeleted, 'N') = 'N' and P.ProgramType = R1.IntegerCodeId
         and exists(Select 1 from RecodeCategories RC WHERE CategoryCode = 'ClientFeeListProgramType'
and RC.RecodeCategoryId= R1.RecodeCategoryId and ISNULL(RC.RecordDeleted, 'N') = 'N'))
Order by P.ProgramName 

        END  

 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientFeeProgram') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR,ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
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



