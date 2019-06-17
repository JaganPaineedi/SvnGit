IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClientInformations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClientInformations]
GO

CREATE PROCEDURE  [dbo].[ssp_RDLClientInformations]                       
(                                      
  @DocumentVersionId int              
)                                       
As                                                                                                                                                      
/************************************************************/                                                              
/* Stored Procedure: ssp_RDLClientInformations	            */                                                                                                               
/* Creation Date:  14 Nov 2013								*/                                                                                                                           
/* Purpose: Gets Data for Family History					*/                                                             
/* Input Parameters: @DocumentVersionId						*/                                                                                                                        
/* Author: Gayathri Naik									*/ 
/*   20 Oct 2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */ 
      
/************************************************************/                                                                                                                                          
BEGIN TRY                                     
BEGIN
	select DC.DocumentName,
	D.EffectiveDate,
	D.ClientId,
		-- Modified by   Revathi   20 Oct 2015   
		case when  ISNULL(C.ClientType,'I')='I' then ISNULL(C.LastName,'') + ', ' + ISNULL(C.FirstName,'') else ISNULL(C.OrganizationName,'') end as ClientName,
	C.DOB,
	SC.OrganizationName	
	from Documents D
	left join DocumentCodes DC on D.DocumentCodeId=DC.DocumentCodeId	
	and ISNull(DC.RecordDeleted,'N')='N'  
	left join Clients C on D.ClientId= C.ClientId   
	and ISNull(C.RecordDeleted,'N')='N' 
	cross join SystemConfigurations SC   
	where D.CurrentDocumentVersionId=@DocumentVersionId
	and ISNull(D.RecordDeleted,'N')='N'  
	
	
	  
	 
	
END                                                                                        
 END TRY                                                                                                 
 BEGIN CATCH                                                   
   DECLARE @Error varchar(8000)                                                                                                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLClientInformations')                     
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                      
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                     
                                                                                                                                
 END CATCH