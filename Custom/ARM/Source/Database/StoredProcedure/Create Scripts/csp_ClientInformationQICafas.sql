/****** Object:  StoredProcedure [dbo].[csp_ClientInformationQICafas]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ClientInformationQICafas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ClientInformationQICafas]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ClientInformationQICafas]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ClientInformationQICafas]                                           
(                                                            
@ClientID as bigint                                                            
)                                            
AS                                                    
                                                         
/*********************************************************************                        
-- Stored Procedure: dbo.ssp_ClientInformationQICafas                                                           
                          
-- Creation Date:    24.07.2009                       
--                         
-- Purpose:  Return Tables for ClientInformations and fill the type Dataset                        
--                        
-- Create:                        
--   Date       Author    Purpose                        
--  24.07.2009  Sahil Bhagat        To fetch the most recent signed Cafas Document for Client                   
--        
*********************************************************************/   

Declare @DocumentVersionRecentCafas int    
                                                        
Begin     
 BEGIN TRY  
                                                           
 select top 1 @DocumentVersionRecentCafas= a.CurrentDocumentVersionId                            
 from Documents a                           
 where a.ClientId = @ClientID                        
 and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                       
 and a.Status = 22                           
 and a.DocumentCodeId in (113)                       
 and isNull(a.RecordDeleted,''N'')<>''Y''                       
 order by a.EffectiveDate desc,ModifiedDate desc        
       
 select top 1 c.[DocumentVersionId]      
      ,c.[CAFASDate]      
      ,c.[RaterClinician]      
      ,c.[CAFASInterval]      
      ,c.[SchoolPerformance]      
      ,c.[HomePerformance]      
      ,c.[CommunityPerformance]      
      ,c.[BehaviourTowardsOther]      
      ,c.[MoodsEmotion]      
      ,c.[SelfHarmfulBehavoiur]      
      ,c.[SubstanceUse]      
      ,c.[Thinkng]      
      ,c.[PrimaryFamilyMaterialNeeds]      
      ,c.[PrimaryFamilySocialSupport]      
      ,c.[NonCustodialMaterialNeeds]      
      ,c.[NonCustodialSocialSupport]      
      ,c.[SurrogateMaterialNeeds]      
      ,c.[SurrogateSocialSupport]      
      ,c.[CreatedDate]      
      ,c.[CreatedBy]      
      ,c.[ModifiedDate]      
      ,c.[ModifiedBy]      
      ,c.[RecordDeleted]      
      ,c.[DeletedDate]      
      ,c.[DeletedBy] from CustomCAFAS c 
    where c.DocumentVersionId=@DocumentVersionRecentCafas                                                     
 END TRY  
     
   BEGIN CATCH  
    DECLARE @Error varchar(8000)                             
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                           
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_ClientInformationQICafas'')                                                           
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                            
   + ''*****'' + Convert(varchar,ERROR_STATE())                                                          
  RAISERROR                                                           
  (                                                          
   @Error, -- Message text.                                                          
   16, -- Severity.                                                          
   1 -- State.                                                          
  )           
   END CATCH                                  
End
' 
END
GO
