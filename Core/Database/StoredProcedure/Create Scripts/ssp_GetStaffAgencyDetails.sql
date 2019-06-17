/****** Object:  StoredProcedure [dbo].[ssp_GetStaffAgencyDetails]    Script Date: 07/12/2017 11:30:01 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetStaffAgencyDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetStaffAgencyDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetStaffAgencyDetails]    Script Date: 07/12/2017 11:30:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/********************************************************************************                                                                        
-- Stored Procedure: dbo.ssp_GetStaffAgencyDetails.sql                                                                          
--                                                                        
-- Copyright: Streamline Healthcate Solutions                                                                        
--                                                                        
-- Purpose: used to get client HealthData and Graph details              
--                                                                        
-- Updates:                                                                                                                               
-- Date          Author          Purpose                                                                        

--02-27-2017 Mrunali Patil  	What : To retrive data for matching staff names and agency names    
--							    Why  : Network 180 - Customizations Task#115

 Author			Modified Date			Reason      
 Mrunali P  	Apr/24/2017				Purpose : Network 180 - Customizations Task#115 (removed the staff ID or agency ID next to the name in the last reviewed by field )
--Lakshmi       04/05/207               Added like condition to provider firstname as per the task 	Network180 Support Go Live #210
--Shankha       07/07/2017              Network180 Support Go Live #297: Removed parentheses and ordered the search result alphabetically
--Vinod         14/12/2017              Network180 Support Go Live #297: Added parentheses selecting condition.Changed Select Cloumn as  'S.DisplayAS' Instead of 'S.LastName + ', ' + S.FirstName'
.   
*********************************************************************************/
CREATE PROCEDURE [dbo].[ssp_GetStaffAgencyDetails] @staffNameToSearch VARCHAR(Max)
AS
BEGIN
	BEGIN TRY
		IF (@staffNameToSearch <> '')
		BEGIN
			SELECT S.StaffId AS LastReviewedById
				--,('(' + S.FirstName + ' ' + S.LastName +  ')') AS LastReviewedByName
				--,S.LastName + ', ' + S.FirstName AS LastReviewedByName
				,S.DisplayAS AS LastReviewedByName   --Vinod         14/12/2017
			FROM Staff S
			INNER JOIN staffroles SR ON SR.StaffId = S.StaffId
				AND ISNULL(SR.RecordDeleted, 'N') = 'N'
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
				AND ISNULL(S.Active, 'N') = 'Y'
			INNER JOIN PermissionTemplates PT ON PT.RoleId = SR.RoleId
				AND ISNULL(PT.RecordDeleted, 'N') = 'N'
			INNER JOIN PermissionTemplateItems PTI ON PTI.PermissionTemplateId = PT.PermissionTemplateId
				AND ISNULL(PTI.RecordDeleted, 'N') = 'N'
			WHERE PTI.PermissionItemId = 5731 -- Category 'STAFFLIST'  CodeName 'UMCaseManager'
				AND (S.FirstName + ' ' + S.LastName LIKE ('%' + @staffNameToSearch + '%')
				OR S.DisplayAS LIKE ('%' + @staffNameToSearch + '%'))
			
			UNION
			
			SELECT DISTINCT P.ProviderId AS LastReviewedById
				--,('(' + P.ProviderName +  ')') AS LastReviewedByName
				,P.ProviderName AS LastReviewedByName
			FROM Providers P
			INNER JOIN StaffProviders SP ON P.ProviderId = SP.ProviderId
				AND ISNULL(SP.RecordDeleted, 'N') = 'N'
			WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.Active, 'N') = 'Y'
				AND P.ProviderName LIKE '%' + @staffNameToSearch + '%'
			ORDER BY LastReviewedByName
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetStaffAgencyDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + 
			'*****' + CONVERT(VARCHAR, ERROR_STATE())

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


