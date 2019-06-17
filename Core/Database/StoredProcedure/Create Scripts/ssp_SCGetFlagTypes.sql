/****** Object:  StoredProcedure [dbo].[ssp_SCGetFlagTypes]    Script Date: 09/01/2015 14:45:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetFlagTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetFlagTypes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetFlagTypes]    Script Date: 09/01/2015 14:45:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetFlagTypes]
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetFlagTypes            */
/* Creation Date:    24/Nov/2014                  */
/* Purpose:  Used to update ClientCCD Allergy, Medication and Problem from XML data                */
/*    Exec ssp_SCGetFlagTypes                                              */
/* Input Parameters:                           */
/*  Date		Author			Purpose              */
/* 01/Sep/2015  SHankha			Core Bugs# 1891*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		SELECT FlagTypeId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,FlagType
			,Active
			,PermissionedFlag
			,DoNotDisplayFlag
			,NeverPopup
			,SortOrder
			,Bitmap
			,BitmapImage
			,Comments
		FROM Flagtypes
		WHERE Isnull(RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'ssp_SCGetFlagTypes') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                     
				16
				,
				-- Severity.                                                                                     
				1
				-- State.                                                                                     
				);
	END CATCH
END

GO


