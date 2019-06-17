
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_SCAddCOBOrderAutomate]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ssp_SCAddCOBOrderAutomate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCAddCOBOrderAutomate] @ClientId             INT, 
                                            @ClientCoveragePlanId INT, 
                                            @StartDate            DATETIME, 
                                            @EndDate              DATETIME, 
                                            @COBOrder             INT, 
                                            @UserCode             VARCHAR(30), 
                                            @ServiceAreaId        INT 
AS 

/******************************************************************************   
**  File: dbo.ssp_SCAddCOBOrderAutomate.prc    
**  Name: Add COB   
**  Desc:    
**   
**  This template can be customized:   
**                 
**  Return values:   
**    
**  Called by:      
**                 
**  Parameters:   
**  Input       Output   
**       --------      -----------   
**   
**  Auth:    
**  Date:    
*******************************************************************************   
**  Change History   
*******************************************************************************   
**  Date:        Author:      Description:   
**  --------    --------    -------------------------------------------   
**  
    24/06/2015  Shruthi.S   Added logic to automate COBorder updation based on COBPriority.Ref:#2 CEI - Customizations.
    14/06/2016  Shruthi.S   Added new functionality when the enddate is null.Ref : #69 CEI - Support Go Live.
    JUL-7-2016  Dknewtson   One temp2 case was causing overlapping date ranges.  Replaced set for @InsertEndDate from @NextStartDate to Dateadd(day,-1,@NextStartDate)
*******************************************************************************/ 
  SET ansi_warnings OFF 

  SET @StartDate = CAST(@StartDate AS DATE)
  SET @EndDate = CAST(@EndDate AS DATE)
  
  

  CREATE TABLE #temp1 
    ( 
       clientcoveragehistoryid INT NULL, 
       clientcoverageplanid    INT NOT NULL, 
       startdate               DATETIME NOT NULL, 
       enddate                 DATETIME NULL, 
       coborder                INT NOT NULL, 
       serviceareaid           INT ,
       COBPriority             INT
    ) 

  CREATE TABLE #temp2 
    ( 
       clientcoveragehistoryid INT NULL, 
       clientcoverageplanid    INT NOT NULL, 
       startdate               DATETIME NOT NULL, 
       enddate                 DATETIME NULL, 
       coborder                INT NOT NULL, 
       serviceareaid           INT 
    ) 
    
    --Declared a COBOrder
  
  Declare @COBOrderPara int
  set @COBOrderPara = @COBOrder

  IF @COBOrder IS NULL 
    SET @COBOrder = 1 
  ---Check if CoveragePlan exist with COBOrder 1 with the same date range ----------
  Declare @COBOrderCount int
  set @COBOrderCount = 0
    SELECT @COBOrderCount = COUNT(*) 
             FROM   clientcoveragehistory a 
                    JOIN dbo.serviceareas b 
                      ON( a.serviceareaid = b.serviceareaid ) 
             WHERE  a.clientcoverageplanid = @ClientCoveragePlanId 
                    AND ( a.serviceareaid = @ServiceAreaId 
                           OR @ServiceAreaId IS NULL ) 
                    AND Isnull(a.recorddeleted, 'N') = 'N' 
                    AND ( a.startdate <= @EndDate 
                           OR @EndDate IS NULL ) 
                    AND ( a.enddate >= @StartDate 
                           OR a.enddate IS NULL )  AND a.COBOrder = 1 

  
  IF @COBOrder = 0 and @COBOrderCount < 1
    SET @COBOrder = 1      

  -- Check for coverage plan exists, if yes give error   
  
  IF EXISTS (SELECT * 
             FROM   clientcoveragehistory a 
                    JOIN dbo.serviceareas b 
                      ON( a.serviceareaid = b.serviceareaid ) 
             WHERE  a.clientcoverageplanid = @ClientCoveragePlanId 
                    AND ( a.serviceareaid = @ServiceAreaId 
                           OR @ServiceAreaId IS NULL ) 
                    AND Isnull(a.recorddeleted, 'N') = 'N' 
                    AND ( a.startdate <= @EndDate 
                           OR @EndDate IS NULL ) 
                    AND ( a.enddate >= @StartDate 
                           OR a.enddate IS NULL )) 
                    AND @COBOrderPara <> 0       
    BEGIN 
        RAISERROR 30001 'Coverage already exists for an overlapping date range.' 

        IF @@ERROR <> 0 
          GOTO error 
    END 
    
  

/*Debug select   
select @StartDate, @EndDate   
*/ 
  -- If there is no coverage plan then insert passed data as it is   
  IF NOT EXISTS (SELECT * 
                 FROM   clientcoverageplans b 
                        JOIN clientcoveragehistory a 
                          ON ( a.clientcoverageplanid = b.clientcoverageplanid ) 
                             AND ( a.serviceareaid = @ServiceAreaId 
                                    OR @ServiceAreaId IS NULL ) 
                 WHERE  b.clientid = @ClientId 
                        AND Isnull(a.recorddeleted, 'N') = 'N' 
                        AND Isnull(b.recorddeleted, 'N') = 'N' 
                        AND ( a.startdate <= @EndDate 
                               OR @EndDate IS NULL ) 
                        AND ( a.enddate >= @StartDate 
                               OR a.enddate IS NULL )) 
    --and not (a.EndDate < @StartDate or a.StartDate > @EndDate))   
    IF(@COBOrderCount < 1)
    BEGIN
		BEGIN 
			INSERT INTO clientcoveragehistory 
						(clientcoverageplanid, 
						 startdate, 
						 enddate, 
						 coborder, 
						 createdby, 
						 createddate, 
						 modifiedby, 
						 modifieddate, 
						 serviceareaid) 
			VALUES     (@ClientCoveragePlanId, 
						@StartDate, 
						@EndDate, 
						1, 
						@UserCode, 
						Getdate(), 
						@UserCode, 
						Getdate(), 
						@ServiceAreaId)
		END                    
        
        --19/02/2015------Akwinass----------------------------------------------------------------------------------------------------------------------            
        IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCManageClientCoveragePlanChangeLog]') AND type in (N'P', N'PC')) 
        BEGIN
			EXEC ssp_SCManageClientCoveragePlanChangeLog @ClientId,@ClientCoveragePlanId,@StartDate,@EndDate,1,@UserCode,@ServiceAreaId,'ADD',NULL
        END
		-------------------------------------------------------------------------------------------------------------------------------------------------
        IF @@ERROR <> 0 
          GOTO error 

        EXEC ssp_PMCombineCOBOrder
          @ClientId, 
          @StartDate, 
          @EndDate, 
          @UserCode,
          @ServiceAreaId 

        IF @@ERROR <> 0 
          GOTO error 

        RETURN 
    END 

  -- Get a list of all coverages that overlap the new coverage   
  INSERT INTO #temp1 
              (clientcoveragehistoryid, 
               clientcoverageplanid, 
               startdate, 
               enddate, 
               coborder, 
               serviceareaid,
               COBPriority) 
  SELECT  a.clientcoveragehistoryid, 
         a.clientcoverageplanid, 
         a.startdate, 
         a.enddate, 
         a.coborder, 
         a.serviceareaid,
         CP.COBPriority
  FROM   clientcoverageplans b 
         JOIN clientcoveragehistory a ON ( a.clientcoverageplanid = b.clientcoverageplanid ) 
         JOIN CoveragePlans CP ON (CP.CoveragePlanId = b.CoveragePlanId)
  WHERE  b.clientid = @ClientId 
         AND Isnull(a.recorddeleted, 'N') = 'N' 
         AND Isnull(b.recorddeleted, 'N') = 'N' 
         AND Isnull(CP.recorddeleted, 'N') = 'N' 
         AND b.clientcoverageplanid != @ClientCoveragePlanId 
         AND ( a.startdate <= @EndDate 
                OR @EndDate IS NULL ) 
         AND ( a.enddate >= @StartDate 
                OR a.enddate IS NULL ) 
         AND a.serviceareaid = @ServiceAreaId 
         Order by CP.COBPriority asc
         
        
         --Variable added to get the Maxorder from #temp1 which has the clientcoveragehistory based on conditions
         Declare @MaxCOBOrderTemp int
         select @MaxCOBOrderTemp = MAX(coborder) from #temp1
        
        
  /*Debug select   
  select * from #temp1   
  */ 
  IF @@ERROR <> 0 
    GOTO error 

  DECLARE @CoverageStartDate DATETIME, 
          @CoverageEndDate   DATETIME, 
          @MaxCOBOrder       INT, 
          @NextStartDate     DATETIME 
  DECLARE @PreviousEndDate DATETIME, 
          @InsertStartDate DATETIME, 
          @InsertEndDate   DATETIME, 
          @CombinedEndDate DATETIME 
   ---Declared a variable to set the MaxOrder from temp1
    
  Declare @MaxCOBOrderTemp1 int
  SELECT top 1 @MaxCOBOrderTemp1 = 
           Max(a.coborder)
    FROM   #temp1 a 
           LEFT JOIN #temp1 b 
             ON ( b.startdate > a.enddate 
                  AND a.enddate IS NOT NULL ) 
    GROUP  BY a.startdate, 
              a.enddate ,
              a.coborder
    ORDER  BY a.startdate ,a.coborder desc
       
      
       
       select a.startdate, 
           a.enddate, 
           MAX(a.coborder), 
           MIN(b.startdate) FROM   #temp1 a 
           LEFT JOIN #temp1 b 
             ON ( b.startdate > a.enddate 
                  AND a.enddate IS NOT NULL ) 
    GROUP  BY a.startdate, 
              a.enddate ,
              a.coborder
    ORDER  BY a.startdate ,a.coborder desc
          
  DECLARE cur_coveragedates1 CURSOR FOR 
    SELECT top 1 a.startdate, 
           a.enddate, 
           MAX(a.coborder), 
           MIN(b.startdate) 
    FROM   #temp1 a 
           LEFT JOIN #temp1 b 
             ON ( b.startdate > a.enddate 
                  AND a.enddate IS NOT NULL ) 
    GROUP  BY a.startdate, 
              a.enddate ,
              a.COBPriority ,
              a.coborder
    ORDER  BY a.startdate , a.COBPriority asc, a.coborder desc
    
    --Declared a variable to get the maxcoborder.
    

  IF @@ERROR <> 0 
    GOTO error 

  OPEN cur_coveragedates1 

  IF @@ERROR <> 0 
    GOTO error 

  FETCH cur_coveragedates1 INTO @CoverageStartDate, @CoverageEndDate, 
  @MaxCOBOrder, @NextStartDate 

  IF @@ERROR <> 0 
    GOTO error 
    
    --Added by Shruthi to check the exisitng count
    Declare @COBCountExisting Int
    set @COBCountExisting = 0
    SELECT @COBCountExisting = 
                    COUNT(*) 
             FROM   clientcoverageplans a 
                    JOIN clientcoveragehistory b 
                      ON ( a.clientcoverageplanid = b.clientcoverageplanid ) 
             WHERE  a.clientid = @ClientId 
                    AND ( b.serviceareaid = @ServiceAreaId 
                           OR @ServiceAreaId IS NULL ) 
                    AND Isnull(a.recorddeleted, 'N') = 'N' 
                    AND Isnull(b.recorddeleted, 'N') = 'N' 
             GROUP  BY b.startdate, 
                       b.coborder 
             HAVING COUNT(*) > 1
    
    --Modified to add a logic which checks for the coborder 1 count and then insert.

  WHILE @@FETCH_STATUS = 0 
    BEGIN 
   
        -- If current Start Date < @CoverageStartDate (date range gap) then insert record for date range   
        -- for current coverage with COBORder 1    
        IF @PreviousEndDate IS NULL 
           AND @StartDate < @CoverageStartDate 
           AND @COBOrderCount < 1 AND @COBCountExisting < 1
           
          BEGIN 
        
              INSERT INTO #temp2 
                          (clientcoverageplanid, 
                           startdate, 
                           enddate, 
                           coborder, 
                           serviceareaid) 
              VALUES      (@ClientCoveragePlanId, 
                           @StartDate, 
                           Dateadd(dd, -1, @CoverageStartDate), 
                           1, 
                           @ServiceAreaId) 
                           
       

              IF @@ERROR <> 0 
                GOTO error 

              SET @InsertStartDate = @CoverageStartDate 
              SET @InsertEndDate = CASE 
                                     WHEN @CoverageEndDate IS NULL THEN @EndDate 
                                     WHEN @EndDate IS NULL THEN @CoverageEndDate 
                                     WHEN @CoverageEndDate < @EndDate THEN 
                                     @CoverageEndDate 
                                     ELSE @EndDate 
                                   END 
          END 
        ELSE 
          IF @StartDate <= @CoverageStartDate 
            BEGIN 
                SET @InsertStartDate = @CoverageStartDate 
                SET @InsertEndDate = CASE 
                                       WHEN @CoverageEndDate < @EndDate 
                                             OR @EndDate IS NULL THEN 
                                       @CoverageEndDate 
                                       ELSE @EndDate 
                                     END 
            END 
          ELSE 
            BEGIN 
                SET @InsertStartDate = @CoverageStartDate 
                SET @InsertEndDate = Dateadd(dd, -1, @StartDate) 
            END 

    /*Debug select   
     select @InsertStartDate, @InsertEndDate   
    */ 
        -- Insert records for the coverage date range including 1 for the new coverage   
        IF @StartDate <= @InsertStartDate 
          BEGIN 
             
              INSERT INTO #temp2 
                          (clientcoveragehistoryid, 
                           clientcoverageplanid, 
                           startdate, 
                           enddate, 
                           coborder, 
                           serviceareaid) 
              SELECT clientcoveragehistoryid, 
                     clientcoverageplanid, 
                     @InsertStartDate, 
                     @InsertEndDate, 
                     CASE 
                       WHEN coborder < @COBOrder THEN coborder 
                       ELSE coborder + 1 
                     END, 
                     serviceareaid 
              FROM   #temp1 
              WHERE  startdate = @CoverageStartDate 
                     AND ( enddate = @CoverageEndDate 
                            OR ( enddate IS NULL 
                                 AND @CoverageEndDate IS NULL ) ) 
                     --AND (ClientCoveragePlanId = @ClientCoveragePlanId)
                     
          
                  --AND @COBOrderCount < 1 AND @COBCountExisting < 1
                  
              IF @@ERROR <> 0 
                GOTO error 
               
              INSERT INTO #temp2 
                          (clientcoverageplanid, 
                           startdate, 
                           enddate, 
                           coborder, 
                           serviceareaid) 
              VALUES      (@ClientCoveragePlanId, 
                           @InsertStartDate, 
                           @InsertEndDate, 
                           CASE 
                             WHEN @COBOrder > @MaxCOBOrderTemp1 THEN @MaxCOBOrderTemp1 + 1 
                             WHEN @MaxCOBOrderTemp1 = 1 THEN @MaxCOBOrderTemp1 + 1 
                             ELSE @MaxCOBOrderTemp1 + 1  
                           END, 
                           @ServiceAreaId) 
         
                

              IF @@ERROR <> 0 
                GOTO error 
          END 
        ELSE 
          BEGIN 
           
              INSERT INTO #temp2 
                          (clientcoveragehistoryid, 
                           clientcoverageplanid, 
                           startdate, 
                           enddate, 
                           coborder, 
                           serviceareaid) 
              SELECT clientcoveragehistoryid, 
                     clientcoverageplanid, 
                     @InsertStartDate, 
                     @InsertEndDate, 
                     coborder, 
                     serviceareaid 
              FROM   #temp1 
              WHERE  startdate = @CoverageStartDate 
                     AND ( enddate = @CoverageEndDate 
                            OR ( enddate IS NULL 
                                 AND @CoverageEndDate IS NULL ) )
                                 
         
                      -- AND @COBOrderCount < 1 AND @COBCountExisting < 1
              IF @@ERROR <> 0 
                GOTO error 
          END 

        IF @InsertEndDate = Dateadd(dd, -1, @CoverageStartDate) 
          BEGIN 
              SET @InsertStartDate = @CoverageStartDate 
              SET @InsertEndDate = CASE 
                                     WHEN @CoverageEndDate IS NULL 
                                           OR @CoverageEndDate > @EndDate THEN 
                                     @EndDate 
                                     ELSE @CoverageEndDate 
                                   END 
          
              INSERT INTO #temp2 
                          (clientcoveragehistoryid, 
                           clientcoverageplanid, 
                           startdate, 
                           enddate, 
                           coborder, 
                           serviceareaid) 
              SELECT clientcoveragehistoryid, 
                     clientcoverageplanid, 
                     @InsertStartDate, 
                     @InsertEndDate, 
                     CASE 
                       WHEN coborder < @COBOrder THEN coborder 
                       ELSE coborder + 1 
                     END, 
                     serviceareaid 
              FROM   #temp1 
              WHERE  startdate = @CoverageStartDate 
                     AND ( enddate = @CoverageEndDate 
                            OR ( enddate IS NULL 
                                 AND @CoverageEndDate IS NULL ) ) 
                                 
        
                        --  AND @COBOrderCount < 1 AND @COBCountExisting < 1
              IF @@ERROR <> 0 
                GOTO error 
             
              INSERT INTO #temp2 
                          (clientcoverageplanid, 
                           startdate, 
                           enddate, 
                           coborder, 
                           serviceareaid) 
              VALUES      (@ClientCoveragePlanId, 
                           @InsertStartDate, 
                           @InsertEndDate, 
                           CASE 
                             WHEN @COBOrder > @MaxCOBOrderTemp1 THEN @MaxCOBOrderTemp1 + 1
                             WHEN @MaxCOBOrderTemp1 = 1 THEN @MaxCOBOrderTemp1 + 1  
                             ELSE @MaxCOBOrderTemp1 + 1  
                           END, 
                           @ServiceAreaId) 
                           
        

              IF @@ERROR <> 0 
                GOTO error 
          END 

        /*Debug select   
         select @InsertStartDate, @InsertEndDate, @CoverageEndDate, @EndDate   
        */ 
        IF @InsertEndDate = Dateadd(dd, -1, @StartDate) 
          BEGIN 
              SET @InsertStartDate = @StartDate 
              SET @InsertEndDate = CASE 
                                     WHEN @CoverageEndDate IS NULL 
                                           OR @CoverageEndDate > @EndDate THEN 
                                     @EndDate 
                                     ELSE @CoverageEndDate 
                                   END 
          
              INSERT INTO #temp2 
                          (clientcoveragehistoryid, 
                           clientcoverageplanid, 
                           startdate, 
                           enddate, 
                           coborder, 
                           serviceareaid) 
              SELECT clientcoveragehistoryid, 
                     clientcoverageplanid, 
                     @InsertStartDate, 
                     @InsertEndDate, 
                     CASE 
                       WHEN coborder < @COBOrder THEN coborder 
                       ELSE coborder + 1 
                     END, 
                     @ServiceAreaId 
              FROM   #temp1 
              WHERE  startdate = @CoverageStartDate 
                     AND ( enddate = @CoverageEndDate 
                            OR ( enddate IS NULL 
                                 AND @CoverageEndDate IS NULL ) )
                                 
                                 
       
                         -- AND @COBOrderCount < 1 AND @COBCountExisting < 1
              IF @@ERROR <> 0 
                GOTO error 
             
              INSERT INTO #temp2 
                          (clientcoverageplanid, 
                           startdate, 
                           enddate, 
                           coborder, 
                           serviceareaid) 
              VALUES      (@ClientCoveragePlanId, 
                           @InsertStartDate, 
                           @InsertEndDate, 
                           CASE 
                             WHEN @COBOrder > @MaxCOBOrderTemp1 THEN @MaxCOBOrderTemp1 + 1 
                             WHEN @MaxCOBOrderTemp1 = 1 THEN @MaxCOBOrderTemp1 + 1 
                             ELSE @MaxCOBOrderTemp1 + 1  
                           END, 
                           @ServiceAreaId) 
                           
        

              IF @@ERROR <> 0 
                GOTO error 
          END 

        /*Debug select   
         select * from #temp2   
        */ 
        IF @InsertEndDate = @CoverageEndDate 
           AND ( @NextStartDate IS NOT NULL 
                  OR @EndDate IS NULL 
                  OR @EndDate > @CoverageEndDate ) 
           AND ( @NextStartDate IS NULL 
                  OR @NextStartDate > Dateadd(dd, 1, @InsertEndDate) ) 
          BEGIN 
              SET @InsertStartDate = Dateadd(dd, 1, @InsertEndDate) 
              SET @InsertEndDate = CASE 
                                     WHEN @NextStartDate IS NULL 
                                           OR @NextStartDate > @EndDate THEN 
                                     @EndDate 
                                     ELSE DATEADD(day,-1,@NextStartDate)
                                   END 
              IF(@COBOrderCount < 1)                     
               BEGIN
            
				  INSERT INTO #temp2 
							  (clientcoverageplanid, 
							   startdate, 
							   enddate, 
							   coborder, 
							   serviceareaid) 
				  VALUES      (@ClientCoveragePlanId, 
							   @InsertStartDate, 
							   @InsertEndDate, 
							   1, 
			  				   @ServiceAreaId) 
                END      
                
              

              IF @@ERROR <> 0 
                GOTO error 
          END 
        ELSE 
          IF @InsertEndDate = @EndDate 
             AND ( @CoverageEndDate IS NULL 
                    OR @CoverageEndDate > @EndDate ) 
             AND ( @NextStartDate IS NULL 
                    OR @NextStartDate > Dateadd(dd, 1, @EndDate) ) 
            BEGIN 
                SET @InsertStartDate = Dateadd(dd, 1, @InsertEndDate) 
                SET @InsertEndDate = @CoverageEndDate 
                
              
               
                INSERT INTO #temp2 
                            (clientcoveragehistoryid, 
                             clientcoverageplanid, 
                             startdate, 
                             enddate, 
                             coborder, 
                             serviceareaid) 
                SELECT clientcoveragehistoryid, 
                       clientcoverageplanid, 
                       @InsertStartDate, 
                       @InsertEndDate, 
                       coborder, 
                       @ServiceAreaId 
                FROM   #temp1 
                WHERE  startdate = @CoverageStartDate 
                       AND ( enddate = @CoverageEndDate 
                              OR ( enddate IS NULL 
                                   AND @CoverageEndDate IS NULL ) ) 
                                   
        
                      -- AND @COBOrderCount < 1 AND @COBCountExisting < 1
                IF @@ERROR <> 0 
                  GOTO error 
            END 

        SET   @PreviousEndDate = @InsertEndDate 
        

        FETCH cur_coveragedates1 INTO @CoverageStartDate, @CoverageEndDate, 
        @MaxCOBOrder, @NextStartDate 

        IF @@ERROR <> 0 
          GOTO error 
    END 

  CLOSE cur_coveragedates1 

  IF @@ERROR <> 0 
    GOTO error 

  DEALLOCATE cur_coveragedates1 

  IF @@ERROR <> 0 
    GOTO error 



--To get the maximum cob priority---
Declare @MaxPriorityTemp2 int
DEclare @MaxCOBOrderCH int
select  @MaxPriorityTemp2 =   max(C.COBPRiority)  from #temp2 t join Clientcoverageplans CP on CP.clientcoverageplanid = t.clientcoverageplanid
                             join Coverageplans C on C.CoveragePlanId = CP.CoveragePlanId
select  @MaxCOBOrderCH =  max(CH.COBORder)  from #temp2 t join Clientcoverageplans CP on CP.clientcoverageplanid = t.clientcoverageplanid
                             join ClientCoverageHistory CH on (CH.clientcoverageplanid = CP.clientcoverageplanid )
                             join Coverageplans C on C.CoveragePlanId = CP.CoveragePlanId
/*Debug select   
select * from #temp2   
*/ 
  -- Update Client Coverage History table   
  -- Update records where only COB Order has changed   
  --UPDATE b 
  --SET    
  --       coborder = b.coborder, 
  --       modifiedby = @UserCode, 
  --       modifieddate = Getdate() 
  --FROM   #temp2 a 
  --       JOIN clientcoveragehistory b 
  --         ON ( a.clientcoveragehistoryid = b.clientcoveragehistoryid ) 
  --WHERE  a.startdate = b.startdate 
  --       AND ( a.enddate = b.enddate 
  --              OR ( a.enddate IS NULL 
  --                   AND b.enddate IS NULL ) ) 
  --       AND a.coborder <> b.coborder 
         
         
--------------------Added to update COBOrder based on COBPriority--------------------

--Update CH
--SET
--    CH.COBOrder =  CT.RankPRiority
--print '100'
       --update CH
       --set CH.COBOrder = CT.RankPRiority
       ---Temp table to insert final result set in order to update the coborder
        CREATE TABLE #TempCOBOrder 
		( 
		   RankOrder               INT Identity(1,1),
		   clientcoveragehistoryid INT NULL, 
		   clientcoverageplanid    INT NOT NULL, 
		   startdate               DATETIME NOT NULL, 
		   enddate                 DATETIME NULL, 
		   coborder                INT NOT NULL, 
		   serviceareaid           INT ,
		   COBPriority             INT
		) 
       
       
       
      
         
         --select * from ClientCoverageHistory ch join #temp2 t on (ch.ClientCoveragePlanId=t.ClientCoveragePlanId) where t.clientcoverageplanid in (53,52,51)

  IF @@ERROR <> 0 
    GOTO error 
   
  -- Delete records that have been modified   
  DELETE a 
  FROM   clientcoveragehistory a 
         JOIN #temp1 b 
           ON ( a.clientcoveragehistoryid = b.clientcoveragehistoryid ) 
  WHERE  NOT EXISTS (SELECT * 
                     FROM   #temp2 c 
                     WHERE  a.clientcoveragehistoryid = 
                            c.clientcoveragehistoryid 
                            AND a.startdate = c.startdate 
                            AND a.coborder = c.coborder 
                            AND ( a.enddate = c.enddate 
                                   OR ( a.enddate IS NULL 
                                        AND c.enddate IS NULL ) ) 
                            AND c.serviceareaid = a.serviceareaid) 

  IF @@ERROR <> 0 
    GOTO error 
    
  -- Insert new records   
  INSERT INTO clientcoveragehistory 
              (clientcoverageplanid, 
               startdate, 
               enddate, 
               coborder, 
               createdby, 
               createddate, 
               modifiedby, 
               modifieddate, 
               serviceareaid) 
  SELECT a.clientcoverageplanid, 
         a.startdate, 
         a.enddate, 
         a.coborder, 
         @UserCode, 
         Getdate(), 
         @UserCode, 
         Getdate(), 
         a.serviceareaid 
  FROM   #temp2 a 
  WHERE  NOT EXISTS (SELECT * 
                     FROM   clientcoveragehistory b 
                     WHERE  a.clientcoveragehistoryid = 
                            b.clientcoveragehistoryid) 
                            
                  
           
       --Added to update the coborder after inserting                     
       Insert into #TempCOBOrder
       select
		   CH.clientcoveragehistoryid,
           a.clientcoverageplanid,
		   a.StartDate,
		   a.EndDate,
		   a.COBOrder,
		   a.ServiceAreaId,
		   CP.COBPriority
       FROM   
          ClientCoverageHistory CH 
         JOIN #temp2 a  on (ch.ClientCoveragePlanId=a.ClientCoveragePlanId) and ISNULL(CH.RecordDeleted,'N') <> 'Y' 
         JOIN clientcoverageplans b    ON ( a.ClientCoveragePlanId = b.ClientCoveragePlanId )  
         JOIN CoveragePlans CP ON (CP.CoveragePlanId = b.CoveragePlanId) and ISNULL(CP.RecordDeleted,'N') <> 'Y'
        order by CP.COBPriority asc
        
        
         
         
         ----Added a temp table to insert #temp2(newly inserted clientcoveragehistory) to update the COBOrder based on COBPriority -----------
        
        CREATE TABLE #TempCOBOrderFinal 
		( 
		   RankOrder               INT Identity(1,1),
		   clientcoveragehistoryid INT NULL, 
		   clientcoverageplanid    INT NOT NULL,
		   
		   COBPriority             INT
		) 
		
		--Added a temp table to insert #temp2(newly inserted clientcoveragehistory) to update the COBOrder based on COBPriority if the enddate is null------------ 
		 CREATE TABLE #TempCOBOrderFinalEndDate 
		( 
		   RankOrder               INT Identity(1,1),
		   clientcoveragehistoryid INT NULL, 
		   clientcoverageplanid    INT NOT NULL,
		   COBPriority             INT
		) 
		
		  --Added temp table for only end date is null  
	   CREATE TABLE #TempCOBOrderFinalOnlyEndDate   
	  (   
		 RankOrder               INT Identity(1,1),  
		 clientcoveragehistoryid INT NULL,   
		 clientcoverageplanid    INT NOT NULL,  
		 COBPriority             INT  
	  ) 
		
		---Inserting already existing records in temp1 to a temp table to update coborder finally
	   Insert into #TempCOBOrderFinal
     
        select
		   distinct CH.clientcoveragehistoryid,
           a.clientcoverageplanid,
          
		  CP.COBPriority
       FROM   
          ClientCoverageHistory CH 
         JOIN #temp2 a  on (ch.ClientCoveragePlanId=a.ClientCoveragePlanId) and ISNULL(CH.RecordDeleted,'N') <> 'Y' 
         JOIN clientcoverageplans b    ON ( a.ClientCoveragePlanId = b.ClientCoveragePlanId )  
         JOIN CoveragePlans CP ON (CP.CoveragePlanId = b.CoveragePlanId) and ISNULL(CP.RecordDeleted,'N') <> 'Y'
        where CH.StartDate < = @StartDate and (CH.ENDDATE >= @StartDate)
       
        order by CP.COBPriority asc
        
        
        ---To insert for the records if end is null
           Insert into #TempCOBOrderFinalEndDate
        select
		   distinct CH.clientcoveragehistoryid,
           a.clientcoverageplanid,
		   CP.COBPriority
       FROM   
          ClientCoverageHistory CH 
         JOIN #temp2 a  on (ch.clientcoveragehistoryid=a.clientcoveragehistoryid) and ISNULL(CH.RecordDeleted,'N') <> 'Y' 
         JOIN clientcoverageplans b    ON ( a.ClientCoveragePlanId = b.ClientCoveragePlanId )  
         JOIN CoveragePlans CP ON (CP.CoveragePlanId = b.CoveragePlanId) and ISNULL(CP.RecordDeleted,'N') <> 'Y'
        where CH.StartDate < = @StartDate and (CH.EndDate is null)
      
        order by CP.COBPriority asc
        
          ---To insert into temp table if enddate is null
          
          Insert into #TempCOBOrderFinalEndDate  
        select  
           distinct CH.clientcoveragehistoryid,  
           a.clientcoverageplanid,  
           CP.COBPriority  
       FROM     
          ClientCoverageHistory CH   
         JOIN #temp2 a  on (ch.ClientCoveragePlanId=a.ClientCoveragePlanId) and ISNULL(CH.RecordDeleted,'N') <> 'Y'   
         JOIN clientcoverageplans b    ON ( a.ClientCoveragePlanId = b.ClientCoveragePlanId )    
         JOIN CoveragePlans CP ON (CP.CoveragePlanId = b.CoveragePlanId) and ISNULL(CP.RecordDeleted,'N') <> 'Y'  
        where (CH.EndDate is null) 
        order by CP.COBPriority asc 
      
        
         
        Update CH
         set ch.COBOrder = T.RankOrder
         From 
         ClientCoverageHistory CH 
         Join #TempCOBOrderFinal T ON ( T.clientcoveragehistoryid = CH.clientcoveragehistoryid )  and ISNULL(CH.RecordDeleted,'N') <> 'Y' 
         
         ---To update the COBOrder for the ones which has enddate has null
         Update CH
         set ch.COBOrder = T.RankOrder
         From 
         ClientCoverageHistory CH 
         Join #TempCOBOrderFinalEndDate T ON ( T.clientcoveragehistoryid = CH.clientcoveragehistoryid )  and ISNULL(CH.RecordDeleted,'N') <> 'Y' 
         
            ---To update the COBOrder for the ones which has only enddate null condition
         Update CH  
         set ch.COBOrder = T.RankOrder  
         From   
         ClientCoverageHistory CH   
         Join #TempCOBOrderFinalOnlyEndDate T ON ( T.clientcoveragehistoryid = CH.clientcoveragehistoryid and T.clientcoverageplanid = CH.clientcoverageplanid)  and ISNULL(CH.RecordDeleted,'N') <> 'Y'   
         
         
                            
  --19/02/2015------Akwinass----------------------------------------------------------------------------------------------------------------------
  IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCManageClientCoveragePlanChangeLog]') AND type in (N'P', N'PC')) 
  BEGIN
	EXEC ssp_SCManageClientCoveragePlanChangeLog @ClientId,@ClientCoveragePlanId,@StartDate,@EndDate,1,@UserCode,@ServiceAreaId,'TEMPADD',NULL
  END
  -------------------------------------------------------------------------------------------------------------------------------------------------
  
  IF @@ERROR <> 0 
    GOTO error 

  -- logic for combining Start and End dates   
  EXEC Ssp_pmcombinecoborder 
    @ClientId, 
    @StartDate, 
    @EndDate, 
    @UserCode ,
    @ServiceAreaId

  IF @@ERROR <> 0 
    GOTO error 
    
 
---Validations are moved here to avoid duplicate insertion of history----------

   
             
  ---- Verify if the COB Order is correct 
  IF EXISTS (SELECT b.startdate, 
                    b.coborder, 
                    COUNT(*) 
             FROM   clientcoverageplans a 
                    JOIN clientcoveragehistory b 
                      ON ( a.clientcoverageplanid = b.clientcoverageplanid ) 
             WHERE  a.clientid = @ClientId 
                    AND ( b.serviceareaid = @ServiceAreaId 
                           OR @ServiceAreaId IS NULL ) 
                    AND Isnull(a.recorddeleted, 'N') = 'N' 
                    AND Isnull(b.recorddeleted, 'N') = 'N' 
                 --   AND @COBOrderPara <> 0
             GROUP  BY b.startdate, 
                       b.coborder 
             HAVING COUNT(*) > 1) 
    BEGIN 
        RAISERROR ('Invalid COB Order in Coverage History. Duplicate COB Order. Please contact system administrator',16,1);

    GOTO error 
END 

  IF EXISTS (SELECT * 
             FROM   clientcoverageplans a 
                    JOIN clientcoveragehistory b 
                      ON ( a.clientcoverageplanid = b.clientcoverageplanid ) 
             WHERE  a.clientid = @ClientId 
                    AND Isnull(a.recorddeleted, 'N') = 'N' 
                    AND Isnull(b.recorddeleted, 'N') = 'N' 
                    AND ( b.serviceareaid = @ServiceAreaId 
                           OR @ServiceAreaId IS NULL ) 
                    AND b.startdate > b.enddate) 
                  --  AND @COBOrderPara <> 0
    BEGIN 

RAISERROR ('Invalid COB Order in Coverage History. End date less than start date. Please contact system administrator',16,1);

    GOTO error 
END 

  IF EXISTS (SELECT * 
             FROM   clientcoverageplans a 
                    JOIN clientcoveragehistory b 
                      ON ( a.clientcoverageplanid = b.clientcoverageplanid ) 
                    JOIN clientcoveragehistory c 
                      ON ( a.clientcoverageplanid = c.clientcoverageplanid ) 
             WHERE  a.clientid = @ClientId 
                    AND Isnull(a.recorddeleted, 'N') = 'N' 
                    AND Isnull(b.recorddeleted, 'N') = 'N' 
                    AND Isnull(c.recorddeleted, 'N') = 'N' 
                    AND ( b.startdate <= c.startdate 
                          AND Isnull(b.enddate, Dateadd(yy, 10, Getdate())) > 
                              c.startdate 
                          AND Isnull(b.enddate, Dateadd(yy, 10, Getdate())) <> 
                              Isnull(c.enddate, 
                              Dateadd(yy, 10, Getdate())) ) 
                    --Added by Suma 
                    AND b.serviceareaid = c.serviceareaid) 
                   -- AND @COBOrderPara <> 0
    BEGIN 

RAISERROR ('Invalid COB Order in Coverage History. Overlapping date ranges. Please contact system administrator',16,1);

    GOTO error 
END 

 
        ---- Update RecordDeleted to 'Y' for already inserted record if it is duplicate and matches the validation criteria----------
        
        Update CH1
        set CH1.recorddeleted='Y'
        From 
        (
			Select 
			 CH.startdate,
			 CH.coborder,
			 CH.ClientCoveragePlanId
			From ClientCoverageHistory CH 
			Join #TempCOBOrder T ON ( T.clientcoverageplanid = CH.clientcoverageplanid )    
			Join  clientcoverageplans a ON ( a.clientcoverageplanid = CH.clientcoverageplanid ) 
			WHERE  a.clientid = @ClientId 
						AND ( CH.serviceareaid = @ServiceAreaId 
							   OR @ServiceAreaId IS NULL ) 
						AND Isnull(a.recorddeleted, 'N') = 'N' 
						AND Isnull(CH.recorddeleted, 'N') = 'N' 
						AND @COBOrderPara <> 0
				 GROUP  BY CH.startdate, 
						   CH.coborder ,
						   CH.ClientCoveragePlanId
				 HAVING COUNT(*) > 1
	      ) R
             Join ClientCoverageHistory CH1 on CH1.ClientCoveragePlanId = R.ClientCoveragePlanId
             
       Update CH
       set CH.recorddeleted='Y'
       From 
       ClientCoverageHistory CH  
       Join clientcoverageplans a ON ( a.clientcoverageplanid = CH.clientcoverageplanid ) 
       Join #TempCOBOrder T ON ( T.clientcoverageplanid = CH.clientcoverageplanid )  
       WHERE  a.clientid = @ClientId 
                    AND Isnull(a.recorddeleted, 'N') = 'N' 
                    AND Isnull(CH.recorddeleted, 'N') = 'N' 
                    AND (CH.serviceareaid = @ServiceAreaId 
                           OR @ServiceAreaId IS NULL ) 
                    AND CH.startdate > CH.enddate 
                    --AND @COBOrderPara <> 0      
                    
                    
       Update CH
       set CH.recorddeleted='Y'
       From 
       ClientCoverageHistory CH                            
       Join #TempCOBOrder T ON ( T.clientcoverageplanid = CH.clientcoverageplanid )  
       Join clientcoverageplans a ON ( a.clientcoverageplanid = CH.clientcoverageplanid ) 
       WHERE  a.clientid = @ClientId 
                    AND Isnull(a.recorddeleted, 'N') = 'N' 
                    AND Isnull(CH.recorddeleted, 'N') = 'N' 
                    AND Isnull(CH.recorddeleted, 'N') = 'N' 
                    --Added by Suma 
                    AND CH.serviceareaid = CH.serviceareaid 
                    AND @COBOrderPara <> 0
                    AND ( CH.startdate <= CH.startdate 
                          AND Isnull(CH.enddate, Dateadd(yy, 10, Getdate())) > 
                              CH.startdate 
                          AND Isnull(CH.enddate, Dateadd(yy, 10, Getdate())) <> 
                              Isnull(CH.enddate, 
                              Dateadd(yy, 10, Getdate()))) 
                              
                              
             Update a
              set a.recorddeleted='Y' 
             FROM   clientcoveragehistory a 
                    JOIN dbo.serviceareas b 
                      ON( a.serviceareaid = b.serviceareaid ) 
             WHERE  a.clientcoverageplanid = @ClientCoveragePlanId 
                    AND ( a.serviceareaid = @ServiceAreaId 
                           OR @ServiceAreaId IS NULL ) 
                    AND Isnull(a.recorddeleted, 'N') = 'N' 
                    AND ( a.startdate <= @EndDate 
                           OR @EndDate IS NULL ) 
                    AND ( a.enddate >= @StartDate 
                           OR a.enddate IS NULL )
                    AND @COBOrderPara <> 0 
 

  RETURN 0 

  ERROR: 

  RETURN -1 


GO

