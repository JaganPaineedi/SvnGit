/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateClientFeeDetails]    Script Date: 07/24/2015 14:27:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateClientFeeDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCUpdateClientFeeDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateClientFeeDetails]    Script Date: 07/24/2015 14:27:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCUpdateClientFeeDetails] @Locations VARCHAR(MAX)
	,@Programs VARCHAR(MAX)
	,@ProcedureCodes VARCHAR(MAX)
	,@ClientFeeId INT
	,@UserCode VARCHAR(25)
AS
-- =============================================    
-- Author      : Akwinass
-- Date        : 24 July 2015 
-- Purpose     : To Update Locations,Programs and ProcedureCodes. 
-- =============================================   
BEGIN
	BEGIN TRY
		--Locations		
		UPDATE ClientFeeLocations SET RecordDeleted = 'Y',DeletedDate = GETDATE(),DeletedBy = @UserCode WHERE ClientFeeId = @ClientFeeId		
		
		INSERT INTO ClientFeeLocations(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ClientFeeId,LocationId)
		SELECT @UserCode,GETDATE(),@UserCode,GETDATE(),@ClientFeeId,Token FROM [dbo].[SplitString](@Locations, ',') 
		WHERE ISNULL(Token, '') <> ''
		AND NOT EXISTS(SELECT 1 FROM ClientFeeLocations WHERE ClientFeeId = @ClientFeeId AND LocationId = Token)
		
		UPDATE CFL
		SET CFL.RecordDeleted = NULL
			,CFL.DeletedDate = NULL
			,CFL.DeletedBy = NULL
			,CFL.ModifiedBy = @UserCode
			,CFL.ModifiedDate = GETDATE()
		FROM ClientFeeLocations CFL
		JOIN (SELECT * FROM [dbo].[SplitString](@Locations, ',') WHERE ISNULL(Token, '') <> '') L ON CFL.LocationId = L.Token
		WHERE CFL.ClientFeeId = @ClientFeeId
		
		--Programs
		UPDATE ClientFeePrograms SET RecordDeleted = 'Y',DeletedDate = GETDATE(),DeletedBy = @UserCode WHERE ClientFeeId = @ClientFeeId
		
		INSERT INTO ClientFeePrograms(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ClientFeeId,ProgramId)
		SELECT @UserCode,GETDATE(),@UserCode,GETDATE(),@ClientFeeId,Token FROM [dbo].[SplitString](@Programs, ',') 
		WHERE ISNULL(Token, '') <> ''
		AND NOT EXISTS(SELECT 1 FROM ClientFeePrograms WHERE ClientFeeId = @ClientFeeId AND ProgramId = Token)
		
		UPDATE CFP
		SET CFP.RecordDeleted = NULL
			,CFP.DeletedDate = NULL
			,CFP.DeletedBy = NULL
			,CFP.ModifiedBy = @UserCode
			,CFP.ModifiedDate = GETDATE()
		FROM ClientFeePrograms CFP
		JOIN (SELECT * FROM [dbo].[SplitString](@Programs, ',') WHERE ISNULL(Token, '') <> '') P ON CFP.ProgramId = P.Token
		WHERE CFP.ClientFeeId = @ClientFeeId	
		
		--ProcedureCodes
		UPDATE ClientFeeProcedureCodes SET RecordDeleted = 'Y',DeletedDate = GETDATE(),DeletedBy = @UserCode WHERE ClientFeeId = @ClientFeeId
		
		INSERT INTO ClientFeeProcedureCodes(CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ClientFeeId,ProcedureCodeId)
		SELECT @UserCode,GETDATE(),@UserCode,GETDATE(),@ClientFeeId,Token FROM [dbo].[SplitString](@ProcedureCodes, ',') 
		WHERE ISNULL(Token, '') <> ''
		AND NOT EXISTS(SELECT 1 FROM ClientFeeProcedureCodes WHERE ClientFeeId = @ClientFeeId AND ProcedureCodeId = Token)
		
		UPDATE CFPC
		SET CFPC.RecordDeleted = NULL
			,CFPC.DeletedDate = NULL
			,CFPC.DeletedBy = NULL
			,CFPC.ModifiedBy = @UserCode
			,CFPC.ModifiedDate = GETDATE()
		FROM ClientFeeProcedureCodes CFPC
		JOIN (SELECT * FROM [dbo].[SplitString](@ProcedureCodes, ',') WHERE ISNULL(Token, '') <> '') P ON CFPC.ProcedureCodeId = P.Token
		WHERE CFPC.ClientFeeId = @ClientFeeId
	END TRY

	BEGIN CATCH
	END CATCH
END
GO





