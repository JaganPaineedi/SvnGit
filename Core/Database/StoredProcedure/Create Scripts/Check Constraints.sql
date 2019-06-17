/* Enables checking constrainsts on data that was loaded BEFORE the check constraints was enabled. When a constraint is disabled for an initial data conversion and then re-enabled doing a CHECK CONSTRAINTS
	only checks data integrity for data inserted/updated going forward. If existing data needs to be checked then CHECK CHECK CONSTRAINT must be run. Running this script may result in errors due to bad data.
	Please take note of which constraints failed and create support tickets so the data can be corrected. The reason this is being done as part of performance optimization is enabling this check helps
	SQL Server query optimizer to come up with better plans. This script can be run any time and doesn't effect end users currently using the system 
*/
DECLARE @sqlcommandconstraint varchar(max);

SELECT @sqlcommandconstraint =
STUFF((
	SELECT '; ' + 'ALTER TABLE [' + s.name + '].[' + o.name + '] WITH CHECK CHECK CONSTRAINT [' + i.name + ']' 
	from sys.check_constraints i
	INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
	INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
	WHERE i.is_not_trusted = 1 AND i.is_not_for_replication = 0 AND i.is_disabled = 0
FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)'),1,2,N'')

exec(@sqlcommandconstraint);

DECLARE @sqlcommandfk varchar(max);
 
SELECT @sqlcommandfk =
STUFF((
	SELECT '; ' +  'ALTER TABLE [' + s.name + '].[' + o.name + '] WITH CHECK CHECK CONSTRAINT [' + i.name + ']' 
	from sys.foreign_keys i
	INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
	INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
	WHERE i.is_not_trusted = 1 AND i.is_not_for_replication = 0
FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)'),1,2,N'')

exec(@sqlcommandfk);