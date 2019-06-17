-- Insert script for SystemConfigurationKeys AllowedAmountNegativeAdjustment
-- Valley - Support Go Live - Task #710 - SC: 837: Claims not sending the allowed amount
if not exists ( select  *
                from    SystemConfigurationKeys
                where   [key] = 'AllowedAmountNegativeAdjustment' ) 
  begin
    insert  into [dbo].[SystemConfigurationKeys]
            ([Key],
             [Value],
             [Description],
             [AcceptedValues],
             [ShowKeyForViewingAndEditing],
             [Modules])
    values  ('AllowedAmountNegativeAdjustment',
             'N',
             'Allowed Amount Adjustment process can post a negative adjustment on a charge',
             'Y,N',
             'Y',
             'Charges/Claims')
            
  end

 