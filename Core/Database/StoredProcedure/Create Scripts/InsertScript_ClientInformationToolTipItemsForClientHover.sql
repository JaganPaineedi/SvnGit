	
	--What: Client Hover: Enhancements being requested
	--Why: MHP-Customizations - Task 121
	
	--Insert Tooltip Items in the table ClientInformationToolTipItems
	-- delete from ClientInformationToolTipItems
	-- select * from ClientInformationToolTipItems
	
	-- insert the row with deleted status. Then based on the system configuration this deleted status will be updated.
	
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'ClientAddress') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('ClientAddress','If the Key is Active, then show Address information when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'ClientInformation') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('ClientInformation','If the Key is Active, then show Client information when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'PhoneNumber') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('PhoneNumber','If the Key is Active, then show Client PhoneNumber when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'DOB') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('DOB','If the Key is Active, then show Client DOB when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'Sex') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('Sex','If the Key is Active, then show Client Sex when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'SSN') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('SSN','If the Key is Active, then show Client SSN when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'ClientPlans') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('ClientPlans','If the Key is Active, then show ClientPlans when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'MedicaidID') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('MedicaidID','If the Key is Active, then show Client MedicaidID when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'PrimaryClinicianName') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('PrimaryClinicianName','If the Key is Active, then show Client PrimaryClinicianName when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'PrimaryProgram') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('PrimaryProgram','If the Key is Active, then show Client PrimaryProgram when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'ResidentialUnitBed') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('ResidentialUnitBed','If the Key is Active, then show Client ResidentialUnitBed when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'Medication') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('Medication','If the Key is Active, then show Client Medication when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'RecentCoveragePlan') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('RecentCoveragePlan','If the Key is Active, then show Client RecentCoveragePlan when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'ClientDateOfEnrollment') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('ClientDateOfEnrollment','If the Key is Active, then show ClientDateOfEnrollment when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'PrimaryPharmacy') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('PrimaryPharmacy','If the Key is Active, then show Client PrimaryPharmacy when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')


END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'Guardian') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('Guardian','If the Key is Active, then show Client Guardian when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'Allergies') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('Allergies','If the Key is Active, then show Client Allergies when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'OutstandingBalance') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('OutstandingBalance','If the Key is Active, then show Client OutstandingBalance when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'Alias') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('Alias','If the Key is Active, then show Client Alias when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'GenderIdentity') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('GenderIdentity','If the Key is Active, then show Client GenderIdentity when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'PrimaryLanguage') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('PrimaryLanguage','If the Key is Active, then show Client PrimaryLanguage when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'Provider') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('Provider','If the Key is Active, then show Provider when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
IF NOT EXISTS(SELECT * FROM   ClientInformationToolTipItems WHERE [Name] = 'DateOfInjury') 
  BEGIN 
	INSERT INTO ClientInformationToolTipItems (Name,ToolTipItemDescription,CreatedBy,CreatedDate,ModifiedBy	,ModifiedDate,RecordDeleted) 	
	values ('DateOfInjury','If the Key is Active, then show DateOfInjury when mouse over on Client picture in the Client Tab',suser_sname(),GETDATE(),suser_sname(),GETDATE(),'Y')
END 
    select * from ClientInformationToolTipItems