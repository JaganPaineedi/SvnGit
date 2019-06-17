IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCSignatureAddFirstSigner')
	BEGIN
		DROP  Procedure SSP_SCSIGNATUREADDFIRSTSIGNER
		                 
	END
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[ssp_SCSignatureAddFirstSigner]  
(@DocumentID int,  
@DocumentVersionId int)            
  
as            
/*********************************************************************/              
/* Stored Procedure: dbo.ssp_SignatureAddFirstSigner                */              
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */              
/* Creation Date:    8/22/05                                         */              
/*                                                                   */              
/* Purpose:  INsert first singer to author       */            
/*                                                                   */            
/* Input Parameters:   @StaffID, @DocumentID,  @NewDocumentID  */            
/*                                                                   */              
/* Output Parameters:   None                               */              
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
/*  Date     Author       Purpose                                    */              
/* 8/22/05   Vikas        Created                                    */              
/* 29/May/08 Sony John    Modified Added select statement from documents  EHR-Support#2511   Make Cancel / No Show Notes Optional - System Wide*/      
/* 08Aug2011 Shifali      Modified Purpose - Updated Column DocumentSignatures.RevisionNumber */
/* 07Oct2011 Shifali      Modified Purpose   Removed update of DocumentSignatures.RevisionNumber as it will be updated on sign only*/
/* 23Jan2012 Shifali      Removed SignedDocumentVersionId updation/insertion*/
/* 14/12/2012 Bernardin   Insert statement added to save the cosigner and guardian automatically Development phase Iv (offshore) task #15*/
/* 28/10/2013 Shankha     Thresholds - Support# 350: Included RecordDeleted check on ClientContact and removed Inner Join with GlobalCodes*/
/* 08/07/2016 Aravind     Modified the @SignerExist logic(Checking a SignedDocumentVersionId)  to add the Client and guardian as a Cosigners automatically on edited version to have them sign.
						  Why: Task #211 - Network 180 Environment Issues Tracking */
/* 12/20/2016 Aravind     Added the logic to remove duplicate Client Cosigners entry in the Edited version of a document
						  Why: Task #782 - 	Network180 Support Go Live */		
/* 01/05/2017 Veena       What:Added top 1 condition for the isclient   
                          Why: Task #782 - 	Network180 Support Go Live */	
/* 21/03/2017  Veena	  What:Added if not exist condition to avoid entering duplicate co-signer for the same document.
                          Why:Network180 Support Go Live  #47   */	  
/* 21/03/2017   Veena     What:Removed not exist condition from Author as it needs to be created  for all the version.
                          Why:Network180 Support Go Live  #47   */
/*10/07/2018   Prem       What:Added @StaffID parameter and passing to DocumentSignatures table
                          Why:Bradford - Support Go Live #632.2                   */
/*15/Oct/2018 Swatika     Added insert statement to save the cosigner as staff automatically as part of Renaissance - Dev Items Tasks #695*/
/******************************************************************************************************************************************/             
BEGIN TRANSACTION            
--if exists(select 1 from documentcodes dc join documents d on  d.documentcodeid=dc.documentcodeid where d.documentid=@DocumentID and dc.RequiresSignature='Y')          
      
declare @RecordDeleted char(1)       
declare @Deletedby  varchar(30)      
declare @DeletedDate datetime
declare @RevisionNumber int
declare @DocumentCodeId int  
declare @DefaultCoSigner char(1)
declare @DefaultGuardian char(1)
declare @ClientId int
declare @FirstName varchar(100)
declare @LastName varchar(100)    
declare @SignerExist bit
declare @DocumentVersion int 
declare @CosignerClient int  
declare @Isclient char  
declare @Authorid int
Declare @StaffId int  ---Added By Prem
Declare @DefaultStaffCosigner char(1)
Declare @AlwaysDefaultCosigner char(1)
Declare @CoSignerId INT
Declare @CoSignerIdName Varchar(1000)
Set @SignerExist=0 


select @RecordDeleted=recordDeleted,@DeletedBy=DeletedBy,@DeletedDate=DeletedDate,@DocumentCodeId = DocumentCodeId,@ClientId=ClientId,@Authorid=AuthorID
 from  documents where documentid=@DocumentID  
 
 Select @FirstName = FirstName,@LastName=LastName from Clients Where ClientId = @ClientId
 
 Select @DocumentVersion= DocumentVersionId,@StaffId=AuthorId from DocumentVersions D where D.DocumentVersionId=@DocumentVersionId

Select @DefaultCoSigner = DefaultCoSigner,@DefaultGuardian = DefaultGuardian ,@DefaultStaffCosigner=DefaultStaffCosigner from DocumentCodes Where DocumentCodeId = @DocumentCodeId
  


   SELECT @AlwaysDefaultCosigner= SP.AlwaysDefaultCosigner, @CoSignerId=S.CoSignerId
   FROM StaffPreferences SP INNER JOIN Staff S ON S.StaffId=SP.StaffId AND  S.StaffId=@StaffId 
   WHERE isnull(S.RecordDeleted,'N')='N'  AND isnull(SP.RecordDeleted,'N')='N'
   
   SET @CoSignerIdName = (SELECT LastName + ', ' + FirstName FROM dbo.Staff WHERE StaffId = @CoSignerId)  
   
 -- Modified by Aravind For Task #211 - Network 180 Environment Issues Tracking
 Set @SignerExist = (SELECT Count(ClientId)AS ClientId from DocumentSignatures where  ClientID=@ClientID AND DocumentId=@DocumentID AND SignedDocumentVersionId=@DocumentVersion AND isnull(RecordDeleted,'N')='N') 
 
-- Modified by Aravind For Task #782 - Network180 Support Go Live
-- Starts 
--Modified by Veena For Task #782 - Network180 Support Go Live
Set @Isclient = (SELECT Top 1 IsClient from DocumentSignatures where  ClientID=@ClientId AND DocumentId=@DocumentID AND isnull(RecordDeleted,'N')='N' AND SignedDocumentVersionId is not null order by SignedDocumentVersionId desc) 
IF (@Isclient='Y')
BEGIN
Set @CosignerClient = (SELECT TOP 1 ClientId from DocumentSignatures where  ClientID=@ClientID AND DocumentId=@DocumentID AND isnull(RecordDeleted,'N')='N' AND SignedDocumentVersionId is not null) 
END
ELSE 
BEGIN
Set @CosignerClient=1
END
-- End
     
if(isnull(@RecordDeleted,'N')='N')      
begin     
 INSERT INTO DocumentSignatures            
 (DocumentId,StaffId,SignatureOrder,CreatedBy,CreatedDate,ModifiedBy)            
 select  DocumentID,Isnull(@StaffId,AuthorId),1,CreatedBY,CreatedDate,ModifiedBy      -- Added @staffId parameter by Prem
 from Documents where DocumentID=@DocumentID  and isNull(RecordDeleted,'N')<>'Y'   
end          
else      
begin   
 INSERT INTO DocumentSignatures            
 (DocumentId,StaffId,SignatureOrder,CreatedBy,CreatedDate,ModifiedBy,RecordDeleted,DeletedBy,DeletedDate)            
 select  DocumentID,AuthorID,1,CreatedBY,CreatedDate,ModifiedBy,RecordDeleted,DeletedBy,DeletedDate
 from Documents where DocumentID=@DocumentID       
end 

if (@SignerExist = 0)
Begin
if(@DefaultCoSigner = 'Y')
IF (@CosignerClient!=0) --- Added for Task #782 - Network180 Support Go Live
begin
 --IF not exists condition added by Veena on  21/03/2017 for Network180 Support Go Live #47
IF NOT EXISTS(Select 1 from DocumentSignatures where DocumentId=@DocumentID and ClientId=@ClientId and IsClient='Y' and isnull(@RecordDeleted,'N')='N')
   BEGIN
 INSERT INTO DocumentSignatures (DocumentId,ClientId,IsClient,SignerName,SignatureOrder) Values (@DocumentID,@ClientId,'Y',@LastName + ', ' + @FirstName,2)
  END
End

if(@DefaultGuardian = 'Y')
    Begin
    --IF not exists condition added by Veena on  21/03/2017 for Network180 Support Go Live #47
    Create table #ClientContacts(
    Number int identity(1,1),
    ContactId int)
    insert into #ClientContacts
    Select distinct Relationship From ClientContacts where ClientId = @ClientId And Guardian = 'Y'  AND  ISNULL(RecordDeleted,'N')<>'Y'  
    Declare @CountContact int ,@ContactNo int,@Relation int
    SET @ContactNo =1
    Select @CountContact= count(Number) from #ClientContacts
    While(@ContactNo <= @CountContact)
    BEGIN
      SET @Relation = (Select ContactId from  #ClientContacts where Number = @ContactNo)
     IF NOT EXISTS(Select 1 from DocumentSignatures where DocumentId=@DocumentID and RelationToClient=@Relation and IsClient = 'N' and isnull(RecordDeleted,'N')<>'Y' )
   BEGIN
		INSERT INTO DocumentSignatures (DocumentId,IsClient,RelationToClient,SignerName,SignatureOrder) 
		SELECT  @DocumentID,'N',@Relation, (ClientContacts.LastName+', '+ClientContacts.FirstName) AS SignerName,3
		FROM         ClientContacts  
		WHERE ClientContacts.ClientId = @ClientId and Relationship=@Relation And ClientContacts.Guardian = 'Y'  AND  ISNULL(ClientContacts.RecordDeleted,'N')<>'Y'  
	End
	SET @ContactNo =@ContactNo + 1
    END
   END
	
	

End
IF (@CoSignerId IS NOT NULL)
		BEGIN
		IF (ISNULL(@AlwaysDefaultCosigner,'N')='Y')
		BEGIN
			IF NOT EXISTS(Select 1 from DocumentSignatures where DocumentId=@DocumentID and StaffId=@CoSignerId and IsClient='N' and isnull(RecordDeleted,'N')='N')
				BEGIN
				   INSERT INTO DocumentSignatures (DocumentId,IsClient,StaffId,SignerName,SignatureOrder) Values (@DocumentID,'N',@CoSignerId,@CoSignerIdName,4)
				END
		END 
		Else
		BEGIN
			if(ISNULL(@DefaultStaffCosigner,'N') = 'Y')
			BEGIN
				IF NOT EXISTS(Select 1 from DocumentSignatures where DocumentId=@DocumentID and StaffId=@CoSignerId and IsClient='N' and isnull(RecordDeleted,'N')='N')
				BEGIN
				   INSERT INTO DocumentSignatures (DocumentId,IsClient,StaffId,SignerName,SignatureOrder) Values (@DocumentID,'N',@CoSignerId,@CoSignerIdName,4)
				END
			END
		END
END 
      
if @@Error<>0 goto error            
  --Commented by Rohit Katoch in reference to core Datmodel upgradation from 2.1 to 2.2        
--select RowIdentifier from DocumentSignatures where SignatureId=@@identity          
COMMIT TRANSACTION            
return(0)            
            
error:            
 rollback tran            
 RAISERROR('Error in ssp_SignatureAddFirstSigner procedure', 16, 1)          
          
           