
--Author: MD Hussain Khusro
--Date: 12/14/2016
--Task: Valley - Support Go Live #993


If Not Exists (Select 1 from SystemConfigurationKeys Where [Key]='DisclosureWaterMarkFontSize')
Begin
	insert into SystemConfigurationKeys ([Key],Value,[Description],AcceptedValues,ShowKeyForViewingAndEditing,Modules,Screens)
	values ('DisclosureWaterMarkFontSize','30','This Key is used to set font size of watermark text','Any Integer value for font size of watermark text. Default value is 30.','Y','Disclosure/Request Details',26 )
End

If Not Exists (Select 1 from SystemConfigurationKeys Where [Key]='DisclosureWaterMarkPosition')
Begin
	insert into SystemConfigurationKeys ([Key],Value,[Description],AcceptedValues,ShowKeyForViewingAndEditing,Modules,Screens)
	values ('DisclosureWaterMarkPosition','Center','This Key is used to set position of watermark text. Position should be either Top or Center. Top - Display watermark on top of PDF and Center - Display watermark diagonally on center of PDF.','Top,Center','Y','Disclosure/Request Details',26 )
End
