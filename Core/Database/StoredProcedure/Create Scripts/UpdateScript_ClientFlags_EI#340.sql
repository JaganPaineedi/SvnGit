--Script by Veena on 05/19/2016 for EI #340

IF EXISTS(Select Screenid from Screens  where screenid=922 and screenname='Client Notes')
Update screens set Screenname ='Client Flags' where screenid=922 and screenname='Client Notes'
IF EXISTS(Select Screenid from banners  where displayas='Client Notes' and tabid=1 and screenid=922)
Update banners set Displayas='Client Flags' where displayas='Client Notes' and tabid=1 and screenid=922


