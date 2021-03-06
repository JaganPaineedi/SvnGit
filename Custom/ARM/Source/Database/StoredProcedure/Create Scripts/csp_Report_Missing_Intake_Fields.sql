/****** Object:  StoredProcedure [dbo].[csp_Report_Missing_Intake_Fields]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Missing_Intake_Fields]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Missing_Intake_Fields]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Missing_Intake_Fields]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'----/*
CREATE PROCEDURE [dbo].[csp_Report_Missing_Intake_Fields]

AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_Missing_Intake_Fields 					*/
/* Creation Date: 03/18/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/	
/*								     									*/
/* Description: Finds missing intake fields for CARF. 			*/		/*						      		                                 */
/*  Date		Author		Purpose										*/
/*	03/18/2013	Ryan Mapes	Created	as per WO: 27805					*/	
/************************************************************************/


declare @Table TABLE (Clientid INT, Date datetime, serviceid int )


INSERT INTO @Table
select clientid, MAX (CreatedDate) as ''CreatedDate'',ServiceId from documents d


 --where 
 where (DocumentcodeId = 1000240 --Client Consent for Treatment
 OR DocumentcodeId  = 1000310 --Con:C; Consent for Treatment Agreement
 OR DocumentcodeId = 1000311 --Con:C; Consent for Trt Agree-Insert
 )
 
 and d.SignedByAuthor like ''y''
  --and CurrentVersionStatus = 22
  AND(ISNULL(d.RecordDeleted, ''N'')<>''Y'')
  
group by ClientId, ServiceId

order by serviceid, ClientId

--select * from @Table

SELECT distinct t.[ClientId]
      ,ISNULL(s.LastName + '', '' + s.firstname,''zzz_No_Primary_Clinician_z'') AS ''StaffName''
      ,ISNULL(LocationName,''zzz_No_Location_Found_z'') AS ''LocationName''
      ,r.RaceId
	  ,c.FinanciallyResponsible
	  ,c.LivingArrangement
	  ,c.CountyOfResidence
	  ,c.CountyOfTreatment
	  ,c.EducationalStatus
	  ,c.MilitaryStatus
	  ,c.EmploymentStatus
	  ,c.PrimaryLanguage
	  ,c.HispanicOrigin
	  ,cc.Ethnicity
	  ,cc.ServicesActivities
	  ,cc.HoursOperation
	  ,cc.AccessAfterHours
	  ,cc.PresenceGuardian
	  ,cc.PrivacyNotice
	  ,cc.NoSmokingWeapons
	  ,cc.FamiliarPremises
	  ,cc.ClientRightsSummary
	  ,cc.GrievanceReview
	  ,cc.ExplainFees
	  ,cc.CopiesPaperwork
	  ,cc.ReviewConsents
	  ,cc.InitalTreatmentForm
	  ,cc.ReviewLevelSystem
	  ,cc.ConfirmPrimaryPhone
	  ,cc.ConfirmAlternatePhone
  FROM [HarborStreamlineProd].[dbo].[CustomClients] cc
  
  join Clients c
  
  on cc.ClientId = c.ClientId
  AND(ISNULL(c.RecordDeleted, ''N'')<>''Y'')
  
  join ClientEpisodes ce
  on ce.EpisodeNumber = c.CurrentEpisodeNumber
  and ce.ClientId = c.ClientId
  AND(ISNULL(ce.RecordDeleted, ''N'')<>''Y'')
  
  join @Table t
  on t.ClientId = cc.ClientId
  
 left join ClientRaces r
  on r.ClientId = t.Clientid
  AND(ISNULL(r.RecordDeleted, ''N'')<>''Y'')
  
  left join Locations l
  on l.LocationId = cc.Location
    AND(ISNULL(l.RecordDeleted, ''N'')<>''Y'')
    
    left join Staff s
    on s.StaffId = ce.IntakeStaff
    AND(ISNULL(s.RecordDeleted, ''N'')<>''Y'')
  
  --join Services s
  --on s.ServiceId = t.serviceid
  where (ISNULL(cc.RecordDeleted, ''N'')<>''Y'')
 --AND c.Active like ''y''
 --and t.Clientid=123967
  and (r.RaceId IS NULL OR
	  c.FinanciallyResponsible IS NULL OR
	  c.LivingArrangement IS NULL OR
	  c.CountyOfResidence IS NULL OR
	  c.CountyOfTreatment IS NULL OR
	  c.EducationalStatus IS NULL OR
	  c.MilitaryStatus IS NULL OR
	  c.EmploymentStatus IS NULL OR
	  c.PrimaryLanguage IS NULL OR
	  c.HispanicOrigin IS NULL OR
	  cc.Ethnicity IS NULL OR
	  cc.ServicesActivities <> ''y'' OR
	  cc.HoursOperation <> ''y'' OR
	  cc.AccessAfterHours <> ''y'' OR
	  (cc.PresenceGuardian <> ''y'' AND cc.PresenceGuardian <> ''a'')  OR
	  cc.PrivacyNotice <> ''y'' OR
	 cc.NoSmokingWeapons <> ''y'' OR
	  cc.FamiliarPremises <> ''y'' OR
	  cc.ClientRightsSummary <> ''y'' OR
	  cc.GrievanceReview <> ''y'' OR
	  cc.ExplainFees <> ''y'' OR
	  cc.CopiesPaperwork <> ''y'' OR
	  cc.ReviewConsents <> ''y'' OR
	  cc.InitalTreatmentForm <> ''y'' OR
	  cc.ReviewLevelSystem <> ''y'' OR
	  (cc.ConfirmPrimaryPhone <> ''y'' AND cc.ConfirmPrimaryPhone <> ''a'') OR
	  (cc.ConfirmAlternatePhone  <> ''y'' and cc.ConfirmAlternatePhone  <> ''a''))
	  
	  --and c.ClientId= 2044
	  
	    ORDER BY t.Clientid
  
  
  
' 
END
GO
