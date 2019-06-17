DELETE FROM GlobalCodes 
WHERE  Category = 'LIVINGARRANGEMENT' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','On Street/Homeless Shelter','1','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Private Residence-Independent','2','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Private Residence-Dependent','3','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Jail/Correctional Facility','4','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT', 
            'Institutional Setting (NH, IMD, Psych, IP, VA, State Hospital)', 
            '5','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','24 Hour Residential Care','6','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Adult/Child Foster Home','7','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Unknown','8','Y','N',NULL) 