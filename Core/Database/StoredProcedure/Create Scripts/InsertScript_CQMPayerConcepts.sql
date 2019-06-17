IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '1' )
BEGIN
	insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('1','MEDICARE')
END
IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '2' )
BEGIN
	insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('2','MEDICAID')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3' )
BEGIN
	insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3','OTHER GOVERNMENT (Federal/State/Local) (excluding Department of Corrections)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '4' )
BEGIN
	insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('4','DEPARTMENTS OF CORRECTIONS')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '5' )
BEGIN
	insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('5','PRIVATE HEALTH INSURANCE')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '6' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('6','BLUE CROSS/BLUE SHIELD')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '7' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('7','MANAGED CARE, UNSPECIFIED (to be used only if one can''t distinguish public from private)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '8' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('8','NO PAYMENT from an Organization/Agency/Program/Private Payer Listed')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '9' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('9','MISCELLANEOUS/OTHER')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '11' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('11','Medicare (Managed Care)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '12' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('12','Medicare (Non-managed Care)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '13' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('13','Medicare Hospice')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '14' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('14','Dual Eligibility Medicare/Medicaid Organization')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '19' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('19','Medicare Other')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '21' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('21','Medicaid (Managed Care)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '22' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('22','Medicaid (Non-managed Care Plan)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '23' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('23','Medicaid/SCHIP')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '24' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('24','Medicaid Applicant')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '25' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('25','Medicaid - Out of State')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '26' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('26','Medicaid -- Long Term Care')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '29' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('29','Medicaid Other')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '31' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('31','Department of Defense')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '32' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('32','Department of Veterans Affairs')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '33' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('33','Indian Health Service or Tribe')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '34' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('34','HRSA Program')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '35' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('35','Black Lung')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '36' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('36','State Government')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '37' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('37','Local Government')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '38' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('38','Other Government (Federal, State, Local not specified)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '39' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('39','Other Federal')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '41' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('41','Corrections Federal')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '42' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('42','Corrections State')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '43' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('43','Corrections Local')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '44' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('44','Corrections Unknown Level')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '51' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('51','Managed Care (Private)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '52' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('52','Private Health Insurance - Indemnity')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '53' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('53','Managed Care (private) or private health insurance (indemnity), not otherwise specified')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '54' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('54','Organized Delivery System')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '55' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('55','Small Employer Purchasing Group')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '56' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('56','Specialized Stand Alone Plan')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '59' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('59','Other Private Insurance')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '61' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('61','BC Managed Care')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '62' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('62','BC Indemnity')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '63' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('63','BC (Indemnity or Managed Care) - Out of State')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '64' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('64','BC (Indemnity or Managed Care) - Unspecified')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '69' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('69','BC Indemnity')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '71' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('71','HMO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '72' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('72','PPO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '73' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('73','POS')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '79' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('79','Other Managed Care')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '81' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('81','Self-pay')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '82' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('82','No Charge')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '83' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('83','Refusal to Pay/Bad Debt')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '84' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('84','Hill Burton Free Care')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '85' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('85','Research/Donor')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '89' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('89','No Payment, Other')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '91' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('91','Foreign National')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '92' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('92','Long-term Care Insurance')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '93' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('93','Disability Insurance')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '94' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('94','Long-term Care Insurance')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '95' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('95','Worker''s Compensation')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '96' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('96','Auto Insurance (includes no fault)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '97' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('97','Legal Liability / Liability Insurance')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '98' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('98','Other specified but not otherwise classifiable (includes Hospice - Unspecified plan)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '99' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('99','No Typology Code available for payment source')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '111' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('111','Medicare HMO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '112' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('112','Medicare PPO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '113' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('113','Medicare POS')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '119' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('119','Medicare Managed Care Other')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '121' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('121','Medicare FFS')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '122' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('122','Medicare Drug Benefit')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '123' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('123','Medicare Medical Savings Account (MSA)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '129' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('129','Medicare Non-managed Care Other')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '191' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('191','Medicare Pharmacy Benefit Manager')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '211' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('211','Medicaid HMO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '212' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('212','Medicaid PPO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '213' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('213','Medicaid PCCM (Primary Care Case Management)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '219' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('219','Medicaid Managed Care Other')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '291' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('291','Medicaid Pharmacy Benefit Manager')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '311' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('311','TRICARE (CHAMPUS)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '312' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('312','Military Treatment Facility')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '313' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('313','Dental --Stand Alone')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '321' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('321','Veteran care--Care provided to Veterans')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '322' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('322','Non-veteran care')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '331' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('331','Indian Health Service -- Regular')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '332' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('332','Indian Health Service -- Contract')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '333' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('333','Indian Health Service - Managed Care')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '334' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('334','Indian Tribe - Sponsored Coverage')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '341' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('341','Title V (MCH Block Grant)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '342' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('342','Migrant Health Program')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '343' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('343','Ryan White Act')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '349' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('349','Other')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '361' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('361','State SCHIP program (codes for individual states)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '362' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('362','Specific state programs (list/ local code)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '369' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('369','State, not otherwise specified (other state)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '371' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('371','Local - Managed care')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '372' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('372','FFS/Indemnity')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '379' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('379','Local, not otherwise specified (other local, county)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '381' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('381','Federal, State, Local not specified managed care')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '382' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('382','Federal, State, Local not specified - FFS')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '389' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('389','Federal, State, Local not specified - Other')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '511' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('511','Commercial Managed Care - HMO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '512' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('512','Commercial Managed Care - PPO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '513' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('513','Commercial Managed Care - POS')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '514' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('514','Exclusive Provider Organization')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '515' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('515','Gatekeeper PPO (GPPO)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '516' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('516','Commercial Managed Care - Pharmacy Benefit Manager')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '519' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('519','Managed Care, Other (non HMO)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '521' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('521','Commercial Indemnity')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '522' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('522','Self-insured (ERISA) Administrative Services Only (ASO) plan')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '523' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('523','Medicare supplemental policy (as second payer)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '529' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('529','Private health insurance--other commercial Indemnity')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '561' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('561','Dental')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '562' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('562','Vision')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '611' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('611','BC Managed Care -- HMO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '612' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('612','BC Managed Care -- PPO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '613' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('613','BC Managed Care -- POS')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '619' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('619','BC Managed Care -- Other')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '821' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('821','Charity')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '822' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('822','Professional Courtesy')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '823' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('823','Research/Clinical Trial')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '951' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('951','Worker''s Comp HMO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '953' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('953','Worker''s Comp Fee-for-Service')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '954' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('954','Worker''s Comp Other Managed Care')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '959' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('959','Worker''s Comp, Other unspecified')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3111' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3111','TRICARE Prime--HMO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3112' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3112','TRICARE Extra--PPO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3113' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3113','TRICARE Standard - Fee For Service')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3114' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3114','TRICARE For Life--Medicare Supplement')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3115' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3115','TRICARE Reserve Select')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3116' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3116','Uniformed Services Family Health Plan (USFHP) -- HMO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3119' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3119','Department of Defense - (other)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3121' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3121','BC Managed Care -- HMO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3122' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3122','Non-enrolled Space Available')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3123' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3123','TRICARE For Life (TFL)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3211' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3211','Direct Care--Care provided in VA facilities')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3212' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3212','Indirect Care--Care provided outside VA facilities')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3221' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3221','Civilian Health and Medical Program for the VA (CHAMPVA)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3222' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3222','Spina Bifida Health Care Program (SB)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3223' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3223','Children of Women Vietnam Veterans (CWVV)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3229' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3229','Other non-veteran care')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3711' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3711','HMO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3712' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3712','PPO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3713' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3713','POS')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3811' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3811','Federal, State, Local not specified - HMO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3812' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3812','Federal, State, Local not specified - PPO')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3813' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3813','Federal, State, Local not specified - POS')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '3819' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('3819','Federal, State, Local not specified - not specified managed care')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '9999' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('9999','Unavailable / No Payer Specified / Blank')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '32121' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('32121','Fee Basis')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '32122' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('32122','Foreign Fee/Foreign Medical Program(FMP)')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '32123' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('32123','Contract Nursing Home/Community Nursing Home')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '32124' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('32124','State Veterans Home')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '32125' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('32125','Sharing Agreements')
END

IF NOT EXISTS(SELECT * FROM CQMPayerConcepts WHERE PayerCode = '32126' )
BEGIN
insert into CQMPayerConcepts (PayerCode,PayerDescription) values ('32126','Other Federal Agency')
END