/****** Object:  StoredProcedure [dbo].[csp_scRemoveInquiryClient]    Script Date: 08/16/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_scRemoveInquiryClient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_scRemoveInquiryClient]
GO

CREATE Procedure [dbo].[csp_scRemoveInquiryClient]
	@ScreenKeyId INT,
	@StaffId INT,
	@CurrentUser VARCHAR(30)
/******************************************************************************
**  File: 
**  Name: csp_scRemoveInquiryClient
**  Desc: Delete the inquiry documents and events, if user remove client form the inquiry page.
**  
**  Parameters:
**  Input
	@ScreenKeyId INT,
	@StaffId INT,
	@CurrentUser VARCHAR(30)
**  Output     ----------       ----------- 
** 
**  Auth:  Pralyankar Kumar Singh
**  Date:  Jan 6, 2012
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:		Author:		Description:
**  --------	--------    ------------------------------------------- 
** 3/21/2012	Pralyankar	Commented Code for Removing CareManagementId and Inquiry EventId
/*19 Aug 2013 katta sharath kumar Pull this sp from Newaygo database from 3.5xMerged with task #3 in Ionia County CMH - Customizations*/    
*******************************************************************************/

AS
	BEGIN

		DECLARE @InquiryEventId INT, @CareManagementId INT

		SELECT @InquiryEventId = InquiryEventId , @CareManagementId = CareManagementId
		FROM CustomInquiries CI LEFT OUTER JOIN Clients C ON C.ClientId = CI.CLientID
		WHERE CI.InquiryId = @ScreenKeyId
	
		/*  >>--------> Get PCM Master DB Name <--------<< */
		DECLARE  @DBName VARCHAR(50) 
		SET @DBName = [dbo].[fn_GetPCMMasterDBName]()
		-- >>>>>>>------------------------------------------------------->

		---- Execute dynamic query in PCM Master Database ----
		DECLARE @DynamicQuery VARCHAR(MAX)
		SET @DynamicQuery = '[' + @DBName + '].[dbo].csp_scRemoveInquiryEvents ''' + @CurrentUser + ''',' 
					+ cast(isnull(@CareManagementId,0) as varchar(10)) + ',' 
					+ cast(isnull(@InquiryEventId,0) as varchar(10)) + ''
		EXEC(@DynamicQuery)
		------------------------------------------------------

		--UPDATE CustomInquiries
		--SET InquiryEventId = NULL 
		--WHERE InquiryId = @ScreenKeyId

		--Update Clients
		--SET CareManagementId = NULL
		--WHERE CareManagementId = @CareManagementId  
	END
GO


