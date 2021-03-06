/****** Object:  StoredProcedure [dbo].[csp_ReferralServiceDropDown]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReferralServiceDropDown]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReferralServiceDropDown]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReferralServiceDropDown]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ReferralServiceDropDown]
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
--		2012.06.15
--2012.06.20 Rohitk add try catch 
--2012.07.02 Amit Kumar Srivastava Added @isInitialTxTab char(1), #1672, Harbor Go Live Issues, DA: Call csp_ReferralServiceDropDown with extra parameter
/****************************************************************/


declare @referralTransferServices table (
	AuthorizationCodeId int
)
insert into @referralTransferServices values
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18),
(333)	-- Health Home

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
(13),
(333)	-- Health Home

if ((@DocumentCodeId in (1483, 1484, 1485)) or (@isInitialTxTab = ''Y''))
	select a.AuthorizationCodeId, a.DisplayAs
	from dbo.AuthorizationCodes as a
	join @txPlanReferralTransferServices as b on b.AuthorizationCodeId = a.AuthorizationCodeId
	where a.Active = ''Y''
	and ISNULL(RecordDeleted, ''N'') <> ''Y''
	order by DisplayAs, AuthorizationCodeId
else
	select a.AuthorizationCodeId, a.DisplayAs
	from dbo.AuthorizationCodes as a
	join @referralTransferServices as b on b.AuthorizationCodeId = a.AuthorizationCodeId
	where a.Active = ''Y''
	and ISNULL(RecordDeleted, ''N'') <> ''Y''
	order by DisplayAs, AuthorizationCodeId

END TRY
BEGIN CATCH
 DECLARE @Error varchar(8000)
 SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_ReferralServiceDropDown'')
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())
    + ''*****'' + Convert(varchar,ERROR_STATE())
 RAISERROR
 (
   @Error, -- Message text.
   16, -- Severity.
   1 -- State.
  );
END CATCH
END
    
' 
END
GO
