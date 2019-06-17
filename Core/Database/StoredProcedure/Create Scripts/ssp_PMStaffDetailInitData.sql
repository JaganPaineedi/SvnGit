/****** Object:  StoredProcedure [dbo].[ssp_PMStaffDetailInitData]    Script Date: 02/23/2012 16:11:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMStaffDetailInitData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMStaffDetailInitData]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMStaffDetailInitData]    Script Date: 02/23/2012 16:11:23 ******/
SET ANSI_NULLS ON			-- 09 Jun 2016     Avi Goyal
GO

SET QUOTED_IDENTIFIER ON	-- 09 Jun 2016     Avi Goyal
GO




CREATE  PROCEDURE [dbo].[ssp_PMStaffDetailInitData]
 @StaffId INT,
 @LoggedInUserId INT
AS
/********************************************************************************                                                  
-- Stored Procedure: ssp_PMStaffDetailInitData
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Procedure to return dropdown list data for the staff details page.
--
-- Author:  Girish Sanaba
-- Date:    12 May 2011
--
-- *****History****
26 Aug 2011		Girish		Removed unnecessary resultsets
27 Aug 2011		Girish		Changed home page and clientpage resultsets to get screens based on permissions
15 Nov 2011		MSuma		Included Active Check on Banners
15 Dec 2011		MSuma		Modified Client Page Preference
20 Dec 2011		MSuma		Included new table for Quick Actions Excluding Client Tab 
02.23.2012		avoss		corrected the permissions for client screen preferance
12.05.2015      Jayashree   Changed LocationId 0 to NULL w.r.t Allegan 3.5 Implementation task #300
08 Jun 2016     Avi Goyal	Added Active check as part of Camino - Environment Issues Tracking task #195 My Preferences - Quick Action: My Office - Reception not showing
09 Jun 2016     Avi Goyal	Set "ANSI_NULLS" & "QUOTED_IDENTIFIER" as "ON" - as per suggestion from DB Team
01 Mar 2016	    Deej	Changed where clause in Location selection from @LoggedInUserId to @StaffId
*********************************************************************************/
BEGIN

	BEGIN TRY
	
	 DECLARE @ScreenIds   TABLE (ScreenId INT, ScreenName VARCHAR(100))                                                    

		insert into @ScreenIds (ScreenId, ScreenName)
		select distinct s.ScreenId, s.ScreenName
		from Screens s 
		WHERE isnull(s.RecordDeleted, 'N') = 'N'  
		EXCEPT 		
		(select s.ScreenId, s.ScreenName  
		  from Screens s  
			   join DocumentCodes dc on dc.DocumentCodeId = s.DocumentCodeId  
		 where isnull(dc.RecordDeleted, 'N') = 'N'  
		   and isnull(s.RecordDeleted, 'N') = 'N'  
		   and not exists(select *  
							from ViewStaffPermissions p  
						   where p.StaffId = @StaffId  
							 and p.PermissionItemId = dc.DocumentCodeId  
							 and p.PermissionTemplateType = 5702)  
		union  
		select s.ScreenId, s.ScreenName  
		  from Screens s  
			   join Banners b on b.ScreenId = s.ScreenId  
		 where isnull(b.RecordDeleted, 'N') = 'N'  
				AND b.Active='Y'			-- 08 Jun 2016     Avi Goyal
		   and isnull(s.RecordDeleted, 'N') = 'N'  
		   and ((@LoggedInUserId = @StaffId and   
				 not exists(select *  
							 from ViewStaffPermissions p  
							where p.StaffId = @LoggedInUserId  
							  and p.PermissionItemId = b.BannerId  
							  and p.PermissionTemplateType = 5703)) or  
				(@LoggedInUserId <> @StaffId and -- Supervisor view  
				 not exists(select *  
							 from ViewStaffRoleSupervisorPermissions p  
							where p.StaffId = @LoggedInUserId  
							  and p.PermissionItemId = b.BannerId  
							  and p.PermissionTemplateType = 5703))) ) 

	--Home Page
	SELECT distinct A.ScreenId, A.ScreenName
	FROM @ScreenIds A
	INNER JOIN Banners B ON A.ScreenId = B.ScreenId
	WHERE B.TabId = 1 --Office
	AND ISNULL(B.RecordDeleted,'N')='N' 
	AND B.Active = 'Y'
	order by A.ScreenName
	
	--Client Page Preference    
	--SELECT distinct A.ScreenId, A.ScreenName
	--FROM @ScreenIds A
	--INNER JOIN Banners B ON A.ScreenId = B.ScreenId
	--WHERE B.TabId = 2 --Client
	--AND ISNULL(B.RecordDeleted,'N')='N'
	--AND B.Active = 'Y' 
	--order by A.ScreenName
	
	--HardCoding only CLientAccount,Summary and Information for Client Page Preferences
	--Need to be done based on Alternate screen id.
	
	SELECT distinct A.ScreenId, A.ScreenName
	FROM @ScreenIds A
	INNER JOIN Banners B ON A.ScreenId = B.ScreenId
		--AVOSS
	JOIN ViewStaffPermissions p ON p.StaffId = @LoggedInUserId and p.PermissionItemId = b.BannerId and p.PermissionTemplateType = 5703
	WHERE B.TabId = 2 --Client
	AND ISNULL(B.RecordDeleted,'N')='N'
	AND B.Active = 'Y'
	--AND B.ScreenId in(321,3,19,370,388) 
	order by A.ScreenName
                               
    --All screens user has permissions to
    SELECT distinct S.ScreenId,T.TabOrder, T.DisplayAs + ' - ' + S.ScreenName AS BannerScreen
    FROM @ScreenIds S  
	INNER JOIN Banners B ON S.ScreenId = B.ScreenId 
	INNER JOIN Tabs T ON B.TabId = T.TabId 
	WHERE  ISNULL(B.RecordDeleted,'N')='N' AND
	 ISNULL(T.RecordDeleted,'N')='N' 
	 AND B.Active = 'Y'
	ORDER BY T.TabOrder, BannerScreen
			
    --Preferred Prescribing Location
    SELECT NULL AS LocationId,                                   
	'' AS LocationName                                           
	UNION                                    
    SELECT L.LocationId, L.LocationName
    FROM Locations AS L INNER JOIN 
    StaffLocations AS SL on L.LocationId=SL.LocationId AND ISNULL(SL.RecordDeleted,'N') = 'N'    
    WHERE 
     L.Active = 'Y'
    AND ISNULL(L.RecordDeleted,'N') = 'N' AND SL.StaffId=@StaffId
                        
	--QuickActions

    SELECT distinct S.ScreenId,T.TabOrder, T.DisplayAs + ' - ' + S.ScreenName AS BannerScreen
    FROM @ScreenIds S  
	INNER JOIN Banners B ON S.ScreenId = B.ScreenId 
	INNER JOIN Tabs T ON B.TabId = T.TabId 
	WHERE  ISNULL(B.RecordDeleted,'N')='N' AND
	 ISNULL(T.RecordDeleted,'N')='N' 
	 AND B.TabId <> 2 --Excluding Client Tab     
	 AND B.Active = 'Y'
	ORDER BY T.TabOrder, BannerScreen
	
	END TRY
              
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMStaffDetailInitData')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH 
	RETURN

END


GO


