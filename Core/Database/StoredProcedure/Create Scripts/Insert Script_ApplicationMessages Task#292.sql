/*****************************************************************************************************************
Author			:  Munish Sood
CreatedDate		:  10 Nov 2016 
Purpose			:  Insert script to add ApplicationMessages and  eApplicationMessageScreens
Engineering Improvement Initiatives- NBL(I) Task# 292 
*****************************************************************************************************************/

Declare @ApplicationMessageId int

If Not exists (Select * from ApplicationMessages where MessageCode ='SAVEAUTHORIZATIONCODE')
Begin
Insert Into ApplicationMessages (PrimaryScreenId, MessageCode, OriginalText, Override,OverrideText)
Values(81, 'SAVEAUTHORIZATIONCODE','You have broken the rule. It will not let you save unless the mapping values are compatible.',
'Y', 'Authorization Code Unit Type must be compatible with the ‘Entered As’ value on the procedure code selected')
End


Set @ApplicationMessageId=@@IDENTITY
If not exists (Select 1 from ApplicationMessageScreens where ScreenId= 81)
Begin
Insert into ApplicationMessageScreens (ApplicationMessageId, ScreenId)
Values(@ApplicationMessageId, 81)
End
Go