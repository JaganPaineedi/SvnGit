/****** Object:  StoredProcedure [dbo].[ProcedureCodeRatesUpd]    Script Date: 11/18/2011 16:25:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProcedureCodeRatesUpd]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ProcedureCodeRatesUpd]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[ProcedureCodeRatesUpd]
	--Fields in ProcedureCodes
		@ProcedureCodeId INT = NULL OUT, 
		@ProcedureCode VARCHAR(75),						--03/01/2017      vsinha
		@ProcedureDescription VARCHAR(250),
		@Active CHAR(1),
		@AllowDecimals CHAR(1), 
		@EnteredAs INT, 
		@NotBillable CHAR(1), 
		@DoesNotRequireStaffForService CHAR(1),
		@NotOnCalendar CHAR(1), 
		@FaceToFace CHAR(1), 
		@GroupCode CHAR(1),
		@EndDateEqualsStartDate CHAR(1), 
		@RequiresSignedNote CHAR(1), 
		@AssociatedNoteId INT,
		@MinUnits FLOAT, 
		@MaxUnits FLOAT, 
		@UnitIncrements FLOAT, 
		@UnitsList VARCHAR(200), 
		@ExternalCode1 VARCHAR(25), 
		@ExternalSource1 INT, 
		@ExternalCode2 VARCHAR(25), 
		@ExternalSource2 INT, 
		@CreditPercentage INT, 
		@Category1 INT, 
		@Category2 INT,
		@Category3 INT, 
		--@ExternalReferenceId VARCHAR(30), 
		@Modifier VARCHAR(30)

	
AS

/******************************************************************************
**		File: 
**		Name: Stored_Procedure_Name
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
**		Date:		Modified:				Description:
**   --------		--------				-------------------------------------------
**  03/01/2017      vsinha					What:  Length of "Display As" to handle procedure code display as increasing to 75     
											Why :  Keystone Customizations 69  
*******************************************************************************/
BEGIN
DECLARE @DisplayNameCount INT

BEGIN TRY
BEGIN TRAN ProcedureCodes

SET @DisplayNameCount = 
		( SELECT     
			count(ProcedureCodeId)
		  FROM ProcedureCodes
		  WHERE     
			    	ProcedureCodeId <> ISNULL(@ProcedureCodeId,0)
			AND 
				DisplayAs = @ProcedureCode
		)

/*To check Duplicate Display name.*/
IF (@DisplayNameCount > 0)
BEGIN
	/*If Duplicate found then return @ProcedureCodeId as -2.*/
	SET @ProcedureCodeId = -2
END
ELSE

BEGIN

	IF( @ProcedureCodeId IS NULL )--AND @ProcedureRateId IS NULL)
	BEGIN
	
			INSERT INTO ProcedureCodes(
					DisplayAs, 
					ProcedureCodeName, 
					Active, 
					AllowDecimals, 
					EnteredAs, 
					NotBillable, 
					DoesNotRequireStaffForService, 
					NotOnCalendar, 
					FaceToFace, 
					GroupCode, 
					EndDateEqualsStartDate, 
					RequiresSignedNote, 
					AssociatedNoteId, 
					MinUnits, 
					MaxUnits, 
					UnitIncrements, 
					UnitsList, 
					ExternalCode1, 
					ExternalSource1, 	
					ExternalCode2, 
					ExternalSource2, 
					CreditPercentage, 	
					Category1, 
					Category2, 
					Category3, 
			--		ExternalReferenceId, 
					CreatedBy, 
					CreatedDate,
					ModifiedBy,
					ModifiedDate
					
			)VALUES(
					@ProcedureCode,
					@ProcedureDescription,
					@Active,
					@AllowDecimals, 
					@EnteredAs, 
					@NotBillable, 
					@DoesNotRequireStaffForService,
					@NotOnCalendar, 
					@FaceToFace, 
					@GroupCode,
					@EndDateEqualsStartDate, 
					@RequiresSignedNote, 
					@AssociatedNoteId,
					@MinUnits, 
					@MaxUnits, 
					@UnitIncrements, 
					@UnitsList, 
					@ExternalCode1, 
					@ExternalSource1, 
					@ExternalCode2, 
					@ExternalSource2, 
					@CreditPercentage, 
					@Category1, 
					@Category2,
					@Category3, 
				--	@ExternalReferenceId, 
					@Modifier,
					GETDATE(),
					@Modifier,
					GETDATE()
			)
	
			IF(@@Error > 0)
			BEGIN 
				RollBack Tran ProcedureCodes
			END
			--Selects ProcedureCodeId of current inserted record
			SET @ProcedureCodeId = @@IDENTITY 
			
			
	END
	ELSE
	BEGIN
		UPDATE    ProcedureCodes
		SET             
				DisplayAs = @ProcedureCode,
				ProcedureCodeName = @ProcedureDescription,
				Active = @Active,
				AllowDecimals = @AllowDecimals,
				EnteredAs = @EnteredAs, 
				NotBillable = @NotBillable, 
				DoesNotRequireStaffForService = @DoesNotRequireStaffForService,
				NotOnCalendar = @NotOnCalendar,
				FaceToFace = @FaceToFace,
				GroupCode = @GroupCode, 
				EndDateEqualsStartDate = @EndDateEqualsStartDate, 
				RequiresSignedNote = @RequiresSignedNote,
				AssociatedNoteId = @AssociatedNoteId,
				MinUnits = @MinUnits, 
				MaxUnits = @MaxUnits, 
				UnitIncrements = @UnitIncrements, 
				UnitsList = @UnitsList,
				ExternalCode1 = @ExternalCode1,
				ExternalSource1 = @ExternalSource1, 
				ExternalCode2 = @ExternalCode2, 
				ExternalSource2 = @ExternalSource2, 
				CreditPercentage = @CreditPercentage, 
				Category1 = @Category1,  
				Category2 = @Category2,
				Category3 = @Category3, 
			--	ExternalReferenceId = @ExternalReferenceId, 
				ModifiedBy = @Modifier, 
				ModifiedDate = GETDATE()
		WHERE
			ProcedureCodeId = @ProcedureCodeId
		
		IF(@@ERROR > 0)
		BEGIN
			ROLLBACK TRAN
		END
		
		
				
			
	END
END
COMMIT TRAN ProcedureCodes
END TRY
BEGIN CATCH
   DECLARE @Error varchar(8000)                                            
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ProcedureCodeRatesUpd')                                        
         + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                              
         + '*****' + Convert(varchar,ERROR_STATE())                                            
        RAISERROR                                             
   (                                            
     @Error, -- Message text.                                
     16, -- Severity.                                            
     1 -- State.                                            
    ); 
END CATCH
END
GO
