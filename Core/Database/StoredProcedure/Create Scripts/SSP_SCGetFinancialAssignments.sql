/****** Object:  StoredProcedure [dbo].[SSP_SCGetFinancialAssignments]    Script Date: 12/15/2014 16:14:52 ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[SSP_SCGetFinancialAssignments]')
  AND TYPE IN (
  N'P'
  , N'PC'
  ))
  DROP PROCEDURE [dbo].[SSP_SCGetFinancialAssignments]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetFinancialAssignments]    Script Date: 12/15/2014 16:14:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetFinancialAssignments]
AS
-- =============================================
-- Author:		Veena S Mani
-- Create date: 03/18/2015
-- Description:	Get Financial Assignment data for Shared tables Valley Customization #950 .
--  Author          Date             Purpose
-- Ajay          05/07/2017        Added two columns ListPageFilter,RevenueWorkQueueManagement in FinancialAssignments table as a part of AHN Customization #Task:44	
-- =============================================
BEGIN TRY
  ---------FinancialAssignments	              
  SELECT
    FinancialAssignmentId,
    CreatedBy,
    CreatedDate,
    ModifiedBy,
    ModifiedDate,
    RecordDeleted,
    DeletedBy,
    DeletedDate,
    AssignmentName,
    Active,
    ChargePayerType,
    ChargePayer,
    ChargePlan,
    ChargeProgram,
    ChargeLocation,
    ChargeServiceArea,
    ChargeProcedureCode,
    ChargeErrorReason,
    ChargeResponsibleDays,
    ChargeIncludeClientCharge,
    FinancialAssignmentChargeClientLastNameFrom,
    FinancialAssignmentChargeClientLastNameTo,
    PaymentProgram,
    PaymentLocation,
    PaymentServiceArea,
    PaymentProcedureCode,
    PaymentPrimaryClinician,
    PaymentDenialReason,
    FinancialAssignmentPaymentClientLastNameFrom,
    FinancialAssignmentPaymentClientLastNameTo,
    ServiceProgram,
    ServiceLocation,
    ServiceServiceArea,
    ServiceProcedureCode,
    ServicePrimaryClinician,
    ServiceErrorReason,
    ServicePayer,
    FinancialAssignmentServiceClientLastNameFrom,
    FinancialAssignmentServiceClientLastNameTo,
    ListPageFilter,
    RevenueWorkQueueManagement
  FROM FinancialAssignments
  WHERE ISNULL(RecordDeleted, 'N') = 'N'

END TRY
BEGIN CATCH
  DECLARE @Error varchar(8000)

  SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'SSP_SCGetFinancialAssignments') + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY()) + '*****' + CONVERT(varchar, ERROR_STATE())

  RAISERROR (
  @Error
  ,-- Message text.                                    
  16
  ,-- Severity.                                    
  1 -- State.                                    
  );
END CATCH
GO