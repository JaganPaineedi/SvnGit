/*Update script to update the Record deleted value to NULL in ClientInformationTabConfigurations*/
/*What :- QI reporting Tab missing in Client Information(C) */
/*Why  :- #657.3 - Network180 Environment Issues Tracking*/

DELETE FROM ClientInformationTabConfigurations  WHERE TabName = 'QI Reporting' AND ScreenId = 969





