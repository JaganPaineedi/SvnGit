 IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[scsp_SCListStaffBasedOnStaffSuperviseesTargetSetup]')
                    AND type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE [dbo].[scsp_SCListStaffBasedOnStaffSuperviseesTargetSetup]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[scsp_SCListStaffBasedOnStaffSuperviseesTargetSetup]   
AS   
  /*   
  Date			Author    Description   
  22/09/2018    Vandana    We created this stored procedure to display clinical staff have a StaffTargetTemplates defined, As per              the task Spring River-Support Go Live #160   
  */   
  BEGIN   
      BEGIN try   
          CREATE TABLE #tempstaff   
            (   
               staffid INT,   
               result  NVARCHAR(max)   
            )   
  
          CREATE TABLE #tempstafftotal   
            (   
               total   DECIMAL(10, 2),   
               staffid INT   
            )   
  
          INSERT INTO #tempstaff   
          SELECT st1.staffid,   
                 [dbo].[Csfgethourscalculation](ST1.startdate, ST1.enddate,   
                 Isnull(ST1.productivitytargetid, 0),   
                 Isnull(ST1.offsetid1, 0), Isnull(ST1.offsetid2, 0),   
                 Isnull(ST1.offsetid3, 0),   
                 Isnull(ST1.additionaloffset, 0),   
                 Isnull(ST1.multiplieroffsetid, 0),   
                 Isnull(ST1.percentageworked, 0), Isnull   
                 (ST1.productivitytargetmultiplier, 0),   
                 Isnull(ST1.offset1multiplier, 0),   
                 Isnull(   
                 ST1.offset2multiplier, 0), Isnull(ST1.offset3multiplier, 0),   
                 'C')   
                 AS   
                 hours   
          FROM   stafftargettemplates ST1   
          WHERE  Isnull(st1.recorddeleted, 'N') = 'N'  
  
          ;WITH fianalresultset   
               AS (SELECT Substring(result, 1, CASE Charindex('=', result)   
                                                 WHEN 0 THEN Len(result)   
                                                 ELSE Charindex('=', result) - 1   
                                               END) AS Total,   
                          staffid   
                   FROM   #tempstaff)   
          INSERT INTO #tempstafftotal   
          SELECT total,   
                 staffid   
          FROM   fianalresultset   
          WHERE  Isnull(total, '') != ''   
  
          SELECT st.staffid,   
                 st.lastname,   
                 st.firstname,   
                 0 AS ActualHourToTargetRatioPeriodToDate,   
                 0 AS AverageLagPeriodToDate   
              FROM   Staff st
	INNER JOIN StaffSupervisors SS ON SS.StaffId = st.StaffId
	WHERE 
		 ISNULL(st.RecordDeleted, 'N') = 'N'
		AND ISNULL(SS.RecordDeleted, 'N') = 'N'
          --FROM   staff AS st   
          --WHERE  Isnull(st.recorddeleted, 'N') = 'N'   
                 AND st.active = 'Y'   
                 AND EXISTS(SELECT st1.staffid   
                            FROM   stafftargettemplates ST1   
                            WHERE  st.staffid = ST1.staffid   
                                   AND Isnull(st1.recorddeleted, 'N') = 'N')   
                 AND EXISTS(SELECT tmp.staffid   
                            FROM   #tempstafftotal tmp   
                            WHERE  st.staffid = tmp.staffid   
                                   AND tmp.total > 0)   
          ORDER  BY st.lastname,   
                    st.firstname ASC   
  
          DROP TABLE #tempstaff   
  
          DROP TABLE #tempstafftotal   
      END try   
  
      BEGIN catch   
          DECLARE @Error VARCHAR(8000)   
  
          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****'   
                       + CONVERT(VARCHAR(4000), Error_message())   
                       + '*****'   
                       + Isnull(CONVERT(VARCHAR, Error_procedure()),   
                       'scsp_SCListStaffBasedOnStaffSuperviseesTargetSetup')   
                       + '*****' + CONVERT(VARCHAR, Error_line())   
                       + '*****' + CONVERT(VARCHAR, Error_severity())   
                       + '*****' + CONVERT(VARCHAR, Error_state())   
  
          RAISERROR ( @Error,-- Message text.          
                      16,-- Severity.          
                      1 -- State.          
          );   
      END catch   
  END   