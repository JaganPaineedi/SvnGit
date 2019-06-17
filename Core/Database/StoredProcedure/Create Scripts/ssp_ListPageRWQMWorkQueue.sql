IF EXISTS 
( 
       SELECT * 
       FROM   sys.objects 
       WHERE  object_id = Object_id(N'[ssp_ListPageRWQMWorkQueue]') 
       AND    type IN (N'P', 
                       N'PC')) 
DROP PROCEDURE [ssp_ListPageRWQMWorkQueue]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ssp_ListPageRWQMWorkQueue]
@PageNumber      INT, 
  @PageSize              INT, 
  @SortExpression        VARCHAR(100), 
  @DueDateFrom           DATETIME, 
  @DueDateTo             DATETIME, 
  @Payers                INT, 
  @Actions               INT, 
  @Purpose               VARCHAR(1), 
  @ToDo                  VARCHAR(1), 
  @Plans                 INT, 
  @RWQMRules             INT, 
  @OrganizationHierarchy VARCHAR(MAX), 
  @Staff                 INT, 
  @ClientId              INT, 
  @ChargeStatus			 INT,
  @OtherFilter           INT,
  @AssignedTo			 INT=NULL,
  @LogInStaffId			 INT=NULL  
/********************************************************************************                                                          
-- Stored Procedure: dbo.ssp_ListPageRWQMWorkQueue                                                            
--                                                          
-- Copyright: Streamline Healthcate Solutions                                                          
--                                                          
-- Purpose: RWQM Work Queue List Page - AHN - Customizations: Task# 44   
-- Created By	: Malathi Shiva 
-- Created Date	: 10/July/2017                                                
--                                                          
-- Updates:                                                                                                                 
-- Date        Author      Purpose           
27/07/2018	   Bibhu       what:Added join with staffclients table to display associated clients for login staff  
          				   why:Engineering Improvement Initiatives- NBL(I) task #77                                              
*********************************************************************************/             

  AS 
BEGIN 
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
  BEGIN TRY 
    CREATE TABLE #ResultSet 
                 ( 
                              RowNumber                 INT , 
                              PageNumber                INT , 
                              RWQMWorkQueueId           INT , 
                              ClientId                  INT , 
                              ClientName                VARCHAR(250) , 
                              RWQMRuleId                INT , 
                              RWQMRuleName              VARCHAR(250) , 
                              FinancialAssignmentId     INT , 
                              AssignedStaff             VARCHAR(60) , 
                              BackUpStaff               VARCHAR(60) , 
                              ActionId                  INT , 
                              ActionName                VARCHAR(250) , 
                              ActionDate                DATETIME , 
                              ClientContactNoteId       INT , 
                              ClientContactNoteDateTime DATETIME , 
                              CoveragePlanId            INT , 
                              CoveragePlanName          VARCHAR(250) , 
                              ChargeId                  INT , 
                              Charge                    MONEY , 
                              DateOfService             DATETIME , 
                              Balance                   MONEY , 
                              BillDate                  DATETIME , 
                              DueDate                   DATETIME ,
                              ServiceId					INT,
                              ChargeStatus				INT,
                              ChargeStatusName			VARCHAR(250)
                 ) 
    DECLARE @CUSTOMFILTERS TABLE 
                                 ( 
                                                              RWQMWorkQueueId INT 
                                 ) 
    DECLARE @ApplyFilterClicked   CHAR(1) 
    DECLARE @CustomFiltersApplied CHAR(1) 
    DECLARE @StartDate            DATETIME 
    IF ISNULL(@SortExpression, '') = '' 
    SET @SortExpression= 'DueDate Desc' 
    -- 
    -- New retrieve - the request came by clicking on the Apply Filter button 
    -- 
    SET @ApplyFilterClicked = 'Y' 
    SET @CustomFiltersApplied = 'N' 
    --set @PageNumber = 1 
    -- 
    -- Run custom logic if any custom filter passed 
    -- 
    
	--IF( @DueDateFrom = CONVERT(DATETIME, N'') )    
 --  BEGIN    
	--SET @DueDateFrom = NULL    
	--END    
      
	--IF( @DueDateTo = CONVERT(DATETIME, N'') )    
 --  BEGIN    
	--SET @DueDateTo = NULL    
	--END    
  
      IF @OtherFilter > 10000 
    BEGIN 
      SET @CustomFiltersApplied = 'Y' 
      INSERT INTO @CustomFilters 
                  ( 
                              RWQMWorkQueueId 
                  ) 
      EXEC Scsp_listpagerwqmworkqueue 
        @DueDateFrom = @DueDateFrom, 
        @DueDateTo = @DueDateTo, 
        @Payers= @Payers, 
        @Actions=@Actions, 
        @Purpose=@Purpose, 
        @ToDo=@ToDo, 
        @Plans=@Plans, 
        @RWQMRules=@RWQMRules, 
        @OrganizationHierarchy=@OrganizationHierarchy, 
        @Staff=@Staff, 
        @ClientId=@ClientId, 
        @ChargeStatus = @ChargeStatus,
        @OtherFilter =@OtherFilter 
    END 
    INSERT INTO #ResultSet 
                ( 
                            RWQMWorkQueueId , 
                            ClientId , 
                            ClientName , 
                            RWQMRuleId , 
                            RWQMRuleName , 
                            FinancialAssignmentId , 
                            AssignedStaff , 
                            BackUpStaff , 
                            ActionId , 
                            ActionName , 
                            ActionDate , 
                            ClientContactNoteId , 
                            ClientContactNoteDateTime , 
                            CoveragePlanId , 
                            CoveragePlanName , 
                            ChargeId , 
                            Charge , 
                            DateOfService , 
                            Balance , 
                            BillDate , 
                            DueDate ,
                            ServiceId,
                            ChargeStatus,
							ChargeStatusName
                ) 
    SELECT   Distinct  RWQM.RWQMWorkQueueId , 
               S.ClientId , 
               C.LastName + ', ' + C.FirstName AS ClientName , 
               RWQM.RWQMRuleId , 
               RR.RWQMRuleName , 
               RWQM.FinancialAssignmentId , 
               S1.LastName + ', ' + S1.FirstName AS AssignedStaff , 
               S2.LastName + ', ' + S2.FirstName AS BackUpStaff , 
               RWQM.RWQMActionId , 
               Ac.ActionName , 
               RWQM.CompletedDate AS ActionDate , 
               RWQM.ClientContactNoteId , 
               CCN.ContactDateTime AS ClientContactNoteDateTime , 
               CP.CoveragePlanId , 
               CP.CoveragePlanName , 
               CH.ChargeId , 
               S.Charge , 
               S.DateOfService , 
               null AS Balance , 
               ISNULL(CH.LastBilledDate,CH.FirstBilledDate) AS BillDate , 
               RWQM.DueDate,
               S.ServiceId,
               CH.ChargeStatus,
               GC.CodeName AS ChargeStatusName
    FROM       RWQMWorkQueue RWQM 
    INNER JOIN Charges CH ON         RWQM.ChargeId = CH.ChargeId AND ISNULL(CH.RecordDeleted, 'N') = 'N' 
    INNER JOIN Services S ON         S.ServiceId = CH.ServiceId     AND        ISNULL(S.RecordDeleted, 'N') = 'N' 
    INNER JOIN Clients C  ON         S.ClientId = C.ClientId     AND        ISNULL(C.RecordDeleted, 'N') = 'N' 
    INNER JOIN StaffClients SC  ON   C.ClientId = SC.ClientId  AND SC.StaffId=@LogInStaffId      ----- 27/07/2018	   Bibhu 
    INNER JOIN RWQMRules RR ON         RR.RWQMRuleId = RWQM.RWQMRuleId     AND        ISNULL(RR.RecordDeleted, 'N') = 'N' 
    LEFT JOIN  ClientContactNotes CCN  ON         CCN.ClientContactNoteId = RWQM.ClientContactNoteId  AND ISNULL(CCN.RecordDeleted, 'N') = 'N' 
    LEFT JOIN RWQMClientContactNotes RWQMCCN  ON RWQMCCN.ClientContactNoteId = CCN.ClientContactNoteId AND ISNULL(RWQMCCN.RecordDeleted, 'N') = 'N' 
    INNER JOIN  FinancialAssignments FA ON         FA.FinancialAssignmentId = RWQM.FinancialAssignmentId   
			  AND		   ISNULL(FA.RecordDeleted, 'N') = 'N'
    INNER JOIN  Staff S1 ON         S1.staffId = RWQM.RWQMAssignedId    AND        ISNULL(S1.RecordDeleted, 'N') = 'N' 
    LEFT JOIN  Staff S2 ON         S2.staffId = RWQM.RWQMAssignedBackupId AND ISNULL(S2.RecordDeleted, 'N') = 'N' 
    LEFT JOIN  RWQMActions Ac ON         Ac.RWQMActionId = RWQM.RWQMActionId AND ISNULL(Ac.RecordDeleted, 'N') = 'N'
    LEFT JOIN  ClientCoveragePlans CCP ON         CCP.ClientCoveragePlanId = CH.ClientCoveragePlanId AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
    LEFT JOIN  CoveragePlans CP ON         CP.CoveragePlanId = CCP.CoveragePlanId AND ISNULL(CP.RecordDeleted, 'N') = 'N'  
    LEFT JOIN ClientPrograms CLP ON CLP.ProgramId = S.ProgramId and CLP.ClientId = S.ClientId  AND ISNULL(CLP.RecordDeleted, 'N') = 'N' 
    LEFT JOIN StaffSupervisors SS ON SS.StaffId = CLP.AssignedStaffId OR SS.SupervisorId = CLP.AssignedStaffId AND ISNULL(SS.RecordDeleted, 'N') = 'N' 
    LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CH.ChargeStatus AND GC.Active = 'Y'   AND ISNULL(GC.RecordDeleted, 'N') = 'N'
    WHERE   ((@CustomFiltersApplied = 'Y' and exists(select * from @CustomFilters cf where cf.RWQMWorkQueueId = RWQM.RWQMWorkQueueId)) OR
    (@CustomFiltersApplied = 'N'  and
        ISNULL(RWQM.RecordDeleted, 'N') = 'N'       
    AND (ISNULL(@DueDateFrom, '')  = '' OR RWQM.DueDate >= @DueDateFrom) AND     
       (ISNULL(@DueDateTo, '')  = '' OR RWQM.DueDate <= @DueDateTo)  
               
   AND        (ISNULL(@Payers, -1) = -1 OR CP.PayerId = @Payers ) 
   AND        (ISNULL(@Actions, -1) = -1 OR RWQM.RWQMActionId = @Actions ) 
	
	AND        (ISNULL(@Purpose, 'B') = 'B'OR --   Both
               (@Purpose = 'L' AND FA.ListPageFilter = 'Y') OR --   List Page Filter
               (@Purpose = 'R' AND FA.RevenueWorkQueueManagement = 'Y') ) --   RWQM 
                              
    AND        (ISNULL(@ToDo, 'B') = 'B'OR --   To Do and Completed 
               (@ToDo = 'T' AND RWQM.RWQMActionId IS NULL) OR --   To Do 
               (@ToDo = 'C' AND RWQM.RWQMActionId IS NOT NULL ) ) --   Completed 
               
    AND        (ISNULL(@Plans, -1) = -1 OR CP.CoveragePlanId = @Plans) 
    AND        (ISNULL(@RWQMRules, -1) = -1 OR RWQM.RWQMRuleId = @RWQMRules ) 
    
    AND		   (ISNULL(@OrganizationHierarchy, '') = '' OR CLP.ProgramId in (select item from [dbo].fnSplit(@OrganizationHierarchy,',')))
              -- OR SS.SupervisorId in (select item from [dbo].fnSplit(@OrganizationHierarchy,',')) ) 
           

 
    AND        ( ISNULL(@Staff, -1) = -1 OR RWQM.RWQMAssignedId = @Staff OR RWQM.RWQMAssignedBackupId = @Staff ) 
    AND        (@ClientId = -1 OR S.ClientId = @ClientId ) 
    
    AND			(ISNULL(@ChargeStatus, -1) = -1 OR CH.ChargeStatus = @ChargeStatus )
    --AND			(ISNULL(@AssignedTo, -1) = -1 OR CCN.AssignedTo = @AssignedTo ) 
    AND			(ISNULL(@AssignedTo, -1) = -1 OR RWQM.RWQMAssignedId = @AssignedTo ) 
    )
  )
  
  	UPDATE r
		SET r.Balance = l.Balance
		FROM #ResultSet r
		JOIN (
			SELECT arl.ChargeId
				,SUM(arl.Amount) AS Balance
			FROM #ResultSet t1
			JOIN ARLedger arl ON t1.ChargeId = arl.ChargeId 
			WHERE ISNULL(arl.RecordDeleted, 'N') = 'N'
			GROUP BY arl.ChargeId
			) l ON l.ChargeId = r.ChargeId
			            
;WITH counts AS 
    ( 
           SELECT COUNT(*) AS totalrows 
           FROM   #ResultSet), RankResultSet AS 
    ( 
             SELECT   RWQMWorkQueueId , 
                      ClientId , 
                      ClientName , 
                      RWQMRuleId , 
                      RWQMRuleName , 
                      FinancialAssignmentId , 
                      AssignedStaff , 
                      BackUpStaff , 
                      ActionId , 
                      ActionName , 
                      ActionDate , 
                      ClientContactNoteId , 
                      ClientContactNoteDateTime , 
                      CoveragePlanId , 
                      CoveragePlanName , 
                      ChargeId , 
                      Charge , 
                      DateOfService , 
                      Balance , 
                      BillDate , 
                      DueDate , 
                      ServiceId,
                      ChargeStatus,
					  ChargeStatusName,
                      COUNT(*) OVER ( ) AS TotalCount , 
                      Rank() OVER ( ORDER BY 
                      CASE 
                               WHEN @SortExpression= 'ClientName' THEN ClientName 
                      END, 
                      CASE 
                               WHEN @SortExpression = 'ClientName desc' THEN ClientName 
                      END DESC, 
                      CASE 
                               WHEN @SortExpression= 'RWQMRuleName' THEN RWQMRuleName 
                      END, 
                      CASE 
                               WHEN @SortExpression= 'RWQMRuleName desc' THEN RWQMRuleName 
                      END DESC, 
                      CASE 
                               WHEN @SortExpression= 'AssignedStaff' THEN AssignedStaff 
                      END, 
                      CASE 
                               WHEN @SortExpression= 'AssignedStaff desc' THEN AssignedStaff 
                      END DESC, 
                      CASE 
                               WHEN @SortExpression= 'BackUpStaff' THEN BackUpStaff 
                      END, 
                      CASE 
                               WHEN @SortExpression= 'BackUpStaff desc' THEN BackUpStaff 
                      END DESC, 
                      CASE 
                               WHEN @SortExpression= 'ActionName' THEN ActionName 
                      END, 
                      CASE 
                               WHEN @SortExpression = 'ActionName desc' THEN ActionName 
                      END DESC, 
                      CASE 
                               WHEN @SortExpression= 'ActionDate' THEN ActionDate 
                      END, 
                      CASE 
                               WHEN @SortExpression= 'ActionDate desc' THEN ActionDate 
                      END DESC, 
                      CASE 
                               WHEN @SortExpression= 'ClientContactNoteDateTime' THEN ClientContactNoteDateTime
                      END, 
                      CASE 
                               WHEN @SortExpression= 'ClientContactNoteDateTime desc' THEN ClientContactNoteDateTime
                      END DESC , 
                      CASE 
                               WHEN @SortExpression= 'CoveragePlanName' THEN CoveragePlanName 
                      END, 
                      CASE 
                               WHEN @SortExpression= 'CoveragePlanName desc' THEN CoveragePlanName
                      END DESC, 
                      CASE 
                               WHEN @SortExpression = 'Charge' THEN Charge 
                      END, 
                      CASE 
                               WHEN @SortExpression= 'Charge desc' THEN Charge 
                      END DESC, 
					  CASE 
                               WHEN @SortExpression = 'ChargeID' THEN ChargeID 
                      END, 
                      CASE 
                               WHEN @SortExpression= 'ChargeID desc' THEN ChargeID 
                      END DESC, 
                      CASE 
                               WHEN @SortExpression= 'Balance' THEN Balance 
                      END, 
                      CASE 
                               WHEN @SortExpression= 'Balance desc' THEN Balance 
                      END DESC, 
                      CASE 
                               WHEN @SortExpression= 'BillDate' THEN BillDate 
                      END, 
                      CASE 
                               WHEN @SortExpression= 'BillDate desc' THEN BillDate 
                      END DESC, 
                      CASE 
                               WHEN @SortExpression= 'DueDate' THEN DueDate 
                      END, 
                      CASE 
                               WHEN @SortExpression= 'DueDate desc' THEN DueDate 
                      END DESC, 
                      CASE 
                               WHEN @SortExpression= 'ChargeStatusName' THEN ChargeStatusName 
                      END, 
                      CASE 
                               WHEN @SortExpression= 'ChargeStatusName desc' THEN ChargeStatusName 
                      END DESC,RWQMWorkQueueId ) AS RowNumber 
             FROM     #ResultSet) 
    SELECT TOP ( CASE 
    WHEN ( 
                  @PageNumber = -1) THEN 
           ( 
                  SELECT ISNULL(totalrows, 0) 
                  FROM   counts) 
    ELSE ( @PageSize) 
END) RWQMWorkQueueId , 
ClientId , 
ClientName , 
RWQMRuleId , 
RWQMRuleName , 
FinancialAssignmentId , 
AssignedStaff , 
BackUpStaff , 
ActionId , 
ActionName , 
ActionDate , 
ClientContactNoteId , 
ClientContactNoteDateTime , 
CoveragePlanId , 
CoveragePlanName , 
ChargeId , 
Charge , 
DateOfService , 
Balance , 
BillDate , 
DueDate ,
ServiceId, 
ChargeStatus,
ChargeStatusName,
RowNumber , 
TotalCount 
INTO   #FinalResultSet 
FROM   RankResultSet 
WHERE  RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 
IF 
    ( 
    SELECT ISNULL(COUNT(*), 0) 
    FROM   #FinalResultSet) < 1 
BEGIN 
  SELECT 0 AS PageNumber , 
         0 AS NumberOfPages , 
         0    NumberOfRows 
END 
ELSE 
BEGIN 
  SELECT TOP 1 
         @PageNumber AS PageNumber , 
         CASE ( TotalCount % @PageSize ) 
                WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0) 
                ELSE ISNULL(( TotalCount        / @PageSize ), 0) + 1 
         END                   AS NumberOfPages , 
         ISNULL(TotalCount, 0) AS NumberOfRows 
  FROM   #FinalResultSet 
END 
SELECT   RWQMWorkQueueId , 
         ClientId , 
         ClientName,
         RWQMRuleId , 
         RWQMRuleName , 
         FinancialAssignmentId , 
         AssignedStaff , 
         BackUpStaff , 
         ActionId , 
         ActionName , 
         ActionDate , 
         ClientContactNoteId , 
         ClientContactNoteDateTime , 
         CoveragePlanId , 
         CoveragePlanName , 
         ChargeId , 
         Charge , 
         DateOfService , 
         Balance , 
         BillDate , 
         CONVERT(VARCHAR(10),DueDate,101) AS DueDate,
         ServiceId,
         ChargeStatus,
		 ChargeStatusName
FROM     #FinalResultSet 
ORDER BY RowNumber
 
         
DROP TABLE #ResultSet 
DROP TABLE #FinalResultSet 
END TRY 
BEGIN CATCH 
  DECLARE @Error VARCHAR(8000) 
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_ListPageRWQMWorkQueue') + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR,ERROR_STATE())
  RAISERROR ( @Error, -- Message text. 
  16,                 -- Severity. 
  1                   -- State. 
  ); 
END CATCH 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
GO