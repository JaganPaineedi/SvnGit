/****** Object:  StoredProcedure [dbo].[csp_RDLPsychiatricServiceNote]    Script Date: 06/30/2014 18:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLPsychiatricServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLPsychiatricServiceNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLPsychiatricServiceNote]    Script Date: 06/30/2014 18:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLPsychiatricServiceNote] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLPsychiatricServiceNote]   */
/*       Date              Author                  Purpose                   */
/*      12-18-2014     Dhanil Manuel               To Retrieve Data  for RDL   */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ClientId int                                                                                                                                                                                               
		SELECT @ClientId = ClientId from Documents where                                                                          		InProgressDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,'N')= 'N'  
	
DECLARE @Cosigners varchar(max);
select @Cosigners ='' --DischargeNotifiedBy
FROM CustomDocumentDischarges CD
	  JOIN Documents D ON CD.DocumentVersionId = D.CurrentDocumentVersionId
		JOIN Clients C ON D.ClientId = C.ClientId
		JOIN DocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId
		WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(CD.RecordDeleted, 'N') = 'N'
		   	AND ISNull(C.RecordDeleted, 'N') = 'N'
			AND ISNull(D.RecordDeleted, 'N') = 'N'
	
	IF OBJECT_ID('tempdb..#CoSigners') IS NOT NULL       
 DROP TABLE #CoSigners    
 CREATE TABLE #CoSigners(
 StaffId varchar(50)  
 )  
			
	if(@Cosigners is not null)	
	begin		
		INSERT INTO #CoSigners(StaffId) 
SELECT  * FROM fnSplit(@Cosigners,'~') 
end

DECLARE @CosignerList VARCHAR(8000)
SELECT @CosignerList = COALESCE(@CosignerList + ',', '') + CAST(S.LastName + ', ' +S.FirstName  AS VARCHAR)
FROM #CoSigners cs 
JOIN Staff S ON S.StaffId = cs.StaffId 
WHERE ISNULL(S.RecordDeleted,'N')<>'Y' 


		SELECT DocumentVersionId
		
		FROM CustomDocumentPsychiatricServiceNoteGenerals CD
	  JOIN Documents D ON CD.DocumentVersionId = D.CurrentDocumentVersionId
		JOIN Clients C ON D.ClientId = C.ClientId
		JOIN DocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId
		
	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLPsychiatricServiceNote') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


