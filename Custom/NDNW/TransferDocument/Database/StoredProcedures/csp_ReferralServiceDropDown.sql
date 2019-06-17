--pulled from Harbor SVN by Atul Pandey on 12/26/2012 for task #4 of project Centra Wellness Customizations
--pulled from Harbor SVN by Atul Pandey on 01/21/2013 for task #4 of project Newaygo Customizations

if object_id('csp_ReferralServiceDropDown', 'P') is not null
	drop procedure csp_ReferralServiceDropDown
go

create procedure csp_ReferralServiceDropDown
	@DocumentCodeId int,
	@ClientId int,
	@isInitialTxTab char(1)
AS
BEGIN
BEGIN TRY
/****************************************************************/
-- PROCEDURE: scsp_ReferralServiceDropDown
-- PURPOSE: Fills the authorization codes list drop-down for
-- any Harbor document that uses services (Treatment plans,
-- Diagnostic Assessments, referrals, transfers).
-- CALLED BY: Harbor custom documents.
-- REVISION HISTORY:
--		
/****************************************************************/

declare @txPlanReferralTransferServices table (
	AuthorizationCodeId int
)
insert into @txPlanReferralTransferServices 
        (AuthorizationCodeId)
values
(1),
(2),
(9),
(12),
(13)

if ((@DocumentCodeId in (1483, 1484, 1485)) or (@isInitialTxTab = 'Y'))
	select a.AuthorizationCodeId, a.DisplayAs
	from dbo.AuthorizationCodes as a
	join @txPlanReferralTransferServices as b on b.AuthorizationCodeId = a.AuthorizationCodeId
	where a.Active = 'Y'
	and ISNULL(RecordDeleted, 'N') <> 'Y'
	order by DisplayAs, AuthorizationCodeId
else
	select a.AuthorizationCodeId, a.DisplayAs
	from dbo.AuthorizationCodes as a
	where a.Active = 'Y'
	and ISNULL(RecordDeleted, 'N') = 'N'
	order by DisplayAs, AuthorizationCodeId

END TRY
BEGIN CATCH
 DECLARE @Error varchar(8000)
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_ReferralServiceDropDown')
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
    
go
