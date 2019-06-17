		EXEC dbo.ssp_RecodesCategoryCreateUpdate @CATEGORYCODE = 'CQMInterventionTreatmentPlans', -- varchar(100)
		    @CategoryName = 'CQMInterventionTreatmentPlans', -- varchar(100)
		    @Description = '', -- varchar(max)
		    @MappingEntity = 'DocumentCodes.DocumentCodeId', -- varchar(100)
		    @RecodeType = NULL, -- type_GlobalCode
		    @RangeType = NULL -- type_GlobalCode

