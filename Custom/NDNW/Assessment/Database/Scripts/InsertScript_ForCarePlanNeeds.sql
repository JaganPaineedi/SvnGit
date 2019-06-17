
IF NOT Exists(Select * From CarePlanDomainNeeds Where NeedName In('Health Practices Youth','Housing Stability Maintenance Youth',
'Communication Youth','Safety Youth','Managing Time Youth','Managing Money Youth','Nutrition Youth','Problem Solving Youth',
'Family Relationships Youth','Family Relationships Youth','Alcohol/Drug Use Youth','Leisure Youth','Community Resources Youth',
'Community Resources Youth','Social Network Youth','Sexuality Youth','Productivity Youth','Coping Skills Youth','Behavior Norms Youth',
'Personal Hygiene Youth','Grooming Youth','Dress Youth'))
Begin

INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(581,20,'Health Practices Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(582,20,'Housing Stability Maintenance Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(583,20,'Communication Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(584,20,'Safety Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(585,20,'Managing Time Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(586,20,'Managing Money Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(587,20,'Nutrition Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(588,20,'Problem Solving Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(589,20,'Family Relationships Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(590,20,'Alcohol/Drug Use Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(591,20,'Leisure Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(592,20,'Community Resources Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(593,20,'Social Network Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(594,20,'Sexuality Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(595,20,'Productivity Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(596,20,'Coping Skills Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(597,20,'Behavior Norms Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(598,20,'Personal Hygiene Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(599,20,'Grooming Youth')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(600,20,'Dress Youth')
End

Go

IF NOT Exists(Select * From CarePlanDomainNeeds Where NeedName In('Health Practices Adult','Housing Stability Maintenance Adult',
'Communication Adult','Safety Adult','Managing Time Adult','Managing Money Adult','Nutrition Adult','Problem Solving Adult',
'Family Relationships Adult','Family Relationships Adult','Alcohol/Drug Use Adult','Leisure Adult','Community Resources Adult',
'Community Resources Adult','Social Network Adult','Sexuality Adult','Productivity Adult','Coping Skills Adult','Behavior Norms Adult',
'Personal Hygiene Adult','Grooming Adult','Dress Adult'))
Begin
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(561,21,'Health Practices Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(562,21,'Housing Stability Maintenance Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(563,21,'Communication Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(564,21,'Safety Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(565,21,'Managing Time Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(566,21,'Managing Money Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(567,21,'Nutrition Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(568,21,'Problem Solving Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(569,21,'Family Relationships Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(570,21,'Alcohol/Drug Use Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(571,21,'Leisure Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(572,21,'Community Resources Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(573,21,'Social Network Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(574,21,'Sexuality Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(575,21,'Productivity Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(576,21,'Coping Skills Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(577,21,'Behavior Norms Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(578,21,'Personal Hygiene Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(579,21,'Grooming Adult')
INSERT INTO [CarePlanDomainNeeds] ([CarePlanDomainNeedId],[CarePlanDomainId],[NeedName])VALUES(580,21,'Dress Adult')
End