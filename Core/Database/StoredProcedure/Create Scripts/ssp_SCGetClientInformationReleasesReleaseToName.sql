IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SCGetClientInformationReleasesReleaseToName]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[ssp_SCGetClientInformationReleasesReleaseToName] 
  END 
GO

CREATE PROCEDURE [dbo].[ssp_SCGetClientInformationReleasesReleaseToName]       
 @ClientId int             
AS    
/***************************************************************************/             
/* Stored Procedure: [ssp_SCGetClientInformationReleasesReleaseToName] */                                                             
/* Copyright: 2006 Streamline SmartCare               */                                                                      
/* Creation Date:  November 22,2017                 */                                                                      
/* Purpose: Gets Data to fill dropdown ReleaseTo/From  from ClientInformationReleases for Revoke Release of Information Document */                                                                     
/* Input Parameters: @ClientId            */                                                                    
/* Output Parameters:                   */                                                                      
/* Return:  0=success, otherwise an error number                           */       
/* Calls:                                                                  */                            
/* Data Modifications:                                                     */                            
/* Updates:                                                                */                            
/* Date			Author          Purpose        */                            
/* 22/Nov/2017	Alok Kumar		Created to bind dropdown with ClientInformationReleases's ReleaseToName with startdate and enddate        */              
/***************************************************************************/                
  BEGIN    
  BEGIN TRY      

  
	SELECT CIR.ClientId,[ClientInformationReleaseId]    
		   ,ISNULL( [ReleaseToName],'')+', '+ISNULL(   CONVERT(VARCHAR, [StartDate], 101),'')+' - '+ISNULL(  CONVERT(VARCHAR, [EndDate], 101) ,'') as ReleaseToNameWithStartDateEndDate    
	       
	FROM [dbo].[ClientInformationReleases] CIR    
	where             
	 CIR.ClientId=@ClientId    
	 and EndDate>Convert(Date, GETDATE(), 101)  
	 and ISNULL( CIR.[RecordDeleted],'N')='N'    
	



        
  End Try    
  BEGIN CATCH                                                     
  DECLARE @Error varchar(8000)                         
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetClientInformationReleasesReleaseToName')                                                       
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