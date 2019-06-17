IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateClientOrderDetails]')
                  AND type IN (N'P', N'PC'))
    DROP PROCEDURE [dbo].[ssp_PostUpdateClientOrderDetails];


GO
SET ANSI_NULLS ON;


GO
SET QUOTED_IDENTIFIER ON;


GO
CREATE PROCEDURE [dbo].[ssp_PostUpdateClientOrderDetails] --659,550,'ADMIN',NULL
@ScreenKeyId INT,
@StaffId INT,
@CurrentUser VARCHAR (30),
@CustomParameters XML
AS
/**********************************************************************/
/* Stored Procedure:  ssp_PostUpdateClientOrderDetails  */
/* Creation Date:  13/Dec/2016                                    */
/* Purpose: To write Post update logic for client Order detail page save            */
/* Input Parameters:   @CurrentUserId ,@ScreenKeyId  ,@StaffId ,@CustomParameters      */
/* Output Parameters:                 */
--exec [ssp_PostUpdateClientOrderDetails] --659,550,'ADMIN',NULL
/* Return:                 */
/* Called By:      */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/* Updates:                                                          */
/* Date				Author          Purpose           */
/* Jan 02 2016		Chethan N		What : Discontinuing Child Orders when parent order is discontinued.
									Why : Woods - Customizations task #841.02	
   Aug 28 2018		Chethan N		What : Send message to 'Assigned to' staff when 'Assigned to' and 'Assigned to Comments' are specified.
									Why : Engineering Improvement Initiatives- NBL(I) task #551									*/								
/*********************************************************************/
BEGIN
    BEGIN TRY
		
		DECLARE @ClientOrderStatus INT
		DECLARE @OrderType INT
		DECLARE @ReferenceType INT
		DECLARE @FromStaff INT
		
		SELECT @ReferenceType = GlobalCodeId 
		FROM GlobalCodes
		WHERE Code = 'LabResults'
		AND Category = 'MESSAGEREFFERNCETYPY'
		
		SELECT @FromStaff = StaffId
		FROM Staff
		WHERE UserCode = @CurrentUser

		SELECT @ClientOrderStatus = CO.OrderStatus, @OrderType = O.OrderType
		FROM Clientorders CO
		JOIN Orders O ON O.OrderId = CO.OrderId
		WHERE CO.ClientOrderId = @ScreenKeyId

		IF (@ClientOrderStatus = 6504 AND @OrderType = 6481) -- 6504 -- Results Obtained
		BEGIN
			EXEC ssp_CreateFlowSheetFromClientorders @ScreenKeyId
		END

		IF (@ClientOrderStatus = 6510 AND @OrderType = 6481) -- 6510 -- Discontinued
		BEGIN
		----- Update OrderDiscontinued and DiscontinuedDateTime when order status is discontinued
			UPDATE CO
			SET Active = 'N'
				,OrderDiscontinued = 'Y'
				,DiscontinuedDateTime = GETDATE()
				,ModifiedBy = @CurrentUser
				,ModifiedDate = GETDATE()
			FROM ClientOrders CO
			WHERE CO.ClientOrderId = @ScreenKeyId AND ISNULL(CO.OrderDiscontinued, 'N') = 'N'

			UPDATE CO
			SET Active = 'N'
				,OrderDiscontinued = 'Y'
				,OrderStatus = 6510
				,DiscontinuedDateTime = GETDATE()
				,ModifiedBy = @CurrentUser
				,ModifiedDate = GETDATE()
			FROM ClientOrders CO
			WHERE CO.ParentClientOrderId = @ScreenKeyId AND ISNULL(CO.OrderDiscontinued, 'N') = 'N'
		END

		IF (@ClientOrderStatus <> 6510 AND @OrderType = 6481)
		BEGIN
		UPDATE CO
			SET Active = 'Y'
				,OrderDiscontinued = 'N'
				,DiscontinuedDateTime = NULL
				,ModifiedBy = @CurrentUser
				,ModifiedDate = GETDATE()
			FROM ClientOrders CO
			WHERE CO.ClientOrderId = @ScreenKeyId AND ISNULL(CO.OrderDiscontinued, 'N') = 'Y'
		END
		
		--- Inserting into Messages
		INSERT INTO Messages(CreatedBy, ModifiedBy, FromStaffId, ToStaffId, ClientId, Unread, DateReceived, [Subject], [Message], Priority, ReferenceType, ReferenceId, Reference, SenderCopy, ReceiverCopy, PartofClientRecord)
		SELECT @CurrentUser, @CurrentUser, @FromStaff, NULL, CO.ClientId, 'Y', GETDATE(),  O.OrderName, CO.AssignedToComments, 61,  @ReferenceType, CO.ClientOrderId, 'Lab Results', 'Y', NULL, 'N'
		FROM ClientOrders CO 
		JOIN Orders O ON O.OrderId = CO.OrderId
		WHERE CO.ClientOrderId = @ScreenKeyId
		AND ISNULL(CO.ReviewInterpretationType, 'N') <> 'N'
		AND CO.AssignedTo IS NOT NULL
		AND ISNULL(CO.AssignedToComments, '') <> ''
		AND @ReferenceType IS NOT NULL
		AND NOT EXISTS(SELECT 1 FROM Messages M WHERE ReferenceType = @ReferenceType AND M.ReferenceId = CO.ClientOrderId AND ISNULL(M.SenderCopy, 'N')  = 'Y')
		UNION
		SELECT @CurrentUser, @CurrentUser, @FromStaff, CO.AssignedTo, CO.ClientId, 'Y', GETDATE(),  O.OrderName, CO.AssignedToComments, 61,  @ReferenceType, CO.ClientOrderId, 'Lab Results', NULL, 'Y', 'N'
		FROM ClientOrders CO 
		JOIN Orders O ON O.OrderId = CO.OrderId
		WHERE CO.ClientOrderId = @ScreenKeyId
		AND ISNULL(CO.ReviewInterpretationType, 'N') <> 'N'
		AND CO.AssignedTo IS NOT NULL
		AND ISNULL(CO.AssignedToComments, '') <> ''
		AND @ReferenceType IS NOT NULL
		AND NOT EXISTS(SELECT 1 FROM Messages M WHERE ReferenceType = @ReferenceType AND M.ReferenceId = CO.ClientOrderId AND ISNULL(M.ReceiverCopy, 'N')  = 'Y')
		
		INSERT INTO MessageRecepients (CreatedBy, ModifiedBy, MessageId, StaffId)
		SELECT M.CreatedBy, M.ModifiedBy, M.MessageId, M1.ToStaffId 
		FROM Messages M
		JOIN Messages M1 ON M1.FromStaffId = M.FromStaffId AND M1.ReferenceId = M.ReferenceId  AND M1.ReferenceType = @ReferenceType AND M1.ToStaffId IS NOT NULL
		WHERE M.ReferenceType = @ReferenceType AND M.ReferenceId = @ScreenKeyId AND ISNULL(M.SenderCopy, 'N')  = 'Y'
		AND NOT EXISTS(SELECT 1 FROM MessageRecepients MR WHERE MR.MessageId = M.MessageId)

    END TRY
    BEGIN CATCH
        DECLARE @Error AS VARCHAR (MAX);
        SET @Error = CONVERT (VARCHAR, ERROR_NUMBER()) + '*****' 
        + CONVERT (VARCHAR (4000), ERROR_MESSAGE()) + '*****' 
        + isnull(CONVERT (VARCHAR, ERROR_PROCEDURE()),
         'ssp_PostUpdateClientOrderDetails') + '*****' 
         + CONVERT (VARCHAR, ERROR_LINE()) + '*****' 
         + CONVERT (VARCHAR, ERROR_SEVERITY()) + '*****' 
         + CONVERT (VARCHAR, ERROR_STATE());
        RAISERROR (@Error, 16, 1); -- Message text.   Severity.  State.                                                                                
    END CATCH
END
GO