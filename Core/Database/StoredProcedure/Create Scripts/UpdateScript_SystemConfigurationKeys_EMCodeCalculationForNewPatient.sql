if exists ( select  1
            from    dbo.SystemConfigurationKeys as sck
            where   sck.[Key] = 'EMCodeCalculationForNewPatient' )
    begin

        update  dbo.SystemConfigurationKeys
        set     AcceptedValues = 'Y,N,O'
              , Description = 'The EMCode calculation can yeild higher results for a new patient visit compared to an existing patient visit. This key allows us to enable higher or lower code generation for new/existing patient visits. If the key value is N, then the system will calculate it based on patient being new or existing patient selection in the UI. If the value of the key is Y then the system will calculate result for a new patient code regardless of the patient being new or existing from the UI. If the value is O then the system will calculate results for an existing patient regardless of the patient being new or existing from the UI.'
        where   [Key] = 'EMCodeCalculationForNewPatient';
    end;
