if not exists (select * from dbo.States as s where s.StateFIPS = '71')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('71','AB',' Alberta, Canada',CAST ('806ca9bf-34ba-4801-802d-2dc13fe53723' as uniqueidentifier))
end

if not exists (select * from dbo.States as s where s.StateFIPS = '72')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('72','BC',' British Columbia,, Canada',CAST ('889c312a-c93a-4bc1-8341-ea117be778ca' as uniqueidentifier))
end

if not exists (select * from dbo.States as s where s.StateFIPS = '73')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('73','MB',' Manitoba, Canada',CAST ('cf11cf40-7aa2-4baf-8dc2-1c8165deb7b4' as uniqueidentifier))
end

if not exists (select * from dbo.States as s where s.StateFIPS = '74')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('74','NB',' New Brunswick, Canada',CAST ('bef420db-66ac-4c78-9d00-95df12ddfbeb' as uniqueidentifier))
end

if not exists (select * from dbo.States as s where s.StateFIPS = '75')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('75','NL',' Newfoundland and Labrador, Canada',CAST ('4ab84dab-f534-4dde-937d-ac4a1f6b2a22' as uniqueidentifier))
end

if not exists (select * from dbo.States as s where s.StateFIPS = '76')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('76','NT',' Northwest Territories, Canada',CAST ('d4647c5a-2ece-44b0-88b8-cf2c4f27706e' as uniqueidentifier))
end

if not exists (select * from dbo.States as s where s.StateFIPS = '77')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('77','NS',' Nova Scotia, Canada',CAST ('b753e38f-deea-4938-968c-dc4a0b770f58' as uniqueidentifier))
end

if not exists (select * from dbo.States as s where s.StateFIPS = '78')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('78','NU',' Nunavut, Canada',CAST ('58551a46-7678-4ba6-b65e-ab97aaf8c229' as uniqueidentifier))
end

if not exists (select * from dbo.States as s where s.StateFIPS = '79')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('79','ON',' Ontario, Canada',CAST ('f96876ce-4cd9-4d41-8cb2-1ae49628da0f' as uniqueidentifier))
end

if not exists (select * from dbo.States as s where s.StateFIPS = '80')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('80','PE',' Prince Edward Island, Canada',CAST ('7ffab5f2-3fd3-4d54-8b2f-95792505e9b9' as uniqueidentifier))
end

if not exists (select * from dbo.States as s where s.StateFIPS = '81')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('81','QC',' Quebec, Canada',CAST ('5df6924c-7079-4b37-be04-b70201e02736' as uniqueidentifier))
end

if not exists (select * from dbo.States as s where s.StateFIPS = '82')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('82','SK',' Saskatchewan, Canada',CAST ('9a3ec772-f1a4-40fc-963f-256ac76b8219' as uniqueidentifier))
end

if not exists (select * from dbo.States as s where s.StateFIPS = '83')
begin
insert INTO [States]([StateFIPS],[StateAbbreviation],[StateName],[RowIdentifier])
VALUES('83','YT',' Yukon, Canada',CAST ('0f11e447-2f61-4b75-8676-69cb21f99bdf' as uniqueidentifier))
end


