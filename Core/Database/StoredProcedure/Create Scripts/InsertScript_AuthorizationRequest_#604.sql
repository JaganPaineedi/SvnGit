/************************************************************************************************/
/*	PurPose		:		InsertScript for DocumentCodes,Screens,EventTypes                       */
/*	Author		:		Arjun															        */
/*	Date		:		26  2015																*/
-------------------------------------------------------------------------------------------------
/*
Update History.
----------------------------------------
Modified Date	Author			Purpose
----------------------------------------
18.Apr.2016		Rohith uppin	Modified Insert scripts logic to insert only when an environment do not have Custom Authorization Request event.
									Task#929 SWMBH Support.
*/
/************************************************************************************************/
DECLARE @TabId INT
DECLARE @screenId INT
DECLARE @DocumentCodeId INT
DECLARE @EventTypeId INT

SET @DocumentCodeId = 1637
SET @TabId = 2
SET @screenId = 1184
SET @EventTypeId=2001
/********************************* DocumentCodes TABLE *****************************************/

IF NOT EXISTS (SELECT * FROM DocumentCodes WHERE DocumentCodeId = @DocumentCodeId) 
	BEGIN SET IDENTITY_INSERT dbo.documentcodes ON 
		INSERT INTO DocumentCodes 
				(DocumentCodeId				
				,DocumentName
				,DocumentDescription
				,DocumentType
				,Active				
				,OnlyAvailableOnline				
				,ViewDocumentURL 
				,ViewDocumentRDL 
				,StoredProcedure 
				,TableList 
				,RequiresSignature 								 
				,ViewStoredProcedure 				
				) 
		VALUES(@DocumentCodeId
				,'Authorization Request'
				,'Authorization Request'
				,10
				,'Y'
				,'Y'
				,'RDLAuthorizationRequest'
				,'RDLAuthorizationRequest'
				,'ssp_GetDataForAuthorizationRequest'
				,'DocumentAuthorizationRequests,AuthorizationRequests,BillingCodes'
				,'Y'
				,'ssp_RDLCustomAuthorizationRequest')
					
	SET IDENTITY_INSERT dbo.documentcodes OFF END
	

/********************************* DocumentCodes TABLE *****************************************/

/********************************* SCREENS TABLE *****************************************/
IF NOT EXISTS (SELECT * FROM screens WHERE ScreenId = @screenId) 
	BEGIN SET IDENTITY_INSERT dbo.Screens ON 
		INSERT INTO Screens 
				(SCREENID 
				 ,SCREENNAME 
				 ,SCREENTYPE 
				 ,SCREENURL 
				 ,SCREENTOOLBARURL 
				 ,TabId 
				 ,INITIALIZATIONSTOREDPROCEDURE 
				,VALIDATIONSTOREDPROCEDURECOMPLETE
				 ,POSTUPDATESTOREDPROCEDURE
				 ,DOCUMENTCODEID) 
		VALUES	(@screenId 
				,'Authorization Request' 
				,5763 
				,'/Modules/CareManagement/ActivityPages/Client/Events/Authorization Request/AuthorizationTabs.ascx' 
				,'' 
				,@TabId 
				,'ssp_InitAuthorizationRequest'
				,NULL
				,'ssp_PostUpdateAuthorizationRequest' 
				,@DocumentCodeId) 
	SET IDENTITY_INSERT dbo.Screens OFF  END

/********************************* SCREENS TABLE END **************************************/

/********************************* EVENTTYPES TABLE *****************************************/

	-- To update Authoirzation request entry back to Custom event.
	IF EXISTS(SELECT 1 FROM EventTypes WHERE EventTypeId = 107 and AssociatedDocumentCodeId = 1637 and ISNULL(RecordDeleted,'N') <> 'Y')
	BEGIN
		IF EXISTS(SELECT 1 FROM DocumentCodes WHERE  DocumentCodeId = 1044 and ISNULL(RecordDeleted,'N') <> 'Y')
		  BEGIN
			UPDATE EventTypes SET AssociatedDocumentCodeId = 1044 WHERE EventTypeId = 107
		  END
		ELSE
		  BEGIN
			UPDATE EventTypes SET RecordDeleted = 'Y', AssociatedDocumentCodeId = NULL WHERE EventTypeId = 107
		  END
	END

IF NOT EXISTS (SELECT 1 FROM EventTypes WHERE AssociatedDocumentCodeId = 1044) 
		BEGIN 
			IF NOT EXISTS(SELECT * FROM EventTypes WHERE AssociatedDocumentCodeId = @DocumentCodeId)
				BEGIN
					SET IDENTITY_INSERT dbo.EventTypes ON
						INSERT INTO EventTypes 
							(EventTypeId
							,EventName
							,EventType
							,DisplayNextEventGroup
							,AssociatedDocumentCodeId
							,SummaryReportRDL
							,SummaryStoredProcedure)
						VALUES ( @EventTypeId
							,'Authorization Request'
							,5772
							,'N'
							,@DocumentCodeId
							,NULL
							,NULL )
					SET IDENTITY_INSERT dbo.EventTypes OFF
				END
			ELSE IF EXISTS(SELECT * FROM EventTypes WHERE EventTypeId = @EventTypeId)
				BEGIN
				  UPDATE EventTypes SET
						  EventName='Authorization Request',
						  EventType=5772,
						  DisplayNextEventGroup='N',
						  AssociatedDocumentCodeId=@DocumentCodeId
				  WHERE EventTypeId = @EventTypeId
				END
		END
/********************************* EVENTTYPES TABLE *****************************************/
	