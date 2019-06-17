IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_FlagTypeById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_FlagTypeById]
GO

/****** Object:  StoredProcedure [dbo].[ssp_FlagTypeById]    Script Date: 12/06/2018 16:59:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_FlagTypeById] 
    @FlagTypeID INT   
AS 
/********************************************************************************                                                    
-- Stored Procedure: ssp_FlagTypeById
-- Copyright: Streamline Healthcate Solutions
-- Purpose: Procedure to return data for the Reception Triage Arrival Details page on basis of given Id.
-- Author:  Avi Goyal
-- Date:    06 Jan 2015
-- *****History****  
-- Date				Author			Purpose
---------------------------------------------------------------------------------
-- 06 Jan 2015		Avi Goyal		What :Created 
									Why: Task 600 Security Alerts of Network 180 - Custmizations
-- 06 Jun 2018		Vijay			What:This ssp modified to update "Flag Type Details" page
									Why:Engineering Improvement Initiatives- NBL(I) - Task#590
*********************************************************************************/  

BEGIN  
	BEGIN TRY  
		SELECT  
			FT.FlagTypeId,
			FT.CreatedBy,
			FT.CreatedDate,
			FT.ModifiedBy,
			FT.ModifiedDate,
			FT.RecordDeleted,
			FT.DeletedBy,
			FT.DeletedDate,
			FT.FlagType,
			FT.Active,
			FT.PermissionedFlag,
			FT.DoNotDisplayFlag,
			FT.NeverPopup,
			FT.SortOrder,
			FT.Bitmap,
			FT.BitmapImage,
			FT.Comments,	
			FT.DefaultWorkGroup,
			FT.FlagLinkTo,
			SA.ActionId,
			SA.[Action] as ActionName,
			FT.DocumentCodeId,
			DC.DocumentName
		FROM FlagTypes FT
		LEFT JOIN SystemActions SA ON SA.ActionId=FT.ActionId AND ISNULL(SA.RecordDeleted,'N')='N'
	    LEFT JOIN DocumentCodes DC ON DC.DocumentCodeId=FT.DocumentCodeId AND ISNULL(DC.RecordDeleted,'N')='N'
		WHERE ISNULL(FT.RecordDeleted,'N')='N'
		AND FT.FlagTypeId = @FlagTypeId
		
		
	END TRY 
    BEGIN CATCH                                
		DECLARE @Error VARCHAR(8000)                                                                          
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                       
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_FlagTypeById')                                                                                                           
					+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                            
					+ '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                        
		RAISERROR                                                                                                           
		(                                                                             
			@Error, -- Message text.         
			16, -- Severity.         
			1 -- State.                                                           
		);                                                                                                        
	END CATCH
END