-- Update script for SystemConfigurationKeys table , column AllowEdit='Y'
-- Engineering Improvement Initiatives- NBL(I) > Tasks #501> 
-- All SystemConfiguraionKeys should allow edit by customers except few we want to control that.

Update SystemConfigurationKeys Set AllowEdit='Y', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE  ISNULL(RecordDeleted, 'N') = 'N'

Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'UseResourceForService' AND ISNULL(RecordDeleted, 'N') = 'N'
										
Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'DISPLAYCAREMANAGEMENTTAB' AND ISNULL(RecordDeleted, 'N') = 'N'

Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'EnableSADemographicTab' AND ISNULL(RecordDeleted, 'N') = 'N'

Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'DisplayProviderDropDown' AND ISNULL(RecordDeleted, 'N') = 'N'										

Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'CoreDataModelVersion4.0' AND ISNULL(RecordDeleted, 'N') = 'N'	

Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'DirectMessageRetieveListURL' AND ISNULL(RecordDeleted, 'N') = 'N'						

Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'DirectMessageRetieveURL' AND ISNULL(RecordDeleted, 'N') = 'N'

Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'DirectMessageAttachmentRetieveURL' AND ISNULL(RecordDeleted, 'N') = 'N'

Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'DirectMessageUploadeAttachmentURL' AND ISNULL(RecordDeleted, 'N') = 'N'

Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'DirectMessageSendURL' AND ISNULL(RecordDeleted, 'N') = 'N'

Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'RXEnableFormulary' AND ISNULL(RecordDeleted, 'N') = 'N'

Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'LABSOFTENABLED' AND ISNULL(RecordDeleted, 'N') = 'N'

Update SystemConfigurationKeys Set AllowEdit='N', ModifiedBy='Admin',ModifiedDate = getDate()
					WHERE [Key] = 'UseResourceForService' AND ISNULL(RecordDeleted, 'N') = 'N'


					