/****** Object:  StoredProcedure [dbo].[ssp_SCGetSharedTablesForServices]    Script Date: 11/18/2011 16:25:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSharedTablesForServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetSharedTablesForServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSharedTablesForServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
  
CREATE PROCEDURE [dbo].[ssp_SCGetSharedTablesForServices]  
/******************************************************************************                                                                                                                                      
**File: SharedTables.cs                                                                                                                                      
**Name:SHS.DataServices                                                                                                                    
**Desc:Used to get all Shared Tables related to Services                                                                                                                   
**Return values:                                                                                                                                      
**                                                                                                                                                   
**  Parameters:                                                                                                                                      
**  Input       Output                                                                                                                                      
**                                                                                                                         
**  Auth:  Damanpreet                                                                                                                              
**  Date:  18 Aug 2011                                                                                                                                
*******************************************************************************                                                                                                                                      
**  Change History                                                                                                                                      
*******************************************************************************                                                                                                                                      
**  Date:         Author:                Description:                                                                                               
**  18 Aug 2011   Damanpreet              Created  
**  3  Oct 2011   Shifali				  Modified (removed hardcoded csps and in case of ''N'', fixed structure with 8 columns)
**  26 Dec 2013   Manju P                 To get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes
**  26 Apr 2016   Dhanil                   Added Place Of Service logic why: task #328 Engineering Improvement  
*******************************************************************************/                                             
AS                                                     
 BEGIN                                                                                       
                                                                                      
 BEGIN TRY                  
    
    Declare @LocationIdUsesSharedTable as char(1)    
    Declare @ProcedureCodeIdUsesSharedTable as char(1)    
    Declare @ProgramIdUsesSharedTable as char(1)    
    Declare @AttendingIdUsesSharedTable as char(1)    
    Declare @PlaceOfServiceIdUsesSharedTable as char(1)
    Declare @ClinicianIdUsesSharedTable as char(1)  
    
    Declare @ProgramIdSharedTableStoredProcedure as varchar(100)    
    Declare @LocationIdSharedTableStoredProcedure as varchar(100)    
    Declare @AttendingIdSharedTableStoredProcedure as varchar(100)       
    Declare @ProcedureCodeIdSharedTableStoredProcedure as varchar(100)      
    Declare @PlaceOfServiceIdSharedTableStoredProcedure as varchar(100)       
    Declare @ClinicianIdSharedTableStoredProcedure as varchar(100)
        
    Select @ProgramIdUsesSharedTable= ProgramIdUsesSharedTable
    ,@ProgramIdSharedTableStoredProcedure= ProgramIdSharedTableStoredProcedure,
    @AttendingIdUsesSharedTable=AttendingIdUsesSharedTable,    
    @AttendingIdSharedTableStoredProcedure = AttendingIdSharedTableStoredProcedure,
    @ProcedureCodeIdUsesSharedTable=ProcedureCodeIdUsesSharedTable,
    @ProcedureCodeIdSharedTableStoredProcedure=ProcedureCodeIdSharedTableStoredProcedure,
    @LocationIdUsesSharedTable=LocationIdUsesSharedTable,    
    @LocationIdSharedTableStoredProcedure = LocationIdSharedTableStoredProcedure,
    @PlaceOfServiceIdUsesSharedTable=PlaceOfServiceIdUsesSharedTable    
    ,@PlaceOfServiceIdSharedTableStoredProcedure=PlaceOfServiceIdSharedTableStoredProcedure
    ,@ClinicianIdUsesSharedTable = ClinicianIdUsesSharedTable
    ,@ClinicianIdSharedTableStoredProcedure = ClinicianIdSharedTableStoredProcedure
    From ServiceDropdownConfigurations       
                                                
     
   IF @AttendingIdUsesSharedTable=''Y''      
    BEGIN      
     --exec csp_GetClinicianDataForService -- Staff      
     EXEC @AttendingIdSharedTableStoredProcedure -- Attending  
       
    END       
    ELSE      
    BEGIN      
        
      SELECT   
      S.StaffId as AttendingId, S.LastName + '' ''+ S.FirstName AS AttendingName,  
      -1 AS ProgramId, '''' AS ProgramName,  
      -1 AS ProcedureCodeId, '''' AS ProcedureCodeName,  
      -1 AS LocationId, '''' AS LocationName
      ,-1 AS ClinicianId, '''' AS ClinicianName 
      FROM Staff S  
      WHERE S.StaffId = -1       
        
   END     
       
   IF @ProgramIdUsesSharedTable =''Y''      
    BEGIN      
     --exec ssp_SCGetDataFromPrograms --Programs                                                                       
    exec @ProgramIdSharedTableStoredProcedure -- Programs  
                    
    END      
    ELSE      
    BEGIN      
      SELECT   
      -1 AS AttendingId, ''''AS AttendingName,  
      P.ProgramId, P.ProgramName,  
      -1 AS ProcedureCodeId, '''' AS ProcedureCodeName,  
      -1 AS LocationId, '''' AS LocationName  
      ,-1 AS ClinicianId, '''' AS ClinicianName 
      FROM Programs P  
      WHERE P.ProgramId = -1      
    END    
                             
    --26 Apr 2016   Dhanil                          
    IF @ProcedureCodeIdUsesSharedTable =''Y''      
     BEGIN      
      --exec ssp_SCGetProcedureCodes --Procedure Codes                          
      exec @ProcedureCodeIdSharedTableStoredProcedure --Procedure Codes                          
     END      
     ELSE      
     BEGIN      
  SELECT   
  -1 AS AttendingId, ''''AS AttendingName,  
  -1 AS ProgramId, '''' AS ProgramName,  
  ProcedureCodeId, ProcedureCodeName,  
  -1 AS LocationId, '''' AS LocationName  
  ,-1 AS ClinicianId, '''' AS ClinicianName 
  FROM ProcedureCodes PC  
  WHERE PC.ProcedureCodeId = -1         
     END                          
                             
                                                  
   If @LocationIdUsesSharedTable =''Y''      
   BEGIN      
     --exec ssp_SCGetDataFromLocations --Locations   
     exec @LocationIdSharedTableStoredProcedure --Locations                                                                                                           
    END      
    ELSE      
  BEGIN      
   SELECT   
  -1 AS AttendingId, ''''AS AttendingName,  
  -1 AS ProgramId, '''' AS ProgramName,  
  -1 AS ProcedureCodeId, '''' AS ProcedureCodeName,  
  LocationId, LocationName  
  ,-1 AS ClinicianId, '''' AS ClinicianName 
  FROM Locations LC  
  WHERE LC.LocationId = -1  
  END     
    
    
    IF @ClinicianIdUsesSharedTable=''Y''      
    BEGIN      
     --exec csp_GetClinicianDataForService -- Clinician      
     EXEC @ClinicianIdSharedTableStoredProcedure -- Clinician  
       
    END       
    ELSE      
    BEGIN      
        
      SELECT   
      -1 as AttendingId, '''' AS AttendingName,  
      -1 AS ProgramId, '''' AS ProgramName,  
      -1 AS ProcedureCodeId, '''' AS ProcedureCodeName,  
      -1 AS LocationId, '''' AS LocationName,
       S.StaffId as ClinicianId, S.DisplayAs AS ClinicianName
      FROM Staff S  
      WHERE S.StaffId = -1 
      
   END   
   
   IF @PlaceOfServiceIdUsesSharedTable=''Y''      
    BEGIN      
     EXEC @PlaceOfServiceIdSharedTableStoredProcedure -- Place Of Service  
       
    END   
        
                                     
 END TRY                                                                                                          
BEGIN CATCH                                                                                            
	DECLARE @Error varchar(8000)                                                                                                                                    
		 SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                     
		 + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCGetSharedTablesForServices'')                                                                                                                                     
		 + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                     
		 + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                                                   
	RAISERROR                                                                            
	(                                                                              
		 @Error, -- Message text.                                                                                                  
		 16, -- Severity.                       
		 1 -- State.                                                              
	);                                                                                                                                    
END CATCH                         
 END  
' 
END
GO
