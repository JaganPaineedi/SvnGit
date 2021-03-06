IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_PMServicesDetailPostUpdate]')
                    AND type IN ( N'P', N'PC' ) ) 
    DROP PROCEDURE [dbo].[ssp_PMServicesDetailPostUpdate]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON	
GO
  
  
CREATE PROC [dbo].[ssp_PMServicesDetailPostUpdate]
    (
      @ScreenKeyId INT ,
      @StaffId INT ,
      @CurrentUser VARCHAR(30) ,
      @CustomParameters XML                                                     
    )
AS /******************************************************************************                                      
**  File:  ClinicianId                                      
**  Name: ssp_PMServicesDetailPostUpdate                                      
**  Desc:                                       
**                                      
**  This template can be customized:                                      
**                                                    
**  Return values:                                      
**                                       
**  Called by:                                         
**                                                    
**  Parameters:                                      
**  Input       Output                                      
**     ----------       -----------                                      
**                                      
**  Auth:                                       
**  Date:                                       
*******************************************************************************                                      
**  Change Histor6y                                      
*******************************************************************************                                      
**  Date:      Author:     Description:                                      
**  ---------  --------    -------------------------------------------                                      
**  19/08/2011  Priyanka     Created Procedure to After update functionality of Services page                              
** 29Feb2012 Shifali   Modified - Added Custom param for Delete of Service   
          Added logic to set Document Status based on service status  
**  20July2012  Rakesh Garg   Purpose If user first save service by Procedure Code Assciated NoteId exists , After that saves same service without AssociatedNoteId  
               --then in that case in Documents table RecordDeleted information  updated with record delete as in service not its working from application ** 09August2012 Sudhir Singh  Updated By Sudhir Singh as per task#1917 and as per discussion with Ja
ved               
**  10Aug2012   AmitSr At the time of insert in documentverions revisionnumber should also save as by default 1               
** 12Sept2012 Shifali Modified - Update GroupService Status/Services.NoteAuthorId = Services.ClinicianId when service saved is part of Group service  
**  18Sept2012 Shifali Modified - Added Check for DisableNoShowNotes/DisableCancelNotes when marking documents records as deleted base 72/73/76  
**  28Nov2012 Rahul Aneja      - Logic shift into  ssp "ssp_PMMarkServiceNoteAsNoShowCancel"  of Update related table (DOcuments,DocumentVersions,DocumentSignatures) when change status of service as NoShow/Cancel 72/73  
**  25Feb 2013  Rakesh Garg      - Changes made w.r.f task 2795 in Thresholds Bugs/Feature Check Service Status for Remove some validations on marking service as an error  
**  22March 2013  Maninder Singh - Changes made w.r.f task 2909 in Thresholds Bugs/Feature - Retreived @AssociatedNoteId based on GroupServiceId in-case Services.GroupServiceId is not null  
**  03-Jun 2013 Changes made by Javed to modify the logic of validation. System should perform the validation of different associated Note Id only if the associated note is not signed
**  19-Dec 2013 Aravind  Modified - #394 ,Venture Region 3.5 Implementation - To allow users to change the procedure code on a scheduled service from Service Details        
**  02-JUNE-2014 Akwinass Implemented Date Cast for Effective Date as per Task #1524 in Core Bugs Project.
**	JUN-27-2014		dharvey		Modified update blocks to include @ClinicianId for DocumentSignatures.StaffId.  
								This was leaving the previous ClinicianId value in place and resulted in failure 
								to store new Clinician's signature details.
** 23-Dec-2014		Ponnin		To Create a Behavioral Checklist To Do document on Save of Service Detail. Why : For task #304.1 of Key Point Customizations.
**	MAR-21-2015		dharvey		Removed Documents.Status <> 22 line when checking for changes to procedure code
								Why: this was creating a gap with services notes that were Signed but still on Show 
								where the procedure code could still be changed
** MAR-26-2015		praorane	Added logic to prevent creation of document when the service is marked as no show or cancel
								This was added because deleted no show cancel MD Notes were being recreated by the post update process
								Refer RWD task #1257 for more details
** Nov-25-2015		Venkatesh	Added logic to update DocumentShared column in the Documents table based on the value in the ShareDocumentOnSave of SystemConfigurations table
								Ref Task  - 4 - Valley Go Live Support for more info.
** 22-Feb-2016	    Akwinass	What:Included ssp_SCManageAttendanceToDoDocuments, To create To Do document for the Associated Attendance Group Service.          
**								Why:task #167 Valley - Support Go Live
** 13-APRIL-2016    Akwinass	What:Included GroupNoteType Column.          
							    Why:task #167.1 Valley - Support Go Live							
** 08-July-2016    Manjunath What:Commented Status column and CurrentVersionStatus Column in Document Update query.
							 Why :Document Status shouldn't change when we are Completing Service from Service Detail.
							 For : Valley - Support Go Live #312 
** 13-June-2017     Veena     What:Added condition to excude the error services while inserting into documents and documentversions
                              Why:It was making a duplicate recorddeleted entry while making record deleted. Core Bugs 857.1
** 23-June-2017     Hemant    What:Added error status to exclude the error services while inserting into documents and documentversions
                              Why:To prevent bad data entries.Thresholds - Support# 982   
** 30-June-2017     Pranay    What: Added Condition to Change the Staus of the Docuement to 26, RecordDeleted to NUll when the Service is Errored 76 -Support Harbor Task#857		
** 09-Oct-2017   Lakshmi       What: In progress document version updating status with the status of 22
							   Why:  Thresholds - Support #1049	
** 12-MAR-2018   Akwinass      What:Included ssp_SCServicesDetailReplacementForNote.
							   Why:Task #589.1 in Engineering Improvement Initiatives- NBL(I)
** 16/05/2018   Dasari Sunil    What : Added logic  for add on codes services to be error when the service is error on service error.
								Why : when a service is error out on move documents, then add on codes do not error out, they have to be individually error out. 	
								New Directions - Support Go Live#807.			                             
*******************************************************************************/                                    
    BEGIN                                   
                              
        BEGIN TRY         
  
  
  
            SET ARITHABORT ON         
            DECLARE @Action VARCHAR(50)          
            SELECT  @Action = @CustomParameters.value('Root[1]/Parameters[1]/@ServiceDetailAction', 'VARCHAR(50)')          
            DECLARE @ServiceId INT                    
            DECLARE @ClientId INT                     
            DECLARE @DateOfService DATETIME                  
            DECLARE @ProcedureCodeId INT                  
            DECLARE @AssociatedNoteId INT                   
            DECLARE @DocumentId AS INT                         
            DECLARE @DocumentVersionId INT              
            DECLARE @ClincianId INT                                 
            DECLARE @UserCode INT      
            DECLARE @DocId INT  
            DECLARE @ServiceStatus INT  
            DECLARE @DocumentStatusToSet INT    
            DECLARE @RecordDeleted VARCHAR(10)    
            DECLARE @DeletedDate DATETIME  
            DECLARE @DeletedBy VARCHAR(30)  
            DECLARE @GroupServiceId INT  
            DECLARE @GroupStatus INT  
  
            DECLARE @DisableNoShowNotes CHAR(1)                      
            DECLARE @DisableCancelNotes CHAR(1)                      
            SELECT  @DisableNoShowNotes = UPPER(ISNULL(DisableNoShowNotes, 'N')) ,
                    @DisableCancelNotes = UPPER(ISNULL(DisableCancelNotes, 'N'))
            FROM    SystemConfigurations     
            SELECT  @GroupServiceId = ISNULL(GroupServiceId, 0)
            FROM    Services
            WHERE   ServiceId = @ScreenKeyId  
  
------Added By Sudhir Singh as per task#1917 in Harbor Go Live isssues  
            DECLARE @ValidationErrors TABLE
                (
                  TableName VARCHAR(200) ,
                  ColumnName VARCHAR(200) ,
                  ErrorMessage VARCHAR(2000) ,
                  PageIndex INT ,
                  TabOrder INT ,
                  ValidationOrder INT
                )   
-----End  
                 
            IF ( @ScreenKeyId > 0 ) 
                BEGIN       
                    IF ( @Action = 'deleteservicedetail' ) 
                        BEGIN  
    
                            SELECT  @DocumentId = DocumentId ,
                                    @DocumentVersionId = InProgressDocumentVersionId
                            FROM    Documents
                            WHERE   ServiceId = @ScreenKeyId    
    
                            UPDATE  Documents
                            SET     RecordDeleted = 'Y' ,
                                    DeletedBy = @CurrentUser ,
                                    DeletedDate = GETDATE()
                            WHERE   DocumentId = @DocumentId                                                                            
    
                            UPDATE  DocumentVersions
                            SET     RecordDeleted = 'Y' ,
                                    DeletedBy = @CurrentUser ,
                                    DeletedDate = GETDATE()
                            WHERE   DocumentVersionId = @DocumentVersionId                                                                            
  
                            UPDATE  DocumentSignatures
                            SET     RecordDeleted = 'Y' ,
                                    DeletedBy = @CurrentUser ,
                                    DeletedDate = GETDATE()
                            WHERE   DocumentId = @DocumentId   
  
                        END  
                    ELSE 
                        BEGIN      
                            SELECT  @ServiceId = ServiceId ,
                                    @ProcedureCodeId = ProcedureCodeId ,
                                    @ClientId = ClientId , 
  /**02-JUNE-2014**Akwinass**Implemented Date Cast for Effective Date as per Task #1524 in Core Bugs Project. **/
  /** JUN-27-2014 dharvey Removed uneeded CASE statement as CAST on NULL will result in NULL **/
                                    @DateOfService = CAST(DateOfService AS DATE) ,
                                    @ClincianId = ClinicianId ,
                                    @ServiceStatus = Status
                            FROM    Services
                            WHERE   ServiceId = @ScreenKeyId                        
    
  --Added by Maninder - To get @AssociatedNoteId based on GroupServiceId  
                            IF ( ISNULL(@GroupServiceId, 0) <> 0 ) 
                                BEGIN  
                                    SELECT  @AssociatedNoteId = ServiceNoteCodeId
                                    FROM    GroupNoteDocumentCodes GNDC
                                            INNER JOIN Groups G ON G.GroupNoteDocumentCodeId = GNDC.GroupNoteDocumentCodeId AND ISNULL(G.GroupNoteType,0) = 9383 --13-APRIL-2016    Akwinass
                                            INNER JOIN GroupServices GS ON G.GroupId = GS.GroupId
                                    WHERE   GS.GroupServiceId = @GroupServiceId
                                            AND ISNULL(GS.RecordDeleted, 'N') <> 'Y'
                                            AND ISNULL(G.RecordDeleted, 'N') <> 'Y'
                                            AND ISNULL(GNDC.RecordDeleted, 'N') <> 'Y'   
                                END  
                            ELSE 
                                BEGIN   
                                    SELECT  @AssociatedNoteId = AssociatedNoteId
                                    FROM    ProcedureCodes
                                    WHERE   ProcedureCodeId = @ProcedureCodeId      
                                END  
  --Below If added by Rakesh Check If service Status is Error then ,we don't need validations for users as service is being marked as Error. w.rf to task 2795 in Thresholds Bugs/Features  
                            IF ( @ServiceStatus <> 76 ) 
                                BEGIN  
  ------Added By Sudhir Singh as per task#1917 in Harbor Go Live isssues  
                                    IF EXISTS ( SELECT  1
                                                FROM    documents d
                                                WHERE   d.serviceid = @ServiceId
                                                        AND d.status = 22
                                                        AND ISNULL(d.recorddeleted, 'N') = 'N'
                                                        AND AuthorId <> @ClincianId ) 
                                        BEGIN  
                                            DELETE  FROM @ValidationErrors  
                                            INSERT  INTO @ValidationErrors
                                                    ( TableName ,
                                                      ColumnName ,
                                                      ErrorMessage
                                                    )
                                                    SELECT  'Documents' ,
                                                            'Status' ,
                                                            'You can''t update clinician as document related to this service is already signed.'   
                                            GOTO error  
                                        END  
  
  -- JHB 6/3/2013 
  -- If the document is not signed yet and the procedure code being selected
  -- does not match the associated note it should raise an error
                                    IF ( @ServiceStatus = 71 ) -- Added for #394 - Venture Region 3.5 Implementation
                                        BEGIN    
                                            IF @AssociatedNoteId IS NOT NULL
                                                AND EXISTS ( SELECT 1
                                                             FROM   documents d
                                                             WHERE  d.serviceid = @ServiceId
																	/** dharvey - removed Riverwood-Support #562 **/
                                                                    --AND d.status <> 22
                                                                    AND DocumentCodeId <> @AssociatedNoteId
                                                                    AND ISNULL(d.recorddeleted, 'N') = 'N' ) 
                                                BEGIN  
                                                    DELETE  FROM @ValidationErrors  
                                                    INSERT  INTO @ValidationErrors
                                                            ( TableName ,
                                                              ColumnName ,
                                                              ErrorMessage
                                                            )
                                                            SELECT  'Documents' ,
                                                                    'Status' ,
                                                                    'You can not set a Procedure code which is Associated with a different Document type.'   
                                                    GOTO error  
                                                END  
                                        END    
                                END    
        ------End  
                             
                  
                            IF ( @AssociatedNoteId IS NOT NULL ) 
                                BEGIN           
  
  
                                    SET @DocumentStatusToSet = CASE WHEN @ServiceStatus = 70 THEN 20 /*Schedule --> InProgress */
                                                                    WHEN @ServiceStatus = 71 THEN 21 /*Show --> InProgress */
                                                                    WHEN @ServiceStatus = 72 THEN 21 /*No Show --> InProgress */
                                                                    WHEN @ServiceStatus = 73 THEN 21 /*Cancel --> InProgress */
                                                                    WHEN @ServiceStatus = 75 THEN 22 /*Complete --> InProgress */
                                                                    WHEN @ServiceStatus = 76 THEN 26 /*Error --> InProgress */
                                                               END  
                                     IF(@ServiceStatus  IN (70,71,75,76))
									      BEGIN
			               						SET @RecordDeleted=NULL
                                          END 
  
                                    SET @DeletedDate = CASE WHEN @RecordDeleted IS NULL  THEN NULL /*Schedule --> InProgress */
                                                            ELSE GETDATE()
                                                       END  
  
                                    SET @DeletedBy = CASE WHEN @RecordDeleted IS NULL   THEN NULL /*Schedule --> InProgress */
                                                          ELSE @CurrentUser
                                                     END  
  
                                    IF NOT EXISTS ( SELECT  1
                                                    FROM    Documents
                                                    WHERE   ServiceId = @ScreenKeyId
                                                     --Added condition and @ServiceStatus <> 76 by Veena on 06/13/2017 
                                                            AND (ISNULL(recorddeleted, 'N') <> 'Y' 
                                                            or @ServiceStatus in (72,73,76)) )  --Added error status  by Hemant on 06/23/2017
                                        BEGIN         
                                        --StartCode - Added code by Venkatesh 
											DECLARE @DocumentShared CHAR(1)
											SET @DocumentShared = NULL
											IF (SELECT  ShareDocumentOnSave FROM SystemConfigurations) = 'Y' 
											BEGIN
												SET @DocumentShared = 'Y'
											END
											ELSE IF (SELECT ShareDocumentOnSave FROM DocumentCodes WHERE DocumentCodeId=@AssociatedNoteId) = 'Y'
											BEGIN
												SET @DocumentShared = 'Y'
											END
											ELSE IF (SELECT AllowEditingByNonAuthors FROM DocumentCodes WHERE DocumentCodeId=@AssociatedNoteId) = 'Y'
											BEGIN
												SET @DocumentShared = 'Y'
											END
										--EndCode - Added code by Venkatesh
                                            INSERT  INTO Documents
                                                    ( CreatedBy ,
                                                      ModifiedBy ,
                                                      ServiceId ,
                                                      ClientId ,
                                                      DocumentCodeId ,
                                                      EffectiveDate ,
                                                      [Status] ,
                                                      AuthorId ,
                                                      CurrentVersionStatus ,
                                                      RecordDeleted ,
                                                      DeletedDate ,
                                                      DeletedBy ,
                                                      Documentshared -- By Venkatesh                  
                                                    )
                                            VALUES  ( @CurrentUser ,
                                                      @CurrentUser ,
                                                      @ServiceId ,
                                                      @ClientId ,
                                                      @AssociatedNoteId ,
                                                      @DateOfService ,                  
       --21  
                                                      @DocumentStatusToSet ,
                                                      @ClincianId ,     
       --21                
                                                      @DocumentStatusToSet ,
                                                      @RecordDeleted ,
                                                      @DeletedDate ,
                                                      @DeletedBy ,
                                                      @DocumentShared -- By Venkatesh
                                                    )         
  
                                            SELECT  @DocumentId = SCOPE_IDENTITY()
                                            FROM    Documents         
  
                                            INSERT  INTO DocumentVersions
                                                    ( CreatedBy ,
                                                      DocumentId ,
                                                      Version ,
                                                      AuthorId ,
                                                      EffectiveDate ,
                                                      ModifiedBy ,
                                                      RecordDeleted ,
                                                      DeletedDate ,
                                                      DeletedBy ,
                                                      RevisionNumber                 
                                                    )
                                            VALUES  ( @CurrentUser ,
                                                      @DocumentId ,
                                                      1 ,
                                                      @ClincianId ,
                                                      @DateOfService ,
                                                      @CurrentUser ,
                                                      @RecordDeleted ,
                                                      @DeletedDate ,
                                                      @DeletedBy ,
                                                      1                
                                                    )      
  
                                            SELECT  @DocumentVersionId = SCOPE_IDENTITY()
                                            FROM    DocumentVersions       
                 
      --  UPDATE Documents set CurrentDocumentVersionId=@DocumentVersionId where DocumentId=@DocumentId                   
                                            UPDATE  Documents
                                            SET     CurrentDocumentVersionId = @DocumentVersionId ,
                                                    InProgressDocumentVersionId = @DocumentVersionId
                                            WHERE   DocumentId = @DocumentId          
  
      -- insert record to DocumentSignatures    
                                            INSERT  INTO DocumentSignatures
                                                    ( --DocumentId,SignedDocumentVersionId,StaffId,SignatureOrder,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate  
                                                      DocumentId ,
                                                      StaffId ,
                                                      SignatureOrder ,
                                                      CreatedBy ,
                                                      CreatedDate ,
                                                      ModifiedBy ,
                                                      ModifiedDate ,
                                                      RecordDeleted ,
                                                      DeletedDate ,
                                                      DeletedBy   
                                                    )
                                            VALUES  ( --@DocumentId,@DocumentVersionId,@ClincianId,1,@CurrentUser,GETDATE(),@CurrentUser,GETDATE()  
                                                      @DocumentId ,
                                                      @ClincianId ,
                                                      1 ,
                                                      @CurrentUser ,
                                                      GETDATE() ,
                                                      @CurrentUser ,
                                                      GETDATE() ,
                                                      @RecordDeleted ,
                                                      @DeletedDate ,
                                                      @DeletedBy  
                                                    )                                
  
                                        END         
                                    ELSE 
                                        BEGIN        
  
       --Documents    
                                            DECLARE @Status INT  
                                            DECLARE @CurentVersionStatus INT  
                                            DECLARE @UpdateBothStatus CHAR(1)  
                                            SET @UpdateBothStatus = NULL  
         
                                            SELECT  @DocumentId = DocumentId
                                            FROM    Documents
                                            WHERE   ServiceId = @ServiceId  
         
                                            --PRINT '@DocumentId'  
                                            --PRINT @DocumentId  
                                            SELECT  @Status = Status ,
                                                    @CurentVersionStatus = CurrentVersionStatus
                                            FROM    Documents
                                            WHERE   DocumentId = @DocumentId     
         
                                            --PRINT '@Status'  
                                            --PRINT @Status  
                                            --PRINT '@CurentVersionStatus'  
                                            --PRINT @CurentVersionStatus  
         
                                            IF ( @Status <> 22
                                                 AND @Status <> 25
                                                 AND @CurentVersionStatus <> 22
                                                 AND @CurentVersionStatus <> 25
                                               ) 
                                                SET @UpdateBothStatus = 'Y'  
                                            IF ( @Status = 22
                                                 AND @CurentVersionStatus <> 22
                                                 AND @CurentVersionStatus <> 25
                                               ) 
                                                SET @UpdateBothStatus = 'N'  
         
         
                                            --PRINT @UpdateBothStatus  
                                            --PRINT @DocumentStatusToSet  
         
                                            IF ( @ServiceStatus <> 72
                                                 OR @ServiceStatus <> 73
                                               )--added By Rahul Aneja  
                                                BEGIN  
                                                    UPDATE  Documents
                                                    SET     ModifiedBy = @CurrentUser ,
                                                            ModifiedDate = GETDATE() ,
                                                            ServiceId = @ServiceId ,
                                                            ClientId = @ClientId ,
                                                            DocumentCodeId = CASE WHEN @GroupServiceId <= 0 THEN @AssociatedNoteId
                                                                                  ELSE DocumentCodeId
                                                                             END ,
                                                            EffectiveDate = @DateOfService ,                  
          --Status = 21,                  
--08-July-2016    Manjunath What:Commented Status column and CurrentVersionStatus                                                            
                                                            --Status = CASE WHEN @UpdateBothStatus = 'Y' THEN @DocumentStatusToSet
                                                            --              ELSE Status
                                                            --         END ,
	--06/30/2017 Pranay What: Status column and CurrentVersionStatus  Should be changed to 26 when the Serive is  76
															Status=CASE WHEN @ServiceStatus=76  THEN @DocumentStatusToSet ELSE Status END,
                                                            AuthorId = @ClincianId ,
                                                            --CurrentVersionStatus = CASE WHEN @UpdateBothStatus = 'Y' THEN @DocumentStatusToSet
                                                            --                            WHEN @UpdateBothStatus = 'N' THEN @DocumentStatusToSet
                                                            --                            ELSE CurrentVersionStatus
                                                            --                       END ,
															CurrentVersionStatus =CASE WHEN (@ServiceStatus=76) THEN @DocumentStatusToSet ELSE CurrentVersionStatus END,--Added by Lakshmi on 09/10/2017
                                                            RecordDeleted = @RecordDeleted ,
                                                            DeletedDate = @DeletedDate ,
                                                            DeletedBy = @DeletedBy
                                                    WHERE   DocumentId = @DocumentId                 
            
          --DocumentVersions  
                                                    UPDATE  DocumentVersions
                                                    SET     DocumentId = @DocumentId ,
                                                            AuthorId = @ClincianId ,
                                                            EffectiveDate = @DateOfService ,
                                                            ModifiedBy = @CurrentUser ,
                                                            ModifiedDate = GETDATE() ,
                                                            RecordDeleted = @RecordDeleted ,
                                                            DeletedDate = @DeletedDate ,
                                                            DeletedBy = @DeletedBy
                                                    WHERE   DocumentId = @DocumentId        
            
          --DocumentSignatures        
                                                    UPDATE  DocumentSignatures
                                                    SET     ModifiedDate = GETDATE() ,
                                                            ModifiedBy = @CurrentUser ,
                                                            RecordDeleted = @RecordDeleted ,
                                                            DeletedDate = @DeletedDate ,
                                                            DeletedBy = @DeletedBy ,
                                                            StaffId = @ClincianId
                                                    WHERE   DocumentId = @DocumentId 
															AND SignatureOrder = 1       
         
                                                END  
         
       -- if  exists(SELECT DocumentId from Documents where ServiceId =@ServiceId   and IsNull(recorddeleted,'N') <> 'Y')     
       -- begin    
       --  SELECT @DocId from Documents where ServiceId =@ServiceId   and IsNull(recorddeleted,'N') <> 'Y'    
       -- update Documents set recorddeleted='Y' where DocumentId=@DocId    
       -- update DocumentVersions set recorddeleted='Y' where DocumentId=@DocId    
       --   end        
                                        END    
            
                                END    
   --Below If condition added by Rakesh, If user first save service by Assciated NoteId , After that saves service without AssociatedNoteId  
   --then in that case records in table not update with record delete as in service not its working from application      
                            ELSE 
                                IF ( @AssociatedNoteId IS NULL ) 
                                    BEGIN  
                                        IF EXISTS ( SELECT  DocumentId
                                                    FROM    Documents
                                                    WHERE   ServiceId = @ServiceId
                                                            AND ISNULL(recorddeleted, 'N') <> 'Y' ) 
                                            BEGIN  
                                                BEGIN  
                                                    SELECT  @DocumentId = DocumentId ,
                                                            @DocumentVersionId = InProgressDocumentVersionId
                                                    FROM    Documents
                                                    WHERE   ServiceId = @ScreenKeyId  
                                                      
                                                    UPDATE  Documents
                                                    SET     RecordDeleted = 'Y' ,
                                                            DeletedBy = @CurrentUser ,
                                                            DeletedDate = GETDATE()
                                                    WHERE   DocumentId = @DocumentId                                                                            
                                                    UPDATE  DocumentVersions
                                                    SET     RecordDeleted = 'Y' ,
                                                            DeletedBy = @CurrentUser ,
                                                            DeletedDate = GETDATE()
                                                    WHERE   DocumentVersionId = @DocumentVersionId                                                                            
                                                    UPDATE  DocumentSignatures
                                                    SET     RecordDeleted = 'Y' ,
                                                            DeletedBy = @CurrentUser ,
                                                            DeletedDate = GETDATE()
                                                    WHERE   DocumentId = @DocumentId   
      
                                                END  
                                            END    
                                    END   
                                    
                            
                            --22-Feb-2016	Akwinass
							EXEC ssp_SCManageAttendanceToDoDocuments @ScreenKeyId,NULL,@CurrentUser,@ClientId							
                        END
     
                    IF ( ISNULL(@GroupServiceId, 0) > 0 ) 
                        BEGIN  
                            SET @GroupStatus = ( SELECT [dbo].[SCGetGroupServiceStatus](@GroupServiceId)
                                               )  
                            IF ( ISNULL(@GroupStatus, '') <> '' ) 
                                BEGIN     
                                    UPDATE  Groupservices
                                    SET     Status = @GroupStatus
                                    WHERE   GroupServiceId = @GroupServiceId    
                                END  
     
   /*Services.NoteAuthorId and Documents AuthorId credentials on save of service which is part of Group service*/  
                            UPDATE  Services
                            SET     NoteAuthorId = ClinicianId
                            WHERE   ServiceId = @ScreenKeyId
                                    AND NoteAuthorId <> ClinicianId     
     
                            UPDATE  Documents
                            SET     AuthorId = S.ClinicianId
                            FROM    Documents D
                                    JOIN Services S ON S.ServiceId = D.ServiceId
                            WHERE   S.ServiceId = @ScreenKeyId
                                    AND S.NoteAuthorId <> S.ClinicianId
                                    AND D.CurrentVersionStatus <> 22  
     
                            UPDATE  DocumentVersions
                            SET     AuthorId = D.AuthorId
                            FROM    DocumentVersions DV
                                    JOIN Documents D ON D.DocumentId = DV.DocumentId
                            WHERE   D.ServiceId = @ScreenKeyId
                                    AND D.CurrentVersionStatus <> 22  
     
                            UPDATE  DocumentSignatures
                            SET     StaffId = D.AuthorId
                            FROM    DocumentSignatures DS
                                    JOIN Documents D ON D.DocumentId = DS.DocumentId
                            WHERE   D.ServiceId = @ScreenKeyId
                                    AND DS.SignatureOrder = 1
                                    AND D.CurrentVersionStatus <> 22  
                        END  
   
   
                END    
                
                IF object_id('dbo.scsp_PMServicesDetailPostUpdate', 'P') is not null
				Begin
                EXEC scsp_PMServicesDetailPostUpdate @ServiceId
                END      
				
				IF object_id('dbo.ssp_SCServicesDetailReplacementForNote', 'P') IS NOT NULL
				BEGIN
					EXEC ssp_SCServicesDetailReplacementForNote @ServiceId,@StaffId,@CurrentUser
				END
				 -- 16/05/2018   Dasari Sunil  
               IF (@ServiceId > 0 and @ServiceStatus= 76)
				BEGIN
					update  S  
						 set S.[Status]=76 
								From services S
									 where exists(Select  serviceid From  ServiceAddOnCodes SA where SA.AddOnServiceId= S.serviceid
										 and SA.serviceid=@ServiceId  
										  AND ISNULL(SA.RecordDeleted, 'N') ='N') 
									 AND ISNULL(S.RecordDeleted, 'N') = 'N'
                END 
  -- 16/05/2018   Dasari Sunil  
  
------Added By Sudhir Singh as per task#1917 in Harbor Go Live isssues  
            error:  
            IF ( SELECT COUNT(*)
                 FROM   @ValidationErrors
               ) > 0 
                BEGIN  
                    SELECT  *
                    FROM    @ValidationErrors       
                END   
-----End   
          
        END TRY                                                                                                                                                                                                                                    
        BEGIN CATCH                                                      
            DECLARE @Error VARCHAR(8000)                                                                                                 
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMServicesDetailPostUpdate') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                   
            RAISERROR                                                                                                     
  (                                                                                                   
   @Error, -- Message text.                                                                                                                     
   16, -- Severity.                                                                                                                                
   1 -- State.                                                         
  );                                                                                                                              
        END CATCH                                
                                
    END    
  
GO


