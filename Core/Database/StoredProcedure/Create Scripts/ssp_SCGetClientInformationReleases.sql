

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientInformationReleases]    Script Date: 05/15/2013 18:41:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientInformationReleases]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientInformationReleases]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientInformationReleases]    Script Date: 05/15/2013 18:41:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ssp_SCGetClientInformationReleases]
@ClientId int
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 25.05.2012	Vaibhav Khare		Commiting on DEV environment 
-- =============================================
AS
BEGIN
 Begin try    
	--ClientInformationReleases                                              
Select   Case                                                                      
   When (SELECT     COUNT(*)                                      
  FROM         ClientInformationReleaseDocuments INNER JOIN                                    
                      ClientInformationReleases AS CIR ON ClientInformationReleaseDocuments.ClientInformationReleaseId = CIR.ClientInformationReleaseId                                    
  WHERE     (CIR.ClientInformationReleaseId = CIR.ClientInformationReleaseId)                                     
  AND (ISNULL(ClientInformationReleaseDocuments.RecordDeleted, 'N') = 'N') ) > 1 Then 'Multiple Documents'                                  
  Else ( select DocumentCodes.DocumentName from DocumentCodes inner join Documents on Documents.DocumentCodeId=DocumentCodes.DocumentCodeId                                                                    
  inner join ClientInformationReleaseDocuments on Documents.DocumentId= ClientInformationReleaseDocuments.DocumentId                                                                    
  inner join ClientInformationReleases as CIR on ClientInformationReleaseDocuments.ClientInformationReleaseDocumentId= CIR.ClientInformationReleaseId                                                                    
  where ClientInformationReleaseDocuments.ClientInformationReleaseId=ClientInformationReleases.ClientInformationReleaseId and ISNULL(ClientInformationReleaseDocuments.RecordDeleted,'N')='N' )                                                               
  
    
     
                                                                           
  ENd as 'ReleaseDocuments'                    
    ,ClientInformationReleases.[ClientInformationReleaseId]                                                                        ,ClientInformationReleases.[ClientId]                                                                                       
  
    
     
    ,ClientInformationReleases.[ReleaseToId]                                                                                            
    ,ClientInformationReleases.[ReleaseToName]                                                        
    ,case when ClientInformationReleases.[StartDate] IS Not NULL then convert(varchar,ClientInformationReleases.[StartDate],101)                                                                                 
            end AS [StartDate]                                                        
    ,case when ClientInformationReleases.[EndDate] IS Not NULL then convert(varchar,ClientInformationReleases.[EndDate],101)                                                                                  
            end AS [EndDate]                                                                                
    ,ClientInformationReleases.[Comment]                                     
    ,ClientInformationReleases.[DocumentAttached]                                                                                            
    ,ClientInformationReleases.[RowIdentifier]                                                                                            
    ,ClientInformationReleases.[CreatedBy]                                                                             
    ,ClientInformationReleases.[CreatedDate]                                                                                            
    ,ClientInformationReleases.[ModifiedBy]                                                    
    ,ClientInformationReleases.[ModifiedDate]                                                                                            
    ,ClientInformationReleases.[RecordDeleted]                                                                                            
    ,ClientInformationReleases.[DeletedDate]                                                                                  
   ,ClientInformationReleases.[DeletedBy]      
    ,Remind  
    ,DaysBeforeEndDate                                                       
    ,Locked  
    ,LockedBy    
    ,LockedDate   
    from ClientInformationReleases                                               
      Where isNull(ClientInformationReleases.RecordDeleted,'N')<>'Y' and ClientInformationReleases.ClientId=@ClientId                                       
                                            
                                            
--ClientInformationReleaseDocuments                                               
select                                                                            
 ClientInformationReleaseDocuments.ClientInformationReleaseDocumentId                                                                  
,ClientInformationReleaseDocuments.ClientInformationReleaseId                                                                  
,Documents.DocumentId                                                                          
, DocumentCodes.DocumentCodeId,DV.DocumentVersionId as [Version], DocumentCodes.DocumentName  --DV.Version                                                              
,case when Documents.EffectiveDate IS Not NULL then convert(varchar,Documents.EffectiveDate,101)                                                                                             
            end AS [EffectiveDate]                                                                
,gcs.CodeName as [Status]                                                                
,case when (st.LastName + ', ' + st.FirstName) IS not NULL then (st.LastName + ', ' + st.FirstName)                                                                                                 
            end AS AuthorName                                                                          
,ClientInformationReleaseDocuments.[RowIdentifier]                                                                                
,ClientInformationReleaseDocuments.[CreatedBy]                                     
,ClientInformationReleaseDocuments.[CreatedDate]                                                                      
,ClientInformationReleaseDocuments.[ModifiedBy]                                                                                                
,ClientInformationReleaseDocuments.[ModifiedDate]                                                                                       
,ClientInformationReleaseDocuments.[RecordDeleted]                                                                                                
,ClientInformationReleaseDocuments.[DeletedDate]                                                                                       
,ClientInformationReleaseDocuments.[DeletedBy]                                                     
,'true' as AddButtonEnabled                                                                         
 from ClientInformationReleaseDocuments                                                             
 inner join                                                             
 ClientInformationReleases on ClientInformationReleases.ClientInformationReleaseId=ClientInformationReleaseDocuments.ClientInformationReleaseId and ISNULL(ClientInformationReleases.RecordDeleted,'N')='N'                                                
 inner join Documents on                                                                        
 ClientInformationReleaseDocuments.DocumentId=Documents.DocumentId                                                             
 inner join DocumentVersions as DV on DV.DocumentId= Documents.DocumentId  and DV.DocumentVersionId=Documents.CurrentDocumentVersionId                                                                
 inner join DocumentCodes on DocumentCodes.DocumentCodeId=Documents.DocumentCodeId                                                                
 inner join GlobalCodes as gcs on gcs.GlobalCodeId= Documents.Status                                
 inner join Staff as st on st.StaffId = Documents.AuthorId                                                               
 where isNull(ClientInformationReleaseDocuments.RecordDeleted,'N')='N'                                                                
  and ClientInformationReleases.ClientId=@ClientId                                                   
            


end try                                                      
                                                                                      
BEGIN CATCH          
        
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetClientInformationReleases')                                                                                     
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


