/****** Object:  StoredProcedure [dbo].[ssp_ListPageCMClients]    Script Date: 11/21/2014 18:52:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageCMClients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageCMClients]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageCMClients]    Script Date: 11/21/2014 18:52:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageCMClients]  
 @PageNumber     INT,   
 @PageSize       INT,   
 @SortExpression VARCHAR(100),   
 @InsurerId      INT,   
 @PlanId         INT,   
 @ContractId     INT,   
 @ClientStatus   INT,   
 @LoginStaffId   INT,   
 @OtherFilter    INT   
AS   
  /************************************************************************************************                                  
  -- Stored Procedure: dbo.ssp_ListPageCMClients         
  -- Copyright: Streamline Healthcate Solutions         
  -- Purpose: Used by Clients list page         
  -- Updates:         
  -- Date        Author            Purpose         
  -- 04.03.2014  Vichee Humane     Created    
  -- 11.25.2014  Arjun K R        Modified   
  -- 01.30.2015  Gautam           Removed the InsurerPlans and ClientPlans with ClientCoveragePlans and related changed.
								  Why :Care Management to SmartCare Env. Issues Tracking: #453 My Office Clients Listpage using clientplans  isnted of ClientCoveragePlans
  -- 09-03-2015  Shruthi.S        Added StaffInsurers join condition and removed obsolete tables like ClientSpendDowns and added ClientMonthlydeductible table.Ref #490 Env Issues.								  
  -- 12-07-2015  Gautam           Removed the existing condition EffectiveFrom and EffectiveTo from ClientCoveragePlan, Why : Field is not available in ClientCoveragePlans table. 
--17-DEC-2015  Basudev Sahu Modified For Task #609 Network180 Customization to  Get Organisation  As Member
  -- 04.Feb.2016 Rohith Uppin	  Lastname ,Firstname modified to Lastname, Firstname. SWMBH Support #829.
  -- 03.May.2016 Himmat           Some of the table alises are invalid so i removed invalid alises SWMBH Support#976
  *************************************************************************************************/  
  BEGIN   
      BEGIN TRY   
          SET nocount ON;   
  
          --DECLATE TABLE TO GET DATA IF OTHER FILTER EXISTS -------              
          DECLARE @CustomFiltersApplied CHAR(1)   
          CREATE TABLE #CustomFilters (ClientID int)   
          DECLARE @EventType INT 
         -- 03.May.2016 Himmat   
          DECLARE @str NVARCHAR(max)   
          DECLARE @HospitalizeStatus INT   
          SET @CustomFiltersApplied = 'N'      
          SET @HospitalizeStatus = 2181   
            
          DECLARE @AllStaffInsurer VARCHAR(1)  
          SELECT TOP 1 @AllStaffInsurer =AllInsurers FROM staff WHERE staffid=@LoginStaffId  
  
          CREATE TABLE #Clients   
            (   
               ClientID          INT,   
               ClientName        VARCHAR(500),   
               Age               VARCHAR(15),   
               Sex               VARCHAR(10),   
               Race              VARCHAR(100),   
               LivingArrangement VARCHAR(500),   
               PhoneNumber       VARCHAR(50)   
            )   
  
          --GET CUSTOM FILTERS              
          IF @OtherFilter > 10000   
            BEGIN  
                SET @CustomFiltersApplied = 'Y'   
                INSERT INTO #CustomFilters (ClientID)   
                EXEC scsp_ListPageCMClients   
                  @SortExpression ,   
                  @InsurerId,   
                  @PlanId,   
                  @ContractId,   
                  @ClientStatus,  
                  @LoginStaffId,  
                  @OtherFilter   
            END   
  
          --INSERT DATE INTO TEMP TABLE WHICH IS FETCHED BELOW BY APPLYING FILTER.           
          IF @CustomFiltersApplied = 'N'   
            BEGIN  
                SET @str = 'Insert into #Clients Select Distinct c.ClientId,
                CASE     
						WHEN ISNULL(C.ClientType, ''I'') = ''I''
						 THEN ISNULL(C.LastName, '''') + '', '' + ISNULL(C.FirstName, '''')
						ELSE ISNULL(C.OrganizationName, '''')
						END as ''Member''
                --c.LastName + '', '' + c.FirstName as ''Member''
                ,Cast(dbo.GetAge (c.DOB,GetDate()) as varchar(5)) + '' Years'' as Age,'        
                SET @str = @str + ' Case c.Sex  when ''M'' then ''Male'' when ''F'' then ''Female'' when ''U'' then ''U'' end as Sex, '  
                SET @str = @str + ' Case when (select count(ClientId) from ClientRaces where ClientRaces.ClientId = c.ClientId and IsNull(ClientRaces.RecordDeleted,''N'')=''N'') >1 then ''Multi-Racial'' else '   
                SET @str = @str + ' (select top 1 ltrim(rtrim(g6.codename)) from clientraces cr6 join  globalcodes g6 on cr6.Raceid=g6.Globalcodeid  where cr6.clientid=c.clientid) end as ''Race'', g2.CodeName as ''LivingArrangement'','''' as PhoneNumber'  
                SET @str = @str + ' from clients c'   
       SET @str = @str + ' join StaffClients sc on sc.ClientId=c.ClientId and sc.StaffId=' + CAST(@LoginStaffId AS VARCHAR)+ 'and IsNull(c.RecordDeleted,''N'')=''N'' '          
          SET @str = @str + ' Left Outer join GlobalCodes g2 on c.LivingArrangement = g2.GlobalCodeId and IsNull(g2.RecordDeleted,''N'')=''N'' '  
                SET @str = @str + ' Left join Staff u ON u.StaffId = c.Inpatientcasemanager '  
                  
                IF(@ClientStatus<>6145)  -- 03.May.2016 Himmat   
                BEGIN   
					SET @str = @str + ' Left outer join ClientRaces cr on c.ClientId=cr.ClientId and IsNull(cr.RecordDeleted,''N'')=''N'' '  
                    SET @str = @str + ' Left outer join GlobalCodes g1 on cr.RaceId=g1.GlobalCodeId and IsNull(g1.RecordDeleted,''N'')=''N'' '  
                   
     IF @InsurerId > 0   
      BEGIN  
       SET @str = @str +' inner join (Select distinct  cp1.ClientId from ClientCoveragePlans cp1 
				inner join CoveragePlanServiceAreas cpsa on cpsa.CoveragePlanId = cp1.CoveragePlanId
				inner join Insurers i on i.ServiceAreaId = cpsa.ServiceAreaId  and IsNull(i.RecordDeleted,''N'')=''N''
				where 
               EXISTS (  
               SELECT SI.InsurerId  
               FROM StaffInsurers SI  
               WHERE SI.RecordDeleted <> ''Y''  
                AND SI.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+''' 
                AND (SI.InsurerId= '''+CAST(@InsurerId AS VARCHAR)+''') 
                AND (i.InsurerId = SI.InsurerId)  
                AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''N''  AND '''+CAST(@InsurerId AS VARCHAR)+''' <> 0
               )  
               OR EXISTS (  
               SELECT IU.InsurerId  
               FROM Insurers IU  
               WHERE isnull(IU.RecordDeleted, ''N'') <> ''Y''  
                AND (i.InsurerId = IU.InsurerId )
               AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''Y''  
              ) 
				  OR EXISTS(
				   SELECT SI.InsurerId  
				   FROM StaffInsurers SI  
				   WHERE SI.RecordDeleted <> ''Y''  
					AND SI.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+'''
					AND (i.InsurerId = SI.InsurerId)  
					AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''N''  
				  )          
                 '   
				   
       SET @str = @str +' and isNull(cp1.RecordDeleted,''N'')=''N'' and IsNull(cpsa.RecordDeleted,''N'')=''N'' ) A on A.ClientId=c.ClientId '  
      END  
     ELSE  
     BEGIN  
      IF(@AllStaffInsurer = 'Y')  
        BEGIN  
           SET @str = @str +' inner join (Select distinct  cp1.ClientId from ClientCoveragePlans cp1 
				inner join CoveragePlanServiceAreas cpsa on cpsa.CoveragePlanId = cp1.CoveragePlanId
				where isNull(cp1.RecordDeleted,''N'')=''N'' and IsNull(cpsa.RecordDeleted,''N'')=''N'' ) A on A.ClientId=c.ClientId '  
         END  
      ELSE  
       BEGIN  
        SET @str = @str +' inner join (Select distinct  cp1.ClientId from ClientCoveragePlans cp1 
				 inner join CoveragePlanServiceAreas cpsa on cpsa.CoveragePlanId = cp1.CoveragePlanId
				inner join Insurers i on i.ServiceAreaId = cpsa.ServiceAreaId  and IsNull(i.RecordDeleted,''N'')=''N''
						where isNull(cp1.RecordDeleted,''N'')=''N''
						 AND
               EXISTS (  
               SELECT SI.InsurerId  
               FROM StaffInsurers SI  
               WHERE SI.RecordDeleted <> ''Y''  
                AND SI.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+''' 
                AND (SI.InsurerId= '''+CAST(@InsurerId AS VARCHAR)+''') 
                AND (i.InsurerId = SI.InsurerId)  
                AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''N''  AND '''+CAST(@InsurerId AS VARCHAR)+''' <> 0
               )  
               OR EXISTS (  
               SELECT IU.InsurerId  
               FROM Insurers IU  
               WHERE isnull(IU.RecordDeleted, ''N'') <> ''Y''  
               AND (i.InsurerId = IU.InsurerId )  
               AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''Y''  
              ) 
				  OR EXISTS(
				   SELECT SI.InsurerId  
				   FROM StaffInsurers SI  
				   WHERE SI.RecordDeleted <> ''Y''  
					AND SI.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+'''
					AND (i.InsurerId = SI.InsurerId)  
					AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''N''  
				  )          
                 '
        SET @str = @str +' and IsNull(cpsa.RecordDeleted,''N'')=''N'' ) A on A.ClientId=c.ClientId'  
       END  
          
     END  
    END  
         
    IF @PlanId <> 0   
      BEGIN   
       SET @str = @str +' inner join (Select distinct  cp2.ClientId from ClientCoveragePlans cp2 
					inner join CoveragePlanServiceAreas cpsa on cpsa.CoveragePlanId = cp2.CoveragePlanId
       where cp2.CoveragePlanId=' + CAST(@PlanId AS VARCHAR)         
       SET @str = @str +' and isNull(cp2.RecordDeleted,''N'')<>''Y'' and  isNull(cpsa.RecordDeleted,''N'')<>''Y'' ) B on B.ClientId=c.ClientId '   
      END   
  
    IF @ContractId <> 0   
       SET @str = @str +' inner join (Select distinct ClientId from ContractRates where ContractId = ' + CAST(@ContractId AS VARCHAR) +'and  isNull(ContractRates.RecordDeleted,''N'')<>''Y'') D on D.ClientId=c.ClientId '         
  
       IF @ClientStatus <> 0   
    BEGIN  
      --Members currently hospitlize         
                  IF @ClientStatus = 6145     
                  BEGIN                     
                  SET @str = @str + 'inner join(Select  p.ClientId from ViewPreScreens p  
            JOIN Clients cc ON cC.Clientid = p.Clientid   
            JOIN StaffClients SC ON SC.ClientId = cc.ClientId and SC.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+'''   
            JOIN GlobalCodes gc ON p.Hospitalizationstatus = gc.Globalcodeid   
            LEFT JOIN Staff u ON u.StaffId = cc.Inpatientcasemanager  
            LEFT JOIN (SELECT *   
                 FROM   ViewConcurrentReviews cr   
                 WHERE  cr.Hospitalizationstatus = 2181   
                  AND cr.Concurrentreviewstatus = 2061   
                  AND NOT EXISTS(SELECT *   
                        FROM   ViewConcurrentReviews cr2   
                        WHERE  cr2.Prescreeneventid = cr.Prescreeneventid   
                         AND cr2.Hospitalizationstatus = 2181   
                         AND cr2.Concurrentreviewstatus = 2061   
                         AND cr2.Dateofconcurrentreview < cr.Dateofconcurrentreview)) AS cr ON cr.Prescreeneventid = p.Prescreeneventid              
                WHERE p.HospitalizationStatus= 2181  
               AND
               EXISTS (  
               SELECT SI.InsurerId  
               FROM StaffInsurers SI  
               WHERE SI.RecordDeleted <> ''Y''  
                AND SI.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+''' 
                AND (SI.InsurerId= '''+CAST(@InsurerId AS VARCHAR)+''') 
                AND (p.InsurerId = SI.InsurerId)  
                AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''N''  AND '''+CAST(@InsurerId AS VARCHAR)+''' <> 0
               )  
               OR EXISTS (  
               SELECT IU.InsurerId  
               FROM Insurers IU  
               WHERE isnull(IU.RecordDeleted, ''N'') <> ''Y''  
               AND (p.InsurerId = IU.InsurerId )  
               AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''Y''  
              ) 
				  OR EXISTS(
				   SELECT SI.InsurerId  
				   FROM StaffInsurers SI  
				   WHERE SI.RecordDeleted <> ''Y''  
					AND SI.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+'''
					AND (p.InsurerId = SI.InsurerId)  
					AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''N''  
				  )          
                 
                                     ) E on E.ClientId=c.ClientId'  
                     
                   
                   END          
    --Members with currently pended claims         
               IF @ClientStatus = 6146         
       BEGIN   
                     SET @str = @str +' inner join (Select distinct ClientId from Claims cs inner join ClaimLines cl on cs.ClaimId=cl.ClaimId inner join OpenClaims oc on cl.ClaimLineId=oc.ClaimLineId'        
       SET @str = @str + ' Where cl.Status = 2027 and isNull(cs.RecordDeleted,''N'')=''N'' and isNull(cl.RecordDeleted,''N'')=''N'' and isNull(oc.RecordDeleted,''N'')=''N'' 
                                  
            AND
               EXISTS (  
               SELECT SI.InsurerId  
               FROM StaffInsurers SI  
               WHERE SI.RecordDeleted <> ''Y''  
                AND SI.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+'''  
                AND (SI.InsurerId= '''+CAST(@InsurerId AS VARCHAR)+''')
                AND (cs.InsurerId = SI.InsurerId)  
                AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''N''  AND '''+CAST(@InsurerId AS VARCHAR)+''' <> 0
               )  
               OR EXISTS (  
               SELECT IU.InsurerId  
               FROM Insurers IU  
               WHERE isnull(IU.RecordDeleted, ''N'') <> ''Y''  
               AND (cs.InsurerId = IU.InsurerId )  
               AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''Y''  
              )    
              OR EXISTS(       
                SELECT SI.InsurerId  
               FROM StaffInsurers SI  
               WHERE SI.RecordDeleted <> ''Y''  
                AND SI.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+'''  
                AND (cs.InsurerId = SI.InsurerId)  
                AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''N''  
              )
                 
       ) E on E.ClientId=c.ClientId'  
       END   
  
      --Members who have special rates         
             IF @ClientStatus = 6147         
                  SET @str = @str +' inner join (Select distinct ClientId from ContractRates where ((StartDate is null and EndDate is Null) Or (StartDate<=getdate() and EndDate>=getdate())) and (ClientId is not null)
                  and  isNull(ContractRates.RecordDeleted,''N'')<>''Y'') E on E.ClientId=c.ClientId'         
               
      -- Members whose spenddown is not met for current month         
            IF @ClientStatus = 6148  --03.May.2016 Himmat        
      BEGIN   
                      SET @str = @str +' join (select distinct cp.ClientId from ClientCoveragePlans cp where CP.ClientHasMonthlyDeductible=''Y'' and not exists(select * from ClientMonthlyDeductibles csd where csd.ClientCoveragePlanId=cp.ClientCoveragePlanId and csd.DeductibleMet =''Y'' 
                      '        
       SET @str = @str +' and IsNull(csd.RecordDeleted,''N'')=''N'' and IsNull(cp.RecordDeleted,''N'')=''N'')'  
       SET @str = @str +' and exists(select * from Claims cl where cl.ClientId = cp.ClientId and DateDiff(dd, cl.ReceivedDate, GetDate()) <= 60 and IsNull(cl.RecordDeleted, ''N'') = ''N'')) e on e.ClientId=c.ClientId where
         
               EXISTS (  
               SELECT SI.InsurerId  
               FROM StaffInsurers SI  
               WHERE SI.RecordDeleted <> ''Y''  
                AND SI.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+'''  
                AND (SI.InsurerId = '''+CAST(@InsurerId AS VARCHAR)+''')
        ---03.May.2016 Himmat AND (cl.InsurerId = SI.InsurerId)
                AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''N''  AND '''+CAST(@InsurerId AS VARCHAR)+''' <> 0
               )  
               OR EXISTS (  
               SELECT IU.InsurerId  
               FROM Insurers IU  
               WHERE isnull(IU.RecordDeleted, ''N'') <> ''Y''  
        ----03.May.2016 Himmat AND (cl.InsurerId = IU.InsurerId )  
               AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''Y''  
              )   
               OR  
               EXISTS (  
               SELECT SI.InsurerId  
               FROM StaffInsurers SI  
               WHERE SI.RecordDeleted <> ''Y''  
                AND SI.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+'''  

                AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''N''  
               )          
               '  
      END   
  
    -- Members whose spenddown is not met for last month         
           IF @ClientStatus = 6149  --03.May.2016 Himmat          
      BEGIN        --SpendDown    
       SET @str = @str +' join ClientCoveragePlans cp on c.ClientId = cp.ClientId and cp.ClientHasMonthlyDeductible = ''Y'' and IsNull(cp.RecordDeleted,''N'')=''N'''  --and cp.EffectiveFrom <=getdate() and (DateAdd(dd, 1, cp.EffectiveTo)>=getdate() or cp.EffectiveTo is null)
       SET @str = @str +'  and not exists (select * from ClientMonthlyDeductibles csd where csd.ClientCoveragePlanId=cp.ClientCoveragePlanId and csd.DeductibleMet =''Y'' and csd.DeductibleYear=year(dateadd(mm,-1,getdate()))
        and csd.DeductibleMonth=month(dateadd(mm,-1,getdate())) and IsNull    (csd.RecordDeleted, ''N'')=''N'')'   
       SET @str = @str +' and exists(select * from Claims cl where cl.ClientId = cp.ClientId and DateDiff(dd, cl.ReceivedDate, GetDate()) <= 60 and IsNull(cl.RecordDeleted, ''N'') = ''N'')
       where 
       
               EXISTS (  
               SELECT SI.InsurerId  
               FROM StaffInsurers SI  
               WHERE SI.RecordDeleted <> ''Y''  
                AND SI.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+'''  
                AND (SI.InsurerId = '''+CAST(@InsurerId AS VARCHAR)+''')
                AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''N''  AND '''+CAST(@InsurerId AS VARCHAR)+''' <> 0
               )  
               OR EXISTS (  
               SELECT IU.InsurerId  
               FROM Insurers IU  
               WHERE isnull(IU.RecordDeleted, ''N'') <> ''Y''  
		---  03.May.2016 Himmat AND (cl.InsurerId = IU.InsurerId )  
               AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''Y''  
              ) 
               OR EXISTS ( 
                SELECT SI.InsurerId  
               FROM StaffInsurers SI  
               WHERE SI.RecordDeleted <> ''Y''  
                AND SI.StaffId = '''+ CAST(@LoginStaffId AS VARCHAR)+'''
        ----03.May.2016 Himmat AND (cl.InsurerId = SI.InsurerId) 
                AND '''+CAST(@AllStaffInsurer AS VARCHAR)+''' = ''N''  
               )'  
      END   
  
            
         IF @ClientStatus = 6150         
               SET @str = @str +' inner join (select distinct ClientId from clients where createddate between (getdate()-14) and getdate() and  isNull(clients.RecordDeleted,''N'')<>''Y'') E on E.ClientId=c.ClientId'         
   END   
    IF @CustomFiltersApplied = 'Y'   
    BEGIN  
    SET @str = @str  + '  Where isNull(c.RecordDeleted,''N'')<>''Y'' and exists(select * from #CustomFilters cf where cf.ClientId = c.ClientId)'   
    END  
    Else  
    SET @str = @str  + '  AND isNull(c.RecordDeleted,''N'')<>''Y'' '       
  
    --PRINT @str  
  
     
    
  
    --exec @str         
    EXECUTE SP_EXECUTESQL @str   
  
    UPDATE #Clients   
    SET    PhoneNumber = (SELECT TOP 1 CP.PhoneNumber   
                          FROM   ClientPhones CP,   
                                 GlobalCodes GC   
                          WHERE  GC.GlobalCodeID = CP.PhoneType   
                                 AND #Clients.ClientID = CP.ClientID   
                                 AND CP.PhoneNumber <> ''   
                                 AND CP.PhoneNumber IS NOT NULL   
                                 AND ISNULL(CP.RecordDeleted, 'N') = 'N'   
                          ORDER  BY GC.GlobalCodeID)   
          END;   
  
    WITH Counts   
         AS (SELECT COUNT(*) AS TotalRows   
             FROM   #Clients),   
         ListBanners   
         AS (SELECT    ClientId,        
        ClientName,   
                             Age,   
                             Sex,   
                             Race,   
                             LivingArrangement,   
                             PhoneNumber,   
                             COUNT(*)   
                             OVER ()   AS   
                             TotalCount,   
                             RANK()   
                               OVER (  ORDER BY   
                                          CASE WHEN @SortExpression='ClientId' THEN ClientId  END,   
                                          CASE WHEN @SortExpression='ClientId desc' THEN ClientId END DESC,  
                                          CASE WHEN @SortExpression='ClientName' THEN ClientName END,   
                                          CASE WHEN @SortExpression='ClientName desc' THEN ClientName END DESC,   
                                          CASE WHEN @SortExpression='Age' THEN Age END,   
                                          CASE WHEN @SortExpression='Age desc' THEN Age END DESC,            
                                          CASE WHEN @SortExpression='Sex' THEN Sex END,   
                                          CASE WHEN @SortExpression='Sex desc' THEN Sex END DESC,   
                                          CASE WHEN @SortExpression='Race' THEN Race END,  
                                          CASE WHEN @SortExpression='Race desc' THEN Race END DESC,   
                                          CASE WHEN @SortExpression='LivingArrangement' THEN LivingArrangement END,   
                                          CASE WHEN @SortExpression='LivingArrangement desc' THEN LivingArrangement END DESC,   
                                          CASE WHEN @SortExpression='PhoneNumber' THEN PhoneNumber END,   
                                          CASE WHEN @SortExpression='PhoneNumber desc' THEN PhoneNumber END DESC ,ClientId ) AS  RowNumber  
              FROM   #Clients)   
    SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT ISNULL( totalrows, 0)   
    FROM   
    Counts ) ELSE (@PageSize) END) ClientID,   
                                   ClientName,   
                                   Age,   
                                   Sex,   
                                   Race,   
                                   LivingArrangement,   
                                   PhoneNumber,   
                                   TotalCount,   
                                   RowNumber   
    INTO   #FinalResultSet   
    FROM   ListBanners   
    WHERE  RowNumber > ((@PageNumber - 1 ) * @PageSize )   
  
    IF (SELECT ISNULL(COUNT(*), 0)   
        FROM   #finalresultset) < 1   
      BEGIN   
          SELECT 0 AS PageNumber,   
                 0 AS NumberOfPages,   
                 0 NumberOfRows   
      END   
    ELSE   
      BEGIN   
          SELECT TOP 1 @PageNumber           AS PageNumber,   
                       CASE ( TotalCount % @PageSize )   
                       WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)   
                       ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1   
                       END  AS NumberOfPages,   
                       ISNULL(totalcount, 0) AS NumberOfRows   
          FROM   #FinalResultSet   
      END   
  
    SELECT ClientID,   
           ClientName,   
           Age,   
           Sex,   
           Race,   
           LivingArrangement,   
           PhoneNumber   
    FROM   #FinalResultSet   
    ORDER  BY RowNumber   
   
END TRY   
  
    BEGIN CATCH   
        DECLARE @Error VARCHAR(8000)   
  
        SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'   
                    + CONVERT(VARCHAR(4000), ERROR_MESSAGE())   
                    + '*****'   
                    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),   
                    'ssp_ListPageCMClients')   
                    + '*****' + CONVERT(VARCHAR, ERROR_LINE())   
                    + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())   
                    + '*****' + CONVERT(VARCHAR, ERROR_STATE())   
  
        RAISERROR ( @Error,   
                    -- Message text.                                                                                              
                    16,   
                    -- Severity.                                                                                              
                    1   
                   -- State.                                                                                              
                    );   
     END CATCH   
END   
  
  
  
  
  
  
  
  