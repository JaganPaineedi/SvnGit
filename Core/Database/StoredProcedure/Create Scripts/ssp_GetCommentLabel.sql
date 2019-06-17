
/****** Object:  StoredProcedure [dbo].[ssp_GetCommentLabel]    Script Date: 01/29/2016 16:45:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetCommentLabel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetCommentLabel]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetCommentLabel]    Script Date: 01/29/2016 16:45:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure  [dbo].[ssp_GetCommentLabel]   --1                 
@GroupId INT                                 
AS            
/******************************************************************************                                
**  File:                               
**  Name: Stored_Procedure_Name                                
**  Desc:This is used to get group information against passed parameter                                 
**                                          
**  Return values:                                
**                                 
**  Called by:GroupSerice.cs                                   
**                                              
**  Parameters:                                
**  Input       Output                     
**  @GroupId    None                            
**     ----------       -----------                                
**                                
**  Auth:Pradeep                                 
**  Date:Dec 9,2009                                 
*******************************************************************************                                
**  Change History                                
*******************************************************************************                                
**  Date:  Author:    Description:   
	28/03/2017      Venkatesh        Check whether the Procedure code is is exists in the Recode Table or not.                             
**  --------  --------    -------------------------------------------                                
*******************************************************************************/                  
BEGIN                  
  BEGIN TRY         
    
 DECLARE @CommentLabel INT
 DECLARE @ProcedureCodeId INT
 SELECT @ProcedureCodeId=ProcedureCodeId FROM Groups WHERE GroupId=@GroupId
 IF EXISTS (SELECT 1 FROM Recodes R JOIN RecodeCategories RC ON R.RecodeCategoryId=RC.RecodeCategoryId AND ISNULL(RC.RecordDeleted,'N')='N'
				WHERE R.IntegerCodeId=@ProcedureCodeId AND RC.CategoryCode='LABELCOMMENTS' AND ISNULL(R.RecordDeleted,'N')='N')
 BEGIN
	SELECT 1 AS CommentLabel
 END
 ELSE
 BEGIN
	SELECT 0 AS CommentLabel
 END

  END TRY                  
  BEGIN CATCH                  
    DECLARE @Error varchar(8000)                              
          SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****'                                            
          + Convert(varchar(4000),ERROR_MESSAGE())                                                   
          + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                                            
          '[ssp_GetCommentLabel]')                                
          + '*****' + Convert(varchar,ERROR_LINE())                                            
          + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                  
          + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                  
      RAISERROR                                                   
          (                                                   
            @Error, -- Message text.                       
            16, -- Severity.                                                   
            1 -- State.                                                   
          )                   
  END CATCH                  
END 
GO


