/****** Object:  StoredProcedure [dbo].[ssp_SCGetAuthorizationDocumentList]    Script Date: 11/18/2011 16:25:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAuthorizationDocumentList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAuthorizationDocumentList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAuthorizationDocumentList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
 CREATE PROCEDURE  [dbo].[ssp_SCGetAuthorizationDocumentList]                               
(                                            
 @AuthorizationDocumentId int                                                    
)                                            
                                            
As                                                            
Begin     
/********************************************************************************************/                                                    
/* Stored Procedure: ssp_SCGetAuthorizationDocumentList          */                                           
/* Copyright: 2009 Streamline Healthcare Solutions           */                                                    
/* Creation Date:  22 Feb 2011                 */                                                    
/* Purpose: Gets Data for  Authorizations Document Details screen corressponding to AuthorizationDocumentId */                                                   
/* Input Parameters: @AuthorizationDocumentId            */                                                  
/* Output Parameters:                  */                                                    
/* Return:                     */                                                    
/* Called By: GetAuthorizationDocumentList() Method in AuthorizationDetail Class Of DataService   */                                                    
/* Calls:                     */                                                    
/* Data Modifications:                  */                                                    
/*       Date              Author                  Purpose         */                                                    
/*   22 Feb 2011           Priya                   Created         */   
/*	 20 Oct 2015		   Revathi				   what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.*/             
/*													why:task #609, Network180 Customization  */  
/********************************************************************************************/                                                 
                                                     
                                                  
BEGIN TRY                                         
                                    
 SELECT ADOD.AuthorizationDocumentOtherDocumentId,D.DocumentId,DocumentName,
 D.ClientId,
-- Modified by Revathi 20 Oct 2015
 case when  ISNULL(Clients.ClientType,''I'')=''I'' then RTRIM(ISNULL(Clients.LastName, '''')) + '', '' + RTRIM(ISNULL(Clients.FirstName, '''')) else ISNULL(Clients.OrganizationName,'''') end  as ClientName,
 CodeName as Status,
 RTRIM(ISNULL(Staff.LastName, '''')) + '', '' + RTRIM(ISNULL(Staff.FirstName, '''')) as Author,EffectiveDate           
 from Documents D          
  inner join  AuthorizationDocumentOtherDocuments ADOD on ADOD.DocumentId=D.DocumentId 
  and IsNull(ADOD.RecordDeleted,''N'')  =''N''  and IsNull(D.RecordDeleted,''N'')  =''N''         
  inner join DocumentCodes DC on DC.DocumentCodeId=D.DocumentCodeId          
  inner join GlobalCodes GC on GC.GlobalCodeId=D.Status          
  inner join Staff on StaffId=D.AuthorId          
  inner join Clients on Clients.ClientId=D.ClientId        
 where ADOD.AuthorizationDocumentId=@AuthorizationDocumentId                     
 order by EffectiveDate desc          
          
                                                                                                            
END TRY                      
BEGIN CATCH                                                        
                                                      
DECLARE @Error varchar(8000)                                                                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCFillAuthorizationDocumentList'')                          
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                    
    + ''*****'' + Convert(varchar,ERROR_STATE())                                                                                 
 RAISERROR                                                                                                                                   
 (                                                                              
  @Error, -- Message text.                                            
  16, -- Severity.                                                                                                                                  
  1 -- State.                                                                                                                                  
 );                                                                                                                                
END CATCH                                                                              
END ' 
END
GO
