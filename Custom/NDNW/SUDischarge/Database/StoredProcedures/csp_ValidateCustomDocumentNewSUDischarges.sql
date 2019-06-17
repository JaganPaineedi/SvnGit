/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentNewSUDischarges]    Script Date: 03/09/2015 15:57:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentNewSUDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentNewSUDischarges]
GO

/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentNewSUDischarges]    Script Date: 03/09/2015 15:57:20 ******/
-- 23-March-2015 SuryaBalan Copied from Valley New Directions for Task #8 New Directions-Customization
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentNewSUDischarges]  
/*********************************************************************/
/* Stored Procedure: [csp_ValidateCustomDocumentNewSUDischarges]   */
/*       Date              Author                  Purpose                   */
/*       01/FEB/2015      SuryaBalan               To Retrieve Data           */
--23-March-2015 SuryaBalan Copied from valley to New Directions Customization Task 4
--24-March-2015 SuryaBalan UnCommented Warning Error which is needed for Signing
/*********************************************************************/
 @StaffId int,  
 @ClientId int,  
 @DocumentCodeId int  
AS  
BEGIN  
	--DECLARE @ClientId INT = 28
    DECLARE @SUAdmissionCount INT = 0
    DECLARE @SUDischargeCount INT = 0
    
    SELECT @SUDischargeCount = COUNT(CurrentDocumentVersionId)
	FROM CustomDocumentSUDischarges CDCD
	INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 21
		AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
		
	IF @SUDischargeCount > 0
	BEGIN
		SELECT DISTINCT 'A SU Discharge document is currently already in progress for this member. Only one SU Discharge document may be in progress for a member at a time.' AS ValidationMessage
			,'E' AS WarningOrError
	END
	ELSE
	BEGIN    
		SELECT @SUAdmissionCount = COUNT(CurrentDocumentVersionId)
		FROM CustomDocumentSUAdmissions CDCD
		INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId
		WHERE Doc.ClientId = @ClientID
			AND Doc.[Status] = 22
			AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'	
			
		SELECT @SUDischargeCount = COUNT(CurrentDocumentVersionId)
		FROM CustomDocumentSUDischarges CDCD
		INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId
		WHERE Doc.ClientId = @ClientID
			AND Doc.[Status] = 22
			AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
			
		
			
		IF @SUDischargeCount >= @SUAdmissionCount OR @SUAdmissionCount = 0
		BEGIN
			SELECT 'Please complete a SU Admission document before proceeding with a SU Discharge document.' AS ValidationMessage
				,'E' AS WarningOrError  
		END
	END
  
END  
GO


