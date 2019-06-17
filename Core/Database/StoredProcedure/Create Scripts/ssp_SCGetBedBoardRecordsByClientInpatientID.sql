/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedBoardRecordsByClientInpatientID]    Script Date: 07/06/2016 12:38:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetBedBoardRecordsByClientInpatientID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetBedBoardRecordsByClientInpatientID]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedBoardRecordsByClientInpatientID]    Script Date: 07/06/2016 12:38:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_SCGetBedBoardRecordsByClientInpatientID] --70                             
 @ClientInpatientVisitId INT  
AS /****************************************************************************/  
/* Stored Procedure: ssp_SCGetBedCensusRecordsTest                              */  
/* Copyright: 2006 Streamlin Healthcare Solutions                           */  
/* Author: Damanpreet Kaur                                                  */  
/* Creation Date:  Aug 5,2010            */  
/* Purpose: Get Data for Bed Census  Page         */  
/* Input Parameters:      BedAssignmentId                                   */  
/* Output Parameters:None                                                   */  
/* Return:                                                                  */  
/* Calls:                                                                   */  
/* Called From:                                                             */  
/* Data Modifications:                                                      */  
/*                                                                          */  
/*-------------Modification History--------------------------               */  
/*-------Date----Author-------Purpose---------------------------------------*/  
/*       22-08-2013    Veena    Moved from Bed Census for Bed board                                                                   */  
/*       13-09-2013    Akwinass Modified to get disposition*/  
/*       09-Jan-2014   Akwinass Modified to get DRGCode*/  
/*       30-Jan-2014   Akwinass Modified to get AdmissionType*/  
/*       06 Mar 2014   Akwinass DischargeType Column Included in ClientInpatientVisits*/  
/*       07 Mar 2014   Akwinass RowIdentifier removed from ClientInpatientVisits*/  
/*       21 Oct 2014   Akwinass EmergencyRoomDeparture Column Included in ClientInpatientVisits (Task #51 in Meaningful Use)*/  
/*       Mar 09 2014   PradeepA AdmissionSource column has been added #227 (Philhaven Development) */  
/*       Jan 18 2016   Seema What : ClinicianId,PhysicianId columns has been added   
        Why :  Philhaven Development #369 */  
--      Jul 7 2016		Munish Sood Commented Code as per Task # 706 Valley - Support Go Live  
--      01-AUG-2016     Akwinass What : Added BedProcedureCodeId,LeaveProcedureCodeId in select statement
--								 Why : Woods - Support Go Live #43    
--      01-03-2017      Lakshmi   commented code as per the task #345 Bradford - Support Go Live
/****************************************************************************/  
BEGIN  
 BEGIN TRY  
  -- RECORDS FROM ClientInpatientVisits                            
  SELECT CIV.ClientInpatientVisitId  
   ,CIV.ClientId  
   ,CIV.Status  
   ,CIV.RequestedDate  
   ,CIV.ScheduledDate  
   ,CIV.AdmitDate  
   ,CIV.DischargedDate  
   ,CIV.ClientType     
   ,CIV.CreatedBy  
   ,CIV.CreatedDate  
   ,CIV.ModifiedBy  
   ,CIV.ModifiedDate  
   ,CIV.RecordDeleted  
   ,CIV.DeletedDate  
   ,CIV.DeletedBy  
   ,C.LastName  
   ,C.FirstName  
   ,(C.LastName + ', ' + C.FirstName) AS ClientName  
   ,CIV.AdmitDecision  
   ,CIV.EmergencyRoomArrival  
   ,CONVERT(VARCHAR(20), CIV.RequestedDate, 101) AS FRequestedDate  
   ,CONVERT(VARCHAR(20), CIV.ScheduledDate, 101) AS FScheduledDate  
   ,CONVERT(VARCHAR(20), CIV.AdmitDate, 101) AS FAdmitDate  
   ,CONVERT(VARCHAR(20), CIV.DischargedDate, 101) AS FDischargedDate  
   ,REPLACE(REPLACE(RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR(20), CIV.AdmitDate, 100), 7)), 7), 'AM', ' AM'), 'PM', ' PM') AS FAdmitTime  
   ,REPLACE(REPLACE(RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR(20), CIV.DischargedDate, 100), 7)), 7), 'AM', ' AM'), 'PM', ' PM') AS FDischargeTime  
   ,CONVERT(VARCHAR(20), CIV.AdmitDecision, 101) AS AdmitDecisionDate  
   ,CONVERT(VARCHAR(20), CIV.EmergencyRoomArrival, 101) AS EmergencyRoomArrivalDate  
   ,REPLACE(REPLACE(RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR(20), CIV.AdmitDecision, 100), 7)), 7), 'AM', ' AM'), 'PM', ' PM') AS FAdmitDecisionTime  
   ,REPLACE(REPLACE(RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR(20), CIV.EmergencyRoomArrival, 100), 7)), 7), 'AM', ' AM'), 'PM', ' PM') AS FEmergencyRoomArrivalTime  
   ,GC.CodeName AS StatusCode  
   ,CIV.AdmissionType  
   ,CIV.DRGCode  
   ,CIV.DischargeType  
   -- 21 Oct 2014 Akwinass  
   ,CIV.EmergencyRoomDeparture  
   ,REPLACE(REPLACE(RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR(20), CIV.EmergencyRoomDeparture, 100), 7)), 7), 'AM', ' AM'), 'PM', ' PM') AS FEmergencyRoomDepartureTime  
   ,CIV.AdmissionSource  
  --RIGHT( LTRIM(RIGHT(CONVERT(VARCHAR(20),CIV.AdmitDate,100),8)),7) AS FAdmitTime,        
  --RIGHT( LTRIM(RIGHT(CONVERT(VARCHAR(20),CIV.DischargedDate,100),8)),7) AS FDischargedTime    
     ,CIV.PhysicianId  -- 18 Jan 2016, Seema   
     ,CIV.ClinicianId --18 Jan 2016, Seema  
   -- 01-AUG-2016 Akwinass
   ,CIV.BedProcedureCodeId
   ,CIV.LeaveProcedureCodeId  
  FROM ClientInpatientVisits AS CIV  
  INNER JOIN Clients AS C ON CIV.ClientId = C.ClientId  
  INNER JOIN GlobalCodes GC ON CIV.Status = GC.GlobalcodeId  
  WHERE (ISNULL(CIV.RecordDeleted, 'N') = 'N')  
   AND (ISNULL(C.RecordDeleted, 'N') = 'N')  
   AND (CIV.ClientInpatientVisitId = @ClientInpatientVisitId);--IN                            
   --        (SELECT     ClientInpatientVisitId                            
   --  FROM         BedAssignments                            
   --  WHERE     (BedAssignmentId = @BedAssignmentId)))                            
  
  -- RECORDS FROM BedAssignments                            
  WITH BedAssignments_cte (  
   BedAssignmentId  
   ,NextBedAssignmentId  
   )  
  AS (  
   SELECT BedAssignmentId  
    ,NextBedAssignmentId  
   FROM BedAssignments AS BA  
   WHERE (ClientInpatientVisitId = @ClientInpatientVisitId)  
     
   UNION ALL  
     
   SELECT BA.BedAssignmentId  
    ,BA.NextBedAssignmentId  
   FROM BedAssignments AS BA  
   INNER JOIN BedAssignments_cte AS BA1 ON BA1.NextBedAssignmentId = BA.BedAssignmentId  
   WHERE (ISNULL(BA.RecordDeleted, 'N') = 'N')  
   )  
  SELECT DISTINCT (BA.BedAssignmentId)  
   ,BA.ClientInpatientVisitId  
   ,BA.BedId  
   ,BA.StartDate  
   ,BA.EndDate  
   ,BA.ArrivalDate  
   ,BA.ExpectedDischargeDate  
   ,BA.Status  
   ,BA.Type  
   ,GlobalCodes.CodeName AS BedType  
   ,BA.Reason  
   ,BA.Active  
   ,BA.NotBillable  
   ,BA.ProgramId  
   ,Programs.ProgramName  
   ,BP.ProgramId AS BedProgramId  
   ,BP.ProgramName AS BedProgramName  
   ,BA.LocationId  
   ,BA.ProcedureCodeId  
   ,BA.BedNotAvailable  
   ,BA.Disposition  
   ,--GC.CodeName AS Disposition,            
   BA.Overbooked  
   ,BA.Priority  
   ,BA.LastServiceCreationDate  
   ,BA.Comment  
   ,BA.NextBedAssignmentId  
   ,BA.CreatedBy  
   ,BA.CreatedDate  
   ,BA.ModifiedBy  
   ,BA.ModifiedDate  
   ,BA.RecordDeleted  
   ,BA.DeletedDate  
   ,BA.DeletedBy  
   ,Units.DisplayAs AS UnitName  
   ,Rooms.RoomName  
   ,Beds.BedName + ' (' + BP.ProgramName + ') ' AS BedName  
   ,Beds.DisplayAs + ' (' + BP.ProgramName + ') ' AS DisplayAs  
   ,Rooms.UnitId  
   ,Rooms.RoomId  
   ,GCR.CodeName ReasonName  
   ,GS.CodeName AS StatusName  
   ,GC.CodeName AS DispositionName   
   ,Beds.BedName AS FBedName  
   ,BA.Comment  
   ,CIV.ClientType  
   ,ddo.DropdownOptions AS DropdownOptions  
  FROM Beds  
  INNER JOIN BedAssignments BA ON BA.BedId = Beds.BedId  
  INNER JOIN Rooms ON Beds.RoomId = Rooms.RoomId  
  INNER JOIN Units ON Rooms.UnitId = Units.UnitId  
  INNER JOIN Programs ON BA.ProgramId = Programs.ProgramId  
  --INNER JOIN dbo.BedAvailabilityHistory BAH ON (  --Lakshmi on 01-03-2017
  --  dbo.Beds.BedId = BAH.BedId  
  --  AND ISNULL(BAH.RecordDeleted, 'N') = 'N' 
    -- MSood 7/6/2016  
    --AND (  
    -- bah.EndDate IS NULL  
    -- OR bah.EndDate > GETDATE()  
    -- )  
   -- )  
  INNER JOIN Programs BP ON (BA.ProgramId = BP.ProgramId)  
  LEFT OUTER JOIN GlobalCodes ON BA.Type = GlobalCodes.GlobalCodeId  
  LEFT OUTER JOIN GlobalCodes GCR ON BA.Reason = GCR.GlobalCodeId  
  LEFT OUTER JOIN GlobalCodes GS ON BA.Status = GS.GlobalCodeId  
  LEFT OUTER JOIN GlobalCodes GC ON BA.Disposition = GC.GlobalCodeId  
  INNER JOIN BedAssignments_cte BA1 ON BA.BedAssignmentId = BA1.BedAssignmentId  
  INNER JOIN ClientInpatientVisits CIV ON CIV.ClientInpatientVisitId = BA.ClientInpatientVisitId  
  LEFT JOIN BedAssignments BA_Next ON (  
    BA.NextBedAssignmentId = BA_Next.BedAssignmentId  
    AND ISNULL(BA_Next.RecordDeleted, 'N') = 'N'  
    )  
  LEFT JOIN BedAssignments BA_Prev ON (  
    BA.BedAssignmentId = BA_Prev.NextBedAssignmentId  
    AND ISNULL(BA_Prev.RecordDeleted, 'N') = 'N'  
    )  
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
  OPTION (MAXRECURSION 10000);  
   --WHERE     (ISNULL(BedAssignments.RecordDeleted, 'N') = 'N') AND                          
   -- (BedAssignments.BedAssignmentId = @BedAssignmentId)                            
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error AS VARCHAR(8000);  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetBedBoardRecordsByClientInpatientID') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
 + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());  
  
  RAISERROR (  
    @Error  
    ,16  
    ,1  
    );-- Message text.  
 END CATCH  
END  
GO


