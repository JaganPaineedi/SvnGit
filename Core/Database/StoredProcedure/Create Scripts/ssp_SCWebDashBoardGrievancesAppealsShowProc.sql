/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashBoardGrievancesAppealsShowProc]    Script Date: 11/18/2011 16:26:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebDashBoardGrievancesAppealsShowProc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebDashBoardGrievancesAppealsShowProc]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebDashBoardGrievancesAppealsShowProc]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure [dbo].[ssp_SCWebDashBoardGrievancesAppealsShowProc]    
(          
@SystemDatabaseId int ,     
@StaffId int    
)          
--/*********************************************************************/          
--/* Stored Procedure: dbo.ssp_SCWebDashBoardGrievancesAppealsShowProc                */          
--          
-- Copyright: Streamline Healthcate Solutions          
-- Created Date: 09.16.2010        
-- Created By: Vikas Vyas        
-- Purpose: used by Grievances and Appeals Dashboard Widget          
--          
-- Updates:          
-- Date        Author      Purpose          
--                    
-- 30-Jan-2015  Merged from 3.5x to 4.0
--30-Jan-2015   Task 331 CM to SC Issues, Added Staffid and condition to fix Opened Apeals count Mismatch with ListPage 
--Jun-28-2016   PradeepA	Modified to avoid the Deleted or Inactive Clients Grievances table entry
--*********************************************************************************/          
as          
        
BEGIN                                                                
   BEGIN TRY          
        
create table #GrievancesAppeals (SystemDatabaseId int, Inquiries int, NewGrievances int, AcknowledgedGrievances int, StateFairHearingStatus int, OpennedAppealStatus int, ClosedAppealStatus int, SecondOpinion int,OrganizationName varchar(100))      
      
          
declare @Inquiries int, @NewGrievances int, @AcknowledgedGrievances int,        
@StateFairHearingStatus int,@OpennedAppealStatus int,@ClosedAppealStatus int, @SecondOpinion int,@OrganizationName varchar(100)        
        
set @Inquiries = 0        
set @NewGrievances = 0        
set @AcknowledgedGrievances = 0        
set @StateFairHearingStatus = 0        
set @OpennedAppealStatus= 0        
set @ClosedAppealStatus = 0        
set @SecondOpinion = 0        
        
        
select @Inquiries = isnull(sum(case when Inquiry = ''Y'' then 1 else 0 end),0),         
@NewGrievances = isnull(sum(case when isnull(DateAcknowledgedInWriting,'''')='''' and isnull(DateResolved,'''')='''' and Inquiry=''N'' then 1 else 0 end),0),          
@AcknowledgedGrievances = isnull(sum(Case when DateAcknowledgedInWriting Is Not null and isnull(DateResolved,'''')='''' and Inquiry=''N'' then 1 else 0 end),0)         
from Grievances G
Inner JOin Clients C on C.ClientId = G.ClientId
WHERE isnull(G.RecordDeleted, ''N'') = ''N'' AND isnull(C.RecordDeleted, ''N'') = ''N'' AND ISNULL(C.Active,''Y'') = ''Y''       
        
select @OpennedAppealStatus = isnull(sum(Case when AppealStatus = ''O'' then 1 else 0 end),0),        
@ClosedAppealStatus = isnull(sum(Case when AppealStatus = ''C'' then 1 else 0 end),0),  
@StateFairHearingStatus = isnull(sum(case when StateFairHearingStatus = ''O'' then 1 else 0 end),0)   
from Appeals  
left Join Clients on Appeals.ClientId=Clients.ClientId   
   --Added by Revathi on 06-Jan-2014 for task #77 Engineering Improvement Initiatives- NBL(I)  
    join StaffClients sc on sc.ClientId=clients.ClientId and sc.StaffId=@StaffId   
    Left OUTER JOIN                        
   GlobalCodes GC1 ON  GC1.GlobalCodeId=Appeals.AppealType 
    where isnull(Appeals.RecordDeleted,''N'')=''N'' AND ISNULL(Clients.RecordDeleted,''N'')<>''Y''     
    
select  @SecondOpinion=COUNT(*) from SecondOpinions where ISNULL(RecordDeleted,''N'')<>''Y''      
     
        
SELECT  @OrganizationName=OrganizationName                                  
FROM  SystemDatabases where SystemDatabaseId=@SystemDatabaseId and isnull(RecordDeleted,''N'')=''N''        
        
      
          
insert into #GrievancesAppeals        
(SystemDatabaseId,Inquiries, NewGrievances, AcknowledgedGrievances, StateFairHearingStatus, OpennedAppealStatus, ClosedAppealStatus, SecondOpinion, OrganizationName)           
        
Select @SystemDatabaseId,        
@Inquiries,          
@NewGrievances,          
@AcknowledgedGrievances,          
@StateFairHearingStatus,          
@OpennedAppealStatus,          
@ClosedAppealStatus,        
@SecondOpinion,        
    
         
@OrganizationName          
        
        
select SystemDatabaseId,OrganizationName,Inquiries, NewGrievances, AcknowledgedGrievances, StateFairHearingStatus, OpennedAppealStatus, ClosedAppealStatus, SecondOpinion    
from  #GrievancesAppeals        
        
--return        
          
  END TRY                                            
                                                               
 BEGIN CATCH                                                                
   DECLARE @Error varchar(8000)                                                      
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                  
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCWebDashBoardGrievancesAppealsShowProc'')                                                 
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                                                  
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                                                  
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                                
 END CATCH                                              
End         
--error:          
--        RAISERROR  20002  ''ssp_SCWebDashBoardGrievancesAppealsShowProc : An Error Occured'' ' 
END
GO
