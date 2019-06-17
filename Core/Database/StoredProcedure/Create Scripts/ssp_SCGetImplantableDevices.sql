IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetImplantableDevices]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetImplantableDevices] --16928
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_SCGetImplantableDevices] (@ImplantableDeviceId INT)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetImplantableDevices]  3        */
/* Date              Author                  Purpose                 */
/* 29/06/2017       Sunil.D             SC: ImplantableDevices  ssp_SCGetImplantableDevices #24 Meaningful Use                   */
/*************************************************ssp_SCGetImplantableDevices********************/
/**  Change History **/
/********************************************************************************/
/**  Date:			Author:			Description: **/
/*					*/    
/**  --------  --------    ------------------------------------------- */
BEGIN
	BEGIN TRY
		 select
				ID.ImplantableDeviceId
				,ID.CreatedBy
				,ID.CreatedDate
				,ID.ModifiedBy
				,ID.ModifiedDate
				,ID.RecordDeleted
				,ID.DeletedBy
				,ID.DeletedDate
				,ID.GlobalUDI
				,ID.BrandName
				,ID.VersionOrModel
				,ID.CompanyName
				,ID.SerialNumber
				,ID.LotOrBatchNumber
				,ID.MRISafety
				,ID.ManufacturingDate
				,ID.ExpirationDate
				,ID.HCTOrPIndicator
				,ID.Descrpition
				,ID.ContainsNaturalRubber
				,ID.ImplantDate
				,ID.Active
				,ID.InactiveReason
		   FROM ImplantableDevices ID
		   WHERE ImplantableDeviceId = @ImplantableDeviceId AND ISNULL(ID.RecordDeleted,'N') <> 'Y'  
		   
	END TRY 
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000) 
		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetImplantableDevices') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE()) 
		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END