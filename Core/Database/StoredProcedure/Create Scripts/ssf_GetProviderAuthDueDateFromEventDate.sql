IF EXISTS 
(
	SELECT	*
	FROM	sys.objects
	WHERE	object_id = OBJECT_ID(N'[dbo].[ssf_GetProviderAuthDueDateFromEventDate]')
		AND	type IN (N'FN', N'IF', N'TF', N'FS', N'FT')
)
	DROP FUNCTION [dbo].[ssf_GetProviderAuthDueDateFromEventDate]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ssf_GetProviderAuthDueDateFromEventDate]
(
	@ProviderAuthorizationId INTEGER
)
/***********************************************************************************************************************
	Function Name:	ssf_GetProviderAuthDueDateFromEventDate
	Author:			Ting-Yu Mu
	Created Date:	11/21/2017
	Parameter:		@ProviderAuthorizationId
	Returns:		Authorization Due Date

	Definitions:
		The review event which associates with the Authorization is automatically created after signing a Auth Request
		event or when SWMBH manually creates review. 
		Concurrent: (Request for additional authorizations for a service they currently have authorizations for)
			# Due date is 14 days from when Event created date.  Unless it is a code for Detox, Residential, IP, Crisis 
			  Residential, and then it will be 3 days- which you (Jake) will have a way to add modify codes this will 
			  apply to if I recall correctly
		Retrospective: (Requested dates are prior to the authorization request being entered)
			# Due date is 30 days from the Event created
		Prospective: (Requested dates are in the future from the date the authorization request is entered)
			# Due date is 14 days from the Event created
========================================================================================================================
	Modification Log
========================================================================================================================
	Date			Author			Purpose
	--------------	--------------	----------------------------------------------------------------
	11/21/2017		Ting-Yu Mu		Created. Why: SWMBH - Support # 1326
	03/16/2018		Ting-Yu Mu		What: Made this function from custom csf to ssf as the core function since it is 
									referenced by the core stored procedure "ssp_ListPageCMAuthorizations"
									Why: SWMBH - Support # 1326
	03/19/2018		Ting-Yu Mu		What: Modified the DROP statement from DROP PROCEDURE to DROP FUNCTION since this 
									is the function
									Why: Cannot use DROP PROCEDURE with 'dbo.ssf_GetProviderAuthDueDateFromEventDate' 
									because 'dbo.ssf_GetProviderAuthDueDateFromEventDate' is a function. 
									Use DROP FUNCTION

	07/19/2018		Neethu		   What: Modified logic to calculate Authorization Due Date  3 Days from the Authorization Request instead of 14 days.
                                   Why: SWMBH support 1326 .For concurrent review level, Authorization Due Date calculating  14 Days from the Authorization Request. 
***********************************************************************************************************************/
RETURNS DATE
BEGIN
	DECLARE	@AuthDueDate DATE
	DECLARE @CreatedDate DATETIME
    DECLARE @ReviewLevel INTEGER
    DECLARE @FromDate DATETIME
    DECLARE @ToDate DATETIME
	DECLARE @EventCreatedDate DATETIME
	DECLARE @SentAuth CHAR(1) = 'N'
    DECLARE @BillingCodeId INTEGER

	DECLARE @RvwLevelRetrospective INTEGER = 8726
    DECLARE @RvwLevelProspective INTEGER = 8727
    DECLARE @RvwLevelConcurrent INTEGER = 8728
    DECLARE @RvwLevelConcurrentUrgent INTEGER = -1337
    DECLARE @RvwLevelLCM INTEGER = 8738

	DECLARE @UrgentConcurrentBillingCode INTEGER = -1
	SELECT	@UrgentConcurrentBillingCode = GlobalCodeId
    FROM	dbo.GlobalCodes
    WHERE	Category = 'BILLINGCODECATEGORY1'
		AND CodeName = 'Urgent Concurrent Review'

	SELECT	@CreatedDate = PA.CreatedDate,
			@ReviewLevel = PA.ReviewLevel,
			@FromDate = PA.StartDate,
			@ToDate = PA.EndDate,
			@BillingCodeId = PA.BillingCodeId
	FROM	dbo.ProviderAuthorizations PA
	WHERE	PA.ProviderAuthorizationId = @ProviderAuthorizationId

	-- #########################################################################
    -- 2.	NOTE: Even if the Billing Code on the Auth Request has a Code 
    -- Category = Urgent Concurrent Review, the Auth Due Date for 
    -- Retrospective Review types should always be 30 days  --Design doc v 3
    -- #########################################################################
	SELECT	@ReviewLevel = @RvwLevelConcurrentUrgent
    FROM	BillingCodes BC
    WHERE	BC.BillingCodeId = @BillingCodeId
		AND BC.Category1 = @UrgentConcurrentBillingCode
		AND @ReviewLevel <> @RvwLevelRetrospective

	SELECT	@EventCreatedDate = E.CreatedDate
	FROM	dbo.Events E
	JOIN	dbo.ProviderAuthorizationDocuments AD ON E.EventId = AD.EventId
		AND ISNULL(AD.RecordDeleted, 'N') = 'N'
	JOIN	dbo.ProviderAuthorizations PA ON AD.ProviderAuthorizationDocumentId = PA.ProviderAuthorizationDocumentId
		AND ISNULL(PA.RecordDeleted, 'N') = 'N'
	WHERE	PA.ProviderAuthorizationId = @ProviderAuthorizationId
		AND ISNULL(E.RecordDeleted, 'N') = 'N'

	-- #########################################################################
	-- Calculates the authoriaztion due date based on the review level
	-- #########################################################################
	SELECT	@AuthDueDate =
		CASE WHEN @ReviewLevel = @RvwLevelRetrospective THEN DATEADD(DAY, 30, @EventCreatedDate)
			 WHEN @ReviewLevel = @RvwLevelProspective THEN DATEADD(DAY, 14, @EventCreatedDate)
             WHEN @ReviewLevel = @RvwLevelConcurrent THEN DATEADD(DAY, 3, @EventCreatedDate)
             WHEN @ReviewLevel = @RvwLevelConcurrentUrgent THEN DATEADD(DAY, 3, @EventCreatedDate)
             ELSE NULL
		END

	-- #########################################################################
	-- Returns calculated DATE
	-- #########################################################################
	RETURN @AuthDueDate
END
GO