 /****** Object:  StoredProcedure [dbo].[ssp_GetGroupNames]    Script Date: 01/12/2015 15:36:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetGroupNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetGroupNames]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetGroupNames]    Script Date: 01/12/2015 15:36:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
 
 CREATE PROCEDURE [dbo].[ssp_GetGroupNames](  
  @GroupName VARCHAR(50)    
 )  
 /********************************************************************/  
 /* Stored Procedure: dbo.ssp_GetGroupNames    */  
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
  DECLARE @GroupNoteType INT        
  SET @Name= '%'+ @GroupName + '%' 
  
  SELECT @GroupNoteType=IntegerCodeId FROM Recodes R
  JOIN RecodeCategories RC ON R.RecodeCategoryId=RC.RecodeCategoryId
  WHERE RC.CategoryCode='USEIDDGROUPNOTE' AND ISNULL(R.RecordDeleted, 'N') = 'N' AND ISNULL(RC.RecordDeleted, 'N') = 'N' 
  
  IF @GroupNoteType IS NULL
  BEGIN
	Select Top 10 GroupId,GroupName from Groups WHERE GroupName like @Name AND ISNULL(UsesAttendanceFunctions, 'N') = 'N' AND Active='Y' AND ISNULL(RecordDeleted, 'N') = 'N'    
  END
  ELSE
  BEGIN
	Select Top 10 GroupId,GroupName from Groups WHERE GroupName like @Name AND ISNULL(GroupNoteDocumentCodeId,'')=@GroupNoteType AND ISNULL(UsesAttendanceFunctions, 'N') = 'N' AND Active='Y' AND ISNULL(RecordDeleted, 'N') = 'N'    
  END
  END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetGroupNames') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                                
    16  
    ,-- Severity.                     
    1 -- State.                                                            
    );  
 END CATCH  
END  
