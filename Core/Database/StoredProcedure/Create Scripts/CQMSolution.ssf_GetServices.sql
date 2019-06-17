/****** Object:  UserDefinedFunction [CQMSolution].[ssf_GetServices]    Script Date: 01-02-2018 12:17:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CQMSolution].[ssf_GetServices]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CQMSolution].[ssf_GetServices]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [CQMSolution].[ssf_GetServices]
                 ( 
				   @providerNPI varchar(50),   -- this is whatever id is used to identify a physician in your system
				   @startDate   datetime,      -- start date of the reporting period
				   @stopDate    datetime,      -- end date of the reporting period
				   @practiceID  varchar(255),   -- ExternalPracticeID
				   @type varchar(255) --ep or eh
		      )
RETURNS TABLE 
AS
RETURN (
       SELECT s.ServiceId,s.DateOfService,s.EndDateOfService,s.ProcedureCodeId,s.LocationId,s.ClientId,s.ClinicianId,s.ProgramId,s.[Status],s.CancelReason
	   FROM Services AS s
	   WHERE s.DateOfService >= @startDate
	   AND s.DateOfService <= @stopDate
	   AND ISNULL(s.RecordDeleted,'N') = 'N'
	   AND @type = 'EP'
      union
	 SELECT s.ServiceId,s.DateOfService,s.EndDateOfService,s.ProcedureCodeId,s.LocationId,s.ClientId,s.ClinicianId,s.ProgramId,s.[Status],s.CancelReason
	   FROM Services AS s
	   WHERE s.DateOfService >= @startDate
	   AND s.DateOfService <= @stopDate
	   AND ISNULL(S.RecordDeleted,'N') = 'N'
	   AND EXISTS( SELECT 1
				   FROM dbo.ClientInpatientVisits AS civ 
				   WHERE ISNULL(civ.RecordDeleted,'N')='N'
				   AND civ.ClientId = s.ClientId
				   AND CONVERT(DATE,civ.AdmitDate) <= CONVERT(DATE,s.DateOfService)
				   AND ( CONVERT(DATE,civ.DischargedDate) >= CONVERT(DATE,s.DateOfService) OR civ.DischargedDate IS NULL )
			   )
       AND @type = 'EH'
       )
GO

