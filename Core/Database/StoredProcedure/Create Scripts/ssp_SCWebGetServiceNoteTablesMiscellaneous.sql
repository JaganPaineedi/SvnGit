/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetServiceNoteTablesMiscellaneous]    Script Date: 3/27/2018 11:13:50 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetServiceNoteTablesMiscellaneous]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetServiceNoteTablesMiscellaneous]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetServiceNoteTablesMiscellaneous]    Script Date: 3/27/2018 11:13:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
CREATE PROCEDURE [dbo].[ssp_SCWebGetServiceNoteTablesMiscellaneous]   
(                    
 @DocumentVersionId  int                                                                                       ,@StaffId int =NULL                                            
)                         
As              
/******************************************************************************                
**  File: MSDE.cs                
**  Name: csp_SCWebGetServiceNoteCustomTablesMiscellaneous                
**  Desc: This fetches data for Service Note Custom Tables               
**  Copyright: 2006 Streamline SmartCare                                          
**                
**  This template can be customized:                
**                              
**  Return values:                
**                 
**  Called by:   DownloadReqServiceData function in MSDE Class in DataServices                
**                              
**  Parameters:                
**  Input       Output                
**     ----------      -----------                
**  DocumentVersionId    Result Set containing values from Service Note Custom Tables              
**                
**  Auth: Mohit Madaan            
**  Date: 12-Feb-10                
*******************************************************************************                
**  Change History                
*******************************************************************************                
**  Date:   Author:    Description:         
**  27/Aug/2013  MShiva  Moved from Newaygo - Task#6       
**  --------   --------   -------------------------------------------                
              
*******************************************************************************/                
BEGIN TRY                
               
SELECT [DocumentVersionId]            
      ,[Narration]              
      ,[CreatedBy]              
      ,[CreatedDate]              
      ,[ModifiedBy]              
      ,[ModifiedDate]              
      ,[RecordDeleted]              
      ,[DeletedDate]              
      ,[DeletedBy]              
  FROM CustomMiscellaneousNotes              
  WHERE ISNull(RecordDeleted,'N')='N' AND DocumentVersionId=@DocumentVersionId               
               
END TRY                
              
BEGIN CATCH                
 declare @Error varchar(8000)                
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCWebGetServiceNoteTablesMiscellaneous')                 
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                  
    + '*****' + Convert(varchar,ERROR_STATE())                
                  
 RAISERROR                 
 (                
  @Error, -- Message text.                
  16,  -- Severity.                
  1  -- State.                
 );                
                
END CATCH   
  
GO


