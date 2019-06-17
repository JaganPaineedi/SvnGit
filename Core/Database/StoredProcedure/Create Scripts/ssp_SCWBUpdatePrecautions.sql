IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCWBUpdatePrecautions')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCWBUpdatePrecautions;
    END;
GO

CREATE PROCEDURE ssp_SCWBUpdatePrecautions
   @XML XML
  , @CurrentUser VARCHAR(30)
AS /******************************************************************************
**		File: 
**		Name: ssp_SCWBUpdatePrecautions
**		Desc: 
**
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 6/20/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      6/20/2017          jcarlson             created
*******************************************************************************/
    BEGIN TRY
        BEGIN TRAN;
		--Check to make sure the parent whiteboard record exists, if not create it


			
				--Split the string of global code ids
        CREATE TABLE #Flags ( PrecautionId INT,Checked BIT,PrecautionText VARCHAR(MAX),WhiteBoardInfoId INT,ClientInpatientVisitId INT );
        INSERT  INTO #Flags ( PrecautionId, Checked, PrecautionText, WhiteBoardInfoId, ClientInpatientVisitId )
        SELECT x.value('(PrecautionId)[1]','int'),
		x.value('(Checked)[1]','bit'),
		x.value('(PrecautionComment)[1]','varchar(max)'),
		x.value('(WhiteBoardInfoId)[1]','int'),
		x.value('(ClientInpatientVisitId)[1]','int')
		FROM @XML.nodes('root/Row') AS XTbl(x)

		DECLARE @WhiteBoardInfoId INT = 0;
		DECLARE @ClientinpatientVisitId INT 
		SELECT @WhiteBoardInfoId = a.WhiteBoardInfoId,
		@ClientinpatientVisitId = a.ClientInpatientVisitId
		FROM #Flags AS a

		DECLARE @ClientId INT 
		SELECT @ClientId = a.ClientId
		FROM dbo.ClientInpatientVisits AS a
		WHERE a.ClientInpatientVisitId = @ClientinpatientVisitId
		AND ISNULL(a.RecordDeleted,'N')='N'
        IF ISNULL(@WhiteBoardInfoId,0) = 0
            BEGIN
                INSERT  INTO dbo.WhiteBoard ( ClientId, ClientInpatientVisitId,CreatedBy,ModifiedBy )
                SELECT  @ClientId, @ClientinpatientVisitId,@CurrentUser,@CurrentUser

        SELECT  @WhiteBoardInfoId = SCOPE_IDENTITY();
			END;
		--record delete any flag ids that are not in the #flags table
        UPDATE  a
        SET     a.RecordDeleted = 'Y', a.DeletedBy = @CurrentUser, a.DeletedDate = GETDATE()
        FROM    dbo.WhiteBoardPrecautions AS a
        JOIN #Flags AS b ON a.PrecautionId = b.PrecautionId
		AND b.Checked = 0;

	    --insert any newly selected flags
        INSERT  INTO dbo.WhiteBoardPrecautions ( WhiteBoardInfoId, PrecautionId,PrecautionComment,CreatedBy,ModifiedBy )
        SELECT  @WhiteBoardInfoId, a.PrecautionId,a.PrecautionText,@CurrentUser,@CurrentUser
        FROM    #Flags AS a
        WHERE   NOT EXISTS ( SELECT 1
                             FROM   dbo.WhiteBoardPrecautions AS b
                             WHERE  b.WhiteBoardInfoId = @WhiteBoardInfoId
                                    AND b.PrecautionId = a.PrecautionId
                                    AND ISNULL(b.RecordDeleted, 'N') = 'N' )
		AND a.Checked = 1;

		--update the text of any precautions that already exist
		UPDATE a 
		SET a.PrecautionComment = b.PrecautionText,
		a.ModifiedBy = @CurrentUser,
		a.ModifiedDate = GETDATE()
		FROM dbo.WhiteBoardPrecautions AS a
		JOIN #Flags AS b ON b.PrecautionId = a.PrecautionId
		AND b.WhiteBoardInfoId = a.WhiteBoardInfoId
		AND ISNULL(a.RecordDeleted,'N')='N'
		AND b.Checked = 1;

			

        COMMIT TRAN; 
    END TRY
    BEGIN CATCH
        IF @@Trancount > 0
            BEGIN
                ROLLBACK TRAN;
            END;
    
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWBUpdatePrecautions') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR (	@Error,		16,	1 	);

    END CATCH;