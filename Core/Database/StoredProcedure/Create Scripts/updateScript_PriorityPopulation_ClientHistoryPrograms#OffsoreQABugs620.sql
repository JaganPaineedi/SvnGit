If EXISTS(select prioritypopulation   from ClientProgramHistory where prioritypopulation='' )
BEGIN
Update ClientProgramHistory set prioritypopulation=NULL where prioritypopulation='' 
END