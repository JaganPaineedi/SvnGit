update   SystemActions SET Action='Re-Order' WHERE ActionId=10040
update   SystemActions SET Action='Change' WHERE ActionId=10028
UPDATE dbo.SystemActions SET RecordDeleted='Y' WHERE ActionId IN (10065)
