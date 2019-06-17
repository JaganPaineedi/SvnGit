--update script to set the NationalProviderId as NULL where there is no NPI degree exist.
--A Renewed Mind - Support  #784.1 
--NPI Number
update S set S.NationalProviderId =NULL from staff s where NationalProviderId is not null and isnull(recorddeleted,'N')<>'Y'
and not exists(Select 1 from StaffLicenseDegrees SD where PrimaryValue='Y' and s.staffid=SD.Staffid and LicenseTypeDegree ='9408' and IsNull(RecordDeleted,'N')<>'Y'  
AND (cast(ISNULL(EndDate,getdate()) as date)>= cast(getdate() as date) and  cast(isnull(StartDate,getdate())as date) <=cast(getdate() as date)))

--DEA Number
update S set S.DEANumber =NULL from staff s where DEANumber is not null and isnull(recorddeleted,'N')<>'Y'
and not exists(Select 1 from StaffLicenseDegrees SD where PrimaryValue='Y' and s.staffid=SD.Staffid and LicenseTypeDegree ='9403' and IsNull(RecordDeleted,'N')<>'Y'  
AND (cast(ISNULL(EndDate,getdate()) as date)>= cast(getdate() as date) and  cast(isnull(StartDate,getdate())as date) <=cast(getdate() as date)))


