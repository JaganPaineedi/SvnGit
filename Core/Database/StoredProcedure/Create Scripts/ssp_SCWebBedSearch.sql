/****** Object:  StoredProcedure [dbo].[ssp_SCWebBedSearch]    Script Date: 01/03/2014 12:11:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebBedSearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebBedSearch]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebBedSearch]    Script Date: 01/03/2014 12:11:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[ssp_SCWebBedSearch] --'2010-11-03 00:00:00.000','',-1,0,0,0,0,0,0      
     /* Param List */
    @FromDate DATETIME ,
    @ToDate DATETIME ,
    @ProgramId INT ,
    @UnitId INT ,
    @RoomId INT ,
    @Type1 INT ,
    @Type2 INT ,
    @Type3 INT ,
    @Type4 INT,
    @BedName VARCHAR(100) = ''
    ,@StaffId INT=0
AS 
/*********************************************************************/                                                      
/* Stored Procedure: dbo.ssp_SCWebBedSearch                              */                                                      
/* Creation Date:    30/07/2010                                         */                                                      
/*                                                                   */                                                      
/* Purpose:   Populate the BedSearch Page in the application        */                                                      
/* Input Parameters:@FromDate,@ToDate,@ProgramId,@UnitId ,@RoomId,@Type1,@Type2,@Type3,@Type4-*/                                                      
/*                                                                   */                                                      
/* Output Parameters:   None                                         */                                                      
/*                                                                   */                                                      
/* Return:  0=success, otherwise an error number                 */                                                      
/*                                                                   */                                                      
/* Called By:                  */                                                      
/*                                                                   */                                                      
/* Calls:                                                            */                                                      
/*                                                                   */                                                      
/* Data Modifications:                                               */                                                      
/*                                                                   */                                                      
/* Updates:                                                          */                                                      
/*   Date        Author                 Purpose              */                                                      
/*  30/07/2010   Damanpreet Kaur        Created          */   
/*  01/12/2010   Davinder Kumar         Embed Bed Available Slot     */  
/*  06/21/2011	 Wasif Butt				Bed search updated for bed types */  
/*  07/10/2012   Shruthi.S              Added RoomId             */      
/*  19/11/2013   Akwinass               Implemented Date instead DateTime*/  
-- 19-12-2013    Akwinass               Based on the program, fillter applied    
-- 02-01-2014    Akwinass               Datetime to Date CAST Implemented.   
-- 08-july-2014  Akwinass               parameter @BedName included to filter based on bed name as per task #1548 in Core Bugs  
-- 26 May 2015      Veena               Added ShowOnBedCensus conditions in filter Philhaven Development #248
-- 27-Jan-2016   Akwinass               Since Time field is not managed on Search Popup, Date Cast Implemented task #372 in Philhaven Development        
-- 21-SEP-2016		Akwinass			Included BlockBeds table to avoid pulling blocked beds (Task #630 Renaissance - Dev Items)
-- 24-July-2018	Deej				Added Logic to  bind the records only for the staff has access to Units and Programs. Bradford - Enhancements #400.2
/*********************************************************************/                                                      
                          
    BEGIN                       
        BEGIN TRY      
	   --Added by Deej
		  DECLARE @ListDataBasedOnStaffsAccessToProgramsAndUnits varchar(3)  
		  --SET @ListDataBasedOnStaffsAccessToProgramsAndUnits= CASE WHEN ssf_GetSystemConfigurationKeyValue( 'EnableStaffsAssociatedUnitAndProgramsFilteringInData') = 'Yes' THEN 'Y'
		  SELECT @ListDataBasedOnStaffsAccessToProgramsAndUnits = CASE WHEN [Value]='Yes' THEN 'Y' ELSE 'N' END 
		  FROM SystemConfigurationKeys WHERE [Key]= 'FilterDataBasedOnStaffAssociatedToProgramsAndUnits'  
        DECLARE @FromDateTime DATETIME = @FromDate
		DECLARE @ToDateTime DATETIME = NULL

		IF @ToDate <> ''
			AND @FromDateTime <> ''
		BEGIN
			SET @FromDateTime = CONVERT(DATETIME, GETDATE(), 120)
		END

		    SELECT  BS.BedId ,
                    BS.BedName ,
                    BS.DisplayAs AS BedDisplayAs ,
                    BAH.StartDate AS StartDate ,
                    BAH.EndDate AS EndDate ,
                    PS.ProgramCode ,
                    PS.ProgramId AS ProgramId ,
                    PS.ProgramName ,
                    US.UnitName ,
                    US.DisplayAs AS UnitDisplayAs ,
                    RS.RoomName ,
                    RS.DisplayAs AS RoomDisplayAs ,--GlobalCodes.CodeName as [Type]              
                    GC1.CodeName AS Type1 ,
                    GC2.CodeName AS Type2 ,
                    GC3.CodeName AS Type3 ,
                    GC4.CodeName AS Type4 ,
                    BAH.LocationId ,
                    BAH.ProcedureCodeId ,
                    --BS.DisplayAs AS BedName,
                    BS.RoomId As FRoomId,
                    PS.InpatientProgram,
                    PS.ResidentialProgram
            into #BedSearch
            FROM Units AS US
			INNER JOIN UnitAvailabilityHistory UAH ON UAH.UnitId = US.UnitId
			INNER JOIN Rooms AS RS ON US.UnitId = RS.UnitId
				AND (
					ISNULL(RS.RecordDeleted, 'N') = 'N'
					AND ISNULL(RS.Active, 'Y') = 'Y'
					)
				AND (
					ISNULL(US.RecordDeleted, 'N') = 'N'
					AND ISNULL(US.Active, 'Y') = 'Y'
			--   Added ShowOnBedCensus conditions in filter Philhaven Development #248
                    AND ISNULL(US.ShowOnBedCensus,'N') = 'Y' 
					
					)
			INNER JOIN RoomAvailabilityHistory RAH ON RAH.RoomId = RS.RoomId
				AND ISNULL(RAH.RecordDeleted, 'N') = 'N'
			INNER JOIN Beds AS BS ON RS.RoomId = BS.RoomId
				AND (
					ISNULL(BS.RecordDeleted, 'N') = 'N'
					AND ISNULL(BS.Active, 'Y') = 'Y'
					)
			INNER JOIN BedAvailabilityHistory AS BAH ON BS.BedId = BAH.BedId
				AND ISNULL(BS.RecordDeleted, 'N') = 'N'
				AND ISNULL(BAH.RecordDeleted, 'N') = 'N'
				AND BAH.EndDate IS NULL
			INNER JOIN Programs AS PS ON BAH.ProgramId = PS.ProgramId
				AND (
					ISNULL(PS.RecordDeleted, 'N') = 'N'
					AND ISNULL(PS.Active, 'Y') = 'Y'
					)
     
     --Test              
                    LEFT OUTER JOIN GlobalCodes AS GC1 ON GC1.GlobalCodeId = BS.Type1
                                                          AND ISNULL(GC1.RecordDeleted,
                                                              'N') = 'N'
                    LEFT OUTER JOIN GlobalCodes AS GC2 ON GC2.GlobalCodeId = BS.Type2
                                                          AND ISNULL(GC2.RecordDeleted,
                                                              'N') = 'N'
                    LEFT OUTER JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = BS.Type3
                                                          AND ISNULL(GC3.RecordDeleted,
                                                              'N') = 'N'
                    LEFT OUTER JOIN GlobalCodes AS GC4 ON GC4.GlobalCodeId = BS.Type4
                                                          AND ISNULL(GC4.RecordDeleted,
                                                              'N') = 'N'             
     --End              
     
            WHERE   
				    --Added by Deej 7/24/2018
                       (@ListDataBasedOnStaffsAccessToProgramsAndUnits='N' or (@ListDataBasedOnStaffsAccessToProgramsAndUnits='Y' and
				    (EXISTS(select 1 from StaffUnits SU WHERE SU.StaffId=@StaffId AND SU.UnitId=US.UnitId and ISNULL(SU.Recorddeleted,'N')='N' )
				    AND EXISTS(SELECT 1 FROM StaffPrograms SP WHERE SP.StaffId=@StaffId AND SP.ProgramId=PS.ProgramId AND ISNULL(SP.RecordDeleted,'N')='N'  ) ))) AND	
				( BAH.ProgramId = @ProgramId
                      OR @ProgramId = -1
                    )
                    AND ( RS.UnitID = @UnitId
                          OR @UnitId = 0
                        )
                    AND ( RS.RoomId = @RoomId
                          OR @RoomId = 0
                        )
                    AND ( BS.Type1 = @Type1
                          OR @Type1 = 0
                        )
                    AND ( BS.Type2 = @Type2
                          OR @Type2 = 0
                        )
                    AND ( BS.Type3 = @Type3
                          OR @Type3 = 0
                        )
                    AND ( BS.Type4 = @Type4
                          OR @Type4 = 0
                        )
                    -- 08-july-2014  Akwinass
					AND (ISNULL(BS.DisplayAs,'')) like '%'+@BedName+'%'
					and CAST(bah.StartDate as Date) <= CAST(@FromDateTime as Date) and (CAST(bah.EndDate as Date) >= CAST(@FromDateTime as Date) or bah.EndDate is null)
					and rah.StartDate <= CAST(@FromDateTime as Date) and (rah.EndDate >= CAST(@FromDateTime as Date) or rah.EndDate is null)
					and uah.StartDate <= CAST(@FromDateTime as Date) and (uah.EndDate >= CAST(@FromDateTime as Date) or uah.EndDate is null)
					and not exists
					(select * 
					from BedAssignments ba
					JOIN Beds b2 ON (ba.BedId = b2.BedId)
					JOIN Rooms r2 ON (b2.RoomId = r2.RoomId)
					where b2.BedId = BS.BedId
					and b2.RoomId = BS.RoomId
					and R2.UnitId = US.UnitId
					and isnull(ba.RecordDeleted,'N') = 'N'
					and (ba.EndDate IS NULL OR (CAST(ba.EndDate as Date) = CAST(@FromDateTime as Date) AND Disposition IS NULL)OR CAST(ba.EndDate as Date) > CAST(@FromDateTime as Date))
					and (@ToDateTime is null or CAST(ba.StartDate as Date) <= CAST(@FromDateTime as Date))
					-- If Bed Assignment is on leave or scheduled leave, check if bed is marked as hold
					and (ba.[Status] not in (5005, 5006) or ba.BedNotAvailable = 'Y'))					   
				
			IF @ToDate = ''
			BEGIN
				SELECT *
				FROM #BedSearch BS
				WHERE BS.ResidentialProgram = 'Y'
				AND NOT EXISTS(SELECT 1 FROM BlockBeds BB WHERE BB.BedId = BS.BedId AND BB.StartDate <= @FromDate AND (BB.EndDate >= @FromDate OR BB.EndDate IS NULL ) AND ISNULL(BB.RecordDeleted,'N') = 'N' )
			END
			ELSE
			BEGIN
				SELECT *
				FROM #BedSearch BS
				WHERE BS.StartDate >= CAST(@FromDate as Date)
					AND (
						BS.EndDate <= CAST(@ToDate as Date)
						OR BS.EndDate IS NULL
						)
					AND BS.ResidentialProgram = 'Y'
					AND NOT EXISTS (SELECT 1 FROM BlockBeds BB WHERE BB.BedId = BS.BedId AND (@FromDate BETWEEN BB.StartDate AND ISNULL(BB.EndDate,CAST('9999-12-31' AS DATE)) OR @ToDate BETWEEN BB.StartDate AND ISNULL(BB.EndDate,CAST('9999-12-31' AS DATE))) AND ISNULL(BB.RecordDeleted, 'N') = 'N')
			END
    -- commented because doesn't fit search criteria
    -- And  ((@FromDate <= BAS.Startdate And BAS.Enddate <= @ToDate)  
    --Or (@FromDate >= BAS.Startdate And BAS.Enddate >= @FromDate And BAS.EndDate <= @ToDate)  
    --Or (@FromDate >= BAS.StartDate And BAS.EndDate >= @ToDate)  
    --Or (@FromDate <= BAS.StartDate And BAS.EndDate >= @ToDate And BAS.StartDate <= @ToDate)  
    --Or (BAS.StartDate <= @FromDate And @FromDate <= BAS.EndDate))       
        END TRY              
        BEGIN CATCH                
            DECLARE @Error VARCHAR(8000)                                  
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'ssp_SCWebBedSearch') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE())                                  
                                
            RAISERROR                                   
   (                                  
    @Error, -- Message text.                                  
    16, -- Severity.                                  
    1 -- State.                                  
   ) ;                   
        END CATCH                                                                             
              
    END








GO


