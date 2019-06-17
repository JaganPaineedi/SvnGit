/****** Object:  StoredProcedure [dbo].[ssp_SCWebBedBoardUpdateUpdateVisitDetails]    Script Date: 03/06/2014 19:22:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebBedBoardUpdateUpdateVisitDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebBedBoardUpdateUpdateVisitDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCWebBedBoardUpdateUpdateVisitDetails]    Script Date: 03/06/2014 19:22:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SCWebBedBoardUpdateUpdateVisitDetails] @emergencyroomarrivaldate VARCHAR(50)
    ,@emergencyroomdeparture VARCHAR(50)
	,@admitdecisiondate VARCHAR(50)	
	,@clienttype INT
	,@clientinpatientvisitid INT
	,@drgcode VARCHAR(20)
	,@admissiontype INT
	,@dischargetype INT
	,@admissionsource INT 
	,@bedprocedurecodeid INT
	,@leaveprocedurecodeid INT
	,@usercode VARCHAR(30)
	/********************************************************************************                                                
-- Copyright: Streamline Healthcate Solutions LLC                                           
--                                                
-- Purpose: Update Update Visit Details                                            
--                                                
-- Updates:                                                                                                       
-- Date           Author     Details    
-- 17-09-2013     Akwinass   Created.    
-- 09-Jan-2014    Akwinass   DRGCode Added as per #1343 in Core Bugs.      
-- 30-Jan-2014    Akwinass   AdmissionType Added as per #139 in Philhaven Development.    
-- 06-Mar-2014    Akwinass   DischargeType Added as per #150 in Philhaven Development. 
-- 21-Oct-2014    Akwinass   EmergencyRoomDeparture Added as per #51 in Meaningful Use.  
-- 03-Sep-2015    MD Khusro  Added new parameter "@admissionsource" and update statement w.r.t core bugs #1880
-- 01-AUG-2016    Akwinass   What : Added BedProcedureCodeId,LeaveProcedureCodeId in select statement
--							 Why : Woods - Support Go Live #43                                    
*********************************************************************************/
AS
BEGIN TRY
		UPDATE ClientInpatientVisits
		SET ClientType = CASE WHEN @clienttype = 0 THEN NULL ELSE @clienttype END
			,EmergencyRoomArrival = CASE WHEN @emergencyroomarrivaldate = '' THEN NULL ELSE @emergencyroomarrivaldate END
			,AdmitDecision = CASE WHEN @admitdecisiondate = '' THEN NULL ELSE @admitdecisiondate END
			,DRGCode = CASE WHEN @drgcode = '' THEN NULL ELSE @drgcode END
			,AdmissionType = CASE WHEN @admissiontype = 0 THEN NULL ELSE @admissiontype END
			-- 03-Sep-2015    MD Khusro
			,AdmissionSource = CASE WHEN @admissionsource = 0 THEN NULL ELSE @admissionsource END
			,DischargeType = CASE WHEN @dischargetype = 0 THEN NULL ELSE @dischargetype END
			,EmergencyRoomDeparture = CASE WHEN @emergencyroomdeparture = '' THEN NULL ELSE @emergencyroomdeparture END
			-- 01-AUG-2016    Akwinass
			,BedProcedureCodeId = CASE WHEN @bedprocedurecodeid = 0 THEN NULL ELSE @bedprocedurecodeid END
			,LeaveProcedureCodeId = CASE WHEN @leaveprocedurecodeid = 0 THEN NULL ELSE @leaveprocedurecodeid END
			,ModifiedBy = @usercode
			,ModifiedDate = CURRENT_TIMESTAMP
		WHERE ClientInpatientVisitId = @clientinpatientvisitid
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWebBedBoardUpdateUpdateVisitDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                        
			16
			,-- Severity.                        
			1 -- State.                        
			);
END CATCH


GO


