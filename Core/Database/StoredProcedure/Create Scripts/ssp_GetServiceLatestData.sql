

/****** Object:  StoredProcedure [dbo].[ssp_GetServiceLatestData]    Script Date: 11/19/2015 19:26:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetServiceLatestData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetServiceLatestData]
GO



/****** Object:  StoredProcedure [dbo].[ssp_GetServiceLatestData]    Script Date: 11/19/2015 19:26:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************/   
/* Stored Procedure: ssp_GetServiceLatestData */   
/* Copyright: 2008 Streamline Healthcare Solutions, LLC */   
/* Creation Date: 19 Nov,2015 */   
/* Input Parameters: @ServiceId */ /* Author :Vaibhav Khare*/  
/* Purpose: Getting age. */   
/*********************************************************************/   
CREATE PROCEDURE [dbo].[ssp_GetServiceLatestData]  
(  
@ServiceId INT  
)  
AS   
BEGIN   
SELECT 
ServiceId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedDate
,DeletedBy
,ClientId
,GroupServiceId
,ProcedureCodeId
,DateOfService
,EndDateOfService
,RecurringService
,Unit
,UnitType
,Status
,CancelReason
,ProviderId
,ClinicianId
,AttendingId
,ProgramId
,LocationId
,Billable
,ClientWasPresent
,OtherPersonsPresent
,AuthorizationsApproved
,AuthorizationsNeeded
,AuthorizationsRequested
,Charge
,NumberOfTimeRescheduled
,NumberOfTimesCancelled
,ProcedureRateId
,DoNotComplete
,Comment
,Flag1
,OverrideError
,OverrideBy
,ReferringId
,DateTimeIn
,DateTimeOut
,NoteAuthorId
,ModifierId1
,ModifierId2
,ModifierId3
,ModifierId4
,PlaceOfServiceId
,SpecificLocation
,OverrideCharge
,OverrideChargeAmount
,ChargeAmountOverrideBy

from Services where serviceId=@ServiceId
END   
/*********************************************************************/   
GO


