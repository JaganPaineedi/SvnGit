/****** Object:  StoredProcedure [dbo].[ssp_GetInpatientVisitActivityBedboard]    Script Date: 04/11/2014 18:35:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetInpatientVisitActivityBedboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetInpatientVisitActivityBedboard]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetInpatientVisitActivityBedboard]    Script Date: 04/11/2014 18:35:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

         
CREATE PROCEDURE [dbo].[ssp_GetInpatientVisitActivityBedboard] (@ClientInpatientVisitId INT,@ColumnName VARCHAR(100))
AS
/*********************************************************************/                            
/* Stored Procedure: ssp_GetInpatientVisitActivity       */                   
                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC         */                            
                  
/* Creation Date:  6 September 2010          */           
                         
/* Author : AG                
                                                     */                            
/* Purpose: Get Inpatient Visit Activity  */                           
/*                                                                   */                          
/* Input Parameters: ClientInpatientVisitId */                          
/*                                                                   */                             
/* Output Parameters:             */                            
/*                                                                   */                            
/* Return:        */                            
/*                                                                   */                            
/* Called By: this procedure is used on bed census - Inpatient Visit Activity tab for BedBoard */                            
/*                                                                   */                            
/* Calls:                                                            */                            
/*                                                                   */                            
/* Data Modifications:                                               */                            
/*                                                                   */                            
/*   Updates:                                                          */                            
                  
/*   Date              Author                  Purpose                                    */                            
/*   07/08/2013		   Akwinass			       Created */      
/*   21/08/2013        Veena                   Merged recent changes from Threshold  */
/*   12/12/2013        Akwinass                Initial Ordery Condition is added in BA_CTE Table*/
/*   24/01/2014        Akwinass                Modified Disposition for Discharged Records*/
/*   11/04/2014        Akwinass                Program Code pulled instead program Name for task #979 in philhaven customization issues*/
/*   21/10/2014        Akwinass                EmergencyRoomDeparture Column Included in ClientInpatientVisits (Task #51 in Meaningful Use)*/
/*   Mar 09 2014       PradeepA				   AdmissionSource column has been added #227 (Philhaven Development) */
/*	 02-Mar-2016	   Seema				   What : added PhysicianId,ClinicianId in select statement
											   Why : Philhaven Development task #369.1 */
/*	 05-DEC-2016	   Sanjay			       What : For remove duplicate records for BedAssignments
								               Why :Woods - Support Go Live #380 */											   
											   
/*********************************************************************/  

BEGIN

BEGIN TRY
DECLARE @ClientPrograms VARCHAR(1000) = '';

SELECT @ClientPrograms = @ClientPrograms + LTRIM(RTRIM(STR(b.ProgramId))) + ','
FROM dbo.ClientInpatientVisits a
JOIN dbo.ClientPrograms b ON (
		b.ClientId = a.ClientId
		AND b.DischargedDate IS NULL
		AND ISNULL(b.RecordDeleted, 'N') = 'N'
		)
WHERE a.ClientInpatientVisitId = @ClientInpatientVisitId;

WITH BA_CTE
AS (
	SELECT BA.BedAssignmentId
		,BA.ClientInpatientVisitId
		,Beds.BedName + '-' + Rooms.RoomName + '-' + Units.UnitName AS BedName
		,Programs.ProgramCode AS ProgramName
		,BA.ProgramId
		,BA.Comment
		,BA.StartDate
		,BA.EndDate
		,BA.BedId
		,BA.Status
		,ISNULL(BA.Disposition, 0) AS Disposition
		,BA.NextBedAssignmentId
		,BA_Prev.Status AS Prev_Status
		,BA_Prev.Disposition AS Prev_Disposition
		,ISNULL(BA_Prev.NextBedAssignmentId, 0) AS Prev_NextBedAssignmentId
		,BA_Next.Status AS Next_Status
		,BA_Next.Disposition AS Next_Dispositon
		,BA_Next.NextBedAssignmentId AS Next_NextBedAssignmentId
		,BA.NextBedAssignmentId AS NextBAId
		,BA_Next.Status AS NextBAStatus
		,BA_Prev.Status AS PreviousBAStatus
		,ddo.DropdownOptions AS DropdownOptions
        ,civ.AdmitDate
        ,civ.AdmitDecision
        ,civ.EmergencyRoomArrival
        --21/10/2014 -  Akwinass
        ,civ.EmergencyRoomDeparture
        ,civ.AdmissionSource
        ,CIV.PhysicianId  -- 02-Mar-2016 Seema 
		,CIV.ClinicianId  -- 02-Mar-2016 Seema
                   from     BedAssignments as BA
                            inner join dbo.ClientInpatientVisits civ on BA.ClientInpatientVisitId = civ.ClientInpatientVisitId
	LEFT OUTER JOIN BedAssignments AS BA_Next ON BA.BedAssignmentId = BA_Next.NextBedAssignmentId and ISNULL( BA_Next.RecordDeleted, 'N') = 'N'---Added by sanjay on 07-12-2016 Task Woods - Support Go Live #380 * 
	LEFT OUTER JOIN BedAssignments AS BA_Prev ON BA.BedAssignmentId = BA_Prev.NextBedAssignmentId and ISNULL(BA_Prev.RecordDeleted, 'N') = 'N'----Added by sanjay on 07-12-2016 Task Woods - Support Go Live #380 *  
	INNER JOIN Beds ON Beds.BedId = BA.BedId
	INNER JOIN dbo.Rooms ON dbo.Rooms.RoomId = dbo.Beds.RoomId
	INNER JOIN dbo.Units ON dbo.Units.UnitId = dbo.Rooms.UnitId
	INNER JOIN Programs ON Programs.ProgramId = BA.ProgramId
	LEFT JOIN GlobalCodes GC ON (BA.Status = GC.GlobalCodeId)
	LEFT JOIN GlobalCodes GC2 ON (BA.Disposition = GC2.GlobalCodeId)
	LEFT JOIN BedBoardStatusChangeDropdowns ddo ON (
			ISNULL(BA.Status, 1) = ISNULL(ddo.BedAssignmentStatus, 1)
			AND ISNULL(ddo.RecordDeleted, 'N') = 'N'
			AND (
				ddo.PreviousAssignmentOccupied IS NULL
				OR (
					ddo.PreviousAssignmentOccupied = 'Y'
					AND BA_Prev.Status = 5002
					)
				OR (
					ddo.PreviousAssignmentOccupied = 'N'
					AND BA_Prev.Status <> 5002
					)
				)
			AND (
				ddo.PreviousAssignmentOnLeave IS NULL
				OR (
					ddo.PreviousAssignmentOnLeave = 'Y'
					AND BA_Prev.Status = 5006
					)
				OR (
					ddo.PreviousAssignmentOnLeave = 'N'
					AND BA_Prev.Status <> 5006
					)
				)
			AND (
				ddo.PreviousAssignmentScheduledOnLeave IS NULL
				OR (
					ddo.PreviousAssignmentScheduledOnLeave = 'Y'
					AND BA_Prev.Status = 5005
					)
				OR (
					ddo.PreviousAssignmentScheduledOnLeave = 'N'
					AND BA_Prev.Status <> 5005
					)
				)
			AND (
				ddo.DispositionIsNull IS NULL
				OR (
					ddo.DispositionIsNull = 'Y'
					AND BA.Disposition IS NULL
					)
				OR (
					ddo.DispositionIsNull = 'N'
					AND BA.Disposition IS NOT NULL
					)
				)
			AND (
				ddo.NextAssignmentIsNull IS NULL
				OR (
					ddo.NextAssignmentIsNull = 'Y'
					AND BA.NextBedAssignmentId IS NULL
					)
				OR (
					ddo.NextAssignmentIsNull = 'N'
					AND BA.NextBedAssignmentId IS NOT NULL
					)
				)
			)
	WHERE ISNULL(BA.RecordDeleted, 'N') = 'N' 	
	)
SELECT BA_CTE.*
	,[Status] AS [ActivityID]
	,'ClientPrograms' = CASE 
		WHEN LEN(@ClientPrograms) > 0
			AND @ClientPrograms IS NOT NULL
			THEN LEFT(LTRIM(RTRIM(@ClientPrograms)), LEN(LTRIM(RTRIM(@ClientPrograms))) - 1)
		ELSE ''
		END
INTO #abc
FROM BA_CTE
WHERE ClientInpatientVisitId = @ClientInpatientVisitId
ORDER BY BedAssignmentId ASC
        IF ( @ColumnName IN ( 'StartDate', 'EndDate', 'Program', 'Bed',
                              'Disposition', 'Activity','Comment','AdmitDate','AdmitDecision','EmergencyRoomArrival' ) ) 
            BEGIN      
                SELECT  vv.*
			,gc1.CodeName AS ActivityStatus
	                ,case when gc1.CodeName = gc2.CodeName then 'Discharged' else gc2.CodeName end  AS DispositionStatus
                FROM    #abc vv
		INNER JOIN globalcodes gc1 ON vv.[ActivityID] = gc1.GlobalCodeId
                LEFT JOIN globalcodes gc2 ON vv.Disposition = gc2.GlobalCodeId
                ORDER BY CASE WHEN @ColumnName = 'StartDate' THEN StartDate
                         END ,
                        CASE WHEN @ColumnName = 'EndDate' THEN ISNULL(EndDate, '2099-01-01')
                        END ,
                        CASE WHEN @ColumnName = 'Activity' THEN gc1.CodeName
                        END ,
                        CASE WHEN @ColumnName = 'Disposition'
                             THEN gc2.CodeName
                        END ,
                        CASE WHEN @ColumnName = 'Bed' THEN BedName
                        END ,
                        CASE WHEN @ColumnName = 'Program' THEN ProgramName
                        END ,
                        CASE WHEN @ColumnName = 'AdmitDate' THEN ISNULL(AdmitDate, '2099-01-01')
                        END ,
                        CASE WHEN @ColumnName = 'Comment' THEN Comment
                        END ,
                        CASE WHEN @ColumnName = 'AdmitDecision' THEN ISNULL(AdmitDecision, '2099-01-01')
                        END ,
                        CASE WHEN @ColumnName = 'EmergencyRoomArrival' THEN ISNULL(EmergencyRoomArrival, '2099-01-01')
                        END
            END
        ELSE 
            IF ( @ColumnName IN ( 'StartDate desc', 'EndDate desc',
                                  'Program desc', 'Bed desc',
                                  'Disposition desc', 'Activity desc','Comment desc','AdmitDate desc','AdmitDecision desc','EmergencyRoomArrival desc' ) ) 
                BEGIN      
                    SELECT  vv.*
			,gc1.CodeName AS ActivityStatus
	                ,gc2.CodeName AS DispositionStatus
                FROM    #abc vv
		INNER JOIN globalcodes gc1 ON vv.[ActivityID] = gc1.GlobalCodeId
                LEFT JOIN globalcodes gc2 ON vv.Disposition = gc2.GlobalCodeId
                    ORDER BY CASE WHEN @ColumnName = 'StartDate desc'
                                  THEN StartDate
                             END DESC ,
                            CASE WHEN @ColumnName = 'EndDate desc'
                                 THEN ISNULL(EndDate, '2099-01-01')
                            END DESC ,
                            CASE WHEN @ColumnName = 'Activity desc'
                                 THEN gc1.CodeName
                            END DESC ,
                            CASE WHEN @ColumnName = 'Disposition desc'
                                 THEN gc2.CodeName
                            END DESC ,
                            CASE WHEN @ColumnName = 'Bed desc' THEN BedName
                            END DESC ,
                            CASE WHEN @ColumnName = 'Program desc'
                                 THEN ProgramName
                            END DESC,
                             CASE WHEN @ColumnName = 'AdmitDate desc' 
								THEN ISNULL(AdmitDate, '2099-01-01')
							END DESC ,
							CASE WHEN @ColumnName = 'Comment desc' THEN Comment
							END DESC,
							CASE WHEN @ColumnName = 'AdmitDecision desc' THEN ISNULL(AdmitDecision, '2099-01-01')
							END DESC,
							CASE WHEN @ColumnName = 'EmergencyRoomArrival desc' THEN ISNULL(EmergencyRoomArrival, '2099-01-01')
							END DESC
                END    
DROP TABLE #abc

END TRY

	BEGIN CATCH
		DECLARE @Error AS VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetInpatientVisitActivityBedboard') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
				@Error
				,16
				,1
				);-- Message text.
	END CATCH
END

GO


