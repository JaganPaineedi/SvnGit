-- Insert script for Key MARShiftEndTime & CreateMARONLYDuringShiftTimes. PEP - Support Go Live > Tasks#37 > Shift MAR Configuration Keys 
IF NOT EXISTS ( SELECT  *
                FROM    SystemConfigurationKeys
                WHERE   [Key] = 'MARShiftEndTime' )
    BEGIN
        INSERT  INTO SystemConfigurationKeys
                ( [CreatedBy],
				  [CreateDate],
				  [ModifiedBy],
				  [ModifiedDate],
                  [Key] ,
                  [Value] ,
                  [Description] ,
                  [AcceptedValues],
                  [ShowKeyForViewingAndEditing],
                  [AllowEdit]
                )
        VALUES  ( 	SYSTEM_USER
					,CURRENT_TIMESTAMP
					,SYSTEM_USER
					,CURRENT_TIMESTAMP
                  ,'MARShiftEndTime' 
                  ,'16:00' 
                  ,'Read Key as -- MAR Shift End Time. The value of this key is set to a MAR shift end time, which is entered in 24 hour format. 
                    The value of this Key will be used to create MAR (Medication Administration Record) till shift end time if another System Key ''CreateMARONLYDuringShiftTimes'' value is ''Yes''. 
                    When the Key ''CreateMARONLYDuringShiftTimes'' value is set to ''No'' then MAR will be created as per shift frequency and there will be no impact of key MARShiftEndTime value.' 
                  ,'Any value in format of HH:MM'
                  ,'Y'
                  ,'Y'
                );

    END;


IF NOT EXISTS ( SELECT  *
                FROM    SystemConfigurationKeys
                WHERE   [Key] = 'CreateMARDuringShiftTimes' )
    BEGIN

        INSERT  INTO SystemConfigurationKeys
                ( [CreatedBy],
				  [CreateDate],
				  [ModifiedBy],
				  [ModifiedDate],
                  [Key] ,
                  [Value] ,
                  [Description] ,
                  [AcceptedValues],
                  [ShowKeyForViewingAndEditing],
                  [AllowEdit]
                )
        VALUES  ( SYSTEM_USER
				,CURRENT_TIMESTAMP
				,SYSTEM_USER
				,CURRENT_TIMESTAMP
                  ,'CreateMARDuringShiftTimes' 
                  ,'No' 
                  ,'Read Key as -- Create MAR During Shift Times.
                  When the key value  is set as “Yes”,then the MAR will be created during ShiftStartTime and ShiftEndTime key value.
                  Please make sure that the Key MARShiftEndTime value is set as per business logic. The default value is set for key MARShiftEndTime is ''16:00'' 
                  When the Value is set as “No”, then the MAR record will be created as per Frequency time and this is default behaviour.' 
                  ,'Yes/No'
                  ,'Y'
                  ,'Y'
                );
 
    END;
   
  