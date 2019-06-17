/****** Object:  StoredProcedure [dbo].[ssp_CMInsertCheckDetails]    Script Date: 04/28/2014 12:35:11 ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMInsertCheckDetails]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_CMInsertCheckDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMInsertCheckDetails]    Script Date: 04/28/2014 12:35:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CMInsertCheckDetails] (@CheckDate datetime,
@CheckNumber int,
@Amount decimal,
@ProviderRefundId int,
@InsurerId int,
@ProviderId int,
@LoggedinUser int)
AS
BEGIN TRY
  BEGIN TRAN
  declare @ReleaseToProvider varchar(100)
  select Top 1 @ReleaseToProvider= Value from SystemConfigurationkeys WHERE [Key]='DefaultReleaseCheckToProvider'
  
    UPDATE ProviderRefunds
    SET ReturnedCheckId = @CheckNumber
    WHERE ProviderRefundId = @ProviderRefundId
    INSERT INTO Checks (CreatedBy,
    CreatedDate,
    ModifiedBy,
    ModifiedDate,
    RecordDeleted,
    InsurerId,
    InsurerBankAccountId,
    ProviderId,
    CheckNumber,
    CheckDate,
    Amount,
    ReleaseToProvider)
      VALUES (@LoggedinUser, GETDATE(), @LoggedinUser, GETDATE(), 'N', @InsurerId, 2, @ProviderId, @CheckNumber, @CheckDate, @Amount, @ReleaseToProvider)
  COMMIT TRAN
END TRY

BEGIN CATCH
  ROLLBACK TRAN
END CATCH
GO