/****** Object:  StoredProcedure [dbo].[ssp_GetGroupNoteDocumentodes]    Script Date: 11/18/2011 16:25:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetGroupNoteDocumentodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetGroupNoteDocumentodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure  [dbo].[ssp_GetGroupNoteDocumentodes]      
                  
AS                  
/******************************************************************************                  
**  File:                 
**  Name: ssp_GetGroupNoteDocumentodes                  
**  Desc:This is used to get data from groupNoteDocumentCodeTable                   
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
**  Date:Dec 15,2009                   
*******************************************************************************                  
**  Change History                  
*******************************************************************************                  
**  Date:          Author:      Description:                  
**  --------       --------     -------------------------------------------                  
**  13/APRIL/2016  Akwinass		What: GroupNoteCodeId JOIN removed (Task #167.1 in Valley - Support Go Live) 
								Why:  GroupNoteCodeId column modified ot allow NULL                  
*******************************************************************************/    
BEGIN    
  BEGIN TRY    
		SELECT GroupNoteDocumentCodeId
			,gndc.GroupNoteName
			,gndc.Active
			,gndc.GroupNoteCodeId
			,gndc.ServiceNoteCodeId
			,gndc.CopyStoredProcedureName
			,gndc.RowIdentifier
			,gndc.CreatedBy
			,gndc.CreatedDate
			,gndc.ModifiedBy
			,gndc.ModifiedDate
			,gndc.RecordDeleted
			,gndc.DeletedDate
			,gndc.DeletedBy
		FROM GroupNoteDocumentCodes AS gndc		
		JOIN dbo.DocumentCodes AS dcs ON dcs.DocumentCodeId = gndc.ServiceNoteCodeId
		--JOIN dbo.DocumentCodes AS dcg ON dcg.DocumentCodeId = gndc.GroupNoteCodeId
		WHERE ISNULL(gndc.RecordDeleted, 'N') = 'N'
			AND ISNULL(gndc.Active, 'N') = 'Y'			
			AND ISNULL(dcs.Active, 'N') = 'Y'			
			AND ISNULL(dcs.RecordDeleted, 'N') <> 'Y'
			-- 13/APRIL/2016 Akwinass
			AND (EXISTS(SELECT 1 FROM DocumentCodes dcg WHERE ISNULL(dcg.Active,'N') = 'Y' AND ISNULL(dcg.RecordDeleted, 'N') <> 'Y' AND dcg.DocumentCodeId = gndc.GroupNoteCodeId) OR gndc.GroupNoteCodeId IS NULL)
		ORDER BY gndc.GroupNoteName ASC          
  END TRY    
  BEGIN CATCH    
    DECLARE @Error varchar(8000)                                     
          SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****'                              
          + Convert(varchar(4000),ERROR_MESSAGE())                                     
          + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                              
          '[ssp_GetGroupNoteDocumentodes]')                                     
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
