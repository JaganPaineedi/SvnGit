
/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentFABIPs]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomDocumentFABIPs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomDocumentFABIPs]
GO


/****** Object:  StoredProcedure [dbo].[csp_validateCustomDocumentFABIPs]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE Procedure [dbo].[csp_validateCustomDocumentFABIPs]
/********************************************************************************                                      
-- Stored Procedure: csp_validateCustomDocumentFABIPs                                        
--                                      
-- Copyright: Streamline Healthcate Solutions                                      
--                                      
-- Purpose: TO Validate Document of FABIP
--
-- Call by:- Document.cs, Entry in Screens Table
--                                      
-- Updates:                                                                                             
-- Date			Author			Purpose  
----------------------------------------------------------------------------                                    
-- 4.1.2012		Devi Dayal		Created. 
-- 08 Sep 2014	Avi Goyal		Added @EffectiveDate paramter to use in DocumentValidations      
								Task : 965 ; Project : Core Bugs
*********************************************************************************/                                      

@DocumentVersionId Int        

AS
Begin                                                

Begin TRY 

declare @DocumentCodeId int
declare @ClientId int
DECLARE @EffectiveDate datetime
DECLARE @DocumentType varchar(10)
declare @QuarterlyStatusId int
select @QuarterlyStatusId=GlobalCodes.GlobalCodeId from GlobalCodes where GlobalCodes.Category='XFABIPTYPE' and GlobalCodes.Code='QUARTERLY'
select @DocumentCodeId = DocumentCodeId, @ClientId = ClientId, @EffectiveDate=EffectiveDate  from Documents where CurrentDocumentVersionId = @DocumentVersionId


CREATE TABLE #CustomDocumentFABIPs (
DocumentVersionId Int,
DocumentCodeId int,
StaffId int,
EffectiveDate datetime,
Type INT,
StaffMembers varchar(max),

TargetBehavior1 Varchar(100), 
Status1 INT,
FrequencyIntensityDuration1 Varchar(max),
Settings1 Varchar(max),
Antecedent1 Varchar(max),
ConsequenceThatReinforcesBehavior1 Varchar(max),
EnvironmentalConditions1 Varchar(max),
HypothesisOfBehavioralFunction1 Varchar(max),
ExpectedBehaviorChanges1 Varchar(max),
MethodsOfOutcomeMeasurement1 Varchar(max),
ScheduleOfOutcomeReview1 Varchar(25),
QuarterlyReview1 Varchar(Max), 

TargetBehavior2 Varchar(100), 
Status2 INT,
FrequencyIntensityDuration2 Varchar(max),
Settings2 Varchar(max),
Antecedent2 Varchar(max),
ConsequenceThatReinforcesBehavior2 Varchar(max),
EnvironmentalConditions2 Varchar(max),
HypothesisOfBehavioralFunction2 Varchar(max),
ExpectedBehaviorChanges2 Varchar(max),
MethodsOfOutcomeMeasurement2 Varchar(max),
ScheduleOfOutcomeReview2 Varchar(25),
QuarterlyReview2 Varchar(Max), 

TargetBehavior3 Varchar(100), 
Status3 INT,
FrequencyIntensityDuration3 Varchar(max),
Settings3 Varchar(max),
Antecedent3 Varchar(max),
ConsequenceThatReinforcesBehavior3 Varchar(max),
EnvironmentalConditions3 Varchar(max),
HypothesisOfBehavioralFunction3 Varchar(max),
ExpectedBehaviorChanges3 Varchar(max),
MethodsOfOutcomeMeasurement3 Varchar(max),
ScheduleOfOutcomeReview3 Varchar(25),
QuarterlyReview3 Varchar(Max), 

TargetBehavior4 Varchar(100), 
Status4 INT,
FrequencyIntensityDuration4 Varchar(max),
Settings4 Varchar(max),
Antecedent4 Varchar(max),
ConsequenceThatReinforcesBehavior4 Varchar(max),
EnvironmentalConditions4 Varchar(max),
HypothesisOfBehavioralFunction4 Varchar(max),
ExpectedBehaviorChanges4 Varchar(max),
MethodsOfOutcomeMeasurement4 Varchar(max),
ScheduleOfOutcomeReview4 Varchar(25),
QuarterlyReview4 Varchar(Max), 

TargetBehavior5 Varchar(100), 
Status5 INT,
FrequencyIntensityDuration5 Varchar(max),
Settings5 Varchar(max),
Antecedent5 Varchar(max),
ConsequenceThatReinforcesBehavior5 Varchar(max),
EnvironmentalConditions5 Varchar(max),
HypothesisOfBehavioralFunction5 Varchar(max),
ExpectedBehaviorChanges5 Varchar(max),
MethodsOfOutcomeMeasurement5 Varchar(max),
ScheduleOfOutcomeReview5 Varchar(25),
QuarterlyReview5 Varchar(Max), 

InterventionsAttempted Varchar(max),        
ReplacementBehaviors Varchar(max),
Motivators Varchar(max),
NonrestrictiveInterventions Varchar(max),
RestrictiveInterventions Varchar(max),
StaffResponsible Varchar(max),
ReceiveCopyOfPlan Varchar(max),
WhoCoordinatePlan Varchar(max),
HowCoordinatePlan Varchar(max),

UseOfManualRestraints varchar(25)
)           
--*INSERT LIST*--         
INSERT INTO #CustomDocumentFABIPs ( 
DocumentVersionId ,
DocumentCodeId,
StaffId,
EffectiveDate,
Type,
StaffMembers,
TargetBehavior1,
Status1,
FrequencyIntensityDuration1,
Settings1,
Antecedent1,
ConsequenceThatReinforcesBehavior1,
EnvironmentalConditions1,
HypothesisOfBehavioralFunction1,
ExpectedBehaviorChanges1,
MethodsOfOutcomeMeasurement1,
ScheduleOfOutcomeReview1,
QuarterlyReview1,

TargetBehavior2,
Status2,
FrequencyIntensityDuration2,
Settings2,
Antecedent2,
ConsequenceThatReinforcesBehavior2,
EnvironmentalConditions2,
HypothesisOfBehavioralFunction2,
ExpectedBehaviorChanges2,
MethodsOfOutcomeMeasurement2,
ScheduleOfOutcomeReview2,
QuarterlyReview2,

TargetBehavior3,
Status3,
FrequencyIntensityDuration3,
Settings3,
Antecedent3,
ConsequenceThatReinforcesBehavior3,
EnvironmentalConditions3,
HypothesisOfBehavioralFunction3,
ExpectedBehaviorChanges3,
MethodsOfOutcomeMeasurement3,
ScheduleOfOutcomeReview3,
QuarterlyReview3,

TargetBehavior4,
Status4,
FrequencyIntensityDuration4,
Settings4,
Antecedent4,
ConsequenceThatReinforcesBehavior4,
EnvironmentalConditions4,
HypothesisOfBehavioralFunction4,
ExpectedBehaviorChanges4,
MethodsOfOutcomeMeasurement4,
ScheduleOfOutcomeReview4,
QuarterlyReview4,

TargetBehavior5,
Status5,
FrequencyIntensityDuration5,
Settings5,
Antecedent5,
ConsequenceThatReinforcesBehavior5,
EnvironmentalConditions5,
HypothesisOfBehavioralFunction5,
ExpectedBehaviorChanges5,
MethodsOfOutcomeMeasurement5,
ScheduleOfOutcomeReview5,
QuarterlyReview5,

InterventionsAttempted,           
ReplacementBehaviors,           
Motivators,           
NonrestrictiveInterventions,
RestrictiveInterventions,
StaffResponsible,
ReceiveCopyOfPlan,
WhoCoordinatePlan,
HowCoordinatePlan,

UseOfManualRestraints
)           
--*Select LIST*--         
Select 
DocumentVersionId,
d.DocumentCodeId,
d.AuthorId,
d.EffectiveDate,
Type,
StaffParticipants,
TargetBehavior1,
Status1,
FrequencyIntensityDuration1,
Settings1,
Antecedent1,
ConsequenceThatReinforcesBehavior1,
EnvironmentalConditions1,
HypothesisOfBehavioralFunction1,
ExpectedBehaviorChanges1,
MethodsOfOutcomeMeasurement1,
ScheduleOfOutcomeReview1,
QuarterlyReview1,

TargetBehavior2,
Status2,
FrequencyIntensityDuration2,
Settings2,
Antecedent2,
ConsequenceThatReinforcesBehavior2,
EnvironmentalConditions2,
HypothesisOfBehavioralFunction2,
ExpectedBehaviorChanges2,
MethodsOfOutcomeMeasurement2,
ScheduleOfOutcomeReview2,
QuarterlyReview2,

TargetBehavior3,
Status3,
FrequencyIntensityDuration3,
Settings3,
Antecedent3,
ConsequenceThatReinforcesBehavior3,
EnvironmentalConditions3,
HypothesisOfBehavioralFunction3,
ExpectedBehaviorChanges3,
MethodsOfOutcomeMeasurement3,
ScheduleOfOutcomeReview3,
QuarterlyReview3,

TargetBehavior4,
Status4,
FrequencyIntensityDuration4,
Settings4,
Antecedent4,
ConsequenceThatReinforcesBehavior4,
EnvironmentalConditions4,
HypothesisOfBehavioralFunction4,
ExpectedBehaviorChanges4,
MethodsOfOutcomeMeasurement4,
ScheduleOfOutcomeReview4,
QuarterlyReview4,

TargetBehavior5,
Status5,
FrequencyIntensityDuration5,
Settings5,
Antecedent5,
ConsequenceThatReinforcesBehavior5,
EnvironmentalConditions5,
HypothesisOfBehavioralFunction5,
ExpectedBehaviorChanges5,
MethodsOfOutcomeMeasurement5,
ScheduleOfOutcomeReview5,
QuarterlyReview5,

InterventionsAttempted,           
ReplacementBehaviors,           
Motivators,           
NonrestrictiveInterventions,
RestrictiveInterventions,
StaffResponsible,
ReceiveCopyOfPlan,
WhoCoordinatePlan,
HowCoordinatePlan,
UseOfManualRestraints
FROM CustomDocumentFABIPs c
LEFT JOIN Documents d ON d.CurrentDocumentVersionId = @DocumentVersionId
WHERE c.DocumentVersionId = @DocumentVersionId and 
      isnull(c.RecordDeleted,'N')<>'Y'          



Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage ) 
SELECT 'CustomDocumentFABIPs', 'Type', 'Functional Behavior Assessment - Type must be specified' FROM #CustomDocumentFABIPs WHERE ISNULL(Type,'')=''          
UNION        
SELECT 'CustomDocumentFABIPs', 'StaffParticipants', 'Functional Behavior Assessment - Staff members who participated must be specified' FROM #CustomDocumentFABIPs WHERE ISNULL(StaffMembers,'') = ''
UNION
SELECT 'CustomDocumentFABIPs', 'Target Behavior 1', 'Functional Behavior Assessment - All the enteries in Target Behavior 1  must be specified' 
FROM #CustomDocumentFABIPs 
WHERE ISNULL(TargetBehavior1,'')='' OR 
	  ISNULL(Status1,0)=0 OR 
	  ISNULL(FrequencyIntensityDuration1,'')='' OR 
	  ISNULL(Settings1,'')='' OR 
	  ISNULL(Antecedent1,'')='' OR 
	  ISNULL(ConsequenceThatReinforcesBehavior1,'')='' OR 
	  ISNULL(EnvironmentalConditions1,'')='' OR 
	  ISNULL(HypothesisOfBehavioralFunction1,'')='' OR 
	  ISNULL(ExpectedBehaviorChanges1,'')='' OR 
	  ISNULL(MethodsOfOutcomeMeasurement1,'')='' OR 
	  ISNULL(ScheduleOfOutcomeReview1,'')='' OR 
	  (ISNULL(QuarterlyReview1,'')='' and [Type]=@QuarterlyStatusId) 
UNION        
SELECT 'CustomDocumentFABIPs', 'Target Behavior 2', 'Functional Behavior Assessment - All the enteries in Target Behavior 2  must be specified' 
FROM #CustomDocumentFABIPs 
WHERE ( ISNULL(TargetBehavior2,'')<>'' OR 
        ISNULL(Status2,0)<>0 OR
        ISNULL(Settings2,'')<>'' OR 
        ISNULL(Antecedent2,'')<>'' OR 
        ISNULL(ConsequenceThatReinforcesBehavior2,'')<>'' OR 
        ISNULL(EnvironmentalConditions2,'')<>'' OR 
        ISNULL(HypothesisOfBehavioralFunction2,'')<>'' OR 
        ISNULL(ExpectedBehaviorChanges2,'')<>'' OR 
        ISNULL(MethodsOfOutcomeMeasurement2,'')<>'' OR 
        ISNULL(ScheduleOfOutcomeReview2,'')<>'' OR 
        ( ISNULL(QuarterlyReview2,'')<>'' and [Type]=@QuarterlyStatusId ) ) 
        
        AND
        
      ( ISNULL(Status2,0)=0 OR 
        ISNULL(FrequencyIntensityDuration2,'')='' OR 
        ISNULL(Settings2,'')='' OR 
        ISNULL(Antecedent2,'')='' OR 
        ISNULL(ConsequenceThatReinforcesBehavior2,'')='' OR 
        ISNULL(EnvironmentalConditions2,'')='' OR 
        ISNULL(HypothesisOfBehavioralFunction2,'')='' OR 
        ISNULL(ExpectedBehaviorChanges2,'')='' OR 
        ISNULL(MethodsOfOutcomeMeasurement2,'')='' OR 
        ISNULL(ScheduleOfOutcomeReview2,'')='' OR 
        ( ISNULL(QuarterlyReview2,'')='' and [Type]=@QuarterlyStatusId ) )
UNION        
SELECT 'CustomDocumentFABIPs', 'Target Behavior 3', 'Functional Behavior Assessment - All the enteries in Target Behavior 3  must be specified' 
FROM #CustomDocumentFABIPs 
WHERE ( ISNULL(TargetBehavior3,'')<>'' OR 
        ISNULL(Status3,0)<>0 OR
        ISNULL(Settings3,'')<>'' OR 
        ISNULL(Antecedent3,'')<>'' OR 
        ISNULL(ConsequenceThatReinforcesBehavior3,'')<>'' OR 
        ISNULL(EnvironmentalConditions3,'')<>'' OR 
        ISNULL(HypothesisOfBehavioralFunction3,'')<>'' OR 
        ISNULL(ExpectedBehaviorChanges3,'')<>'' OR 
        ISNULL(MethodsOfOutcomeMeasurement3,'')<>'' OR 
        ISNULL(ScheduleOfOutcomeReview3,'')<>'' OR 
        ( ISNULL(QuarterlyReview3,'')<>'' and [Type]=@QuarterlyStatusId ) ) 
        
        AND
      ( ISNULL(Status3,0)=0 OR 
        ISNULL(FrequencyIntensityDuration3,'')='' OR 
        ISNULL(Settings3,'')='' OR 
        ISNULL(Antecedent3,'')='' OR 
        ISNULL(ConsequenceThatReinforcesBehavior3,'')='' OR 
        ISNULL(EnvironmentalConditions3,'')='' OR 
        ISNULL(HypothesisOfBehavioralFunction3,'')='' OR 
        ISNULL(ExpectedBehaviorChanges3,'')='' OR 
        ISNULL(MethodsOfOutcomeMeasurement3,'')='' OR 
        ISNULL(ScheduleOfOutcomeReview3,'')='' OR 
        ( ISNULL(QuarterlyReview3,'')='' and [Type]=@QuarterlyStatusId ) )
UNION        
SELECT 'CustomDocumentFABIPs', 'Target Behavior 4', 'Functional Behavior Assessment - All the enteries in Target Behavior 4  must be specified' 
FROM #CustomDocumentFABIPs 
WHERE ( ISNULL(TargetBehavior4,'')<>'' OR 
        ISNULL(Status4,0)<>0 OR
        ISNULL(Settings4,'')<>'' OR 
        ISNULL(Antecedent4,'')<>'' OR 
        ISNULL(ConsequenceThatReinforcesBehavior4,'')<>'' OR 
        ISNULL(EnvironmentalConditions4,'')<>'' OR 
        ISNULL(HypothesisOfBehavioralFunction4,'')<>'' OR 
        ISNULL(ExpectedBehaviorChanges4,'')<>'' OR 
        ISNULL(MethodsOfOutcomeMeasurement4,'')<>'' OR 
        ISNULL(ScheduleOfOutcomeReview4,'')<>'' OR 
        ( ISNULL(QuarterlyReview4,'')<>'' and [Type]=@QuarterlyStatusId ) ) 
        
        AND
      ( ISNULL(Status4,0)=0 OR 
        ISNULL(FrequencyIntensityDuration4,'')='' OR 
        ISNULL(Settings4,'')='' OR 
        ISNULL(Antecedent4,'')='' OR 
        ISNULL(ConsequenceThatReinforcesBehavior4,'')='' OR 
        ISNULL(EnvironmentalConditions4,'')='' OR 
        ISNULL(HypothesisOfBehavioralFunction4,'')='' OR 
        ISNULL(ExpectedBehaviorChanges4,'')='' OR 
        ISNULL(MethodsOfOutcomeMeasurement4,'')='' OR 
        ISNULL(ScheduleOfOutcomeReview4,'')='' OR 
        ( ISNULL(QuarterlyReview4,'')='' and [Type]=@QuarterlyStatusId ) )
UNION        
SELECT 'CustomDocumentFABIPs', 'Target Behavior5', 'Functional Behavior Assessment - All the enteries in Target Behavior 5  must be specified' 
FROM #CustomDocumentFABIPs 
WHERE ( ISNULL(TargetBehavior5,'')<>'' OR 
        ISNULL(Status5,0)<>0 OR
        ISNULL(Settings5,'')<>'' OR 
        ISNULL(Antecedent5,'')<>'' OR 
        ISNULL(ConsequenceThatReinforcesBehavior5,'')<>'' OR 
        ISNULL(EnvironmentalConditions5,'')<>'' OR 
        ISNULL(HypothesisOfBehavioralFunction5,'')<>'' OR 
        ISNULL(ExpectedBehaviorChanges5,'')<>'' OR 
        ISNULL(MethodsOfOutcomeMeasurement5,'')<>'' OR 
        ISNULL(ScheduleOfOutcomeReview5,'')<>'' OR 
        ( ISNULL(QuarterlyReview5,'')<>'' and [Type]=@QuarterlyStatusId ) ) 
        
        AND
      ( ISNULL(Status5,0)=0 OR 
        ISNULL(FrequencyIntensityDuration5,'')='' OR 
        ISNULL(Settings5,'')='' OR 
        ISNULL(Antecedent5,'')='' OR 
        ISNULL(ConsequenceThatReinforcesBehavior5,'')='' OR 
        ISNULL(EnvironmentalConditions5,'')='' OR 
        ISNULL(HypothesisOfBehavioralFunction5,'')='' OR 
        ISNULL(ExpectedBehaviorChanges5,'')='' OR 
        ISNULL(MethodsOfOutcomeMeasurement5,'')='' OR 
        ISNULL(ScheduleOfOutcomeReview5,'')='' OR 
        ( ISNULL(QuarterlyReview5,'')='' and [Type]=@QuarterlyStatusId ) )


UNION          
SELECT 'CustomDocumentFABIPs', 'InterventionsAttempted', 'Behavior Intervention Plan - Interventions previously attempted must be specified' FROM #CustomDocumentFABIPs WHERE ISNULL(InterventionsAttempted,'')=''          
UNION        
SELECT 'CustomDocumentFABIPs', 'ReplacementBehaviors', 'Behavior Intervention Plan - Replacement behaviors must be specified' FROM #CustomDocumentFABIPs WHERE ISNULL(ReplacementBehaviors,'')=''
UNION          
SELECT 'CustomDocumentFABIPs', 'Motivators', 'Behavior Intervention Plan - Motivators must be specified' FROM #CustomDocumentFABIPs WHERE ISNULL(Motivators,'')=''
UNION        
SELECT 'CustomDocumentFABIPs', 'NonrestrictiveInterventions', 'Behavior Intervention Plan - Nonrestrictive interventions must be specified' FROM #CustomDocumentFABIPs WHERE ISNULL(NonrestrictiveInterventions,'')=''
UNION          
SELECT 'CustomDocumentFABIPs', 'RestrictiveInterventions', 'Behavior Intervention Plan - Restrictive interventions must be specified' FROM #CustomDocumentFABIPs WHERE ISNULL(RestrictiveInterventions,'')=''
UNION        
SELECT 'CustomDocumentFABIPs', 'StaffResponsible', 'Behavior Intervention Plan - Responsible Staff must be specified' FROM #CustomDocumentFABIPs WHERE ISNULL(StaffResponsible,'')=''
UNION          
SELECT 'CustomDocumentFABIPs', 'ReceiveCopyOfPlan', 'Behavior Intervention Plan - Copy of this plan must be specified' FROM #CustomDocumentFABIPs WHERE ISNULL(ReceiveCopyOfPlan,'')=''
UNION        
SELECT 'CustomDocumentFABIPs', 'WhoCoordinatePlan', 'Behavior Intervention Plan - Coordinate the plan must be specified' FROM #CustomDocumentFABIPs WHERE ISNULL(WhoCoordinatePlan,'')=''
UNION          
SELECT 'CustomDocumentFABIPs', 'HowCoordinatePlan', 'Behavior Intervention Plan - Coordinated with the student�s parent(s) must be specified' FROM #CustomDocumentFABIPs WHERE ISNULL(HowCoordinatePlan,'')=''
--UNION
--SELECT 'CustomDocumentFABIPs', 'UseOfManualRestraints', 'Behavior Intervention Plan - f Manual Restraints can only be updated in FBA/BIP - Restraints document.' FROM #CustomDocumentFABIPs WHERE DocumentCodeId <> 10036 AND ISNULL(UseOfManualRestraints,'') <> ''
UNION
SELECT 'CustomDocumentFABIPs', 'UseOfManualRestraints', 'Behavior Intervention Plan - Only MD is allowed to set f Manual Restraints field.' FROM #CustomDocumentFABIPs WHERE NOT EXISTS ( SELECT * FROM StaffLicenseDegrees sld WHERE sld.StaffId = StaffId AND sld.LicenseTypeDegree = 25204 AND sld.StartDate <= EffectiveDate AND ISNULL(sld.EndDate, EffectiveDate) >= EffectiveDate ) AND ISNULL(UseOfManualRestraints,'') <> ''
UNION
SELECT 'CustomDocumentFABIPs', 'UseOfManualRestraints', 'Behavior Intervention Plan - f Manual Restraints must be specified' FROM #CustomDocumentFABIPs WHERE ISNULL(UseOfManualRestraints,'') = ''

-- Set Variables sql text
DECLARE @Variables varchar(max)  
SET @Variables = 'DECLARE @DocumentVersionId int
				  SET @DocumentVersionId = ' + convert(varchar(20), @DocumentVersionId) +
				    'DECLARE @EffectiveDate datetime  
					SET @EffectiveDate = ''' + CONVERT(varchar(20), @EffectiveDate, 101) + '''' + 
				 'DECLARE @ClientId int
				  SET @ClientId = ' + CONVERT(varchar(20),@ClientId) 
				  
-- Exec csp_validateDocumentsTableSelect to determine validation list  
If Not Exists (Select * From CustomDocumentValidationExceptions where DocumentVersionId = @DocumentVersionId and DocumentValidationid is null)  
Begin  
	Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables  
End  


END TRY
BEGIN CATCH

DECLARE @Error VARCHAR(8000)                                
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())             
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_validateCustomDocumentFABIPs')                                 
+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                  
+ '*****' + Convert(varchar,ERROR_STATE())                                
RAISERROR                                 
(                                
@Error, -- Message text.                                
16,  -- Severity.                                
1  -- State.                                
);        
END CATCH                          
END

GO


