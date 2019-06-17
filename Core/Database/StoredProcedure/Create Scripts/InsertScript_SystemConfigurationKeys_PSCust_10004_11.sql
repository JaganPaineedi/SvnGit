declare @UserCode varchar(30) = 'PSSCust10004_11'

insert into SystemConfigurationKeys(CreatedBy,ModifiedBy,[Key],[Value],[Description],AcceptedValues,AllowEdit,ShowKeyForViewingAndEditing)

select @UserCode,@UserCode,'CarePlanUseCustomGoalInitialization','N','When set to "Y", custom initialization logic will be used to initalize care plan goals Client Goal field when the Add Goal hyper link is clicked.','Y,N','Y','Y'
where not exists( select 1
				from SystemConfigurationKeys
				where [Key] = 'CarePlanUseCustomGoalInitialization'
				)