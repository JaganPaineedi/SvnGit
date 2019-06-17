/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateClientOrdersReleaseAndAcknowledge]    Script Date: 07/31/2013 12:09:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateClientOrdersReleaseAndAcknowledge]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCUpdateClientOrdersReleaseAndAcknowledge]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateClientOrdersReleaseAndAcknowledge]    Script Date: 07/31/2013 12:09:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCUpdateClientOrdersReleaseAndAcknowledge] 
@ClientOrderId VARCHAR(max), 
@Action        VARCHAR(30), 
@StaffId       INT 
AS 
/*********************************************************************/ 
/* Stored Procedure: [ssp_SCUpdateClientOrdersReleaseAndAcknowledge]            */ 
/* Creation Date:  22/July/2013													*/ 
/* Purpose: To Get ClientOrders To Release											*/ 
/* Output Parameters:																 */ 
/* Called By:																		*/ 
/* Data Modifications:																*/ 
/* Updates:																			*/ 
/*  Date			Author		Purpose												*/ 
/*  22/July/2013	Vithobha	Created												*/ 
/*  01/Aug/2013      Gautam     Modified to include temp tables in place of looping   */
/*  Feb/02/2016		PradeepA	Included Labsoft logic to send Order message on release*/
  /********************************************************************/ 
  BEGIN 
      BEGIN try 
			DECLARE @LabSoftEnabled CHAR(1)
			DECLARE @DocumentVersionId AS INT;
			DECLARE @CurrentUser type_CurrentUser
			SELECT @LabSoftEnabled = dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTENABLED')
			SELECT @CurrentUser = UserCode FROM Staff Where StaffId = @StaffId
			
			Create table #ClientOrder
			(
				ClientOrderId int,
			)
			Insert into #ClientOrder(ClientOrderId)
			SELECT ids FROM dbo.SplitIntegerString(@ClientOrderId, ',')  
			
			Create table #OrderAcknwRoles
			(
				ClientOrderId int,
				OrderAcknRoleCount int,
			)
			
			Create table #ClientOrderAcknwRoles
			(
				ClientOrderId int,
				ClientOrderAcknRoleCount int
			)                                 
          --Update the Client Orders  For OrderPended             
          IF( @Action = 'Release' ) 
            BEGIN 
                UPDATE ClientOrders 
                SET    OrderPended = 'N', 
                       ReleasedOn = Getdate(), 
                       ReleasedBy = @StaffId 
                where ClientOrderId IN (SELECT ClientOrderId FROM #ClientOrder) 
                
                IF ISNULL(@LabSoftEnabled, 'N') = 'Y'
				BEGIN
					DECLARE OrderDocumentsforRelease CURSOR LOCAL FAST_FORWARD
					FOR
					SELECT DISTINCT DocumentVersionId
					FROM ClientOrders
					WHERE ClientOrderId IN (
							SELECT ClientOrderId
							FROM #ClientOrder
							)

					OPEN OrderDocumentsforRelease

					WHILE 1 = 1
					BEGIN
						FETCH OrderDocumentsforRelease
						INTO @DocumentVersionId

						IF @@fetch_status <> 0
							BREAK

						EXECUTE SSP_SCCreateOrderMessageForLabSoft @DocumentVersionId
							,@CurrentUser;
					END

					CLOSE OrderDocumentsforRelease

					DEALLOCATE OrderDocumentsforRelease
				END
            END 

          --Update the Client Orders  For OrderPendRequiredRoleAcknowledge AND Insert a Row in ClientOrderAcknowledgments            
          IF( @Action = 'Acknowledge' ) 
			BEGIN 
				--For each client order
				--Update the clientorders.ORDERPENDACKNOWLEDGE = 'N' when clientorders.ORDERPENDACKNOWLEDGE = 'Y'
				UPDATE ClientOrders 
				SET    OrderPendAcknowledge = 'N' 
				WHERE  ClientOrderId IN (SELECT ClientOrderId FROM #ClientOrder) 
					   And OrderPendAcknowledge ='Y'
					   
				-- Insert a record into the clientorderacknowledgments, for the staff for each of the assigned role(s) 
				--when Clientorderacknowledgments has no rows for the clientorderid and the current staff	   
               Insert Into ClientOrderAcknowledgments 
					 (ClientOrderId, 
                       RoleId, 
                       StaffId, 
                       OrderPendRequiredRoleAcknowledge, 
                       AcknowledgeBy, 
                       AcknowledgeOn)         
			   SELECT CO.ClientOrderId,OA.RoleId,@StaffId,'N',@StaffId,Getdate() 
			   FROM   OrderAcknowledgments OA 
					  INNER JOIN StaffRoles SR ON SR.RoleId = OA.RoleId 
								AND Isnull(OA.RecordDeleted, 'N') = 'N'  
								AND Isnull(SR.RecordDeleted, 'N') = 'N' 
					  INNER JOIN ClientOrders CLO ON CLO.OrderId=OA.OrderId
								AND Isnull(CLO.RecordDeleted, 'N') = 'N' 
					  INNER JOIN #ClientOrder CO ON CO.ClientOrderId =CLO.ClientOrderId
			   WHERE  SR.StaffId = @StaffId 
					  AND Isnull(OA.NeedsToAcknowledge, 'Y') = 'Y'   
					  AND Not exists(Select * from ClientOrderAcknowledgments where ClientOrderId=CO.ClientOrderId
										and RoleId=OA.RoleId)
               
               -- Get Order Acknowledge role
               	Insert into #OrderAcknwRoles
				select CO.ClientOrderId,count(OA.RoleId)
               	From #ClientOrder CO 
               			Inner join ClientOrders CLO On CO.ClientOrderId =CLO.ClientOrderId
               						AND Isnull(CLO.RecordDeleted, 'N') = 'N'
               			Inner join OrderAcknowledgments OA on OA.OrderId=CLO.OrderId
               						AND Isnull(OA.RecordDeleted, 'N') = 'N' AND Isnull(OA.NeedsToAcknowledge, 'Y') = 'Y'
               	Group by  CO.ClientOrderId
               	
               	-- Get Client Order Acknowledge role
               Insert into #ClientOrderAcknwRoles
				select CO.ClientOrderId,count(COA.RoleId)
               	From #ClientOrder CO 
               			Inner join ClientOrders CLO On CO.ClientOrderId =CLO.ClientOrderId
               						AND Isnull(CLO.RecordDeleted, 'N') = 'N'
               			Inner join ClientOrderAcknowledgments COA on COA.ClientOrderId=CLO.ClientOrderId
               						AND Isnull(COA.RecordDeleted, 'N') = 'N' AND Isnull(COA.OrderPendRequiredRoleAcknowledge, 'N') = 'N'
               	Group by  CO.ClientOrderId
               	--Check if clientorders.ORDERPENDREQUIREDROLEACKNOWLEDGE = 'Y'
				--then Compare  OrderAcknowledgments.Roleid (1.2) = clientorderacknowledgments.roleid(1.2.3) with  for the client order
				-- if these match then 
				--update the clientorders.orderpendrequiredroleacknowledge = 'N'
               	
               	Update CO
               	set CO.OrderPendRequiredRoleAcknowledge = 'N'
               	From ClientOrders CO 
               			Inner join #OrderAcknwRoles OAR On CO.ClientOrderId =OAR.ClientOrderId
               						AND Isnull(CO.RecordDeleted, 'N') = 'N'
               			Inner join #ClientOrderAcknwRoles COAR On CO.ClientOrderId =COAR.ClientOrderId
               	Where COAR.ClientOrderAcknRoleCount >=OAR.OrderAcknRoleCount
               			and CO.OrderPendRequiredRoleAcknowledge='Y'
            
            -- Invoke the process to create MAR schedules
            
            Declare @UserCode VARCHAR(30)
            SELECT @UserCode = UserCode 
            FROM   Staff 
            WHERE  StaffId = @StaffId 
                   AND ISNULL(RecordDeleted, 'N') = 'N' 
                   
            exec SSP_CreateMARDetails @UserCode ,NULL, @ClientOrderId
            
            END
            drop table #ClientOrder
            drop table #OrderAcknwRoles
            Drop table #ClientOrderAcknwRoles
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_SCUpdateClientOrdersReleaseAndAcknowledge') 
                      + '*****' + CONVERT(VARCHAR, Error_line()) 
                      + '*****' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error,-- Message text.                        
                      16,-- Severity.                        
                      1 -- State.                        
          ); 
      END catch  
  END 

GO


