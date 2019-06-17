/****** Object:  StoredProcedure [dbo].[ssp_RDLRequestAmendmentsViewer]    Script Date: 06/09/2015 10:09:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLRequestAmendmentsViewer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLRequestAmendmentsViewer]
GO


/****** Object:  StoredProcedure [dbo].[ssp_RDLRequestAmendmentsViewer]    Script Date: 06/09/2015 10:09:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLRequestAmendmentsViewer]
 (  
  @DocumentCodeId int,
  @ClientId int
 )  
AS 
/******************************************************************************                              
**  File:                               
**  Name: [ssp_RDLRequestAmendmentsViewer]                              
**  Desc: This storeProcedure will return information for RDL                            
**                                            
**  Parameters:                              
**  Input  @DocumentVersionId           
                                
**  Output     ----------       -----------                              
**                          
                            
**  Auth:  Ponnin Selvan                        
**  Date:  27 Oct 2014                            
*******************************************************************************                              
**  Change History                              
*******************************************************************************                              
**  Date:			 Author:    Description:                              
**  --------  --------    -------------------------------------------                              
**   29-Oct-2014	Ponnin	   MeaningFul Use Task #65 - Client Amendment Request   
**   3-Nov - 2014	Ponnin	MeaningFul Use Task #65 -Added new Parameter ClientId to display records for the selected client. 
**	 6-Nov - 2014	Ponnin		What :Added Date/Time of Request and Date/Time of Decision. Why : For task #65 of  Client Amendment Request      
**	 7-Nov - 2014	Ponnin		Design format changed for Date/Time of Request and Date/Time of Decision.     Why : For task #65 of  Client Amendment Request
*******************************************************************************/     
BEGIN
	BEGIN TRY
	
	
	 Select 
		CARDD.ClientAmendmentRequestDetailDocumentId
		,CARDD.CreatedBy
		,CARDD.CreatedDate
		,CARDD.ModifiedBy
		,CARDD.ModifiedDate
		,CARDD.RecordDeleted
		,CARDD.DeletedBy
		,CARDD.DeletedDate
		,CARDD.DocumentVersionId
		,CARDD.AmendedDocumentVersionId
		,CARDD.AmendmentRequested
		,CARDD.AcceptedOrDenied
		,CARDD.ReasonForDenial
		,DC.DocumentName AS DocumentName
		,S.[FirstName] + ', ' + S.[LastName] As StaffName
		,C.[FirstName] + ', ' + C.LastName AS ClientName
		,C.ClientId 
		,CONVERT(VARCHAR(10),D.EffectiveDate,101) as EffectiveDate
		,CMRD.ReasonForRequest
		,CONVERT(VARCHAR(10),CARDD.DateOfRequest,101) + ' ' + substring(convert(varchar(20),CARDD.DateOfRequest, 9), 13, 5)  + ' ' + substring(convert(varchar(30), CARDD.DateOfRequest, 9), 25, 2) as DateTimeOfRequest
		,CONVERT(VARCHAR(10),CARDD.DateOfDecision,101) + ' ' + substring(convert(varchar(20),CARDD.DateOfDecision, 9), 13, 5)  + ' ' + substring(convert(varchar(30), CARDD.DateOfDecision, 9), 25, 2) as DateTimeOfDecision
		
	 from ClientAmendmentRequestDetailDocuments CARDD
	 join ClientAmendmentRequestDocuments CMRD on CARDD.DocumentVersionId = CMRD.DocumentVersionId
	 Join Documents D on CARDD.AmendedDocumentVersionId = d.InProgressDocumentVersionId 
	 join Clients C on C.ClientId = D.ClientId 
	 Join DocumentCodes DC on DC.DocumentCodeId= D.DocumentCodeId 
	 Join Staff S on S.StaffId=D.AuthorId 
	  where DC.DocumentCodeId=@DocumentCodeId and C.ClientId = @ClientId  and  isnull(C.RecordDeleted,'N')<>'Y' and isnull(CARDD.RecordDeleted,'N')<>'Y' and isnull(D.RecordDeleted,'N')<>'Y'
	 
	END TRY
  BEGIN CATCH        
  DECLARE @Error varchar(8000)                                                       
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLRequestAmendmentsViewer')                                                                                     
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


