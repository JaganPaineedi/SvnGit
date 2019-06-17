
IF EXISTS ( SELECT	 *
			FROM	 SYS.objects
			WHERE	 object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomScreening]')
					 AND type IN (N'P', N'PC') ) 
   BEGIN 
	  DROP PROCEDURE [dbo].[csp_RDLCustomScreening] 
   END 
  GO              


CREATE PROCEDURE [dbo].[csp_RDLCustomScreening]
   @DocumentVersionId AS INT
AS /************************************************************************/                                                            
/* Stored Procedure: csp_RDLCustomScreening      */                                                   
/*        */                                                            
/* Creation Date:  11/05/2015           */                                                            
/*                  */                                                            
/* Purpose: Gets Data for csp_Subreport       */                                                           
/* Input Parameters: DocumentVersionId        */                                                          
/* Output Parameters:             */                                                            
/* Purpose: Use For Rdl Report           */                                                  
/* Calls:                */                                                            
/*                  */                                                            
/*Author :    Date             Purpose    */
/*Shruthi.S : 11/05/2015       Added to pull data for the main report header fields. #39 New Directions - Customizations.*/

/*********************************************************************/           
   BEGIN     
Select
    sc.OrganizationName
   ,Documents.ClientId                          
  ,Clients.LastName + ', ' + Clients.FirstName as ClientName                          
  ,Staff2.LastName + ', ' + Staff2.FirstName as ClinicianName                          
  ,Documents.EffectiveDate
  ,convert(varchar(10),Clients.DOB,101)  as DOB
From Documents  with (nolock)      
Join Clients with (nolock)  on Clients.ClientId = Documents.ClientId      
join DocumentVersions as dv with (nolock) on dv.DocumentId = documents.DocumentId    
Left Join Staff as Staff2 with (nolock) on Staff2.StaffId = Documents.AuthorId                                 
--cross Join CustomConfigurations cc   with (nolock)     
cross join SystemConfigurations sc with (nolock)                    
Where dv.DocumentVersionId =@DocumentVersionId                    
and ISNULL(Documents.RecordDeleted,'N')='N'                 
and ISNULL(Staff2.RecordDeleted,'N')='N'                       
and ISNULL(Clients.RecordDeleted,'N')='N'                       
                              
			   

  
--Checking For Errors  
	  IF (@@error != 0) 
		 BEGIN  
			RAISERROR  20006   'csp_RDLCustomScreening : An Error Occured'  
			RETURN  
		 END  
   END      
  
  