


UPDATE  cli2
SET     cli2.VoidedClaim = cli.VoidedClaim
FROM    dbo.ClaimLineItems cli
        JOIN dbo.ClaimLineItems AS cli2 ON cli2.ClaimLineItemId = cli.OriginalClaimLineItemId
                                           AND cli.VoidedClaim IS NOT NULL
	
UPDATE  dbo.ClaimLineItems
SET     ToBeVoided = 'N'
WHERE   ISNULL(VoidedClaim, 'N') = 'Y'

UPDATE  dbo.ClaimLineItems
SET     ToBeResubmitted = 'N'
WHERE   ISNULL(ResubmittedClaim, 'N') = 'Y'

