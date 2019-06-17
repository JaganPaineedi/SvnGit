/****** Object:  StoredProcedure [dbo].[SSP_GetOrderEntryDetails]    Script Date: 07/31/2013 12:29:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetOrderEntryDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_GetOrderEntryDetails]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetOrderEntryDetails]    Script Date: 07/31/2013 12:29:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[SSP_GetOrderEntryDetails]
@ClientOrderId INT  
,@StaffId INT =  NULL
AS  
     
/*********************************************************************/                                                                                              
 /* Stored Procedure: SSP_GetOrderEntryDetails             */                                                                                     
 /* Creation Date:  10/July/2013                                     */                                                                                              
 /* Purpose: To get Client OrderS            */                                                                                            
  /* Output Parameters:   */                  
  /*Returns The Table for Order Entry Details  */                                                                                              
 /* Called By:                                                       */                                                                                    
 /* Data Modifications:                                              */                                                                                              
 /*   Updates:                                                       */                                                                                              
 /*   Date			Author		Purpose                       */                                                                                              
 /*  17/June/2013  Vithobha		Created                       */              
/*	Deleted Old comments		*/	
/*	16 May 2017	    Lakshmi		What: Commented some of the not used coloumns from select statement.
								Why:  Bear River - Support Go Live #243			
	02 Jul 2018		Chethan N	What : Added new column 'LocationId' to ClientOrders table.
								Why : Engineering Improvement Initiatives- NBL(I) task #667	
	02 Jul 2018		Chethan N	What : Added new column 'ResultsReviewComment' and 'AssignedToComments' to ClientOrders table.
								Why : Engineering Improvement Initiatives- NBL(I) task #551
	16 Oct 2018		Chethan N	What: Added @ClientOrderId parameter to check the for Ordering Physician
								Why: CCC-Customizations task# 83   		
	01 Mar 2019		Vijeta S	What: Passing -1 as ClientOrderId to get the table structure of table "ImageRecordItems" where data is not required.
								Why: CCC - Support Go Live task# 187   */																																								
 /********************************************************************/   
BEGIN 
    BEGIN try 
        SELECT CO.ClientOrderId, 
               CO.CreatedBy, 
               CO.CreatedDate, 
               CO.ModifiedBy, 
               CO.ModifiedDate, 
               CO.RecordDeleted, 
               CO.DeletedDate, 
               CO.DeletedBy, 
               CO.ClientId, 
               CO.OrderId, 
               CO.DocumentId, 
               CO.PreviousClientOrderId, 
               CO.MedicationOrderStrengthId, 
               CO.MedicationOrderRouteId, 
               CO.OrderPriorityId, 
               CO.OrderScheduleId, 
               CO.OrderTemplateFrequencyId, 
               CO.MedicationUseOtherUsage, 
               CO.MedicationOtherDosage, 
               CO.RationaleText, 
               CO.CommentsText, 
               CO.Active, 
               CO.OrderPended, 
               CO.OrderDiscontinued, 
               CO.DiscontinuedDateTime, 
               CO.OrderStartOther, 
               CO.OrderStartDateTime, 
               CO.OrderedBy, 
               CO.OrderMode, 
               CO.OrderStatus, 
               CO.AssignedTo,
               CO.OrderingPhysician,  
               CO.OrderFlag,
               CO.DocumentVersionId, 
               CO.ReleasedOn, 
               CO.ReleasedBy, 
               CO.OrderPendAcknowledge, 
               CO.OrderPendRequiredRoleAcknowledge,
               GC.CodeName AS OrderType,
               CO.ReviewedFlag,
               CO.ReviewedBy,
               CO.ReviewedDateTime,
               CO.ReviewedComments,
               CO.FlowSheetDateTime,
               CO.MedicationDaySupply,  
               CO.MedicationRefill,  
               CO.Level,
               CO.Legal,
               CO.DispenseBrand,
               CO.IsReadBackAndVerified,
               CO.MayUseOwnSupply,
               CO.ConsentIsRequired,
               CO.MaySelfAdminister,
               CO.IsPRN,
               CO.OrderEndDateTime,
               C.LastName+', '+C.FirstName AS ClientName,
               C.SSN,
               C.Sex,
               replace(convert(varchar(10),  C.DOB, 101), ' ', '/') AS DOB,
               (CA.[Address] + ' ' + CA.[City] + ' ' + CA.[State] + ' ' + CA.[Zip]) AS Address
      --         ,L.LocationName AS PerformingLab
			   --,L.Address AS LabAddress 
			   --,L.PhoneNumber AS LabPhone
			   --,L.Comment AS LabMedDirector
			   ,OTF.DisplayName as FrequencyText
			   ,CO.MaxDispense
			   ,CO.RationaleOtherText
			   ,CO.ReviewInterpretationType
			   ,CO.MedicationDosage
			   ,CO.MedicationUnits
			   ,CO.DaysOfWeek
			   ,ORD.AddOrderToMAR
			   ,CO.LaboratoryId
			   ,CO.DrawFromServiceCenter
			   ,CO.DiscontinuedReason
			   ,CO.PotencyUnit
			   ,CO.ParentClientOrderId
			   ,CO.ClinicalLocation
			   ,CO.LocationId
			   ,CO.ResultsReviewComment
			   ,CO.AssignedToComments
        FROM   ClientOrders  CO 
        INNER JOIN Orders ORD  ON  CO.OrderId = ORD.OrderId AND ISNULL(ORD.RecordDeleted, 'N') = 'N'
        INNER JOIN Clients C  ON  C.ClientId = CO.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N'
        LEFT JOIN ClientAddresses CA  ON  CA.ClientId = C.ClientId AND ISNULL(CA.RecordDeleted, 'N') = 'N' AND CA.AddressType=90 --Home Address Type
        --LEFT JOIN ClientOrderQnAnswers CQA  ON  CQA.ClientOrderId = CO.ClientOrderId AND ISNULL(CQA.RecordDeleted, 'N') = 'N'
        --LEFT JOIN OrderQuestions OQ  ON  CQA.QuestionId = OQ.QuestionId AND ISNULL(OQ.RecordDeleted, 'N') = 'N' 
        --LEFT JOIN Locations L  ON  CQA.AnswerValue = L.LocationId AND ISNULL(L.RecordDeleted, 'N') = 'N' 
        LEFT OUTER JOIN GlobalCodes GC ON GC.GlobalCodeId = ORD.OrderType
        LEFT JOIN OrderTemplateFrequencies OTF On CO.OrderTemplateFrequencyId=OTF.OrderTemplateFrequencyId
												AND ISNULL(OTF.RecordDeleted, 'N') = 'N' 
        WHERE  CO.ClientOrderId = @ClientOrderId     
               AND ISNULL(CO.RecordDeleted, 'N') = 'N' 
               --AND (ORD.OrderType<>6481 OR ISNULL(OQ.AnswerRelatedCategory,'XLabName')='XLabName') 
        
        /*ImageRecords For Client Order Attachments*/       
        SELECT IR.ImageRecordId,IR.CreatedBy,IR.CreatedDate,IR.ModifiedBy,IR.ModifiedDate,IR.RecordDeleted,IR.DeletedDate,IR.DeletedBy,IR.ScannedOrUploaded,IR.DocumentVersionId,IR.ImageServerId,IR.ClientId,IR.AssociatedId,IR.AssociatedWith,IR.RecordDescription,IR.EffectiveDate,IR.NumberOfItems,IR.AssociatedWithDocumentId,IR.AppealId,IR.StaffId,IR.EventId,IR.ProviderId,IR.TaskId,IR.AuthorizationDocumentId,IR.ScannedBy,IR.CoveragePlanId,IR.ClientDisclosureId,CO.ClientOrderId,CO.CreatedBy,CO.CreatedDate,CO.ModifiedBy,CO.ModifiedDate,CO.RecordDeleted,CO.DeletedDate,CO.DeletedBy,CO.ClientId,CO.OrderId,CO.DocumentId,CO.PreviousClientOrderId,CO.MedicationOrderStrengthId,CO.MedicationOrderRouteId,CO.OrderPriorityId,CO.OrderScheduleId,CO.OrderTemplateFrequencyId,CO.MedicationUseOtherUsage,CO.MedicationOtherDosage,CO.RationaleText,CO.CommentsText,CO.Active,CO.OrderPended,CO.OrderDiscontinued,CO.DiscontinuedDateTime,CO.OrderStartOther,CO.OrderStartDateTime,CO.OrderedBy,CO.OrderMode,CO.OrderStatus,CO.AssignedTo,CO.OrderFlag,CO.DocumentVersionId,CO.ReleasedOn,CO.ReleasedBy,CO.OrderPendAcknowledge,CO.OrderPendRequiredRoleAcknowledge,CO.OrderingPhysician,CO.OrderEndDateTime 
        FROM ImageRecords IR 
        JOIN ClientOrderImageRecords COIR ON COIR.ImageRecordId = IR.ImageRecordId
        INNER JOIN ClientOrders CO 	ON CO.ClientOrderId = COIR.ClientOrderId 
		WHERE CO.ClientOrderId = @ClientOrderId AND ISNULL(IR.RecordDeleted,'N')='N' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'  
		 
		/*ImageRecordItems For Client Order Attachments*/ 
		SELECT IRI.ImageRecordItemId,IRI.ImageRecordId,IRI.ItemNumber,IRI.ItemImage,IRI.RowIdentifier,IRI.CreatedBy,IRI.CreatedDate,IRI.ModifiedBy,IRI.ModifiedDate,IRI.RecordDeleted,IRI.DeletedDate,IRI.DeletedBy,IR.ImageRecordId,IR.CreatedBy,IR.CreatedDate,IR.ModifiedBy,IR.ModifiedDate,IR.RecordDeleted,IR.DeletedDate,IR.DeletedBy,IR.ScannedOrUploaded,IR.DocumentVersionId,IR.ImageServerId,IR.ClientId,IR.AssociatedId,IR.AssociatedWith,IR.RecordDescription,IR.EffectiveDate,IR.NumberOfItems,IR.AssociatedWithDocumentId,IR.AppealId,IR.StaffId,IR.EventId,IR.ProviderId,IR.TaskId,IR.AuthorizationDocumentId,IR.ScannedBy,IR.CoveragePlanId,IR.ClientDisclosureId,CO.ClientOrderId,CO.CreatedBy,CO.CreatedDate,CO.ModifiedBy,CO.ModifiedDate,CO.RecordDeleted,CO.DeletedDate,CO.DeletedBy,CO.ClientId,CO.OrderId,CO.DocumentId,CO.PreviousClientOrderId,CO.MedicationOrderStrengthId,CO.MedicationOrderRouteId,CO.OrderPriorityId,CO.OrderScheduleId,CO.OrderTemplateFrequencyId,CO.MedicationUseOtherUsage,CO.MedicationOtherDosage,CO.RationaleText,CO.CommentsText,CO.Active,CO.OrderPended,CO.OrderDiscontinued,CO.DiscontinuedDateTime,CO.OrderStartOther,CO.OrderStartDateTime,CO.OrderedBy,CO.OrderMode,CO.OrderStatus,CO.AssignedTo,CO.OrderFlag,CO.DocumentVersionId,CO.ReleasedOn,CO.ReleasedBy,CO.OrderPendAcknowledge,CO.OrderPendRequiredRoleAcknowledge,CO.OrderingPhysician,CO.OrderEndDateTime 
		FROM ImageRecordItems IRI INNER JOIN ImageRecords IR ON IR.ImageRecordId = IRI.ImageRecordId
		JOIN ClientOrderImageRecords COIR ON COIR.ImageRecordId = IR.ImageRecordId
        INNER JOIN ClientOrders CO 	ON CO.ClientOrderId = COIR.ClientOrderId 
		WHERE CO.ClientOrderId = -1 AND ISNULL(IR.RecordDeleted,'N')='N' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y' AND ISNULL(IRI.RecordDeleted, 'N') <> 'Y'  
		
		DECLARE @FlowSheetDateTime AS DATETIME
		DECLARE @ClientId AS INT
		DECLARE @HealthDataAttributeId AS INT
		
		SELECT @FlowSheetDateTime = ISNULL(CONVERT(VARCHAR,CAST(CONVERT(VARCHAR,CO.FlowSheetDateTime,20) AS DATETIME),109), GETDATE()), @ClientId =CO.Clientid, @HealthDataAttributeId=ORD.LabId
		FROM   ClientOrders  CO INNER JOIN Orders ORD  
        ON  CO.OrderId = ORD.OrderId  
        WHERE  CO.ClientOrderId = @ClientOrderId     
        AND ISNULL(CO.RecordDeleted, 'N') = 'N' AND ISNULL(ORD.LabId, '') <> ''
        
        EXEC ssp_SCGetClientHealthDataAttributes @ClientId, @HealthDataAttributeId, @FlowSheetDateTime 
        --EXEC ssp_SCGetClientHealthDataAttributes @ClientId, @HealthDataAttributeId, '' 
        --for getting lab results
        EXEC  SSP_GetClientLabOrderResults @ClientOrderId
        
        --ClientOrderQnAnswers     
		SELECT coq.ClientAnswerId
			,coq.CreatedBy
			,coq.CreatedDate
			,coq.ModifiedBy
			,coq.ModifiedDate
			,coq.RecordDeleted
			,coq.DeletedBy
			,coq.DeletedDate
			,coq.QuestionId
			,coq.ClientOrderId
			,coq.AnswerType
			,coq.AnswerText
			,coq.AnswerValue
			,coq.AnswerDateTime
			,coq.HealthDataAttributeId
		FROM ClientOrderQnAnswers coq
		INNER JOIN ClientOrders CL ON CL.ClientOrderId = coq.ClientOrderId
		WHERE ISNULL(coq.RecordDeleted, 'N') <> 'Y'
			AND CL.ClientOrderId = @ClientOrderId
			
		
		---------------------OrderingPhysician--------------------------------------
		DECLARE @OrderingPhysician CHAR(1)
		DECLARE @PermissionTemplateId INT
		
		SELECT TOP 1 @PermissionTemplateId =  GlobalCodeID
		FROM GlobalCodes
		WHERE Code = 'Ordering Physician'
			AND Category = 'STAFFLIST'
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT @OrderingPhysician = CASE 
				WHEN EXISTS (
						SELECT 1
						FROM ViewStaffPermissions vs
						WHERE vs.permissionitemid = @PermissionTemplateId
							AND vs.StaffId = @StaffId
							AND vs.PermissionTemplateType = 5704
						)
					THEN 'Y'
				ELSE 'N'
				END 
		
		SELECT ISNULL(@OrderingPhysician, 'N') AS OrderingPhysician
		
    END try 

    BEGIN catch 
        DECLARE @Error VARCHAR(8000) 

        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                    + CONVERT(VARCHAR(4000), Error_message()) 
                    + '*****' 
                    + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                    'SSP_GetOrderEntryDetails') 
                    + '*****' + CONVERT(VARCHAR, Error_line()) 
                    + '*****' + CONVERT(VARCHAR, Error_severity()) 
                    + '*****' + CONVERT(VARCHAR, Error_state()) 

        RAISERROR ( @Error,-- Message text.             
                    16,-- Severity.             
                    1 -- State.             
        ); 
    END catch 

    RETURN 
END  

GO


