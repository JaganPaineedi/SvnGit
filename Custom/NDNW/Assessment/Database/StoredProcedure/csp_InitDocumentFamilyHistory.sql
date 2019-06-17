 /****** Object:  StoredProcedure [dbo].[csp_InitDocumentFamilyHistory]    Script Date: 11/13/2013 16:25:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitDocumentFamilyHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitDocumentFamilyHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
CREATE PROCEDURE  [dbo].[csp_InitDocumentFamilyHistory]                
(                                        
	  @ClientID int ,
      @StaffID int ,
      @CustomParameters xml              
)                                         
As                                                                                                                                                        
/*************************************************************/                                                                
/* Stored Procedure: csp_InitDocumentFamilyHistory	     */                                                                                                                     
/* Creation Date:	 14 Nov 2013						     */                                                                                                                                                                                       
/* Input Parameters: @ClientID,@StaffID,@CustomParameters    */                                                              
/* Author:			Malathi Shiva */
/*************************************************************/                                                                                                                                            
BEGIN TRY                                       
BEGIN       
--------------------FamilyHistory  ---------------- 


Declare @LatestDocumentVersionID int              
set @LatestDocumentVersionID =(select top 1 CurrentDocumentVersionId                                    
from Documents a  
Inner Join DocumentCodes Dc on Dc.DocumentCodeid=a.DocumentCodeid
Inner Join DocumentVersions DV on a.CurrentDocumentVersionId=dv.DocumentVersionId
join DocumentFamilyHistory df on dv.DocumentVersionId=df.DocumentVersionId                                                       
where a.ClientId = @ClientID                                                        
and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                        
and a.Status = 22                
--and a.DocumentCodeId=10018                                                         
and isNull(a.RecordDeleted,'N')<>'Y' and isNull(Dc.RecordDeleted,'N')<>'Y'                                                                                          
order by a.EffectiveDate desc,a.ModifiedDate desc ) 

select  'DocumentFamilyHistory' as TableName,   DocumentFamilyHistoryId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,DocumentVersionId
,FamilyMemberType
,IsLiving
,CurrentAge
,CauseOfDeath
,Hypertension
,Hyperlipidemia
,Diabetes
,DiabetesType1
,DiabetesType2
,Alcoholism
,COPD
,Depression
,ThyroidDisease
,CoronaryArteryDisease
,Cancer
,Other
,CancerType
--,STUFF((case when isnull(Hypertension,'N')='Y' then ',Hypertension' else '' end) 
--+(case when isnull(Hyperlipidemia,'N')='Y' then ',Hyperlipidemia' else '' end)
--+(case when isnull(Diabetes,'N')='Y' then ',Diabetes ' else '' end) 
--+ (case when isnull(DiabetesType1,'N')='Y' then case when isnull(DiabetesType2,'N')='Y'then  '(Type1,Type2)' else '(Type1)' end  else  Case when isnull(DiabetesType2,'N')='Y' then  '(Type2)' else '' end  end)
--+(case when isnull(Alcoholism,'N')='Y' then ',Alcoholism'  else '' end)
--+(case when isnull(COPD,'N')='Y' then ',COPD'  else '' end)
--+(case when isnull(Depression,'N')='Y' then ',Depression'  else '' end)
--+(case when isnull(ThyroidDisease,'N')='Y' then ',ThyroidDisease'  else '' end)
--+(case when isnull(CoronaryArteryDisease,'N')='Y' then ',CoronaryArteryDisease'  else '' end)
--+(case when ISNULL(Cancer,'N')='y' then ',Cancer ('+(select CodeName from  GlobalCodes where Category = 'FamilyHistoryCancer' 
--and GlobalCodeId = CancerType )+')'  else '' end)
--+(case when isnull(Other,'N')='Y' then',Other'+'('+convert(varchar(max),OtherComment)+')'  else '' end),1,1,'') as DiseaseCondition
,DiseaseConditionDXCodeDescription 
,dbo.csf_GetGlobalCodeNameById(FamilyMemberType) AS 'FamilyMemberTypeText'
,IsLivingValue = CASE IsLiving WHEN  'Y' Then 'Yes' WHEN 'N' Then 'No' When 'U'  Then 'Unknown'END 
,OtherComment from DocumentFamilyHistory 
where DocumentVersionId=@LatestDocumentVersionID
and ISNULL(DocumentFamilyHistory.RecordDeleted,'N')='N'

END                                                                                          
 END TRY                                                                                                   
 BEGIN CATCH                                                     
   DECLARE @Error varchar(8000)                                                                                                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_InitDocumentFamilyHistory')                       
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                        
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                                                                                                                                     
 END CATCH  
Go    