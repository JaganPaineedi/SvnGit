IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPsychiatricServiceNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceNotes]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLCustomPsychiatricServiceNotes] 
(@DocumentVersionId INT=0)
/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 02-Jan-2015     Revathi      What:Get Psychiatric Service Notes Client Informations
                             Why:task #823 Woods-Customizations
************************************************/
  AS 
 BEGIN
				
	Begin Try 				
	 SELECT  Distinct   
  C.ClientId   
  ,C.LastName + ', ' + C.FirstName as ClientName  
  ,CONVERT(VARCHAR(10), Dv.EffectiveDate, 101)  as EffectiveDate       
  ,CONVERT(VARCHAR(10), C.DOB, 101) as DOB      
  ,@DocumentVersionId as DocumentVersionId  
  ,P.ProgramName  
  --,SC.OrganizationName  
  ,DC.DocumentName  
  ,ISNULL(St.LastName,'') +coalesce(' , ' + St.firstname, '')  as PrimaryEpisodeWorker  
  , (Datediff(yy, C.DOB, GetDate())) as ClientAge  
  FROM CustomDocumentPsychiatricServiceNoteGenerals CD   
  Inner Join Documents Dv On Dv.CurrentDocumentVersionId = CD.DocumentVersionId   
  Inner Join Clients C on C.ClientId = Dv.ClientId  
  INNER JOIN Services S ON S.ServiceId=DV.ServiceId  
  INNER JOIN Programs P ON P.ProgramId=S.ProgramId  
  Inner join DocumentCodes DC ON DC.DocumentCodeid= Dv.DocumentCodeId    
  LEFT JOIN Staff st ON st.StaffId=C.PrimaryClinicianId  
  WHERE       
  ISNULL(CD.RecordDeleted,'N')='N'  
  AND ISNULL(Dv.RecordDeleted,'N')='N'  
  AND ISNULL(C.RecordDeleted,'N')='N'    
  AND CD.DocumentVersionId = @DocumentVersionId  
	End Try
 
  BEGIN CATCH          
   DECLARE @Error varchar(8000)                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomPsychiatricServiceNotes')                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                
   + '*****' + Convert(varchar,ERROR_STATE())                                           
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );             
 END CATCH          
END