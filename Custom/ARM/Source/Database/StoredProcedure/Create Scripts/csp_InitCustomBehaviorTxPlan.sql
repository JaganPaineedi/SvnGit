/****** Object:  StoredProcedure [dbo].[csp_InitCustomBehaviorTxPlan]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomBehaviorTxPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomBehaviorTxPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomBehaviorTxPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--alter PROCEDURE  [dbo].[csp_InitCustomBehaviorTxPlanTest] 
CREATE PROCEDURE  [dbo].[csp_InitCustomBehaviorTxPlan]                               
(                                
@ClientId as int            
)                                
As   

/** Replaced by csp_InitCustomBehaviorTxPlanStandardInitialization **/

Return

/*                             
                
                                        
 Begin                                        
 /*********************************************************************/                                          
 /* Stored Procedure: csp_InitCustomBehaviorTxPlan               */                                 
                                 
 /* Copyright: 2006 Streamline SmartCare*/                                          
                                 
 /* Creation Date:  08/16/2007                                   */                                          
 /*                                                                   */                                          
 /* Purpose: Gets customdata from CustomBehaviorTxPlan, DOB is checked for Null values, as       
there are some records in Clients table that have NULL DOB*/                                         
 /*                                                                   */                                        
 /* Input Parameters: ClientID */                                        
 /*                                                                   */                                           
 /* Output Parameters:                                */                                          
 /*                                                                   */                                          
 /* Return:   */                                          
 /*                                                                   */                                          
 /* Called By:     */                            
 /*    GetCustomData in CustomDocuments class   */                                
                                 
 /*                                                                   */                                          
 /* Calls:                                                            */                                          
 /*                                                                   */                                          
 /* Data Modifications:                                               */                                          
 /*                                                                   */                                          
 /*   Updates:                                                          */                                          
                                 
 /*       Date              Author                  Purpose                                    */                                          
 /*       08/16/2007       Preeti           To Retrieve Data      */    
/*
		01/12/2010			avoss			modified to select valid data. BackgroundInformation,GoalDetail,CurrentLevel and Objective are not initialized

*/                                      
 /*********************************************************************/                                           


declare 
	 @Psychologist varchar(80)
	,@GoalData varchar(max)

select @GoalData = isnull(p.ReasonForAssessment,'''')  	
from documents d
join CustomPsychAssessment p on p.DocumentId = d.DocumentId and isnull(p.recorddeleted,''N'')<>''Y''
where d.Status=22
and d.ClientId = @ClientId
and isnull(d.recorddeleted,''N'')<>''Y''
and not exists ( 
	select * 
	from documents d2
	join CustomPsychAssessment p2 on p2.DocumentId = d2.DocumentId and isnull(p2.recorddeleted,''N'')<>''Y''
	where d2.Status=22
	and d2.ClientId = d.ClientId
	and isnull(d2.recorddeleted,''N'')<>''Y''
	and ( ( d2.EffectiveDate > d.EffectiveDate ) or ( d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId ) )
)

if not exists ( 
	select *
	from documents d
	join CustomBehaviorTxPlan t on t.DocumentId = d.DocumentId and isnull(t.recorddeleted,''N'')<>''Y''
	where d.ClientId = @ClientId
	and d.Status=22
	and isnull(d.recorddeleted,''N'')<>''Y''
)

begin 
	Select 
	ISNULL(Convert(varchar(10),C.DOB,101),Convert(varchar(10),getdate(),101)) as DOB 
	,s.LastName+'', ''+s.FirstName as PrimaryClinician      
	,dbo.GetAge(isnull(c.DOB,getdate()),Getdate()) as Age
	,null as Psychologist
	,'''' as Diagnosis
	,'''' as IdentifyingInformation
	,'''' as MedType1,'''' as MedDosage1,'''' as MedPurpose1,'''' as MedPhysician1
	,'''' as MedType2,'''' as MedDosage2,'''' as MedPurpose2,'''' as MedPhysician2
	,'''' as MedType3,'''' as MedDosage3,'''' as MedPurpose3,'''' as MedPhysician3
	,'''' as MedType4,'''' as MedDosage4,'''' as MedPurpose4,'''' as MedPhysician4
	,'''' as MedType5,'''' as MedDosage5,'''' as MedPurpose5,'''' as MedPhysician5
	,'''' as MedType6,'''' as MedDosage6,'''' as MedPurpose6,'''' as MedPhysician6
	,'''' as MedType7,'''' as MedDosage7,'''' as MedPurpose7,'''' as MedPhysician7
	,'''' as MedType8,'''' as MedDosage8,'''' as MedPurpose8,'''' as MedPhysician8
	,'''' as MedType9,'''' as MedDosage9,'''' as MedPurpose9,'''' as MedPhysician9
	,'''' as BackgroundInformation
	,@GoalData as GoalDetail
	,'''' as CurrentLevel
	,'''' as Objective          
	from Clients C   
	left join Staff s on s.StaffId = c.PrimaryClinicianId  
	where C.ClientId = @ClientId         
end             

--If past plans exist
if exists ( 
	select *
	from documents d
	join CustomBehaviorTxPlan t on t.DocumentId = d.DocumentId and isnull(t.recorddeleted,''N'')<>''Y''
	where d.ClientId = @ClientId
	and d.Status=22
	and isnull(d.recorddeleted,''N'')<>''Y''
)

begin 
	select
	isnull(dbo.RemoveTimestamp(c.DOB),dbo.RemoveTimestamp(getdate())) as DOB 
	,s.LastName+'', ''+s.FirstName as PrimaryClinician      
	,dbo.GetAge(isnull(c.DOB,getdate()),Getdate()) as Age
	,null as Psychologist
	,t.Diagnosis as Diagnosis
	,case when isnull(convert(varchar(max),t.IdentifyingInformation),'''')<>'''' 
		then ''Identifying Information: '' + convert(varchar(max),t.IdentifyingInformation) 
		else '''' end
		+ case when isnull(convert(varchar(max),t.BackgroundInformation),'''') <> '''' 
				then char(13)+char(10)+char(13)+char(10)+ ''Background Information: ''+ convert(varchar(max),t.BackgroundInformation)
				else + '''' end 
		+ case when isnull(@GoalData,'''') <> '''' 
				then char(13)+char(10)+char(13)+char(10)+ ''Goals: ''+ @GoalData 
				else '''' end
		+ case when isnull(convert(varchar(max),t.CurrentLevel),'''') <>'''' 
				then char(13)+char(10)+char(13)+char(10)+ ''Current Level: ''+ convert(varchar(max),t.CurrentLevel)
				else '''' end
		+ case when isnull(convert(varchar(max),t.Objective),'''') <>'''' 
				then char(13)+char(10)+char(13)+char(10)+ ''Objective: ''+ convert(varchar(max),t.Objective)
				else '''' end
	 as IdentifyingInformation
	,t.MedType1 as MedType1 ,t.MedDosage1 as MedDosage1 ,t.MedPurpose1 as MedPurpose1,t.MedPhysician1 as MedPhysician1
	,t.MedType2 as MedType2 ,t.MedDosage2 as MedDosage2 ,t.MedPurpose2 as MedPurpose2 ,t.MedPhysician2 as MedPhysician2
	,t.MedType3 as MedType3 ,t.MedDosage3 as MedDosage3 ,t.MedPurpose3 as MedPurpose3 ,t.MedPhysician3 as MedPhysician3
	,t.MedType4 as MedType4 ,t.MedDosage4 as MedDosage4 ,t.MedPurpose4 as MedPurpose4 ,t.MedPhysician4 as MedPhysician4
	,t.MedType5 as MedType5 ,t.MedDosage5 as MedDosage5 ,t.MedPurpose5 as MedPurpose5 ,t.MedPhysician5 as MedPhysician5
	,t.MedType6 as MedType6 ,t.MedDosage6 as MedDosage6 ,t.MedPurpose6 as MedPurpose6 ,t.MedPhysician6 as MedPhysician6
	,t.MedType7 as MedType7 ,t.MedDosage7 as MedDosage7 ,t.MedPurpose7 as MedPurpose7 ,t.MedPhysician7 as MedPhysician7
	,t.MedType8 as MedType8 ,t.MedDosage8 as MedDosage8 ,t.MedPurpose8 as MedPurpose8 ,t.MedPhysician8 as MedPhysician8
	,t.MedType9 as MedType9 ,t.MedDosage9 as MedDosage9 ,t.MedPurpose9 as MedPurpose9 ,t.MedPhysician9 as MedPhysician9
	,t.BackgroundInformation as BackgroundInformation
	,@GoalData as GoalDetail
	,t.CurrentLevel as CurrentLevel
	,t.Objective as Objective   
	from documents d
	join CustomBehaviorTxPlan t on t.DocumentId = d.DocumentId and isnull(t.recorddeleted,''N'')<>''Y''
	join Clients c on c.ClientId = d.ClientId  
	left join Staff s on s.StaffId = c.PrimaryClinicianId  
	where d.ClientId = @ClientId       
	and d.Status=22
	and isnull(d.recorddeleted,''N'')<>''Y''
	and not exists ( 
		select * 
		from documents d2
		join CustomBehaviorTxPlan t2 on t2.DocumentId = d2.DocumentId and isnull(t2.recorddeleted,''N'')<>''Y''
		where d2.Status=22
		and d2.ClientId = d.ClientId
		and isnull(d2.recorddeleted,''N'')<>''Y''
		and ( ( d2.EffectiveDate > d.EffectiveDate ) or ( d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId ) )
	)


end

 
 END                    
  
 --Checking For Errors                  
  If (@@error!=0)                  
  Begin                  
   RAISERROR  20006   ''csp_InitCustomBehaviorTxPlan : An Error Occured''                   
   Return                  
   End 


*/
' 
END
GO
