/****** Object:  StoredProcedure [dbo].[ssp_SCInsertUpdateBedAttendances]    Script Date: 03/14/2014 14:01:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCInsertUpdateBedAttendances]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCInsertUpdateBedAttendances]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCInsertUpdateBedAttendances]    Script Date: 03/14/2014 14:01:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCInsertUpdateBedAttendances] @ListOfDataToSave VARCHAR(MAX)
	,@AttendanceDate DATETIME
	,@CurrentUser VARCHAR(100)
AS
/********************************************************************************                                                    
  -- Stored Procedure: [ssp_SCInsertUpdateBedAttendances]       
  --       
  -- Copyright: Streamline Healthcate Solutions       
  --       
  -- Purpose: To save Bed Attendances       
  --       
  -- Updates:                                                                                             
  -- Date        Author            Purpose                                          
  -- 24 Jun 2012    Deej Kumar        BedAttendance Pop up Save to Bed Attendance.        
  -- 25 Jun 2012    Malathi Shiva     Save to Service Table.        
  -- 28 Jun 2012    Malathi Shiva     Save to BedAssignmentServices  
  -- 13 Jan 2014    Akwinass          Instead of sp_xml_preparedocument/sp_xml_removedocument normal xml selection implemented 
  -- 14-Mar-2014    Akwinass          Included where condition to update @table
  -- 10-July-2014   Akwinass          Task #1546 in Core Bugs (Leave Procedure Code is used to Update On Leave Bed Assignment).
  -- 14-July-2014   Akwinass          Task #1537 in Core Bugs ('AttendanceDate' Column Included).
  -- 21-JAN-2016    Akwinass          Task #2227 in Core Bugs ('ClientInpatientVisits' status update Included).
  -- 07-April-2016  Akwinass          "Hold Bed" included by default for "On Leave" action (Task #11 in Woods - Support Go Live).
  -- 15-JUNE-2016   Akwinass          Discharge check implemented to avoid creating new records (Task #42 in Woods - Support Go Live).
  -- 01-AUG-2016    Akwinass		  What : Modified the logic using system configuration key 'BEDASSIGNMENTRETAINPROCEDURECODE'
									  Why : Woods - Support Go Live #43
  -- 22-AUG-2016    Akwinass		  What : Changed system configuration key name from 'BEDASSIGNMENTRETAINPROCEDURECODE' to 'RETAINBEDASSIGNMENTPROCEDURECODE'.
									  Why : Woods - Support Go Live #43
  -- 11/16/2017     Hemant            What:Included the distinct keyword tofix the duplication issue and 
                                           replaced @@identity with scope_identity()
                                      Why:The CreateDate and modifiedDate are exactly the same on the n records and a situation where the scope_identity() and the @@identity functions differ, is if you
                                          have a trigger on the table. If you have a query that inserts a record, causing the trigger 
                                          to insert another record somewhere, the scope_identity() function will return the identity 
                                          created by the query, while the @@identity function will return the identity created by the trigger.
                                          So, normally we would use the scope_identity() function.	
                                      Project:Woods - Support Go Live: #758	
  -- 09-April-2018   Sachin           What : Calling to scsp_SCInsertUpdateBedAttendances which is newly created for Custom AspenPointe.
									  Why  : AspenPointe - Support Go Live #730.1 					  
  *********************************************************************************/
BEGIN
	BEGIN TRY	
	
	  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCInsertUpdateBedAttendances]'))
	    Begin
	          EXEC scsp_SCInsertUpdateBedAttendances @ListOfDataToSave 
													,@AttendanceDate 
													,@CurrentUser 
			 return
	    END	
	   	
		DECLARE @doc INT
		DECLARE @RETAINPROCEDURECODE VARCHAR(10)
		DECLARE @BedLeaveProcedureCodeId INT = NULL
		DECLARE @BedProcedureCodeId INT = NULL
		DECLARE @BedLocationId INT = NULL
		SELECT TOP 1 @RETAINPROCEDURECODE = Value
		FROM SystemConfigurationKeys
		WHERE [Key] = 'RETAINBEDASSIGNMENTPROCEDURECODE'
			AND ISNULL(RecordDeleted, 'N') = 'N'			

		DECLARE @STable TABLE (
			Id INT
			,clientid INT
			)
		DECLARE @table TABLE (
			BedAttendanceId INT
			,BedAssignmentId INT
			,UniqueRowIdentity VARCHAR(100)
			,Present VARCHAR(30)
			,LeaveReason INT
			,UserCode VARCHAR(30)
			,ClientId INT
			,ProcedureCodeId INT
			,StartDate DATETIME
			,ProgramId INT
			-- 14-July-2014   Akwinass
			,AttendanceDate DATETIME
			)		
		
		--13-Jan-2014 Instead of sp_xml_preparedocument/sp_xml_removedocument normal xml selection implemented 
		DECLARE @VarcharArg XML

		SET @VarcharArg = cast(@ListOfDataToSave AS XML)

		INSERT INTO @table
		--Hemant 11/16/2017  
		SELECT Distinct CASE 
				WHEN p.value('(./BedAttendanceId)[1]', 'VARCHAR(50)') = ''
					THEN NULL
				ELSE p.value('(./BedAttendanceId)[1]', 'VARCHAR(50)')
				END AS BedAttendanceId
			,p.value('(./BedAssignmentId)[1]', 'VARCHAR(100)') AS BedAssignmentId
			,p.value('(./UniqueRowIdentity)[1]', 'VARCHAR(100)') AS UniqueRowIdentity
			,p.value('(./Present)[1]', 'VARCHAR(100)') AS Present
			,CASE 
				WHEN p.value('(./LeaveReason)[1]', 'VARCHAR(100)') = ''
					THEN NULL
				ELSE p.value('(./LeaveReason)[1]', 'VARCHAR(100)')
				END AS LeaveReason
			,p.value('(./UserCode)[1]', 'VARCHAR(100)') AS UserCode
			,p.value('(./ClientId)[1]', 'VARCHAR(100)') AS ClientId
			,p.value('(./ProcedureCodeId)[1]', 'VARCHAR(100)') AS ProcedureCodeId
			,p.value('(./StartDate)[1]', 'VARCHAR(100)') AS StartDate
			,p.value('(./ProgramId)[1]', 'VARCHAR(100)') AS ProgramId
			-- 14-July-2014   Akwinass
			,CASE 
				WHEN p.value('(./AttendanceDate)[1]', 'VARCHAR(100)') = ''
					THEN NULL
				ELSE p.value('(./AttendanceDate)[1]', 'VARCHAR(100)')
				END AS AttendanceDate
		FROM @VarcharArg.nodes('/ArrayOfDataToSave/dataToSave') t(p)
		ORDER BY BedAssignmentId

		DECLARE @ClientInpatientVisitId INT
			,@BedAssignmentId INT
			,@BedId INT
			,@StartDate DATETIME
			,@EndDate DATETIME
			,@Status INT
			,@ProgramId INT
			,@LocationId INT
			,@ProcedureCodeId INT
			,@BedNotAvailable CHAR(1)
			,@NotBillable CHAR(1)
			,@Overbooked CHAR(1)
			,@LeaveReason INT
			,@LeaveBillable CHAR(1)
			,@LeaveBedHold CHAR(1)
			,@LeaveProcedureCodeId INT
		DECLARE @NextBedAssignmentId INT
		DECLARE @NewStatus INT

		-- In case no change in status of leave, update leave reason   
		UPDATE a
		SET Reason = b.LeaveReason
			,ModifiedBy = @CurrentUser
			,ModifiedDate = GETDATE()
		FROM BedAssignments a
		JOIN @table b ON (a.BedAssignmentId = b.BedAssignmentId)
		WHERE a.Status = 5006
			AND b.Present = 'N'
			AND b.LeaveReason IS NOT NULL

		-- Create New Bed Assignments for ones marked as Leave  
		DECLARE cur_BedAttendance CURSOR
		FOR
		SELECT a.ClientInpatientVisitId
			,a.BedAssignmentId
			,a.BedId
			,a.StartDate
			,a.EndDate
			,a.Status
			,a.ProgramId
			,a.LocationId
			,a.ProcedureCodeId
			,a.BedNotAvailable
			,a.NotBillable
			,a.Overbooked
			,b.LeaveReason
			,c.Billable
			,c.BedHold
			,b.ProcedureCodeId
		FROM BedAssignments a
		JOIN @table b ON (a.BedAssignmentId = b.BedAssignmentId)
		LEFT JOIN BedLeaveReasons c ON (b.LeaveReason = c.BedLeaveReasonId)
		WHERE ISNULL(a.Disposition,0) <> 5205 AND ((a.Status = 5002 AND b.Present = 'N') OR (a.Status <> 5002 AND b.Present = 'Y'))
		

		OPEN cur_BedAttendance

		FETCH cur_BedAttendance
		INTO @ClientInpatientVisitId
			,@BedAssignmentId
			,@BedId
			,@StartDate
			,@EndDate
			,@Status
			,@ProgramId
			,@LocationId
			,@ProcedureCodeId
			,@BedNotAvailable
			,@NotBillable
			,@Overbooked
			,@LeaveReason
			,@LeaveBillable
			,@LeaveBedHold
			,@LeaveProcedureCodeId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- If current status is Occupied, create a leave record  
			IF @Status = 5002
			BEGIN
				SET @NewStatus = 5006
				
				-- 10-July-2014   Akwinass
				SET @BedLeaveProcedureCodeId = NULL
				-- 01-AUG-2016 Akwinass
				SELECT TOP 1 @BedLeaveProcedureCodeId = BAH.LeaveProcedureCodeId
				FROM dbo.BedAvailabilityHistory BAH
				JOIN dbo.Programs P ON (P.ProgramId = BAH.ProgramId)
				JOIN dbo.Beds B ON (B.BedId = BAH.BedId)
				WHERE BAH.BedId = @BedId
					AND (ISNULL(BAH.RecordDeleted, 'N') = 'N')
					AND (BAH.EndDate IS NULL OR BAH.EndDate > GETDATE())
				ORDER BY BAH.BedAvailabilityHistoryId DESC
					
				IF ISNULL(@RETAINPROCEDURECODE,'') = 'Y'
				BEGIN
					SELECT TOP 1 @BedLeaveProcedureCodeId = LeaveProcedureCodeId
					FROM ClientInpatientVisits					
					WHERE ClientInpatientVisitId = @ClientInpatientVisitId
						AND (ISNULL(RecordDeleted, 'N') = 'N')
				END
				
				IF @BedLeaveProcedureCodeId IS NULL
				BEGIN
					SET @BedLeaveProcedureCodeId = @LeaveProcedureCodeId
				END


				INSERT INTO BedAssignments (
					ClientInpatientVisitId
					,BedId
					,StartDate
					,EndDate
					,Status
					,ProgramId
					,LocationId
					,ProcedureCodeId
					,BedNotAvailable
					,NotBillable
					,Reason
					,Overbooked
					,CreatedBy
					,ModifiedBy
					)
				VALUES (
					@ClientInpatientVisitId
					,@BedId
					,@AttendanceDate
					,@EndDate
					,@NewStatus
					,@ProgramId
					,@LocationId
					,@BedLeaveProcedureCodeId
					-- 07-April-2016  Akwinass
					,'Y'
					,CASE 
						WHEN ISNULL(@LeaveBillable, 'N') = 'Y'
							THEN 'N'
						ELSE 'Y'
						END
					,@LeaveReason
					,@Overbooked
					,@CurrentUser
					,@CurrentUser
					)

				SET @NextBedAssignmentId = SCOPE_IDENTITY() --Hemant 11/16/2017  

				-- Update occupied bed assignment id  
				UPDATE BedAssignments
				SET NextBedAssignmentId = @NextBedAssignmentId
					,EndDate = @AttendanceDate
					,Disposition = 5204
					,-- Went On Leave  
					ModifiedBy = @CurrentUser
					,ModifiedDate = GETDATE()
				WHERE BedAssignmentId = @BedAssignmentId
				
				-- 19-JAN-2014    Akwinass
				-- Update client inpatient visits status as "On Leave"
				UPDATE ClientInpatientVisits
				SET [Status] = 4983
					,ModifiedBy = @CurrentUser
					,ModifiedDate = GETDATE()
				WHERE ClientInpatientVisitId = @ClientInpatientVisitId
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END
					-- If current status is On Leave, create an occupied record 
			ELSE IF @Status = 5006
			BEGIN
				SET @NewStatus = 5002
				SET @BedProcedureCodeId = NULL
				SET @BedLocationId = NULL

				SELECT TOP 1 @BedProcedureCodeId = BAH.ProcedureCodeId
					,@BedLocationId = BAH.LocationId
				FROM dbo.BedAvailabilityHistory BAH
				JOIN dbo.Programs P ON (P.ProgramId = BAH.ProgramId)
				JOIN dbo.Beds B ON (B.BedId = BAH.BedId)
				WHERE BAH.BedId = @BedId
					AND (ISNULL(BAH.RecordDeleted, 'N') = 'N')
					AND (BAH.EndDate IS NULL OR BAH.EndDate > GETDATE())
				ORDER BY BAH.BedAvailabilityHistoryId DESC

				
				-- 01-AUG-2016 Akwinass
				IF ISNULL(@RETAINPROCEDURECODE,'') = 'Y'
				BEGIN					
					SELECT TOP 1 @BedProcedureCodeId = BedProcedureCodeId
					FROM ClientInpatientVisits					
					WHERE ClientInpatientVisitId = @ClientInpatientVisitId
						AND (ISNULL(RecordDeleted, 'N') = 'N')
				END

				INSERT INTO BedAssignments (
					ClientInpatientVisitId
					,BedId
					,StartDate
					,EndDate
					,Status
					,ProgramId
					,LocationId
					,ProcedureCodeId
					,BedNotAvailable
					,NotBillable
					,Reason
					,Overbooked
					,CreatedBy
					,ModifiedBy
					)
				SELECT TOP 1 @ClientInpatientVisitId
					,@BedId
					,@AttendanceDate
					,@EndDate
					,@NewStatus
					,@ProgramId
					,CASE WHEN @BedLocationId IS NULL THEN @LocationId ELSE @BedLocationId END
					,CASE WHEN @BedProcedureCodeId IS NULL THEN ProcedureCodeId ELSE @BedProcedureCodeId END
					,NULL
					,NULL
					,NULL
					,@Overbooked
					,@CurrentUser
					,@CurrentUser
				FROM BedAvailabilityHistory
				WHERE BedId = @BedId
					AND StartDate <= @AttendanceDate
					AND (
						EndDate IS NULL
						OR EndDate > @AttendanceDate
						)
					AND ISNULL(RecordDeleted, 'N') = 'N'

				SET @NextBedAssignmentId = SCOPE_IDENTITY() --Hemant 11/16/2017  

				-- Update occupied bed assignment id  
				UPDATE BedAssignments
				SET NextBedAssignmentId = @NextBedAssignmentId
					,EndDate = @AttendanceDate
					,Disposition = 5206 -- Returned From leave  
				WHERE BedAssignmentId = @BedAssignmentId
				
				-- 19-JAN-2014    Akwinass
				-- Update client inpatient visits status as "Admitted"
				UPDATE ClientInpatientVisits
				SET [Status] = 4982
					,ModifiedBy = @CurrentUser
					,ModifiedDate = GETDATE()
				WHERE ClientInpatientVisitId = @ClientInpatientVisitId
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END			

			-- The Attendance information now applies to the New bed assignment id  
			UPDATE @table
			SET BedAssignmentId = @NextBedAssignmentId
			WHERE BedAssignmentId = @BedAssignmentId

			FETCH cur_BedAttendance
			INTO @ClientInpatientVisitId
				,@BedAssignmentId
				,@BedId
				,@StartDate
				,@EndDate
				,@Status
				,@ProgramId
				,@LocationId
				,@ProcedureCodeId
				,@BedNotAvailable
				,@NotBillable
				,@Overbooked
				,@LeaveReason
				,@LeaveBillable
				,@LeaveBedHold
				,@LeaveProcedureCodeId
		END

		CLOSE cur_BedAttendance

		DEALLOCATE cur_BedAttendance

		--INSERTING NEW RECORDS - Bedattendances    
		INSERT INTO Bedattendances (
			BedAssignmentId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,Present
			,BedLeaveReasonId
			,Processed
			,ServiceId
			,AttendanceDate
			)
		SELECT BedAssignmentId
			,@CurrentUser
			,GETDATE() AS CreatedDate
			,@CurrentUser
			,GETDATE() AS ModifiedDate
			,T.Present
			,T.LeaveReason
			,'N'
			,NULL
			-- 14-July-2014   Akwinass
			,T.AttendanceDate
		FROM @Table T
		WHERE BedAttendanceId IS NULL

		--UPDATING EXISTING RECORDS  -  Bedattendances  
		UPDATE A
		SET A.Present = B.Present
			,A.BedLeaveReasonId = B.LeaveReason
			,A.BedAssignmentId = B.BedAssignmentId
			-- 14-July-2014   Akwinass
			,A.AttendanceDate = B.AttendanceDate
			,A.ModifiedBy = @CurrentUser
			,A.ModifiedDate = GETDATE()
		FROM BedAttendances A
		INNER JOIN @table B ON A.BedAttendanceId = B.BedAttendanceId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCInsertUpdateBedAttendances') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.       
				16
				,-- Severity.       
				1 -- State.       
				);
	END CATCH

	RETURN
END

GO


