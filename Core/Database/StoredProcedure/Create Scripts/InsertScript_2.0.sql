/********************************************************************************                                                        
         
-- Copyright: Streamline Healthcare Solutions          
--          
-- Purpose: Called in Insert screen for KPIMaster        
--          
/* Data Modifications:                                               */    
/*                                                                   */    
/*   Date  		Author       Purpose                                    */    
/*   7 Mar 2019    Abhishek     Created                        */    
/*********************************************************************/       
*********************************************************************************/
SET IDENTITY_INSERT KPIMaster ON
INSERT INTO [KPIMaster] ([KPIMasterId], [KPIName], [KPIDescription], [Category], [Type], [CollectionPeriod], [RetentionPeriod], [CollectionMethod], [Active], [RawData], [RawDataTableName], [CollectionStoredProcedure], [ProcessingStoredProcedure])
  VALUES (36, 'Electronic Scripts Alerts', 'Number of Instances for Measurement Period', (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'KPICategory' AND CodeName = 'Interface'), (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'KPIType' AND CodeName = 'Count'), 86400, 0, (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'CollectionMethod' AND CodeName = 'Manual'), 'Y', 'N', 'KPILog', 'ssp_SCKPIReportElectronicScriptsAlerts', 'ssp_SCKPIReportProcessAlerts')
  INSERT INTO [KPIMaster] ([KPIMasterId], [KPIName], [KPIDescription], [Category], [Type], [CollectionPeriod], [RetentionPeriod], [CollectionMethod], [Active], [RawData], [RawDataTableName], [CollectionStoredProcedure], [ProcessingStoredProcedure])
  VALUES (37, 'Fax Scripts ScriptActivities Alerts', 'Number of Instances for Measurement Period', (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'KPICategory' AND CodeName = 'Interface'), (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'KPIType' AND CodeName = 'Count'), 86400, 0, (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'CollectionMethod' AND CodeName = 'Manual'), 'Y', 'N', 'KPILog', 'ssp_SCKPIReportFaxScriptsAlerts', 'ssp_SCKPIReportProcessAlerts')
   INSERT INTO [KPIMaster] ([KPIMasterId], [KPIName], [KPIDescription], [Category], [Type], [CollectionPeriod], [RetentionPeriod], [CollectionMethod], [Active], [RawData], [RawDataTableName], [CollectionStoredProcedure], [ProcessingStoredProcedure])
  VALUES (38, 'Fax Scripts FaxActivities Alerts', 'Number of Instances for Measurement Period', (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'KPICategory' AND CodeName = 'Interface'), (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'KPIType' AND CodeName = 'Count'), 86400, 0, (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'CollectionMethod' AND CodeName = 'Manual'), 'Y', 'N', 'KPILog', 'ssp_SCKPIReportFaxScriptActivitiesAlerts', 'ssp_SCKPIReportProcessAlerts')
  INSERT INTO [KPIMaster] ([KPIMasterId], [KPIName], [KPIDescription], [Category], [Type], [CollectionPeriod], [RetentionPeriod], [CollectionMethod], [Active], [RawData], [RawDataTableName], [CollectionStoredProcedure], [ProcessingStoredProcedure])
  VALUES (39, 'DEExportMessages Alerts', 'Number of Instances for Measurement Period', (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'KPICategory' AND CodeName = 'Interface'), (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'KPIType' AND CodeName = 'Count'), 86400, 0, (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'CollectionMethod' AND CodeName = 'Manual'), 'Y', 'N', 'KPILog', 'ssp_SCKPIReportDEExportMessagesAlerts', 'ssp_SCKPIReportProcessAlerts')
  INSERT INTO [KPIMaster] ([KPIMasterId], [KPIName], [KPIDescription], [Category], [Type], [CollectionPeriod], [RetentionPeriod], [CollectionMethod], [Active], [RawData], [RawDataTableName], [CollectionStoredProcedure], [ProcessingStoredProcedure])
  VALUES (40, 'DEImportMessages Alerts', 'Number of Instances for Measurement Period', (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'KPICategory' AND CodeName = 'Interface'), (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'KPIType' AND CodeName = 'Count'), 86400, 0, (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = 'CollectionMethod' AND CodeName = 'Manual'), 'Y', 'N', 'KPILog', 'ssp_SCKPIReportDEImportMessagesAlerts', 'ssp_SCKPIReportProcessAlerts')  
   SET IDENTITY_INSERT KPIMaster OFF