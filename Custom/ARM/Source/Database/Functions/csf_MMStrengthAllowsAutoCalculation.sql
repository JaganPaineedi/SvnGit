/****** Object:  UserDefinedFunction [dbo].[csf_MMStrengthAllowsAutoCalculation]    Script Date: 06/19/2013 18:03:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_MMStrengthAllowsAutoCalculation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[csf_MMStrengthAllowsAutoCalculation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_MMStrengthAllowsAutoCalculation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[csf_MMStrengthAllowsAutoCalculation]    
(
	@MedicationId int
) returns char(1)
as    
begin

	if exists (    
	   select *    
	   from MDMedications as m    
	   join MDClinicalFormulations as cf on cf.ClinicalFormulationId = m.ClinicalFormulationId    
	   join MDDosageFormCodes as dfc on dfc.DosageFormCodeId = cf.DosageFormCodeId    
	   where m.MedicationId = @MedicationId    
	   and dfc.DosageFormCode in (    
		''1A'', ''1E'', ''1F'', ''3Q'', ''4A'', ''4Q'', ''4R'', ''4S'', ''4T'', ''4U'', ''7O'', ''7P'', ''7Q'', ''CA'', ''CB'', ''CC'',    
		''CD'', ''CE'', ''CF'', ''CG'', ''CH'', ''CI'', ''CJ'', ''CK'', ''CL'', ''CM'', ''CN'', ''CO'', ''CP'', ''CQ'',    
		''CR'', ''CS'', ''CT'', ''CX'', ''EA'', ''EX'', ''TA'', ''TB'', ''TC'', ''TE'', ''TF'', ''TH'', ''TI'', ''TJ'',    
		''TL'', ''TM'', ''TN'', ''TO'', ''TP'', ''TQ'', ''TR'', ''TS'', ''TU'', ''TV'', ''TX'', ''TY'', ''TZ'', ''UA'',    
		''UB'', ''UC'', ''UD'', ''UE'', ''UF'', ''UG'', ''UH'', ''UI'', ''UJ'', ''UK'', ''UL'', ''UM'', ''UO'', ''UP'',    
		''UQ'', ''UR'', ''UT'', ''ZJ'', ''ZK'', ''ZN'', ''ZO''    
	   )    
	)
	begin
	   return ''Y''
	end
    
return ''N''


end
' 
END
GO
