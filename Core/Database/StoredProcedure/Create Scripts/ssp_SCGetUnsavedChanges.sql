IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetUnsavedChanges]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetUnsavedChanges]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_SCGetUnsavedChanges] @LoggedInStaffId INT
	,@StaffId INT = NULL
	/********************************************************************************  
-- Stored Procedure: dbo.ssp_SCGetUnsavedChanges    
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: gets data for Unsaved changes  
-- Updates:                                                         
-- Date        Author       Purpose  
-- 12.09.2009  Umesh Sharma Created.   
-- 12.09.2009  Vikas Monga  Added more columns to the final select  
-- 07.09.2010  SFarber      Added logic to support Supervisor view.  
-- 28Feb2012   Shifali		Added RecordDeleted checks and Active check with Banners
							Purpose - As it creates duplicacy if same Banner exists say twice and one is Active and other is InActive
-- 01Marc2012	Shifali		Reverted changes by Shifali made above for Banner Active check
-- 03/21/2012  JRiley		Added logic to remove duplicate results when non-active banners exist
-- 05/16/2012 jagdeep Hundal Modify sp to resolve the Multiple unsaved changes #971,951
-- 28.Aug.2014	Rohith Uppin New Column Provider Id added in Unsavedchange table to capture all provider related changes. Task#29 CM to SC.
-- 12/12/2014 Akwinass      REPLACE included for xmlns=""
-- 12/Jan/2014 Aravind      Added RecordDeleted check for banners.
                            Purpose - As it creates duplicacy if same Banner exists say twice and both are Active, 
                            with one Banner is RecordDeleted='Y'
                            Task #1213 - Philhaven - Customization Issues Tracking
-- 01/29/2015  NJain		Replaced VARCHAR with NVARCHAR in CAST XML as VARCHAR(MAX)                      
-- 21 Oct 2015  Revathi		what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
--							why:task #609, Network180 Customization  /
--23 Nov 2015  Vichee       Modified the code to get ClientName depends on the ClientType else null why:task #609, Network180 Customization
--05/18/2017   Rahul		EI#507 - Performance Improvement - Persisting the Original/Changed Dataset - Modified the code to include the OriginalXML
--06/27/2017   Rahul		EI#507 - Performance Improvement - Persisting the Original/Changed Dataset - Modified the code to include the MissingColumns  
*********************************************************************************/
AS
BEGIN

SET @StaffId = isnull(@StaffId, @LoggedInStaffId)

--Added by Nandita to delete unsaved changes for the staff id
DECLARE @DurationToDelete INT
DECLARE @ValueVariable VARCHAR(200)

BEGIN TRY
SELECT @ValueVariable= Value FROM SystemConfigurationKeys WHERE [key] = 'RETAINUNSAVEDCHANGESFORXHOURS'

IF  (@ValueVariable IS NOT NULL)
BEGIN



	SET @DurationToDelete=CAST(@ValueVariable AS INT)

	DELETE FROM UnsavedChanges WHERE CreatedDate < DATEADD(HOUR,-(@DurationToDelete),GETDATE()) AND StaffId=@StaffId


END

DECLARE @CustomUnsavedChange TABLE (
	UnsavedChangeId INT
	,StaffId INT NULL
	,ScreenId INT NULL
	,ClientId INT NULL
	,Concurrency BIT NULL
	,ScreenType INT
	,TabId INT
	,CreatedDate DATETIME
	,CreatedBy VARCHAR(30)
	,ModifiedDate DATETIME
	,ModifiedBy VARCHAR(30)
	,RecordDeleted CHAR(1)
	,DeletedBy VARCHAR(30)
	,DeletedDate DATETIME
	,UnsavedChangesXML XML
	,ClientName VARCHAR(100)
	,ScreenName VARCHAR(100)
	,ScreenProperties VARCHAR(max) NULL
	,RowIdentifier UNIQUEIDENTIFIER
	,ProviderId INT NULL
	,ProviderName VARCHAR(100)
	,OriginalXML XML	--05/18/2017   Rahul
	,MissingColumns VARCHAR(max) NULL	--06/27/2017   Rahul
	)

INSERT INTO @CustomUnsavedChange (
	UnsavedChangeId
	,StaffId
	,ScreenId
	,ClientId
	,Concurrency
	,ScreenType
	,TabId
	,ProviderId
	,ProviderName
	,CreatedDate
	,CreatedBy
	,ModifiedDate
	,ModifiedBy
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	)
SELECT DISTINCT u.UnsavedChangeId
	,u.StaffId
	,u.ScreenId
	,u.ClientId
	,u.Concurrency
	,s.ScreenType
	,b.TabId
	,P.ProviderId
	,CASE P.ProviderType
		WHEN 'I'
			THEN P.ProviderName + ', ' + P.FirstName
		WHEN 'F'
			THEN P.ProviderName
		END AS ProviderName
	,u.CreatedDate
	,u.CreatedBy
	,u.ModifiedDate
	,u.ModifiedBy
	,u.RecordDeleted
	,u.DeletedBy
	,u.DeletedDate
FROM UnsavedChanges u
LEFT JOIN Clients c ON c.ClientId = u.ClientId
LEFT JOIN Screens s ON s.ScreenId = u.ScreenId
LEFT JOIN Banners b ON b.ScreenId = s.ScreenId
	AND b.Active = 'Y'
	AND isnull(b.RecordDeleted, 'N') = 'N'
LEFT JOIN Providers P ON P.ProviderId = u.ProviderId
WHERE u.StaffId = @LoggedInStaffId
	AND @LoggedInStaffId = @StaffId -- Not Supervisor view   
	AND isnull(c.RecordDeleted, 'N') = 'N'

UPDATE CUS
SET UnsavedChangesXML = CAST(REPLACE(CAST(UC.UnsavedChangesXML AS NVARCHAR(MAX)), 'xmlns=""', '') AS XML)
	--Added by Revathi 21 Oct 2015
	,ClientName = 
	 CASE 
		WHEN c.ClientType = 'I'
			THEN ISNULL(c.LastName, '') + ', ' + ISNULL(c.FirstName, '')
		ELSE  case when c.ClientType = 'O' then ISNULL(c.OrganizationName, '') else '' end
		END
	
	,ScreenName = s.ScreenName
	,ScreenProperties = UC.ScreenProperties
	,RowIdentifier = UC.RowIdentifier
	,OriginalXML = CAST(REPLACE(CAST(UC.OriginalXML AS NVARCHAR(MAX)), 'xmlns=""', '') AS XML)		--05/18/2017   Rahul
	,MissingColumns = UC.MissingColumns	--06/27/2017	Rahul
FROM @CustomUnsavedChange CUS
INNER JOIN UnsavedChanges UC ON UC.UnsavedChangeId = CUS.UnsavedChangeId
LEFT JOIN Clients c ON c.ClientId = UC.ClientId
LEFT JOIN Screens s ON s.ScreenId = UC.ScreenId

SELECT CUC.UnsavedChangeId
	,CUC.StaffId
	,CUC.ScreenId
	,CUC.ClientId
	,CUC.UnsavedChangesXML
	,CUC.Concurrency
	,CUC.ClientName
	,CUC.ScreenName
	,CUC.ScreenType
	,CUC.ScreenProperties
	,CUC.TabId
	,CUC.CreatedDate
	,CUC.RowIdentifier
	,CUC.CreatedBy
	,CUC.ModifiedDate
	,CUC.ModifiedBy
	,CUC.RecordDeleted
	,CUC.DeletedBy
	,CUC.DeletedDate
	,CUC.ProviderId
	,CUC.ProviderName
	,CUC.OriginalXML	--05/18/2017   Rahul
	,CUC.MissingColumns	--06/27/2017	Rahul
FROM @CustomUnsavedChange CUC

END TRY                                                                        
 BEGIN CATCH                            
  DECLARE @Error VARCHAR(8000)                                                                         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                   
     + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_SCGetUnsavedChanges')                                                                                                       
     + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                           
     + '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                    
  RAISERROR                                                                                                       
  (                                                                         
   @Error,                                                                                                       
   16, -                                                                                                      
   1                                                                                                    
  );                                                                                                    
 END CATCH                                                   
END
