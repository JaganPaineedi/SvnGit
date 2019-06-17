
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientImmunizationsDetails]    Script Date: 06/13/2015 17:23:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientImmunizationsDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientImmunizationsDetails]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientImmunizationsDetails]    Script Date: 06/13/2015 17:23:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[ssp_SCGetClientImmunizationsDetails]  
  
(          
@ClientImmunizationId int          
)          
        
  
As  
  
  
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_SCGetClientImmunizationsDetails             */                  
/* Creation Date:  12/05/2011                                            */                  
/*                                                                       */                  
/* Purpose: To  Get Client Immunization detail as per ClientImmunizationId              */                 
/*                                                                   */                
/* Input Parameters: @ClientImmunizationId           */                
/*                                                                   */                  
/* Output Parameters:                                */                  
/*                                                                   */                  
/*  Date                  Author                 Purpose                                    */                  
/* 12/05/2011             Jagdeep Hundal        Created                                    */   
/* 01/08/2014			  Chethan N				Added four new columns-VaccineStatus, Comment,Route & AdministrationSite */  
/*06/25/2014			  Veena					Added 	ExportedDateTime   */
/*11/04/2014			vaibhav					Adding new tab */            
/*********************************************************************/           
  
Select   ClientImmunizationId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedBy
		,DeletedDate
		,ClientId
		,VaccineNameId
		,AdministeredDateTime
		,AdministeredAmount
		,AdministedAmountType
		,LotNumber
		,ExpirationDate
		,ManufacturerId
		,VaccineStatus
		,Comment
		,Route
		,AdministrationSite
		,ExportedDateTime
		,ResidentMonitored
		,ReactionNoted
FROM  ClientImmunizations where ClientImmunizationId=@ClientImmunizationId
    and   ISNULL(RecordDeleted, 'N') = 'N'  

Select
ImmunizationDetailId,
CreatedBy,
CreatedDate,
ModifiedBy,
ModifiedDate,
RecordDeleted,
DeletedDate,
DeletedBy,
ClientImmunizationId,
EnteredBy,
OrderedBy,
AdministeringProvider,
NeedVaccinationReminder,
AdministrationNotes,
VaccineFunding,
VaccineType,
StatementPublished,
StatementPresented,
PresumedImmunity,
TreatmentRefusalReason,
ProtectionIndicator

FROM  ImmunizationDetails where ClientImmunizationId=@ClientImmunizationId
    and   ISNULL(RecordDeleted, 'N') = 'N'  

--Checking For Errors  
If (@@error!=0) 
	 Begin  
	 RAISERROR  20006  'ssp_SCGetClientImmunizationsDetails: An Error Occured'     
	 Return  
 End  
  
  
  
  
  
  
  
GO

