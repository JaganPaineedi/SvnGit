IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCSignatureSignedByStaff')
	BEGIN
		DROP  Procedure ssp_SCSignatureSignedByStaff
		                 
	END
GO
CREATE PROC [dbo].[ssp_SCSignatureSignedByStaff]
    (
      @StaffID INT ,
      @DocumentID INT ,
      @Password VARCHAR(100) ,
      @ClientSignedPaper VARCHAR(1) ,
      @DocumentVersionId INT
    )
AS /*********************************************************************/                                
/* Stored Procedure: dbo.ssp_SignatureSignedStaffWithPad                */                                
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                
/* Creation Date:    7/24/05                                         */                                
/*                                                                   */                                
/* Purpose: This is used to when document is signed by the user */                                
/*                                                                   */                              
/* Input Parameters:@StaffID - StaffID                                      
     @DocumentID - DocumentID                              
     @Version - Version                              
     @ClientSignedPaper - ClientSignedPaper                              
     @Password              
                 */                              
/*                                                                   */                                
/* Output Parameters:   None                           */                                
/*                                                                   */                                
/* Return:                                */                                
/*                                                                   */                                
/* Called By:                                                        */                                
/*                                                                   */                                
/* Calls:                                                            */                                
/*                                                                   */                                
/* Data Modifications:                                               */                                
/*                                                                   */                                
/* Updates:                                                          */                                
/*   Date     Author       Purpose       Purpose               */                                
/*  7/24/05   Kulwinder    Created               
  Saurabh   Modified   Transfer Document functionality Added               
    3/16/06   vikas modified   added for Task no 1142 Dx Need or not   */           
/*11/30/2007 Vikas Vyas   Update Modified Date In DocumentSignature Table */          
/*11Aug2011	 Shifali	  Added CurrentVersionStatus = 22 in Update Document when documentcodeId<>102 */           
/*11Aug2011  Shifali	  Added Logic to Update RevisionNumber in DocumentSignatures table	*/
/*07Sept2011 Shifali	  Added Update for Documents.CurrentDocumentVersionId on sign equal to InProgressDocumentVersionId*/
/*03Oct2011	 Shifali	  Added condition AND SignedDocumentVersionId IS NULL*/
/*09Aug2012  AmitSr       Removed Space after last name when updated in DocumentSignature, #1908,Harbor Go Live Issues ,Document Signatures: Wrong Formating*/  
/*19April2013 Bernardin   Reverted back to previous version */
/*23April2013 Bernardin   Added condition AND SignedDocumentVersionId IS NULL AND SignatureDate IS NULL. 3.5X Issues Task# 286*/
/*08/25/2015 Wasif		  Going to bypass password check here if AuthenticationType is AD because we can only reach this signature part if AD password was already validated in the app */
/*15 December 2016 Manjunath K   Modified Existing conditions to create entries into TimelineServices for all services. */
/*								 For AspenPointe-Environment Issues  #35.*/
/*16 May 2017 Manjunath K   Modified Existing conditions to create entries into TimelineServices for DSM Diagnosis document as well. */
/*								 For AspenPointe-Environment Issues  #35.*/
/* 10/07/2018   Prem   What:Added @AllowVersionAuthorToSign parameter and checking the same while updating the Documents table.
                       Why: Implemented the new functionality for Bradford. In documents while clicking on Edit button the Sign button
                        should be enable based on AllowVersionAuthorToSign column. If the AllowVersionAuthorToSign column is 'Y' then it will allow to sign the document
                        Task#:Bradford - Support Go Live #632.2 */
/*13 Nov 2018 Chita Ranjan		 What:Added condition to Update the VerificationMode column in DocumentSignatures table dynamically based on selection in Signature Popup*/
/*                      		 Why: PEP - Customizations #10212*/
/*********************************************************************/                               
                    
                            
    BEGIN                              
        DECLARE @varNewDocId INT                              
        DECLARE @DocumentCodeId INT                            
        DECLARE @IsFirstUser VARCHAR(10)                           
        DECLARE @Coordinator VARCHAR(10)                  
        DECLARE @NewDocumentID INT                         
        DECLARE @FirstName VARCHAR(100)                                
        DECLARE @LastName VARCHAR(100)                                
        DECLARE @SigningSuffix VARCHAR(100)           
--DECLARE @DocumentVersionId int 
        DECLARE @RevisionNumber INT  
        DECLARE @AllowVersionAuthorToSign varchar(1)
        DECLARE @VerificationMode varchar(1)  = 'P' 
  
	  IF (@ClientSignedPaper = 'V')
	  BEGIN
	  SET @VerificationMode = 'V'
	  SET @ClientSignedPaper='N'
	  END
 --Get RevisionNumber
-- SELECT @RevisionNumber = RevisionNumber FROM DocumentVersions DV
-- JOIN Documents D on DV.DocumentVersionId = D.CurrentDocumentVersionId 
-- WHERE D.DocumentId=@DocumentID
  
----Get DocumentVersionId using DocumentID,Version  
--SELECT @DocumentVersionId=SignedDocumentVersionId FROM DocumentSignatures   
--WHERE DocumentId=@DocumentID and StaffId= @StaffId and ISNULL(RecordDeleted,'N')='N'                          


        SELECT  @RevisionNumber = RevisionNumber
        FROM    DocumentVersions DV
        WHERE   DV.DocumentVersionId = @DocumentVersionId
        
        SELECT  @DocumentCodeId = DocumentCodeId
                FROM    Documents
                WHERE   Documentid = @DocumentID
                        AND ISNULL(RecordDeleted, 'N') = 'N'
        SELECT  @AllowVersionAuthorToSign = AllowVersionAuthorToSign  ---Added By Prem 10-07-2018
                 From DocumentCodes 
                 WHERE   DocumentCodeId =  @DocumentCodeId
                        AND ISNULL(RecordDeleted, 'N') = 'N'          
                            
  
--Get DocumentVersionId using DocumentID,Version  
--SELECT @DocumentVersionId=SignedDocumentVersionId FROM DocumentSignatures   
--WHERE DocumentId=@DocumentID and StaffId= @StaffId and ISNULL(RecordDeleted,'N')='N'



--Raman              
        SELECT  @FirstName = FirstName ,
                @LastName = LastName ,
                @SigningSuffix = ISNULL(SigningSuffix, '')
        FROM    Staff
        WHERE   StaffID = @StaffID
                AND ISNULL(RecordDeleted, 'N') <> 'Y'                                
--Verify the PAssword              
			if EXISTS ( SELECT  StaffID
                    FROM    Staff
                    WHERE   StaffID = @StaffID and ([UserPassword] = @Password or AuthenticationType = 'A'))
            BEGIN                       
                         
                IF ( @DocumentCodeId = 102 )--Transfer Document                            
                    BEGIN                    
                        IF EXISTS ( SELECT  CusTran.RequestingTeamCoordinator
                                    FROM    CustomTransfers CusTran
                                            JOIN DocumentVersions V ON CusTran.DocumentVersionId = V.DocumentVersionId
                                            JOIN Documents Doc ON V.Documentid = Doc.Documentid
                                            JOIN Documentsignatures DocSig ON DocSig.Documentid = Doc.Documentid
                                    WHERE   Doc.DocumentId = @DocumentID
                                            AND ISNULL(CusTran.RequestingDecision,
                                                       '') = ''
                                            AND ISNULL(CusTran.ReceivedDecision,
                                                       '') = ''
                                            AND ISNULL(DocSig.SignatureDate,
                                                       '') = ''
                                            AND ISNULL(CusTran.RecordDeleted,
                                                       'N') <> 'Y'
                                            AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(V.RecordDeleted, 'N') = 'N'
                                            AND ISNULL(DocSig.RecordDeleted,
                                                       'N') = 'N'
                                            AND Doc.AuthorId = @StaffID ) 
                            SELECT  @IsFirstUser = 'True'                            
                        ELSE 
                            SELECT  @IsFirstUser = 'False'                            
                               
                        IF ( @IsFirstUser = 'True' ) 
                            BEGIN                            
                                IF EXISTS ( SELECT  RequestingTeamCoordinator
                                            FROM    CustomTransfers
                                            WHERE   DocumentVersionId = @DocumentVersionId
                                                    AND ISNULL(RequestingTeamCoordinator,
                                                              '') <> ''
                                                    AND ISNULL(RecordDeleted,
                                                              'N') = 'N' ) 
                                    BEGIN                            
                                        SELECT  @Coordinator = RequestingTeamCoordinator
                                        FROM    CustomTransfers
                                        WHERE   DocumentVersionId = @DocumentVersionId
                                                AND ISNULL(RequestingTeamCoordinator,
                                                           '') <> ''
                                                AND ISNULL(RecordDeleted, 'N') = 'N'              
                                        BEGIN TRANSACTION                            
                                        UPDATE  Documents
                                        SET     AuthorId = @Coordinator
                                        WHERE   DocumentId = @DocumentID
                                                AND ISNULL(RecordDeleted, 'N') = 'N'              
                                        UPDATE  CustomTransfers
                                        SET     SentDate1 = GETDATE()
                                        WHERE   DocumentVersionId = @DocumentVersionId
                                                AND ISNULL(RecordDeleted, 'N') = 'N'              
                                        DELETE  FROM DocumentSignatures
                                        WHERE   DocumentId = @DocumentID
                                                AND ISNULL(RecordDeleted, 'N') = 'N'              
                                        IF @@error <> 0 
                                            GOTO error                               
                                        COMMIT TRANSACTION                             
                                    END                            
                                ELSE 
                                    IF EXISTS ( SELECT  ReceivingTeamCoordinator
                                                FROM    CustomTransfers
                                                WHERE   DocumentVersionId = @DocumentVersionId
                                                        AND ISNULL(ReceivingTeamCoordinator,
                                                              '') <> ''
                                                        AND ISNULL(RecordDeleted,
                                                              'N') = 'N' ) 
                                        BEGIN                            
                                            SELECT  @Coordinator = ReceivingTeamCoordinator
                                            FROM    CustomTransfers
                                            WHERE   DocumentVersionId = @DocumentVersionId
                                                    AND ISNULL(ReceivingTeamCoordinator,
                                                              '') <> ''
                                                    AND ISNULL(RecordDeleted,
                                                              'N') = 'N'              
                                            BEGIN TRANSACTION                            
                                            UPDATE  Documents
                                            SET     AuthorId = @Coordinator
                                            WHERE   DocumentId = @DocumentID
                                                    AND ISNULL(RecordDeleted,
                                                              'N') = 'N'              
                                            UPDATE  CustomTransfers
                                            SET     SentDate2 = GETDATE()
                                            WHERE   DocumentVersionId = @DocumentVersionId
                                                    AND ISNULL(RecordDeleted,
                                                              'N') = 'N'              
                                            DELETE  FROM DocumentSignatures
                                            WHERE   DocumentId = @DocumentID
                                                    AND ISNULL(RecordDeleted,
                                                              'N') = 'N'              
                                            IF @@error <> 0 
                                                GOTO error                              
                                            COMMIT TRANSACTION                             
                                        END                            
                            END                            
                        ELSE 
                            IF ( @IsFirstUser = 'False' ) 
                                BEGIN                  
                                    IF EXISTS ( SELECT  StaffID
                                                FROM    Staff
                                                WHERE   [UserPassword] = @Password
                                                        AND StaffID = @StaffID ) 
                                        BEGIN                                
                                            BEGIN TRAN                              
           --Update the document signatures                               
                                            UPDATE  documentSignatures
                                            SET     SignatureDate = GETDATE() ,
                                                    ModifiedDate = GETDATE() ,
                                                    ClientSignedPaper = @ClientSignedPaper ,
                                                    VerificationMode = @VerificationMode ,
                                                    SignerName = @FirstName
                                                    + ' ' + @LastName
                                                    + CASE WHEN @SigningSuffix = ''
                                                           THEN ''
                                                           ELSE ', '
                                                              + @SigningSuffix
                                                      END
                                            WHERE   documentid = @DocumentID
                                                    AND StaffID = @StaffID
                                                    AND ISNULL(RecordDeleted,
                                                              'N') = 'N' --and Version=@Version                                
                                            IF @@error <> 0 
                                                GOTO error                               
                                 
                                            UPDATE  Documents
                                            SET     SignedByAuthor = 'Y' ,
                                                    DocumentShared = 'Y' ,
                                                    Status = 22
                                            WHERE   documentid = @DocumentID
                                                    AND AuthorID = @StaffID
                                                    AND ISNULL(RecordDeleted,
                                                              'N') = 'N'              
                                            IF @@error <> 0 
                                                GOTO error                   
                  
                                            IF EXISTS ( SELECT
                                                              CreateAssignment
                                                        FROM  CustomTransfers
                                                        WHERE CreateAssignment = 'Y'
                                                              AND DocumentVersionId = @DocumentVersionId
                                                              AND ISNULL(RecordDeleted,
                                                              'N') = 'N' ) 
                                                EXEC ssp_SCCreateAssignmentTransfer                    
                                            IF @@error <> 0 
                                                GOTO error                                
                                            COMMIT TRAN                              
                                        END                              
                                END                
                    END                
                ELSE      -- if documentcodeid<>102                
                    BEGIN                     
                        BEGIN TRAN                              
  --Update the document signatures                               
                        UPDATE  DocumentSignatures
                        SET     SignatureDate = GETDATE() ,
                                ModifiedDate = GETDATE() ,
                                ClientSignedPaper = @ClientSignedPaper ,
                                VerificationMode = @VerificationMode ,
                                SignerName = @FirstName + ' ' + @LastName
                                + CASE WHEN @SigningSuffix = '' THEN ''
                                       ELSE ', ' + @SigningSuffix
                                  END ,
                                RevisionNumber = @RevisionNumber ,
                                SignedDocumentVersionId = @DocumentVersionId
                        WHERE   documentid = @DocumentID
                                AND StaffID = @StaffID
                                AND ISNULL(RecordDeleted, 'N') = 'N' --and Version=@Version 
                                AND  SignedDocumentVersionId IS NULL 
                                AND SignatureDate IS NULL                               
                                --AND ( SignedDocumentVersionId IS NULL
                                --      OR ( SignedDocumentVersionId IS NOT NULL
                                --           AND EXISTS ( SELECT
                                --                              1
                                --                        FROM  dbo.DocumentSignatures
                                --                        WHERE DocumentId = @DocumentId
                                --                              AND SignatureDate IS NOT NULL )
                                --         )
                                --    )
    
                        IF @@error <> 0 
                            GOTO error                                                        
                        --UPDATE  Documents
                        --SET     SignedByAuthor = 'Y' ,
                        --        DocumentShared = 'Y' ,
                        --        Status = 22 ,
                        --        CurrentVersionStatus = 22 ,
                        --        CurrentDocumentVersionId = @DocumentVersionId
                        --WHERE   documentid = @DocumentID
                        --        AND ( AuthorID = @StaffID
                        --              OR ReviewerId = @StaffID 
                        --            )
                        --        AND ISNULL(RecordDeleted, 'N') = 'N'  
                        
                         Update  D
                            set SignedByAuthor = 'Y',
                                DocumentShared = 'Y',
                                Status = 22,
                                CurrentVersionStatus = 22,
                                CurrentDocumentVersionId = @DocumentVersionId
                        FROM    Documents d
                                join DocumentVersions dv on dv.DocumentId = d.DocumentId --Added By Prem 10-07-2018
                                 and dv.DocumentVersionId = @DocumentVersionId
                        WHERE   d.DocumentId = @DocumentID
                                and (d.AuthorId = @StaffID
                                     or d.ReviewerId = @StaffID
                                     or (@AllowVersionAuthorToSign = 'Y'
                                         and dv.AuthorId = @StaffID))            
                        IF @@error <> 0 
                            GOTO error                              
            --15 December 2016 Manjunath K
                        IF EXISTS ( SELECT  1
                                    FROM    Documents D
                                    Inner Join DocumentCodes DC on DC.DocumentCodeId= D.DocumentCodeId
                                    WHERE   D.AuthorId = @StaffID AND D.DocumentId = @DocumentID 
                                    AND (DC.ServiceNote = 'Y' OR DC.DocumentCodeId=1601) --16 May 2017 Manjunath K
                                    AND ISNULL(DC.RecordDeleted,'N')='N'
                                    AND DC.Active = 'Y'
                                            --AND ( DocumentCodeId = 5
                                            --      OR DocumentCodeId = 6
                                            --      OR DocumentCodeId = 101
                                            --    )
                                            AND ISNULL(D.RecordDeleted, 'N') = 'N' ) 
                            BEGIN                              
                                EXEC ssp_SCUpdateTimeline @DocumentVersionId                              
                                IF @@error <> 0 
                                    GOTO error                              
                            END                              
                                
   --If document code is 101 'Assessment ' then create a new diagnosis document                              
                        IF EXISTS ( SELECT  1
                                    FROM    Documents
                                    WHERE   AuthorID = @StaffID
                                            AND DocumentID = @DocumentID
                                            AND DocumentCodeId = 101
                                            AND ISNULL(RecordDeleted, 'N') = 'N' ) 
                            BEGIN                              
   -- Added by vikas  for taks no 1142 on ace  need Dx or not              
                                DECLARE @varNeedDx VARCHAR(2)              
                                SELECT  @varNeedDx = AutoCreateDiagnosisFromAssessment
                                FROM    SystemConfigurations               
                                IF ( @varNeedDx = 'Y' ) 
                                    BEGIN              
    --exec ssp_SCSignatureCreateDiagnosisDoc @StaffID,@DocumentID,@NewDocumentID out                              
                                        UPDATE  CustomAssessments
                                        SET     DiagnosisDocumentId = @NewDocumentID
                                        WHERE   DocumentVersionId = @DocumentVersionId             
                                        IF @@error <> 0 
                                            GOTO error                              
                            
                                        UPDATE  documentSignatures
                                        SET     SignatureDate = GETDATE() ,
                                                ModifiedDate = GETDATE() ,
                                                ClientSignedPaper = @ClientSignedPaper ,
                                                VerificationMode = @VerificationMode ,
                                                SignerName = @FirstName + ' '
                                                + @LastName
                                                + CASE WHEN @SigningSuffix = ''
                                                       THEN ''
                                                       ELSE ', '
                                                            + @SigningSuffix
                                                  END
                                        WHERE   documentid = @NewDocumentID
                                                AND StaffID = @StaffID
                                                AND ISNULL(RecordDeleted, 'N') = 'N' --and Version=@Version                              
                                        IF @@error <> 0 
                                            GOTO error                              
                                    END             
 --End of Added by vikas              
                            END                              
                        COMMIT TRAN                     
                    END            
                SELECT  'TRUE' ,
                        @NewDocumentID                              
            END                
        ELSE 
            SELECT  'FALSE' ,
                    @NewDocumentID                              
    END                   
    RETURN(0)                              
                          
    error:       
     if @@TRANCOUNT > 0 rollback transaction                       
    ROLLBACK TRAN                              
    RAISERROR('Error in ssp_SCSignatureSignedByStaff', 16, 1)              

GO


