UPDATE Screens
SET PostUpdateStoredProcedure = 'ssp_CMClaimlinePostUpdate',
ModifiedBy = 'HeartlandSGL12',
ModifiedDate = GETDATE()
WHERE ScreenId = 1010
