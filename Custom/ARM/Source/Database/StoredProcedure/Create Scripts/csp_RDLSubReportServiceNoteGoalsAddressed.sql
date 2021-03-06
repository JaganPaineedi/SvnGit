/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportServiceNoteGoalsAddressed]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportServiceNoteGoalsAddressed]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportServiceNoteGoalsAddressed]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportServiceNoteGoalsAddressed]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[csp_RDLSubReportServiceNoteGoalsAddressed]    
(                                            
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)                                            
As                                            
                                                    
Begin                                                    
/*********************************************************************/                                                      
/* Stored Procedure: csp_    */                                             
                                            
/* Copyright: 2006 Streamline SmartCare*/                                                      
                                            
/*********************************************************************/                                             


Create Table #Needs
(ServiceId int,
 NeedId int, 
 NeedNumber varchar(20),
 ObjectiveId int,
 ObjectiveNumber varchar(20),
 StageOfTreatment varchar(100),
 ObjectiveList varchar(1000)) 

Insert into #Needs
(ServiceId,
 NeedId,
 NeedNumber, 
 StageOfTreatment)
Select distinct d.ServiceId, n.NeedId, n.NeedNumber, gc.CodeName as StageOfTreatment
--ObjectiveText ,n.goaltext
From Documents d
Join DocumentVersions dv on dv.DocumentId=d.DocumentId and isnull(dv.RecordDeleted,''N'')=''N''
join ServiceGoals sg on sg.ServiceId = d.ServiceId
join TPNeeds n on n.NeedId = sg.NeedId
left join GlobalCodes gc on gc.GlobalCodeId = sg.StageOfTreatment
--where d.DocumentId = @DocumentId
where dv.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010
and isnull(d.RecordDeleted, ''N'')= ''N''
and isnull(sg.RecordDeleted, ''N'')= ''N''
and isnull(n.RecordDeleted, ''N'')= ''N''
order by n.needid


Declare @ObjectiveList varchar(300)
Declare @NeedId int
Declare @NeedNumber varchar(20)
Declare @ObjectiveId int
Declare @ObjectiveNumber varchar(20)

Declare GoalsList Cursor for Select NeedId, NeedNumber from #Needs             
                   
 Open GoalsList             
              
 Fetch Next from GoalsList into @NeedID, @NeedNumber            
              
 While (@@Fetch_Status = 0)               
 Begin              

--
	Declare ObjectivesList Cursor for Select o.ObjectiveId from #Needs n 
														join TPObjectives o  on o.NeedId = n.NeedId and isnull(o.RecordDeleted, ''N'') = ''N''
														join ServiceObjectives so on so.ServiceId = n.ServiceId and o.ObjectiveId = so.objectiveid and isnull(so.RecordDeleted, ''N'') = ''N''
														where n.NeedId =@NeedId  
														order by o.ObjectiveNumber          
                   
	 Open ObjectivesList             
	              
	 Fetch Next from ObjectivesList into @ObjectiveId    


			 While (@@Fetch_Status = 0)               
			 Begin              
			  if not @ObjectiveId is NULL               
			begin              
			 Select @ObjectiveNumber = ObjectiveNumber  from TpObjectives where  ObjectiveId = @ObjectiveId  and isnull(RecordDeleted, ''N'')= ''N''         
			end               
			else              
			begin              
			set @ObjectiveNumber=null              
			end     


  Update  n
	Set ObjectiveList =case when @ObjectiveNumber  is null then ObjectiveList             
			else   case when ObjectiveList is null then @ObjectiveNumber else isnull(ObjectiveList,'''') + '', '' + @ObjectiveNumber end 
	end
	From #Needs n	
	where n.NeedId = @NeedID


Set @ObjectiveList = NULL
Set @ObjectiveId = NULL

  Fetch Next from ObjectivesList  into @ObjectiveId              
 End               
 Close ObjectivesList            
 Deallocate ObjectivesList              
               
              
Fetch Next from GoalsList  into @NeedId, @NeedNumber             
 End -- End  of Main...              
 Close GoalsList             
 Deallocate GoalsList   


select * from #Needs
                   
  --Checking For Errors                              
  If (@@error!=0)                                            
  Begin                                            
   RAISERROR  20006   ''csp_RDLSubReport : An Error Occured''                                             
   Return                                            
   End                                                     
                       
End
' 
END
GO
