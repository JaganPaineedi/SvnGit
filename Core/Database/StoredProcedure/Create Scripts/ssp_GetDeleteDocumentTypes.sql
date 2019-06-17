/****** Object:  StoredProcedure [dbo].[ssp_GetDeleteDocumentTypes]    Script Date: 10/21/2016 12:29:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDeleteDocumentTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetDeleteDocumentTypes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetDeleteDocumentTypes]    Script Date: 10/21/2016 12:29:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_GetDeleteDocumentTypes]
 
/**********************************************************************  
Report Request:  
 Displays a list of documents that meet the criteria of the  
 parameters, which at that point the user can pick and choose  
 which ones to delete.  
  
Parameters:  

Modified By  Modified Date Reason  
msood/mkhusro	10/21/2016 missing in SVN
  
**********************************************************************/ 	
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT dc.DocumentCodeId,dc.DocumentName
FROM DocumentCodes dc
WHERE ISNULL(dc.RecordDeleted,'N') = 'N'
      AND dc.Active = 'Y'
      and dc.DocumentType not in ( 15, 17 )
      and dc.DocumentCodeId not in ( 1 ) 
order by dc.DocumentName
      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED




GO


