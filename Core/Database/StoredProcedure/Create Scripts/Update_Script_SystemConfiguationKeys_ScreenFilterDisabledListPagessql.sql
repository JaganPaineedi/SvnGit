--Created By Hemant     6/30/2016     Included "Payment/Adjustment Posting" screenId to fix the Paging issue.
   
--select Value from SystemConfigurationKeys WHERE[key] = 'ScreenFilterDisabledListPages'
--select * from StaffScreenFilters WHERE ScreenId = 323

IF EXISTS(SELECT 1 FROM StaffScreenFilters WHERE ScreenId = 323) BEGIN DELETE
FROM
StaffScreenFilters
WHERE
ScreenId = 323
END

IF EXISTS(
    SELECT 1 FROM SystemConfigurationKeys WHERE[key] = 'ScreenFilterDisabledListPages'
) BEGIN UPDATE
SystemConfigurationKeys
SET
Value = '368,323'
WHERE
    [key] = 'ScreenFilterDisabledListPages'
END

