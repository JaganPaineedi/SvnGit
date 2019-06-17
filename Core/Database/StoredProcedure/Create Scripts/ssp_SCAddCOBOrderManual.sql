
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_SCAddCOBOrderManual]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ssp_SCAddCOBOrderManual]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SCAddCOBOrderManual] @ClientId             INT, 
                                            @ClientCoveragePlanId INT, 
                                            @StartDate            DATETIME, 
                                            @EndDate              DATETIME, 
                                            @COBOrder             INT, 
                                            @UserCode             VARCHAR(30), 
                                            @ServiceAreaId        INT 
AS 
/******************************************************************************   
**  File: dbo.ssp_SCAddCOBOrderManual.prc    
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
**  Date:    Author:      Description:   
**  --------  --------    -------------------------------------------   
**  24/06/2015 Shruthi.S  Created this sp to update COBOrder as exisiting logic which was in 3.5x.Ref #2 CEI - Customizations.
**  JUL-7-2016  Dknewtson   One temp2 case was causing overlapping date ranges.  Replaced set for @InsertEndDate from @NextStartDate to Dateadd(day,-1,@NextStartDate)
**  Aug-18-2016	Wasif		Changed Raise Error Syntax for TxACE was not caught by the SQL 2014 upgrade utility. 
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
       serviceareaid           INT 
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

  IF @COBOrder IS NULL 
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
    BEGIN 
        RAISERROR ('Coverage already exists for an overlapping date range.', 16, 1) 

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
               serviceareaid) 
  SELECT a.clientcoveragehistoryid, 
         a.clientcoverageplanid, 
         a.startdate, 
         a.enddate, 
         a.coborder, 
         a.serviceareaid 
  FROM   clientcoverageplans b 
         JOIN clientcoveragehistory a 
           ON ( a.clientcoverageplanid = b.clientcoverageplanid ) 
  WHERE  b.clientid = @ClientId 
         AND Isnull(a.recorddeleted, 'N') = 'N' 
         AND Isnull(b.recorddeleted, 'N') = 'N' 
         AND b.clientcoverageplanid != @ClientCoveragePlanId 
         AND ( a.startdate <= @EndDate 
                OR @EndDate IS NULL ) 
         AND ( a.enddate >= @StartDate 
                OR a.enddate IS NULL ) 
         AND a.serviceareaid = @ServiceAreaId 

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
  DECLARE cur_coveragedates CURSOR FOR 
    SELECT a.startdate, 
           a.enddate, 
           MAX(a.coborder), 
           MIN(b.startdate) 
    FROM   #temp1 a 
           LEFT JOIN #temp1 b 
             ON ( b.startdate > a.enddate 
                  AND a.enddate IS NOT NULL ) 
    GROUP  BY a.startdate, 
              a.enddate 
    ORDER  BY a.startdate 

  IF @@ERROR <> 0 
    GOTO error 

  OPEN cur_coveragedates 

  IF @@ERROR <> 0 
    GOTO error 

  FETCH cur_coveragedates INTO @CoverageStartDate, @CoverageEndDate, 
  @MaxCOBOrder, @NextStartDate 

  IF @@ERROR <> 0 
    GOTO error 

  WHILE @@FETCH_STATUS = 0 
    BEGIN 
        -- If current Start Date < @CoverageStartDate (date range gap) then insert record for date range   
        -- for current coverage with COBORder 1    
        IF @PreviousEndDate IS NULL 
           AND @StartDate < @CoverageStartDate 
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
                             WHEN @COBOrder > @MaxCOBOrder THEN @MaxCOBOrder + 1 
                             ELSE @COBOrder 
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
                             WHEN @COBOrder > @MaxCOBOrder THEN @MaxCOBOrder + 1 
                             ELSE @COBOrder 
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
                             WHEN @COBOrder > @MaxCOBOrder THEN @MaxCOBOrder + 1 
                             ELSE @COBOrder 
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

                IF @@ERROR <> 0 
                  GOTO error 
            END 

        SET @PreviousEndDate = @InsertEndDate 

        FETCH cur_coveragedates INTO @CoverageStartDate, @CoverageEndDate, 
        @MaxCOBOrder, @NextStartDate 

        IF @@ERROR <> 0 
          GOTO error 
    END 

  CLOSE cur_coveragedates 

  IF @@ERROR <> 0 
    GOTO error 

  DEALLOCATE cur_coveragedates 

  IF @@ERROR <> 0 
    GOTO error 

/*Debug select   
select * from #temp2   
*/ 
  -- Update Client Coverage History table   
  -- Update records where only COB Order has changed   
  UPDATE b 
  SET    coborder = b.coborder, 
         modifiedby = @UserCode, 
         modifieddate = Getdate() 
  FROM   #temp2 a 
         JOIN clientcoveragehistory b 
           ON ( a.clientcoveragehistoryid = b.clientcoveragehistoryid ) 
  WHERE  a.startdate = b.startdate 
         AND ( a.enddate = b.enddate 
                OR ( a.enddate IS NULL 
                     AND b.enddate IS NULL ) ) 
         AND a.coborder <> b.coborder 

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

  -- Verify if the COB Order is correct 
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
             GROUP  BY b.startdate, 
                       b.coborder 
             HAVING COUNT(*) > 1) 
    BEGIN 
        RAISERROR ('Invalid COB Order in Coverage History. Duplicate COB Order. Please contact system administrator', 16, 1)

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
    BEGIN 
        RAISERROR ('Invalid COB Order in Coverage History. End date less than start date. Please contact system administrator' , 16, 1)

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
    BEGIN 
        RAISERROR ('Invalid COB Order in Coverage History. Overlapping date ranges. Please contact system administrator', 16, 1)

    GOTO error 
END 

  RETURN 0 

  ERROR: 

  RETURN -1 


GO


