 /* 
 This script changes isolation level of the production database to READ_COMMITTED_SNAPSHOT. This will eliminate the few instances where there is unnecessary locking
 and deadlock in the system. The script needs to be run off hours since it will kill any ongoing transactions in the database. Also, this new snapshot isolation level 
 makes greater use of tempdb so make sure tempdb has enough disk space to grow up 10GB more before implenting. Finally, the script is guessing the name of the production database so
 please make sure it's guessing correctly or even better hard-code the database name so you know it is being set to the production database. If you have any questions please e-mail
 me.

 Suhail Ali
 Streamline Healthcare Solutions
 email: sali@streamlinehealthcare.com
 */
 DECLARE @dbname varchar(max);
 DECLARE @sqlcommand varchar(max);

 SELECT @dbname = name 
 FROM sys.databases 
 WHERE name like '%Prod%'; -- Modify to match name of production database

 SELECT @sqlcommand = 'ALTER DATABASE ' + QUOTENAME(@dbname) + ' SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE;'
 SELECT @sqlcommand
 EXEC(@sqlcommand)
 GO
 /*
Increased the cost threshold for parallelism since the default setting is defaulted to a low setting causing unnecessary parallelism for simple plans. This number has been derived based on looking the cost of 
common, simple queries and testing it in production with key customers. This can be run in production at any time and doesn't effect end users.
*/
sp_configure 'show advanced options', 1;
GO
reconfigure;
GO
sp_configure 'cost threshold for parallelism', 40;
GO
Reconfigure;