IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetEpisodeInformations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetEpisodeInformations]
GO
create  PROCEDURE  [dbo].[ssp_GetEpisodeInformations]                                                                                                                                                             
(                           
 @ClientId int  
               
)              
As   
  
/************************************************************************/                                                  
/* Stored Procedure: ssp_GetEpisodeInformations    */                                                                     
/* Copyright: 2006 Streamline SmartCare                            */                                                                              
/* Creation Date:  Jan 16 ,2018                                   */                                                  
/*                                                                 */                                                  
/* Purpose: Gets Data for  ClientEpisodes       */                                                 
/*                                                                 */                                                
/* Input Parameters: @ClientId                            */                                                
/*                                                                 */                                                   
/* Output Parameters:                                              */                                                  
/* Call By:                                                        */                                        
/* Calls:                                                          */                                                  
/*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */                                                
/************************************************************************/     
BEGIN TRY  
             
Begin              
Declare @EpisodeInformation varchar(max)  
SET @EpisodeInformation =(SELECT TOP 1('Episode Number: '+ Convert(varchar(8),EpisodeNumber)  +'     
'+'Registration: '+ISNull(Convert(varchar(8),RegistrationDate,1),'')+'          '+'Discharged: '+ISNull(Convert(varchar(8),DischargeDate,1),'') )  from ClientEpisodes where ClientId=@ClientId and  ISNull(RecordDeleted,'N')='N' order by RegistrationDate desc )    
select @EpisodeInformation as EpisodeInformation  
End   
  
END TRY                                                                                                   
--Checking For Errors                                        
BEGIN CATCH                                                     
   DECLARE @Error varchar(8000)                                                                                                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetEpisodeInformations')                       
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                        
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                 
                                                                                                                                  
END CATCH 