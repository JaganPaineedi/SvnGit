/****** Object:  StoredProcedure [dbo].[ssp_PMClientClaimsAndServices]    Script Date: 11/18/2016 11:15:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMClientClaimsAndServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMClientClaimsAndServices]
GO


/****** Object:  StoredProcedure [dbo].[ssp_PMClientClaimsAndServices]    Script Date: 11/18/2016 11:15:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PMClientClaimsAndServices]
     @ClientId INT ,   --Pass @ClientId                     
    @Status INT ,
    @FromDate DATETIME ,
    @ToDate DATETIME ,
    @InsurerId INT ,
    @Type CHAR(1) = NULL ,
    @ClinicianId INT = -1 ,
    @ProgramId INT = -1 ,
    @OtherFilter INT,
    @StaffId INT= NULL,
    @ServicesfromClaims char(1)='N',
    @AddOnCodes char(1)='N'				--13.Feb.2017     Alok Kumar
AS /******************************************************************************   
	** File: ssp_PMClientClaimsAndServices.sql  
	** Name: ssp_PMClientClaimsAndServices  
	** Desc:    
	**   
	**   
	** This template can be customized:   
	**   
	** Return values: Filter Values - Client Services List Page  
	**   
	** Called by:   
	**   
	** Parameters:   
	** Input Output   
	** ---------- -----------   
	** 
	** Auth: Mary Suma  
	** Date: 09/07/2011  
	*******************************************************************************   
	** Change History   
	*******************************************************************************   
	** Date:		Author:			Description:   
	** 09/07/2011  Mary Suma		Client Services List Page 
	** 09/09/2011  Mary Suma		Included Custom Filter
	** 21/04/2012  Mary Suma		Modified Condition on Staff  
	** 2/28/2013   Vishant Garg     We are showing claim lines and services on services list page .so onclick of 
									list page we need to open the respective detail screens.
									Added a column screenid to set in openpage on the basis of type.
									with ref to task # 505 i 3.x issues
	**05/17/2013 sharath kumar katta Modified The Status Varchar(50) TO Varchar(250) With Ref to Task #70 3.5x(newaygo)
	**07/20/2015 njain				Removed RecordDeleted check on ProcedureCodes, per Javed
	**03/25/2016 Gautam				Added code to see those services that are in a Program that is associated to the Staff Account based on sys key 'ShowAllClientsServices'
									Why : Engineering Improvement Initiatives- NBL(I) > Tasks#297 	
	05.Aug.2016     Basudev     Changed code to see those services from claims if filter @ServicesfromClaims = 'Y' 
								Why : CEI - Support Go Live Task #233 	
	18.Nov.2016     TRemisoski  Limit charge results so only on service line is displayed.		
	12-Dec-2016  	Gautam         Modify code to display Units ,Keystone - Customizations #43 
	02/10/2017      jcarlson       Keystone Customizations 69 - increased procedurecode length to 150 to handle procedure code display as increasing to 75
	21.Feb.2017     Alok Kumar	Added a new filter 'Add On Codes' and a new column to the List page. 
								Why : Harbor - Support	Task #1003. 
	07.Apr.2017     Alok Kumar	Modified length of the variable @StrSqlQuery  from VARCHAR(1000) to  NVARCHAR(MAX).  Ref : Harbor - Support	Task #1003. 
	06.Jul.2017		Gautam		Modified code for Performance issue.,Thresholds - Support, Task#991								
	24-NOV-2017   Akwinass    Added "Attachments" column (Task #589 in Engineering Improvement Initiatives- NBL(I))
	16/03/2018     Neha           What: Added a new column 'Group Name' to display the Group name if the document is a Group Service Note.
                                  Why: MHP-Enhancements – Task# 193
    06/02/2019     Kavya    What: Added condition to take the original status when the status other than service related statuses Why: CEI SGL#772
	*******************************************************************************/  
    
    BEGIN                                                                
        BEGIN TRY 
	
            SET  XACT_ABORT ON      
       
/****************************************************************************************************************/      
            IF EXISTS ( SELECT  *
                        FROM    sysobjects
                        WHERE   type = 'U'
                                AND name = '#TEMPCLIENTCLAIMSANDSERVICES' )
                BEGIN      
  --PRINT 'Dropping Table #TEMPCLIENTCLAIMSANDSERVICES'      
                    DROP  TABLE  #TEMPCLIENTCLAIMSANDSERVICES      
                END      
--declare @clientId int      
			 -- 03/25/2016     Gautam   
		   DECLARE @ShowAllClientsServices CHAR(1)='Y'   
		   Create Table #StaffPrograms
		   (ProgramId int)
		   
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
			-- end Gautam
			
            CREATE TABLE #TEMPCLIENTCLAIMSANDSERVICES
                (
                  Type CHAR ,
                  DateOfService DATETIME ,
                  ProcedureCode VARCHAR(155) ,
                  StatusId INT ,
                  Status VARCHAR(250) ,
                  Clinician VARCHAR(100) ,
                  ServiceId INT ,
                  ClinicianId INT ,
                  ProgramId INT ,
                  Program VARCHAR(100) ,
                  LocationId INT ,
                  Location VARCHAR(100) ,
                  Charge MONEY ,
                  Payment MONEY ,
                  [ClientBal] MONEY ,
                  [3rdPartyBal] MONEY ,
                  ClaimLineId INT ,
                  DisDateOfService VARCHAR(50) ,
                  ScreenId INT ,
				  Units DECIMAL(18,2),
				  AddOnCodes VARCHAR(Max),		--13.Feb.2017     Alok Kumar
				  ProcedureCodeId Int,
				  Attachments INT,
				  GroupName  varchar(100), 
				  GroupId int,      
				  GroupServiceId int
                )      
         
--set @ClientId = 1      
            INSERT  INTO #TEMPCLIENTCLAIMSANDSERVICES
                    ( Type ,
                      DateOfService ,
                      ProcedureCode ,
                      StatusId ,
                      Status ,
                      Clinician ,
                      ServiceId ,
                      ClinicianId ,
                      ProgramId ,
                      Program ,
                      LocationId ,
                      Location ,
                      Charge ,
                      Payment ,
                      [ClientBal] ,
                      [3rdPartyBal] ,
                      ClaimLineId ,
                      DisDateOfService ,

--Added By Vishant Garg
                      ScreenId ,
					  AddOnCodes,		--13.Feb.2017     Alok Kumar
					  ProcedureCodeId,
					  GroupName, 
				      GroupId ,      
				      GroupServiceId 
                    )
                    SELECT  'S' AS Type ,
                            CONVERT(VARCHAR, A.DateofService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), A.DateOfService, 100), 12, 8)) AS DateOfService ,
                            [Procedure] AS ProcedureCode ,
                            A.Status AS StatusId ,
                            GlobalCodes.CodeName + RTRIM(ISNULL(' (' + RTRIM(CancelReason) + ')', '')) AS Status ,   -- Modified by rohit to add cancel reason. ref PM #1134.
                            CASE Staff.Degree
                              WHEN ISNULL(Staff.Degree, 0) THEN Staff.LastName + ', ' + Staff.FirstName + ' ' + ISNULL(GCD.CodeName, '')
                              ELSE Staff.LastName + ', ' + Staff.FirstName
                            END AS Clinician ,
                            A.ServiceId AS serviceId ,
                            ClinicianId AS ClinicianId ,      
  --Staff.LastName+', '+Staff.FirstName +' '+ Convert(varchar,Staff.Degree) AS ClinicianName,      
                            Programs.ProgramId AS ProgramId ,
                            Programs.ProgramCode AS Program ,
                            A.LocationId AS locationId ,
                            Locations.LocationCode AS Location ,
                            Charge ,
                            Payment AS Payment ,
                            [ClientBal] ,
                            [3rdPartyBal] ,
                            0 AS claimLineId ,
                            A.DateofService AS DisDateOfService ,
  
--Added By Vishant Garg
                            207,    --screenif for servicedetails  
							NULL AS AddOnCodes,		--13.Feb.2017     Alok Kumar
							A.ProcedureCodeId,
							null  as GroupName,
						    null as GroupId,
							null as GroupServiceId
                    FROM    ( 
						---- we want to get one charge where the priority is either 1 or 0.  If there is a charge with priority 1, use it.  Otherwise use the priority 0 charge
						--select * from (
						--	select * from (
								SELECT    ProcedureCodes.DisplayAs + ' ' + SUBSTRING(CONVERT(VARCHAR, Services.Unit), 0, CHARINDEX('.', CONVERT(VARCHAR, Services.Unit))) + ' ' + ISNULL(CONVERT(VARCHAR, GC.CodeName), RTRIM('')) AS "Procedure" ,
													Services.Status ,
													ProgramId ,
													ClinicianId ,
													LocationId ,
													Services.Charge AS Charge ,
													Services.DateOfService ,
													Services.ServiceId ,
													GCcancelReason.CodeName AS CancelReason
													--CONVERT(VARCHAR(25), Services.Unit) + ' ' +  ISnull(GC.CodeName,'') as Units  --02-Dec-2016  	Gautam 
													--row_number() over(partition by Services.ServiceId order by C.Priority desc) as Rnk
													,Services.ProcedureCodeId
										  FROM      ProcedureCodes
													RIGHT JOIN Services ON ProcedureCodes.ProcedureCodeId = Services.ProcedureCodeId
													LEFT JOIN GlobalCodes GC ON Services.UnitType = GC.GlobalCodeId
													LEFT JOIN GlobalCodes GCcancelReason ON GCcancelReason.GlobalCodeID = Services.CancelReason
																							AND GCcancelReason.Category = 'CancelReason' --Join added by Rohit. Ref. PM #1134
													-- T.Remisoski - 11.18.2016 - hot fix to limit charges to 1 per service                                                                                  
													--LEFT JOIN Charges C ON Services.ServiceId = C.ServiceId and C.Priority <= 1 and isnull(C.RecordDeleted, 'N') = 'N'                        
										  WHERE     Services.ClientId = @ClientId
													AND ( ( Services.RecordDeleted = 'N' )
														  OR ( Services.RecordDeleted IS NULL )
														)--basudev 05-Aug-2016
														  and (@ServicesfromClaims='Y' or (@ServicesfromClaims='N' and not exists(select 1 from ClaimLineServiceMappings CLSM where CLSM.ServiceId=Services.ServiceId AND ( ( CLSM.RecordDeleted = 'N' )
																  OR ( CLSM.RecordDeleted IS NULL )
																) )))  
													--AND ( ( ProcedureCodes.RecordDeleted = 'N' )
													--      OR ( ProcedureCodes.RecordDeleted IS NULL )
													--    )
								--) as internal
							 -- ) as filter where filter.Rnk = 1	
                            ) A
                            LEFT JOIN GlobalCodes ON A.Status = GlobalCodes.GlobalCodeId
                            LEFT JOIN Programs ON A.ProgramId = Programs.ProgramId  
 --Added by MSuma
                            LEFT JOIN Staff ON A.ClinicianId = Staff.StaffId
                            LEFT JOIN GlobalCodes GCD ON Staff.Degree = GCD.GlobalCodeId
                              
 -- Commented by MSuma     
 --LEFT JOIN       
 --    (SELECT StaffId,FirstName,LastName,      
 --   Case Clinician      
 --    WHEN 'Y' THEN Degree      
 --    WHEN 'N' THEN null      
 --    Else Degree       
 --   END as Degree,GlobalCodes.CodeName      
 --  FROM Staff LEFT JOIN GlobalCodes ON Staff.Degree = GlobalCodes.GlobalCodeId ) as Staff       
 --  ON A.ClinicianId=Staff.StaffId      
       
 --      
                            LEFT JOIN Locations ON A.LocationId = Locations.LocationId
                            LEFT JOIN ( SELECT  SUM(Amount) * -1 AS Payment ,
                                                Services.ServiceId
                                        FROM    Services
                                                LEFT JOIN Charges ON Services.ServiceId = Charges.ServiceId
                                                LEFT JOIN ARLedger ON Charges.ChargeId = ARLedger.ChargeId
                                        WHERE   Services.ClientId = @ClientId
                                                AND ARLedger.LedgerType = 4202
                                                AND ( ( Services.RecordDeleted = 'N' )
                                                      OR ( Services.RecordDeleted IS NULL )
                                                    )
                                                AND ( ( Charges.RecordDeleted = 'N' )
                                                      OR ( Charges.RecordDeleted IS NULL )
                                                    )
                                                AND ( ( ARLedger.RecordDeleted = 'N' )
                                                      OR ( ARLedger.RecordDeleted IS NULL )
                                                    )
                                                and (@ServicesfromClaims='Y' or (@ServicesfromClaims='N' and not exists(select 1 from ClaimLineServiceMappings CLSM where CLSM.ServiceId=Services.ServiceId AND ( ( CLSM.RecordDeleted = 'N' )
                                                      OR ( CLSM.RecordDeleted IS NULL )
                                                    ) ))) 
                                        GROUP BY Services.ServiceId
                                      ) B ON A.ServiceId = B.ServiceId
                            LEFT JOIN ( SELECT  OpenCharges.Balance AS [ClientBal]/*ce]*/ ,
                                                Services.ServiceId
                                        FROM    Services
                                                LEFT JOIN Charges ON Services.ServiceId = Charges.ServiceId
                                                LEFT JOIN OpenCharges ON OpenCharges.ChargeID = Charges.ChargeId
                                        WHERE   priority = 0
                                                AND Services.ClientId = @ClientId
                                                AND ( ( Services.RecordDeleted = 'N' )
                                                      OR ( Services.RecordDeleted IS NULL )
                                                    )
                                                AND ( ( Charges.RecordDeleted = 'N' )
                                                      OR ( Charges.RecordDeleted IS NULL )
                                                    )
                                                AND ( ( OpenCharges.RecordDeleted = 'N' )
                                                      OR ( OpenCharges.RecordDeleted IS NULL )
                                                    )
                                                and (@ServicesfromClaims='Y' or (@ServicesfromClaims='N' and not exists(select 1 from ClaimLineServiceMappings CLSM where CLSM.ServiceId=Services.ServiceId AND ( ( CLSM.RecordDeleted = 'N' )
                                                      OR ( CLSM.RecordDeleted IS NULL )
                                                    ) ))) 
                                      ) C ON A.ServiceId = C.ServiceId
                            LEFT JOIN ( SELECT  SUM(OpenCharges.Balance) AS [3rdPartyBal]/*lance]*/ ,
                                                Services.ServiceId
                                        FROM    Services
                                                LEFT JOIN Charges ON Services.ServiceId = Charges.ServiceId
                                                LEFT JOIN OpenCharges ON OpenCharges.ChargeID = Charges.ChargeId
                                        WHERE   priority <> 0
                                                AND Services.ClientId = @ClientId
                                                AND ( ( Services.RecordDeleted = 'N' )
                                                      OR ( Services.RecordDeleted IS NULL )
                                                    )
                                                AND ( ( Charges.RecordDeleted = 'N' )
                                                      OR ( Charges.RecordDeleted IS NULL )
                                                    )
                                                AND ( ( OpenCharges.RecordDeleted = 'N' )
                                                      OR ( OpenCharges.RecordDeleted IS NULL )
                                                    )
                                        GROUP BY Services.ServiceId
                                      ) D ON A.ServiceId = D.ServiceId       
          
            -- Update Units (Claim units)  12-Dec-2016  	Gautam  
            Update C
            Set C.Units =ch2.Units
            From #TEMPCLIENTCLAIMSANDSERVICES C Inner Join 
				  (Select ServiceId,ChargeId,Units from 
                 (Select Ch.ServiceId,Ch.ChargeId,Ch.Units, row_number() over(partition by Ch.ServiceId order by Ch.ChargeId Asc) as RNK  
				  From Charges Ch Join #TEMPCLIENTCLAIMSANDSERVICES d ON Ch.ServiceId = d.ServiceId 
							and Ch.Priority <= 1 
				  Where isnull(Ch.RecordDeleted, 'N') = 'N'  )Ch1 
				  where RNK=1 ) ch2  on C.ServiceId = Ch2.ServiceId 
			

			--13.Feb.2017     Alok Kumar	(Updating AddOnCodes column)	--15.Mar.2017     Alok Kumar
			--06-July-2017	Gautam
			UPDATE  C 
			SET C.AddOnCodes = isnull(REPLACE(REPLACE(STUFF((
								SELECT DISTINCT ', ' +  PC.ProcedureCodeName FROM ProcedureCodes PC
								Join ServiceAddOnCodes SOC on PC.ProcedureCodeId= SOC.AddOnProcedureCodeId
								where SOC.ServiceId = C.ServiceId AND ISNULL(SOC.RecordDeleted, 'N') ='N'
								FOR XML PATH('')
								), 1, 1, ''), '&lt;', '<'), '&gt;', '>'), '')
			FROM    #TEMPCLIENTCLAIMSANDSERVICES C join ServiceAddOnCodes SOC1 
							   on SOC1.ServiceId = C.ServiceId AND ISNULL(SOC1.RecordDeleted, 'N') = 'N'
							   
			UPDATE C
			SET C.Attachments = (SELECT COUNT(ImageRecordId) FROM ImageRecords IR WHERE IR.ServiceId = C.ServiceId AND ISNULL(IR.RecordDeleted, 'N') = 'N')
			FROM #TEMPCLIENTCLAIMSANDSERVICES C
			JOIN ProcedureCodes PC ON C.ProcedureCodeId = PC.ProcedureCodeId
				AND ISNULL(PC.AllowAttachmentsToService, 'N') = 'Y'
				
			UPDATE C
			SET C.GroupName = IsNull(G.GroupName,''),
			C.GroupId=GS.GroupId,  
            C.GroupServiceId= GS.GroupServiceId 
			FROM #TEMPCLIENTCLAIMSANDSERVICES C
			
			Join Services S  ON C.ServiceId = S.ServiceId
            join GroupServices GS on S.GroupServiceId=GS.GroupServiceId  AND ISNULL(GS.RecordDeleted, 'N') = 'N'
            join Groups G ON GS.GroupId=G.GroupId  
             
			
            DECLARE @Filter NVARCHAR(1000)    
            SET @Filter = ''    
            DECLARE @StrSqlQuery NVARCHAR(MAX)			--07.Apr.2017     Alok Kumar
    
            IF @Type IS NOT NULL
                AND @Type <> ''
                BEGIN     
                    IF @Filter <> ''
                        BEGIN     
                            SET @Filter = @Filter + ' And Type =|' + CONVERT(VARCHAR, @Type) + '|'    
                        END    
                    ELSE
                        BEGIN     
                            SET @Filter = @Filter + ' Type=|' + CONVERT(VARCHAR, @Type) + '|'    
                        END    
                END    

            DECLARE @NewStatus VARCHAR(10)    
            IF @Status <> -1
                AND @Status <> ''
                BEGIN     
                    IF @Filter <> ''
                        BEGIN 
                            IF ( @Status = 759 )
                                SET @NewStatus = '70'
                            IF ( @Status = 760 )
                                SET @NewStatus = '75'
                            IF ( @Status = 761 )
                                SET @NewStatus = '71'
                            IF ( @Status = 762 )
                                SET @NewStatus = '73,72'
                            IF(@Status<> 759 and @Status<>760 and @Status<> 761 and @Status<>762)                            
                                SET @NewStatus=  @Status    
                            BEGIN    
                                SET @Filter = @Filter + ' And StatusId in(' + @NewStatus + ')'    
                            END
                        END    
                    ELSE
                        BEGIN     
                            SET @Filter = @Filter + ' StatusId in(' + CONVERT(VARCHAR, @Status) + ')'    
                        END     
                END    
    
            IF @ClinicianId <> -1
                AND @ClinicianId <> 0
                BEGIN    
                    IF @Filter <> ''
                        BEGIN     
                            SET @Filter = @Filter + ' And ClinicianId =' + CONVERT(VARCHAR, @ClinicianId)    
                        END    
                    ELSE
                        BEGIN     
                            SET @Filter = @Filter + ' ClinicianId =' + CONVERT(VARCHAR, @ClinicianId)    
                        END     
                END     
    
            IF @ProgramId <> -1
                AND @ProgramId <> 0
                BEGIN    
                    IF @Filter <> ''
                        BEGIN     
                            SET @Filter = @Filter + ' And ProgramId =' + CONVERT(VARCHAR, @ProgramId)    
                        END    
                    ELSE
                        BEGIN     
                            SET @Filter = @Filter + ' ProgramId =' + CONVERT(VARCHAR, @ProgramId)    
                        END     
                END     
    
    
            IF @ToDate IS NOT NULL
                BEGIN    
                    IF @Filter <> ''
                        BEGIN     
  -- set @Filter = @Filter + ' And DateOfService <=|'+ convert(varchar,@ToDate)+'|'    
                            SET @Filter = @Filter + ' And convert(datetime, convert(varchar, DateOfService, 101)) <= |' + CONVERT(VARCHAR, @ToDate, 101) + '|'          -- Bhupinder Bajwa Task # 276    
                        END    
                    ELSE
                        BEGIN     
                            SET @Filter = @Filter + ' convert(datetime, convert(varchar, DateOfService, 101)) <= |' + CONVERT(VARCHAR, @ToDate, 101) + '|'  -- Bhupinder Bajwa Task # 276     
                        END     
                END     
    
    
            IF @FromDate IS NOT NULL
                BEGIN    
                    IF @Filter <> ''
                        BEGIN     
                            SET @Filter = @Filter + ' And  convert(datetime, convert(varchar, DateOfService, 101)) >= |' + CONVERT(VARCHAR, @FromDate, 101) + '|'    -- Bhupinder Bajwa Task # 276    
                        END    
                    ELSE
                        BEGIN     
                            SET @Filter = @Filter + '  convert(datetime, convert(varchar, DateOfService, 101)) >= |' + CONVERT(VARCHAR, @FromDate, 101) + '|'     -- Bhupinder Bajwa Task # 276    
                        END     
                END     
			-- 03/25/2016     Gautam   
			IF ISNULL(@ShowAllClientsServices,'Y')='N'
				BEGIN
					SET @Filter = @Filter + ' AND EXISTS ( SELECT * FROM   #StaffPrograms SP WHERE  SP.ProgramId = T.ProgramId )'
				END
			
			--13.Feb.2017     Alok Kumar   
			IF ISNULL(@AddOnCodes,'N')='Y'
				BEGIN
					SET @Filter = @Filter + ' AND EXISTS ( SELECT 1 FROM   ServiceAddOnCodes ACS WHERE  ACS.ServiceId = T.ServiceId AND ISNULL(ACS.RecordDeleted, ''N'') = ''N'' )'		--15.Mar.2017     Alok Kumar
				END
				   
    
            IF @Filter IS NOT NULL
                AND @Filter <> ''
                BEGIN    
                    SET @StrSqlQuery = 'select  Type AS Type ,
												DateOfService AS DateOfService ,
												ProcedureCode AS ProcedureCode ,
												StatusId ,
												[Status] AS Status ,
												Clinician AS Clinician ,
												serviceId AS ServiceId ,
												ClinicianId ,
												ProgramId AS ProgramId ,
												Program AS Program ,
												LocationId AS LocationId ,
												Location AS Location ,
												Charge AS Charge ,
												Payment AS Payment ,
												[ClientBal] AS ClientBal ,
												[3rdPartyBal] AS [3rdPartyBal] ,
												ClaimLineId ,
												DisDateOfService ,
												ScreenId,
												Units,
												AddOnCodes,
												Attachments,
												GroupName AS GroupName,
												GroupId AS GroupId,
												GroupServiceId AS GroupServiceId
									from #TEMPCLIENTCLAIMSANDSERVICES T where ' + @Filter + ' order by DateOfService desc'    
                    SET @StrSqlQuery = REPLACE(@StrSqlQuery, '|', '''')    
                    EXEC (@StrSqlQuery)    
                END     
            ELSE
                BEGIN    
                    SELECT  Type AS Type ,
                            DateOfService AS DateOfService ,
                            ProcedureCode AS ProcedureCode ,
                            StatusId ,
                            [Status] AS Status ,
                            Clinician AS Clinician ,
                            serviceId AS ServiceId ,
                            ClinicianId ,
                            ProgramId AS ProgramId ,
                            Program AS Program ,
                            LocationId AS LocationId ,
                            Location AS Location ,
                            Charge AS Charge ,
                            Payment AS Payment ,
                            [ClientBal] AS ClientBal ,
                            [3rdPartyBal] AS [3rdPartyBal] ,
                            ClaimLineId ,
                            DisDateOfService ,
		--Added By Vishant Garg
                            ScreenId,
							Units,
							AddOnCodes,
							Attachments,
							GroupName,
							GroupId,
							GroupServiceId
                    FROM    #TEMPCLIENTCLAIMSANDSERVICES T
                    WHERE  ( @ShowAllClientsServices='Y' Or ( @ShowAllClientsServices='N' and 
								EXISTS ( SELECT *
                                                 FROM   #StaffPrograms SP
                                                 WHERE  SP.ProgramId = T.ProgramId )))
                           AND ( @AddOnCodes='N' Or ( @AddOnCodes='Y' and				--13.Feb.2017     Alok Kumar
								EXISTS ( SELECT 1 FROM   ServiceAddOnCodes ACS
                                                 WHERE  ACS.ServiceId = T.ServiceId AND ISNULL(ACS.RecordDeleted, 'N') = 'N' )))  --15.Mar.2017     Alok Kumar
                    ORDER BY DateOfService DESC        
                END    
     
    
    
--select convert(varchar, CareManagementId) as CareManagementId  from Clients where ClientId = @ClientId    -- added on 03 Jan 2007 (Bhupinder Bajwa REF Task #243)    
    
            SET  XACT_ABORT OFF  
        END TRY  
   
        BEGIN CATCH  
            DECLARE @Error VARCHAR(8000)         
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMClientClaimsAndServices') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
            RAISERROR  
	  (  
	   @Error, -- Message text.  
	   16,  -- Severity.  
	   1  -- State.  
	  );  
        END CATCH  
    END 

GO


