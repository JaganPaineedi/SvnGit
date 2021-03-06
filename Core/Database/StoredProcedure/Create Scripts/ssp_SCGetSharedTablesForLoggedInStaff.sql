IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCGetSharedTablesForLoggedInStaff')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCGetSharedTablesForLoggedInStaff;
    END;
                    GO
CREATE PROCEDURE [dbo].[ssp_SCGetSharedTablesForLoggedInStaff]
    @StaffId INT ,
    @ProviderId INT ,
    @ApplicationId INT                                                                
/********************************************************************************                            
-- Stored Procedure: dbo.ssp_SCGetSharedTablesForLoggedInStaff                              
--                            
-- Copyright: Streamline Healthcate Solutions                            
--                            
-- Purpose: get all Shared Tables related to logged in User of SC Application                         
-- Updates:                                                                             
-- Date        Author        Purpose                      
-- 06.12.2009  Sonia Dhamija Created.                       
-- 02.24.2010  Vikas Monga   Get Client List in Staff share table                                              
-- 03.08.2010  Vikas Vyas    Added Procedure to get Staff Procedure,Staff Program List                                             
-- 03.20.2010  Vikas Vyas    Added Parameter ProviderId as well as get List of UserProviders,EventType                                     
-- 04.06.2010  Vikas Vyas    Added ssp_SCGetWidgetData to get list of StaffWidgets                                                                            
-- 04.16.2010  Vikas Monga   Added ssp_SCGetStaffScreenPermissions to get screen and screen controls permisions                                                                            
-- 07.09.2010  SFarber       Added logic to support Supervisor view.                      
-- 07.22.2010  Vikas Monga   Added SP to refresh staff client table.            
-- 02.11.2011  SFarber       Added All Access Permission, Staff Details and Programs          
-- 02.21.2011  SFarber       Fixed logic for @AllAccess              
-- 08.16.2010  Karan Garg    Added ssp_SCGetStaffScreenPermissionsForUpdateMode to get screen controls permissions in update mode          
-- 11.21.2011  MSuma   Included Changes for HomePageScreenId  
-- 29.09.2014  Chethan N	 Added ssp_SCGetClientInformationTabConfigurationsForStaff to get client tabs url from ClientInformationTabConfigurations table 
-- 06.23.2015  Chethan N	What : Added New SSP ''ssp_SCGetDocumentCodesViewPermission'' to get Document Codes for which logged in staff have View only permission
--							Why : Macon Desing task#60     
-- JUNE.27.2017 Akwinass	What : Added ssp_SCSearchReports
--							Why : Engineering Improvement Initiatives- NBL(I) #536 	
-- 04.27.2018	jcarlson	Harbor Support 1661.2 : SET ARITHABORT ON; performance improvements  
													reformatted for improved readability   
*********************************************************************************/
AS
	SET ARITHABORT ON;
    EXEC ssp_RefreshStaffClients @StaffId;                                                                             

    EXEC ssp_SCGetAllFilters @StaffId; --Staff Filetrs Data                                                                  

    EXEC ssp_SCGetStaffProxiesDetail @StaffId; -- Get Staff Proxy users                                                           

    EXEC ssp_SCGetStaffBannersTabs @LoggedInStaffId = @StaffId, @StaffId = @StaffId;  -- Get Staff banners and Tabs                                                     

    EXEC ssp_SCGetUnsavedChanges @LoggedInStaffId = @StaffId, @StaffId = @StaffId; -- Get Unsaved Changes                                                        

    EXEC ssp_SCGetPrimaryStaffClients @LoggedInStaffId = @StaffId, @StaffId = @StaffId; -- Get Client List                                                      

    EXEC ssp_SCWebGetStaffProcedures @StaffId; --Get Staff Procedure List                                                    

    EXEC ssp_SCServicesStaffProgram @StaffId; -- Get Staff Program List                                                  

    EXEC ssp_SCGetUserProviders @ProviderId; -- Get list of UserProviders                                                    

    EXEC ssp_SCGetEventType @StaffId; -- Get list of EventTypes                                         

    EXEC ssp_SCGetWidgetData @StaffId; --Get list of StaffWidgets                                     
                  
    EXEC ssp_SCGetStaffScreenPermissions @LoggedInStaffId = @StaffId, @StaffId = @StaffId; --Get Screen and screen control Permission                                     

    EXEC ssp_SCGetStaffScreenAlternates;    

    EXEC ssp_SCGetSupervisorStaffs @StaffId; --Get staff list for the Supervisor             
            
    DECLARE @AllAccess CHAR(1);              
              
-- Determine if staff has all access              
    IF EXISTS ( SELECT  *
                FROM    ViewStaffPermissions
                WHERE   StaffId = @StaffId
                        AND PermissionTemplateType = 5909
                        AND PermissionItemId = 6241 )
        SET @AllAccess = 'Y';              
    ELSE
        IF EXISTS ( SELECT  *
                    FROM    ViewStaffPermissions
                    WHERE   StaffId = @StaffId
                            AND PermissionTemplateType = 5909
                            AND PermissionItemId <> 6241 )
            SET @AllAccess = 'N';              
              
    IF @AllAccess IS NULL
        SET @AllAccess = 'Y';              
                
    SELECT  @AllAccess AS AllAccess; -- All Access persmission              
          
    EXEC ssp_SCGetStaffDetails @LoggedInStaffId = @StaffId;  -- Get staff details              
    
	EXEC ssp_SCGetDataFromPrograms @LoggedInStaffId = @StaffId; -- Get staff programs       
    
	EXEC ssp_SCGetStaffScreenPermissionsForUpdateMode @LoggedInStaffId = @StaffId, @StaffId = @StaffId; --Get Screen and screen control Permission for Update Mode    
    
	EXEC ssp_PMGetHomePageScreenStaff @LoggedInUserId = @StaffId, @StaffId = @StaffId; 
    
	EXEC SSP_SCGetLoggedinStaffPermissions @LoggedInStaffId = @StaffId;
    
	EXEC ssp_SCGetClientInformationTabConfigurationsForStaff @LoggedInStaffId = @StaffId, @StaffId = @StaffId;
    
	EXEC ssp_SCGetDocumentCodesViewPermission @StaffId = @StaffId;  -- Get DocumentCodeId for View Mode -- Added By Chethan N
    
	EXEC ssp_SCSearchReports @StaffId = @StaffId;

GO
