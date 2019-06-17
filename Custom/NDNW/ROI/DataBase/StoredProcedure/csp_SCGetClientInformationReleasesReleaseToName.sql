IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_SCGetClientInformationReleasesReleaseToName')
	BEGIN
		DROP  Procedure  csp_SCGetClientInformationReleasesReleaseToName
	END

GO

CREATE PROCEDURE [dbo].[csp_SCGetClientInformationReleasesReleaseToName]       
 @ClientId int             
AS    
/***************************************************************************/             
/* Stored Procedure: [csp_SCGetClientInformationReleasesReleaseToName] */                                                             
/* Copyright: 2006 Streamline SmartCare               */                                                                      
/* Creation Date:  January 17,2013                 */                                                                      
/* Purpose: Gets Data to fill dropdown ReleaseTo/From  from ClientInformationReleases for Revoke Release of Information Document */                                                                     
/* Input Parameters: @ClientId            */                                                                    
/* Output Parameters:                   */                                                                      
/* Return:  0=success, otherwise an error number                           */       
/* Calls:                                                                  */                            
/* Data Modifications:                                                     */                            
/* Updates:                                                                */                            
/* Date       Author          Purpose        */                            
/* 27/1/2013 Atul Pandey      Created to bind dropdown with ClientInformationReleases's ReleaseToName with startdate and enddate        */          
/* 30/1/2013 Sanjayb          Modified logic for active Client Releases     */          
/***************************************************************************/                
  BEGIN    
  BEGIN TRY      
SELECT CIR.ClientId,[ClientInformationReleaseId]
       ,ISNULL( [ReleaseToName],'')+', '+ISNULL(   CONVERT(VARCHAR, [StartDate], 101),'')+' - '+ISNULL(  CONVERT(VARCHAR, [EndDate], 101) ,'') as ReleaseToNameWithStartDateEndDate
   
FROM [dbo].[ClientInformationReleases] CIR
where
  Not  exists (Select CDRI.ClientInformationReleaseId 
				from CustomDocumentRevokeReleaseOfInformations CDRI 
				inner join Documents ds on ds.CurrentDocumentVersionId = CDRI.DocumentVersionId
             where CDRI.ClientInformationReleaseId=CIR.ClientInformationReleaseId
             and CIR.ClientId=@ClientId
             and ds.Status=22
             and ISNULL( CDRI.[RecordDeleted],'N')='N'
             and ISNULL( CIR.[RecordDeleted],'N')='N'
             and ISNULL( ds.[RecordDeleted],'N')='N'
             --to get only active release of information (i.e. only those docuuments which are not revoked)
 and            
 CIR.ClientId=@ClientId)
 --commented below line because previously we are thinking that we get active release of information by the End Date .
 --and EndDate>Convert(Date, GETDATE(), 101) --to get only active release of information,didn't write = because that is already release today
 and ISNULL( CIR.[RecordDeleted],'N')='N'
 --and CIR.ReleaseToId is not null  --ReleaseToId should  not be null for Because then it is specified that to whom Client Information is released.
    
  End Try    
  BEGIN CATCH                                                     
  DECLARE @Error varchar(8000)                         
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetClientInformationReleasesReleaseToName')                                                       
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