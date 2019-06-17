IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCopayCollectUpFront]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetCopayCollectUpFront]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetCopayCollectUpFront]
    @ServiceId int -- ServiceId of Service
/********************************************************************************                                                  
-- Stored Procedure: ssp_SCGetCopayCollectUpFront
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Procedure to return Copay CollectUpFront for the given ServiceId.
--
-- *****History****
--Date          Author          Purpose
12 Jan 2018		Gautam			Created. EII- NBL(I) > Tasks #619 > Show Copay Collect Up Front on Reception 
*********************************************************************************/    
AS 
    BEGIN                                                              
        BEGIN TRY
        DECLARE @NextClientCoveragePlanId int;  
		  DECLARE @ClientId int;  
		  DECLARE @DateOfService datetime;  
		  DECLARE @ProgramId int;  
		  DECLARE @ServiceAreaID int;  
		  DECLARE @ProcedureCodeId int;  
		  DECLARE @ClientCoveragePlanId int;  
		  DECLARE @ClinicianId int;  
		  declare @ClientCopaymentId int, @CopayCollectUpfront char(1)
		  declare @IncludeOrExcludeProcedures char(1)
  
	SELECT   @ClientId = s.ClientId, @DateOfService =  CONVERT(VARCHAR(10), s.DateOfService, 101), 
			@ProcedureCodeId = s.ProcedureCodeId,@ClinicianId = ClinicianId  
	from Services s  
	JOIN ProcedureCodes pc ON pc.ProcedurecodeId = s.ProcedureCodeId    
	left join Staff st ON st.StaffId = s.ClinicianId 
	where ServiceId = @ServiceId and ISNULL(s.RecordDeleted,'N')='N' and ISNULL(pc.RecordDeleted,'N')='N' 
		and ISNULL(st.RecordDeleted,'N')='N'  
    
	exec ssp_PMGetNextBillablePayer @ClientId, @ServiceId, @DateOfService, @ProcedureCodeId, @ClinicianId, null, @NextClientCoveragePlanId = @ClientCoveragePlanId OUTPUT        
	
	-- Find Copay Information
	select  @ClientCopaymentId = b.ClientCopaymentId,@CopayCollectUpfront = ISNULL(a.CopayCollectUpfront,'N'),
	@IncludeOrExcludeProcedures = b.IncludeOrExcludeProcedures
	from  ClientCoveragePlans a
	JOIN ClientCopayments b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
	where a.ClientCoveragePlanId = @ClientCoveragePlanId
	and b.StartDate <= @DateOfService
	and (dateadd(dd, 1, b.EndDate) > @DateOfService or b.EndDate is null)
	and isnull(b.RecordDeleted,'N') = 'N'

    
	if (@IncludeOrExcludeProcedures = 'I' or @IncludeOrExcludeProcedures = 'E') and @ClientCopaymentId is not null
	BEGIN
		Set @ClientCopaymentId = null
		
		select  @CopayCollectUpfront = a.CopayCollectUpfront
		from  ClientCoveragePlans a
				JOIN ClientCopayments b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
				Join ClientCopaymentProcedures CP on CP.ClientCopaymentId = b.ClientCopaymentId And CP.ProcedureCodeId = @ProcedureCodeId
		where a.ClientCoveragePlanId = @ClientCoveragePlanId
				and b.StartDate <= @DateOfService
				and (dateadd(dd, 1, b.EndDate) > @DateOfService or b.EndDate is null)
				and isnull(b.RecordDeleted,'N') = 'N'
	END
   select @CopayCollectUpfront as CopayCollectUpfront
            
		END TRY
		BEGIN CATCH
            DECLARE @Error VARCHAR(8000)       
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetCopayCollectUpFront') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())
			RAISERROR
			(
				@Error, -- Message text.
				16,		-- Severity.
				1		-- State.
			);
        END CATCH
    END

   
GO


