/****** Object:  StoredProcedure [dbo].[ssp_RDLRequestAmendments]    Script Date: 06/09/2015 10:08:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLRequestAmendments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLRequestAmendments]
GO


/****** Object:  StoredProcedure [dbo].[ssp_RDLRequestAmendments]    Script Date: 06/09/2015 10:08:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLRequestAmendments]  
 (  
  @DocumentVersionId int     
 )  
AS 
/******************************************************************************                              
**  File:                               
**  Name: [ssp_RDLRequestAmendments]                              
**  Desc: This storeProcedure will return information for RDL                            
**                                            
**  Parameters:                              
**  Input  @DocumentVersionId           
                                
**  Output     ----------       -----------                              
**                          
                            
**  Auth:  Vithobha                        
**  Date:  27 Oct 2014                            
*******************************************************************************                              
**  Change History                              
*******************************************************************************                              
**  Date:  Author:    Description:                              
**  --------  --------    -------------------------------------------                              
**	 6-Nov - 2014	Ponnin		What :Added Date/Time of Request and Date/Time of Decision. Why : For task #65 of  Client Amendment Request                    
*******************************************************************************/     
BEGIN
	BEGIN TRY

	 	SELECT cardd.ClientAmendmentRequestDetailDocumentId
		,cardd.CreatedBy
		,cardd.CreatedDate
		,cardd.ModifiedBy
		,cardd.ModifiedDate
		,cardd.RecordDeleted
		,cardd.DeletedBy
		,cardd.DeletedDate
		,cardd.DocumentVersionId
		,cardd.AmendedDocumentVersionId
		,cardd.AmendmentRequested
		,cardd.AcceptedOrDenied
		,cardd.ReasonForDenial
		,dc.DocumentName
		,(ISNULL(s.LastName + ', ', '') + s.FirstName) StaffName
		,CONVERT(VARCHAR, d.EffectiveDate, 101) EffectiveDate
		,CONVERT(VARCHAR(10),CARDD.DateOfRequest,101) + ' ' + substring(convert(varchar(20),CARDD.DateOfRequest, 9), 13, 5)  + ' ' + substring(convert(varchar(30), CARDD.DateOfRequest, 9), 25, 2) as DateTimeOfRequest
		,CONVERT(VARCHAR(10),CARDD.DateOfDecision,101) + ' ' + substring(convert(varchar(20),CARDD.DateOfDecision, 9), 13, 5)  + ' ' + substring(convert(varchar(30), CARDD.DateOfDecision, 9), 25, 2) as DateTimeOfDecision
		
	FROM ClientAmendmentRequestDetailDocuments cardd
	INNER JOIN DocumentVersions dv ON dv.DocumentVersionId = cardd.AmendedDocumentVersionId
		AND ISNULL(dv.RecordDeleted, 'N') = 'N'
	INNER JOIN Documents d ON d.DocumentId = dv.DocumentId
		AND ISNULL(d.RecordDeleted, 'N') = 'N'
	INNER JOIN Staff s ON s.StaffId = d.AuthorId
	INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
	WHERE cardd.DocumentVersionId = @DocumentVersionId
		AND ISNULL(cardd.RecordDeleted, 'N') = 'N'
	 
	 
	END TRY
  BEGIN CATCH        
  DECLARE @Error varchar(8000)                                                       
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLRequestAmendments')                                                                                     
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


