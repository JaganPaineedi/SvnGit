/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedCensusRecordsByClientInpatientID]    Script Date: 11/13/2012 3:25:52 PM ******/
IF EXISTS ( SELECT  1
            FROM    INFORMATION_SCHEMA.ROUTINES
            WHERE   SPECIFIC_SCHEMA = 'dbo'
                    AND SPECIFIC_NAME = 'ssp_SCGetBedCensusRecordsByClientInpatientID' ) 
    DROP PROCEDURE [dbo].[ssp_SCGetBedCensusRecordsByClientInpatientID]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetBedCensusRecordsByClientInpatientID]    Script Date: 11/13/2012 3:25:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_SCGetBedCensusRecordsByClientInpatientID] --70                     
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
/*       01/Sep/2010 Sumanta  Implement recursive look up to fetch next bed */
/*       2012-07-12 Chuck Blaine  Added BedProgramId/BedProgramName, changed BedName to use availability program instead of assignment */                  
/*       Nov 13 2012 Chuck Blaine  Fixed join to bed availability history and added Display value for bed name */
/*       Aug 07 2014 Chethan N	   What :  RowIdentifier removed from ClientInpatientVisits
								   Why : Core Bugs task # 1851 */      
/****************************************************************************/                      
    BEGIN                            
        BEGIN TRY                    
 -- RECORDS FROM ClientInpatientVisits                    
            SELECT  CIV.ClientInpatientVisitId ,
                    CIV.ClientId ,
                    CIV.Status ,
                    CIV.RequestedDate ,
                    CIV.ScheduledDate ,
                    CIV.AdmitDate ,
                    CIV.DischargedDate ,
                    --CIV.RowIdentifier ,
                    CIV.CreatedBy ,
                    CIV.CreatedDate ,
                    CIV.ModifiedBy ,
                    CIV.ModifiedDate ,
                    CIV.RecordDeleted ,
                    CIV.DeletedDate ,
                    CIV.DeletedBy ,
                    C.LastName ,
                    C.FirstName ,
                    ( C.LastName + ', ' + C.FirstName ) AS ClientName ,
                    CONVERT(VARCHAR(20), CIV.RequestedDate, 101) AS FRequestedDate ,
                    CONVERT(VARCHAR(20), CIV.ScheduledDate, 101) AS FScheduledDate ,
                    CONVERT(VARCHAR(20), CIV.AdmitDate, 101) AS FAdmitDate ,
                    CONVERT(VARCHAR(20), CIV.DischargedDate, 101) AS FDischargedDate
            FROM    ClientInpatientVisits AS CIV
                    INNER JOIN Clients AS C ON CIV.ClientId = C.ClientId
            WHERE   ( ISNULL(CIV.RecordDeleted, 'N') = 'N' )
                    AND ( ISNULL(C.RecordDeleted, 'N') = 'N' )
                    AND ( CIV.ClientInpatientVisitId = @ClientInpatientVisitId );  --IN                    
 --        (SELECT     ClientInpatientVisitId                    
 --  FROM         BedAssignments                    
 --  WHERE     (BedAssignmentId = @BedAssignmentId)))                    
                     
                      
  -- RECORDS FROM BedAssignments                    
            WITH    BedAssignments_cte ( BedAssignmentId, NextBedAssignmentId )
                      AS ( SELECT   BedAssignmentId ,
                                    NextBedAssignmentId
                           FROM     BedAssignments AS BA
                           WHERE    ( ClientInpatientVisitId = @ClientInpatientVisitId )
                           UNION ALL
                           SELECT   BA.BedAssignmentId ,
                                    BA.NextBedAssignmentId
                           FROM     BedAssignments AS BA
                                    INNER JOIN BedAssignments_cte AS BA1 ON BA1.NextBedAssignmentId = BA.BedAssignmentId
                           WHERE    ( ISNULL(BA.RecordDeleted, 'N') = 'N' )
                         )
                SELECT  DISTINCT
                        ( BA.BedAssignmentId ) ,
                        BA.ClientInpatientVisitId ,
                        BA.BedId ,
                        BA.StartDate ,
                        BA.EndDate ,
                        BA.Status ,
                        BA.Type ,
                        GlobalCodes.CodeName AS BedType ,
                        BA.Reason ,
                        BA.Active ,
                        BA.NotBillable ,
                        BA.ProgramId ,
                        Programs.ProgramName ,
                        BP.ProgramId AS BedProgramId ,
                        BP.ProgramName AS BedProgramName ,
                        BA.LocationId ,
                        BA.ProcedureCodeId ,
                        BA.BedNotAvailable ,
                        BA.Disposition , --GC.CodeName AS Disposition,    
                        BA.Overbooked ,
                        BA.Priority ,
                        BA.LastServiceCreationDate ,
                        BA.Comment ,
                        BA.NextBedAssignmentId ,
                        BA.CreatedBy ,
                        BA.CreatedDate ,
                        BA.ModifiedBy ,
                        BA.ModifiedDate ,
                        BA.RecordDeleted ,
                        BA.DeletedDate ,
                        BA.DeletedBy ,
                        Units.UnitName ,
                        Rooms.RoomName ,
                        Beds.BedName + ' (' + BP.ProgramName + ') ' AS BedName ,
                        Beds.DisplayAs + ' (' + BP.ProgramName + ') ' AS DisplayAs ,
                        Rooms.UnitId ,
                        Rooms.RoomId ,
                        GCR.CodeName ReasonName ,
                        GS.CodeName AS StatusName
                FROM    Beds
                        INNER JOIN BedAssignments BA ON BA.BedId = Beds.BedId
                        INNER JOIN Rooms ON Beds.RoomId = Rooms.RoomId
                        INNER JOIN Units ON Rooms.UnitId = Units.UnitId
                        INNER JOIN Programs ON BA.ProgramId = Programs.ProgramId
                        INNER JOIN dbo.BedAvailabilityHistory BAH ON ( dbo.Beds.BedId = BAH.BedId
                                                              AND ( bah.EndDate IS NULL
                                                              OR bah.EndDate > GETDATE()
                                                              )
                                                              )
                        INNER JOIN Programs BP ON ( BAH.ProgramId = BP.ProgramId )
                        LEFT OUTER JOIN GlobalCodes ON BA.Type = GlobalCodes.GlobalCodeId
                        LEFT OUTER JOIN GlobalCodes GCR ON BA.Reason = GCR.GlobalCodeId
                        LEFT OUTER JOIN GlobalCodes GS ON BA.Status = GS.GlobalCodeId
                        LEFT OUTER JOIN GlobalCodes GC ON BA.Disposition = GC.GlobalCodeId
                        INNER JOIN BedAssignments_cte BA1 ON BA.BedAssignmentId = BA1.BedAssignmentId
            OPTION  ( MAXRECURSION 10000 );                  
 --WHERE     (ISNULL(BedAssignments.RecordDeleted, 'N') = 'N') AND                  
 -- (BedAssignments.BedAssignmentId = @BedAssignmentId)                    

        END TRY                    
        BEGIN CATCH                                
            IF ( @@error != 0 ) 
                BEGIN
                    RAISERROR  20006  'ssp_SCGetBedCensusRecordsByClientInpatientID: An Error Occured'
                    RETURN
                END                              
        END CATCH                    
                              
    END  
  
  



GO


