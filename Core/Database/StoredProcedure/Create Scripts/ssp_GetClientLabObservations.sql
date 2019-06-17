IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = Object_id(N'[dbo].[ssp_GetClientLabObservations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClientLabObservations]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetClientLabObservations] 
@ObservationName VARCHAR(50),
@ClientOrderId INT
AS
DECLARE @MName VARCHAR(50)

SET @MName = '%' + @ObservationName + '%'

/*********************************************************************/
/* Stored Procedure: [ssp_GetClientLabObservations]              */
/* EXEC [ssp_GetClientLabObservations]  'hep'            */
/* Creation Date:  13/Nov/2014                                     */
/* Purpose: To get observations For lab orders            */
/* Created By : Praveen Potnuru*/
/*                                                                   */                        
/*  Date        Author              Purpose             */     
/* 12/13/2016	Chethan N			What : Added parameter @ClientOrderId to retrieve Observations based on ClientOrderid 
									Why : Bear River - Support Go Live task #94*/ 	
/********************************************************************/
SELECT OB.ObservationId
	,OB.ObservationName
	,OB.[Range]
	,OB.Unit
	,OB.LOINCCode
FROM observations  OB 
JOIN HealthDataAttributes HDA ON OB.ObservationMethodIdentifier = HDA.LoincCode AND OB.ObservationName = HDA.Name
JOIN HealthDataSubTemplateAttributes HDSTA ON HDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId
JOIN HealthDataSubTemplates HDST ON HDSTA.HealthDataSubTemplateId = HDST.HealthDataSubTemplateId
JOIN HealthDataTemplateAttributes HDTA ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId
JOIN HealthDataTemplates HDT ON HDT.HealthDataTemplateId = HDTA.HealthDataTemplateId
JOIN Orders O ON HDT.HealthDataTemplateId = O.LabId
JOIN ClientOrders CO ON O.OrderId = CO.OrderId
WHERE ObservationName LIKE @MName
AND CO.ClientOrderId = @ClientOrderId
	AND isnull(OB.RecordDeleted, 'N') = 'N'
ORDER BY ObservationName
GO

