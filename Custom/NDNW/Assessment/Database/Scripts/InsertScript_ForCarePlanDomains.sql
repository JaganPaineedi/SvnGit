IF NOT Exists(Select * From CarePlanDomains Where DomainName In('DLA-20 Youth','DLA-20 Adult'))
Begin
Set IDENTITY_Insert CarePlanDomains ON
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(20,'DLA-20 Youth')
INSERT INTO [CarePlanDomains] ([CarePlanDomainId],[DomainName])VALUES(21,'DLA-20 Adult')
Set IDENTITY_Insert CarePlanDomains OFF

End
