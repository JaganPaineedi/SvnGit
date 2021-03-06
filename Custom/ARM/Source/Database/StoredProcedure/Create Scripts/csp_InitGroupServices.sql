/****** Object:  StoredProcedure [dbo].[csp_InitGroupServices]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitGroupServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitGroupServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitGroupServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [dbo].[csp_InitGroupServices]  --0,92,''<Root><Parameters GroupID="318"   ></Parameters></Root>''                           
(                                                                        
 @ClientID int,                                        
 @StaffID int,                                      
 @CustomParameters xml                                         
)                                                                                                  
As                                                                                                    
 /*********************************************************************/                                                                                                              
 /* Stored Procedure: csp_InitGroupServices               */                                                                                                     
                                                                                                     
 /* Copyright: 2007 Streamline SmartCare*/                                                                                                              
                                                                                                     
 /* Creation Date:  7/May/2010                                    */                                                                                                              
 /*                                                                   */                                                                                                              
 /* Purpose: Get Infromation related to GroupService */                                                                                                             
 /*                                                                   */                                                                                                            
 /* Input Parameters: GroupID  */                                                                                                            
 /*                                                                   */                                                                                                               
 /* Output Parameters:                                */                                                                                                              
 /*                                                                   */                                                                                                              
 /* Return:   */                                                                                                              
 /*                                                                   */                                                                                                              
 /* Called By:Detail Class Of DataService    */                                                                                                    
 /*      */                                                                                                    
                                                                                                     
 /*                                                                   */                                                                                                              
 /* Calls:                                                            */                                                                                                              
 /*                                                                   */                                                                                                              
 /* Data Modifications:                                               */                           /*                                                                   */                        /*   Updates:                             */                 
                                                            
                                   
 /*       Date                Author                  Purpose     */                                                     
 /*   7/May/2010             Mohit Madan     Createded in SP*/
 /*	  Oct/03/2012			 Wasif Butt		 Added check for Active clients  */ 						                                                                                         
 /***********************************************************************************************/                                    
Begin                                                          
                                          
Begin try                                
                              
--Following option is reqd for xml operations                              
SET ARITHABORT ON                                 
                              
DECLARE @ClientPagePreferences VARCHAR(100)                       
DECLARE @GroupID INT                  
DECLARE @GroupStatus VARCHAR(500)                                                  
                            
SET @GroupID = @CustomParameters.value(''(/Root/Parameters/@GroupID)[1]'', ''int'' )                               
SELECT @ClientPagePreferences = ISNULL(ClientPagePreferences,'''') from Staff WHERE StaffId = @StaffID AND ISNULL(RecordDeleted,''N'') = ''N''                
SET @GroupStatus = (SELECT [dbo].[GetGroupStatus](@GroupId))                                                   
                              
  ---- Group -----                                                                                                                                     
     select ''Groups'' as TableName,                              
      G.GroupId                                            
      ,G.GroupName                                            
      ,G.GroupCode                                            
      ,G.GroupType                                            
      ,G.Comment                                            
      ,G.ProcedureCodeId                                            
      ,G.LocationId                                            
      ,G.ProgramId                                            
      ,G.ClinicianId                                            
      ,G.Unit                                            
      ,G.UnitType                                            
      ,G.Active                                            
      ,G.GroupNoteDocumentCodeId                                            
      ,G.RowIdentifier                                            
      ,G.CreatedBy                                            
      ,G.CreatedDate                                            
      ,G.ModifiedBy                                            
      ,G.ModifiedDate                                            
      ,G.RecordDeleted                                            
      ,G.DeletedDate                                            
      ,G.DeletedBy                                            
      ,''Scheduled'' as GroupStatusName
      ,70 as GroupStatus                                            
      ,GNDC.GroupNoteCodeId                                  
      ,GNDC.ServiceNoteCodeId                                   
      ,PC.EnteredAs AS UnitCode                                  
      ,GC.CodeName  AS UnitCodeName                      
      ,SC.ScreenId                        
      ,SC.ScreenURL                
      ,LTRIM(RTRIM(@ClientPagePreferences)) AS ClientPagePreferences                             
      ,''N'' as IsInitialize                                   
      from Groups G left outer join  GroupNoteDocumentCodes GNDC                                              
      ON G.GroupNoteDocumentCodeId  = GNDC.GroupNoteDocumentCodeId                                    
      LEFT OUTER JOIN ProcedureCodes PC ON G.ProcedureCodeId = PC.ProcedureCodeId                                              
      LEFT OUTER JOIN GlobalCodes GC ON PC.EnteredAs = GC.GlobalCodeId                        
      --LEFT OUTER JOIN Screens SC ON PC.AssociatedNoteId = SC.DocumentCodeId                                  
       LEFT OUTER JOIN Screens SC ON GNDC.ServiceNoteCodeId  = SC.DocumentCodeId                  
      where G.GroupId=@GroupId                               
      and ISNULL(G.RecordDeleted,''N'')=''N''                               
      and ISNULL(GNDC.RecordDeleted,''N'')=''N''                               
      and ISNULL(PC.RecordDeleted,''N'')=''N''                               
      and ISNULL(GC.RecordDeleted,''N'')=''N''                             
                              
                             
Declare @billable char(1)                         
select @billable= NotBillable  from Groups join ProcedureCodes on Groups.ProcedureCodeId=ProcedureCodes.ProcedureCodeId and GroupId=@GroupID                              
and ISNULL(ProcedureCodes.RecordDeleted,''N'')=''N''                               
and ISNULL(Groups.RecordDeleted,''N'')=''N''                         
                          
---- Group Services-----                              
                                                                
select ''GroupServices'' AS TableName,                         
GETDATE() AS DateOfService,                        
GroupId,                        
G.ProcedureCodeId,                        
Unit,UnitType,                        
ClinicianId,                        
ProgramId,                        
LocationId,              
Comment,                      
@billable AS Billable,                        
G.CreatedBy,                        
G.CreatedDate,                        
G.ModifiedBy,                        
G.ModifiedDate,                        
70 as Status,                        
G.RowIdentifier,
PC.MaxUnits,
PC.MinUnits  
from Groups G                    
Left Join ProcedureCodes PC    
On PC.ProcedureCodeId=G.ProcedureCodeId
where G.GroupId= @GroupID                         
and ISNULL(G.RecordDeleted,''N'')=''N''                              
                                
  ---- Services-----                
  IF object_id(''tempdb..#Notes'') IS NOT NULL                
  drop table #Notes                
create table #Notes (                                                
NoteId       int identity not null,                                                
ClientId     int          null,                                                
ClientNoteId int          null,                                  
GlobalCodeId int          null,                                      
NoteType     int          null,                                                
Bitmap       varchar(200) null,                                   
NoteNumber   int          null,                                                
Note         varchar(100) null,                
CodeName     varchar(250) null,                
Diagnosis1   char(6)      null,                
Diagnosis2   char(6)      null,                
Diagnosis3   char(6)      null                
)                                                
                                              
                                              
insert into #Notes (                                                
       ClientId,                                                
       ClientNoteId,                          
    GlobalCodeId,                                                
       NoteType,                                                
       Bitmap,                                  
       Note,                
       CodeName)                                                
select distinct cn.ClientId,                                       
       cn.ClientNoteId,                                                
    gc.GlobalCodeId,                                 
       cn.NoteType,                                                 
       gc.Bitmap,                                   
       cn.Note,                
       gc.CodeName                                                 
  from  GroupClients gcl                                                  
       join  ClientNotes cn on gcl.clientid=cn.clientid                                              
       left join GlobalCodes gc on gc.GlobalCodeId = cn.NoteType                                                
       --join StaffClients sc on sc.ClientId = cn.ClientId                        
 where  gcl.GroupId = @GroupID and  isnull(gcl.RecordDeleted, ''N'') = ''N''  and isnull(cn.RecordDeleted, ''N'') = ''N'' and cn.Active=''Y''                                         
 and (dateDiff(dd, cn.EndDate, getdate()) <= 0 or cn.EndDate is null)       
 and gc.Category=''ClientNoteType''                         
order by cn.clientid,cn.ClientNoteId desc                
--order by cn.ClientNoteId desc                
                
update n                                                
   set NoteNumber = n.NoteId - fn.FirstNoteId + 1                                                
  from #Notes n                                                
       join (select ClientId,                                                
                    min(NoteId) as FirstNoteId                                                 
               from #Notes                               
   group by ClientId) fn on fn.ClientId = n.ClientId                 
                   
--IF object_id(''tempdb..#TempDiagnosis'') IS NOT NULL                
-- drop table #TempDiagnosis                
--create table #TempDiagnosis (                                                
--DiagnosisId  int identity not null,                     
--ClientId     int          null,                                                
--DSMCode      char(6)      null,                                  
--NoteNumber   int          null                
--)                                    
                
--INSERT INTO #TempDiagnosis                
--(                
-- ClientId,                
-- DSMCode                
--)                
--SELECT  GC.ClientId ,Dig.DSMCode from GroupClients GC                 
-- left outer join Documents D on GC.ClientId = D.ClientId                    
-- left outer join DocumentVersions Dv on D.CurrentDocumentVersionId = Dv.DocumentVersionId                         
-- left outer join DiagnosesIAndII Dig on Dv.DocumentVersionId = Dig.DocumentVersionId                         
-- Where D.DocumentCodeId = 5  AND GC.GroupId = @GroupID                       
-- AND D.Status = 22  AND DSMCode IS NOT NULL                  
-- AND ISNULL(D.RecordDeleted,''N'')=''N''                        
-- AND ISNULL(Dv.RecordDeleted,''N'')=''N''                        
-- AND ISNULL(Dig.RecordDeleted,''N'')=''N''                        
-- order by Dig.DiagnosisId desc                
                 
-- update T                                                
--   set NoteNumber = T.DiagnosisId - fn.FirstNoteId + 1                                                
--  from #TempDiagnosis T                                                
--       join (select ClientId,                                                
--                    min(DiagnosisId) as FirstNoteId                                                 
--               from #TempDiagnosis                                                
--   group by ClientId) fn on fn.ClientId = T.ClientId                    
                   
                                
--select ''Services'' as TableName,                      
--GC.ClientId,                      
---1 as GroupServiceId,                      
--G.ProcedureCodeId,              
--PC.RequiresTimeInTimeOut,              
----GETDATE() as DateofService,                      
--G.Unit,                             
--G.UnitType,                      
--70 as  Status,                      
----G.ClinicianId as ProviderID,                      
--G.ClinicianId ,                   
--@StaffID AS NoteAuthorId ,                    
--G.ProgramId,                      
--G.LocationId,                      
--''Y'' as Billable                              
--,GC.CreatedBy,                      
--GC.CreatedDate,                      
--GC.ModifiedBy,          
--GC.ModifiedDate,                      
--GC.RowIdentifier                       
                      
--,Clients.LastName + '', '' + Clients.FirstName as [ClientName]                                 
--,''N'' AS IsServiceError                           
--,0 AS DocumentId                  
--,n.ClientId as NoteClient                
--      ,n.BitmapNo                
--      ,n.BitmapId1,n.Note1,                                                
--      n.BitmapId2,n.Note2,                                                 
--      n.BitmapId3,n.Note3,                                                  
--      n.BitmapId4,n.Note4,                                                 
--      n.BitmapId5,n.Note5,                
--      DiagnosisCode1,                
--      DiagnosisCode2,                
--      DiagnosisCode3,    
--      --added by shifali in ref to enable/disable service information/note tab based on saved service && doc status    
--     70 as  SavedServiceStatus,    
--     0 as SavedDocumentStatus,
--     PC.MaxUnits,
--     PC.MinUnits                               
----,SC.ScreenId                        
----,SC.ScreenURL                         
----,PC.ProcedureCodeId              
                           
--from GroupClients GC join                              
--Groups G on G.GroupId=GC.Groupid                        
----added by shifali              
--LEFT OUTER JOIN ProcedureCodes PC              
--on G.ProcedureCodeId=PC.ProcedureCodeId              
----modification by shifali ends here              
--LEFT OUTER JOIN Clients on GC.ClientId = Clients.ClientId                                     
----LEFT OUTER JOIN ProcedureCodes PC ON G.ProcedureCodeId =PC.ProcedureCodeId                         
----LEFT OUTER JOIN Screens SC ON PC.AssociatedNoteId = SC.DocumentCodeId                             
-- left join (select ClientId,                
--     max(NoteNumber) as BitmapNo,                                                
--                         max(case NoteNumber when 1 then GlobalCodeId else null end) as BitmapId1,                                                
--                         max(case NoteNumber when 1 then CodeName+'' : ''+Note else null end) as Note1,                                
                                                
                                                
--                         max(case NoteNumber when 2 then GlobalCodeId else null end) as BitmapId2,                                                
--       max(case NoteNumber when 2 then CodeName+'' : ''+Note else null end) as Note2,                                
                                         
--                         max(case NoteNumber when 3 then GlobalCodeId else null end) as BitmapId3,                                                
--       max(case NoteNumber when 3 then CodeName+'' : ''+Note else null end) as Note3,                                
                       
--       max(case NoteNumber when 4 then GlobalCodeId else null end) as BitmapId4,                                                
--       max(case NoteNumber when 4 then CodeName+'' : ''+Note else null end) as Note4,                                
                                         
--                         max(case NoteNumber when 5 then GlobalCodeId else null end) as BitmapId5,                                                
--       max(case NoteNumber when 5 then CodeName+'' : ''+Note else null end) as Note5                                
                                         
--                    from #Notes                                                
--                   where NoteNumber <= 5                                                
--                   group by ClientId) n on n.ClientId = GC.ClientId                 
                                   
--   left join (                
--   select CLientId,                
--   max(NoteNumber) as DiagnosisNo,                
                   
--   max(case NoteNumber when 1 then DSMCode else null end) as DiagnosisCode1,                
                   
--   max(case NoteNumber when 2 then DSMCode else null end) as DiagnosisCode2,                
                   
--   max(case NoteNumber when 3 then DSMCode else null end) as DiagnosisCode3    
                  
--    from #TempDiagnosis                 
--   where NoteNumber <=3 group By ClientId                 
--   ) T on T.ClientId =GC.ClientId                  
                                            
--where G.GroupId=@GroupID AND GC.GroupId = @GroupID                    
--and ISNULL(G.RecordDeleted,''N'')=''N''                               
--and ISNULL(GC.RecordDeleted,''N'')=''N''                        
--AND ISNULL(GC.RecordDeleted,''N'')=''N''                              
--AND ISNULL(Clients.RecordDeleted,''N'')=''N''        











select ''Services'' as TableName,                      
GC.ClientId,                      
-1 as GroupServiceId,                      
G.ProcedureCodeId,              
PC.RequiresTimeInTimeOut,              
--GETDATE() as DateofService,                      
G.Unit,                             
G.UnitType,                      
70 as  Status,                      
--G.ClinicianId as ProviderID,                      
G.ClinicianId ,                   
@StaffID AS NoteAuthorId ,                    
G.ProgramId,                      
G.LocationId,                      
''Y'' as Billable                              
,GC.CreatedBy,                      
GC.CreatedDate,                      
GC.ModifiedBy,          
GC.ModifiedDate,                      
GC.RowIdentifier                       
                      
,Clients.LastName + '', '' + Clients.FirstName as [ClientName]                                 
,''N'' AS IsServiceError                           
,0 AS DocumentId                  
,n.ClientId as NoteClient                
      ,n.BitmapNo                
      ,n.BitmapId1,n.Note1,                                                
      n.BitmapId2,n.Note2,                                                 
      n.BitmapId3,n.Note3,                                                  
      n.BitmapId4,n.Note4,                                                 
      n.BitmapId5,n.Note5,                
      --DiagnosisCode1,                
      --DiagnosisCode2,                
      --DiagnosisCode3,    
      --added by shifali in ref to enable/disable service information/note tab based on saved service && doc status    
     70 as  SavedServiceStatus,    
     0 as SavedDocumentStatus,
     PC.MaxUnits,
     PC.MinUnits                               
--,SC.ScreenId                        
--,SC.ScreenURL                         
--,PC.ProcedureCodeId              
                           
from GroupClients GC join                              
Groups G on G.GroupId=GC.Groupid                        
--added by shifali              
LEFT OUTER JOIN ProcedureCodes PC              
on G.ProcedureCodeId=PC.ProcedureCodeId              
--modification by shifali ends here              
LEFT OUTER JOIN Clients on GC.ClientId = Clients.ClientId                                     
--LEFT OUTER JOIN ProcedureCodes PC ON G.ProcedureCodeId =PC.ProcedureCodeId                         
--LEFT OUTER JOIN Screens SC ON PC.AssociatedNoteId = SC.DocumentCodeId                             
 left join (select ClientId,                
     max(NoteNumber) as BitmapNo,                                                
                         max(case NoteNumber when 1 then GlobalCodeId else null end) as BitmapId1,                                                
                         max(case NoteNumber when 1 then CodeName+'' : ''+Note else null end) as Note1,                                
                                                
                                                
                         max(case NoteNumber when 2 then GlobalCodeId else null end) as BitmapId2,                                                
       max(case NoteNumber when 2 then CodeName+'' : ''+Note else null end) as Note2,                                
                                         
                         max(case NoteNumber when 3 then GlobalCodeId else null end) as BitmapId3,                                                
       max(case NoteNumber when 3 then CodeName+'' : ''+Note else null end) as Note3,                                
                       
       max(case NoteNumber when 4 then GlobalCodeId else null end) as BitmapId4,                                                
       max(case NoteNumber when 4 then CodeName+'' : ''+Note else null end) as Note4,                                
                                         
                         max(case NoteNumber when 5 then GlobalCodeId else null end) as BitmapId5,                                                
       max(case NoteNumber when 5 then CodeName+'' : ''+Note else null end) as Note5                             
                    from #Notes                                                
                   where NoteNumber <= 5                                                
                   group by ClientId) n on n.ClientId = GC.ClientId                 
                                   
   --left join (                
   --select CLientId,                
   --max(NoteNumber) as DiagnosisNo,                
                   
   --max(case NoteNumber when 1 then DSMCode else null end) as DiagnosisCode1,                
                   
   --max(case NoteNumber when 2 then DSMCode else null end) as DiagnosisCode2,                
                   
   --max(case NoteNumber when 3 then DSMCode else null end) as DiagnosisCode3    
                  
   -- from #TempDiagnosis                 
   --where NoteNumber <=3 group By ClientId                 
   --) T on T.ClientId =GC.ClientId                  
                                            
where G.GroupId=@GroupID AND GC.GroupId = @GroupID                    
and ISNULL(G.RecordDeleted,''N'')=''N''                               
and ISNULL(GC.RecordDeleted,''N'')=''N''                        
AND ISNULL(GC.RecordDeleted,''N'')=''N''                              
AND ISNULL(Clients.RecordDeleted,''N'')=''N''    
AND ISNULL(Clients.Active,''N'')=''Y''    










              
 ---GroupServiceStaff---                              
                               
 declare @CodeName varchar(100)                              
 select @CodeName=CodeName   from  Groups G join GlobalCodes GC on G.UnitType=GC.GlobalCodeId where GroupId=@GroupID                              
  and ISNULL(G.RecordDeleted,''N'')=''N''                               
   and ISNULL(GC.RecordDeleted,''N'')=''N''                               
                               
 SELECT ''GroupServiceStaff'' as TableName,                              
      -1 as GroupServiceId                                          
      ,GS.StaffId                                          
      ,G.Unit                    
      ,G.UnitType                                          
      --,GETDATE() as DateOfService                                          
      ,GS.RowIdentifier                                          
      ,GS.CreatedBy                                          
      ,GS.CreatedDate                                          
      ,GS.ModifiedBy                                          
      ,GS.ModifiedDate                                          
      ,GS.RecordDeleted                                          
      ,GS.DeletedDate            
      ,GS.DeletedBy                                   
      ,S.LastName + '', '' + S.FirstName as [StaffName]                                          
      ,@CodeName as CodeName                                
    --,GS.CreatedBy,GS.CreatedDate,GS.ModifiedBy,GS.ModifiedDate,GS.RowIdentifier                               
  FROM GroupStaff GS                               
  join Groups G on GS.GroupId =G.GroupId                               
  join Staff S on GS.StaffId=S.StaffId                               
  where ISNULL(GS.RecordDeleted,''N'')=''N''                              
  and ISNULL(S.RecordDeleted,''N'')=''N''                              
  and ISNULL(S.Active,''N'')=''Y''                              
  and ISNULL(G.RecordDeleted,''N'')=''N''                              
  and G.Groupid=@GroupID                                 
                                      
 --SELECT ''GroupStaff'' as TableName,                              
 -- GS.GroupStaffId,                              
 -- @GroupID as GroupId                                          
 -- ,GS.StaffId                                          
 -- ,GS.CreatedBy,GS.CreatedDate,GS.ModifiedBy,GS.ModifiedDate,GS.RowIdentifier                              
 -- , ''N'' as IsInitialize                                
 -- FROM GroupStaff GS                               
 -- where ISNULL(GS.RecordDeleted,''N'')=''N''                              
 -- and GS.Groupid=@GroupID                               
                                  
                                  
 SELECT ''GroupClients'' as TableName,                              
      GC.GroupClientId                                          
      ,GC.GroupId                                          
      ,GC.ClientId                                          
      ,GC.RowIdentifier                                          
      ,GC.CreatedBy                                          
      ,GC.CreatedDate                                          
      ,GC.ModifiedBy                                          
      ,GC.ModifiedDate                                          
      ,GC.RecordDeleted                                          
      ,GC.DeletedDate                                          
      ,GC.DeletedBy                                          
      ,Clients.LastName + '', '' + Clients.FirstName as [ClientName]                                 
      ,''N'' AS IsServiceError                           
      ,''N'' AS IsInitialize                          
      ,0 AS DocumentId                            
                              
      --,SC.ScreenId                        
      --,SC.ScreenURL                         
      --,PC.ProcedureCodeId                         
      ,-1 AS GroupServiceId                          
       ,G.ProcedureCodeId           
       FROM [GroupClients] GC LEFT OUTER JOIN Clients on GC.ClientId = Clients.ClientId                      
       LEFT OUTER JOIN Groups G ON GC.GroupId =G.GroupId                         
       --LEFT OUTER JOIN ProcedureCodes PC ON G.ProcedureCodeId =PC.ProcedureCodeId                         
       --LEFT OUTER JOIN Screens SC ON PC.AssociatedNoteId = SC.DocumentCodeId                         
       where GC.GroupId =@GroupId                            
       AND ISNULL(GC.RecordDeleted,''N'')=''N''                              
       AND ISNULL(Clients.RecordDeleted,''N'')=''N''     
       AND ISNULL(Clients.Active,''N'')=''Y''   
       
 exec SSP_SCInitializeGroupServicesDSMCodes @GroupID                         
                      
      --DROP TABLE #TempDiagnosis                
      DROP TABLE #Notes                
end try                                                                                    
                                                                                                                             
BEGIN CATCH                              
DECLARE @Error varchar(8000)                                                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                 
+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),                                
''csp_InitGroupServices'')                                                                                                                   
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
