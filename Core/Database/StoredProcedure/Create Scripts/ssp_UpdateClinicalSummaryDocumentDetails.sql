/****** Object:  StoredProcedure [dbo].[ssp_updateclinicalsummarydocumentdetails]    Script Date: 06/09/2015 04:11:24 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_updateclinicalsummarydocumentdetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_updateclinicalsummarydocumentdetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_updateclinicalsummarydocumentdetails]    Script Date: 06/09/2015 04:11:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************** 
**  File: ssp_RDLClinicalSummaryAllergies.sql 
**  Name: ssp_RDLClinicalSummaryAllergies 
**  Desc: 
** 
**  Return values:  
** 
**  Called by:  
** 
**  Parameters: 
**  Input   Output 
**  ServiceId      ----------- 
** 
**  Created By: Veena S Mani 
**  Date:  Feb 24 2014 
******************************************************************************* 
**  Change History 
******************************************************************************* 
**  Date:  Author:    Description: 
**  9/10/2014  Veena   Added column ServiceId to ClinicalSummaryDocuments   MU #50  **
**  12/07/2015 Shankha Modified to not create DocumentVersionView record from this procedure Barry - Support #278  **
**  19/07/2016 Chethan N What : Added parameter @Byte 
						 Why : Meaningful Use - Stage 3 task# 33**
**  --------  --------    ------------------------------------------- 
*******************************************************************************/
CREATE PROCEDURE [dbo].[ssp_updateclinicalsummarydocumentdetails] @StaffId INT
	,@CurrentUser VARCHAR(30)
	,@ReportType CHAR(1)
	,@ClientId INT
	,@ServiceId INT
	,@Byte IMAGE = NULL
	,@DocumentType VARCHAR(10)
	
AS
DECLARE @DocumentId INT
DECLARE @DocumentVersionId INT
DECLARE @DCTYPE INT

IF (@DocumentType = 'TC')
	SET @DCTYPE = 1611
ELSE
	SET @DCTYPE = 1610

IF (@StaffId = 0)
	SET @StaffId = NULL

IF (@ServiceId = 0)
	SET @ServiceId = NULL

INSERT INTO documents (
	createdby
	,createddate
	,modifiedby
	,modifieddate
	,clientid
	,serviceid
	,documentcodeid
	,effectivedate
	,STATUS
	,authorid
	,signedbyauthor
	,signedbyall
	,currentversionstatus
	)
VALUES (
	@CurrentUser
	,Getdate()
	,@CurrentUser
	,Getdate()
	,@ClientId
	,NULL
	,@DCTYPE
	,Getdate()
	,22
	,@StaffId
	,'Y'
	,'Y'
	,22
	)

SET @DocumentId = (
		SELECT @@Identity
		)

INSERT INTO documentversions (
	createdby
	,createddate
	,modifiedby
	,modifieddate
	,documentid
	,version
	,authorid
	,effectivedate
	)
VALUES (
	@CurrentUser
	,Getdate()
	,@CurrentUser
	,Getdate()
	,@DocumentId
	,1
	,@StaffId
	,Getdate()
	)

SET @DocumentVersionId = (
		SELECT @@Identity
		)

UPDATE documents
SET currentdocumentversionid = @DocumentVersionId
	,inprogressdocumentversionid = @DocumentVersionId
WHERE documentid = @DocumentId

-- Commented the following inser by Shankha on 7/12
/*
INSERT INTO documentversionviews (
	documentversionid
	,viewimage
	,rowidentifier
	,createdby
	,createddate
	,modifiedby
	,modifieddate
	)
VALUES (
	@DocumentVersionId
	,@Byte
	,Newid()
	,@CurrentUser
	,Getdate()
	,@CurrentUser
	,Getdate()
	)
*/
INSERT INTO ClinicalSummaryDocuments (
	documentversionid
	,reporttype
	,createdby
	,createddate
	,modifiedby
	,modifieddate
	,ServiceId
	)
VALUES (
	@DocumentVersionId
	,@ReportType
	,@CurrentUser
	,Getdate()
	,@CurrentUser
	,Getdate()
	,@ServiceId
	)
    
-- Added  by Shankha on 8/12
SELECT @DocumentVersionId

GO


