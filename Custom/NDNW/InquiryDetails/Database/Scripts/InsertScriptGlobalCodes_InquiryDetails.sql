/********************************************************************************************
Author    :  Malathi Shiva  
ModifiedDate  :  18 Dec 2014  
Purpose    :  Insert/Update script to modify existing GlobalCodes.CodeName as per the clients requirement
*********************************************************************************************/
DELETE FROM GlobalCodes 
WHERE  Category = 'XURGENCYLEVEL' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XURGENCYLEVEL','Not urgent','1','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XURGENCYLEVEL','Urgent','2','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XURGENCYLEVEL','Emergent','3','Y','N',NULL) 

DELETE FROM GlobalCodes 
WHERE  Category = 'XINQUIRYTYPE' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYTYPE','Screen','1','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYTYPE','Crisis','2','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYTYPE','Information','3','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYTYPE','Jail Diversion','4','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYTYPE','Housing Evaluation','5','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYTYPE','Discharge Coordination','6','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYTYPE','Transition planning consultation','7','Y','N',NULL) 

DELETE FROM GlobalCodes 
WHERE  Category = 'XCONTACTTYPE' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XCONTACTTYPE','Call','1','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XCONTACTTYPE','Consult','2','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XCONTACTTYPE','Face to Face','3','Y','N',NULL) 

DELETE FROM GlobalCodes 
WHERE  Category = 'XSATYPE' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XSATYPE','Pregnant and injecting drug user','1','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XSATYPE','Parenting and injecting drug user','2','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XSATYPE','Pregnant substance user','3','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XSATYPE','Parenting substance user','4','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XSATYPE','Injecting drug user','5','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XSATYPE','HIV positive drug user','6','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XSATYPE','Special revenue contract clients (SLCO)','7','Y','N', 
            NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XSATYPE','Referral from VOA/Detox/Day Treatment/SLCO tx unit','8', 
            'Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XSATYPE','All other substance abusers','9','Y','N',NULL) 

IF NOT EXISTS(SELECT Category 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XINQUIRYHOUSEHOLD') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,Description,UserDefinedCategory,HasSubcodes, 
                   UsedInCareManagement) 
      VALUES     ('XINQUIRYHOUSEHOLD','XINQUIRYHOUSEHOLD','Y','N','N','Y',NULL, 
                  'N' 
                  ,'N','N') 
  END 

DELETE FROM GlobalCodes 
WHERE  Category = 'XINQUIRYHOUSEHOLD' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYHOUSEHOLD','Lives Alone','1','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYHOUSEHOLD','Lives with One or More Relatives','2','Y','N', 
            NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYHOUSEHOLD','Lives with non-related person(s)','3','Y','N', 
            NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYHOUSEHOLD','Lives with Single Parent','4','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYHOUSEHOLD','Lives with both parents','5','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYHOUSEHOLD','Unknown, declined to answer','6','Y','N',NULL) 

IF NOT EXISTS(SELECT Category 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XINQUIRYPSOURCE') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,Description,UserDefinedCategory,HasSubcodes, 
                   UsedInCareManagement) 
      VALUES     ('XINQUIRYPSOURCE','XINQUIRYPSOURCE','Y','N','N','Y',NULL,'N', 
                  'N' 
                  ,'N') 
  END 

DELETE FROM GlobalCodes 
WHERE  Category = 'XINQUIRYPSOURCE' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYPSOURCE','Legal Employment, Wages and Salary','1','Y','N', 
            NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYPSOURCE','Welfare, Public Assistance','2','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYPSOURCE','Pension, Retirement Benefits, Social Security', 
            NULL,'Y','N', 
            NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYPSOURCE','Disability, Worker''s Comp','3','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYPSOURCE','Other','4','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYPSOURCE','None','5','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQUIRYPSOURCE','Unknown','6','Y','N',NULL) 

--IF NOT EXISTS(SELECT Category 
--              FROM   GlobalCodeCategories 
--              WHERE  Category = 'XINQLIVING') 
--  BEGIN 
--      INSERT INTO GlobalCodeCategories 
--                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
--                   , 
--                   AllowSortOrderEdit 
--                   ,Description,UserDefinedCategory,HasSubcodes, 
--                   UsedInCareManagement) 
--      VALUES     ('XINQLIVING','XINQLIVING','Y','N','N','Y',NULL,'N','N','N') 
--  END 

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

IF NOT EXISTS(SELECT GlobalCodeId 
              FROM   GlobalCodes 
              WHERE  CodeName = 'Duplicate Insurance Plan' 
                     AND Category = 'CLIENTNOTETYPE') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Description,Active,CannotModifyNameOrDelete 
                   , 
                   SortOrder, 
                   ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2, 
                   Bitmap, 
                   Code) 
      VALUES     ('CLIENTNOTETYPE','Duplicate Insurance Plan','NULL','Y','N', 
                  NULL, 
                  NULL,NULL,NULL, 
                  NULL,NULL,NULL) 
  END 

GO 

DELETE FROM GlobalCodes 
WHERE  Category = 'MARITALSTATUS' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('MARITALSTATUS','Divorced','1','Y','N','5') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('MARITALSTATUS','Married','2','Y','N','2') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('MARITALSTATUS','Never Married','3','Y','N','3') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('MARITALSTATUS','Separated','4','Y','N','4') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('MARITALSTATUS','Unknown','6','Y','N','9') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('MARITALSTATUS','Widowed','7','Y','N','6') 

DELETE FROM GlobalCodes 
WHERE  Category = 'EMPLOYMENTSTATUS' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Employed Full Time (35 Hrs or More)','1','Y', 
            'N','1') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Employed Part Time (less than 35 Hrs)','2','Y', 
            'N','2') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Supported/Trans Employment','3','Y','N','13') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Homemaker','4','Y','N','11') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Student','5','Y','N','15') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Retired','6','Y','N','14') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Unemployed, seeking work','7','Y','N','7') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Unemployed, NOT seeking work/Volunteer','8','Y' 
            ,'N','12') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Disabled - Not in Labor Force','9','Y','N', 
            '3') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Ages 0-5','10','Y','N','10') 

DELETE FROM GlobalCodes 
WHERE  Category = 'LANGUAGE' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Achinese','1','Y','N','ace') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Acoli','2','Y','N','ach') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Adangme','3','Y','N','ada') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Afar','4','Y','N','aar') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Akan','5','Y','N','aka') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Albanian - alb','6','Y','N','alb') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Arabic','7','Y','N','ara') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Armenian - arm','8','Y','N','arm') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Armenian - hye','9','Y','N','hye') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Bosnian','10','Y','N','bos') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Chinese - Cantonese','11','Y','N','chi') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Efik','12','Y','N','efi') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','English','13','Y','N','eng') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','French','14','Y','N','fre') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','German - ger','15','Y','N','ger') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','German - deu','16','Y','N','deu') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Greek','17','Y','N','gre') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Hebrew','18','Y','N','heb') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Hindi','19','Y','N','hin') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Hmong','20','Y','N','hmn') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Italian','21','Y','N','ita') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Japanese','22','Y','N','jpn') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Korean','23','Y','N','kor') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Romanian','24','Y','N','rum') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Russian','25','Y','N','rus') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Sign languages','26','Y','N','sgn') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Spanish','27','Y','N','spa') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Tamil','28','Y','N','tam') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Thai','29','Y','N','tha') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Vietnamese','30','Y','N','vie') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','UTE Native American','31','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Zulu','32','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Other','33','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Cambodian','34','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Croatian','35','Y','N','sgn') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Farsi','36','Y','N','spa') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Karen','37','Y','N','tam') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Kirundian','38','Y','N','tha') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Kurdish','39','Y','N','vie') 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Laotian','40','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Navajo NativeAmerican','41','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Portuguese','42','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Samoan','43','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Serbian','44','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Somalian','45','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Sudanese','46','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Swahili','47','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Tibetan','48','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LANGUAGE','Tongan','49','Y','N',NULL) 

DELETE FROM GlobalCodes 
WHERE  Category = 'XINQCOUNTY' 
       AND GlobalCodeId > 10000 
       
       IF NOT EXISTS(SELECT Category 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XINQCOUNTY') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,Description,UserDefinedCategory,HasSubcodes, 
                   UsedInCareManagement) 
      VALUES     ('XINQCOUNTY','XINQCOUNTY','Y','N','N','Y',NULL,'N', 
                  'N' 
                  ,'N') 
  END 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQCOUNTY','Salt Lake','1','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQCOUNTY','Summit','2','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQCOUNTY','Tooele','3','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQCOUNTY','Other','4','Y','N',NULL) 

IF NOT EXISTS(SELECT Category 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XINQLEGAL') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,Description,UserDefinedCategory,HasSubcodes, 
                   UsedInCareManagement) 
      VALUES     ('XINQLEGAL','XINQLEGAL','Y','N','N','Y',NULL,'N','N','N') 
  END 

DELETE FROM GlobalCodes 
WHERE  Category = 'XINQLEGAL' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQLEGAL','Voluntary','1','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQLEGAL','Involuntary – Civil','2','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQLEGAL','Involuntary – Criminal','3','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQLEGAL','Unrecorded','4','Y','N',NULL) 

IF NOT EXISTS(SELECT Category 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XINQSDICT') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,Description,UserDefinedCategory,HasSubcodes, 
                   UsedInCareManagement) 
      VALUES     ('XINQSDICT','XINQSDICT','Y','N','N','Y',NULL,'N','N','N') 
  END 

DELETE FROM GlobalCodes 
WHERE  Category = 'XINQSDICT' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQSDICT','CANYON SCHOOL DISTRICT','1','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQSDICT','GRANITE SCHOOL DISTRICT','2','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQSDICT','JORDAN SCHOOL DISTRICT','3','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQSDICT','MURRAY SCHOOL DISTRICT','4','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQSDICT','NORTH SUMMIT SCHOOL DISTRICT','5','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQSDICT','PARK CITY SCHOOL DISTRICT','6','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQSDICT','SALT LAKE SCHOOL DISTRICT','7','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQSDICT','SO SUMMIT SCHOOL DISTRICT','8','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XINQSDICT','TOOELE SCHOOL DISTRICT','9','Y','N',NULL) 

IF NOT EXISTS(SELECT Category 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XINQEDUCATION') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,Description,UserDefinedCategory,HasSubcodes, 
                   UsedInCareManagement) 
      VALUES     ('XINQEDUCATION','XINQEDUCATION','Y','N','N','Y',NULL,'N','N', 
                  'N' 
      ) 
  END 

DELETE FROM GlobalCodes 
WHERE  Category = 'EDUCATIONALSTATUS' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','Preschool/Nursery/Head St','1','Y','N',NULL,1) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','Kindergarten','2','Y','N',NULL,2) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','1st Grade','3','Y','N',NULL,3) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','2nd Grade','4','Y','N',NULL,4) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','3rd Grade','5','Y','N',NULL,5) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','4th Grade','6','Y','N',NULL,6) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','5th Grade','7','Y','N',NULL,7) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','6th Grade','8','Y','N',NULL,8) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','7th Grade','9','Y','N',NULL,9) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','8th Grade','10','Y','N',NULL,10) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','9th Grade','11','Y','N',NULL,11) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','10th Grade','12','Y','N',NULL,12) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','11th Grade','13','Y','N',NULL,13) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','12th Grade','14','Y','N',NULL,14) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','High School Graduate','15','Y','N',NULL,15) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','Post High School Program','16','Y','N',NULL,16) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','College Graduate','17','Y','N',NULL,17) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','Some Graduate School','18','Y','N',NULL,18) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','Graduate School Graduate','19','Y','N',NULL,19) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','Never Attended School','20','Y','N',NULL,20) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','Special Education','21','Y','N',NULL,21) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1],SortOrder) 
VALUES     ('EDUCATIONALSTATUS','Vocational School','22','Y','N',NULL,22) 

DELETE FROM GlobalCodes 
WHERE  Category = 'REFERRALSOURCE' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Self','1','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Family/Friend','2','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Correctional/Legal','3','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Military','4','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Education','5','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Social or Community Service','6','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Medical','7','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Mental Health','8','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Residential','9','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','SUD','10','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Clergy','11','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Shelter','12','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Employer/Employee Assistance','13','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','Other','14','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALSOURCE','New Choices Waiver','15','Y','N',NULL) 

DELETE FROM GlobalSubCodes 
WHERE  GlobalCodeId IN (SELECT GlobalCodeId 
                        FROM   GlobalCodes 
                        WHERE  Category = 'REFERRALTYPE' 
                               AND GlobalCodeId > 10000) 
DELETE FROM GlobalCodes 
WHERE  Category = 'REFERRALTYPE' 
       AND GlobalCodeId > 10000 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Court','1','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Attorney','2','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Jail/Police','3','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','School District/School','4','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Social Service Agency','5','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Nursing Home Ext Care','6','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Emergency Room','7','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Other Physician','8','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Psychiatric Hospital','9','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Outpt Psych Clinic','10','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Private Psychiatrist','11','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Other Private Mh Practitioner','12','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Probation/Parole','13','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Other CMHC','14','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Community Residential','15','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Other Inpt Residential','16','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Substance Use Inpt Tx','17','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Substance Use Outpt Tx','18','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Assisted Living','19','Y','N',NULL) 

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('REFERRALTYPE','Nursing Facility','20','Y','N',NULL) 

GO
--DELETE FROM GlobalCodes where Category='XINQDISPOSITION' 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40090) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40090,'XINQDISPOSITION','Referred in – FlexCare','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL)  
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40091) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40091,'XINQDISPOSITION','Referred in – VBH','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL)  
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40092) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40092,'XINQDISPOSITION','Referred Out','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40093) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40093,'XINQDISPOSITION','Referral to Supported Housing','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40094) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40094,'XINQDISPOSITION','Continue Case Management and Psycosocial Services','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40095) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40095,'XINQDISPOSITION','Continue Assertive Outreach Services','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40096) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40096,'XINQDISPOSITION','Referral to Assertive Outreach Program','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40097) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40097,'XINQDISPOSITION','USH','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL)  
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40098) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40098,'XINQDISPOSITION','Incarcerated','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40099) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40099,'XINQDISPOSITION','Referred out to Community Based Services','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40112) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40112,'XINQDISPOSITION','Referred to Higher Level of Care','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40113) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40113,'XINQDISPOSITION','Deceased','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 
--IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=40114) 
--BEGIN 
--SET IDENTITY_INSERT GlobalCodes ON 
--INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
--VALUES(40114,'XINQDISPOSITION','Referred to SUD Waitlists (will need to identify those different wait lists','NULL','Y','N',NULL,NULL,NULL,NULL,NULL,NULL,NULL) 
--SET IDENTITY_INSERT GlobalCodes OFF 
--END 
--GO 