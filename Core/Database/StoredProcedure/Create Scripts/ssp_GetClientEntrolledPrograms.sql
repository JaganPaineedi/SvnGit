 /****** Object:  StoredProcedure [dbo].[ssp_GetClientEntrolledPrograms]    Script Date: 01/12/2015 15:36:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientEntrolledPrograms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientEntrolledPrograms]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetClientEntrolledPrograms]    Script Date: 01/12/2015 15:36:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
 
 CREATE PROCEDURE [dbo].[ssp_GetClientEntrolledPrograms] (  
  @ClientId INT,
  @GroupProgramId INT,
  @ProgramName VARCHAR(50)    
 )  
 /********************************************************************/  
 /* Stored Procedure: dbo.ssp_GetClientEntrolledPrograms    */  
 /* Creation Date:  05 Aug,2011                                      */  
 /*                                                                  */  
 /* Purpose: get Client Names based on client name*/  
 /*                                                                  */  
 /* Input Parameters: @ClientName        */  
 /*                                                                  */  
 /* Output Parameters:            */  
 /*                                                                  */  
 /*  Date                  Author                 Purpose   */  
 /* 22/12/2016             Venkatesh     Created - As per task Texas Customization 44 */  
 /********************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  
	  DECLARE @Name VARCHAR(50)         
	  SET @Name= '%'+ @ProgramName + '%' 
	  
	  CREATE TABLE #GroupNoteProgramList  
	  (  
	  ProgramId INT,  
	  ProgramName VARCHAR(200)  
	  )
	  
	  Insert into #GroupNoteProgramList  	    
	  Select Top 10 CP.ProgramId, P.ProgramName FROM Programs P
	  JOIN ClientPrograms CP ON CP.ProgramId=P.ProgramId
	  WHERE ISNULL(CP.RecordDeleted, 'N') = 'N'  AND ISNULL(P.RecordDeleted, 'N') = 'N' 
	  AND ClientId =  @ClientId AND P.ProgramName like @Name
	  
	  IF NOT EXISTS (Select 1 FROM #GroupNoteProgramList WHERE ProgramId=@GroupProgramId)
	  BEGIN
			Insert into #GroupNoteProgramList
			SELECT @GroupProgramId , (SELECT ProgramName FROM Programs WHERE ProgramId=@GroupProgramId)
	  END
	
	 SELECT ProgramId,ProgramName FROM #GroupNoteProgramList
  END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientEntrolledPrograms') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                                
    16  
    ,-- Severity.                     
    1 -- State.                                                            
    );  
 END CATCH  
END  