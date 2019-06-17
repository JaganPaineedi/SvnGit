/****** Object:  StoredProcedure [dbo].[csp_ReportDischargeByCaseload]    Script Date: 04/18/2013 09:48:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDischargeByCaseload]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDischargeByCaseload]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportDischargeByCaseload]    Script Date: 04/18/2013 09:48:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[csp_ReportDischargeByCaseload]
	@Team 		int ,
	@Clinician	int ,
	@LastSeen	int
AS
/*
*
Modifications: 
	Date		User		Description
	---------	---------	----------------------------------
	5/6/2008	avoss		Changed check for 90 days to be under 120 to display all past 90 days
	11/02/2010	avoss		changed to find most recent adequate/adv notice in the client's current episode
	05/25/2011	dharvey		Added 60 day parameter per S.Hall
	09/28/2011	dharvey		Modified Updates to improve performance


declare 	
	@Team 		int ,
	@Clinician	int ,
	@LastSeen	int

select @Team=null,
	@Clinician=null,
	@LastSeen = 90
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



CREATE TABLE #Results
(ClientOrder varchar(200) null,
 ClientName varchar(200) null,
 ClientId int null,
 TeamName varchar(100) null,
 Clinician varchar(200) null,
 ClinicianId int null,
 LastSeenByMe datetime null,
 LastSeen datetime null, 
 LastService varchar(150) null,
 LastClinician varchar(150) null,
 NextScheduled datetime null,
 NextService varchar(150) null,
 NextClinician varchar(150) null,
 EpisodeRegDate datetime null,
 AdvanceAdequateNoticeSent datetime null,
 AdvanceNoticeSent datetime null,
 AdequateNoticeSent datetime null,
 TotalClients int,
 TotalNotSeen int
 )
 
Insert Into #Results
(ClientOrder,
 ClientName,
 ClientId, 
 TeamName,
 Clinician,
 ClinicianId,
 EpisodeRegDate
 )

Select c.LastName + ', ' + c.FirstName, 
c.LastName + ', ' + c.FirstName,
c.ClientId,
isnull(gc1.CodeName, 'Unknown'), 
isnull(s.LastName + ', ' + s.FirstName, 'Unknown'),
s.StaffId,
isnull(ce.RegistrationDate, ce.InitialRequestDate)
From Clients c with(nolock)
Left Join Staff s with(nolock) on s.StaffId = c.PrimaryClinicianId and isnull(s.RecordDeleted, 'N') = 'N'
Left Join Programs p with(nolock) on p.ProgramId = s.PrimaryProgramId
Left Join GlobalCodes gc1 with(nolock) on gc1.GlobalCodeId = p.ProgramType and isnull(gc1.RecordDeleted, 'N') = 'N'
left join ClientEpisodes ce with(nolock) on ce.ClientId = c.ClientId and isnull(ce.RecordDeleted,'N')<>'Y'
where c.Active = 'Y'
and isnull(c.RecordDeleted, 'N') = 'N'
and (@Team is null
     Or
     (@Team is not null
     AND p.ProgramType = @Team))
and (@Clinician is null
     Or 

--ADDED LOGIC FOR NET TEAM
     (@Clinician is not null
     AND s.Staffid =@Clinician 
		)
		)

and not exists (select 1 from Services s with(nolock)
                where c.Clientid = s.ClientId
                and datediff(dd, getdate(), s.DateOfService) >= 0
                and s.Status = 70
				and s.ClinicianId = c.PrimaryClinicianId
 --               and s.ProcedureCodeId in (274, 287)  -- check for any scheduled intake assessment/ithera
                and isnull(s.recorddeleted, 'N') = 'N'
               )
and not exists ( select * from ClientEpisodes ce2 where ce2.ClientId = c.ClientId and ISNULL(ce2.RecordDeleted,'N')<>'Y' 
	and ce2.EpisodeNumber > ce.EpisodeNumber )



-- Find Last Seen By Me Date
Update #Results
set LastSeenByMe = s1.MaxDateOfService
From #Results r
Join (Select ClientId, ClinicianId, MAX(DateOfService) as MaxDateOfService
		From Services with(nolock) 
		Where Status in (71, 75)
		and isnull(RecordDeleted, 'N') = 'N'
		Group by ClientId, ClinicianId
		) s1 on s1.ClientId=r.ClientId and s1.ClinicianId=r.ClinicianId


--Update #Results
--set LastSeenByMe = s1.DateOfService
--From #Results r
--Left Join Services s1 with(nolock) on  s1.ClinicianId = r.ClinicianId
--			and s1.Status in (71, 75)
--			and s1.ClientId = r.ClientId
--			and isnull(s1.RecordDeleted, 'N') = 'N'
--			and not exists (select top 1 serviceid from Services s1a with(nolock)
--					where s1a.Status in (71, 75)
--					and s1a.ClientId = s1.ClientID
--					and s1a.DateOfService > s1.DateOfService
--					and s1a.ClinicianId = r.ClinicianId
--					and isnull(s1a.RecordDeleted, 'N') = 'N')
--Left Join ProcedureCodes cp1 with(nolock) on cp1.ProcedureCodeId = s1.ProcedureCodeId



-- Find Last Service Date
Update #Results
set LastSeen = s.DateOfService,
LastService = pc.DisplayAs,
LastClinician = st.LastName+', '+st.FirstName
From #Results r
Join Services s on s.ClientId=r.ClientId and ISNULL(s.RecordDeleted,'N')='N'
Join (Select Clientid, MAX(DateOFService) as DateOfService
		From Services s
		Where Status in (71,75)
		and ISNULL(RecordDeleted,'N')='N'
		Group by ClientId
		) s1 on s1.ClientId=s.ClientId and s1.DateOfService=s.DateOfService
Left Join ProcedureCodes pc with(nolock) on pc.ProcedureCodeId = s.ProcedureCodeId
Left Join Staff st with(nolock) on st.StaffId = s.ClinicianId
			
			
--Update #Results
--set LastSeen = s1.DateOfService,
--LastService = cp1.DisplayAs,
--LastClinician = st.LastName + ', ' + st.FirstName
--From #Results r
--Left Join Services s1 with(nolock) on isnull(s1.RecordDeleted, 'N') = 'N'
--			and s1.Status in (71, 75)
--			and s1.ClientId = r.ClientId
--			and not exists (select top 1 serviceid from Services s1a with(nolock)
--					where s1a.Status in (71, 75)
--					and s1a.ClientId = s1.ClientID
--					and s1a.DateOfService > s1.DateOfService
--					and isnull(s1a.RecordDeleted, 'N') = 'N')
--Left Join ProcedureCodes cp1 with(nolock) on cp1.ProcedureCodeId = s1.ProcedureCodeId
--Left Join Staff st with(nolock) on st.StaffId = s1.ClinicianId


-- Find Next Service Date
Update #Results
set  NextScheduled = s.DateOfService,
 NextService = pc.DisplayAs,
 NextClinician = st.LastName + ', ' + st.FirstName
From #Results r
Join Services s on s.ClientId=r.ClientId and ISNULL(s.RecordDeleted,'N')='N'
Join (Select Clientid, MIN(DateOFService) as DateOfService
		From Services s
		Where Status in (70)
		and ISNULL(RecordDeleted,'N')='N'
		Group by ClientId
		) s1 on s1.ClientId=s.ClientId and s1.DateOfService=s.DateOfService
Left Join ProcedureCodes pc with(nolock) on pc.ProcedureCodeId = s.ProcedureCodeId
Left Join Staff st with(nolock) on st.StaffId = s.ClinicianId


--Update #Results
--set  NextScheduled = s2.DateOfService,
-- NextService = cp2.DisplayAs,
-- NextClinician = st.LastName + ', ' + st.FirstName
--From #Results r
--Left Join Services s2 with(nolock) on isnull(s2.RecordDeleted, 'N') = 'N'
--			and s2.Status in (70)
--			and s2.ClientId = r.ClientId
--			and not exists (select 1 from Services s2a with(nolock)
--					where s2a.Status in (70)
--					and s2a.ClientId = s2.ClientID
--					and s2a.DateOfService < s2.DateOfService
--					and isnull(s2a.RecordDeleted, 'N') = 'N')
--Left Join ProcedureCodes cp2 with(nolock) on cp2.ProcedureCodeId = s2.ProcedureCodeId
--Left Join Staff st with(nolock) on st.StaffId = s2.ClinicianId 




--Set AdvanceAdequateNoticeSent Date 
Update #Results
set AdvanceAdequateNoticeSent = isnull(x.NoticeProvidedDate, d.EffectiveDate )
From #Results r
Join Documents d with(nolock) on r.ClientId = d.ClientID 
join customAdvanceAdequateNotices x with(nolock) on x.DocumentVersionId = d.CurrentDocumentVersionId 
	and isnull(x.RecordDeleted,'N')<>'Y'
and d.DocumentCodeId = 100
and d.Status = 22
--and datediff(dd, d.EffectiveDate, getdate()) < 180
and d.EffectiveDate >= r.EpisodeRegDate
and isnull(d.RecordDeleted, 'N') = 'N'
--and d.documentid in (select can.documentid from customAdvanceAdequateNotices can with(nolock)
--				   where can.documentid = d.documentid
--					and can.Version = d.CurrentVersion
--					and isnull(can.RecordDeleted, 'N') = 'N')
and not exists (select 1 from documents d2 with(nolock)
		join customAdvanceAdequateNotices can2 with(nolock) on d2.CurrentDocumentVersionId = can2.DocumentVersionId
		where d2.ClientId = d.ClientId
		--and datediff(dd, d2.EffectiveDate, getdate()) < 180
		and d2.EffectiveDate >= r.EpisodeRegDate
		and d2.DocumentCodeId = 100
		and d2.Status = 22
		and d2.EffectiveDate > d.EffectiveDate
		and isnull(d2.RecordDeleted, 'N') = 'N')
--select top 10 * from customAdvanceAdequateNotices



/**/
-- Find Advance Date
Update #Results
set AdvanceNoticeSent = d.EffectiveDate
From #Results r
Join Documents d with(nolock) on r.ClientId = d.ClientID 
and d.DocumentCodeId = 106
and d.Status = 22
--and datediff(dd, d.EffectiveDate, getdate()) < 180
and d.EffectiveDate >= r.EpisodeRegDate
and isnull(d.RecordDeleted, 'N') = 'N'
and d.CurrentDocumentVersionId in (select can.DocumentVersionId from CustomAdvanceNotice can with(nolock)
				   where isnull(DischargeFromAgency, 'N') = 'Y'
					and can.DocumentVersionId = d.CurrentDocumentVersionId
					and isnull(can.RecordDeleted, 'N') = 'N')
and not exists (select 1 from documents d2 with(nolock)
		join CustomAdvanceNotice can2 with(nolock) on d2.CurrentDocumentVersionId = can2.DocumentVersionId
		where d2.ClientId = d.ClientId
		and isnull(can2.DischargeFromAgency, 'N') = 'Y'
		--and datediff(dd, d2.EffectiveDate, getdate()) < 180
		and d2.EffectiveDate >= r.EpisodeRegDate
		and d2.DocumentCodeId = 106
		and d2.Status = 22
		and d2.EffectiveDate > d.EffectiveDate
		and isnull(d2.RecordDeleted, 'N') = 'N')
--Left Join CustomAdvanceNotice an on an.Documentid = d.DocumentId and an.Version = d.CurrentVersion



-- Find Adequate Date
Update #Results
set AdequateNoticeSent = d.EffectiveDate
From #Results r
Join Documents d with(nolock) on r.ClientId = d.ClientID 
and d.DocumentCodeId = 105
and d.Status = 22
--and datediff(dd, d.EffectiveDate, getdate()) < 180
and d.EffectiveDate >= r.EpisodeRegDate
and isnull(d.RecordDeleted, 'N') = 'N'
and d.CurrentDocumentVersionId in (select can.DocumentVersionId from CustomAdequateNotice can with(nolock)
				   where isnull(DischargeFromAgency, 'N') = 'Y'
					and can.DocumentVersionId = d.CurrentDocumentVersionId
					and isnull(can.RecordDeleted, 'N') = 'N')
and not exists (select 1 from documents d2 with(nolock)
		join CustomAdequateNotice can2 with(nolock) on d2.CurrentDocumentVersionId = can2.DocumentVersionId
		where d2.ClientId = d.ClientId
		and isnull(can2.DischargeFromAgency, 'N') = 'Y'
		--and datediff(dd, d2.EffectiveDate, getdate()) < 180
		and d2.EffectiveDate >= r.EpisodeRegDate
		and d2.DocumentCodeId = 105
		and d2.Status = 22
		and d2.EffectiveDate > d.EffectiveDate
		and isnull(d2.RecordDeleted, 'N') = 'N')
--Left Join CustomAdequateNotice an on an.Documentid = d.DocumentId and an.Version = d.CurrentVersion


Update #Results
set AdvanceAdequateNoticeSent = AdvanceNoticeSent
Where isnull(AdvanceNoticeSent, '1/1/1900') > isnull(AdequateNoticeSent, '1/1/1900')
and AdvanceAdequateNoticeSent is  null

Update #Results
set AdvanceAdequateNoticeSent = AdequateNoticeSent
Where isnull(AdvanceNoticeSent, '1/1/1900') < isnull(AdequateNoticeSent, '1/1/1900')
and AdvanceAdequateNoticeSent is  null



	--
	-- Total Clients by Team
	--
	UPDATE r
	SET r.TotalClients = (Select COUNT(Distinct ClientId) 
							From #Results r2
							Where r2.TeamName = r.TeamName
							)
	From #Results r



	--
	--Delete scheduled services for ACT, NET TEAM, CM1, CM2
	--
	/* Added ACT, CM1, CM2 to this logic */ -- DJH 1.26.2012
	Delete from #Results
	where clinicianid in (736,980,1173,1188) and NextClinician is not null

	-- Delete Seen in less than @LastSeen range
	DELETE From #Results 
	Where (datediff(dd, case when clinicianid in (736,980,1173,1188) 
								then LastSeen 
								else isnull(LastSeenByMe,getdate()) 
								end
							, getdate()) < @LastSeen)


	--
	-- Get Not Seen Total
	--
	UPDATE r
	SET r.TotalNotSeen = (Select COUNT(Distinct ClientId) 
							From #Results r2
							Where r2.TeamName = r.TeamName
							)
	From #Results r
	
	
	


select *
 from #Results
-- Modified to pass paramter value to eliminate hardcoded values - 5/25/2011 - DJH
--Where (datediff(dd, case when clinicianid = 980 then LastSeen else LastSeenByMe end, getdate()) >= @LastSeen)
--where (@LastSeen = 90 and datediff(dd, case when clinicianid = 980 then LastSeen else LastSeenByMe end, getdate()) >= 90) -- and datediff(dd, LastSeenByMe, getdate()) < 120)
--OR (@LastSeen = 120 and datediff(dd, case when clinicianid = 980 then LastSeen else LastSeenByMe end , getdate()) >= 120)  

----------------------------------------------------------
-- Removed this line to add the above logic 12/14/07 rxp
-- datediff(dd, LastSeenByMe, getdate()) >= @LastSeen 
----------------------------------------------------------
order by Clinician, ClientName


drop table #results



SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

