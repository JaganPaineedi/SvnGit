
/****** Object:  StoredProcedure [dbo].[ssp_PCCalendarEventById]    Script Date: 08/07/2012 15:03:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PCCalendarEventById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PCCalendarEventById]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
/*-- Author:		davinderk(copy and edit ssp created by - Wasif Butt 
-- Create date: 7-Aug-2012
-- Description:	Pulls appointment details for the wdcalendar
-- Task# - 7 - Scheduling - Primary Care - Summit Pointe 

03Oct2012		Rahul Aneja			Added  SpecificLocation  column in Appointments table
26/Oct/2012		Mamta Gupta			Added new column into table Appointments.NumberofTimeRescheduled
									To Count no of appointment rescheduling. Task No. 35 Primary Care - Summit Pointe */
/*12 Dec 2014   Varun               Added New Column ProgramId and removed RowIdentifier column Ref To Task#172 - Primary Care - Summit Pointe*/  
/*18 Dec 2014   Varun               Returning DocumenVersionId in Appointments Ref To Task#205 - Primary Care - Summit Pointe*/
/*23 Dec 2014   Varun               Added RowIdentifier in Appointments Ref To Task#172 - Primary Care - Summit Pointe*/  
/*16 Oct 2015	Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.       
									why:task #609, Network180 Customization    */
/*10 March 2016   Varun             Changed Inner Join to Left Join as Appointments were not getting returned if A.ClientId										is NULL Why: Task - Core Bugs #2037*/  
/*04 April 2017	  Suneel N			Added ServiceLinked in Appointments Ref To Task #692.06 Allegan - Support.*/
-- =============================================
CREATE PROCEDURE [dbo].[ssp_PCCalendarEventById]
	-- Add the parameters for the stored procedure here
    @AppointmentId INT   
AS 
BEGIN  
    BEGIN TRY  
			 Declare @DocumentVersionId int
			 set @DocumentVersionId= (select InProgressDocumentVersionId from Documents where AppointmentId= @AppointmentId  AND ISNULL(RecordDeleted,'N')<>'Y')
			SELECT  A.AppointmentId,
					A.StaffId,
					A.Subject,
					A.StartTime,
					A.EndTime,
					A.AppointmentType,
					A.Description,
					A.ShowTimeAs,
					A.ClientId,
					A.LocationId,
					A.ServiceId,
					A.GroupServiceId,
					A.AppointmentProcedureGroupId,
					A.RecurringAppointment,
					A.RecurringDescription,
					A.RecurringAppointmentId,
					A.RecurringServiceId,
					A.RecurringGroupServiceId,
					A.RecurringOccurrenceIndex,
					A.Status,
					A.CancelReason,
					A.ExamRoom,
					A.ClientWasPresent,
					A.OtherPersonsPresent,
					A.RowIdentifier,
					A.CreatedBy,
					A.CreatedDate,
					A.ModifiedBy,
					A.ModifiedDate,
					A.RecordDeleted,
					A.DeletedDate,
					A.DeletedBy,
					----Added by Revathi 16 Oct 2015         
			CASE 
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN rtrim(ISNULL(C.LastName, '')) + ', ' + rtrim(ISNULL(C.FirstName, ''))
				ELSE C.OrganizationName
				END AS ClientName
					,A.SpecificLocation -- Added by Rahul Aneja
					,A.NumberofTimeRescheduled --Added By Mamta Gupta
					,A.ProgramId
					,@DocumentVersionId AS DocumentVersionId
					,CASE WHEN ISNULL(D.ServiceId,'') = '' THEN 'N'
                     ELSE 'Y'
						END AS ServiceLinked
			--Varun: Changed Inner Join to Left Join as Appointments were not getting returned if A.ClientId is NULL 
			FROM    Appointments A LEFT JOIN clients C ON C.ClientId=A.ClientId  
			LEFT JOIN Documents D ON A.AppointmentId= D.AppointmentId  
			AND ISNULL(D.RecordDeleted,'N')<>'Y'
			WHERE   A.AppointmentId = @AppointmentId 
			
			
			SELECT  PCASH.PrimaryCareAppointmentsStatusHistoryId,
					PCASH.CreatedBy,
					PCASH.CreatedDate,
					PCASH.ModifiedBy,
					PCASH.ModifiedDate,
					PCASH.RecordDeleted,
					PCASH.DeletedDate,
					PCASH.DeletedBy,
					PCASH.PrimaryCareAppointmentId, 
					PCASH.Status,
					PCASH.Time,
					GC.CodeName 
			FROM    PrimaryCareAppointmentsStatusHistory PCASH INNER JOIN GlobalCodes GC ON GC.GlobalCodeId=PCASH.Status and GC.Category='PCAPPOINTMENTSTATUS'
					AND ISNULL(PCASH.RecordDeleted,'N')<>'Y' --AND PCASH.Status <> 8044
			WHERE   PrimaryCareAppointmentId = @AppointmentId ORDER BY PCASH.Time DESC  
			
        
    END TRY 
    BEGIN CATCH                                
		DECLARE @Error varchar(8000)                                                                          
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PCCalendarEventById')                                                                                                           
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
		+ '*****' + Convert(varchar,ERROR_STATE())                                                        
		RAISERROR                                                                                                           
		(                                                                             
		@Error, -- Message text.         
		16, -- Severity.         
		1 -- State.                                                           
		);                                                                                                        
	END CATCH  
		
 END


