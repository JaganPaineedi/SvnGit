 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_FaxGetRdLCName]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE ssp_FaxGetRdLCName
GO


SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE [dbo].[ssp_FaxGetRdLCName](@DOCUMENTCODEID INT) 
as
/*========================================================================================================
-Stored Procedure: ssp_FaxServiceGetFaxRequests
-Creation Date:  07/10/2018
-Created By: Pranay Bodhu
-Purpose:
	Called by Fax-Server to Get the RDL names.
-Input Parameters:@DOCUMENTCODEID
-Output Parameters:None
-Return:
   Returns  RDL name.
-Called by:
	FaxSerive Client Windows Service
Log:
-Date                           Name                                      Purpose
	
========================================================================================================*/
BEGIN

	SELECT DocumentCodeId
     , ViewDocumentRDL
      FROM [DocumentCodes] where  DocumentCodeId=@DocumentCodeId   AND ISNULL(RecordDeleted,'N')='N'


 --Checking For Errors                                            
  If (@@error!=0)                                            
  Begin                                            
   RAISERROR  ('ssp_FaxGetRdLCName : An Error Occured',16,1)                                             
   Return                                            
   End                                                     
       
      

END
