/****** Object:  StoredProcedure [dbo].[ssp_SCGetLatestSharedTablesForApplication]    Script Date: 08/31/2016 14:37:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetLatestSharedTablesForApplication]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetLatestSharedTablesForApplication]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetLatestSharedTablesForApplication]    Script Date: 08/31/2016 14:37:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetLatestSharedTablesForApplication] -- 'GlobalCodes'                                                                                   
	@TableName NVARCHAR(max)
	/******************************************************************************                                                                                                                  
**File: SharedTables.cs                                                                                                                  
**Name:SHS.DataServices                                                                                                
**Desc:Used to get particular Latest Shared Table related to SC Application                                                                                                  
**Return values:                                                                                                                  
**                                                                                                                               
**  Parameters:                                                                                                                  
**  Input       Output                                                                                                                  
**  @TableName   latest shared table                                                                                                
**                                                                                                            
**                                                                                                              
**                                                                                                            
**  Auth:  Shifali                                                                                                       
**  Date:  29 june,2010                                                                                                                 
*******************************************************************************                                                                                                                  
**  Change History                                                                                                                  
*******************************************************************************                                                                                                                  
**  Date:         Author:                Description:                                                                           
    14/Jun/2012	  Mamta Gupta			 Kalamazoo Bugs - Added condition for StaffLocations Shared Table
    07/Sept/2012  Rakesh Garg			 Modified As per Devinder discussion with Javed, Need to check for tableName and exec sp accrodingly
    31/AUG/2016   Akwinass				 Included Authorization Codes (Task #551 Key Point - Support Go Live)
    30/JAN/2018   Animesh Gaurav         Newly associated Program On Staff Details was not appearing in Group service list page- Program Dropdown. 
										 The issues was On click of save button in staff details, the  shared table was not refreshed which now fixed.Task #1193,Thresold Support)
*******************************************************************************/
AS
BEGIN
	BEGIN TRY
	IF (@TableName = 'StaffLocations')
	BEGIN
		EXEC ssp_SCGetStaffLocations
	END
	ELSE IF (@TableName = 'Banners')
	BEGIN
		EXEC ssp_SCGetBanners -- Banners Data
	END
	ELSE IF (@TableName = 'GlobalCodeCategories')
	BEGIN
		EXEC ssp_PMGetGlobalCodeCategories --Global Code Categories 
	END
	ELSE IF (@TableName = 'GlobalCodes')
	BEGIN
		EXEC ssp_SCGetDataFromGlobalCodes --Global Codes 
	END
	ELSE IF (@TableName = 'GlobalSubCodes')
	BEGIN
		EXEC ssp_SCGetDataFromGlobalSubCodes -- Global Sub Codes  
	END
	ELSE IF (@TableName = 'Locations')
	BEGIN
		EXEC ssp_SCGetDataFromLocations --Locations  
	END
	ELSE IF (@TableName = 'CoveragePlans')
	BEGIN
		EXEC ssp_PMGetCoveragePlans --CoveragePlans   
	END
	ELSE IF (@TableName = 'ProcedureCodes')
	BEGIN
		EXEC ssp_SCGetProcedureCodes --Procedure Codes 
	END
	ELSE IF (@TableName = 'Programs')
	BEGIN
		EXEC ssp_SCGetDataFromPrograms --Programs  
	END
	ELSE IF (@TableName = 'ReceptionViews')
	BEGIN
		EXEC ssp_PMGetReceptionViews --Reception Views  
	END
	ELSE IF (@TableName = 'Payers')
	BEGIN
		EXEC ssp_PMGetAllPayers --Payers  
	END
	ELSE IF (@TableName = 'ScreenLabels')
	BEGIN
		EXEC ssp_PMGetScreenLabels --Label Replacement 
	END
	ELSE IF (@TableName = 'ScreenControlsHelp')
	BEGIN
		EXEC ssp_SCGetScreenControlsHelp -- Controls Help Text  
	END
	ELSE IF (@TableName = 'Staff')
	BEGIN
		EXEC ssp_SCGetStaffDetails -- Staff    
	END
	--30/JAN/2018   Animesh Gaurav 
	ELSE IF (@TableName = 'GroupsProgram')  
 BEGIN  
  exec ssp_SCGetDataForGroupProgram--GroupsProgram      
 END  
	-- 31/AUG/2016 Akwinass
	ELSE IF (@TableName = 'AuthorizationCodes')
	BEGIN
		EXEC ssp_SCGetAuthorisationCodes -- AuthorizationCodes    
	END
	ELSE
	BEGIN
		DECLARE @strQuery NVARCHAR(max)
		SET @strQuery = 'Select * from ' + @TableName
		--+ ' where isnull(' + @TableName + '.RecordDeleted,''N'') <> ''Y''          
		--and ' + @TableName + '.Active = ''Y'''    
		--print @strQuery    
		EXEC (@strQuery)
	END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetLatestSharedTablesForApplication') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                              
				16
				,-- Severity.                                                                                                                
				1 -- State.                                          
				);
	END CATCH
END

GO