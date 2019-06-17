/********************************************************************************************
Author		:	Talasu Hemant Kumar
CreatedDate	:	10/05/2017
Purpose		:	To disable the row in the pop up. (My Office -->Bed Census-->Click the Attendance screen toolbar) 
                Why:Do not allow the user to modify the Attendance Record if there is already an Attendance Record 
                    in the system and there is a Service ID associated to the attendance record and the Service ID's status 
                    is anything BUT Error.
     Project:Woods - Support Go Live #732
*********************************************************************************************/

IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [key] = 'DisableBedAttendanceRow')
 BEGIN
  INSERT INTO [dbo].[SystemConfigurationKeys]
       ([Key]
       ,[Value]
       ,[Description]
       ,[AllowEdit]
       ,[AcceptedValues]
       )
    VALUES    
       ('DisableBedAttendanceRow'
       ,'N'
       ,'This Key belongs to Bed Census and the Attendance pop up on Bed Census.  We need to not allow the user to modify the Attendance Record if there is already an Attendance Record in the system and there is a Service ID associated to the attendance record and the Service ID`s status is anything BUT Error.'
       ,'Y'
       ,'Y,N'
       )
 END