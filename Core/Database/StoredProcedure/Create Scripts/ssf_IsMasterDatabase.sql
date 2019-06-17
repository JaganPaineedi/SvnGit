if object_id('dbo.ssf_IsMasterDatabase') is not null 
  drop function dbo.ssf_IsMasterDatabase
go

create function dbo.ssf_IsMasterDatabase ()
returns char(1)
/*************************************************
-- Function: dbo.ssf_IsMasterDatabase
--
-- Copyright: Streamline Healthcare Solutions
-- 
-- Purpose: determines if the current database is a Master database
--
-- Updates:                 
--  Date         Author    Purpose                
-- 09.16.2015    SFarber   Created.         
**************************************************/
as 
begin

  declare @ConnectionString varchar(250)
  declare @IsMasterDatabase char(1) = 'N'

  select  @ConnectionString = replace(sd.ConnectionString, ' ', '') + ';'
  from    SystemDatabases sd
  where   sd.MasterDatabase = 'Y'

  if (isnull(@ConnectionString, '') = '' or @ConnectionString like '%InitialCatalog=' + db_name() + ';%') 
    begin
      set @IsMasterDatabase = 'Y'
    end

  return @IsMasterDatabase

end

go
