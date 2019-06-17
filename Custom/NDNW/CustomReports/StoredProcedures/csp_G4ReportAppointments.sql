/****** Object:  StoredProcedure [dbo].[csp_G4ReportAppointments]    Script Date: 05/26/2016 12:30:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_G4ReportAppointments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_G4ReportAppointments]
GO

/****** Object:  StoredProcedure [dbo].[csp_G4ReportAppointments]    Script Date: 05/26/2016 12:30:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/******************************************************************************                  
**  File: csp_G4Report.sql 
**  Name: csp_G4Report 
**  Desc: Provides information on Prevention/Education/Outreach activities for
**        OHP enrolled members.
**                   
**  Created By:  Paul Ongwela 
**  Date:		 June 23, 2015 
*******************************************************************************
...............................................................................                  
..  Change History                   
...............................................................................                  
..  Date:		Author:				Description:                   
..  --------	--------			-------------------------------------------    
..  06/23/2015  Paul Ongwela        Created.
..  03/01/2016  Govind				Exclude EventType parameter - Task ND Cust#31
..  03/22/2016	Govind				Created Recodes to exclude some staff from displaying on report - Task ND Cust#31
..
*******************************************************************************/

Create Procedure [dbo].[csp_G4ReportAppointments]
	 --@EventType Int
	@StartDate DateTime
	,@EndDate DateTime
As

Begin

-- Set NoCount On added to prevent extra result sets from interfering with
-- statements such as SELECT, INSERT, UPDATE, and DELETE... 
Set NoCount On

;With Report As (
	Select gc.CodeName As Activity
		  ,Count(a.AppointmentType) As Number
		    ,a.staffid as StaffId
			,s.lastname + ', ' + s.firstname as StaffName
		  ,Sum(DateDiff(Minute,StartTime,EndTime)) As TotalTime
		  	,sum(DateDiff(Minute,StartTime,EndTime)) As Total
		  --,gc.GlobalCodeId
	  
	From Appointments a
		 Join GlobalCodes gc On a.AppointmentType = gc.GlobalCodeId
			And IsNull(gc.RecordDeleted,'N') = 'N'
		 Join Staff s on s.staffid = a.staffid
			And IsNull(s.RecordDeleted,'N') <> 'Y'

	Where IsNull(a.RecordDeleted,'N') = 'N'
		And StartTime >= @StartDate And EndTime <= @EndDate
		And s.staffid not in (SELECT IntegerCodeId FROM dbo.ssf_RecodeValuesCurrent('XStaffToExcludeFromG4'))
		--And (1=(Case When @EventType Is Null Then 1 Else 0 End)
		--	Or a.AppointmentType = @EventType)
		And gc.GlobalCodeId In (
								Select GlobalCodeId
								From GlobalCodes
								Where SubString(CodeName,1,3) = 'PEO'
									And IsNull(RecordDeleted,'N') = 'N'
									And Category = 'APPOINTMENTTYPE'
								)
	--Group By gc.CodeName
	--	  ,gc.GlobalCodeId

	group by gc.codename, 
	a.staffid,
	s.lastname,s.firstname,
	a.appointmenttype
)
Select Activity
	, Number
	, StaffName
	, StaffId
	, Total
	,Cast(TotalTime/60 As VarChar(5)) +
	 Case When Cast(TotalTime/60 As VarChar(5)) = 1 Then ' hr, '
		  Else ' hrs, ' End +
	 Right('0' + Cast(TotalTime%60 As VarChar(2)), 2)+' min.' AS [Time]
From Report r

End





GO


