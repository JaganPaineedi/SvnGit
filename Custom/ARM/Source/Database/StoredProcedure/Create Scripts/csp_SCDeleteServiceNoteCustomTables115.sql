/****** Object:  StoredProcedure [dbo].[csp_SCDeleteServiceNoteCustomTables115]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteServiceNoteCustomTables115]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteServiceNoteCustomTables115]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteServiceNoteCustomTables115]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCDeleteServiceNoteCustomTables115]      
(                
 @DocumentVersionId as int,                
 @varAuthorName varchar(50)                                                                                                                                   
)                
As      
/******************************************************************************        
**  File: MSDE.cs        
**  Name: csp_SCDeleteServiceNoteCustomTables115        
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
**  DocumentID,Version    Result Set containing values from Service Note Custom Tables      
**        
**  Auth: Balvinder Singh        
**  Date: 24-April-08        
*******************************************************************************        
**  Change History        
*******************************************************************************        
**  Date:    Author:    Description:        
**  --------   --------   -------------------------------------------        
      
*******************************************************************************/        
BEGIN TRY        
       
Update CustomMiscellaneousNotes      
set RecordDeleted=''Y'',DeletedBy=@varAuthorName, DeletedDate=getDate()      
where DocumentVersionId=@DocumentVersionId       
       
END TRY        
      
BEGIN CATCH        
 declare @Error varchar(8000)        
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())         
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCDeleteServiceNoteCustomTables115'')         
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())          
    + ''*****'' + Convert(varchar,ERROR_STATE())        
          
 RAISERROR         
 (        
  @Error, -- Message text.        
  16,  -- Severity.        
  1  -- State.        
 );        
        
END CATCH
' 
END
GO
