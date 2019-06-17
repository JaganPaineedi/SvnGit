IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_SureScriptsApprovedChangeRequest]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE ssp_SureScriptsApprovedChangeRequest;
GO

SET QUOTED_IDENTIFIER OFF;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE ssp_SureScriptsApprovedChangeRequest
AS

/*********************************************************************/        
---Copyright: 2011 Streamline Healthcare Solutions, LLC

---Creation Date: 09/22/2017

--Author : Pranay

---Purpose:To get the change response

---Return:Change List Medication Order

---Called by:Windows Service
---Log:
--	Date                     Author                             Purpose
/*********************************************************************/  


BEGIN TRY
  DECLARE @STATUSPENDING INT 
    SET @STATUSPENDING = 5562

	    BEGIN TRAN
            DECLARE @results TABLE
            (
              NOTE VARCHAR(210) ,                     -- NOTE ADDED FOR THIS MEDICATION
              PON VARCHAR(50) ,                       -- Prescriber order number
              RESPONSE_XML type_Comment2 ,            -- The xml of the original refill request
              WRITTEN_DATE VARCHAR(10)                -- Date the approval was made
			)
IF EXISTS(SELECT SureScriptsChangeApprovalId from SureScriptsChangeApprovals
                             WHERE ApprovedMessageId is null )
BEGIN

		INSERT INTO @results
			        ( NOTE ,
			          PON ,
			          RESPONSE_XML ,
			          WRITTEN_DATE
			        )
		
		SELECT 'Prior Auth received'
		       ,ssca.PON
			  ,CAST(ssom.MessageText AS VARCHAR(max))
			  , dbo.ssf_SureScriptsFormatDate(GETDATE())
		FROM SureScriptsChangeApprovals ssca join dbo.SureScriptsOutgoingMessages as ssom on ssom.SureScriptsOutgoingMessageId = ssca.SurescriptsOutgoingMessageId
	    WHERE ssca.ApprovedMessageId is null
		AND ISNULL(ssca.RecordDeleted,'N')='N'


     SELECT  * FROM    @results
 END 
COMMIT TRAN 
    END TRY
    BEGIN CATCH

        IF @@trancount > 0 
            ROLLBACK TRAN

        DECLARE @errMessage NVARCHAR(4000)
        SET @errMessage = ERROR_MESSAGE()

        RAISERROR(@errMessage, 16, 1)
    END CATCH

GO