SET IDENTITY_INSERT dbo.GlobalCodes ON 
INSERT INTO dbo.GlobalCodes ( GlobalCodeId,Active,CodeName,Code,Category,[Description], CannotModifyNameOrDelete, ExternalCode1, ExternalCode2 )
SELECT 2762, 'Y','Client Copayment','CLIENTCOPAYMENT','ADJUSTMENTCODE','Adjustment code for client copayments. System Configuration key ClientCoPaymentAdjustmentCode is defaulted to this.'
, 'Y', '3','PR'
WHERE NOT EXISTS  ( SELECT 1 FROM GlobalCodes WHERE GlobalCodeId = 2762 )

SET IDENTITY_INSERT dbo.GlobalCodes OFF 
