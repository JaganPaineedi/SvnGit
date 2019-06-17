/****** Object:  StoredProcedure [dbo].[ssp_GetInpatientVisitActivity]    Script Date: 3/12/2013 10:29:54 AM ******/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   SPECIFIC_NAME = 'ssp_GetInpatientVisitActivity'
                    AND SPECIFIC_SCHEMA = 'dbo' ) 
    DROP PROCEDURE [dbo].[ssp_GetInpatientVisitActivity]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetInpatientVisitActivity]    Script Date: 3/12/2013 10:29:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





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
/* Called By: this procedure is used on bed census - Inpatient Visit Activity tab */                            
/*                                                                   */                            
/* Calls:                                                            */                            
/*                                                                   */                            
/* Data Modifications:                                               */                            
/*                                                                   */                            
/*   Updates:                                                          */                            
                  
/*       Date				Author                  Purpose                                    */                            
/*       2/8/2012			Wasif Butt			Updated BedActivityStatus table to GlobalCodes */                           
/*       08/07/2012			Chethan N			What : Added new columns 'AdmitDate', 'AdmitDecision', 'EmergencyRoomArrival' 
												Why :  Core Bugs task # 1851*/                            
/*********************************************************************/           
                 
CREATE PROCEDURE [dbo].[ssp_GetInpatientVisitActivity]
    (
      @ClientInpatientVisitId INT                  
    )
AS --  WITH BA_CTE as(        
--  SELECT          
        
--  BA.BedAssignmentId, BA.ClientInpatientVisitId,Beds.BedName,Programs.ProgramName,BA.ProgramId,BA.Comment, BA.StartDate,BA.EndDate, BA.BedId, BA.Status, BA.Disposition, BA.NextBedAssignmentId, BA_Prev.Status AS Prev_Status,         
--                      BA_Prev.Disposition AS Prev_Disposition, BA_Prev.NextBedAssignmentId AS Prev_NextBedAssignmentId, BA_Next.Status AS Next_Status,         
--                      BA_Next.Disposition AS Next_Dispositon, BA_Next.NextBedAssignmentId AS Next_NextBedAssignmentId        
--  FROM  BedAssignments AS BA LEFT OUTER JOIN        
--                      BedAssignments AS BA_Next ON BA.BedAssignmentId = BA_Next.NextBedAssignmentId LEFT OUTER JOIN        
--                      BedAssignments AS BA_Prev ON BA.BedAssignmentId = BA_Prev.NextBedAssignmentId        
--                      inner join Beds on Beds.BedId=BA.BedId        
--                      inner join Programs on Programs.ProgramId=BA.ProgramId                            
--                      )        
                   
--  Select   BA_CTE.*, DBO.GetPatientActivity([Status],Prev_Status,Prev_Disposition)as [Activity]      
          
--  from    BA_CTE     
    
--where ClientInpatientVisitId=@ClientInpatientVisitId        
	
    DECLARE @ClientPrograms VARCHAR(1000) = '';

    SELECT  @ClientPrograms = @ClientPrograms + LTRIM(RTRIM(STR(b.ProgramId)))
            + ','
    FROM    dbo.ClientInpatientVisits a
            JOIN dbo.ClientPrograms b ON ( b.ClientId = a.ClientId
                                           AND b.DischargedDate IS NULL
                                           AND ISNULL(b.RecordDeleted, 'N') = 'N'
                                         )
    WHERE   a.ClientInpatientVisitId = @ClientInpatientVisitId;
    
    WITH    BA_CTE
              AS ( SELECT   BA.BedAssignmentId ,
                            BA.ClientInpatientVisitId ,
                            Beds.BedName + '-' + Rooms.RoomName + '-'
                            + Units.UnitName AS BedName ,
                            Programs.ProgramName ,
                            BA.ProgramId ,
                            BA.Comment ,
                            BA.StartDate ,
                            BA.EndDate ,
                            BA.BedId ,
                            BA.Status ,
                            ISNULL(BA.Disposition, 0) AS Disposition ,
                            BA.NextBedAssignmentId ,
                            BA_Prev.Status AS Prev_Status ,
                            BA_Prev.Disposition AS Prev_Disposition ,
                            ISNULL(BA_Prev.NextBedAssignmentId, 0) AS Prev_NextBedAssignmentId ,
                            BA_Next.Status AS Next_Status ,
                            BA_Next.Disposition AS Next_Dispositon ,
                            BA_Next.NextBedAssignmentId AS Next_NextBedAssignmentId ,
                            BA.NextBedAssignmentId AS NextBAId ,
                            BA_Next.Status AS NextBAStatus ,
                            BA_Prev.Status AS PreviousBAStatus ,
                            ddo.DropdownOptions AS DropdownOptions,
                            CIV.AdmitDate,  
							CIV.AdmitDecision,  
							CIV.EmergencyRoomArrival
                   FROM     BedAssignments AS BA
                            JOIN dbo.ClientInpatientVisits civ on BA.ClientInpatientVisitId = civ.ClientInpatientVisitId  
							LEFT OUTER JOIN BedAssignments AS BA_Next ON BA.BedAssignmentId = BA_Next.NextBedAssignmentId
                            LEFT OUTER JOIN BedAssignments AS BA_Prev ON BA.BedAssignmentId = BA_Prev.NextBedAssignmentId
                            INNER JOIN Beds ON Beds.BedId = BA.BedId
                            INNER JOIN dbo.Rooms ON dbo.Rooms.RoomId = dbo.Beds.RoomId
                            INNER JOIN dbo.Units ON dbo.Units.UnitId = dbo.Rooms.UnitId
                            INNER JOIN Programs ON Programs.ProgramId = BA.ProgramId
                            LEFT JOIN GlobalCodes GC ON ( BA.Status = GC.GlobalCodeId )
                            LEFT JOIN GlobalCodes GC2 ON ( BA.Disposition = GC2.GlobalCodeId )
                            LEFT JOIN BedCensusStatusChangeDropdowns ddo ON ( ISNULL(BA.Status,
                                                              1) = ISNULL(ddo.BedAssignmentStatus,
                                                              1)
                                                              AND ( ddo.PreviousAssignmentOccupied IS NULL
                                                              OR ( ddo.PreviousAssignmentOccupied = 'Y'
                                                              AND BA_Prev.Status = 5002
                                                              )
                                                              OR ( ddo.PreviousAssignmentOccupied = 'N'
                                                              AND BA_Prev.Status <> 5002
                                                              )
                                                              )
                                                              AND ( ddo.PreviousAssignmentOnLeave IS NULL
                                                              OR ( ddo.PreviousAssignmentOnLeave = 'Y'
                                                              AND BA_Prev.Status = 5006
                                                              )
                                                              OR ( ddo.PreviousAssignmentOnLeave = 'N'
                                                              AND BA_Prev.Status <> 5006
                                                              )
                                                              )
                                                              AND ( ddo.PreviousAssignmentScheduledOnLeave IS NULL
                                                              OR ( ddo.PreviousAssignmentScheduledOnLeave = 'Y'
                                                              AND BA_Prev.Status = 5005
                                                              )
                                                              OR ( ddo.PreviousAssignmentScheduledOnLeave = 'N'
                                                              AND BA_Prev.Status <> 5005
                                                              )
                                                              )
                                                              AND ( ddo.DispositionIsNull IS NULL
                                                              OR ( ddo.DispositionIsNull = 'Y'
                                                              AND BA.Disposition IS NULL
                                                              )
                                                              OR ( ddo.DispositionIsNull = 'N'
                                                              AND BA.Disposition IS NOT NULL
                                                              )
                                                              )
                                                              AND ( ddo.NextAssignmentIsNull IS NULL
                                                              OR ( ddo.NextAssignmentIsNull = 'Y'
                                                              AND BA.NextBedAssignmentId IS NULL
                                                              )
                                                              OR ( ddo.NextAssignmentIsNull = 'N'
                                                              AND BA.NextBedAssignmentId IS NOT NULL
                                                              )
                                                              )
                                                              )
                   WHERE    ISNULL(BA.RecordDeleted, 'N') = 'N'
                 )
        SELECT  BA_CTE.* ,
                --DBO.GetPatientActivity([Status], Prev_Status, Prev_Disposition) AS [ActivityID]
                [Status] AS [ActivityID] ,
                'ClientPrograms' = CASE WHEN LEN(@ClientPrograms) > 0
                                             AND @ClientPrograms IS NOT NULL
                                        THEN LEFT(LTRIM(RTRIM(@ClientPrograms)),
                                                  LEN(LTRIM(RTRIM(@ClientPrograms)))
                                                  - 1)
                                        ELSE ''
                                   END
        INTO    #abc
        FROM    BA_CTE
        WHERE   ClientInpatientVisitId = @ClientInpatientVisitId
        ORDER BY BA_CTE.BedAssignmentId DESC
        
    
    
  
    SELECT  vv.* ,
            gc1.CodeName AS ActivityStatus ,
            gc2.CodeName AS DispositionStatus
    FROM    #abc vv
            INNER JOIN globalcodes gc1 ON vv.[ActivityID] = gc1.GlobalCodeId
            LEFT JOIN globalcodes gc2 ON vv.Disposition = gc2.GlobalCodeId
    ORDER BY vv.BedAssignmentId DESC
    DROP TABLE #abc  




GO


