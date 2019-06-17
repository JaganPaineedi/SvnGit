-- Insert script to insert values into States table as per MHP-Support Go Live #426
 

if not exists (select * from dbo.States as s where s.StateFIPS = '43')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName])
VALUES('43','PR','Puerto Rico')
end

if not exists (select * from dbo.States as s where s.StateFIPS = '52')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName])
VALUES('52','VI','Virgin Islands of the U.S')
end

if not exists (select * from dbo.States as s where s.StateFIPS = '60')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName])
VALUES('60','AS','American Samoa')
end

if not exists (select * from dbo.States as s where s.StateFIPS = '66')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName])
VALUES('66','GU','Guam')
end

if not exists (select * from dbo.States as s where s.StateFIPS = '68')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName])
VALUES('68','MH','Marshall Islands')
end

if not exists (select * from dbo.States as s where s.StateFIPS = '70')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName])
VALUES('70','PW','Palau')
end


