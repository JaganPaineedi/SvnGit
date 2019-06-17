IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMSystemConfiguration]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMSystemConfiguration]
GO

CREATE PROCEDURE [dbo].[ssp_PMSystemConfiguration]
/********************************************************************************                                                  
-- Stored Procedure: ssp_PMSystemConfiguration
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: Procedure to return data for the System Configurations page.
--
-- Author:  Girish Sanaba
-- Date:    19 July 2011
--
-- *****History****
-- 24 Aug 2011 Girish Removed References to Rowidentifier and/or ExternalReferenceId
-- 27 Aug 2011 Girish Readded References to Rowidentifier 

-- 27th Jan 2012 Shruthi.S RecordDeleted Check added for ReceptionViewLocations,ReceptionViewPrograms,ReceptionViewStaff all these tables.
-- 21 Dec 2014 Avi Goyal	What : Added Types & removed RowIdentifier
						 	Why : Task 614 of Network-180 Customizations
-- 27 July 2015 Arjun K R   Remove the code which convert 'AllTypes' Columns values to 'N' if its value is NULL. Task #63 Keypoint Env Issues Tracking.
*********************************************************************************/
	
AS
BEGIN                                                              
	BEGIN TRY
	
/*****************	ReceptionViewLocations ********************************/

	SELECT ReceptionViewLocationId,
			ReceptionViewId,
			LocationId,
			RowIdentifier,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate,
			RecordDeleted,
			DeletedDate,
			DeletedBy
	FROM
			ReceptionViewLocations
    WHERE
		   (RecordDeleted='N' OR RecordDeleted IS NULL)

	/*****************	ReceptionViewPrograms ********************************/
	SELECT ReceptionViewProgramId,
			ReceptionViewId,
			ProgramId,
			RowIdentifier,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate,
			RecordDeleted,
			DeletedDate,
			DeletedBy
	FROM
			ReceptionViewPrograms
    WHERE 
           (RecordDeleted='N' OR RecordDeleted IS NULL)			
				
	/**********ReceptionViewStaff******************/
	SELECT ReceptionViewStaffId,
			ReceptionViewId,
			StaffId,
			RowIdentifier,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate,
			RecordDeleted,
			DeletedDate,
			DeletedBy
	FROM
			ReceptionViewStaff	
    WHERE 
           (RecordDeleted='N' OR RecordDeleted IS NULL)	
           
           	
   -- Added by Avi Goyal, on 21 Dec 2014         
    /**********ReceptionViewTypes******************/
	SELECT ReceptionViewTypeId,
			ReceptionViewId,
			Type,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate,
			RecordDeleted,
			DeletedDate,
			DeletedBy
	FROM ReceptionViewTypes	
    WHERE  (RecordDeleted='N' OR RecordDeleted IS NULL)				
			
/*****************	ReceptionViewsDisplay ********************************/		

	SELECT 
		ReceptionViewId,
		ViewName,
		AllLocations,
		AllPrograms,
		AllStaff,
		CreatedBy,CreatedDate,
		ModifiedBy,ModifiedDate,
		RecordDeleted,DeletedDate,
		DeletedBy,
		AllLocationsDisplay =
		CASE 
			
			WHEN AllLocations = 'Y' THEN 'All'		
			ELSE  CASE   ---'Some'				
					WHEN EXISTS(select * from ReceptionViewLocations L WHERE (L.RecordDeleted='N' OR L.RecordDeleted IS NULL) AND R.ReceptionViewId=L.ReceptionViewId)THEN 'Some'				
					ELSE 'None'				
				  END
			        
			
		END,
		
		AllProgramsDisplay =
		CASE
		 
			WHEN AllPrograms = 'Y' THEN 'All'
			ELSE CASE   --'Some'		
						WHEN EXISTS(select * from ReceptionViewPrograms P WHERE (P.RecordDeleted='N' OR P.RecordDeleted IS NULL) AND R.ReceptionViewId=P.ReceptionViewId) THEN 'Some'
						ELSE 'None'
				 ENd
		END,
		
		AllStaffDisplay =
		CASE 
			WHEN AllStaff = 'Y' THEN 'All'
			ELSE CASE --'Some'
			WHEN EXISTS(select * from ReceptionViewStaff S WHERE (S.RecordDeleted='N' OR S.RecordDeleted IS NULL) AND R.ReceptionViewId=S.ReceptionViewId)THEN 'Some'
			ELSE 'None'
			END
		END,
		-- Added by Avi Goyal, on 21 Dec 2014 
		--ISNULL(AllTypes,'N') AS AllTypes,  -- Commented By Arjun K R 27 July 2015
		AllTypes,
		AllTypesDisplay =
		CASE
		 
			WHEN AllTypes = 'Y' THEN 'All'
			ELSE CASE   --'Some'		
						WHEN EXISTS(select * from ReceptionViewTypes T WHERE (T.RecordDeleted='N' OR T.RecordDeleted IS NULL) AND R.ReceptionViewId=T.ReceptionViewId) THEN 'Some'
						ELSE 'None'
				 END
		END
	FROM
		ReceptionViews R
		WHERE
		(RecordDeleted='N' OR RecordDeleted IS NULL)
		ORDER BY ViewName
	    
				
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMSystemConfiguration')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
END


GO


