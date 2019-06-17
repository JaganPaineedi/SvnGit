
/*
===============================================================================================
Added by				 Date							Purpose
Lakshmi kanth J          08/12/2016                    what: Mapping table icd9icd10 data corrected 
													   Why: New Directions - Support Go Live #520
===============================================================================================
*/


Update DiagnosisICD10Codes Set DSMVCode = 'Y',BillableFlag = 'Y' WHere  ICD10CodeId >= 69603 and ICD10CodeId < 70350

update DiagnosisICD10Codes set IncludeInSearch=null Where ICD10CodeId >= 70350 AND ICD10CodeId <=71096