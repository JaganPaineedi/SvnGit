/****** Object:  StoredProcedure [dbo].[ssp_SCGetFlowSheetScreenFilters]    Script Date: 08/28/2017 14:02:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetFlowSheetScreenFilters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetFlowSheetScreenFilters]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCGetFlowSheetScreenFilters]    Script Date: 08/28/2017 14:02:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SCGetFlowSheetScreenFilters]
@StaffId INT,
@ScreenId INT,
@ClientId INT,
@TabId INT
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCGetFlowSheetScreenFilters                        */
/* Copyright: 2017 Streamline Healthcare Solutions                          */
/* Author: Hemant                                                           */
/* Creation Date:  8/15/2017                                                */
/* Purpose: To Get FlowSheet Screen Filter                                  */
/* Input Parameters:@StaffId, @ScreenId, @ClientId                          */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*                                                                          */
/****************************************************************************/
BEGIN
	BEGIN TRY
		SELECT StaffId AS StaffId
			,ScreenId AS ScreenId
			,ClientId AS ClientId
			,FiltersXML
		FROM StaffScreenFilters
		WHERE StaffId = @StaffId
			AND ISNULL(RecordDeleted, 'N') = 'N' 
			AND ISNULL(ScreenId,0) = @ScreenId
			And ISNULL(ClientId,0) = @ClientId
			And ISNULL(TabId,0)=@TabId
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCGetFlowSheetScreenFilters: An Error Occured'

			RETURN
		END
	END CATCH
END


GO


