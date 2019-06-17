IF EXISTS ( SELECT * FROM sys.procedures WHERE NAME = 'ssp_UpdateClientOrderResultsReview' )
	DROP PROCEDURE ssp_UpdateClientOrderResultsReview
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].ssp_UpdateClientOrderResultsReview ( @ClientId INT
, @ClientOrderIds VARCHAR(MAX) 
, @EffectiveDate DATETIME = NULL         
, @ReviewInterpretationType CHAR(1)
, @ReviewedComments VARCHAR(MAX)
, @StaffId INT
, @UserCode VARCHAR(50)
, @AssignedTo INT
, @ResultsReviewComment INT
, @AssignedToComments VARCHAR(MAX)
, @OrderStatus INT
, @ReviewedFlag CHAR(1)
, @NurseReviewedBy INT
)
/****************************************************************************************************/
/* Stored Procedure: [ssp_UpdateClientOrderResultsReview] 40725	, 0, NULL									*/
/* Creation Date: 12/05/2017 																	*/
/* Author: Chethan N  																			*/
/* Purpose: To get Client Order Results and Observations											*/
/* Data Modifications:																				*/
/* Date				Author          Purpose           */
/* Aug 28 2018		Chethan N		What : Send message to 'Assigned to' staff when 'Assigned to' and 'Assigned to Comments' are specified.
									Why : Engineering Improvement Initiatives- NBL(I) task #551
   Oct 16 2018		Chethan N		What: Updating OrderStatus, ReviewedFlag and NurseReviewedBy
									Why: CCC-Customizations task# 83								*/
/****************************************************************************************************/
AS
BEGIN
	BEGIN TRY
	
	DECLARE @ReferenceType INT
	DECLARE @FromStaff INT
	
	SELECT @ReferenceType = GlobalCodeId 
	FROM GlobalCodes
	WHERE Code = 'BatchLabResults'
	AND Category = 'MESSAGEREFFERNCETYPY'
		
	SELECT @FromStaff = StaffId
	FROM Staff
	WHERE UserCode = @UserCode
	
	UPDATE  CO
	SET CO.ReviewedFlag = @ReviewedFlag
		,CO.ReviewedBy = @StaffId
		,CO.ReviewedDateTime = GETDATE()
		,CO.OrderStatus = @OrderStatus
		,CO.ReviewInterpretationType = @ReviewInterpretationType
		,CO.ReviewedComments = @ReviewedComments
		,CO.ModifiedBy = @UserCode
		,CO.ModifiedDate = GETDATE()
		,CO.AssignedTo = @AssignedTo
		,CO.ResultsReviewComment = @ResultsReviewComment
		,CO.AssignedToComments = @AssignedToComments
		,CO.NurseReviewedBy =  @NurseReviewedBy
	FROM ClientOrders CO
	WHERE CO.ClientOrderId 	IN ( SELECT Token FROM [dbo].[SplitString] (@ClientOrderIds,',') )
	
	
	--- Inserting into Messages
	INSERT INTO Messages(CreatedBy, ModifiedBy, FromStaffId, ToStaffId, ClientId, Unread, DateReceived, [Subject], [Message], Priority, ReferenceType, ReferenceId, Reference, SenderCopy, ReceiverCopy, PartofClientRecord)
	SELECT @UserCode, @UserCode, @FromStaff, NULL, CO.ClientId, 'Y', GETDATE(),  O.OrderName, CO.AssignedToComments, 61,  @ReferenceType, CO.ClientOrderId, 'Batch Lab Results', 'Y', NULL, 'N'
	FROM ClientOrders CO 
	JOIN Orders O ON O.OrderId = CO.OrderId
	WHERE CO.ClientOrderId IN ( SELECT Token FROM [dbo].[SplitString] (@ClientOrderIds,',') )
	AND ISNULL(CO.ReviewInterpretationType, 'N') <> 'N'
	AND CO.AssignedTo IS NOT NULL
	AND ISNULL(CO.AssignedToComments, '') <> ''
	AND @ReferenceType IS NOT NULL
	AND NOT EXISTS(SELECT 1 FROM Messages M WHERE ReferenceType = @ReferenceType AND M.ReferenceId = CO.ClientOrderId AND ISNULL(M.SenderCopy, 'N')  = 'Y')
	UNION
	SELECT @UserCode, @UserCode, @FromStaff, CO.AssignedTo, CO.ClientId, 'Y', GETDATE(),  O.OrderName, CO.AssignedToComments, 61,  @ReferenceType, CO.ClientOrderId, 'Batch Lab Results', NULL, 'Y', 'N'
	FROM ClientOrders CO 
	JOIN Orders O ON O.OrderId = CO.OrderId
	WHERE CO.ClientOrderId IN ( SELECT Token FROM [dbo].[SplitString] (@ClientOrderIds,',') )
	AND ISNULL(CO.ReviewInterpretationType, 'N') <> 'N'
	AND CO.AssignedTo IS NOT NULL
	AND ISNULL(CO.AssignedToComments, '') <> ''
	AND @ReferenceType IS NOT NULL
	AND NOT EXISTS(SELECT 1 FROM Messages M WHERE ReferenceType = @ReferenceType AND M.ReferenceId = CO.ClientOrderId AND ISNULL(M.ReceiverCopy, 'N')  = 'Y')
	
	INSERT INTO MessageRecepients (CreatedBy, ModifiedBy, MessageId, StaffId)
	SELECT M.CreatedBy, M.ModifiedBy, M.MessageId, M1.ToStaffId 
	FROM Messages M
	JOIN Messages M1 ON M1.FromStaffId = M.FromStaffId AND M1.ReferenceId = M.ReferenceId  AND M1.ReferenceType = @ReferenceType AND M1.ToStaffId IS NOT NULL
	WHERE M.ReferenceType = @ReferenceType AND M.ReferenceId IN ( SELECT Token FROM [dbo].[SplitString] (@ClientOrderIds,',') ) AND ISNULL(M.SenderCopy, 'N')  = 'Y'
	AND NOT EXISTS(SELECT 1 FROM MessageRecepients MR WHERE MR.MessageId = M.MessageId)
	
	EXEC ssp_GETClientOrderObservations @ClientId=@ClientId, @EffectiveDate=@EffectiveDate
	
	END TRY

	BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_UpdateClientOrderResultsReview') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
	@Error
	,
	-- Message text.
	16
	,
	-- Severity.
	1
	-- State.
	);
	END CATCH
END
