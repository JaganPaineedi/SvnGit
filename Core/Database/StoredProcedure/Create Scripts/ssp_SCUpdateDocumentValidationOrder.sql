IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'ssp_SCUpdateDocumentValidationOrder') AND type IN (N'P', N'PC')
		)
BEGIN
	DROP PROCEDURE ssp_SCUpdateDocumentValidationOrder;
END;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE ssp_SCUpdateDocumentValidationOrder @DocumentValidationId INT, @Direction varchar(20)
AS
/******************************************************************************
**		File: ssp_SCGetDocumentValidation.sql
**		Name: ssp_SCGetDocumentValidation
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**	    11/25/2016      jcarlson			    created
*******************************************************************************/
BEGIN
	BEGIN TRY
	
	declare @CurrentOrder int;
	declare @NewOrder int;
	declare @DocumentCodeId int;

	select @CurrentOrder = dv.ValidationOrder,
	@DocumentCodeId = dv.DocumentCodeId
	from DocumentValidations as dv
	where isnull(dv.RecordDeleted,'N')='N'
	and dv.DocumentValidationId = @DocumentValidationId

	if(@Direction = 'down')
	begin
	set @NewOrder = @CurrentOrder - 1;
	end

	if(@Direction = 'up')
	begin
	set @NewOrder = @CurrentOrder + 1;
	end

	if(@NewOrder <= 0)
	begin
	   set @NewOrder = 1
	end


	declare @ExistingValidationId int;

	select @ExistingValidationId = dv.DocumentValidationId
	from DocumentValidations as dv
	where isnull(dv.RecordDeleted,'N')='N'
	and dv.DocumentCodeId = @DocumentCodeId
	and dv.ValidationOrder = @NewOrder;

	if(@ExistingValidationId is not null)
	begin
	    update DocumentValidations 
	    set ValidationOrder = @CurrentOrder
	    where DocumentValidationId = @ExistingValidationId
	end

	update DocumentValidations 
	set ValidationOrder = @NewOrder
	where DocumentValidationId = @DocumentValidationId

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCUpdateDocumentValidationOrder') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
				@Error,
				-- Message text.                                                                     
				16,
				-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH;
END;
GO

