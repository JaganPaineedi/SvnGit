/****** Object:  StoredProcedure [dbo].[ssp_SCWebSignatureSignersList]    Script Date: 11/26/2014 18:25:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebSignatureSignersList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebSignatureSignersList]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebSignatureSignersList]    Script Date: 11/26/2014 18:25:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
CREATE procedure [dbo].[ssp_SCWebSignatureSignersList](  
 @varDocumentId INT  
 --,@DocumentVersionId INT  
)                          
AS  
/*********************************************************************/                          
/* Stored Procedure: dbo.ssp_SCWebSignatureSignersListt                             */                          
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC      */                          
/* Creation Date:   16 Sep 2009                                        */                          
/*                                                                   */                          
/* Purpose:   gives the detail of person who have to sign the  document */                          
/*                                                                   */ /* Input Parameters: @varDocumenntId, @varVersion*/                          
/*                                                                   */                          
/* Output Parameters:   None                                         */                          
/*                                                                   */                          
/* Return:  0=success, otherwise an error number                 */                          
/*                                                                   */                          
/* Called By: Devinder                 */                          
/*                                                                   */                          
/* Calls:    Co-Signer                                                        */                          
/*                                                                   */                          
/* Data Modifications:                                               */                          
/*                                                                   */                          
/* Updates:                                                          */                          
/*   Date		Author      Purpose                                    */                          
/*   Devinder   Created                                    */      
/*06Oct2011		Shifali     Modified - Added Check StaffId is not Documet Author as per SHS discussion, we  
						  will not show Author in Signer list */   
/*23NOv2011		Shifali   Modified - Added isNull check in condition AND ISNULL(a.StaffId,-1) <> D.AuthorId 
  26 July 2016			  Shruthi Added logic to pull the Co-Signers automatically for Registartion document.Ref : #671 Network180-Customziations. .*/  
/* 19 September	Aravind   Passing parameter @varDocumentId to scsp_SCGetCoSignerListAfterSigningRegistration   
                           Why: Task #403 - Registration not displaying as needing to be Cosigned*/                       
/*********************************************************************/ 
                        
BEGIN  
 Declare @RegisDocumentCodeID int
 set @RegisDocumentCodeID = 10500 --Custom Registration DocumentCodeId  
 Declare @CurrentDocumentCodeId int
 select @CurrentDocumentCodeId = DocumentCodeId from Documents where DocumentId=@varDocumentId
 
 if(@CurrentDocumentCodeId = @RegisDocumentCodeID and   EXISTS (SELECT *   
           FROM   SYS.objects   
           WHERE  object_id =   
                  Object_id(N'[dbo].[scsp_SCGetCoSignerListAfterSigningRegistration]')   
                  AND type IN ( N'P', N'PC' ) )  and   EXISTS (SELECT *   
           FROM   SYS.objects   
           WHERE  object_id =   
                  Object_id(N'[dbo].[csp_SCGetCoSignerListAfterSigningRegistration]')   
                  AND type IN ( N'P', N'PC' ) ))
       begin 
     
                   exec scsp_SCGetCoSignerListAfterSigningRegistration @varDocumentId
       end 
 else
	  begin
				  SELECT a.SignatureId,a.SignatureOrder,                
			 CASE              
			 WHEN a.IsClient='Y' THEN  
			 c.lastName-- , c.Firstname                           
			  
			 WHEN a.IsClient='N' AND a.StaffId IS NULL THEN  
			 a.signername              
			  
			 ELSE b.lastName--,b.Firstname                           
			 END   
			 LastName,                
			 CASE WHEN a.IsClient='Y' THEN  
			 c.Firstname                
			 WHEN a.IsClient='N' AND a.StaffId IS NULL THEN ''              
			 ELSE                          
			 b.Firstname                           
			 END Firstname, a.IsClient, a.StaffId  ,a.ClientId              
			 FROM DocumentSignatures a                   
			 LEFT JOIN Staff b on a.staffid=b.staffid                  
			 LEFT JOIN Clients c ON c.Clientid=a.ClientID                  
			 LEFT JOIN Documents D ON a.DocumentId = D.DocumentId  
			 WHERE  
			 a.DocumentId=@varDocumentId AND  
			 a.SignatureDate IS NULL AND (a.RecordDeleted='N' OR a. RecordDeleted IS  NULL)                          
			 AND ISNULL(a.DeclinedSignature,'N')='N'                      
			 AND ISNULL(c.RecordDeleted,'N')='N'                
			 --AND (a.SignedDocumentVersionId = @DocumentVersionId)  
			 AND ISNULL(a.StaffId,-1) <> D.AuthorId 
	  end
   
  
 IF (@@error!=0)                
 BEGIN
   RAISERROR ('ssp_SCWebSignatureSignersList: An Error Occured ',16,1);
 END                                     
END                