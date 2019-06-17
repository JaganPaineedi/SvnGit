/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentLOCUSs]    Script Date: 11/21/2013******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentLOCUSs]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentLOCUSs]
GO

/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentLOCUSs]     Script Date: 11/21/2013******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentLOCUSs]            
          
--@CurrentUserId Int,                
--@ScreenKeyId Int             
  @DocumentVersionId Int            
as            
/**********************************************************************/                                                                                            
 /* Stored Procedure: csp_ValidateCustomDocumentLOCUSs      */                                                                                   
 /* Creation Date:  02/May/2014                                       */                                                                                            
 /* Purpose: To validate the required field on the Locus Asessment page     
                      */                                                                                           
 /* Input Parameters:   @CurrentUserId, @ScreenKeyId      */                                                                                          
 /* Output Parameters:                 */                                                                                            
 /* Return:                 */                                                                                            
 /* Called By:     */                                                                                  
 /* Calls:                                                            */                                                                                            
 /*                                                                   */                                                                                            
 /* Data Modifications:                                               */                                                                                            
 /* Updates:                                                          */                                                                                            
 /* Date          Author           Purpose           */        
 /* 10-03-2016    Pavani          Commented validation asPer the task Engineering improvement Initiatives-NBL(I) #322.4*/
 /*********************************************************************/                                                           
            
Begin                                                          
                
 Begin try             
--*TABLE CREATE*--      
declare @CurrentDocumentVersionId  int    
SET @CurrentDocumentVersionId = @DocumentVersionId       
declare @EffectiveDate datetime    
DECLARE @TotalScoreCount INT;    

    
DECLARE @CustomDocumentLOCUSsDFA TABLE   (          
     DocumentVersionId   INT    
       ,SectionIScore    INT    
       ,SectionIIScore  INT    
       ,SectionIIIScore  INT    
       ,SectionIVaScore  INT    
       ,SectionIVbScore  INT    
       ,SectionVScore  INT    
       ,SectionVIScore  INT    
       ,CompositeScore INT    
       ,LOCUSRecommendedLevelOfCare INT    
       ,AssessorRecommendedLevelOfCare INT    
       ,ReasonForDeviation VARCHAR(MAX) 
       ,Comments  VARCHAR(250)
    ,TotalScoreCount INT    
)            
      
--*INSERT LIST*--              
INSERT INTO @CustomDocumentLOCUSsDFA(            
    DocumentVersionId      
       ,SectionIScore       
       ,SectionIIScore      
       ,SectionIIIScore     
       ,SectionIVaScore     
       ,SectionIVbScore     
       ,SectionVScore      
       ,SectionVIScore     
       ,CompositeScore     
       ,LOCUSRecommendedLevelOfCare     
       ,AssessorRecommendedLevelOfCare     
       ,ReasonForDeviation 
       ,Comments   
       ,TotalScoreCount    
)            
--*Select LIST*--                
select             
    a.DocumentVersionId      
       ,a.SectionIScore       
       ,a.SectionIIScore      
       ,a.SectionIIIScore     
       ,a.SectionIVaScore     
       ,a.SectionIVbScore     
       ,a.SectionVScore      
       ,a.SectionVIScore     
       ,a.CompositeScore     
       ,a.LOCUSRecommendedLevelOfCare     
       ,a.AssessorRecommendedLevelOfCare        
       ,a.ReasonForDeviation  
       ,a.Comments  
       ,SUM(a.SectionIScore+a.SectionIIScore+a.SectionIIIScore+a.SectionIVaScore+a.SectionIVbScore+a.SectionVScore    
  +a.SectionVIScore) AS 'TotalScoreCount'    
from CustomDocumentLOCUSs a             
where a.DocumentVersionId = @CurrentDocumentVersionId and isnull(RecordDeleted,'N')<>'Y'      
Group by  a.DocumentVersionId,a.SectionIScore,a.SectionIIScore,a.SectionIIIScore ,a.SectionIVaScore     
       ,a.SectionIVbScore,a.SectionVScore,a.SectionVIScore,a.CompositeScore,a.LOCUSRecommendedLevelOfCare     
       ,a.AssessorRecommendedLevelOfCare,a.ReasonForDeviation,a.Comments             
 /*       
 DECLARE @validationReturnTable TABLE          
(            
 TableName varchar(200),                
 ColumnName varchar(200),                
 ErrorMessage varchar(1000)            
)   */      
SELECT  @EffectiveDate=EffectiveDate FROM DocumentS WHERE DocumentId in(SELECT documentId from  DocumentVersions  where documentversionId=@CurrentDocumentVersionId)     
      
Insert into #validationReturnTable            
(TableName,            
ColumnName,            
ErrorMessage,
PageIndex            
)            
--This validation returns three fields            
--Field1 = TableName            
--Field2 = ColumnName            
--Field3 = ErrorMessage            
           
Select 'CustomDocumentLOCUSs', 'SectionIScore', 'Section I score must be specified',''         
FROM @CustomDocumentLOCUSsDFA WHERE isnull(SectionIScore,'')=''          
    
Union            
Select 'CustomDocumentLOCUSs', 'SectionIIScore', 'Section II score must be specified' ,''           
FROM @CustomDocumentLOCUSsDFA WHERE isnull(SectionIIScore,'')=''          
            
Union            
Select 'CustomDocumentLOCUSs', 'SectionIIIScore', 'Section III score must be specified' ,''           
FROM @CustomDocumentLOCUSsDFA WHERE isnull(SectionIIIScore,'')=''    
    
Union            
Select 'CustomDocumentLOCUSs', 'SectionIVaScore', 'Section IV a Score must be specified' ,''           
FROM @CustomDocumentLOCUSsDFA WHERE isnull(SectionIVaScore,'')=''            
    
Union            
Select 'CustomDocumentLOCUSs', 'SectionIVbScore', 'Section IV b score must be specified' ,''           
FROM @CustomDocumentLOCUSsDFA WHERE isnull(SectionIVbScore,'')=''            
    
Union            
Select 'CustomDocumentLOCUSs', 'SectionVScore', 'Section V Score must be specified' ,''           
FROM @CustomDocumentLOCUSsDFA WHERE isnull(SectionVScore,'')=''    
    
Union            
Select 'CustomDocumentLOCUSs', 'SectionVIScore', 'Section VI Score must be specified' ,''           
FROM @CustomDocumentLOCUSsDFA WHERE isnull(SectionVIScore,'')=''      
    
Union            
Select 'CustomDocumentLOCUSs', 'CompositeScore', 'Composite Score must be specified',''            
FROM @CustomDocumentLOCUSsDFA WHERE isnull(CompositeScore,'')=''     
    
Union            
Select 'CustomDocumentLOCUSs', 'LOCUSRecommendedLevelOfCare', 'LOCUS recommended Level of Care must be specified',''            
FROM @CustomDocumentLOCUSsDFA WHERE isnull(LOCUSRecommendedLevelOfCare,'')=''      
    
Union            
Select 'CustomDocumentLOCUSs', 'AssessorRecommendedLevelOfCare', 'Assessor recommended level of care must be specified' ,''           
FROM @CustomDocumentLOCUSsDFA WHERE isnull(AssessorRecommendedLevelOfCare,'')=''     
    
--Union    
--Select 'CustomDocumentLOCUSs', 'ReasonForDeviation', 'Reason for deviation must be specified'    
--FROM @CustomDocumentLOCUSsDFA WHERE LOCUSRecommendedLevelOfCare <> AssessorRecommendedLevelOfCare AND     
--                                    ISNULL(ReasonForDeviation,'') = ''    
Union    
Select 'CustomDocumentLOCUSs', 'Comments', 'Comments must be specified',''
FROM @CustomDocumentLOCUSsDFA WHERE LOCUSRecommendedLevelOfCare <> AssessorRecommendedLevelOfCare AND ISNULL(Comments,'') = ''
 
Union    
Select 'CustomDocumentLOCUSs', 'CompositeScore', 'Composite score must be witin 7 - 35 range',''    
FROM @CustomDocumentLOCUSsDFA WHERE CompositeScore not between 7 and 35    
    
--Pavani  10-03-2016 
    
--UNION    
--SELECT 'CustomDocumentLOCUSs', 'TotalScoreCount', 'Total Score does not match Entered Number in Composite Score' ,''   
--FROM @CustomDocumentLOCUSsDFA WHERE CompositeScore<>TotalScoreCount    

--End     
    
/* Below condition added by Rakesh-II  i.e condition added for Effective Date cannot  be in future */    
if (@EffectiveDate> getdate())    
begin    
    Insert into #validationReturnTable(TableName, ColumnName,ErrorMessage,PageIndex )    
    Select 'Documents', 'DocumentDate', 'Effective date can not be in future',''  FROM @CustomDocumentLOCUSsDFA      
end    
    
/*    
Select TableName, ColumnName, ErrorMessage             
from @validationReturnTable          
          
IF Exists (Select TableName From @validationReturnTable)          
 Begin           
  select 1  as ValidationStatus          
 End          
Else          
 Begin          
  Select 0 as ValidationStatus          
 End     
*/              
end try                                                          
                                                                                        
BEGIN CATCH              
            
DECLARE @Error varchar(8000)                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_ValidateCustomDocumentLOCUSs')                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                       
 RAISERROR                                                                                         
 (                                                           
  @Error, -- Message text.                                                                                        
  16, -- Severity.                                                                                        
  1 -- State.                                                                                        
 );                                                                                     
END CATCH                                    
END               
            
            