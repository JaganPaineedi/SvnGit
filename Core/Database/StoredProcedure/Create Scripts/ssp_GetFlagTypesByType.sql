/****** Object:  StoredProcedure [dbo].[ssp_GetFlagTypesByType]    Script Date: 02/01/2018 16:59:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetFlagTypesByType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetFlagTypesByType]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetFlagTypesByType]    Script Date: 02/01/2018 16:59:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  Procedure [dbo].[ssp_GetFlagTypesByType] --'', 46863, 466654
(@FlagType VARCHAR(Max)
,@FlagTypeId INT
,@ClientNoteId INT )
As   
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetFlagTypesByType]   
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author		Purpose 
  01-02-2018    Vijay		What:This ssp is for searchable Flags textbox
							Why:Engineering Improvement Initiatives- NBL(I) - Task#590
*********************************************************************************/         
BEGIN   
 BEGIN TRY  
   
  IF (@FlagType <> '' AND @FlagTypeId = -1 AND @ClientNoteId = -1)  
  BEGIN  
   SELECT FT.FlagTypeId,
    FT.FlagType,
    FT.FlagLinkTo,
    SA.[Action] AS ActionName,
    SA.ActionId,
    DC.DocumentName,
    DC.DocumentCodeId,
    FT.BitmapImage 
   FROM FlagTypes FT
   LEFT JOIN SystemActions SA ON SA.ActionId = FT.ActionId AND ISNULL(SA.RecordDeleted, 'N') = 'N'
   LEFT JOIN DocumentCodes DC ON DC.DocumentCodeId = FT.DocumentCodeId AND ISNULL(DC.RecordDeleted, 'N') = 'N'
   WHERE FlagType LIKE ('%' + @FlagType + '%') 
   AND FT.Active = 'Y'
   AND ISNULL(FT.RecordDeleted, 'N') = 'N'
   ORDER BY FT.FlagType  
  END 
  ELSE IF(@FlagType = '' AND @FlagTypeId <> -1 AND @ClientNoteId = -1)  
  BEGIN
   SELECT FT.FlagTypeId,
    FT.FlagType,
    FT.FlagLinkTo,
    SA.[Action] AS ActionName,
    SA.[ActionId] AS ActionId,
    DC.DocumentName,
    DC.DocumentCodeId,
    FT.BitmapImage,
    FT.PermissionedFlag,
	FT.DoNotDisplayFlag,
	FT.NeverPopup,
	FT.DefaultWorkGroup
   FROM FlagTypes FT
   LEFT JOIN SystemActions SA ON SA.ActionId = FT.ActionId AND ISNULL(SA.RecordDeleted, 'N') = 'N'
   LEFT JOIN DocumentCodes DC ON DC.DocumentCodeId = FT.DocumentCodeId AND ISNULL(DC.RecordDeleted, 'N') = 'N'
   WHERE FT.FlagTypeId =@FlagTypeId
   AND FT.Active = 'Y'
   AND ISNULL(FT.RecordDeleted, 'N') = 'N'
   ORDER BY FT.FlagType  
  END
  ELSE IF(@FlagType = '' AND @FlagTypeId <> -1 AND @ClientNoteId <> -1)  
  BEGIN
   SELECT CN.NoteType,
    FT.FlagType,
    CN.FlagLinkTo,
    SA.[Action] AS ActionName,
    SA.[ActionId] AS ActionId,
    DC.DocumentName,
    DC.DocumentCodeId,
    FT.BitmapImage,
    FT.PermissionedFlag,
	FT.DoNotDisplayFlag,
	FT.NeverPopup,
	CN.WorkGroup	
   FROM ClientNotes CN
   LEFT JOIN FlagTypes FT on FT.FlagTypeId = CN.NoteType --AND FT.Active = 'Y' AND ISNULL(FT.RecordDeleted, 'N') = 'N'
   LEFT JOIN SystemActions SA ON SA.ActionId = CN.ActionId AND ISNULL(SA.RecordDeleted, 'N') = 'N'
   LEFT JOIN DocumentCodes DC ON DC.DocumentCodeId = CN.DocumentCodeId AND ISNULL(DC.RecordDeleted, 'N') = 'N'
   WHERE CN.NoteType =@FlagTypeId
   AND (@ClientNoteId = -1 OR @ClientNoteId = CN.ClientNoteId)   
   AND ISNULL(CN.RecordDeleted, 'N') = 'N'
   ORDER BY FT.FlagType  
  END
  
	
--Checking For Errors            
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetFlagTypesByType')                                                                                                           
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


