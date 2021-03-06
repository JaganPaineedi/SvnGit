/****** Object:  StoredProcedure [dbo].[csp_ClientInformationQIDDReporting]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ClientInformationQIDDReporting]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ClientInformationQIDDReporting]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ClientInformationQIDDReporting]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ClientInformationQIDDReporting]                                         
(                                                          
	@ClientID as bigint                                                          
)                                          
AS        
Declare @DocumentDDAssessment int,@VersionDDAssessment int    
                                                     
                                                        
/*********************************************************************                      
-- Stored Procedure: dbo.[csp_ClientInformationQIDDReporting]                                                         
                        
-- Creation Date:    24.07.2009                     
--                       
-- Purpose:  Return Tables for ClientInformations and fill the type Dataset                      
--                      
-- Create:                      
--   Date       Author    Purpose                      
--  24.07.2009  Sahil Bhagat        To fetch the most recent signed DDReporting Document for Client                 
--      
*********************************************************************/                                                         
 Begin  
 BEGIN TRY                                                         
 select top 1 @DocumentDDAssessment= a.DocumentId,@VersionDDAssessment=a.CurrentDocumentVersionId                         
 from Documents a                         
 where a.ClientId = @ClientID                      
 and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                     
 and a.Status = 22                         
 and a.DocumentCodeId in (110)                     
 and isNull(a.RecordDeleted,''N'')<>''Y''                     
 order by a.EffectiveDate desc,ModifiedDate desc      
     
 select top 1 c.[DocumentVersionId]    
       
      ,c.[CommunicationStyle]    
      ,c.[SupportNature]    
      ,c.[SupportStatus]    
      ,c.[LevelVision]    
      ,c.[LevelHearing]    
      ,c.[LevelOther]    
      ,c.[LevelBehavior]    
      ,c.[AssistanceMobility]    
      ,c.[AssistanceMedication]    
      ,c.[AssistancePersonal]    
      ,c.[AssistanceHousehold]    
      ,c.[AssistanceCommunity]    
      ,c.[HealthHistory]    
      ,c.[CreatedBy]    
      ,c.[CreatedDate]    
      ,c.[ModifiedBy]    
      ,c.[ModifiedDate]    
      ,c.[RecordDeleted]    
      ,c.[DeletedDate]    
      ,c.[DeletedBy] from CustomDDAssessment c inner join DocumentVersions d on    
 c.DocumentVersionId= d.documentVersionId where d.DocumentId=@DocumentDDAssessment order by d.Version desc                                                    
 END TRY
 
 BEGIN CATCH
  DECLARE @Error varchar(8000)                           
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_ClientInformationQIDDReporting'')                                                         
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
