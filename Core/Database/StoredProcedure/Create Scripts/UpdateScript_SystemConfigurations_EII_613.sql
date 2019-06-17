
IF EXISTS(Select 1 from SystemConfigurations)
BEGIN
Update SystemConfigurations set ScreenCustomTabExceptions = ScreenCustomTabExceptions + ',490,492,508'
END