/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataForAdmitFromBedCensus]    Script Date: 11/18/2011 16:25:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataForAdmitFromBedCensus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDataForAdmitFromBedCensus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataForAdmitFromBedCensus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_SCGetDataForAdmitFromBedCensus]     -- ssp_SCGetDataForAdmitFromBedCensus 11                 
(      
 @ClientInPatientVisitId int      
)                     
AS                      
/******************************************************************************                            
**  File: BedCensus Admit Page in (BedCensus Module)                            
**  Name:           
**  Desc:            
**  Return values:                             
**  Called by: [ssp_SCGetDataForAdmitFromBedCensus]                             
**  Parameters:        
**  Auth:  Munish Singla             
**  Date:  2 July 2009                        
*******************************************************************************                            
**  Change History                            
*******************************************************************************                            
**  Date:       Author:    Description:                            
**  --------  --------    ----------------------------------------------------                            
**   20/Oct/2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.           
							why:task #609, Network180 Customization                  
*******************************************************************************/                          
BEGIN                      
BEGIN TRY          
Select BA.ClientInpatientVisitId as InPatientVisitID , CONVERT(varchar(10),BA.StartDate,101) as StartDate, CONVERT(varchar(10),BA.EndDate,101) as nextActivityDate,      
BA.ProgramId as ProgramId,BA.LocationId as LocationId,BA.ProcedureCodeId as ProcedureCodeID,BA.Reason as Reason,BA.[type] as AssignmentType,      
--Case When BA.Billable = ''Y'' then ''True'' Else ''False'' End as Billable,
 GC.CodeName as nextActivity,      
Case When  BA.ProgramId <> BAVH.ProgramId Then ''True'' Else ''False'' End as OverFlow,      
Room.DisplayAs as RoomDisplayAS,      
Unit.DisplayAs  as UnitDisplayAs,      
(Bed.DisplayAs  +  ''('' + Rtrim(P.ProgramCode) + '')'')as BedDisplayAs,      
BA.Comment as Comment,      
C.ClientId as ClientId, 
-- Modified by  Revathi 20/Oct/2015    
case when  ISNULL(C.ClientType,''I'')=''I'' then (ISNULL(C.FirstName,'''') + '', '' + ISNULL(C.LastName,'''')) else ISNULL(C.OrganizationName,'''') end as ClientName          
from BedAssignments as BA       
Inner Join Programs as P      
   On P.ProgramId = BA.ProgramId      
Inner Join GlobalCodes as GC      
 On GC.GlobalCodeId = BA.[Status]       
Inner Join Beds as Bed      
 On Bed.BedId = BA.BedId      
Inner Join Rooms as Room       
    on Room.RoomId = Bed.RoomId      
Inner Join Units as Unit      
    On Unit.UnitId = Room.UnitId      
Inner Join ClientInpatientVisits as CIPV          
    on CIPV.ClientInpatientVisitId = BA.ClientInpatientVisitId      
Inner Join Clients as C      
    on C.ClientId= CIPV.ClientId      
Inner Join BedAvailabilityHistory as BAVH      
   on BAVH.BedId = BA.BedId         
 where  BA.ClientInpatientVisitId = @ClientInPatientVisitId and IsNUll(BA.RecordDeleted,''N'') = ''N''      
          
END TRY                        
BEGIN CATCH                         
DECLARE @Error varchar(8000)                          
 SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                           
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[ssp_SCGetDataForAdmitFromBedCensus'')                           
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                            
    + ''*****'' + Convert(varchar,ERROR_STATE())                          
                      
 RAISERROR                           
 (                          
  @Error, -- Message text.                          
  16, -- Severity.                          
  1 -- State.                          
 );                          
                          
END CATCH                       
END  ' 
END
GO
