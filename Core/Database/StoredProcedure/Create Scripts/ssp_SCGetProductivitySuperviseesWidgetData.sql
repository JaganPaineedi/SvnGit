IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetProductivitySuperviseesWidgetData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetProductivitySuperviseesWidgetData]
GO

CREATE PROC [dbo].[ssp_SCGetProductivitySuperviseesWidgetData] (
	@ProductivityDate AS DATE = NULL
	--,@MainOrganizationLevelId AS INT = NULL
	,@StaffId AS INT
	,@ProjectedTimeOffHours AS INT = NULL
	--,@OrganizationLevelId AS INT = NULL
	)
AS
/******************************************************************************                                            
**  File:                                             
**  Name: ssp_SCGetProductivitySuperviseesWidgetData  null,550,null                                        
**  Desc: This storeProcedure will executed for binding supervisees dashboard widget 
**  
**  Parameters:   
**  Input   @ProductivityDate AS DATE,  
    @StaffId AS INT ,  
    @ProjectedTimeOffHours AS INT  
**  Output     ----------       -----------   
**    
**  Auth:  Vandana Ojha
**  Date: Sept 21, 2018  
*******************************************************************************   
**  Change History    
*******************************************************************************   
**  Date:  Author:    Description:   
**  --------  --------    -------------------------------------------   
**    
*******************************************************************************/
BEGIN
	BEGIN TRY
	EXEC ssp_SCQueryStaffDashboardSuperviseesProductivityMetrics @ProductivityDate
		,@StaffId
		,@ProjectedTimeOffHours

	EXEC ssp_SCQueryOrgLevelSuperviseesDashboardProductivityMetrics @ProductivityDate
		,@StaffId

	-------->SiteMap creation <------------------    
	DECLARE @MainLevelNumber INT
		,@LevelNumber INT

	SELECT S.staffid AS OrganizationLevelId
		,ISNULL(LastName + ', ', '') + FirstName AS LevelName
	FROM Staff S
	INNER JOIN StaffSupervisors SS ON SS.StaffId = S.StaffId
	WHERE SS.SupervisorId = @StaffId
		AND ISNULL(S.RecordDeleted, 'N') = 'N'
		AND ISNULL(SS.RecordDeleted, 'N') = 'N'
		END TRY
		BEGIN CATCH
		 DECLARE @Error VARCHAR(8000)   
  
          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****'   
                       + CONVERT(VARCHAR(4000), Error_message())   
                       + '*****'   
                       + Isnull(CONVERT(VARCHAR, Error_procedure()),   
                       'ssp_SCGetProductivitySuperviseesWidgetData')   
                       + '*****' + CONVERT(VARCHAR, Error_line())   
                       + '*****' + CONVERT(VARCHAR, Error_severity())   
                       + '*****' + CONVERT(VARCHAR, Error_state())   
  
          RAISERROR ( @Error,-- Message text.          
                      16,-- Severity.          
                      1 -- State.          
          );   
		END CATCH
END
GO


