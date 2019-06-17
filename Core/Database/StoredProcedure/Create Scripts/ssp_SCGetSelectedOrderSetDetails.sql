/****** Object:  StoredProcedure [dbo].[ssp_SCGetSelectedOrderSetDetails]    Script Date: 05/10/2017 12:15:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSelectedOrderSetDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetSelectedOrderSetDetails]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetSelectedOrderSetDetails]    Script Date: 05/10/2017 12:15:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
      
CREATE PROCEDURE [dbo].[ssp_SCGetSelectedOrderSetDetails]
 @OrderSetId INT,
@ClientId INT = 0  
AS            
/*********************************************************************/                                                                                                    
/* Stored Procedure: [ssp_SCGetSelectedOrderSetDetails] 14    */                                                                                           
/* Creation Date:  04/July/2013                                      */                                                                                                    
/* Purpose: To get Selected Order details For Order set Entry        */                                                                                                  
/* Input Parameters:@OrderSetId           */                              
/* Output Parameters:             */                                                                                                                     
/* Called By:                                                        */                                                                                          
/* Data Modifications:                                               */                                                                                                    
/* Updates:                                                          */                                                                                                    
/* Date   Author    Purpose            */                                                                                                    
/* 04/July/2013  S Ganesh  Created          */       
/* 20/March/2015  Varun returning SensitiveOrder column          */  
/* 10/Apr/2017  Chethan N	What : Client Order Set Changes.
							Why : Engineering Improvement Initiatives- NBL(I) task #475     */       
/*********************************************************************/               
BEGIN       
      
	 DECLARE @OrderIdString VARCHAR(MAX)
	 SET  @OrderIdString=''     

	SELECT @OrderIdString = @OrderIdString + CAST(OrderId AS VARCHAR(5)) + ','
	FROM OrderSetAttributes
	WHERE OrderSetId = @OrderSetId

	SET @OrderIdString = SUBSTRING(@OrderIdString, 0, LEN(@OrderIdString))
      
	 SELECT OSA.OrderId
		,OSA.OrderSetId
		,CAST(ORD.OrderType AS varchar) AS OrderType
		,OrderTypeName = (
			SELECT GC.CodeName
			FROM GlobalCodes GC
			WHERE GC.GlobalCodeId = ORD.OrderType
			)
		,ORD.OrderName + ISNULL(' (' + (
				SELECT MedicationName
				FROM MDMedicationNames
				WHERE MedicationNameId = ORD.MedicationNameId
				) + ')', '') AS OrderName
		,ORD.HasRationale
		,ORD.HasComments
		,ORD.Active
		,CASE ISNULL(ORD.CanBePended, 'N')
			WHEN 'N'
				THEN 'N'
			ELSE 'Y'
			END AS CanBePended
		,ISNULL(ORD.OrderLevelRequired, 'N') AS OrderLevelRequired
		,ISNULL(ORD.LegalStatusRequired, 'N') AS LegalStatusRequired
		,ISNULL(ORD.NeedsDiagnosis, 'N') AS NeedsDiagnosis
		,ISNULL(ORD.ConsentIsRequired, 'N') AS ConsentIsRequired
		,ISNULL(ORD.IsSelfAdministered, 'N') AS MaySelfAdminister
		,ISNULL(ORD.Sensitive, 'N') AS SensitiveOrder
		,ISNULL(ORD.DrawFromServiceCenter, 'N') AS CanBeDrawFromServiceCenter
		,OrderPendAcknowledge = ISNULL((
				SELECT TOP 1 CanAcknowledge
				FROM OrderAcknowledgments
				WHERE OrderId = ORD.OrderId
					AND CanAcknowledge = 'Y'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				), 'N')
		,OrderPendRequiredRoleAcknowledge = ISNULL((
				SELECT TOP 1 NeedsToAcknowledge
				FROM OrderAcknowledgments
				WHERE OrderId = ORD.OrderId
					AND NeedsToAcknowledge = 'Y'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				), 'N')
				, CA.AllergenConceptId
	FROM OrderSetAttributes OSA
	INNER JOIN Orders ORD ON ORD.OrderId = OSA.OrderId
	LEFT JOIN (SELECT DISTINCT MDA.AllergenConceptId
		,MD.MedicationNameId
		,ORD.OrderId
	FROM MDMedications MD
	INNER JOIN MDAllergenConcepts MDA ON MDA.MedicationNameId = MD.MedicationNameId
	INNER JOIN ClientAllergies CA ON CA.AllergenConceptId = MDA.AllergenConceptId
	JOIN Orders ORD ON ORD.MedicationNameId = MD.MedicationNameId
	JOIN OrderSetAttributes OA ON OA.OrderId = ORD.OrderId AND OA.OrderSetId = @OrderSetId
	WHERE ISNULL(CA.RecordDeleted, 'N') <> 'Y'
		AND CA.Active = 'Y'
		AND CA.ClientId = @ClientId) AS CA ON CA.OrderId = ORD.OrderId
	WHERE OSA.OrderSetId = @OrderSetId
		AND ISNULL(OSA.RecordDeleted, 'N') <> 'Y'
	ORDER BY OSA.DisplayOrder ASC

	EXEC ssp_SCGetSelectedOrderSetDetailsComplete @OrderIdString , @ClientId    
       
END   

GO


