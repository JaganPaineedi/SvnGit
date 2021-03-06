/****** Object:  StoredProcedure [dbo].[csp_AlertClinicianDisclosureApproval]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AlertClinicianDisclosureApproval]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AlertClinicianDisclosureApproval]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AlertClinicianDisclosureApproval]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_AlertClinicianDisclosureApproval]


as
/*
modified by		modifided date		reason
avoss			11.18.2011			created


exec dbo.csp_AlertClinicianDisclosureApproval
select * from globalcodes where globalcodeId = 25000
*/


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


declare @Today datetime, @Yesterday datetime
set @Today = dbo.RemoveTimestamp(getdate())
set @Yesterday = dateadd(dd,-1,@Today)


--Create Alert
declare @AlertType int
set @AlertType = 81 --Documents - Best Fit 
--This will need to be changed to match the ROI alert

--select * from globalcodes where category like ''Alerttype''
select 
	''Client''''s Authorization To Release Information is Expiring'' as Subject,
	''The client''''s disclosure to '' + cd.DisclosedToName + '' status has changed to '' + gc.CodeName + 
	+ ''. Please make sure to review the disclosed item(s).'' as Message,
	c.ClientId, 
	c.Firstname + '' '' + c.lastname as ClientName,
	@AlertType as AlertType,
	cd.ClientDisclosureId,
	cd.DisclosedBy as ToStaffId 
into #AlertStage
from AuditLog al 
join ClientDisclosures cd on cd.ClientDisclosureId = al.PrimaryKeyValue and isnull(cd.RecordDeleted,''N'')<> ''Y''
join Clients c on c.ClientId = cd.ClientId
join GlobalCodes gc on gc.GlobalCodeId = cd.DisclosureStatus
where al.AuditLogTableId = 1 
and al.ColumnName = ''DisclosureStatus''
and al.NewValue = 21906 --Pending Clinician Review
and not exists ( Select 1 
	from CustomDisclosureClinicianAlerts cda
	where cda.ClientDisclosureId = al.PrimaryKeyValue
	and cda.StaffId = cd.DisclosedBy
)


	
--select * from #AlertStage
if exists ( select * from #AlertStage )
begin 
	insert into alerts (
		ToStaffId, ClientId, AlertType,Unread,DateReceived,Subject,Message,
		Reference,CreatedBy,CreatedDate,ModifiedBy,
		ModifiedDate,RecordDeleted )

	select
	s.ToStaffId,
	s.ClientId,
	s.AlertType,
	''Y'' as Unread,  --Unread
	getdate() as DateRecieved, --DateRecieved
	s.Subject,
	s.Message as Message, 
	s.ClintDisclosureId as Reference,
	''ClincianDisclosureAlert'' as CreatedBy,
	getdate() as CreatedDate,
	''ClincianDisclosureAlert'' as ModifiedBy,
	getdate() as ModifiedDate,
	''N'' as RecordDeleted
	from #AlertStage s
	where not exists ( select * from Alerts al 
			where al.ToStaffId = s.ToStaffId
			and al.ClientId = s.ClientId
			and al.Subject = s.Subject
			and al.Reference =  convert(varchar(150),s.ClintDisclosureId)
			and al.AlertType = s.AlertType
		)

begin
insert into CustomDisclosureClinicianAlerts
(ClientdisclosureId, StaffId)
select ClintDisclosureId, ToStaffId
from #AlertStage
end

end



drop table #AlertStage

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


' 
END
GO
