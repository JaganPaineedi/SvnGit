
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetEndUserConfigurations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetEndUserConfigurations]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ssp_SCGetEndUserConfigurations 2
CREATE PROCEDURE [dbo].[ssp_SCGetEndUserConfigurations] @StaffId INT
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetEndUserConfigurations]   */
/*       Date              Author                  Purpose                   */
/*      08-03-2016     Dhanil Manuel               To Get the end user monitoring configuartions settings task #394 Engineering Improvement Initiatives*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		
		DECLARE @AllowEndUserMonitoring char(1) = 'N';
		Declare @AllowedForStaff char(1) = 'N';
		Declare @AllowedTime char(1) = 'N';

				
		if exists(select * from AppDynamicsAllowedStaff where Staffid = @StaffId and isnull(RecordDeleted,'N') <> 'Y')
		begin
		   set @AllowedForStaff = 'Y';
		end
		else  if exists(select * from AppDynamicsAllowedStaff where  isnull(RecordDeleted,'N') <> 'Y')
		         and not exists (select * from AppDynamicsAllowedStaff where Staffid = @StaffId and isnull(RecordDeleted,'N') <> 'Y')
		begin
		   set @AllowedForStaff = 'N';
		end
		else if not exists(select * from AppDynamicsAllowedStaff where  isnull(RecordDeleted,'N') <> 'Y')
		begin
		   set @AllowedForStaff = 'Y';
		end

		 if not exists(select * from  AppDynamicsTimeFrames where isnull(RecordDeleted,'N') <> 'Y'  and StartDate is not null and  EndDate is not null)
		begin
		  set @AllowedTime = 'Y'
		end
	    else if 
		exists(select * from  AppDynamicsTimeFrames where isnull(RecordDeleted,'N') <> 'Y'  and StartDate is not null and  EndDate is not null) 
		and exists(select * from  AppDynamicsTimeFrames where StartDate <= getdate() and  EndDate >= getdate()  and isnull(RecordDeleted,'N') <> 'Y')
		begin
		  set @AllowedTime = 'Y'
		end
		else if exists(select * from  AppDynamicsTimeFrames where isnull(RecordDeleted,'N') <> 'Y'  and StartDate is not null and  EndDate is not null) 
		and not exists(select * from  AppDynamicsTimeFrames where StartDate <= getdate() and  EndDate >= getdate()  and isnull(RecordDeleted,'N') <> 'Y')
		begin
		  set @AllowedTime = 'N'
		end
		
		if(@AllowedForStaff ='Y' and @AllowedTime = 'Y')
		  set @AllowEndUserMonitoring = 'Y'
        if(@AllowedForStaff ='N' or @AllowedTime = 'N')
		  set @AllowEndUserMonitoring = 'N'

		        
       select @AllowEndUserMonitoring as AllowEndUserMonitoring

      
	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetEndUserConfigurations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


