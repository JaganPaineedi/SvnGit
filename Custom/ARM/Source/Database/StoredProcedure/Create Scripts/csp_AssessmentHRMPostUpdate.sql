/****** Object:  StoredProcedure [dbo].[csp_AssessmentHRMPostUpdate]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AssessmentHRMPostUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AssessmentHRMPostUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AssessmentHRMPostUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
           
create  procedure  [dbo].[csp_AssessmentHRMPostUpdate]          
@DocumentVersionId int,                  
@UserCode varchar(50)                
/********************************************************************************                                  
-- Stored Procedure: dbo.csp_AssessmentPostUpdate                                    
--                                  
-- Copyright: 2009 Streamline Healthcate Solutions                                  
--                                  
-- Purpose:                                  
--                                  
-- Updates:                                                                                         
-- Date        Author      Purpose                                  
-- 07.21.2010  Anuj Tomar  Created.                                        
-- 01.23.2011  SFarber     Added code to calculate LOCId                                  
*********************************************************************************/                       
as     
BEGIN                 
    
BEGIN TRY    
                   
declare @Score int                  
declare @LOCId int    
declare @LOCCategoryId int    
    
declare @AdultOrChild char      
declare @ClientInDDPopulation char       
declare @ClientInSAPopulation char      
declare @ClientInMHPopulation char      
      
select @AdultOrChild = AdultOrChild,    
       @ClientInDDPopulation = isnull(ClientInDDPopulation, ''N''),      
       @ClientInSAPopulation = isnull(ClientInSAPopulation, ''N''),    
       @ClientInMHPopulation = isnull(ClientInMHPopulation, ''N'')       
  from CustomHRMAssessments                 
 where DocumentVersionId = @DocumentVersionId                                     
       
if @ClientInDDPopulation = ''N'' and @AdultOrChild = ''A'' and (@ClientInSAPopulation = ''Y'' or @ClientInMHPopulation = ''Y'')      
begin      
  exec scsp_HRMCalculateGAFScoreFromDLA @DocumentVersionId = @DocumentVersionId, @GAFScore = @Score output                       
     
  update DiagnosesV                  
      set AxisV = @Score                  
    where DocumentVersionId = @DocumentVersionId                  
    
  set @LOCCategoryId = 1      
end      
                   
exec ssp_SCCalculateLevelOfIntensityForAssessmentHRM    @DocumentVersionId , @UserCode             
    
  print @LOCCategoryId  
  PRINT @Score  
update a    
   set LOCId = dbo.GetLOCId(@LOCCategoryId, @Score)    
  from CustomHRMAssessments a    
 where a.DocumentVersionId = @DocumentVersionId           
       
                 
END TRY                  
BEGIN CATCH                                                                                                                                                                
  DECLARE @Error varchar(8000)                                                                                                           
  SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
                     
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_AssessmentHRMPostUpdate'')                                                                                                        
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                                      
  
    
      
        
          
                                
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                                                      
  RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                                                                        
END CATCH               
END ' 
END
GO
