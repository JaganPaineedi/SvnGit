
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_InsertOutgoingFaxes]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_InsertOutgoingFaxes];
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[ssp_InsertOutgoingFaxes]
    @ImageRecordId INT ,
    @FaxTo VARCHAR(100) ,
    @FaxNumber type_PhoneNumber ,
    @Subject VARCHAR(250) ,
    @FromStaffId INT ,
    @CoverLetterNote type_Comment2 ,
    @CoverLetterId INT ,
    @Status type_GlobalCode ,
    @CreatedBy type_CurrentUser ,
    @ClientDisclosureId INT,
    @ModifiedBy type_CurrentUser 
AS 
/* =============================================      
-- Author:  Pranay Bodhu  
-- Create date: 05/12/2018 
-- Description:   Inserts records into outgoing faxes once the send fax button is clicked.
      
 Author			Modified Date			Reason      
   
      

 ============================================= */
    BEGIN TRY
        BEGIN TRAN;
		
        INSERT  INTO OutgoingFaxes
                ( ImageRecordId ,
                  FaxTo ,
                  FaxNumber ,
                  Subject ,
                  FromStaffId ,
                  CoverLetterNote ,
                  Status ,
                  CoverLetterId ,
                  CreatedBy ,
                  ModifiedBy ,
                  SentDateTime ,
                  ClientDisclosureId
                )
        VALUES  ( @ImageRecordId ,
                  @FaxTo ,
                  @FaxNumber ,
                  @Subject ,
                  @FromStaffId ,
                  @CoverLetterNote ,
                  @Status ,
                  @CoverLetterId ,
                  @CreatedBy ,
                  @ModifiedBy ,
                  GETDATE() ,
                  @ClientDisclosureId
                );	

        COMMIT TRAN;

    END TRY
    BEGIN CATCH

        IF @@trancount > 0
            ROLLBACK TRAN;

        DECLARE @errMessage NVARCHAR(4000);
        SET @errMessage = ERROR_MESSAGE();

        RAISERROR(@errMessage, 16, 1);
    END CATCH;
GO

