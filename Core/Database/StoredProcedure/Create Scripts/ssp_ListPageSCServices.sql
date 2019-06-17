/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCServices]    Script Date: 2/3/2016 10:09:03 AM ******/
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCServices]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_ListPageSCServices] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCServices]    Script Date: 2/3/2016 10:09:03 AM ******/
SET ANSI_NULLS ON									  
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageSCServices]
    @ClientId INT ,
    @CareManagementClientId INT ,
    @DOSFrom DATETIME ,
    @DOSTo DATETIME ,
    @ClinicianFilter INT ,
    @StatusFilter INT ,
    @ProcedureFilter INT ,
    @ProgramFilter INT ,
    @DateFilter INT ,
    @ServiceFilter INT ,
    @OtherFilter INT ,
    @InsurerId INT ,
    @StaffId INT ,
    @ServicesfromClaims char(1)='N',
    @AddOnCodes char(1)='N'				--13.Feb.2017     Alok Kumar
/********************************************************************************                                        
-- Stored Procedure: dbo.ssp_ListPageSCServices                                          
--                                        
-- Copyright: Streamline Healthcate Solutions                                        
--                                        
-- Purpose: used by Services list page                                        
--                                        
-- Updates:                                                                                               
-- Date        Author      Purpose                                        
-- 08.18.2010  SFarber     Created.            
-- 09.27.2010  SFarber     Modified logic for proxy staff.   
-- 10.20.2010  SFarber     Replaced @ResultSet with #ResultSet  
-- 11.8.2010   SFerenz    Changed 'Status' from varchar(15) to varchar(100)  
-- 11.9.2011   Shifali    Modified in ref to task# 11 To BE Reviewed DOcument Status (Added d.Status 24,25)  
-- 22.4.2012   Sourabh	  Modified to get caremanagementId wrt #1387.	
/* 2/28/2012   Vishant Garg     What and why- Use the synonyms [SC_Clients] to get the caremanagementClientid of client from smartcare database.
--                              If we are using filters to show only data forclaims then we need this id. to get the client's data.
								with ref to task # 505 i 3.x issues */
/* 5 Feb 2013  Vishant Garg     What and why -Added a check for synonms [SC_Clients] because if  client are not using PCM dB then we have no need to execute the same.*/
/* 5/23/2013	Wasif Butt		#3174 - Service Note List Page - Remove Error Services - Core Change */
/* 03/28/2014  John Sudhakar	DataType changed from Varchar(100) to Varchar(350); Reviewer: Kiran K*/
/* 07/11/2014  Shankha			Removed the ServiceNote = 'Y' check for DocumentCodes join path */
/*	MAR-30-2015		dharvey		Updated DocumentName column to not send ProcedureCodeName if the document is deleted */
/*  07/17/2015		njain		Added Record Deleted check on Procedure Codes*/
/*  07/20/2015		njain		Reverted the changes from 7/17/2015, per Javed*/
/*	14.Oct.2015		Rohith uppin	Added David K changes back to SPP & one more condition @CareManagementClientId < 0.
										From David K [12/FEB/2015 dknewtson  Adjusted logic to not overwrite the Care Management client Id if it's been sent by the front end]*/
/*  22.Mar.2016     Gautam      Changed code to see those services that are in a Program that is associated to the Staff Account using sys key ShowAllClientsServices
								Why : Engineering Improvement Initiatives- NBL(I) > Tasks#297 */
/*  05.Aug.2016     Basudev     Changed code to see those services from claims if filter @ServicesfromClaims = 'Y' 
								Why : CEI - Support Go Live Task #233 */		
--02/10/2017      jcarlson       Keystone Customizations 69 - increased [Procedure] length to 500 to handle procedure code display as increasing to 75 								
--21.Feb.2017     Alok Kumar	Added a new filter 'Add On Codes' and a new column to the List page. 
								Why : Harbor - Support	Task #1003. 
--06.Jul.2017		Gautam		Modified code for Performance issue.,Thresholds - Support, Task#991	
--24-NOV-2017   Akwinass    Added "Attachments" column (Task #589 in Engineering Improvement Initiatives- NBL(I))	
 --16/03/2018   Neha           What: Added a new column 'Group Name' to display the Group name if the document is a Group Service Note.
                               Why: MHP-Enhancements – Task# 193							
*********************************************************************************/
AS -- Added By Vishant Garg  
  IF (@CareManagementClientId IS NULL OR @CareManagementClientId < 0) -- by Rohith uppin
	BEGIN   
		IF EXISTS ( SELECT  *
					FROM    sys.synonyms
					WHERE   name = N'SC_Clients' )
			BEGIN                                 
				SELECT  @CareManagementClientId = CareManagementId
				FROM    [dbo].[SC_Clients]
				WHERE   clientid = @ClientId 
			END
		ELSE
			BEGIN
				SELECT  @CareManagementClientId = CareManagementId
				FROM    [dbo].[Clients]
				WHERE   clientid = @ClientId 
			END	
    END	   
  -- 22.Mar.2016     Gautam   
   DECLARE @ShowAllClientsServices CHAR(1)   
   Create Table #StaffPrograms
   (ProgramId int) 
   
  
 --Addition ended here by vishant garg.                                                                                                    
    CREATE TABLE #ResultSet
        (
          RecordId INT IDENTITY
                       NOT NULL ,
          AuthorizationsApproved VARCHAR(15) ,
          DateOfService DATETIME ,
          Status VARCHAR(100) ,
          DocumentName VARCHAR(155) ,
          [Procedure] VARCHAR(500) ,                            
--ProgramName             varchar(100),                            
          ProgramCode VARCHAR(100) ,
          ClinicianName VARCHAR(100) ,
          Comment VARCHAR(MAX) ,
          ServiceId INT ,
          DocumentId INT ,
          ScreenId INT ,
          IsClaimLine CHAR(1),
          AddOnCodes VARCHAR(Max),			--13.Feb.2017     Alok Kumar
          ProcedureCodeId Int,
          Attachments INT,
          GroupName  varchar(100), 
          GroupId int,    
          GroupServiceId int
        )                            
                                    
    DECLARE @CustomFilters TABLE ( ServiceId INT )           
    DECLARE @CustomFiltersApplied CHAR(1)  
          
    SET @CustomFiltersApplied = 'N'  
                                     
    IF @StatusFilter > 10000
        OR @ServiceFilter > 10000
        OR @OtherFilter > 10000
        OR @DateFilter > 10000
        BEGIN                  
          
            SET @CustomFiltersApplied = 'Y'     
                          
            INSERT  INTO @CustomFilters
                    ( ServiceId
                    )
                    EXEC scsp_ListPageSCServices @ClientId = @ClientId, @CareManagementClientId = @CareManagementClientId, @DOSFrom = @DOSFrom, @DOSTo = @DOSTo, @ClinicianFilter = @ClinicianFilter, @StatusFilter = @StatusFilter, @ProcedureFilter = @ProcedureFilter, @ProgramFilter = @ProgramFilter, @DateFilter = @DateFilter, @ServiceFilter = @ServiceFilter, @OtherFilter = @OtherFilter, @InsurerId = @InsurerId, @StaffId = @StaffId                                       
                              
        END             
          
-- Services  
    IF @ServiceFilter IN ( 169, 170 )
        BEGIN  
			---- 22.Mar.2016     Gautam  
			SELECT @ShowAllClientsServices= dbo.ssf_GetSystemConfigurationKeyValue('ShowAllClientsServices')
			IF ISNULL(@ShowAllClientsServices,'Y')='N' 
				BEGIN
					IF exists ( select 1 from   ViewStaffPermissions  where  StaffId = @StaffId  and PermissionTemplateType = 5705  
									  and PermissionItemId = 5744 ) --5744 (Clinician in Program Which Shares Clients) 5741(All clients)
						and not exists ( select 1 from   ViewStaffPermissions  where  StaffId = @StaffId  and PermissionTemplateType = 5705  
									  and PermissionItemId = 5741)								  
					BEGIN                          
						Insert into #StaffPrograms
						Select ProgramId From StaffPrograms Where StaffId=@StaffId  AND ISNULL(RecordDeleted, 'N') <> 'Y'
					END
					ELSE
					BEGIN
						SET @ShowAllClientsServices='Y'
					END
				END  
			ELSE
				BEGIN
					SET @ShowAllClientsServices='Y'
				END  
			-- End -- 22.Mar.2016     Gautam  
            INSERT  INTO #ResultSet
                    ( AuthorizationsApproved ,
                      DateOfService ,
                      DocumentName ,
                      Status ,
                      [Procedure] ,
                      ProgramCode ,
                      ClinicianName ,
                      Comment ,
                      ServiceId ,
                      DocumentId ,
                      ScreenId,
                      AddOnCodes,		--13.Feb.2017     Alok Kumar 
                      ProcedureCodeId,
                      GroupName, 
					  GroupId ,    
					  GroupServiceId
                    )
                    SELECT  CASE WHEN ( ISNULL(s.AuthorizationsNeeded, 0) <= 0
                                        AND ISNULL(s.AuthorizationsApproved, 0) <= 0
                                      )
                                      OR s.STATUS NOT IN ( 70, 71 ) THEN 'transimage'
                                 WHEN ISNULL(s.AuthorizationsNeeded, 0) <= 0
                                      AND ISNULL(s.AuthorizationsApproved, 0) > 0 THEN 'GreenFlag'
                                 WHEN ISNULL(s.AuthorizationsRequested, 0) > 0 THEN 'YellowFlag'
                                 WHEN ISNULL(s.AuthorizationsNeeded, 0) > 0
                                      AND ISNULL(s.AuthorizationsRequested, 0) <= 0 THEN 'RedFlag'
                                 ELSE 'transimage'
                            END ,
                            s.DateOfService ,
                            CASE WHEN pc.DisplayDocumentAsProcedureCode = 'Y'
                                      /** dharvey - added to prevent document link when note is deleted **/
                                      AND EXISTS ( SELECT   1
                                                   FROM     Documents d2
                                                   WHERE    d2.ServiceId = s.ServiceId
                                                            AND ISNULL(d2.RecordDeleted, 'N') = 'N' ) THEN pc.DisplayAs
                                 ELSE dc.DocumentName
                            END AS DocumentName ,
                            gcs.CodeName + CASE WHEN gccr.GlobalCodeId IS NOT NULL THEN ' (' + gccr.CodeName + ')'
                                                ELSE ''
                                           END ,
                            pc.DisplayAs + ' ' + ISNULL(CAST(s.Unit AS VARCHAR), '') + ' ' + ISNULL(gcut.CodeName, '') ,
                            p.ProgramCode ,
                            st.LastName + ', ' + st.FirstName ,
                            s.Comment ,
                            s.ServiceId ,
                            d.DocumentId ,
                            CASE WHEN d.DocumentId IS NULL THEN 29
                                 WHEN ( d.AuthorId = @StaffId
                                        OR -- Current staff is an author                        
                                        d.AuthorId IN ( SELECT  ProxyForStaffId
                                                        FROM    StaffProxies
                                                        WHERE   StaffId = @StaffId
                                                                AND ISNULL(RecordDeleted, 'N') = 'N' )
                                        OR -- Current staff is a proxy for an author  
                                        d.ProxyId = @StaffId
                                        OR  -- Current staff is a proxy                        
                                        d.Status IN ( 22, 23 )
                                        OR  -- Document is in the final status: Signed or Cancelled                        
                                        d.DocumentShared = 'Y'
                                      )  -- Document is shared   
                                      THEN sr.ScreenId
                                 ELSE NULL
                            END,
                            NULL AS AddOnCodes,		--13.Feb.2017     Alok Kumar
                            s.ProcedureCodeId,
                            IsNull(G.GroupName,'') as 'GroupName',
							GS.GroupId,
							GS.GroupServiceId
                    FROM    Services s
                            JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
                            JOIN GlobalCodes gcs ON gcs.GlobalCodeId = s.Status
                            JOIN Programs p ON p.ProgramId = s.ProgramId
                            LEFT JOIN Documents d ON d.ServiceId = s.ServiceId
                                                     AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
                                                     AND d.Status IN ( 20, 21, 22, 23, 24, 25 )
                             left outer join GroupServices GS on s.GroupServiceId=GS.GroupServiceId and isNull(GS.RecordDeleted,'N')<>'Y' 
						     left outer join Groups G ON GS.GroupId=G.GroupId
                            LEFT JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId 
         --AND dc.ServiceNote = 'Y' [Commented by Shankha Primary Care - Summit Pointe# 195]                           
                            LEFT JOIN Screens sr ON sr.DocumentCodeId = d.DocumentCodeId
                                                    AND ISNULL(sr.RecordDeleted, 'N') <> 'Y'
                            LEFT JOIN GlobalCodes gcut ON gcut.GlobalCodeID = s.UnitType
                            LEFT JOIN GlobalCodes gccr ON gccr.GlobalCodeId = s.CancelReason
                            LEFT JOIN Staff st ON st.StaffId = s.ClinicianId
                    WHERE   s.ClientId = @ClientId
                            AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
                            AND ( @ShowAllClientsServices='Y' Or ( @ShowAllClientsServices='N' and 
								EXISTS ( SELECT *
                                                 FROM   #StaffPrograms SP
                                                 WHERE  SP.ProgramId = s.ProgramId ))) 
                            --13.Feb.2017     Alok Kumar 
							AND ( @AddOnCodes='N' Or ( @AddOnCodes='Y' and				
													EXISTS ( SELECT 1 FROM   ServiceAddOnCodes ACS
																	 WHERE  ACS.ServiceId = s.ServiceId AND ISNULL(ACS.RecordDeleted, 'N') = 'N' )))			--15.Mar.2017     Alok Kumar
							-- end
                                                 --basudev 05 Aug,2016
                            and (@ServicesfromClaims='Y' or (@ServicesfromClaims='N' and not exists(select 1 from ClaimLineServiceMappings CLSM where CLSM.ServiceId=s.ServiceId AND ( ( CLSM.RecordDeleted = 'N' )
                                                      OR ( CLSM.RecordDeleted IS NULL )
                                                    ))))
                            --AND ISNULL(pc.RecordDeleted, 'N') <> 'Y'
                            --AND ISNULL(p.RecordDeleted, 'N') <> 'Y'
                            AND ( ( @CustomFiltersApplied = 'Y'
                                    AND EXISTS ( SELECT *
                                                 FROM   @CustomFilters cf
                                                 WHERE  cf.ServiceId = s.ServiceId )
                                  )
                                  OR ( @CustomFiltersApplied = 'N'
                                       AND @StatusFilter IN ( 0, 160, 133, 134, 135, 136, 137 )
                                       AND ( s.DateOfService >= @DOSFrom
                                             OR @DOSFrom IS NULL
                                           )
                                       AND ( s.DateOfService < DATEADD(dd, 1, @DOSTo)
                                             OR @DOSTo IS NULL
                                           )
                                       AND ( s.ProcedureCodeId = @ProcedureFilter
                                             OR ISNULL(@ProcedureFilter, -1) <= 0
                                           )
                                       AND ( s.ProgramId = @ProgramFilter
                                             OR ISNULL(@ProgramFilter, -1) <= 0
                                           )
                                       AND ( ( @StatusFilter IN ( 0, 160 )
                                               AND s.Status NOT IN ( 76 )
                                             )
                                             OR                   -- All Statuses                             
                                             ( @StatusFilter = 133
                                               AND s.Status IN ( 70, 71 )
                                             )
                                             OR -- Scheduled/Show                                       
                                             ( @StatusFilter = 134
                                               AND s.Status = 70
                                             )
                                             OR      -- Scheduled                            
                                             ( @StatusFilter = 135
                                               AND s.Status = 71
                                             )
                                             OR      -- Show                            
                                             ( @StatusFilter = 136
                                               AND s.Status IN ( 72, 73 )
                                             )
                                             OR -- NoShow/Cancel                            
                                             ( @StatusFilter = 137
                                               AND s.Status = 75
                                             )
                                           )        -- Complete                            
                                       AND ( s.ClinicianId = @ClinicianFilter
                                             OR ISNULL(@ClinicianFilter, -1) <= 0
                                           )
                                     )
                                )  
        END  
        
        --06-July-2017	Gautam
			UPDATE  C 
			SET C.AddOnCodes = isnull(REPLACE(REPLACE(STUFF((
								SELECT DISTINCT ', ' +  PC.ProcedureCodeName FROM ProcedureCodes PC
								Join ServiceAddOnCodes SOC on PC.ProcedureCodeId= SOC.AddOnProcedureCodeId
								where SOC.ServiceId = C.ServiceId AND ISNULL(SOC.RecordDeleted, 'N') ='N'
								FOR XML PATH('')
								), 1, 1, ''), '&lt;', '<'), '&gt;', '>'), '')
			FROM    #ResultSet C join ServiceAddOnCodes SOC1 
							   on SOC1.ServiceId = C.ServiceId AND ISNULL(SOC1.RecordDeleted, 'N') = 'N'
		
		UPDATE C
		SET C.Attachments = (SELECT COUNT(ImageRecordId) FROM ImageRecords IR WHERE IR.ServiceId = C.ServiceId AND ISNULL(IR.RecordDeleted, 'N') = 'N')
		FROM #ResultSet C
		JOIN ProcedureCodes PC ON C.ProcedureCodeId = PC.ProcedureCodeId
			AND ISNULL(PC.AllowAttachmentsToService, 'N') = 'Y'					   
		--13.Feb.2017     Alok Kumar	(Updating AddOnCodes column)	--15.Mar.2017     Alok Kumar
		--UPDATE  C 
		--SET C.AddOnCodes = ( SELECT DISTINCT ISNULL(STUFF((SELECT ', ' + 
		--				ISNULL((SELECT TOP 1 ProcedureCodeName FROM ProcedureCodes WHERE ProcedureCodeId= SOC.AddOnProcedureCodeId
		--							AND ISNULL(RecordDeleted, 'N') <> 'Y' AND ISNULL(Active, 'N') = 'Y'), '')	
		--				   FROM ServiceAddOnCodes SOC 
		--				   WHERE SOC.ServiceId = C.ServiceId AND ISNULL(SOC.RecordDeleted, 'N') <> 'Y'
		--				   FOR XML PATH(''),type ).value('.', 'nvarchar(max)'), 1, 2, ' '), ''))
		--FROM    #ResultSet C
		--End Alok Kumar
  
-- Claim lines  
    IF @ServiceFilter IN ( 169, 171 )
        BEGIN  
            INSERT  INTO #ResultSet
                    ( AuthorizationsApproved ,
                      DateOfService ,
                      Status ,
                      DocumentName ,
                      [Procedure] ,
                      ProgramCode ,
                      ClinicianName ,
                      Comment ,
                      ServiceId ,
                      DocumentId ,
                      ScreenId ,
                      IsClaimLine
                    )
                    SELECT  'transimage' ,
                            cl.FromDate ,
                            gcs.CodeName ,
                            NULL ,
                            ISNULL(bc.BillingCode, ISNULL(cl.ProcedureCode, cl.RevenueCode)) + ' ' + ISNULL(CONVERT(VARCHAR, cl.Units), '') + ' Units' ,
                            NULL ,
                            p.ProviderName + CASE WHEN LEN(p.FirstName) > 0 THEN ', ' + p.FirstName
                                                  ELSE ''
                                             END ,
                            cl.Comment ,
                            cl.ClaimLineId ,
                            NULL ,
                            116 ,
                            'Y'
                    FROM    ClaimLines cl
                            JOIN Claims c ON c.ClaimId = cl.ClaimId
                            JOIN GlobalCodes gcs ON gcs.GlobalCodeId = cl.Status
                            JOIN Sites s ON s.SiteId = c.SiteId
                            JOIN Providers p ON p.ProviderId = s.ProviderId
                            LEFT JOIN BillingCodes bc ON bc.BillingCodeId = cl.BillingCodeId
                    WHERE   c.ClientId = @CareManagementClientId
                            AND ISNULL(c.RecordDeleted, 'N') = 'N'
                            AND ISNULL(cl.RecordDeleted, 'N') = 'N'
                            AND ( ( @CustomFiltersApplied = 'Y'
                                    AND EXISTS ( SELECT *
                                                 FROM   @CustomFilters cf
                                                 WHERE  cf.ServiceId = cl.ClaimLineId )
                                  )
                                  OR ( @CustomFiltersApplied = 'N'
                                       AND c.InsurerId = @InsurerId
                                       AND @StatusFilter IN ( 0, 160, 138, 162, 163, 164, 165, 166, 167, 168 )
                                       AND ( cl.FromDate >= @DOSFrom
                                             OR @DOSFrom IS NULL
                                           )
                                       AND ( cl.FromDate < DATEADD(dd, 1, @DOSTo)
                                             OR @DOSTo IS NULL
                                           )
                                       AND ( @StatusFilter IN ( 0, 160 )
                                             OR                 -- All Statuses                             
                                             ( @StatusFilter = 138
                                               AND cl.Status = 2021
                                             )
                                             OR -- Entry Incomplete                                       
                                             ( @StatusFilter = 162
                                               AND cl.Status = 2022
                                             )
                                             OR -- Entry Complete                           
                                             ( @StatusFilter = 163
                                               AND cl.Status = 2023
                                             )
                                             OR -- Approved                            
                                             ( @StatusFilter = 164
                                               AND cl.Status = 2026
                                             )
                                             OR -- Paid                          
                                             ( @StatusFilter = 165
                                               AND cl.Status = 2024
                                             )
                                             OR -- Denied                            
                                             ( @StatusFilter = 166
                                               AND cl.Status = 2027
                                             )
                                             OR -- Pended                            
                                             ( @StatusFilter = 167
                                               AND cl.Status = 2025
                                             )
                                             OR -- Partially  Approved                            
                                             ( @StatusFilter = 168
                                               AND cl.Status = 2028
                                             )
                                           )
                                     )
                                ) -- Void     
  
  -- Calculate AuthorizationsApproved flag for open Entry Complete, Denied and Pended claim lines  
            DECLARE @AuthorizationsRates TABLE
                (
                  Date DATETIME ,
                  ProviderAuthorizationId INT ,
                  AuthorizationUnitsUsed DECIMAL(18, 2) ,
                  ClaimLineUnitsApproved DECIMAL(18, 2) ,
                  ClaimLineUnits DECIMAL(18, 2) ,
                  ContractId INT ,
                  ContractRateId INT ,
                  ContractRate MONEY ,
                  ContractRuleId INT ,
                  AuthorizationRequired CHAR(1)
                )  
  
            DECLARE @RecordId INT  
            DECLARE @ClaimLineId INT  
            DECLARE @BillingCodeId INT  
            DECLARE @RevenueCode VARCHAR(25)  
            DECLARE @HCPCSCode VARCHAR(25)  
  
            DECLARE cur_ClaimLines CURSOR
            FOR
                SELECT  r.RecordId ,
                        cl.ClaimLineId ,
                        cl.BillingCodeId ,
                        cl.RevenueCode ,
                        cl.ProcedureCode
                FROM    ClaimLines cl
                        JOIN #ResultSet r ON r.ServiceId = cl.ClaimLineId
                        JOIN OpenClaims oc ON oc.ClaimLineId = cl.ClaimLineId
                WHERE   cl.Status IN ( 2022, 2024, 2027 )
                        AND r.IsClaimLine = 'Y'
                        AND ISNULL(cl.DoNotAdjudicate, 'N') = 'N'  
    
            OPEN cur_ClaimLines  
            FETCH NEXT FROM cur_ClaimLines INTO @RecordId, @ClaimLineId, @BillingCodeId, @RevenueCode, @HCPCSCode  
  
            WHILE @@fetch_status = 0
                BEGIN   
                    IF @BillingCodeId IS NULL
                        AND LEN(@HCPCSCode) > 0
                        SELECT  @BillingCodeId = BillingCodeId
                        FROM    BillingCodes
                        WHERE   BillingCode = @HCPCSCode
                                AND Active = 'Y'
                                AND ISNULL(RecordDeleted, 'N') = 'N'  
   
                    IF @BillingCodeId IS NULL
                        AND LEN(@RevenueCode) > 0
                        SELECT  @BillingCodeId = BillingCodeId
                        FROM    BillingCodes
                        WHERE   BillingCode = @RevenueCode
                                AND Active = 'Y'
                                AND ISNULL(RecordDeleted, 'N') = 'N'  
  
                    DELETE  FROM @AuthorizationsRates  
  
    -- Find authorizations that can be used for this claim line  
                    INSERT  INTO @AuthorizationsRates
                            ( Date ,
                              ProviderAuthorizationId ,
                              AuthorizationUnitsUsed ,
                              ClaimLineUnitsApproved ,
                              ClaimLineUnits ,
                              ContractId ,
                              ContractRateId ,
                              ContractRate ,
                              ContractRuleId
                            )
                            EXEC ssp_CMGetAuthorizationsRatesForClaimLineApproval @ClaimLineId = @ClaimLineId  
  
                    UPDATE  ar
                    SET     AuthorizationRequired = cr.AuthorizationRequired
                    FROM    @AuthorizationsRates ar
                            JOIN ContractRules cr ON cr.ContractRuleId = ar.ContractRuleId  
  
                    UPDATE  ar
                    SET     AuthorizationRequired = bc.AuthorizationRequired
                    FROM    @AuthorizationsRates ar
                            JOIN BillingCodes bc ON bc.BillingCodeId = @BillingCodeId
                    WHERE   ar.ContractRuleId IS NULL  
  
                    IF EXISTS ( SELECT  *
                                FROM    @AuthorizationsRates
                                WHERE   AuthorizationRequired = 'Y' )
                        IF NOT EXISTS ( SELECT  *
                                        FROM    @AuthorizationsRates
                                        WHERE   AuthorizationRequired = 'Y'
                                                AND ProviderAuthorizationId IS NOT NULL )
                            UPDATE  #ResultSet
                            SET     AuthorizationsApproved = 'RedFlag'
                            WHERE   RecordId = @RecordId  
                        ELSE
                            IF NOT EXISTS ( SELECT  *
                                            FROM    @AuthorizationsRates
                                            WHERE   AuthorizationRequired = 'Y'
                                                    AND ProviderAuthorizationId IS NULL )
                                UPDATE  #ResultSet
                                SET     AuthorizationsApproved = 'GreenFlag'
                                WHERE   RecordId = @RecordId  
                            ELSE
                                UPDATE  #ResultSet
                                SET     AuthorizationsApproved = 'YellowFlag'
                                WHERE   RecordId = @RecordId  
  
                    FETCH NEXT FROM cur_ClaimLines INTO @RecordId, @ClaimLineId, @BillingCodeId, @RevenueCode, @HCPCSCode  
                END  
  
            CLOSE cur_ClaimLines  
            DEALLOCATE cur_ClaimLines  
        END  
  
  
    SELECT  r.AuthorizationsApproved ,
            r.DateOfService ,
            r.Status ,
            r.DocumentName ,
            r.[Procedure] ,
            r.ProgramCode ,
            r.ClinicianName ,
            r.Comment ,
            r.ServiceId ,
            CASE WHEN r.ScreenId IS NULL THEN NULL
                 ELSE r.DocumentId
            END AS DocumentId ,
            r.ScreenId,
            r.AddOnCodes,		--13.Feb.2017     Alok Kumar 
            r.Attachments,
            r.GroupName,
            r.GroupId,
            r.GroupServiceId 
    FROM    #ResultSet r
    ORDER BY r.DateOfService DESC  

-- Added by sourabh : to get CaremanagementId   
--select convert(varchar, CareManagementId) as CareManagementId  from Clients where ClientId = @ClientId      

    SELECT  CONVERT(VARCHAR, @CareManagementClientId) AS CareManagementId    
   
    RETURN  
  
  
GO

