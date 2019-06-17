create  PROCEDURE  [dbo].[csp_EpisodeInformation]                                                                                                                                                             
(                           
 @ClientId int  
               
)              
As   
  
/************************************************************************/                                                  
/* Stored Procedure: csp_MHAssessmentInformation    */                                                                     
/* Copyright: 2006 Streamline SmartCare                            */                                                                              
/* Creation Date:  Sep 06 ,2011                                   */                                                  
/*                                                                 */                                                  
/* Purpose: Gets Data for  ClientEpisodes       */                                                 
/*                                                                 */                                                
/* Input Parameters: @ClientId                            */                                                
/*                                                                 */                                                   
/* Output Parameters:                                              */                                                  
/* Call By:                                                        */                                        
/* Calls:                                                          */                                                  
/*                                                                 */                                                  
/* Author: Jagdeep Hundal                                          */                                                  
/************************************************************************/     
BEGIN TRY  
             
Begin              
Declare @EpisodeInformation varchar(max)  
SET @EpisodeInformation =(SELECT TOP 1('EpisodeNumber: '+ Convert(varchar(8),EpisodeNumber)  +'     
'+'Registration: '+ISNull(Convert(varchar(8),RegistrationDate,1),'')+'          '+'Discharged: '+ISNull(Convert(varchar(8),DischargeDate,1),'') )  from ClientEpisodes where ClientId=@ClientId and  ISNull(RecordDeleted,'N')='N' order by RegistrationDate desc )    
select @EpisodeInformation as EpisodeInformation  
End   
  
END TRY                                                                                                   
--Checking For Errors                                        
BEGIN CATCH                                                     
   DECLARE @Error varchar(8000)                                                                                                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_MHAssessmentInformation')                       
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                        
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                 
                                                                                                                                  
END CATCH 