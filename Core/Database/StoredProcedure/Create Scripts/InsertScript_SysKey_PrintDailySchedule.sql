--Project: AHN-Support Go Live
--Task: 18 - Reception: Icons will not work for any Primary Care Appointments

-- Insert script for SystemConfigurationKeys for the KEY 'XDISPLAYSECTIONSONBHTEDSDISCHARGE' to 'N' except for SWMBH 
IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'USESTAFFIDFORPRINTDAILYSCHEDULE' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value,[Description])
    VALUES ('USESTAFFIDFORPRINTDAILYSCHEDULE', 'N','This key is used to set StaffId as parametter for print daily schedule report') 
END
GO

