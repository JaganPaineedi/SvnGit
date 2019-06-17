 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InsertCriticalAlertsProcess]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE ssp_InsertCriticalAlertsProcess
GO


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ssp_InsertCriticalAlertsProcess]
    @TableId VARCHAR(105)=NULL ,
    @ErrorDescription VARCHAR(MAX) ,
    @CreatedBy type_CurrentUser ,
    @ModifiedBy type_CurrentUser 
AS 
/* =============================================      
-- Author:  Pranay Bodhu  
-- Create date: 07/05/2018 
-- Description:   Inserts records into CriticalAlertsProcess table.
--Purpose- These records are picked up by sql job to show alerts.
      
 Author			Modified Date			Reason      
   
      

 ============================================= */
    BEGIN TRY
        BEGIN TRAN;
		
		INSERT INTO dbo.CriticalAlertsProcess
		        ( 
		          TableId ,
		          ErrorDescription ,
		          AlertType ,
		          CreatedBy ,
		          CreatedDate ,
		          ModifiedBy ,
		          Sent 
		        )
		VALUES  ( 
		          @TableId , -- TableId - varchar(105)
		          @ErrorDescription , -- ErrorDescription - varchar(max)
		          'Custom' , -- AlertType - varchar(max)
		          @CreatedBy , -- CreatedBy - type_CurrentUser
		          GETDATE() , -- CreatedDate - type_CurrentDatetime
		          @CreatedBy , -- ModifiedBy - type_CurrentUser
		          'N'  -- Sent - type_YOrN
		        )

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


