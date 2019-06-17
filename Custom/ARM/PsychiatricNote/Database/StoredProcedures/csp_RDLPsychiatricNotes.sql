/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMedicalNotes]    Script Date: 06/30/2014 18:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLPsychiatricNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLPsychiatricNotes]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLPsychiatricNotes]    Script Date: 07/24/2015 18:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLPsychiatricNotes] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLPsychiatricNotes]   */
/*       Date              Author                  Purpose                   */
/*      07-24-2015        Vijay Yadav              To Retrieve Data  for RDL   */
/*********************************************************************/
BEGIN
	BEGIN TRY
	
  DECLARE @OrganizationName VARCHAR(250)
  SELECT TOP 1 @OrganizationName = OrganizationName FROM SystemConfigurations
	
	
		 SELECT  Distinct   
  C.ClientId   
  ,C.LastName + ', ' + C.FirstName as ClientName  
  ,CONVERT(VARCHAR(10), Dv.EffectiveDate, 101)  as EffectiveDate       
  ,CONVERT(VARCHAR(10), C.DOB, 101) as DOB      
  ,@DocumentVersionId as DocumentVersionId  
  ,P.ProgramName  
  ,DC.DocumentName  
  , (Datediff(yy, C.DOB, GetDate())) as ClientAge 
  ,@OrganizationName AS OrganizationName  
  ,CD.AdultChildAdolescent as AdultChildAdolescent
  FROM CustomDocumentPsychiatricNoteGenerals CD   
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
		
	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLPsychiatricNotes') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

GO


