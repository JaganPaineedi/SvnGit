DROP PROCEDURE [dbo].[csp_RdlPcpDepressionScreeningReferrals]
GO

/****** Object:  StoredProcedure [dbo].[csp_RdlPcpDepressionScreeningReferrals]    Script Date: 9/9/2016 10:06:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************             
**  File: csp_RdlPcpDepressionScreeningReferrals.sql 
**  Name: csp_RdlPcpDepressionScreeningReferrals 
**  Desc: Tracks individuals who have been referred by a PCP for a depression
**		  screening and must report on follow up.
**                   
**  Created By:  Paul Ongwela 
**  Date:		 May 7, 2015 
**
...............................................................................                  
..  Change History                   
...............................................................................                  
..  Date:		Author:				Description:                   
..  --------	--------			-------------------------------------------    
..  05/07/2015  Paul Ongwela        Created.
..
..
*******************************************************************************/

CREATE PROCEDURE [dbo].[csp_RdlPcpDepressionScreeningReferrals]
	@ReferralType INT
	,@ReferralSubType INT
	,@StartDate DATETIME
	,@EndDate DATETIME
AS

BEGIN

-- Set NoCount On added to prevent extra result sets from interfering with
-- statements such as SELECT, INSERT, UPDATE, and DELETE... 
SET NOCOUNT ON;

SELECT	c.ClientId
		, c.FirstName + ' ' + c.LastName AS ClientName
		, gc1.CodeName AS ReferralType
		, gc2.CodeName AS ReferralSubType
		, cdr.ReferralDate, gc3.CodeName AS Results

FROM CustomDocumentRegistrations AS cdr
	JOIN DocumentVersions AS dv ON dv.DocumentVersionId = cdr.DocumentVersionId
	JOIN Documents AS d ON d.DocumentId = dv.DocumentId
		AND d.CurrentDocumentVersionId = dv.DocumentVersionId
	JOIN Clients AS c ON c.ClientId = d.ClientId
	JOIN GlobalCodes AS gc1 ON gc1.GlobalCodeId = cdr.ReferralType
	JOIN GlobalCodes AS gc2 ON gc2.GlobalCodeId = cdr.ReferralSubType
	JOIN GlobalCodes AS gc3 ON gc3.GlobalCodeId = cdr.Facility

WHERE ISNULL(cdr.RecordDeleted, 'N') = 'N'
	AND  ISNULL(dv.RecordDeleted, 'N') = 'N'
	AND  ISNULL(d.RecordDeleted, 'N') = 'N'
	AND  ISNULL(c.RecordDeleted, 'N') = 'N'
	AND d.Status = 22 -- Signed
	AND DATEDIFF(DAY, d.EffectiveDate, @StartDate) <= 0
	AND DATEDIFF(DAY, d.EffectiveDate, @EndDate) >= 0
	AND (1=(CASE WHEN @ReferralType IS NULL THEN 1 ELSE 0 END)
		OR cdr.ReferralType = @ReferralType)
	AND (1=(CASE WHEN @ReferralSubType IS NULL THEN 1 ELSE 0 END)
		OR cdr.ReferralSubType = @ReferralSubType)
	AND d.EffectiveDate BETWEEN @StartDate AND @EndDate
	
END


GO


