IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetNewBedDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetNewBedDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                                       
Create  Procedure [dbo].[ssp_GetNewBedDetails] --6,'01/20/2016' -- 131           
(                    
@BedId int,
@CensusDate Datetime                    
)                    
As   
 Begin   
 Begin TRY     
 
/****************************************************************************************/                            
/* Stored Procedure: dbo.ssp_GetNewBedDetails                                    */                            
/* Creation Date:  22-Jan-2016                                                         */                            
/* Creation By:  Veena S Mani                                                        */                            
/* Purpose: To Get Bed Details                         */                         
/* Input Parameters: @BedId ,@CensusDate                                                         */                          
/* Output Parameters:                                                                   */                            
/*  Date                  Author                 Purpose                                */ 
/*  20/01/2016            Veena                  Philhaven Development #373 Swap beds          */
                           
/****************************************************************************************/                     
DECLARE @ProgramID  INT
SET @ProgramID =(Select top 1 ProgramId From BedAvailabilityHistory WHERE BedId=@BedId order by BedAvailabilityHistoryId)

--DECLARE @CensusDate DATETIME = '01/20/2016'
;
WITH BedAssignmentSResults
AS (SELECT DISTINCT ba.BedAssignmentId
		,ba.BedId,
CIV.ClientId,
BS.DisplayAs + 
CASE WHEN CIV.ClientId IS NULL
THEN ''
ELSE
' - '+  C.LastName + ', ' + C.FirstName   END AS BedNameWithClient,
BS.DisplayAs AS BedName,
RS.DisplayAs AS Room,
U.DisplayAs AS Unit,
CASE   
    WHEN ISNULL(C.ClientType, 'I') = 'I'  
     THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  + '(' + CAST(C.ClientId AS VARCHAR) + ')'
    ELSE ISNULL(C.OrganizationName, '')  + '(' + CAST(C.ClientId AS VARCHAR) + ')'
    END AS ClientName
--C.LastName + ' ' + C.FirstName + '(' + CAST(C.ClientId AS VARCHAR) + ')' AS ClientName
	FROM BedAssignments ba
	JOIN ClientInpatientVisits CIV ON CIV.ClientInpatientVisitId=ba.ClientInpatientVisitId
	JOIN Beds BS ON (ba.BedId = BS.BedId)
	JOIN Rooms RS ON (BS.RoomId = RS.RoomId)
	JOIN Units U ON (RS.UnitId=U.UnitId)
	JOIN BedAvailabilityHistory BAH ON (ba.BedId = bah.BedId)
	JOIN Programs PR ON(ba.ProgramId=PR.ProgramId AND PR.InpatientProgram='Y')
    JOIN Clients C ON CIV.ClientId=C.ClientId     

	WHERE ISNULL(ba.RecordDeleted, 'N') = 'N' AND BAH.ProgramId=@ProgramID AND bah.BedId<>@BedId
			AND CAST(ba.StartDate as Date) <= CAST(@CensusDate as Date) 
			AND ISNULL(BAH.RecordDeleted, 'N') = 'N'
			AND (((ba.EndDate IS NULL OR CAST(ba.EndDate as Date) > CAST(@CensusDate as Date)))
				OR				
				(CAST(ba.EndDate as Date) = CAST(@CensusDate as Date) AND ba.Disposition IS NOT NULL)
				OR				
				(CAST(ba.EndDate as Date) >= DATEADD(dd, - 90, CAST(@CensusDate as Date))AND ba.Disposition IS NULL))
			AND bah.StartDate <= @CensusDate 
			AND (bah.EndDate >= @CensusDate OR bah.EndDate IS NULL)	
			AND ba.Status = 5002
			AND ba.Disposition IS NULL		
--UNION ALL			
--SELECT DISTINCT NULL
--	,BS.BedId
--    ,NULL,
--BS.DisplayAs AS BedNameWithClient,
--BS.DisplayAs AS BedName,
--RS.DisplayAs AS Room,
--US.DisplayAs AS Unit,
--NULL AS ClientName

--FROM Units AS US
--INNER JOIN UnitAvailabilityHistory UAH ON UAH.UnitId = US.UnitId
--INNER JOIN Rooms AS RS ON US.UnitId = RS.UnitId
--	AND (ISNULL(RS.RecordDeleted, 'N') = 'N' AND ISNULL(RS.Active, 'Y') = 'Y')
--	AND (ISNULL(US.RecordDeleted, 'N') = 'N' AND ISNULL(US.Active, 'Y') = 'Y' AND ISNULL(US.ShowOnBedBoard, 'N') = 'Y')
--INNER JOIN RoomAvailabilityHistory RAH ON RAH.RoomId = RS.RoomId AND ISNULL(RAH.RecordDeleted, 'N') = 'N'
--INNER JOIN Beds AS BS ON RS.RoomId = BS.RoomId
--	AND (ISNULL(BS.RecordDeleted, 'N') = 'N' AND ISNULL(BS.Active, 'Y') = 'Y')
--INNER JOIN BedAvailabilityHistory AS BAH ON BS.BedId = BAH.BedId
--	AND ISNULL(BS.RecordDeleted, 'N') = 'N'
--	AND ISNULL(BAH.RecordDeleted, 'N') = 'N'
--	AND BAH.EndDate IS NULL
--INNER JOIN Programs AS PS ON (BAH.ProgramId = PS.ProgramId AND PS.InpatientProgram = 'Y')
--	AND (ISNULL(PS.RecordDeleted, 'N') = 'N' AND ISNULL(PS.Active, 'Y') = 'Y')
--WHERE  bah.StartDate <= CAST(@CensusDate AS DATE) AND BAH.ProgramId=@ProgramID AND bah.BedId<>@BedId
--		AND (bah.EndDate >= CAST(@CensusDate AS DATE) OR bah.EndDate IS NULL)
--		AND rah.StartDate <= CAST(@CensusDate AS DATE)
--		AND (rah.EndDate >= CAST(@CensusDate AS DATE) OR rah.EndDate IS NULL)
--		AND uah.StartDate <= CAST(@CensusDate AS DATE)
--		AND (uah.EndDate >= CAST(@CensusDate AS DATE) OR uah.EndDate IS NULL)
--		AND ISNULL(UAH.RecordDeleted, 'N') = 'N'
--		AND NOT EXISTS (
--			SELECT *
--			FROM BedAssignments ba
--			JOIN Beds b2 ON (ba.BedId = b2.BedId)
--			JOIN Rooms r2 ON (b2.RoomId = r2.RoomId)
--			WHERE b2.BedId = BS.BedId
--				AND b2.RoomId = BS.RoomId
--				AND R2.UnitId = US.UnitId
--				AND ISNULL(ba.RecordDeleted, 'N') = 'N'
--				AND (ba.EndDate IS NULL OR (CAST(ba.EndDate AS DATE) = CAST(@CensusDate AS DATE) AND Disposition IS NULL) OR CAST(ba.EndDate AS DATE) > CAST(@CensusDate AS DATE))
--				AND CAST(ba.StartDate AS DATE) <= CAST(@CensusDate AS DATE)
--				AND (ba.[Status] NOT IN (5005,5006) OR ba.BedNotAvailable = 'Y')
--			)
		
)
SELECT * FROM BedAssignmentSResults

     
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetNewBedDetails')                                                                                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                                        
 RAISERROR                                                                                                           
 (                                                                             
  @Error, -- Message text.                                                                                                          
  16, -- Severity.                                                                                                          
  1 -- State.                                                                                                          
 );                                                                                                        
END CATCH                                                       
END   

