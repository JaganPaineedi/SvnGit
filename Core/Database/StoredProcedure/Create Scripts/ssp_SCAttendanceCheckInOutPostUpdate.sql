 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCAttendanceCheckInOutPostUpdate')
	BEGIN
		DROP  Procedure  ssp_SCAttendanceCheckInOutPostUpdate
	END

GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
           
CREATE proc [dbo].[ssp_SCAttendanceCheckInOutPostUpdate]    
(                  
  @ScreenKeyId int,                                                  
  @StaffId int,                                                  
  @CurrentUser varchar(30),                  
  @CustomParameters xml                                   
)                  
as              
/****************************************************************************/
/* Stored Procedure: ssp_SCAttendanceCheckInOutPostUpdate                   */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Akwinass                                                          */
/* Creation Date:  April 29,2015                                            */
/* Purpose: To Update Document Status                                       */
/* Input Parameters:@ScreenKeyId,@StaffId,@CurrentUser,@CustomParameters    */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*       Date           Author           Purpose                            */
/*       23-NOV-2015  Akwinass		 Created(Task #829.06 in Core Bugs).*/
/*       22-Feb-2016  Akwinass	     What:Included ssp_SCManageAttendanceToDoDocuments, To create To Do document for the Associated Attendance Group Service.          
							         Why:task #167 Valley - Support Go Live*/
/*     13-APRIL-2016  Akwinass		 What: Included GroupNoteType column check.          
								     Why:task #167.1 Valley - Support Go Live*/
/*     4/19/2016      Hemant         What: Included Updated statement for GroupServices table
                                     Why:Thresholds - Support #475*/
/*       24-AUG-2016  Akwinass	     What:Removed RecordDeleted condition          
							         Why:task #88 Woods - Environment Issues Tracking*/
/****************************************************************************/
begin                 
            
begin try             
		--Following option is reqd for xml operations                                
		SET ARITHABORT ON
		
		DECLARE @GroupServiceId INT      
		DECLARE @SpecificLocation VARCHAR(MAX)
		DECLARE @PlaceOfServiceId INT
		DECLARE @ClientId INT  
		DECLARE @MinDateOfService datetime,  
        @MaxEndDateOfService datetime,
        @MinDateTimeIn datetime,
        @MaxDateTimeOut datetime  
		
		SELECT TOP 1 @GroupServiceId = GroupServiceId,@ClientId = ClientId FROM Services WHERE ServiceId = @ScreenKeyId --24-AUG-2016 Akwinass AND ISNULL(RecordDeleted, 'N') = 'N'

		UPDATE Documents
		SET AuthorId = S.ClinicianId
		FROM Services S
		INNER JOIN Documents D ON S.ServiceId = D.ServiceId
		WHERE S.GroupServiceId = @GroupServiceId AND S.ClientId= @ClientId
			AND D.[Status] <> 22
			AND S.[Status] IN(70,71)
			AND ISNULL(S.RecordDeleted, 'n') = 'n'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'

		UPDATE DocumentVersions
		SET AuthorId = S.ClinicianId
		FROM DocumentVersions DV
		INNER JOIN Documents D ON D.InProgressDocumentVersionId = DV.DocumentVersionId
		INNER JOIN services AS s ON d.ServiceId = s.ServiceId
		WHERE s.GroupServiceId = @GroupServiceId AND S.ClientId= @ClientId
			AND D.[Status] <> 22
			AND S.[Status] IN(70,71)
			AND ISNULL(DV.RecordDeleted, 'n') = 'n'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'

		UPDATE DocumentSignatures
		SET StaffId = S.ClinicianId
		FROM DocumentSignatures DS
		INNER JOIN Documents D ON D.DocumentId = DS.DocumentId
		INNER JOIN services AS s ON d.ServiceId = s.ServiceId
		WHERE s.GroupServiceId = @GroupServiceId AND S.ClientId= @ClientId
			AND D.[Status] <> 22
			AND S.[Status] IN(70,71)
			AND ISNULL(DS.RecordDeleted, 'n') = 'n'
			AND DS.SignatureDate IS NULL
			AND DS.SignatureOrder = 1

		UPDATE Documents
		SET [Status] = CASE S.[Status] WHEN 70 	THEN 20 WHEN 71 THEN 21  WHEN 72 THEN 21 WHEN 73 THEN 21 WHEN 76 THEN 21 WHEN 75 THEN 22 END
		,[CurrentVersionStatus] = CASE S.[Status] WHEN 70 	THEN 20 WHEN 71 THEN 21  WHEN 72 THEN 21 WHEN 73 THEN 21 WHEN 76 THEN 21 WHEN 75 THEN 22 END
		FROM Services S
		INNER JOIN Documents D ON S.ServiceId = D.ServiceId
		WHERE S.GroupServiceId = @GroupServiceId AND S.ClientId= @ClientId
			AND D.[Status] <> 22 -- this condition is added BY Rakesh-II, as signed status were changing to in progress after some scenario (Added afer discuss with Devender Pal)             
			AND S.[Status] IN(70,71)
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND EXISTS(SELECT GS.GroupServiceId FROM GroupServices GS JOIN Groups G ON GS.GroupId = G.GroupId WHERE GS.GroupServiceId = S.GroupServiceId AND ISNULL(GS.RecordDeleted, 'N') = 'N' AND G.GroupNoteDocumentCodeId IS NOT NULL AND ISNULL(G.GroupNoteType,0) = 9383)
		
		Select @MinDateOfService = MIN(DateOfService),
        @MaxEndDateOfService=MAX(EndDateOfService),
        @MinDateTimeIn = MIN(DateTimeIn),
        @MaxDateTimeOut=MAX(DateTimeOut) 
        from [Services] where GroupServiceId= @GroupServiceId
  --4/19/2016      Hemant
		Update GroupServices set DateOfService =Isnull(@MinDateOfService,''),
		EndDateOfService=Isnull(@MaxEndDateOfService,''),
		DateTimeIn=Isnull(@MinDateTimeIn,''),
		DateTimeOut=Isnull(@MaxDateTimeOut,'')
		where GroupServiceId= @GroupServiceId
		
		--23-AUG-2016    Akwinass
		UPDATE D
		SET D.RecordDeleted = 'Y'
			,D.DeletedBy = @CurrentUser
			,D.DeletedDate = GETDATE()
		FROM Documents D
		JOIN Services S ON D.ServiceId = S.ServiceId
		WHERE S.GroupServiceId = @GroupServiceId
			AND S.ClientId = @ClientId
			AND ISNULL(S.RecordDeleted, 'N') = 'Y'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			
		UPDATE ACIOD
		SET ACIOD.RecordDeleted = 'Y'
			,ACIOD.DeletedBy = @CurrentUser
			,ACIOD.DeletedDate = GETDATE()
		FROM AttendanceCheckInOutDetails ACIOD
		JOIN Services S ON ACIOD.ServiceId = S.ServiceId
		WHERE S.GroupServiceId = @GroupServiceId
			AND S.ClientId = @ClientId
			AND ISNULL(S.RecordDeleted, 'N') = 'Y'
			AND ISNULL(ACIOD.RecordDeleted, 'N') = 'N'
			
		UPDATE SD
		SET SD.RecordDeleted = 'Y'
			,SD.DeletedBy = @CurrentUser
			,SD.DeletedDate = GETDATE()
		FROM ServiceDiagnosis SD
		JOIN Services S ON SD.ServiceId = S.ServiceId
		WHERE S.GroupServiceId = @GroupServiceId
			AND S.ClientId = @ClientId
			AND ISNULL(S.RecordDeleted, 'N') = 'Y'
			AND ISNULL(SD.RecordDeleted, 'N') = 'N'
  	
		--22-Feb-2016    Akwinass
		EXEC ssp_SCManageAttendanceToDoDocuments @ScreenKeyId,NULL,@CurrentUser,@ClientId		
  end try                                                                                
                                                                                                                         
BEGIN CATCH                                    
DECLARE @Error varchar(8000)                                                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                             
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                            
'ssp_SCAttendanceCheckInOutPostUpdate')                                                                                                               
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                
    + '*****' + Convert(varchar,ERROR_STATE())                                                            
 RAISERROR                                                                                   
 (                                                                                 
  @Error, -- Message text.                                                                                                   
  16, -- Severity.                                                                                                              
  1 -- State.                                       
 );                                                                                                            
END CATCH              
              
end