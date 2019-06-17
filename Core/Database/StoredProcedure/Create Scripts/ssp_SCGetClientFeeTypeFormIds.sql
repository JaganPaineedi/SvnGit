/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeeTypeFormIds]    Script Date: 01/14/2015 10:01:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientFeeTypeFormIds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientFeeTypeFormIds]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFeeTypeFormIds]    Script Date: 01/14/2015 10:01:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SCGetClientFeeTypeFormIds]
AS
-- =============================================    
-- Author      : Akwinass
-- Date        : 27 July 2015 
-- Purpose     : Get Client Fee Type Configurations. 
-- =============================================   
BEGIN
	BEGIN TRY	 
		SELECT DISTINCT ClientFeeTypeConfigurationId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,FormId
			,ClientFeeType
			,InitializationCSPName
		FROM ClientFeeTypeConfigurations
		WHERE FormId IS NOT NULL
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
	END CATCH

END


GO

