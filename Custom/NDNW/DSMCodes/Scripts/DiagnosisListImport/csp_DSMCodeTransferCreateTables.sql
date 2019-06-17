create procedure csp_DSMCodeTransferCreateTables

as

if not exists (select * from sys.tables where name = 'ztemp')
begin
	create table ztemp (DC int, DSMCode float, DSMNumber int)
end


if not exists (select * from sys.tables where name = 'zztemp')
begin
	create table zztemp (DC int, DSMCode text, DSMNumber int)
end





