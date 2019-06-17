IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetPharmacyById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetPharmacyById]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Kneale Alpers
-- Create date: August 26, 2013
-- Description:	Gets Single Parmacy by Id
-- =============================================
CREATE PROCEDURE [dbo].[ssp_SCGetPharmacyById]
	@PharmacyId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT CASE WHEN LTRIM(RTRIM(ISNULL(SureScriptsPharmacyIdentifier,'')))='' THEN 'Y' ELSE 'N' END AS PharmacyEditAllowed, * FROM dbo.Pharmacies WHERE PharmacyId = @PharmacyId
    
END


GO


