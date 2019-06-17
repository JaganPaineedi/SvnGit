/****** Object:  StoredProcedure [dbo].[ssp_GetClientInPatientVisitDetails]    Script Date: 11/10/2015 11:09:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/********************************************************************************                                                       
-- Stored Procedure: ssp_GetClientInPatientVisitDetails               
--               
-- Copyright: Streamline Healthcare Solutions               
--               
-- Purpose: To Retrieve Data From ClientInPatientVisit Table            
--               
-- Author:  Malathi Shiva               
-- Date:    27 June 2012               
-- 11/10/2015 JHB - Added record deleted check
*********************************************************************************/   
ALTER PROCEDURE [dbo].[ssp_GetClientInPatientVisitDetails]
    @ClientId INT ,
    @SortExpression VARCHAR(100)
AS
    DECLARE @ResultSet TABLE
        (
          ClientInpatientVisitId INT ,
          ClientId INT ,
          [Status] INT ,
          CodeName VARCHAR(250) ,
          ProgramId INT ,
          ProgramName VARCHAR(250) ,
          RequestedDate DATETIME ,
          ScheduledDate DATETIME ,
          AdmitDate DATETIME ,
          DischargedDate DATETIME ,
          BedAssignmentId INT
        )   
  
    BEGIN   
        BEGIN TRY   
        
            SET @SortExpression = RTRIM(LTRIM(@SortExpression))  
            IF ISNULL(@SortExpression, '') = ''
                SET @SortExpression = 'ProgramName'  
     
            INSERT  INTO @ResultSet
                    ( ClientInpatientVisitId ,
                      ClientId ,
                      [Status] ,
                      CodeName ,
                      ProgramId ,
                      ProgramName ,
                      RequestedDate ,
                      ScheduledDate ,
                      AdmitDate ,
                      DischargedDate ,
                      BedAssignmentId
                    )
                    SELECT  CIP.ClientInpatientVisitId ,
                            CIP.ClientId ,
                            CIP.[Status] ,
                            GC.CodeName ,
                            BA.ProgramId ,
                            P.ProgramName ,
                            CIP.RequestedDate ,
                            CIP.ScheduledDate ,
                            CIP.AdmitDate ,
                            CIP.DischargedDate ,
                            BA.BedAssignmentId
                    FROM    ClientInpatientVisits CIP
                            JOIN GlobalCodes GC ON CIP.[Status] = GC.GlobalCodeId
                            JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CIP.ClientInpatientVisitId
                                                      AND BA.NextBedAssignmentID IS NULL  
                   -- JHB 11/10/2015
                                                      AND ISNULL(BA.RecordDeleted, 'N') = 'N'
                            JOIN Programs P ON BA.ProgramId = P.ProgramId
                    WHERE   ISNULL(CIP.RecordDeleted, 'N') = 'N'
                            AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                            AND ClientId = @ClientId   
                   
                   
            SELECT  ClientInpatientVisitId ,
                    ClientId ,
                    [Status] AS StatusId ,
                    CodeName AS [Status] ,
                    ProgramId ,
                    ProgramName ,
                    RequestedDate ,
                    ScheduledDate ,
                    AdmitDate ,
                    DischargedDate ,
                    BedAssignmentId ,
                    COUNT(*) OVER ( ) AS TotalCount ,
                    ROW_NUMBER() OVER ( ORDER BY CASE WHEN @SortExpression = 'ProgramName' THEN ProgramName
                                                 END, CASE WHEN @SortExpression = 'ProgramName DESC' THEN ProgramName
                                                      END DESC, CASE WHEN @SortExpression = 'Status' THEN [Status]
                                                                END, CASE WHEN @SortExpression = 'Status DESC' THEN [Status]
                                                                     END DESC, CASE WHEN @SortExpression = 'AdmitDate' THEN AdmitDate
                                                                               END, CASE WHEN @SortExpression = 'AdmitDate DESC' THEN AdmitDate
                                                                                    END DESC, ClientInpatientVisitId ) AS RowNumber
            FROM    @ResultSet  
       
  
          --SELECT *   
          --FROM   @ResultSet   
            
            SELECT  0 AS PageNumber ,
                    0 AS NumberOfPages ,
                    ( SELECT    COUNT(*)
                      FROM      @ResultSet
                    ) AS NumberOfRows  
        END TRY   
  
        BEGIN CATCH   
            DECLARE @Error VARCHAR(8000)   
  
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientInPatientVisitDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())   
  
            RAISERROR ( @Error,   
                      -- Message text.                                                                                                                                                   
                      16,   
                      -- Severity.                                                                                                                                                                                                                            
            
                      1   
          -- State.                                                      
          );   
        END CATCH   
    END 
GO
