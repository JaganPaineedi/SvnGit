
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageBedCensus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageBedCensus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPageBedCensus]
    @SessionId VARCHAR(30) ,
    @InstanceId INT ,
    @PageNumber INT ,
    @PageSize INT ,
    @SortExpression VARCHAR(100) ,
    @ClientId INT ,
    @Status INT ,
    @ProgramId INT ,
    @UnitId INT ,
    @RoomId INT ,
    @BedId INT ,
    @CensusDate DATETIME ,
    @OtherFilter INT  ,  
    @StaffId  Int    --     25-Sep-2016        Vamsi                                        
                                                  
/********************************************************************************                                                                                
-- Stored Procedure: dbo.ssp_SCListPageBedCensus2                                                                                 
--                                                                                
-- Copyright: Streamline Healthcate Solutions                                                                                
--                                                                                
-- Purpose: used by Bed Census list page                                                                                
--                                                                                
-- Updates:                                                                                                                                       
-- Date				Author				Purpose                                                                                
-- 01.18.2012		Wasif Butt           BedCensus Listpage data.  
-- 03.09.2012		Wasif Butt			Issue related to duplicate row number generated causing a system error                                
-- 08.JUL.2012		MSuma				Removed ListPageTable using CTE                              
-- 09-12-2013       Akwinass            Filter the Query based on ResidentialProgram And Implemented DateTime to Date(varchar) Convertion
-- 31-12-2013       Akwinass            Removed Implemented DateTime to Date(varchar) Convertion and Implemented DateTime to Date CAST for @CensusDate Parameter.
-- 06-01-2014       Akwinass            Modified Query to Show the discharged bed.
-- 11-03-2014       Akwinass            Public custom table created '#CustomFilters' as per deej comments.
-- 11-04-2014       Akwinass            Program Code pulled instead program Name for task #979 in philhaven customization issues.
-- 26 SEP 2014      Akwinass            Added New Column BedAdmissionRequiresOrder,BedDischargeRequiresOrder With Ref To Task#1205 - Philhaven - Customization Issues Tracking
-- 26 May 2015      Veena               Added ShowOnBedCensus conditions in filter Philhaven Development #248**
-- 03 JUNE 2015     Akwinass            Included 5006(On Leave) Status (Task#1282 - Philhaven - Customization Issues Tracking)
--12 Dec 2015	    Basudev Sahu		Modified For Task #609 Network180 Customization
-- 27-Jan-2016      Akwinass            Time field is managed based on Bed Availability History task #372 in Philhaven Development
-- 28-Jan-2016      Akwinass            For Occupied Beds, Time field is managed based on Bed Availability History task #372 in Philhaven Development
-- 24-May-2016		PradeepA			Added Discharged status filter and Primary Plan #187 Bradford Customizations
-- 11-July-2016		Vithobha			Modified the logic to check @ProgramId from BedAvailabilityHistory to BedAssignments, Bradford - Support Go Live: #53
-- 21-SEP-2016		Akwinass			Included BlockBeds table to avoid pulling blocked beds (Task #630 Renaissance - Dev Items)
-- 25-Sep-2016        Vamsi               Modified the logic to get Flag types which have permission, Woods - Support Go Live: #229  
-- 24-July-2018	Deej				Added Logic to  bind the records only for the staff has access to Units and Programs. Bradford - Enhancements #400.2
-- 30-July-2018		Bibhu				what:Added join with staffclients table to display associated clients for login staff  
          							   why:Engineering Improvement Initiatives- NBL(I) task #77 
*********************************************************************************/
AS 
BEGIN
BEGIN TRY
    DECLARE @ResultSetTemp TABLE
        (
          RowNumber INT ,
          PageNumber INT ,
          ClientName VARCHAR(50) ,
          [Status] VARCHAR(100) NULL ,
          ActivityStatusId INT NULL ,
          AdmitDate VARCHAR(20) ,
          DischargedDate VARCHAR(20) ,
          RequestedDate DATETIME NULL ,
          ScheduledDate DATETIME NULL ,
          BedName VARCHAR(50) ,                                          
--  Comment Varchar(max),                                          
          ClientId INT ,
          FUnitId INT ,
          FRoomId INT ,
          EBedId INT ,
          StartDate DATETIME NULL ,
          EndDate DATETIME NULL ,
          BStatus INT NULL ,
          BDisposition INT NULL ,
          DClientInPatientVisitId INT NULL ,
          BedAssignmentId INT NULL ,
          ProgramName VARCHAR(100) ,                             
--  ProgramCode Varchar(100),                                      
          ProgramId INT ,
          Exclamation VARCHAR(100) ,
          BedDisplayAs VARCHAR(100) ,
          UnitDisplayAS VARCHAR(100) ,
          RoomDisplayAs VARCHAR(100) ,
          ProcedureCodeId INT ,
          NextBAId INT ,
          NextBAStatus INT ,
          PreviousBAStatus INT                             
--  ,LocationId int                                        
    
        )   
  
    DECLARE @ResultSet TABLE
        (
          RowNumber INT ,
          PageNumber INT ,
          ClientName VARCHAR(50) ,
          [Status] VARCHAR(100) NULL ,
          ActivityStatusId INT NULL ,
          AdmitDate VARCHAR(20) ,
          DischargedDate VARCHAR(20) ,
          RequestedDate DATETIME NULL ,
          ScheduledDate DATETIME NULL ,
          BedName VARCHAR(50) ,                                          
  --Comment Varchar(max),                                          
          ClientId INT ,
          FUnitId INT ,
          FRoomId INT ,
          EBedId INT ,
          StartDate DATETIME NULL ,
          EndDate DATETIME NULL ,
          BStatus INT NULL ,
          BDisposition INT NULL ,
          DClientInPatientVisitId INT NULL ,
          BedAssignmentId INT NULL ,
          ProgramName VARCHAR(100) ,                             
  --ProgramCode Varchar(100),                                      
          ProgramId INT ,
          Exclamation VARCHAR(100) ,
          BedDisplayAs VARCHAR(100) ,
          UnitDisplayAS VARCHAR(100) ,
          RoomDisplayAs VARCHAR(100) ,
          ProcedureCodeId INT ,
          NextBAId INT ,
          NextBAStatus INT ,
          PreviousBAStatus INT                            
                              
  --,LocationId int                                           
        )                                                          
                                        
    CREATE TABLE #CustomFilters
        (
          BedAssignmentId INT ,
          BedId INT
        )                                         
    DECLARE @CustomFiltersApplied CHAR(1)                                          
    DECLARE @Today DATETIME                                               
    DECLARE @ApplyFilterClicked CHAR(1)                                                                
    DECLARE @bedAssignmentId INT    
    --Added by Deej
    DECLARE @ListDataBasedOnStaffsAccessToProgramsAndUnits varchar(3)  
    --SET @ListDataBasedOnStaffsAccessToProgramsAndUnits= CASE WHEN ssf_GetSystemConfigurationKeyValue( 'EnableStaffsAssociatedUnitAndProgramsFilteringInData') = 'Yes' THEN 'Y'
    SELECT @ListDataBasedOnStaffsAccessToProgramsAndUnits = CASE WHEN [Value]='Yes' THEN 'Y' ELSE 'N' END 
    FROM SystemConfigurationKeys WHERE [Key]= 'FilterDataBasedOnStaffAssociatedToProgramsAndUnits'       
             
    SET @SortExpression = RTRIM(LTRIM(@SortExpression))                                            
    SET @bedAssignmentId = -1000          
                                      
    IF ISNULL(@SortExpression, '') = '' 
        SET @SortExpression = 'ClientName desc'    
    
    SET @ApplyFilterClicked = 'Y' 
    SET @CustomFiltersApplied = 'N'                                          
                                          
                      
                                                                                 
    SET @Today = CAST(GETDATE() as Date)                                                         
                                          
-- Get custom filters                                     
                                                    
    IF @OtherFilter > 10000 
        BEGIN                                          
                                        
            SET @CustomFiltersApplied = 'Y'                                                
                                          
            INSERT  INTO #CustomFilters
                    ( BedAssignmentId ,
                      BedId  
                    )
           EXEC scsp_SCListPageBedCensus @SessionId
				,@InstanceId
				,@PageNumber
				,@PageSize
				,@SortExpression
				,@ClientId
				,@Status
				,@ProgramId
				,@UnitId
				,@RoomId
				,@BedId
				,@CensusDate
				,@OtherFilter 
        END        
 
    
   -- Bed Assignments  
;
    WITH    BedAssignmentSResults
              AS ( SELECT   ba.BedAssignmentId ,
                            ba.BedId,
                            NULL AS BlockBedId
                   FROM     BedAssignments ba
                            JOIN Beds BS ON ( ba.BedId = BS.BedId )
                            JOIN Rooms RS ON ( BS.RoomId = RS.RoomId )
                            JOIN BedAvailabilityHistory BAH ON ( ba.BedId = bah.BedId )
                            -- 09-12-2013       Akwinass            Filter the Query based on ResidentialProgram
                            JOIN Programs PR ON(ba.ProgramId=PR.ProgramId AND PR.ResidentialProgram='Y')
                   WHERE    
				    --Added by Deej 7/24/2018
                       (@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
									exists(select 1 from StaffPrograms SP where SP.StaffId=@StaffId AND SP.ProgramId=PR.ProgramId 
											AND ISNULL(SP.RecordDeleted,'N')='N' ))) AND
									
							( @CustomFiltersApplied = 'Y'
                              AND EXISTS ( SELECT   *
                                           FROM     #CustomFilters cf
                                           WHERE    cf.BedAssignmentId = ba.BedAssignmentId )
                            )
                            OR ( @CustomFiltersApplied = 'N'
                                 AND ( @Status = 0 -- All  
                                       OR ( @Status = 1
                                            AND BA.Status = 5002
                                          ) -- Occupied  
                                       OR ( @Status = 2
                                            AND BA.Status IN ( 5001, 5003,
                                                              5004, 5005, 5007 )
                                          ) -- Scheduled  
                                       OR ( @Status = 3
                                            AND BA.Status = 5006
                                          ) -- On Leave  
                                       OR ( @Status = 5
											AND BA.StartDate IS NOT NULL AND BA.EndDate IS NOT NULL AND BA.Disposition = 5205
										  ) -- Discharged
                                       
                                     )
                                     -- 11-July-2016		Vithobha
                                 AND ( ba.ProgramId = @ProgramId
                                       OR @ProgramId = -1
                                     )
                                 AND ( RS.UnitID = @UnitId
                                       OR @UnitId = 0
                                     )
                                 AND ( RS.RoomId = @RoomId
                                       OR @RoomId = 0
                                     )
                                 AND ( BS.BedId = @BedId
                                       OR @BedId = 0
                                     )
                                 AND ISNULL(ba.RecordDeleted, 'N') = 'N'
                                 AND CAST(ba.StartDate as Date) <= CAST(@CensusDate as Date)
                                 AND ISNULL(BAH.RecordDeleted, 'N') = 'N'
                                 AND (  
      -- Bed Assignments that are current  
                                       ( ( ba.EndDate IS NULL
                                         OR CAST(ba.EndDate as Date) > CAST(@CensusDate as Date)
                                         )
                                       )
                                       OR  
      -- Bed Assignments with dispositions due on the date  
                                       ( CAST(ba.EndDate as Date) = CAST(@CensusDate as Date)
                                         AND ba.Disposition IS NOT NULL
                                       )
                                       OR  
      -- Bed Assignments where disposition is overdue and end date was up to 90 days old  
                                       (
											CAST(ba.EndDate as Date) >= DATEADD(dd, - 90, CAST(@CensusDate as Date) )
											AND ba.Disposition IS NULL
											)
										)
                                 AND CAST(bah.StartDate as Date) <= CAST(@CensusDate as Date)
                                 AND (CAST(bah.EndDate as Date) >= CAST(@CensusDate as Date) OR bah.EndDate IS NULL)
                               )
                   UNION ALL
   -- Logic for Open Beds  
                   SELECT   NULL ,
                            BS.BedId,
                            BB.BlockBedId
                   FROM     Units AS US
                            INNER JOIN UnitAvailabilityHistory UAH ON UAH.UnitId = US.UnitId
                            INNER JOIN Rooms AS RS ON US.UnitId = RS.UnitId
                                                      AND ( ISNULL(RS.RecordDeleted,
                                                              'N') = 'N'
                                                            AND ISNULL(RS.Active,
                                                              'Y') = 'Y'
                                                          )
                                                      AND ( ISNULL(US.RecordDeleted,
                                                              'N') = 'N'
                                                            AND ISNULL(US.Active,
                                                              'Y') = 'Y'
                                                              	--   Added ShowOnBedCensus conditions in filter Philhaven Development #248
                                                              AND ISNULL(US.ShowOnBedCensus,'N') = 'Y' 
                                                          )
                            INNER JOIN RoomAvailabilityHistory RAH ON RAH.RoomId = RS.RoomId
                                                              AND ISNULL(RAH.RecordDeleted,
                                                              'N') = 'N'
                            INNER JOIN Beds AS BS ON RS.RoomId = BS.RoomId
                                                     AND ( ISNULL(BS.RecordDeleted,
                                                              'N') = 'N'
                                                           AND ISNULL(BS.Active,
                                                              'Y') = 'Y'
                                                         )
                            INNER JOIN BedAvailabilityHistory AS BAH ON BS.BedId = BAH.BedId
                                                              AND ISNULL(BS.RecordDeleted,
                                                              'N') = 'N'
                                                              AND ISNULL(BAH.RecordDeleted,
                                                              'N') = 'N'
                                                             AND BAH.EndDate IS NULL
                            -- 09-12-2013       Akwinass            Filter the Query based on ResidentialProgram
                            INNER JOIN Programs AS PS ON (BAH.ProgramId = PS.ProgramId AND PS.ResidentialProgram='Y')
                                                         AND ( ISNULL(PS.RecordDeleted,
                                                              'N') = 'N'
                                                              AND ISNULL(PS.Active,
                                                              'Y') = 'Y'
                                                             )
                            LEFT JOIN BlockBeds BB ON BS.BedId = BB.BedId AND BB.StartDate <= @CensusDate AND (BB.EndDate >= @CensusDate OR BB.EndDate IS NULL ) AND ISNULL(BB.RecordDeleted,'N') = 'N'
                   WHERE    
			    --Added by Deej 7/24/2018
                       (@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
									(EXISTS(select 1 from StaffUnits SU WHERE SU.StaffId=@StaffId AND SU.UnitId=US.UnitId and ISNULL(SU.Recorddeleted,'N')='N' )
									AND EXISTS(SELECT 1 FROM StaffPrograms SP WHERE SP.StaffId=@StaffId AND SP.ProgramId=PS.ProgramId AND ISNULL(SP.RecordDeleted,'N')='N'  ) ))) AND

			    ( @CustomFiltersApplied = 'Y'
                              AND EXISTS ( SELECT   *
                                           FROM     #CustomFilters cf
                                           WHERE    cf.BedId = BS.BedId )
                            )
                            OR ( @CustomFiltersApplied = 'N'
								AND ( @Status = 0 -- All  
                                       OR ( @Status = 4 -- Open
                                            AND BB.BlockBedId IS NULL
                                          )  
                                       OR ( @Status = 6 -- Blocked 
                                            AND BB.BlockBedId IS NOT NULL
                                          )                                        
                                     )                                 
                                 AND ( BAH.ProgramId = @ProgramId
                                       OR @ProgramId = -1
                                     )
                                 AND ( RS.UnitID = @UnitId
                                       OR @UnitId = 0
                                     )
                                 AND ( RS.RoomId = @RoomId
                                       OR @RoomId = 0
                                     )
                                 AND ( BS.BedId = @BedId
                                       OR @BedId = 0
                                     )
                                 AND bah.StartDate <= @CensusDate
                                 AND (bah.EndDate >= @CensusDate OR bah.EndDate IS NULL)
                                 AND rah.StartDate <= CAST(@CensusDate as Date)
                                 AND ( rah.EndDate >= CAST(@CensusDate as Date)
                                       OR rah.EndDate IS NULL
                                     )
                                 AND uah.StartDate <= CAST(@CensusDate as Date)
                                 AND ( uah.EndDate >= CAST(@CensusDate as Date)
                                       OR uah.EndDate IS NULL
                                     )
                                 AND ISNULL(UAH.RecordDeleted, 'N') = 'N'
                                 AND NOT EXISTS ( SELECT    *
                                                  FROM      BedAssignments ba
                                                            JOIN Beds b2 ON ( ba.BedId = b2.BedId )
                                                            JOIN Rooms r2 ON ( b2.RoomId = r2.RoomId )
                                                  WHERE     b2.BedId = BS.BedId
                                                            AND b2.RoomId = BS.RoomId
                                                            AND R2.UnitId = US.UnitId
                                                            AND ISNULL(ba.RecordDeleted,
                                                              'N') = 'N'
                                                            AND ( ba.EndDate IS NULL
                                                              OR (CAST(ba.EndDate as Date) = CAST(@CensusDate as Date) and Disposition is null)
                                                              OR  CAST(ba.EndDate as Date) > CAST(@CensusDate as Date)
                                                              )
                                                            AND CAST(ba.StartDate as Date) <= CAST(@CensusDate as Date)  
     -- If Bed Assignment is on leave or scheduled leave, check if bed is marked as hold  
                                                            AND ( ba.[Status] NOT IN (
                                                              5005, 5006 )
                                                              OR ba.BedNotAvailable = 'Y'
                                                              ) )
                               )
                 ),
            RankResults
              AS (SELECT   CASE     -- modify by Basudev  for  network 180 task #609
						WHEN ISNULL(C.ClientType, 'I') = 'I'
						 THEN C.LastName + ', ' + C.FirstName
						ELSE C.OrganizationName
						END AS ClientName, 
              --SELECT   C.LastName + ', ' + C.FirstName AS ClientName ,
                            CASE WHEN CF.BlockBedId IS NOT NULL THEN 'Blocked'
								 WHEN CF.BedAssignmentId IS NULL THEN 'Open'
                                 WHEN BA.EndDate IS NULL
                                      OR CAST(BA.EndDate as Date) > CAST(@CensusDate as Date)
                                 THEN GC.CodeName
                                 WHEN CAST(BA.EndDate as Date) = CAST(@CensusDate as Date)
                                      AND BA.Disposition IS NOT NULL
                                 THEN GC2.CodeName
                                 WHEN CAST(BA.EndDate as Date) <= CAST(@CensusDate as Date)
                                      AND BA.Disposition IS NULL
                                      AND BA.NextBedAssignmentId IS NOT NULL
                                 THEN GC.CodeName
                                 WHEN CAST(BA.EndDate as Date) <= CAST(@CensusDate as Date)
										AND BA.Disposition IS NULL
										AND BA.NextBedAssignmentId IS NULL
										AND BA.Status IN(5001,5003,5004,5005,5006,5007)
								 THEN GC.CodeName
                                 WHEN CAST(BA.EndDate as Date) <= CAST(@CensusDate as Date)
                                      AND BA.Disposition IS NULL
                                      AND BA.NextBedAssignmentId IS NULL
                                      AND BA.Status = 5002
                                 THEN 'Scheduled Discharge'
                            END AS [Status] ,
                            BA.[Status] AS ActivityStatusId ,
                            CONVERT(NVARCHAR(50), CIV.AdmitDate, 101) AS AdmitDate ,
                            CIV.DischargedDate ,
                            CIV.RequestedDate ,
                            CIV.ScheduledDate ,
                            B.BedName ,  
--,BA.Comment  
                            CIV.ClientId ,
                            R.UnitId AS FUnitId ,
                            R.RoomId AS FRoomId ,
                            B.BedId AS EBedId ,
                            BA.StartDate ,
                            BA.EndDate ,
                            BA.Status AS BStatus ,
                            BA.Disposition AS BDisposition ,
                            CIV.ClientInpatientVisitId AS DClientInpatientVisitId ,
                            BA.BedAssignmentId ,
                            PR.ProgramCode AS ProgramName ,  
--,PS.ProgramCode  
                            PR.ProgramId ,
                            --26 SEP 2014   Akwinass
							ISNULL(PR.BedAdmissionRequiresOrder,'') AS BedAdmissionRequiresOrder,
							ISNULL(PR.BedDischargeRequiresOrder,'') AS BedDischargeRequiresOrder,
                            BPR.ProgramId AS BAProgramId ,
                            BPR.ProgramCode AS BAProgramName ,
                            CASE WHEN BA.EndDate < @Today
                                      AND BA.Disposition IS NULL
                                 THEN 'Past Due'
                                 ELSE 'False'
                            END AS Exclamation ,
                            B.DisplayAs AS BedDisplayAs ,
                            U.DisplayAs AS UnitDisplayAS ,
                            R.DisplayAs AS RoomDisplayAs ,
                            NULL AS ProcedureCodeId ,  
--,BAH.LocationId as LocationId                                      
                            BA.NextBedAssignmentId AS NextBAId ,
                            BA_Next.Status AS NextBAStatus ,
                            BA_Prev.Status AS PreviousBAStatus ,
                            ddo.DropdownOptions AS DropdownOptions,
                            dbo.ssf_GetPrimaryPlanName(CIV.ClientId) AS PrimaryPlan	
                   FROM     BedAssignmentsResults CF
                            JOIN Beds B ON ( CF.BedId = B.BedId )
                            JOIN Rooms R ON ( B.RoomId = R.RoomId )
                            JOIN Units U ON ( R.UnitId = U.UnitId  )
                            LEFT JOIN BedAssignments BA ON ( BA.BedAssignmentId = CF.BedAssignmentId )
                            LEFT JOIN ClientInpatientVisits CIV ON ( BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId )
                            LEFT JOIN BedAvailabilityHistory BAH ON ( B.BedId = bah.BedId
                                                              AND ISNULL(bah.RecordDeleted,'N') = 'N'
                                                              AND ( bah.EndDate IS NULL OR (bah.EndDate > GETDATE() AND CF.BedAssignmentId IS NOT NULL))
                                                              )
                            LEFT JOIN Programs PR ON ( BAH.ProgramId = PR.ProgramId )
                            LEFT JOIN Programs BPR ON ( BA.ProgramId = BPR.ProgramId )
                            LEFT JOIN Clients C ON ( CIV.ClientId = C.ClientId )
                            LEFT JOIN BedAssignments BA_Next ON ( BA.NextBedAssignmentId = BA_Next.BedAssignmentId
                                                              AND ISNULL(BA_Next.RecordDeleted,
                                                              'N') = 'N'
                                                              )
                            LEFT JOIN BedAssignments BA_Prev ON ( BA.BedAssignmentId = BA_Prev.NextBedAssignmentId
                                                              AND ISNULL(BA_Prev.RecordDeleted,
                                                              'N') = 'N'
                                                              )
                            LEFT JOIN GlobalCodes GC ON ( BA.Status = GC.GlobalCodeId )
                            LEFT JOIN GlobalCodes GC2 ON ( BA.Disposition = GC2.GlobalCodeId )
                            LEFT JOIN BedCensusStatusChangeDropdowns ddo ON ( ((ISNULL(BA.[Status], 1) = ISNULL(ddo.BedAssignmentStatus, 1) AND CF.BlockBedId IS NULL) OR (ISNULL(BA.[Status], 1) = 1 AND ISNULL(ddo.BedAssignmentStatus, 1) = 5009 AND CF.BlockBedId IS NOT NULL))
                                                              AND ( ddo.PreviousAssignmentOccupied IS NULL
                                                              OR ( ddo.PreviousAssignmentOccupied = 'Y'
                                                              AND BA_Prev.[Status] = 5002
                                                              )
                                                              OR ( ddo.PreviousAssignmentOccupied = 'N'
                                                              AND BA_Prev.[Status] <> 5002
                                                              )
                                                              )
                                                              AND ( ddo.PreviousAssignmentOnLeave IS NULL
                                                              OR ( ddo.PreviousAssignmentOnLeave = 'Y'
                                                              AND BA_Prev.[Status] = 5006
                                                              )
                                                              OR ( ddo.PreviousAssignmentOnLeave = 'N'
                                                              AND BA_Prev.[Status] <> 5006
                                                              )
                                                              )
                                                              AND ( ddo.PreviousAssignmentScheduledOnLeave IS NULL
                                                              OR ( ddo.PreviousAssignmentScheduledOnLeave = 'Y'
                                                              AND BA_Prev.[Status] = 5005
                                                              )
                                                              OR ( ddo.PreviousAssignmentScheduledOnLeave = 'N'
                                                              AND BA_Prev.[Status] <> 5005
                                                              )
                                                              )
                                                              AND ( ddo.DispositionIsNull IS NULL
                                                              OR ( ddo.DispositionIsNull = 'Y'
                                                              AND BA.Disposition IS NULL
                                                              )
                                                              OR ( ddo.DispositionIsNull = 'N'
                                                              AND BA.Disposition IS NOT NULL
                                                              )
                                                              )
                                                              AND ( ddo.NextAssignmentIsNull IS NULL
                                                              OR ( ddo.NextAssignmentIsNull = 'Y'
                                                              AND BA.NextBedAssignmentId IS NULL
                                                              )
                                                              OR ( ddo.NextAssignmentIsNull = 'N'
                                                              AND BA.NextBedAssignmentId IS NOT NULL
                                                              )
                                                              )
                                                              )
                                                              	--   Added ShowOnBedCensus conditions in filter Philhaven Development #248
                                                              WHERE ISNULL(U.ShowOnBedCensus,'N') = 'Y' AND
												  --Added by Deej 7/24/2018
												(@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
												EXISTS(select 1 from StaffUnits SU WHERE SU.StaffId=@StaffId AND SU.UnitId=U.UnitId and ISNULL(SU.Recorddeleted,'N')='N' ))) 
												AND (Exists (Select 1 From  StaffClients SC Where  SC.ClientId=C.ClientId AND SC.StaffId=@StaffId ) 
												OR C.ClientId IS NULL )-- 30-July-2018  Bibhu 
   --WHERE  BA.StartDate IS NOT NULL
                            
                 ),
            counts
              AS ( SELECT   COUNT(*) AS totalrows
                   FROM     RankResults
                 ),
            FinalResults
              AS ( SELECT   ClientName ,
                            [Status] ,
                            ActivityStatusId ,
                            AdmitDate ,
                            DischargedDate ,
                            RequestedDate ,
                            ScheduledDate ,
                            BedName ,
                            ClientId ,
                            FUnitId ,
                            FRoomId ,
                            EBedId ,
                            StartDate ,
                            EndDate ,
                            BStatus ,
                            BDisposition ,
                            DClientInPatientVisitId ,
                            BedAssignmentId ,
                            ProgramName ,
                            ProgramId ,
                            --26 SEP 2014   Akwinass
							BedAdmissionRequiresOrder,
							BedDischargeRequiresOrder,
                            BAProgramName ,
                            BAProgramId ,
                            Exclamation ,
                            BedDisplayAs ,
                            UnitDisplayAS ,
                            RoomDisplayAs ,
                            ProcedureCodeId ,
                            NextBAId ,
                            NextBAStatus ,
                            PreviousBAStatus ,
                            DropdownOptions ,
                            PrimaryPlan,
                            COUNT(*) OVER ( ) AS TotalCount ,
                            RANK() OVER ( ORDER BY CASE WHEN @SortExpression = 'ClientName'
                                                        THEN ClientName
                                                   END, CASE WHEN @SortExpression = 'ClientName desc'
                                                             THEN ClientName
                                                        END DESC, CASE
                                                              WHEN @SortExpression = 'Status'
                                                              THEN [Status]
                                                              END, CASE
                                                              WHEN @SortExpression = 'Status desc'
                                                              THEN [Status]
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'Admitted'
                                                              THEN AdmitDate
                                                              END, CASE
                                                              WHEN @SortExpression = 'Admitted desc'
                                                              THEN AdmitDate
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'DischargedDate'
                                                              THEN DischargedDate
                                                              END, CASE
                                                              WHEN @SortExpression = 'DischargedDate desc'
                                                              THEN DischargedDate
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'Flags'
                                                              THEN ( SELECT
                                                              dbo.GetNoteTypeByClientId(ClientId)
                                                              )
                                                              END, CASE
                                                              WHEN @SortExpression = 'Flags desc'
                                                              THEN ( SELECT
                                                              dbo.GetNoteTypeByClientId(ClientId)
                                                              )
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'BedName'
                                                              THEN BedDisplayAs
                                                              END, CASE
                                                              WHEN @SortExpression = 'BedName desc'
                                                              THEN BedDisplayAs
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'Note'
                                                              THEN ( SELECT
                                                              dbo.GetNoteTypeByClientId(ClientId)
                                                              )
                                                              END, CASE
                                                              WHEN @SortExpression = 'Note desc'
                                                              THEN ( SELECT
                                                              dbo.GetNoteTypeByClientId(ClientId)
                                                              )
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'ProgramName'
                                                              THEN BAProgramName
                                                              END, CASE
                                                              WHEN @SortExpression = 'ProgramName desc'
                                                              THEN BAProgramName
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'RoomName'
                                                              THEN RoomDisplayAs
                                                              END, CASE
                                                              WHEN @SortExpression = 'RoomName desc'
                                                              THEN RoomDisplayAs
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'UnitName'
                                                              THEN UnitDisplayAs
                                                              END, CASE
                                                              WHEN @SortExpression = 'UnitName desc'
                                                              THEN UnitDisplayAs
                                                              END DESC,CASE
                                                              WHEN @SortExpression = 'PrimaryPlan'
                                                              THEN PrimaryPlan
                                                              END, CASE
                                                              WHEN @SortExpression = 'PrimaryPlan desc'
                                                              THEN PrimaryPlan
                                                              END DESC, ISNULL(BedAssignmentId, EBedId) ) AS RowNumber  
                   FROM     RankResults
                 )
        SELECT TOP ( CASE WHEN ( @PageNumber = -1 )
                          THEN ( SELECT ISNULL(totalrows, 0)
                                 FROM   counts
                               )
                          ELSE ( @PageSize )
                     END )
                ClientName ,
                [Status] ,
                ActivityStatusId ,
                AdmitDate ,
                DischargedDate ,
                RequestedDate ,
                ScheduledDate ,
                BedName ,
                ClientId ,
                FUnitId ,
                FRoomId ,
                EBedId ,
                StartDate ,
                EndDate ,
                BStatus ,
                BDisposition ,
                DClientInPatientVisitId ,
                BedAssignmentId ,
                ProgramName ,
                ProgramId ,
                --26 SEP 2014   Akwinass
				BedAdmissionRequiresOrder,
				BedDischargeRequiresOrder,
                BAProgramName ,
                BAProgramId ,
                Exclamation ,
                BedDisplayAs ,
                UnitDisplayAS ,
                RoomDisplayAs ,
                ProcedureCodeId ,
                NextBAId ,
                NextBAStatus ,
                PreviousBAStatus ,
                DropdownOptions ,
                PrimaryPlan,
                TotalCount ,
                RowNumber
              --NextBedAssignmentStatus,
        INTO    #FinalResultSet
        FROM    FinalResults
        WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 
                           
    IF ( SELECT ISNULL(COUNT(*), 0)
         FROM   #FinalResultSet
       ) < 1 
        BEGIN
            SELECT  0 AS PageNumber ,
                    0 AS NumberOfPages ,
                    0 NumberOfRows
        END
    ELSE 
        BEGIN
            SELECT TOP 1
                    @PageNumber AS PageNumber ,
                    CASE ( TotalCount % @PageSize )
                      WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)
                      ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1
                    END AS NumberOfPages ,
                    ISNULL(TotalCount, 0) AS NumberOfRows
            FROM    #FinalResultSet     
        END                    

       SELECT  frs.ClientName ,  
            frs.[Status] ,  
            frs.ActivityStatusId ,  
            frs.AdmitDate ,  
            frs.DischargedDate ,  
            frs.RequestedDate ,  
            frs.ScheduledDate ,  
            frs.BedName ,  
            frs.ClientId ,  
            frs.FUnitId ,  
            frs.FRoomId ,  
            frs.EBedId ,  
            ISNULL(frs.StartDate, @CensusDate) AS StartDate ,  
            frs.EndDate ,  
            frs.BStatus ,  
            frs.BDisposition ,  
            frs.DClientInpatientVisitId ,  
            frs.BedAssignmentId ,  
            frs.ProgramName ,  
            frs.ProgramId ,  
            --26 SEP 2014   Akwinass  
            frs.BedAdmissionRequiresOrder,  
            frs.BedDischargeRequiresOrder,  
            frs.BAProgramName ,  
            frs.BAProgramId ,  
            frs.Exclamation ,  
            frs.BedDisplayAs ,  
            frs.UnitDisplayAS ,  
            frs.RoomDisplayAs ,  
            frs.ProcedureCodeId ,  
            frs.NextBAId ,  
            frs.NextBAStatus ,  
            gc.CodeName + ' - ' + CONVERT(VARCHAR(50), bedas.StartDate, 101) AS NextBAStatusDisplayAs ,  
            frs.PreviousBAStatus ,  
            frs.DropdownOptions ,  
            frs.PrimaryPlan,  
            NEWID() AS UniqueRowIdentity ,             
            ( SELECT    dbo.ssf_GetNoteTypeWithPermission(frs.ClientId,@StaffId)  -- Vamsi 25-Sep-2016  
             ) AS TypeId   
            
    FROM    #FinalResultSet frs
            LEFT JOIN dbo.GlobalCodes gc ON frs.NextBAStatus = gc.GlobalCodeId
            LEFT JOIN dbo.BedAssignments bedas ON bedas.BedAssignmentId = frs.NextBAId
            
    ORDER BY RowNumber
            



END TRY
              
BEGIN CATCH
	DECLARE	@Error VARCHAR(8000)       
	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
				 'ssp_SCListPageBedCensus') + '*****'
		+ CONVERT(VARCHAR, ERROR_LINE()) + '*****'
		+ CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
		+ CONVERT(VARCHAR, ERROR_STATE())
	RAISERROR
(
	@Error, -- Message text.
	16,		-- Severity.
	1		-- State.
);
END CATCH 
RETURN



END

GO


