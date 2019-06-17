IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCDocumentPreventNewVersion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCDocumentPreventNewVersion]
GO


/****** Object:  StoredProcedure [dbo].[scsp_SCDocumentPreventNewVersion]    Script Date: 12/13/2016 4:32:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_SCDocumentPreventNewVersion] --  811902,92,825237,21              
	(
	@varDocumnetId INT
	,@varAuthorId INT
	,--Current User            
	@varVersiondId INT
	,@varStatus INT OUT
	)
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_DocumentPrventFromNewVersion            */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    12/12/05                                        */
/*                                                                   */
/* Purpose: this is used to prevent the user from creating a new version of old format documents*/
/*                                                                   */
/* Input Parameters: @varDocumnetId ,@varAuthorId  ,@varVersiondId   */
/*                                                                   */
/* Output Parameters:   None										 */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/* Date     Author       Purpose                                   */
/* 12/12/05   Vikas    Created                                      */
/* 8/02/07   AVOSS Modified for Tx and PR rules					 */
/* 3/21/2008 SFERENZ Added check on CustomDocumentPreventNewVersionExceptions table */
/* 02/25/2010 Vikas Monga Change column name CurrentVersion with CurrentDocumentVersionId for document table.Add @varStatus as out put parameter*/
/* Shifali  Modified - Replaced CurrentDocumentVersionId with InProgressDocumentVersionId*/
/* 31 Jan 2012 Karan	 Mdified  - Added Exists in case of AllowEditByNonAuthors = 'Y'	*/
/* 28 May 2012 Shifali	 Mdified  - Added Condition for DocumentCodeId 10510*/
/* 03 Sep 2012 Vikas KAshyap Mdified  - Made Changes w.r.t. Task#1885 Threshold Buges*/
/* 11/11/2015 T.Remisoski removed all rules. */
/* 12/13/2016	M Jensen Prevent new versions of old informed consent */
/*********************************************************************/
BEGIN
	IF EXISTS (
			SELECT 1
			FROM Documents
			WHERE documentId = @varDocumnetId
				AND DocumentCodeId = 10037
			)
	BEGIN
		SET @varStatus = 0
	END
	ELSE
	BEGIN
		SET @varStatus = 1
	END
END
GO

