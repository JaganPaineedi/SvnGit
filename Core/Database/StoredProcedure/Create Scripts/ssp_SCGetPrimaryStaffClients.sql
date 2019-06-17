/****** Object:  StoredProcedure [dbo].[ssp_SCGetPrimaryStaffClients]    Script Date: 07/20/2015 22:36:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetPrimaryStaffClients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetPrimaryStaffClients]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetPrimaryStaffClients]    Script Date: 07/20/2015 22:36:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ssp_SCGetPrimaryStaffClients]
@LoggedInStaffId int,
@StaffId int
/********************************************************************************
-- Stored Procedure: dbo.ssp_SCGetPrimaryStaffClients
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Selects a list of clients for the SmartCare drop-down
--
-- Updates:
-- Date        Author    Purpose
-- 01.08.2005  Vikas     Created.
-- 04.08.2009  Chandan   External Client Id
-- 05.18.2010  TER       Proc Re-Written for SQL 2005/08.
-- 07.12.2010  RJN       Added @xLoggedInStaffId
-- 07.28.2010  SFarber   Modified to use StaffClients
-- 27.03.2012  Praveen   Modified according to the task #204 in 3.5x issues
-- 04.04.2013  Praveen Potnuru: Added Distint condition w.r.t task204 in 3.5x issues
-- 07.20.2015  TRemisoski Copy input parameters to local variables to avoid parameter sniffing issues in 2008R2
-- 28-Aug-2015 Deej Added logic invoke a custom sp to implement custom logic for caseload
-- 22-12-2015  Basudev Sahu Modified For Task #609 Network180 Customization to get Client Name and Organization name 
*********************************************************************************/
as

-- 07.20.2015  TRemisoski Copy input parameters to local variables to avoid parameter sniffing issues in 2008R2
declare
	@xLoggedInStaffId int,
	@xStaffId int

set @xLoggedInStaffId = @LoggedInStaffId
set @xStaffId = @StaffId

  CREATE TABLE #Clients
      (
         clientid            INT,
         primaryclient       VARCHAR(3)
      )
--declare @Clients table (ClientId int not null,Primaryclient VARCHAR(3))

declare  @UsePrimaryProgramForCaseload char(1), @PrimaryProgramId int, @DisplayPrimaryClients char(1), @DetermineCaseloadBy int ,@Today datetime

set @Today = convert(char(10), getdate(), 101)

select @UsePrimaryProgramForCaseload = UsePrimaryProgramForCaseload,
       @DisplayPrimaryClients = isnull(DisplayPrimaryClients, 'N'),
       @PrimaryProgramId = PrimaryProgramId,
       @DetermineCaseloadBy = determinecaseloadby
  from Staff
 where StaffId = @xStaffId

insert into #Clients (ClientId,PrimaryClient)
 SELECT DISTINCT c.clientid,
           cl.primaryclient from Clients c
         join StaffClients sc on sc.StaffId = @xLoggedInStaffId and sc.ClientId = c.ClientId
         join (
select c.ClientId,
       'Yes' AS PrimaryClient
  from Clients as c
 where c.Active = 'Y'
   and c.PrimaryClinicianId = @xStaffId
   and isnull(c.RecordDeleted, 'N') = 'N'
    and @DetermineCaseloadBy = 8271---Primary Clinician
union
select c.ClientId,
       'Yes' AS PrimaryClient
  from Clients as c
 where c.Active = 'Y'
   and isnull(c.RecordDeleted, 'N') = 'N'
   --and @UsePrimaryProgramForCaseload = 'Y' --commented this line w.r.t to task #204 3.5x issues
    AND @DetermineCaseloadBy = 8272 --Primary Program
   and exists(select *
                from ClientPrograms as cp
               where cp.ClientId = c.ClientId
                 and cp.ProgramId = @PrimaryProgramId
                 and cp.Status <> 5
                 and isnull(cp.RecordDeleted, 'N') = 'N')

union
select c.ClientId,
       'Yes' AS PrimaryClient
  from Clients as c
 where c.Active = 'Y'
   and isnull(c.RecordDeleted, 'N') = 'N'
   --and @UsePrimaryProgramForCaseload = 'Y'
    AND @DetermineCaseloadBy = 8273--Assigned Programs
   and exists(select *
                from ClientPrograms as cp
               inner join staffprograms sp on
                                sp.programid = cp.programid and sp.staffid = @xStaffId
                                and isnull(sp.RecordDeleted, 'N') = 'N'
                                where cp.ClientId = c.ClientId
                 --and cp.ProgramId = @PrimaryProgramId
                 and cp.Status <> 5
                 and isnull(cp.RecordDeleted, 'N') = 'N')
union
-- if the user prfererence for "display primary clients" <> 'Y', add any active client scheduled or seen by the clinician in the past 3 months
select c.ClientId,
       'No' AS PrimaryClient
  from Clients as c
 where c.Active = 'Y'
   and isnull(c.RecordDeleted, 'N') = 'N'
   --and @DisplayPrimaryClients <> 'Y' --commented this line w.r.t to task #204 3.5x issues
   and exists(select *
                from Services as s
               where s.ClientId = c.ClientId
                 and s.ClinicianId = @xStaffId
                and (
         (
          s.Status = 70
          and DATEDIFF(DAY, s.DateOfService, @Today) <= 0
         )
         or (
          s.DateOfService >= dateadd(mm, -3, @Today) -- Service was done in the last 3 months
          and s.Status in (71, 75)
         )
        )
                                and s.Status not in (72, 73)
                 and isnull(s.RecordDeleted, 'N') = 'N'
                  and isnull(c.RecordDeleted, 'N') = 'N'))cl on cl.ClientId = c.ClientId
   WHERE  c.active = 'Y'
           AND Isnull(c.recorddeleted, 'N') = 'N'
EXEC scsp_SCGetPrimaryStaffClients  @LoggedInStaffId,@StaffId         
-- Final results
select DISTINCT a.ClientId,
       a.LastName,
       a.FirstName,
       CASE     
		WHEN ISNULL(a.ClientType, 'I') = 'I'
		 THEN ISNULL(a.LastName, '') + ', ' + ISNULL(a.FirstName, '')
		ELSE ISNULL(a.OrganizationName, '')
		END as [Name],
       --ltrim(rtrim(a.LastName)) + ', ' + a.FirstName as [Name],
       a.RowIdentifier,
       1 as Status,
       a.PrimaryProgramId,
       a.PrimaryClinicianId,
       a.ExternalClientId
  from Clients a
       join #Clients as b on b.ClientId = a.ClientId and (@DisplayPrimaryClients <> 'Y' or (@DisplayPrimaryClients = 'Y' and b.Primaryclient='Yes'))
       join StaffClients sc on sc.StaffId = @xLoggedInStaffId and sc.ClientId = a.ClientId
 order by [Name]

return 0

GO

