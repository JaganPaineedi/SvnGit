----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------ 

------ END OF STEP 3 -----

------ STEP 4 ----------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomElectronicEligibilityCoveragePlanCOBPriority')
BEGIN
/*  
 * TABLE: CustomElectronicEligibilityCoveragePlanCOBPriority 
 */
 CREATE TABLE CustomElectronicEligibilityCoveragePlanCOBPriority( 
		ElectronicEligibilityCoveragePlanCOBPriorityId		int	identity(1,1)	 NOT NULL,
		CreatedBy											type_CurrentUser     NOT NULL,
		CreatedDate											type_CurrentDatetime NOT NULL,
		ModifiedBy											type_CurrentUser     NOT NULL,
		ModifiedDate										type_CurrentDatetime NOT NULL,
		RecordDeleted										type_YOrN			 NULL
															CHECK (RecordDeleted in ('Y','N')),
		DeletedBy											type_UserId          NULL,
		DeletedDate											datetime			 NULL,
		CoveragePlanId										int					 NOT NULL,
		COBPriority											int					 NOT NULL,
		CONSTRAINT CustomElectronicEligibilityCoveragePlanCOBPriority_PK PRIMARY KEY CLUSTERED (ElectronicEligibilityCoveragePlanCOBPriorityId)
)
  IF OBJECT_ID('CustomElectronicEligibilityCoveragePlanCOBPriority') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomElectronicEligibilityCoveragePlanCOBPriority >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomElectronicEligibilityCoveragePlanCOBPriority >>>', 16, 1)
/*  
 * TABLE: CustomElectronicEligibilityCoveragePlanCOBPriority 
 */   
     
ALTER TABLE CustomElectronicEligibilityCoveragePlanCOBPriority ADD CONSTRAINT CoveragePlans_CustomElectronicEligibilityCoveragePlanCOBPriority_FK
    FOREIGN KEY (CoveragePlanId)
    REFERENCES CoveragePlans(CoveragePlanId)   


     PRINT 'STEP 4(A) COMPLETED'
 END
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping')
BEGIN
/*  
 * TABLE: CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping 
 */
 CREATE TABLE CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping( 
		ElectronicEligibilityResponseBenefitAttributeToCoveragePlanMappingId		int	identity(1,1)	 NOT NULL,
		CreatedBy																	type_CurrentUser     NOT NULL,
		CreatedDate																	type_CurrentDatetime NOT NULL,
		ModifiedBy																	type_CurrentUser     NOT NULL,
		ModifiedDate																type_CurrentDatetime NOT NULL,
		RecordDeleted																type_YOrN			 NULL
																					CHECK (RecordDeleted in ('Y','N')),
		DeletedBy																	type_UserId          NULL,
		DeletedDate																	datetime             NULL,
		ElectronicEligibilityVerificationPayerId									int					 NULL,
		CoveragePlanId																int					 NULL,
		VerifiedResponseType														varchar(25)			 NULL,
		BenefitInfo																	varchar(max)		 NULL,
		BenefitInsuranceType														varchar(max)		 NULL,
		BenefitPlanCoverageDescription												varchar(max)		 NULL,
		BenefitMessage1																varchar(max)		 NULL,
		BenefitEntityCode															varchar(max)		 NULL,
		BenefitEntityName															varchar(max)		 NULL,
		BenefitEntityInformationContact												varchar(max)		 NULL,
		SubscriberGroupPolicyCountyNum												varchar(max)		 NULL,
		BenefitRelatedEntityId														varchar(max)		 NULL,
		HasSpendBeenMet																type_YOrN			 NULL
																					CHECK (HasSpendBeenMet in ('Y','N')),
		CanCoverageBeInactiveIfNotInResponse										type_YOrN			 NULL
																					CHECK (CanCoverageBeInactiveIfNotInResponse in ('Y','N')),
		CONSTRAINT CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping_PK PRIMARY KEY CLUSTERED (ElectronicEligibilityResponseBenefitAttributeToCoveragePlanMappingId)
)
  IF OBJECT_ID('CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping >>>', 16, 1)
/*  
 * TABLE: CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping 
 */   
     
ALTER TABLE CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping ADD CONSTRAINT ElectronicEligibilityVerificationPayers_CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping_FK
    FOREIGN KEY (ElectronicEligibilityVerificationPayerId)
    REFERENCES ElectronicEligibilityVerificationPayers(ElectronicEligibilityVerificationPayerId)
    
ALTER TABLE CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping ADD CONSTRAINT CoveragePlans_CustomElectronicEligibilityResponseBenefitAttributeToCoveragePlanMapping_FK
    FOREIGN KEY (CoveragePlanId)
   REFERENCES CoveragePlans(CoveragePlanId)

     PRINT 'STEP 4(B) COMPLETED'
 END
 

  ---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------


IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_Eligibility')
	BEGIN
		INSERT INTO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_Eligibility'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
	END
 GO