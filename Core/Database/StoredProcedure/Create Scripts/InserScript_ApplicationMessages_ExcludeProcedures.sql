insert into ApplicationMessages (PrimaryScreenId,MessageCode,OriginalText,Override,OverrideText)
Values(0,'EXCLUDEALLPROCEDURE_DD','Exclude All Procedures','Y','Exclude All Procedures')

insert into ApplicationMessageScreens (ApplicationMessageId,ScreenId) Values ((Select ApplicationMessageId from ApplicationMessages where MessageCode ='EXCLUDEALLPROCEDURE_DD') ,0)
