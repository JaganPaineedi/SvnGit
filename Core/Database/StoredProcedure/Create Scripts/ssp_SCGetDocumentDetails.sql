IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCGetDocumentDetails')
                    AND type IN ( N'P', N'PC' ) )
				BEGIN 
				DROP PROCEDURE ssp_SCGetDocumentDetails 
				END
                    GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

create PROCEDURE [dbo].[ssp_SCGetDocumentDetails] (
	@DocumentId INT
	,@AuthorId INT
	,@VersionId INT
	,@DocumentCodeId INT
	,@ClientID INT
	,@BannerId INT
	,@DocumentNavigationId INT
	)
	/******************************************************************************
	**		File: Database\StoredProcedure\Create Scripts
	**		Name: ssp_SCGetDocumentDetails
	**		Desc: 
	**
	**		This template can be customized:
	**              
	**		Return values:
	** 
	**		Called by:   
	**              
	**		Parameters:
	**
	**		Auth: jcarlson
	**		Date: 2/9/2018
	*******************************************************************************
	**		Change History
	*******************************************************************************
	**		Date:		    Author:				    Description:
	**		--------		--------				-------------------------------------------
	**      22 Feb 2010		Vikas Monga				Created                                    
	**		05 May 2010		Sandeep Singh			Call sp from move document functionality                                                                                       
    **												Add a parameter @DocumentCodeId   
	**		30 March 2010	Sweety Kamboj			Modified for DocumentProxyTracking                                    
	**		1st July 2011	Damanpreet Kaur			Modified for ref: Task#177 Documents Acknowledgements and Comments
	**		26 Aug 2011		Shifali					Modified for ref: Task# 11 (To Be Reviewed Status,e.g. CurrentVersionStatus etc.)
	**		15 Sept 2011	Shifali					Modified for ref: Task# 11 (To Be Reviewed Status - Change ssp_SCGetSignedPersonList  to get signed list based on version(Added new param document versionid
	**		30 Nov 2011		Karan Garg				Added Check for Allow Editing in case of multiple authors (ref task #12 Threshold phase II) 
	**		24 Feb 2012		Maninder				Merged Code from PhaeII (by Ryan Noble) Modified to return ProxyId as the current LoggedInStaffID (@AuthorId) 
	**													if the currently logged in user is in the list of proxies for the author on the 
	**													document record.
	**		22June2012		Shifali					Modified stored proc to get Associated custom Table Rows count in Documents table @CustomTableRowCount 
	**		26 Dec 2012		Gautam					Used EXEC sp_executesql @proc_name parameter to call the procedure in place of Exec Procedure name to  
	**													Improve performance in multiuser environment.It may reuse the execution plan it generates for the first execution.
	**		05 Jul 2015		Gautam					What: Change the join to left join with Screens for documents do not have screenId
	**													Why: Woods - Core bugs #473		
	**		06/16/2016		jcarlson				added in logic to prevent editing a document based on document code configuration "DaysDocumentEditableAfterSignature"
	**		02/09/2018		jcarlson				Heartland SGL 24: Set the default value of PreventNewVersion based on document code configuration
	**      12/03/2018		Lakshmi  				Added a select coloumn 'DispalyAs' to Documentversions table, as per the task Woods - Support Go Live #748
	**      18-May-2018     Sachin                  What : Added new column AllowVersionAuthorToSign to fetch the column value AllowVersionAuthorToSign='Y' .
                                                    Why  : Bradford - Support Go Live #632
   10/9/2018   jcarlson		    Camino SGL 727 - Added new EditableAfterSignature field, set @PreventNewVersion default value based on this
	*******************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomTableRowCount INT
		DECLARE @PrimaryTableName VARCHAR(100)
		DECLARE @TablistList VARCHAR(1000)
		DECLARE @SQLString NVARCHAR(500)
		DECLARE @parmDef NVARCHAR(200)
		DECLARE @proc_name NVARCHAR(500);

		/*Get Next Previous information of document banner if  @DocumentNavigationId=0                                             
   Else get Next Previous information of document group                                       
 */
		IF (@DocumentNavigationId = 0)
		BEGIN
			SET @proc_name = 'exec ssp_SCDocumentGetPreviousNextDate @DocumentID,@ClientID,@DocumentCodeId,@AuthorId';

			EXEC sp_executesql @proc_name
				,N'@DocumentId INT,@ClientID INT,@DocumentCodeId INT,@AuthorId INT'
				,@DocumentID
				,@ClientID
				,@DocumentCodeId
				,@AuthorId
				--EXEC ssp_SCDocumentGetPreviousNextDate @DocumentID,@ClientID,@DocumentCodeId,@AuthorId                                              
		END
		ELSE
		BEGIN
			SET @proc_name = 'exec ssp_SCDocumentGetPreviousNextDocumentByDocumentNavigationId @DocumentNavigationId ,@ClientId, @DocumentId ,@BannerId,@AuthorId';

			EXEC sp_executesql @proc_name
				,N'@DocumentNavigationId INT,@ClientID INT,@DocumentId INT,@BannerId INT,@AuthorId INT'
				,@DocumentNavigationId
				,@ClientId
				,@DocumentId
				,@BannerId
				,@AuthorId
				--EXEC ssp_SCDocumentGetPreviousNextDocumentByDocumentNavigationId @DocumentNavigationId ,@ClientId, @DocumentId ,@BannerId,@AuthorId                                                   
		END

		SET @proc_name = 'exec ssp_SCGetDocumentNavigationByClientID @ClientID ,@Type,@AuthorId';

		EXEC sp_executesql @proc_name
			,N'@ClientID INT,@Type varchar(50),@AuthorId INT'
			,@ClientId
			,'DocumentNavigation'
			,@AuthorId

		--EXEC ssp_SCGetDocumentNavigationByClientID   @ClientID,'DocumentNavigation'  ,@AuthorId         
		SET @proc_name = 'exec ssp_ScGetMoveButtonStatus @DocumentCodeId,@DocumentID';

		EXEC sp_executesql @proc_name
			,N'@DocumentCodeId INT,@DocumentID INT'
			,@DocumentCodeId
			,@DocumentID

		--EXEC ssp_ScGetMoveButtonStatus @DocumentCodeId,@DocumentId                                            
		SELECT Active
		FROM Clients
		WHERE ClientId = @ClientID

		IF (@DocumentId > 0)
		BEGIN
			DECLARE @MaxVersion INT
			DECLARE @PreventNewVersion INT
			DECLARE @Status INT

			/*Get Document latest version*/
			SELECT @MaxVersion = Max([Version])
			FROM DocumentVersions
			WHERE documentid = @DocumentId
				AND ISNULL(RecordDeleted, 'N') <> 'Y'

			/*Get Document status*/
			SELECT @Status = [Status]
			FROM Documents
			WHERE Documentid = @DocumentId
				AND ISNULL(RecordDeleted, 'N') <> 'Y'

				

			 SELECT @PreventNewVersion = case when UPPER(ISNULL(dc.EditableAfterSignature,'Y')) = 'Y' then 1 --enable
												   else 0 --disable
												   end
			FROM  Documentcodes AS dc
			WHERE dc.DocumentCodeId = @DocumentCodeId

			--Set the default value of PreventNewVersion based on document code configuration
			--@AuthorId is the logged in user..
			SELECT @PreventNewVersion = CASE WHEN d.AuthorId <> @AuthorId --logged in use is not the author of the document, determine if the edit button is allowed based on document code settings
												THEN CASE 
														WHEN UPPER(ISNULL(dc.AllowEditingByNonAuthors,'N')) = 'Y' THEN 1 --1 means enable
														ELSE 0 --'N'
													END
											ELSE @PreventNewVersion
										END
			FROM Documents AS d
			JOIN Documentcodes AS dc ON d.DocumentCodeId = dc.DocumentCodeId
			WHERE dc.DocumentCodeId = @DocumentCodeId
			AND d.DocumentId = @DocumentId

			/* Get Status to EditView Button Status*/
			IF (
					@Status IN (
						20
						,21
						,22
						)
					)
			BEGIN
				EXEC scsp_SCDocumentPreventNewVersion @varDocumnetId = @DocumentId
					,@varAuthorId = @AuthorId
					,@varVersiondId = @VersionId
					,@varStatus = @PreventNewVersion OUTPUT
			END
			ELSE
			BEGIN
				SET @PreventNewVersion = @PreventNewVersion
			END

                           


			--/******* Changes done by Karan  #### Start ###        
			--/******* Purpose : Check for Allow Editing in case of multiple authors (ref task #12 Threshold phase II)          
			--/******* Dated : 30 Nov 2011          
			IF (
					(
						SELECT AllowEditingByNonAuthors
						FROM DocumentCodes
						WHERE DocumentCodeId = @DocumentCodeId
						) = 'Y'
					AND (@PreventNewVersion = 1)
					)
			BEGIN
				/**** Any User Can edit document*****/
				DECLARE @EnableEditValidationStoredProcedure VARCHAR(200)
				DECLARE @tablePreventNewVersion TABLE (PreventNewVersion INT)

				SET @EnableEditValidationStoredProcedure = (
						SELECT EnableEditValidationStoredProcedure
						FROM DocumentCodes
						WHERE DocumentCodeId = @DocumentCodeId
						)

				IF (@EnableEditValidationStoredProcedure IS NOT NULL)
				BEGIN
					SET @EnableEditValidationStoredProcedure = @EnableEditValidationStoredProcedure + ' ' + CONVERT(NVARCHAR(50), @DocumentId) + ', ' + CONVERT(NVARCHAR(50), @AuthorId) + ', ' + CONVERT(NVARCHAR(50), @VersionId)

					INSERT INTO @tablePreventNewVersion
					EXEC (@EnableEditValidationStoredProcedure)

					SET @PreventNewVersion = (
							SELECT TOP 1 PreventNewVersion
							FROM @tablePreventNewVersion
							)
				END
			END

			--/******* Changes done by Karan  #### End ###        
			/*Changes by Shifali Starts Here*/
			/*We need to get the Custom Table Record Count for Document's VersionId so that we can set a property at server/client side in .net application   
		 and perform operations required*/
			SELECT @TablistList = TableList
			FROM DocumentCodes
			WHERE DocumentCodeId = @DocumentCodeId

			SET @CustomTableRowCount = 0;
			SET @PrimaryTableName = ''

			IF (
					@TablistList <> ''
					OR @TablistList IS NOT NULL
					)
			BEGIN
				SET @PrimaryTableName = (
						SELECT TOP 1 *
						FROM dbo.[fnSplit](@TablistList, ',')
						)
					-- Execute Dyanminc SQL Statment & Get @CustomTableRowCount as output parameter to check row exists in primary table or not        
			END

			IF (@PrimaryTableName <> '')
			BEGIN
				SET @SQLString = N'SELECT @outputCount = Count(*)         
		FROM ' + @PrimaryTableName + ' where DocumentVersionId=' + CAST(@VersionId AS VARCHAR)
				SET @parmDef = N'@docVersionId int, @outputCount int Output';

				PRINT @SQLString

				EXECUTE sp_executesql @SQLString
					,@parmDef
					,@VersionId
					,@outputCount = @CustomTableRowCount OUTPUT;
			END

			/**********************************
			* Set Document Editable based on Document Code Configurations DaysDocumentEditableAfterSignature
			**********************************/
			IF NOT EXISTS ( SELECT *
					   FROM dbo.Documents AS d
					   JOIN dbo.DocumentCodes AS dc ON dc.DocumentCodeId = d.DocumentCodeId
					   WHERE DATEDIFF(DAY,d.EffectiveDate,GETDATE()) <= dc.DaysDocumentEditableAfterSignature
					   AND dc.DaysDocumentEditableAfterSignature IS NOT NULL
					   AND d.DocumentId = @DocumentId
					   )
					   AND EXISTS ( SELECT 1 FROM dbo.DocumentCodes AS dc
								WHERE dc.DocumentCodeId = @DocumentCodeId
								AND dc.DaysDocumentEditableAfterSignature IS NOT NULL
								)
					   BEGIN
                            
					   SET @PreventNewVersion = 0

					   END

			/**Changes by Shifali Ends here**/
			/*Get Document related information*/
			SELECT D.EffectiveDate
				,D.AuthorID
				,D.SignedByAuthor
				,D.ModifiedBy
				,D.ModifiedDate
				,D.RecordDeleted
				,isnull(SC.ScreenName, DC.DocumentName) AS DocumentName
				,RTRIM(SF.LastName) AS LastName
				,RTRIM(SF.FirstName) AS FirstName
				,CASE DC.RequiresSignature
					WHEN 'N'
						THEN CASE D.[Status]
								WHEN 22
									THEN 'Complete'
								ELSE GC.CodeName
								END
					ELSE GC.CodeName
					END AS [Status]
				,DocumentShared
				,D.CurrentDocumentVersionId
				,@MaxVersion AS MaxVersion
				,D.[Status] AS StatusID
				,CASE 
					WHEN (
							@AuthorId <> d.AuthorId
							AND d.AuthorId IN (
								SELECT ProxyForStaffId
								FROM StaffProxies
								WHERE StaffId = @AuthorId
									AND ISNULL(recorddeleted, 'N') = 'N'
								)
							)
						THEN @AuthorId
					ELSE d.ProxyId
					END AS ProxyId
				,@PreventNewVersion AS PreventNewVersion
				,CASE DC.RequiresSignature
					WHEN 'N'
						THEN CASE D.[CurrentVersionStatus]
								WHEN 22
									THEN 'Complete'
								ELSE GC1.CodeName
								END
					ELSE GC1.CodeName
					END AS [CurrentVersionStatus]
				,D.CurrentVersionStatus AS CurrentVersionStatusID
				,D.InProgressDocumentVersionId
				,@CustomTableRowCount AS CustomTableRowCount /*Added By Shifali on 22June2012*/
				,DC.AllowVersionAuthorToSign as AllowVersionAuthorToSign      -- Added by Sachin  
			FROM Documents D
			-- 06/20/2015	Gautam                                                                        
			LEFT JOIN Screens SC ON SC.DocumentCodeId = D.DocumentCodeId
			INNER JOIN Staff SF ON SF.StaffId = D.AuthorId
			INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = D.[Status]
			INNER JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = D.CurrentVersionStatus
			INNER JOIN DocumentCodes DC ON DC.DocumentCodeId = D.DocumentCodeId
			WHERE D.Documentid = @DocumentId
				AND isNull(D.RecordDeleted, 'N') <> 'Y'

			/*Get Document versions list*/    
   SELECT dv.DocumentId    
    ,dv.[Version]    
    ,dv.CreatedDate    
    ,DocumentVersionId    
    ,case when s.FirstName!='' and s.LastName!='' then s.FirstName+' '+s.LastName end as DisplayAs 
   FROM DocumentVersions dv    
   INNER JOIN Staff s on s.StaffId=dv.AuthorId
   WHERE dv.DocumentID = @DocumentID    
    AND ISNULL(dv.RecordDeleted, 'N') = 'N'  
    AND ISNULL(s.RecordDeleted, 'N') = 'N'

			/*Get Document Signer list*/
			--Exec ssp_SCWebSignatureSignersList @DocumentId,@VersionId  
			EXECUTE sp_executesql N'exec ssp_SCWebSignatureSignersList @varDocumentId=@ParameterValue'
				,N'@ParameterValue INT'
				,@ParameterValue = @DocumentId

			--Exec ssp_SCWebSignatureSignersList @DocumentId                      
			/*Get Document Signed PersonList */
			SET @proc_name = 'exec ssp_SCGetSignedPersonList @DocumentID,@VersionId';

			EXEC sp_executesql @proc_name
				,N'@DocumentId INT,@VersionId INT'
				,@DocumentID
				,@VersionId

			--Exec ssp_SCGetSignedPersonList @DocumentId,@VersionId                                                        
			/* Modified by Sweety Kamboj on 30April,2010*/
			--select COUNT(DocumentProxyTrackingId) as recordCount from DocumentProxyTrackings where DocumentId=@DocumentId                                                    
			--Exec ssp_SCGetDocumentProxyTrackingByDocumentId @DocumentId , @AuthorId          
			SET @proc_name = 'exec ssp_SCGetDocumentProxyTrackingByDocumentId @DocumentID,@AuthorId';

			EXEC sp_executesql @proc_name
				,N'@DocumentId INT,@AuthorId INT'
				,@DocumentID
				,@AuthorId

			/* Modified by Damanpreet Kaur to get all the DocumentAcknowledgementDetails based on @DocumentId and @VersionId  */
			--EXEC ssp_SCGetDocumentAcknowledgementDetails  @DocumentId  
			SET @proc_name = 'exec ssp_SCGetDocumentAcknowledgementDetails @DocumentID';

			EXEC sp_executesql @proc_name
				,N'@DocumentID INT'
				,@DocumentID
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetDocumentDetails') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                    
				16
				,-- Severity.                                                                    
				1 -- State.                                                                    
				);
	END CATCH
END

GO