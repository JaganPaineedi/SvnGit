-- Script to remove the Valley specific CLIENTFEETYPE Global codes from all environment except Valley.
-- Deleting the Global codes only if both codename Medicaid & Salt Lake County are not used in that environment.
-- Why : Custom global codes script was wrongly sent to all customers. Task Engineering Improvement Initiatives- NBL(I) > Tasks #366

DECLARE @ClientFeeType INT

IF not exists (select 1 from systemconfigurations  where OrganizationName like 'Valley%') -- Not exists in Valley customer any db
BEGIN
IF EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CLIENTFEETYPE' AND CodeName = 'Medicaid' AND ISNULL(RecordDeleted,'N')='N')
BEGIN	
	SET @ClientFeeType = 0
	SELECT TOP 1 @ClientFeeType = GlobalCodeId FROM GlobalCodes WHERE Category='CLIENTFEETYPE' AND CodeName = 'Medicaid' AND ISNULL(RecordDeleted,'N')='N'
	IF NOT EXISTS (SELECT 1 FROM ClientFees WHERE ISNULL(ClientFeeType, 0) = @ClientFeeType )  and
		NOT EXISTS (SELECT 1 FROM ClientFees WHERE ClientFeeType in (SELECT globalcodeid FROM GlobalCodes 
						WHERE Category='CLIENTFEETYPE' AND CodeName = 'Salt Lake County' ))

	BEGIN
		DELETE FROM GlobalCodes WHERE GlobalCodeId = @ClientFeeType
	END
END


IF EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CLIENTFEETYPE' AND CodeName = 'Salt Lake County' AND ISNULL(RecordDeleted,'N')='N')
BEGIN		
	SET @ClientFeeType = 0
	SELECT TOP 1 @ClientFeeType = GlobalCodeId FROM GlobalCodes WHERE Category='CLIENTFEETYPE' AND CodeName = 'Salt Lake County' AND ISNULL(RecordDeleted,'N')='N'
	IF NOT EXISTS (SELECT 1 FROM ClientFees WHERE ISNULL(ClientFeeType, 0) = @ClientFeeType )  and
		NOT EXISTS (SELECT 1 FROM ClientFees WHERE ClientFeeType in (SELECT globalcodeid FROM GlobalCodes 
						WHERE Category='CLIENTFEETYPE' AND CodeName = 'Medicaid' ))
	BEGIN
		DELETE FROM GlobalCodes WHERE GlobalCodeId = @ClientFeeType
	END
END
END