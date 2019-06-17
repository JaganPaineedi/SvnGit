IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryGeneralInfo' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryGeneralInfo', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryClientInfo' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryClientInfo', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryCareTeam' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryCareTeam', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryDiagnosis' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryDiagnosis', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryVitals' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryVitals', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryAllergies' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryAllergies', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummarySmokingStatus' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummarySmokingStatus', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryCurrentMedication' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryCurrentMedication', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryImmunizations' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryImmunizations', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryRadiologyResultReviewed' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryRadiologyResultReviewed', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryMostRecentLevelofFunctioning' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryMostRecentLevelofFunctioning', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryReasonforReferral' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryReasonforReferral', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryGoalsObjectives' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryGoalsObjectives', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowTransitionCareSummaryProcedure' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowTransitionCareSummaryProcedure', null)
END
GO

IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'ShowEncounterEventDocumentationOnSummaryOfCare' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value)
    VALUES ('ShowEncounterEventDocumentationOnSummaryOfCare', NULL)
END
GO



