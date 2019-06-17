
/****** Object:  StoredProcedure [dbo].[csp_GetTextForAssessmentType]    Script Date: 01/16/2015 17:28:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetTextForAssessmentType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetTextForAssessmentType]
GO


/****** Object:  StoredProcedure [dbo].[csp_GetTextForAssessmentType]    Script Date: 01/16/2015 17:28:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
Create PROCEDURE [dbo].[csp_GetTextForAssessmentType]   
(  
@ClientId int,  
@AssessmentType char(1),  
@DocumentVersionId int  
)  
  
As  
/*********************************************************************/                                                                                                                                                        
/* Stored Procedure: dbo.CSP_UpdateAsseeementType                */                                                                                                                                                        
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                                        
/* Creation Date:  06 August,2010                                       */                                                                                                                                                        
/*                                                                   */                                                                                                                                                        
/* Purpose:  Get Data for Update Assessment Type Pages */                                                                                                                                                      
/*                                                                   */                                                                                                                                                      
/* Input Parameters:  @@ClientId             */                                                                                                                                                      
/*                                                                   */                                                                                                                                                        
/* Output Parameters:   None                   */                                                                                                                                                        
/*                                                                   */                                                                                                                                                        
/* Return:  0=success, otherwise an error number                     */                                                                                                                                                        
/*                                                                   */                               
/* Called By:        */       
/* */                       
/* Calls:         */                                         
/*                         */                                           
/* Data Modifications:                   */                                                                        
/*      */                                                                                                       
/* Updates:               */                                                                                                
/*   Date     Author            Purpose                             */                                                                           
/*     */                                                                                   
/*                                                                                                        
*/                                                                                                                             
/*********************************************************************/                                                                                 
                                                                             
  
BEGIN  
 BEGIN TRY  
  BEGIN  
  
 Declare @AssessmentTypeText varchar(500)  
 Declare @AnnualAssessmentDueDate varchar(50)                     
  
    
 --Find Most Recent Initial or Annual Assessment  
 Set  @AnnualAssessmentDueDate= (select top 1 convert(varchar(20), dateadd(yy, 1, EffectiveDate), 101)                                    
           from Documents d       
           Join CustomHRMAssessments a on a.DocumentVersionId = d.CurrentDocumentVersionId                                                  
           where d.ClientId = @ClientID                                                        
           and d.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                        
           and d.Status = 22                 
           and d.DocumentCodeId in (349, 1469) --HRM Assessment   
           and a.AssessmentType in ('A', 'I')                                                         
           and isNull(a.RecordDeleted,'N')<>'Y'                                                                                           
           order by d.EffectiveDate desc,d.ModifiedDate desc )    
             
             
    --Set pop up text              
 set @AssessmentTypeText= Case When @AssessmentType = 'U' Then 'You have selected ''Update''. An ''Annual'' is due '+ isnull(@AnnualAssessmentDueDate, 'NO PREVIOUS ASSESSMENT') + ' and will still be required even if you complete an ''Update'' '+   
                 'assessment at this time.'--  Click ''OK'' to continue with an ''Update'' Assessment or ''Cancel'' to change to an ''Annual'' Assessment'    
           When @AssessmentType in ('I') then 'You have selected ''Initial''. A blank assessment will be created for this client.'  
           --When @AssessmentType in ('S') then 'You have selected ''Screen''. A blank assessment will be created for this client.'  
           When @AssessmentType in ('A') then 'You have selected ''Annual''. Certain sections will have information carried forward from this client''s last signed assessment.'  
           ENd  
Select  'UpdateAsseeementType' AS TableName,@AssessmentTypeText as 'UpdateAsseeementTypeText'    
END  
 END TRY  
   
 BEGIN CATCH  
 DECLARE @Error varchar(8000)                                                                                                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                          
                  
 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_GetTextForAssessmentType]')                                                                                                                 
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
  
GO


