
IF NOT EXISTS (SELECT [ScreenId] FROM ScreenPermissionControls WHERE [ControlName] = 'RadioButton_Clients_ClientType_I' AND [SCREENID] = 27)
BEGIN
insert into ScreenPermissionControls(ScreenId,ControlName,DisplayAs,Active)
values (27,'RadioButton_Clients_ClientType_I','RadioButton ClientType I','Y')
END
else
BEGIN
update  ScreenPermissionControls set ControlName= 'RadioButton_Clients_ClientType_I',DisplayAs='RadioButton ClientType I',
Active = 'Y' where ScreenId = 27 and ControlName= 'RadioButton_Clients_ClientType_I'
END


IF NOT EXISTS (SELECT [ScreenId] FROM ScreenPermissionControls WHERE [ControlName] = 'RadioButton_Clients_ClientType_O' AND [SCREENID] = 27)
BEGIN
insert into ScreenPermissionControls(ScreenId,ControlName,DisplayAs,Active)
values (27,'RadioButton_Clients_ClientType_O','RadioButton ClientType O','Y')
END
else
BEGIN
update  ScreenPermissionControls set ControlName= 'RadioButton_Clients_ClientType_O',DisplayAs='RadioButton ClientType O',
Active = 'Y' where ScreenId = 27 and ControlName= 'RadioButton_Clients_ClientType_O'
END