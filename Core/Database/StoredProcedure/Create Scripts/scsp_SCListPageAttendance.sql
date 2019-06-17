
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCListPageAttendance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCListPageAttendance]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_SCListPageAttendance]  
(  
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@Date DATETIME
	,@ProgramId INT
	,@StaffId INT
	,@GroupId INT
	,@NoteType INT
	,@OtherFilter INT
	,@CurrentUserId INT = NULL
)  
 
/********************************************************************************    
-- Stored Procedure: dbo.scsp_SCListPageAttendance      
--    
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 11-May-2015	 Akwinass		What:Used in ssp_SCListPageAttendance.          
--								Why:task  #915 Valley - Customizations
-- 06-Aug-2015	 Akwinass		What:Checked Out Column Changes Included.       
-- 								Why:Task #829.09 in Woods - Customizations
-- 30-OCT-2015	 Akwinass	    What:ServiceCount column included.
--								Why:Task #17 in Valley - Support Go Live
-- 22-Feb-2016	  Akwinass	    What:Included @CurrentUserId
--							    Why:task #167 Valley - Support Go Live
-- 13-APRIL-2016  Akwinass	    What:Included GroupNoteType Column.          
							    Why:task #167.1 Valley - Support Go Live
*********************************************************************************/   
AS
BEGIN  
SELECT TOP 0 NULL AS ServiceId
	,NULL AS ClientId
	,NULL AS ClientName
	,NULL AS StaffId
	,NULL AS Staff
	,NULL AS GroupId
	,NULL AS GroupName
	,NULL AS ProgramId
	,NULL AS ProgramCode
	,NULL as ClientFeeType
	,NULL AS BannerDetails
	,NULL AS NextMedDue
	,NULL AS NextAppointment
	,NULL AS LocationCode
	,NULL AS ColorCode
	,NULL AS GroupServiceId
	,NULL AS CheckInTime
	,NULL AS CheckOutTime
	,NULL AS ServiceStatus
	,NULL AS CancelReason
	,NULL AS AttendanceScreenId
	,NULL AS GroupNoteType
	,NULL AS GroupNoteDocumentCodeId
	,NULL AS ServiceCount
	,NULL AS DocumentSigned
END
GO
