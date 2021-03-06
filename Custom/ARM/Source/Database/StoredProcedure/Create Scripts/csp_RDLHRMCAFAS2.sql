/****** Object:  StoredProcedure [dbo].[csp_RDLHRMCAFAS2]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLHRMCAFAS2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLHRMCAFAS2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLHRMCAFAS2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RDLHRMCAFAS2]                          
@DocumentVersionId  int                   
 AS                         
Begin             
               
/*********************************************************************/                                                                                                                                  
/* Stored Procedure: dbo.[csp_RdlHRMCAFAS]                */                                                                                                                                  
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                  
/* Creation Date:  27 July,2010                                       */                                                                                                                                  
/* Created By: Jitender Kumar Kamboj                                                                  */                                                                                                                                  
/* Purpose:  Get Data for HRM CAFAS document */                                                                                                                                
/*                                                                   */                                                                                                                                
/* Input Parameters:  @DocumentVersionId             */                                                                                                                                
/*                                                                   */                                                                                                                                  
/* Output Parameters:   None                   */                                                                                                                                  
/*                                                                   */                                                                                                                                  
/* Return:  0=success, otherwise an error number                     */                                                                                                                                  
/*                                                                   */                                                                                                                                  
/* Called By:                                                        */                                                                                                                                  
/*                                                                   */                                                                                                                                  
/* Calls:                                                            */                   
/* */                                            
/* Data Modifications:                   */                                                  
/*      */                                                                                 
/* Updates:               */                                                                          
/*   Date     Author            Purpose                             */                                                     
/*      */                                                             
/*                                                                                    
*/                                                                                                       
/*********************************************************************/            

declare @DocumentId int
select @DocumentId = DocumentId from DocumentVersions where DocumentVersionId = @DocumentVersionId

declare @StatusDate varchar(50)
select @StatusDate = CONVERT(varchar(12),d.EffectiveDate,101)
from Documents d 
where d.DocumentId = @DocumentId

Declare @ClientInDDPopulation Char(1), @ClientInMHPopulation Char(1), @ClientInSAPopulation Char(1), @AssessmentType char(1), @AdultOrChild char(10)
        

select 
 @ClientInDDPopulation = ClientInDDPopulation
,@ClientInMHPopulation = ClientInMHPopulation
,@ClientInSAPopulation = ClientInSAPopulation
,@AssessmentType = AssessmentType 
,@AdultOrChild = AdultOrChild
from CustomHRMAssessments                      
where DocumentVersionId = @DocumentVersionId


--start verify changes logic
create table #Verify (
 DocumentId int
,PopulationCategory varchar(10)
,TabName varchar(128)
,TableName varchar(128) 
,ColumnName varchar(128)
,GroupName varchar(128)
,FieldName varchar(128)
,StatusData varchar(128)
)

insert into #Verify 
(DocumentId, PopulationCategory, TabName, TableName, ColumnName, GroupName, FieldName)
 
--Document Initialization Individual Fields
Select Distinct 
 @DocumentId
, c.Diagnosis  as PopulationCategory
, c.TabName
, c.TableName as TableName
, c.ColumnName as ColumnName
, null as GroupName
, isnull(c.FieldName,'''') as FieldName
From Cstm_Conv_Map_DocumentInitializationLog c
--Left Join DocumentValidations d on c.TabName=d.TabName and c.TableName=d.TableName
Where isnull(c.FieldName,'''') <> ''''
and c.TableName = ''CustomCAFAS2''

order by 4, 3, 2, 6, 5

update v
set ColumnName = c.ColumnName
from #Verify v
join Cstm_Conv_Map_DocumentInitializationLog c on c.GroupName=v.GroupName 
Where isnull(c.FieldName,'''')=''''
and v.ColumnName is null
and v.GroupName is not null
and c.TableName = ''CustomCAFAS2''


update v
set StatusData = case di.InitializationStatus 
	when 5871 then ''To Verify'' --To Validate
	when 5872 then ''Reviewed and Verified '' + @StatusDate
	when 5873 then ''Reviewed and Updated '' + @StatusDate
	when 5874 then ''Reviewed and Cleared '' + @StatusDate
	else ''*Error ''  end
from #Verify v
join DocumentInitializationLog di on v.DocumentId = di.DocumentId 
	and di.ColumnName = v.ColumnName
join GlobalCodes gc on gc.GlobalCodeId = di.InitializationStatus
where di.DocumentId=v.DocumentId

                 
---CustomCAFAS2---                                                                                              
SELECT [DocumentVersionId]           
,[CAFASDate]                                                                                              
,s.Lastname + '', '' + s.Firstname as RaterClinician                                                     
,dbo.csf_GetGlobalCodeNameById([CAFASInterval]) as CAFASInterval                                                  
,[SchoolPerformance]                                                                                              
,[SchoolPerformanceComment]                                                                                              
,[HomePerformance]                                                             
,[HomePerfomanceComment]                                                                  
,[CommunityPerformance]                                                                                              
,[CommunityPerformanceComment]                                                                                              
,[BehaviorTowardsOther]                                                                                              
,[BehaviorTowardsOtherComment]                                     
,[MoodsEmotion]                                                                                              
,[MoodsEmotionComment]                                                                                              
,[SelfHarmfulBehavior]                                                                                      
,[SelfHarmfulBehaviorComment]                                                                                              
,[SubstanceUse]                            
,[SubstanceUseComment]                                                              
,[Thinkng]                                                                                           
,[ThinkngComment]            
,[YouthTotalScore]                                                                                              
,[PrimaryFamilyMaterialNeeds]                                                  
,[PrimaryFamilyMaterialNeedsComment]                                                                                              
,[PrimaryFamilySocialSupport]                                                                          
,[PrimaryFamilySocialSupportComment]                                                                                              
,[NonCustodialMaterialNeeds]                                 
,[NonCustodialMaterialNeedsComment]                                                                                              
,[NonCustodialSocialSupport]                                                                                              
,[NonCustodialSocialSupportComment]                                                                                              
,[SurrogateMaterialNeeds]                                                                                              
,[SurrogateMaterialNeedsComment]                                                                                              
,[SurrogateSocialSupport]                                                                                              
,[SurrogateSocialSupportComment]   
--Verification Information
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''BehaviorTowardsOtherComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''BehaviorTowardsOtherComment'' ) + ''): ''   else null end as BehaviorTowardsOtherCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''CommunityPerformanceComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''CommunityPerformanceComment'' ) + ''): ''   else null end as CommunityPerformanceCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''HomePerfomanceComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''HomePerfomanceComment'' ) + ''): ''   else null end as HomePerfomanceCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''MoodsEmotionComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''MoodsEmotionComment'' ) + ''): ''   else null end as MoodsEmotionCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''NonCustodialMaterialNeedsComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''NonCustodialMaterialNeedsComment'' ) + ''): ''   else null end as NonCustodialMaterialNeedsCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''NonCustodialSocialSupportComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''NonCustodialSocialSupportComment'' ) + ''): ''   else null end as NonCustodialSocialSupportCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''PrimaryFamilyMaterialNeedsComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''PrimaryFamilyMaterialNeedsComment'' ) + ''): ''   else null end as PrimaryFamilyMaterialNeedsCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''PrimaryFamilySocialSupportComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''PrimaryFamilySocialSupportComment'' ) + ''): ''   else null end as PrimaryFamilySocialSupportCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''SchoolPerformanceComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''SchoolPerformanceComment'' ) + ''): ''   else null end as SchoolPerformanceCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''SelfHarmfulBehaviorComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''SelfHarmfulBehaviorComment'' ) + ''): ''   else null end as SelfHarmfulBehaviorCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''SubstanceUseComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''SubstanceUseComment'' ) + ''): ''   else null end as SubstanceUseCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''SurrogateMaterialNeedsComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''SurrogateMaterialNeedsComment'' ) + ''): ''   else null end as SurrogateMaterialNeedsCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''SurrogateSocialSupportComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''SurrogateSocialSupportComment'' ) + ''): ''   else null end as SurrogateSocialSupportCommentLabel
,case when @AssessmentType=''A'' and exists ( select * from #Verify v where isnull(v.StatusData,'''')<>'''' and v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''ThinkngComment'' )   then ''Comment (''+ (select distinct v.StatusData from #Verify v where v.TableName = ''CustomCAFAS2'' and v.ColumnName = ''ThinkngComment'' ) + ''): ''   else null end as ThinkngCommentLabel                                                                                           
FROM CustomCAFAS2  c
left join Staff s on s.StaffID    = c.RaterClinician                                                                                         
WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(c.RecordDeleted,''N'')=''N''                                
  
                 
              
    --Checking For Errors                          
  If (@@error!=0)                          
  Begin                          
   RAISERROR  20006   ''csp_RDLHRMCAFAS2 : An Error Occured''                           
   Return                          
   End                          
                   
                        
              
End
' 
END
GO
