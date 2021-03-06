/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHRMTPAssociatedObjectives]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHRMTPAssociatedObjectives]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportHRMTPAssociatedObjectives]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHRMTPAssociatedObjectives]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RDLSubReportHRMTPAssociatedObjectives]    
(                                            
@TPInterventionProcedureId int
)                                            
As                                            
                                                    
Begin                                                    
/*********************************************************************/                                                      
/* Stored Procedure: csp_    */                                             
                                            
/* Copyright: 2006 Streamline SmartCare*/                                                      
                                            
/*********************************************************************/                                             

CREATE Table #ObjectiveList
(TPInterventionProcedureId int , 
 ObjectiveList varchar(300))

--select * from tpinterventionproceduresobjectives
--select * from tpobjectives

-- Get Client Objective List
            Declare @ObjectiveList Varchar(1000)
            Declare @ObjectiveListId   int
            Declare @MaxObjectiveId int
			Declare @StartDate		Datetime
		
            Set @ObjectiveListId = 1

            Create table #Temp
            (ObjectiveListId int identity,
             ObjectiveNumber varchar(20)
            )
 
            Insert into #Temp
            (ObjectiveNumber)
            Select distinct tpo.objectivenumber
			From TPInterventionProcedures  i
			join TPInterventionProcedureObjectives o on i.TPInterventionProcedureId = o.TPInterventionProcedureId
			join TPObjectives tpo on tpo.ObjectiveId = o.ObjectiveId
			Where i.TPInterventionProcedureId = @TPInterventionProcedureId
			and isnull(i.RecordDeleted, ''N'')= ''N''
			and isnull(o.RecordDeleted, ''N'')= ''N''
			and isnull(tpo.RecordDeleted, ''N'')= ''N''
			order by tpo.ObjectiveNumber


            --Find Max Allergy in temp table for while loop
            Set @MaxObjectiveId = (Select Max(ObjectiveListId) From #Temp)

            --Begin Loop to create Allergy List
            While @ObjectiveListId <= @MaxObjectiveId
            Begin
                  Set @ObjectiveList = isnull(@ObjectiveList, '''') + 
                        case when @ObjectiveListId <> 1 then '', '' else '''' end + 
                        (select isnull(ObjectiveNumber, '''')
                        From #Temp t
                        Where t.ObjectiveListId = @ObjectiveListId)
                  Set @ObjectiveListId = @ObjectiveListId + 1
            End 
            --End Loop


Insert Into #ObjectiveList
(TPInterventionProcedureId , 
 ObjectiveList)
values (@TPInterventionProcedureId, @ObjectiveList)

select * from #ObjectiveList
                   
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
