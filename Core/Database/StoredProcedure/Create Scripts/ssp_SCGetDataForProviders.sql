
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataForProviders]    Script Date: 06/09/2015 05:25:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataForProviders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDataForProviders]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataForProviders]    Script Date: 06/09/2015 05:25:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
**  File: ssp_SCGetDataForProviders.sql
**  Name: ssp_SCGetDataForProviders
**  Desc: Provides Clinicians list who is having permission.
**
**  Return values: <Return Values>
**
**  Called by: <Code file that calls>
**
**  Parameters:
**  Input   Output
**  ServiceId      -----------
**
**  Created By: Veena S Mani
**  Date:  June 13 2014
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:  Author:    Description:
**  --------  --------    -------------------------------------------
--  23/06/14   Veena   Removed conditions to exclude staffs.
*******************************************************************************/
CREATE PROCEDURE  [dbo].[ssp_SCGetDataForProviders]
AS
BEGIN
	BEGIN TRY
	--DECLARE @count INT
	--SET @count=(Select count(*) from MeaningFulUseProviderExclusions pe inner join meaningfulusedetails md on md.MeaningFulUseDetailId= pe.MeaningFulUseDetailId where OrganizationExclusion='Y' and ISNULL(md.RecordDeleted,'N') <> 'Y' and md.MeasureType=8700 and CAST(pe.ProviderExclusionFromDate AS DATE) <= CAST(GETDATE() AS DATE) and CAST(pe.ProviderExclusionToDate AS DATE) >= CAST(GETDATE() AS DATE) and ISNULL(pe.RecordDeleted,'N') <> 'Y')
	--IF (@count>0)
	--BEGIN
	--Select 'All Providers' as ProviderTextField,'-1' as ProviderValueField
	--END
	--ELSE
	BEGIN
		SELECT DISTINCT sf.StaffId as ProviderValueField
			,sf.LastName + ', ' + sf.FirstName AS ProviderTextField
		FROM Staff AS sf
		--INNER JOIN MeaningFulUseProviderExclusions AS MPE on sf.staffid = MPE.Staffid
		WHERE sf.clinician='Y'   and ISNULL(RecordDeleted,'N') <> 'Y' --and staffid not in (Select Staffid from MeaningFulUseProviderExclusions pe inner join meaningfulusedetails md on md.MeaningFulUseDetailId= pe.MeaningFulUseDetailId  where  pe.OrganizationExclusion='N' and ISNULL(md.RecordDeleted,'N') <> 'Y' and md.MeasureType=8700  and CAST(pe.ProviderExclusionFromDate AS DATE) <= CAST(GETDATE() AS DATE) and CAST(pe.ProviderExclusionToDate AS DATE) >= CAST(GETDATE() AS DATE)  and ISNULL(pe.RecordDeleted,'N') <> 'Y')
		ORDER BY  ProviderTextField
	
	END	
	--	select * from MeaningFulUseProviderExclusions where  OrganizationExclusion='N'  and CAST(ProviderExclusionFromDate AS DATE) <= CAST(GETDATE() AS DATE) and CAST(ProviderExclusionToDate AS DATE) >= CAST(GETDATE() AS DATE)  and ISNULL(RecordDeleted,'N') <> 'Y'
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetDataForProviders') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH

	RETURN
END

GO

