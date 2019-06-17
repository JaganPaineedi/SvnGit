IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_TriageArrivalDetailById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_TriageArrivalDetailById]
GO
/********************************************************************************                                                    
-- Stored Procedure: ssp_TriageArrivalDetailById
-- Copyright: Streamline Healthcate Solutions
-- Purpose: Procedure to return data for the Reception Triage Arrival Details page on basis of given Id.
-- Author:  Avi Goyal
-- Date:    08 Dec 2014  
-- *****History****  
-- Date				Author			Purpose
---------------------------------------------------------------------------------
-- 08 Dec 2014		Avi Goyal		What :Created 
									Why: Task 614 Walk-Ins-Customer Flow of Network 180 - Custmizations
--29 Aug 2016		Basudev Sahu	What : Removed order by time for walk in  for Arrival Details Page.
									Why : Task #369 Network 180 Environment Issues Tracking .
*********************************************************************************/  
CREATE PROCEDURE [dbo].[ssp_TriageArrivalDetailById]
    @TriageArrivalDetailID INT   
AS 
BEGIN  
	BEGIN TRY  
		SELECT  
			RTAD.TriageArrivalDetailId,
			RTAD.CreatedBy,
			RTAD.CreatedDate,
			RTAD.ModifiedBy,
			RTAD.ModifiedDate,
			RTAD.RecordDeleted,
			RTAD.DeletedBy,
			RTAD.DeletedDate,    
			RTAD.ClientId,
			RTAD.StaffId,
			RTAD.LocationId,
			RTAD.ClientFirstName,
			RTAD.ClientLastName,
			RTAD.ClientDOB,
			RTAD.AddressLine1,
			RTAD.AddressLine2,
			RTAD.Homeless,
			RTAD.City,
			RTAD.[State],
			RTAD.Zip,
			RTAD.Phone,
			StartDate,
			RTAD.ProcedureId,
			RTAD.[Status],
			RTAD.Comments,
			RTAD.SSN	
		FROM TriageArrivalDetails RTAD
		--INNER JOIN Clients C ON C.ClientId=A.ClientId
		WHERE RTAD.TriageArrivalDetailId = @TriageArrivalDetailId
		
		
		SELECT  
			TADSH.TriageArrivalDetailStatusHistoryId,
			TADSH.CreatedBy,
			TADSH.CreatedDate,
			TADSH.ModifiedBy,
			TADSH.ModifiedDate,
			TADSH.RecordDeleted,
			TADSH.DeletedBy,
			TADSH.DeletedDate,
			TADSH.TriageArrivalDetailId,
			TADSH.LocationId,
			TADSH.StaffId,
			S.DisplayAs AS StaffName,
			TADSH.StartDate,
			TADSH.ProcedureId,
			TADSH.[Status],
			GCStatus.CodeName AS StatusText,
			TADSH.[Time] 
			
		FROM TriageArrivalDetailStatusHistory TADSH
		--INNER JOIN Clients C ON C.ClientId=A.ClientId
		LEFT JOIN Staff S ON S.StaffId=TADSH.StaffId
		LEFT JOIN GlobalCodes GCStatus ON GCStatus.GlobalCodeId=TADSH.[Status]
		WHERE TADSH.TriageArrivalDetailId = @TriageArrivalDetailId AND ISNULL(TADSH.RecordDeleted,'N')='N'
		--ORDER BY TADSH.[Time] ASC  -- Removed by Basudev for task #369 Network 180 Environment Issues Tracking
		
	END TRY 
    BEGIN CATCH                                
		DECLARE @Error VARCHAR(8000)                                                                          
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                       
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_TriageArrivalDetailById')                                                                                                           
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