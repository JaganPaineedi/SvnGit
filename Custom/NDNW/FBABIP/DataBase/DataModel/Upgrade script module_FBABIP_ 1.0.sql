/****** Object:  Table [dbo].[CustomDocumentFABIPs]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentFABIPs]') AND type in (N'U'))
DROP TABLE [dbo].[CustomDocumentFABIPs]
GO

CREATE TABLE CustomDocumentFABIPs(
    DocumentVersionId                     int                     NOT NULL,
    CreatedBy                             type_CurrentUser        NOT NULL,
    CreatedDate                           type_CurrentDatetime    NOT NULL,
    ModifiedBy                            type_CurrentUser        NOT NULL,
    ModifiedDate                          type_CurrentDatetime    NOT NULL,
    RecordDeleted                         type_YOrN               NULL
                                          CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                             type_UserId             NULL,
    DeletedDate                           datetime                NULL,
    Type                                  type_GlobalCode         NULL,
    StaffParticipants                     type_Comment2           NULL,
    TargetBehavior1                       varchar(100)            NULL,
    Status1                               type_GlobalCode         NULL,
    FrequencyIntensityDuration1           type_Comment2           NULL,
    Settings1                             type_Comment2           NULL,
    Antecedent1                           type_Comment2           NULL,
    ConsequenceThatReinforcesBehavior1    type_Comment2           NULL,
    EnvironmentalConditions1              type_Comment2           NULL,
    HypothesisOfBehavioralFunction1       type_Comment2           NULL,
    ExpectedBehaviorChanges1              type_Comment2           NULL,
    MethodsOfOutcomeMeasurement1          type_Comment2           NULL,
    ScheduleOfOutcomeReview1              varchar(25)             NULL,
    QuarterlyReview1                      type_Comment2           NULL,
    TargetBehavior2                       varchar(100)            NULL,
    Status2                               type_GlobalCode         NULL,
    FrequencyIntensityDuration2           type_Comment2           NULL,
    Settings2                             type_Comment2           NULL,
    Antecedent2                           type_Comment2           NULL,
    ConsequenceThatReinforcesBehavior2    type_Comment2           NULL,
    EnvironmentalConditions2              type_Comment2           NULL,
    HypothesisOfBehavioralFunction2       type_Comment2           NULL,
    ExpectedBehaviorChanges2              type_Comment2           NULL,
    MethodsOfOutcomeMeasurement2          type_Comment2           NULL,
    ScheduleOfOutcomeReview2              varchar(25)             NULL,
    QuarterlyReview2                      type_Comment2           NULL,
    TargetBehavior3                       varchar(100)            NULL,
    Status3                               type_GlobalCode         NULL,
    FrequencyIntensityDuration3           type_Comment2           NULL,
    Settings3                             type_Comment2           NULL,
    Antecedent3                           type_Comment2           NULL,
    ConsequenceThatReinforcesBehavior3    type_Comment2           NULL,
    EnvironmentalConditions3              type_Comment2           NULL,
    HypothesisOfBehavioralFunction3       type_Comment2           NULL,
    ExpectedBehaviorChanges3              type_Comment2           NULL,
    MethodsOfOutcomeMeasurement3          type_Comment2           NULL,
    ScheduleOfOutcomeReview3              varchar(25)             NULL,
    QuarterlyReview3                      type_Comment2           NULL,
    ConsequenceThatReinforcesBehavior4    type_Comment2           NULL,
    EnvironmentalConditions4              type_Comment2           NULL,
    HypothesisOfBehavioralFunction4       type_Comment2           NULL,
    ExpectedBehaviorChanges4              type_Comment2           NULL,
    MethodsOfOutcomeMeasurement4          type_Comment2           NULL,
    ScheduleOfOutcomeReview4              varchar(25)             NULL,
    QuarterlyReview4                      type_Comment2           NULL,
    TargetBehavior4                       varchar(100)            NULL,
    Status4                               type_GlobalCode         NULL,
    FrequencyIntensityDuration4           type_Comment2           NULL,
    Settings4                             type_Comment2           NULL,
    Antecedent4                           type_Comment2           NULL,
    TargetBehavior5                       varchar(100)            NULL,
    Status5                               type_GlobalCode         NULL,
    FrequencyIntensityDuration5           type_Comment2           NULL,
    Settings5                             type_Comment2           NULL,
    Antecedent5                           type_Comment2           NULL,
    ConsequenceThatReinforcesBehavior5    type_Comment2           NULL,
    EnvironmentalConditions5              type_Comment2           NULL,
    HypothesisOfBehavioralFunction5       type_Comment2           NULL,
    ExpectedBehaviorChanges5              type_Comment2           NULL,
    MethodsOfOutcomeMeasurement5          type_Comment2           NULL,
    ScheduleOfOutcomeReview5              varchar(25)             NULL,
    QuarterlyReview5                      type_Comment2           NULL,
    InterventionsAttempted                type_Comment2           NULL,
    ReplacementBehaviors                  type_Comment2           NULL,
    Motivators                            type_Comment2           NULL,
    NonrestrictiveInterventions           type_Comment2           NULL,
    RestrictiveInterventions              type_Comment2           NULL,
    StaffResponsible                      type_Comment2           NULL,
    ReceiveCopyOfPlan                     type_Comment2           NULL,
    WhoCoordinatePlan                     type_Comment2           NULL,
    HowCoordinatePlan                     type_Comment2           NULL,
    UseOfManualRestraints                 type_GlobalCode         NULL,
    CONSTRAINT CustomDocumentFABIPs_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)
go



IF OBJECT_ID('CustomDocumentFABIPs') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentFABIPs >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomDocumentFABIPs >>>'
go



ALTER TABLE CustomDocumentFABIPs ADD CONSTRAINT DocumentVersions_CustomDocumentFABIPs_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
go
