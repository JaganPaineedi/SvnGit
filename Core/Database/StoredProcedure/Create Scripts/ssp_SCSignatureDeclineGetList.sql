/****** Object:  StoredProcedure [dbo].[ssp_SCSignatureDeclineGetList]    Script Date: 11/18/2011 16:25:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSignatureDeclineGetList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSignatureDeclineGetList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSignatureDeclineGetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROC [dbo].[ssp_SCSignatureDeclineGetList](@DocumentId int,@SignatureID int,@DeletedBy varchar(30),@DeclineReason int)        
as        
/*********************************************************************/        
/* Stored Procedure: dbo.ssp_SCSignatureDeclineGetList                  */        
/* Creation Date:    18March2010                                     */        
/*                                                                   */        
/* Purpose:  Decline signer, Get Signer List and Get Signed Person List */        
/*                                                                   */      
/* Input Parameters:@SignatureID,@DeletedBy        */      
/* Output Parameters:   none                     */        
/*                                                                   */        
/* Return:  0=success, otherwise an error number                     */        
/*                                                                   */        
/* Called By:                                                        */        
/*                                                                   */        
/* Calls:                                                            */        
/*                                                                   */        
/* Data Modifications:                                               */        
/*                                                                   */        
/* Updates:                                                          */        
/*   Date         Author         Purpose                                    */        
/*  18March2010   Vikas Monga    Created                                    */        
/*	23Nov2011	  Shifali		 Added new param @DocumentVersionId to sp ssp_SCGetSignedPersonList call*/
/*	23Jun2015	  Dhanil		 Added new column ReasonForDecline task #633 N180 Customizations*/
/*********************************************************************/            
BEGIN        
declare @varSignatureorder int      
declare @varDocumentid int
declare @DocumentVersionId int      
 
--modified by Dhanil: Added new column ReasonForDecline task #633 N180 Customizations  
UPDATE DocumentSignatures SET DeclinedSignature=''Y'',ReasonForDecline = @DeclineReason where SignatureID=@SignatureID   

SELECT @DocumentVersionId = InProgressDocumentVersionId FROM Documents WHERE DocumentID = @DocumentId
  
exec ssp_SCWebSignatureSignersList @varDocumentId=@DocumentId  
exec ssp_SCGetSignedPersonList @DocumentId,@DocumentVersionId  
  
  
     IF (@@error!=0)      
     RAISERROR  20002  ''ssp_SCSignatureDeclineGetList: An Error Occured While Updating ''      
       
     END
' 
END
GO
