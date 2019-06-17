update ServiceDropDownConfigurations set
	ProgramIdFilteredBy = 'ClientId',
	ProgramIdStoredProcedure = 'csp_GetProgramForService',
	ClinicianIdFilteredBy = 'ProgramId;ProcedureCodeId',
	ClinicianIdStoredProcedure = 'csp_GetClinicianForService',
	ProcedureCodeIdFilteredBy = 'ProgramId',
	ProcedureCodeIdStoredProcedure = 'csp_GetProcedureCodesForService',
	LocationIdFilteredBy = 'ClinicianId;ProgramId',
	LocationIdStoredProcedure = 'csp_GetLocationForService'


