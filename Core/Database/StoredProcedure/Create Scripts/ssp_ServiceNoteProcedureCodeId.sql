/****** Object:  StoredProcedure [dbo].[ssp_ServiceNoteProcedureCodeId]    Script Date: 02/12/2016 13:25:46 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_ServiceNoteProcedureCodeId]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_ServiceNoteProcedureCodeId];
GO


/****** Object:  StoredProcedure [dbo].[ssp_ServiceNoteProcedureCodeId]    Script Date: 02/12/2016 13:25:46 ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

     
CREATE PROCEDURE [dbo].[ssp_ServiceNoteProcedureCodeId]
    @ClientId INT
  , @DateOfService DATETIME
  , @ProgramId INT
  , @AttendingId INT
  , @ProcedureCodeId INT
  , @LocationId INT
  , @PlaceOfServiceId INT
  , @ClinicianId INT              
/********************************************************************************                                                              
-- Stored Procedure: dbo.ssp_ServiceNoteProcedureCodeId                                                                
--                                                              
-- Copyright: Streamline Healthcate Solutions                                                              
--                                                              
-- Purpose: To get Procedures based on Clinician License/Degree on date of service and  Associated program  to bind on service screens                                                              
--                                                              
-- Updates:                                                                                                                     
-- Date        Author            Purpose                                                              
-- 01.21.2013  SFarber           Fixed 'in last 6 months' calculation logic for Care Plan       
-- 02.17.2013  Maninder Singh    when we create new Service in case  ClinicianID set as -1 parameter that pass into "csp_ServiceNoteProcedureCodeId" Sp (used to fill Procedure DropDown on change of Program DropDown)  ref task #2751 in Thresholds Bugs and 
  
    
Features                                
-- 03.21.2013  Jeff Riley        Modified - Do not display any procedures if effective date is null       
-- 04.16.2013  Jeff Riley        Modified - Updated MHA logic to include MHAs that happen on the same day as date of service                                   
-- 06.02.2013  Javed Husain      Modified - Updated logic for ProcedureCodes.AllowAllPrograms and ProcedureCodes.AllowAllLicensesDegrees  
-- 7.17.2013   Jeff Riley        Modified - Fixed bug where @IntakeDate was being populated from wrong ClientEpisode field  
-- 11.15.2013  Jeff Riley        Modified - Fixed bug where treatment dev would be removed if DOS was on same date as intake date  
-- 7.16.2014   Jeff Riley        Modified - Removed use of temp table to improve performance                      
-- 02/12/2016  Chethan N		 Converted to Core       
-- 02/10/2017  jcarlson          Keystone Customizations 69 - increased ProcedureCodeName length to 500 to handle procedure code display as increasing to 75  
-- 02/23/2017  jcarlson		     Keystone Customizations 55 - Added logic to handle effective dates being added to programprocedure table
--12/05/2018   Vinay K S		 Modified - Now pulls procedure codes based on system config key "AllowSchedulingBeyondLicenseExpirationDate".MHP - Enhancements - 333 (Licensure/Procedure Code functionality)
*********************************************************************************/
AS
    BEGIN              
			 --12/05/2018          
        DECLARE @GracePeriodSystemConfigKey INT
        SET @GracePeriodSystemConfigKey = ISNULL((SELECT CAST(VALUE AS INT) FROM SYSTEMCONFIGURATIONKEYS WHERE [Key]='AllowSchedulingBeyondLicenseExpirationDate'),0)
		
        DECLARE @ProcedureCodes1 TABLE (
              ProcedureCodeId INT NOT NULL
            , ProcedureCodeName VARCHAR(500)
            );        
            
  
        
-- Get list of Procedure Codes that have been Prescribed or do not require prescription        
        INSERT  INTO @ProcedureCodes1 ( ProcedureCodeId, ProcedureCodeName )
        SELECT  pc.ProcedureCodeId, pc.DisplayAs
        FROM    ProcedureCodes pc
        WHERE   ISNULL(pc.RecordDeleted, 'N') = 'N'
                AND ISNULL(pc.Active, 'N') = 'Y';  
  
        
        
-- Filter procedure codes by         
-- (1) Clinician License/Degree on date of service        
-- (2) Associated with program        
  
        IF @DateOfService IS NOT NULL
            BEGIN    
        
                SELECT DISTINCT
                        pc.ProcedureCodeId, pc.ProcedureCodeName
                FROM    ProcedureCodes pc
                LEFT JOIN ProgramProcedures pp ON ( pc.ProcedureCodeId = pp.ProcedureCodeId )
                                                  AND ISNULL(pp.RecordDeleted, 'N') = 'N'
                WHERE   ISNULL(pp.RecordDeleted, 'N') = 'N'
                        AND ISNULL(pc.RecordDeleted, 'N') = 'N'
                        AND ISNULL(Active, 'N') = 'Y'   
						--only grab procedure codes for the program selected if they are effective today
                        AND ( ( ( ( pp.StartDate IS NULL
                                    OR CONVERT(DATE, pp.StartDate) <= CONVERT(DATE, @DateOfService)
                                  )
                                  AND ( pp.EndDate IS NULL
                                        OR CONVERT(DATE, pp.EndDate) >= CONVERT(DATE, @DateOfService)
                                      )
                                )
                                AND ( pp.ProgramId = @ProgramId )
                              )
								 --if no program selected, then all pc codes can be displayed
                              OR ISNULL(@ProgramId, -1) = -1
                              OR pc.AllowAllPrograms = 'Y'
                            )
                        AND ( pc.AllowAllLicensesDegrees = 'Y'
                              OR EXISTS ( SELECT    *
                                          FROM      ProcedureCodeStaffCredentials pcsc
                                          JOIN      StaffLicenseDegrees sld ON ( pcsc.DegreeLicenseType = sld.LicenseTypeDegree )
                                          WHERE     ( sld.StaffId = @ClinicianId
                                                      OR @ClinicianId = -1
                                                    )
                                                    AND pcsc.ProcedureCodeId = pc.ProcedureCodeId
                                                    AND sld.StartDate <= @DateOfService
                                                    AND ( sld.EndDate IS NULL
                                                          --12/05/2018                                              
                                                      OR DATEADD(month,@GracePeriodSystemConfigKey,sld.EndDate) >= CAST(@DateOfService AS DATE)  
                                                        )
                                                    AND ISNULL(sld.RecordDeleted, 'N') = 'N'
                                                    AND ISNULL(pcsc.RecordDeleted, 'N') = 'N' )
                            )
                ORDER BY pc.ProcedureCodeName;      
     
     
            END;    
        ELSE
            BEGIN    
                DELETE  FROM @ProcedureCodes1;    
      
                SELECT DISTINCT
                        p.ProcedureCodeId, p.ProcedureCodeName
                FROM    @ProcedureCodes1 p;        
            END;      
  
             
    END;       
  
GO


