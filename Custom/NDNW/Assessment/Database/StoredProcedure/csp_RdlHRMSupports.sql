

/****** Object:  StoredProcedure [dbo].[csp_RdlHRMSupports]    Script Date: 01/29/2015 19:20:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlHRMSupports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlHRMSupports]
GO



/****** Object:  StoredProcedure [dbo].[csp_RdlHRMSupports]    Script Date: 01/29/2015 19:20:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[csp_RdlHRMSupports]    --827658                    
@DocumentVersionId  int                 
 AS                       
Begin           
             
/*********************************************************************/                                                                                                                                
/* Stored Procedure: dbo.[csp_RdlHRMSupports]                */                                                                                                                                
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                
/* Creation Date:  20 July,2010                                       */                                                                                                                                
/*                                                                   */                                                                                                                                
/* Purpose:  Get Data for CustomHRMAssessments Pages */                                                                                                                              
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
/*   Jitender Kumar Kamboj  */                                                           
/*                                                        
avoss modified for verification logic  
                            
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
(DocumentId, PopulationCategory, TabName, TableName, ColumnName, GroupName, FieldName,StatusData)  
   
--Document Initialization Individual Fields  
Select Distinct   
@DocumentId  
, null  as PopulationCategory  
, 'Substnace Use History' as TabName  
, 'CustomSubstanceUseHistory2' as TableName  
, di.ColumnName as ColumnName  
, null as GroupName  
, di.ChildRecordId  as FieldName  
, case di.InitializationStatus   
 when 5871 then ' (To Verify)' --To Validate  
 when 5872 then ' (Reviewed and Verified ' + @StatusDate + ')'  
 when 5873 then ' (Reviewed and Updated ' + @StatusDate + ')'  
 when 5874 then ' (Reviewed and Cleared ' + @StatusDate + ')'  
 else '*Error '  end  
From DocumentInitializationLog di with (nolock)   
join CustomHRMAssessmentSupports2 c with (nolock) on c.HRMAssessmentSupportId = di.ChildRecordId and ISNULL(c.RecordDeleted,'N')<>'Y'  
join GlobalCodes gc with (nolock) on gc.GlobalCodeId = di.InitializationStatus   
Where di.TableName = 'CustomHRMAssessmentSupports2'  
and di.DocumentId = @DocumentId  
and ISNULL(Di.RecordDeleted,'N')<>'Y'  
  
order by 4, 3, 2, 6, 5, 7  
  
 ---CustomHRMAssessmentSupports2---                                                                    
SELECT   
  c.[HRMAssessmentSupportId]                                                                       
 ,c.[DocumentVersionId]                                                                              
 ,c.[SupportDescription]                                                                              
 ,c.[Current]                                                                              
 ,c.[PaidSupport]                                                                              
 ,c.[UnpaidSupport]                                                                              
 ,c.[ClinicallyRecommended]                                     
 ,c.[CustomerDesired]          
 ,row_number() over ( partition by c.DocumentVersionId  order by c.HRMAssessmentSupportId ) as RowNum  
 ,v.StatusData as StatusData                                                                               
FROM CustomHRMAssessmentSupports2 c with (nolock)   
left join #Verify v on ltrim(rtrim(v.FieldName)) = c.[HRMAssessmentSupportId]  
WHERE c.DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'         
order by c.HRMAssessmentSupportId                
               
            
    --Checking For Errors                        
  If (@@error!=0)                        
  Begin                        
   RAISERROR  20006   'csp_RdlHRMSupports : An Error Occured'                         
   Return                        
   End                        
                 
                      
            
End  
GO


