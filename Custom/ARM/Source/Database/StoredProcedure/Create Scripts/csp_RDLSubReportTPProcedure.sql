/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportTPProcedure]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportTPProcedure]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportTPProcedure]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportTPProcedure]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLSubReportTPProcedure]    
(                                    
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010                                    
)                                    
As                                    
                                            
Begin                                         
/*********************************************************************/                                              
/* Stored Procedure: csp_RDLSubReportTPProcedure    */                                     
                                    
/* Copyright: 2006 Streamline SmartCare*/                                              
                                    
/* Creation Date:  Dec 4 ,2007                                  */                                              
/*                                                                   */                                              
/* Purpose: Gets Data for csp_RDLSubReportTPProcedure  */                                             
/*                                                                   */                                            
/* Input Parameters: DocumentID,Version */                                            
/*                                                                   */                                               
/* Output Parameters:                                */                                              
/*                                                                   */                                              
/*    */                                              
/*                                                                   */                                              
/* Purpose Use For Rdl Report  */                                    
/*      */                                    
                                    
/*                                                                   */                                              
/* Calls:                                                            */                                              
/*                                                                   */                                              
/* Author Rishu Chopra                                            */                                              
/*                                                                   */                                              
/*                                                             */                                              
                                    
/*                                        */                                              
/*	sp_help tpprocedures  sp_help tpprocedureAssociations		*/
/*********************************************************************/                                     
/*
select top 100 * from documents d
join tpprocedures as tp on tp.DocumentId = d.documentid
join TPProcedureAssociations as tpa on tp.tpprocedureId = tpa.tpprocedureId
where d.documentCodeId = 2 and d.createddate > ''1/1/2007'' and d.currentversion > 2 
and d.Status = 22 and tpa.ObjectiveId is not null
*/
                                         
begin           
/*
declare @DocumentId int, @Version int
select @DocumentId = 282767, @Version = 2 
*/
             
create Table #TPProcedureSummary (              
 TPProcedureId int NOT NULL ,              
 ProcedureName Varchar(100) NULL ,              
 ProviderName Varchar(100) NULL ,              
 Units decimal(18, 0) NULL ,              
 FrequencyName Varchar(100) NULL ,              
 StartDate datetime NULL ,              
 EndDate datetime NULL ,              
 TotalUnits decimal(18, 2) NULL ,              
 ObjectiveName Varchar(100) NULL ,              
 InterventionName Varchar(100) NULL ,                             
)               
              
insert into #TPProcedureSummary              
select	
	TP.TPProcedureId,
	A.AuthorizationCodeName as ProcedureName,
	case isnull(P.ProviderName ,''N'') when ''N'' then '''' else P.ProviderName end                      
	 + case isnull(tp.ProviderId,''0'') when ''0'' then Ag.AgencyName else '''' end   
	as ProviderName,
	tp.units,
	GCS.CodeName as FrequencyName,
	tp.startdate,
	tp.enddate,
	tp.totalunits,
	null as ObjectiveName,
	null as InterventionName                 
from  Agency AS Ag , TpProcedures as TP                  
left join Providers P on P.ProviderID = TP.ProviderID 
	and ( P.RecordDeleted=''N'' or  P.RecordDeleted is null)  
	and ( TP.RecordDeleted=''N'' or  TP.RecordDeleted is null)                  
left join AuthorizationCodes A on TP.AuthorizationCodeID = A.AuthorizationCodeID 
	and ( A.RecordDeleted=''N'' or  A.RecordDeleted is null)                   
left join GlobalCodes  GCS  on GCS.GlobalCodeId = TP.FrequencyType 
	and (GCS.RecordDeleted=''N'' or GCS.RecordDeleted is null)                
--where Tp.DocumentID =@Documentid  
--and TP.Version =@Version  
where Tp.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010
And  IsNull(tp.RecordDeleted,''N'')=''N''                
              
Declare @TPProcedureId int              
              
Declare  @ObjectiveId   int              
Declare @InterventionId int              
Declare @ObjectiveNumber Varchar(100)              
Declare @InterventionNumber Varchar(100)              
              
Declare CTPProcedures Cursor for Select TPProcedureId from #TPProcedureSummary              
                   
 Open CTPProcedures              
              
 Fetch Next from CTPProcedures into @TPProcedureId              
              
 While (@@Fetch_Status = 0)               
 Begin              
          
----Main Cursor Body              
              
 Declare PRProcedureAssociation Cursor for Select ObjectiveId,InterventionId from TPProcedureAssociations Where TPProcedureId = @TPProcedureId and isnull(RecordDeleted, ''N'')= ''N''          
                              
 Open PRProcedureAssociation              
              
 Fetch Next from PRProcedureAssociation into @ObjectiveId,@InterventionId              
              
 While (@@Fetch_Status = 0)               
 Begin              
  if not @ObjectiveId is NULL               
begin              
 Select @ObjectiveNumber = ObjectiveNumber  from TpObjectives where  ObjectiveId = @ObjectiveId              
end               
else              
begin              
set @ObjectiveNumber=null              
end              
              
              
              
  if not @InterventionId is NULL               
begin              
 Select @InterventionNumber = InterventionNumber  from TpInterventions where InterventionId = @InterventionId              
end               
else              
begin              
set @InterventionNumber=null              
end              
                
              
              
  Update  #TPProcedureSummary Set ObjectiveName =case when @ObjectiveNumber  is null then ObjectiveName              
  else   case when ObjectiveName is null then @ObjectiveNumber else isnull(ObjectiveName,'''') + '', '' + @ObjectiveNumber end              
end              
               
              
 , InterventionName =case when @InterventionNumber is null then InterventionName              
else case when InterventionName is null then @InterventionNumber else isnull(InterventionName,'''') + '', '' + @InterventionNumber end              
end              
              
 Where TPProcedureId  = @TPProcedureId              
              
  Fetch Next from PRProcedureAssociation into @ObjectiveId,@InterventionId              
 End               
 Close PRProcedureAssociation              
 Deallocate PRProcedureAssociation              
               
              
Fetch Next from CTPProcedures into @TPProcedureId              
 End -- End  of Main...              
 Close CTPProcedures              
 Deallocate CTPProcedures                        
 
 Select
 TPProcedureId,              
 ProcedureName,              
 ProviderName,              
 Units,              
 FrequencyName,              
 StartDate,              
 EndDate,              
 TotalUnits,              
 ObjectiveName,              
 InterventionName
 From #TPProcedureSummary       

--drop table #TPProcedureSummary 

     
end   














































  --Checking For Errors                                    
  If (@@error!=0)                                    
  Begin                                    
   RAISERROR  20006   ''csp_RDLSubReportTPProcedure : An Error Occured''                                     
   Return                                    
   End                                             
               
End 

--select * from TPProcedureAssociations
' 
END
GO
