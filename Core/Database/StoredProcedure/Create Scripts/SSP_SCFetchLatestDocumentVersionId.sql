
/****** Object:  StoredProcedure [dbo].[SSP_SCFetchLatestDocumentVersionId]    Script Date: 03/13/2017 15:16:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCFetchLatestDocumentVersionId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCFetchLatestDocumentVersionId]
GO


/****** Object:  StoredProcedure [dbo].[SSP_SCFetchLatestDocumentVersionId]    Script Date: 03/13/2017 15:16:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCFetchLatestDocumentVersionId]
(
	@documentId AS INT,
	@LoggedInUserId AS INT
)
As

Begin
/*********************************************************************/
/* Stored Procedure: dbo.SSP_SCFetchLatestDocumentVersionId            */

/* Copyright: 2006 Streamline SmartCare*/

/* Creation Date:  09/12/2009                                   */
/*                                                                   */
/* Purpose: Get Latest DocumentVersionId from Documents table */
/*                                                                   */
/* Input Parameters: DocumentID */
/*                                                                   */
/* Output Parameters:                      */
/*                                                                   */
/* Return:   latestDocumentVersionId  */
/*                                                                   */
/* Called By: GetLatestDocumentVersionId()     */
/*      */

/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/*   Updates:                                                          */

/*       Date              Author                  Purpose                                    */
/*  09/12/20097          Vikas Monga     To Get LatestDocumentVersionId                                */
/*  05Sept2011           Shifali		 Changes in ref to task# 11(To Be Reviewed Status)     */
/*  3/13/2017			 MD Hussain K	 Moved this SP logic to common function by Tom and added logic to fetch InProgressDocumentVersionId for second (or later) version of document w.r.t task #544 CEI - Support Go Live
										 Because after the pdf loaded, click the Edit button, the version loaded is the one signed by the original author not the In Progress version   */
/*********************************************************************/

	SELECT dbo.ssf_GetLatestDocumentVersionIdForLoggedInUser(@documentId, @LoggedInUserId) as CurrentDocumentVersionId

   --Checking For Errors
	IF (@@error!=0)
	BEGIN
		RAISERROR  ('SSP_SCFetchLatestDocumentVersionId : An Error Occured', 16, 1)
		RETURN
	END

END


GO


