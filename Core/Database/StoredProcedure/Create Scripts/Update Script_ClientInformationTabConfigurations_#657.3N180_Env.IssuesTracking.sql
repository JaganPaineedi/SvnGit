/*Update script to update the Record deleted value to NULL in ClientInformationTabConfigurations*/
/*What :- QI reporting Tab missing in Client Information(C) */
/*Why  :- #657.3 - Network180 Environment Issues Tracking*/

UPDATE ClientInformationTabConfigurations SET RecordDeleted = NULL WHERE TabName = 'QI Reporting' AND ScreenId = 969

