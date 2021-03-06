/****** Object:  StoredProcedure [dbo].[csp_AlertReleaseOfInformationExpiring]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AlertReleaseOfInformationExpiring]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AlertReleaseOfInformationExpiring]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AlertReleaseOfInformationExpiring]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_AlertReleaseOfInformationExpiring]


as
/*
modified by		modifided date		reason
avoss			08.25.2011			created


exec dbo.csp_AlertReleaseOfInformationExpiring

*/


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @Today datetime, @Yesterday datetime
set @Today = dbo.RemoveTimestamp(getdate())
set @Yesterday = dateadd(dd,-1,@Today)


--Create Alert
declare @RepId int, @StartDate datetime
select @RepId = 52, @StartDate = ''12/1/2011''

--This may need to have a custom table to send out releases to treatment team or admin groups.  This needs to be reviewed
--create table CustomReleasesTreatment(
--ClientId int,
--ReleaseToTreatment varchar(50),
--ReleaseDate datetime,
--AdminGroup varchar(50),
--CreatedBy varchar(50),
--CreatedDate datetime,
--ModifiedBy varchar(50),
--ModifiedDate datetime,
--RecordDeleted varchar(1),
--DeletedDate datetime,
--DeletedBy varchar(50)
--)

--select * from CustomAssessments  


declare @AlertType int
set @AlertType = 21601 --Newly Created GlobalCode

--select * from globalcodes where category like ''Alerttype''
select 
	''Client''''s Authorization To Release Information is Expiring'' as Subject,
	''The client''''s authorization to release information to '' + cir.ReleaseToName + 
		+ case when cir.EndDate < dateAdd(dd,1,@Today) then '' expired '' else '' expires on '' end 
		+ convert(varchar(12),cir.EndDate,101)+''.''
		+ '' Please make sure to aquire a new release if needed.'' as Message,
	c.ClientId, 
	c.Firstname + '' '' + c.lastname as ClientName,
	isnull(c.PrimaryClinicianId,@RepId) as PrimaryClinicianId,
	case when c.PrimaryClinicianId is null then ''(No Primary Clinician)'' 
		else prc.Firstname + '' '' + prc.lastname end as PrimaryClinician,  
	@AlertType as AlertType,
	datediff(dd,@Today,cir.EndDate) as DaysUntilExpired,
	cir.ClientInformationReleaseId 
into #AlertStage
From clients c 
join ClientInformationReleases cir on cir.ClientId = c.ClientId and isnull(cir.RecordDeleted,''N'')<>''Y''
left join staff prc on prc.StaffId = isnull(c.PrimaryClinicianId,@RepId) and prc.Active=''Y''
where datediff(dd,@Today,cir.EndDate) < 30
--and datediff(dd,@Today,cir.EndDate) > -30
and not exists ( select 1 from ClientInformationReleases cir2 
	where cir2.ClientId = cir.ClientId
	and ( cir2.ReleaseToId = cir.ReleaseToId 
		or ltrim(rtrim(cir2.ReleaseToName)) = ltrim(rtrim(cir.ReleaseToName))
		)
	and isnull(cir2.RecordDeleted,''N'')<>''Y''
	and cir2.EndDate > cir.EndDate)

--select * from #AlertStage

if exists ( select * from #AlertStage )
begin 
	insert into alerts (
		ToStaffId, ClientId, AlertType,Unread,DateReceived,Subject,Message,
		Reference,CreatedBy,CreatedDate,ModifiedBy,
		ModifiedDate,RecordDeleted )

	select
	s.PrimaryClinicianId as ToStaffId,
	s.ClientId,
	s.AlertType,
	''Y'' as Unread,  --Unread
	getdate() as DateRecieved, --DateRecieved
	s.Subject,
	s.PrimaryClinician + '': '' + char(10)+char(13)+ s.Message as Message, 
	s.ClientInformationReleaseId as Reference,
	''ROIExpireAlert'' as CreatedBy,
	getdate() as CreatedDate,
	''ROIExpireAlert'' as ModifiedBy,
	getdate() as ModifiedDate,
	''N''
	from #AlertStage s
	where not exists ( select * from Alerts al 
			where al.ToStaffId = s.PrimaryClinicianId
			and al.ClientId = s.ClientId
			and al.Subject = s.Subject
			and al.Reference =  s.ClientInformationReleaseId 
			and al.AlertType = s.AlertType
		)
end



drop table #AlertStage

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


/*

select * from ClientInformationReleases

*/
' 
END
GO
