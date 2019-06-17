/********************************************************************************************
Author    :  Malathi Shiva  
CreatedDate  :  08 Sept 2014  
Purpose    :  GlobalCodes insert/update for Categories : XEDUCATIONALSTATUS, XJUSTICESYSTEMINVOLV, XSMOKINGSTATUS, XFORENSICTREATMENT, XSSISSDISTATUS, XSCREENFORMISA, XADVANCEDIRECTIVE
*********************************************************************************************/
--Category = 'EDUCATIONALSTATUS'    
--IF EXISTS (SELECT 1 
--           FROM   GlobalCodes g 
--           WHERE  category = 'EDUCATIONALSTATUS' 
--                  AND CodeName LIKE '%~INACTIVE%') 
--  BEGIN 
--      UPDATE g 
--      SET    g.CodeName = Substring(CodeName, 0, Patindex('%~INACTIVE%', 
--                                                 CodeName) 
--                          ),Active = 
--             'Y' 
--      FROM   GlobalCodes g 
--      WHERE  category = 'EDUCATIONALSTATUS' 
--             AND CodeName LIKE '%~INACTIVE%' 
--  END 

-- Category = 'XEDUCATIONALSTATUS'  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XEDUCATIONALSTATUS') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XEDUCATIONALSTATUS','XEDUCATIONALSTATUS','Y','Y','Y','Y','Y' 
                   , 
                   'N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XEDUCATIONALSTATUS' 
                     AND CodeName = 'Currently: Regular Education') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XEDUCATIONALSTATUS','Currently: Regular Education','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XEDUCATIONALSTATUS' 
                     AND CodeName = 'Currently: Special Education') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XEDUCATIONALSTATUS','Currently: Special Education','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XEDUCATIONALSTATUS' 
                     AND CodeName = 'Alt Education (HS Degree)') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XEDUCATIONALSTATUS','Alt Education (HS Degree)','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XEDUCATIONALSTATUS' 
                     AND CodeName = 'Conditioning Education') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XEDUCATIONALSTATUS','Conditioning Education','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XEDUCATIONALSTATUS' 
                     AND CodeName = 'Vocational Training') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XEDUCATIONALSTATUS','Vocational Training','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XEDUCATIONALSTATUS' 
                     AND CodeName = 'Not Currently Enrolled') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XEDUCATIONALSTATUS','Not Currently Enrolled','Y','N') 
  END 

-- Category = 'XJUSTICESYSTEMINVOLV'  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XJUSTICESYSTEMINVOLV') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XJUSTICESYSTEMINVOLV','XJUSTICESYSTEMINVOLV','Y','Y','Y','Y' 
                   , 
                   'Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XJUSTICESYSTEMINVOLV' 
                     AND CodeName = 'Not applicable') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XJUSTICESYSTEMINVOLV','Not applicable','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XJUSTICESYSTEMINVOLV' 
                     AND CodeName = 'Arrested') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XJUSTICESYSTEMINVOLV','Arrested','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XJUSTICESYSTEMINVOLV' 
                     AND CodeName = 'Charged with a crime') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XJUSTICESYSTEMINVOLV','Charged with a crime','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XJUSTICESYSTEMINVOLV' 
                     AND CodeName = 'Incarcerated – Jail') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XJUSTICESYSTEMINVOLV','Incarcerated – Jail','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XJUSTICESYSTEMINVOLV' 
                     AND CodeName = 'Incarcerated – Prison') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XJUSTICESYSTEMINVOLV','Incarcerated – Prison','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XJUSTICESYSTEMINVOLV' 
                     AND CodeName = 'Juvenile Detention center') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XJUSTICESYSTEMINVOLV','Juvenile Detention center','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XJUSTICESYSTEMINVOLV' 
                     AND CodeName = 'Detained – Jail') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XJUSTICESYSTEMINVOLV','Detained – Jail','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XJUSTICESYSTEMINVOLV' 
                     AND CodeName = 'Mental Health Court') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XJUSTICESYSTEMINVOLV','Mental Health Court','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XJUSTICESYSTEMINVOLV' 
                     AND CodeName = 'Other') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XJUSTICESYSTEMINVOLV','Other','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XJUSTICESYSTEMINVOLV' 
                     AND CodeName = 'Unknown, decline to answer') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XJUSTICESYSTEMINVOLV','Unknown, decline to answer','Y','N') 
  END 

-- Category = 'XSMOKINGSTATUS' 
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XSMOKINGSTATUS') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XSMOKINGSTATUS','XSMOKINGSTATUS','Y','Y','Y','Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSMOKINGSTATUS' 
                     AND CodeName = 'Never smoked ') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSMOKINGSTATUS','Never smoked ','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSMOKINGSTATUS' 
                     AND CodeName = 'Former smoker') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSMOKINGSTATUS','Former smoker','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSMOKINGSTATUS' 
                     AND CodeName = 'Current someday smoker') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSMOKINGSTATUS','Current someday smoker','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSMOKINGSTATUS' 
                     AND CodeName = 'Current everyday smoker') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSMOKINGSTATUS','Current everyday smoker','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSMOKINGSTATUS' 
                     AND CodeName = 'Use smokeless tobacco only in last 30 days' 
             ) 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSMOKINGSTATUS','Use smokeless tobacco only in last 30 days' 
                   , 
                   'Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSMOKINGSTATUS' 
                     AND CodeName = 'Current status unknown') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSMOKINGSTATUS','Current status unknown','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSMOKINGSTATUS' 
                     AND CodeName = 'Not applicable') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSMOKINGSTATUS','Not applicable','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSMOKINGSTATUS' 
                     AND CodeName = 'Former smoking status unknown') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSMOKINGSTATUS','Former smoking status unknown','Y','N') 
  END 

-- Category = 'XEDUCATIONALSTATUS' 
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XFORENSICTREATMENT') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XFORENSICTREATMENT','XFORENSICTREATMENT','Y','Y','Y','Y','Y' 
                   , 
                   'N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XFORENSICTREATMENT' 
                     AND CodeName = 'Not applicable') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XFORENSICTREATMENT','Not applicable','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XFORENSICTREATMENT' 
                     AND CodeName = 'Department of corrections client') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XFORENSICTREATMENT','Department of corrections client','Y', 
                   'N' 
      ) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XFORENSICTREATMENT' 
                     AND CodeName = 'Unable to stand trial') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XFORENSICTREATMENT','Unable to stand trial','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XFORENSICTREATMENT' 
                     AND CodeName = 'Unable to stand trial – extended Term') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XFORENSICTREATMENT', 
                   'Unable to stand trial – extended Term', 
                   'Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XFORENSICTREATMENT' 
                     AND CodeName = 'Unable to stand trial – G2') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XFORENSICTREATMENT','Unable to stand trial – G2','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XFORENSICTREATMENT' 
                     AND CodeName = 'Not guilty by reason of insanity') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XFORENSICTREATMENT','Not guilty by reason of insanity','Y', 
                   'N' 
      ) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XFORENSICTREATMENT' 
                     AND CodeName = 'Civil Court ordered – treatment') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XFORENSICTREATMENT','Civil Court ordered – treatment','Y', 
                   'N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XFORENSICTREATMENT' 
                     AND CodeName = 'Criminal court – ordered treatment') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XFORENSICTREATMENT','Criminal court – ordered treatment', 
                   'Y' 
                   ,'N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XFORENSICTREATMENT' 
                     AND CodeName = 'Court- ordered evaluation/assessment only') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XFORENSICTREATMENT', 
                   'Court- ordered evaluation/assessment only','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XFORENSICTREATMENT' 
                     AND CodeName = 'Unknown, declined to answer') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XFORENSICTREATMENT','Unknown, declined to answer','Y','N') 
  END 

-- Category = 'XADVANCEDIRECTIVE' 
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XADVANCEDIRECTIVE') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XADVANCEDIRECTIVE','XADVANCEDIRECTIVE','Y','Y','Y','Y','Y', 
                   'N' 
      ) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XADVANCEDIRECTIVE' 
                     AND CodeName = 'Yes') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XADVANCEDIRECTIVE','Yes','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XADVANCEDIRECTIVE' 
                     AND CodeName = 'No') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XADVANCEDIRECTIVE','No','Y','N') 
  END 

-- Category = 'XSCREENFORMISA' 
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XSCREENFORMISA') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XSCREENFORMISA','XSCREENFORMISA','Y','Y','Y','Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSCREENFORMISA' 
                     AND CodeName = 'Yes') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSCREENFORMISA','Yes','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSCREENFORMISA' 
                     AND CodeName = 'No') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSCREENFORMISA','No','Y','N') 
  END 

-- Category = 'XSSISSDISTATUS' 
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XSSISSDISTATUS') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XSSISSDISTATUS','XSSISSDISTATUS','Y','Y','Y','Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDISTATUS' 
                     AND CodeName = 'Not applicable') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDISTATUS','Not applicable','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDISTATUS' 
                     AND CodeName = 'Eligible, receiving payments') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDISTATUS','Eligible, receiving payments','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDISTATUS' 
                     AND CodeName = 'Eligible, not receiving payments') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDISTATUS','Eligible, not receiving payments','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDISTATUS' 
                     AND CodeName = 'Eligibility determination pending') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDISTATUS','Eligibility determination pending','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDISTATUS' 
                     AND CodeName = 'Potentially eligible, has not applied') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDISTATUS','Potentially eligible, has not applied','Y', 
                   'N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDISTATUS' 
                     AND CodeName = 'Determined to be ineligible') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDISTATUS','Determined to be ineligible','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDISTATUS' 
                     AND CodeName = 'Eligibility status unknown') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDISTATUS','Eligibility status unknown','Y','N') 
  END 
DELETE FROM GlobalCodes 
WHERE  Category = 'XRELIGION' 
  IF NOT EXISTS(SELECT Category 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XRELIGION') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,Description,UserDefinedCategory,HasSubcodes, 
                   UsedInCareManagement) 
      VALUES     ('XRELIGION','XRELIGION','Y','N','N','Y',NULL, 
                  'N' 
                  ,'N','N') 
  END 
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Amish','1','Y','N',NULL) 
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Assembly of God','2','Y','N',NULL) 
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Baptist','3','Y','N',NULL) 
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Bible Fellowship','4','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Brethren In Christ','5','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Catholic','6','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Church of the brethren','7','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Church of Christ','8','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Church of God','9','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Evangelical Cong Church','10','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Episcopalian','11','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Evangelical','12','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Grace brethren','13','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Independent','14','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Jewish','15','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Lutheran','16','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','LDS','17','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('XRELIGION','Mennonite','18','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
             
VALUES     ('XRELIGION','None','19','Y','N',NULL)
DELETE FROM GlobalCodes 
WHERE  Category = 'LIVINGARRANGEMENT' and GlobalCodeId >10000

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Transient/homeless','1','Y','N',NULL) 
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Residential facility','2','Y','N',NULL) 
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Jail','3','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Foster home','4','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Prison','5','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Room and board','6','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Supported housing (scattered site)','7','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Supported housing (congregated site)','7','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Alcohol and drug free housing','7','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Oxford home','7','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('LIVINGARRANGEMENT','Other private residence','7','Y','N',NULL)



DELETE FROM GlobalCodes 
WHERE  Category = 'EMPLOYMENTSTATUS' and GlobalCodeId >10000

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Full time (35 hours or more)','1','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Part time (17-34 hours)','2','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Not in labor force','3','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Disabled','4','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Homemaker','5','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Hospital patient/Resident of other Institution','6','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Retired','7','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Sheltered/non-competitive employment','8','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Student','9','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Unknown','10','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('EMPLOYMENTSTATUS','Other reported classification','11','Y','N',NULL)

DELETE FROM GlobalCodes 
WHERE  Category = 'MILITARYSTATUS' and GlobalCodeId >10000
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'MILITARYSTATUS') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('MILITARYSTATUS','MILITARYSTATUS','Y','Y','Y','Y','Y','N') 
  END 
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('MILITARYSTATUS','Yes','1','Y','N',NULL)
INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('MILITARYSTATUS','No','2','Y','N',NULL)

INSERT INTO [GlobalCodes] 
            ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete], 
             [ExternalCode1]) 
VALUES     ('MILITARYSTATUS','Unknown','2','Y','N',NULL)


-- Category = 'CITIZENSHIP' 

DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'CITIZENSHIP' 
                  AND Active = 'Y' and GlobalCodeId > 10000
                  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'CITIZENSHIP') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('CITIZENSHIP','CITIZENSHIP','Y','Y','Y','Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'CITIZENSHIP' 
                     AND CodeName = 'US Citizen') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('CITIZENSHIP','US Citizen','Y','N') 
  END 
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'CITIZENSHIP' 
                     AND CodeName = 'Immigrant – Documented') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('CITIZENSHIP','Immigrant – Documented','Y','N') 
  END 
  
   IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'CITIZENSHIP' 
                     AND CodeName = 'Immigrant – Non-Documented') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('CITIZENSHIP','Immigrant – Non-Documented','Y','N') 
  END 

--Category = 'EDUCATIONALSTATUS'
DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'EDUCATIONALSTATUS' 
                  AND Active = 'Y' and GlobalCodeId > 10000
                  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'EDUCATIONALSTATUS') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('EDUCATIONALSTATUS','EDUCATIONALSTATUS','Y','Y','Y','Y','Y','N') 
  END  
   IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '0') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','0','Y','N') 
  END 
   IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '1') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','1','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '2') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','2','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '3') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','3','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '4') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','4','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '5') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','5','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '6') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','6','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '7') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','7','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '8') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','8','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '9') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','9','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '10') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','10','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '11') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','11','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '12/GED') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','12/GED','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '13') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','13','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '14') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','14','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '15') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','15','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '16') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','16','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '17') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','17','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '18') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','18','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '19') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','19','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '20') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','20','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '21') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','21','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '22') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','22','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '23') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','23','Y','N') 
  END    

 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '24') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','24','Y','N') 
  END
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'EDUCATIONALSTATUS' 
                     AND CodeName = '25') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('EDUCATIONALSTATUS','25','Y','N') 
  END
  
  --Category = 'XCLIENTTYPE'
DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'XCLIENTTYPE' 
                  AND Active = 'Y' and GlobalCodeId > 10000
                  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XCLIENTTYPE') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XCLIENTTYPE','XCLIENTTYPE','Y','Y','Y','Y','Y','N') 
  END  
   IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCLIENTTYPE' 
                     AND CodeName = 'Inpatient Mental Health') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XCLIENTTYPE','Inpatient Mental Health','Y','N') 
  END   
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCLIENTTYPE' 
                     AND CodeName = 'Medication Management') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XCLIENTTYPE','Medication Management','Y','N') 
  END  
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCLIENTTYPE' 
                     AND CodeName = 'Outpatient Mental Health') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XCLIENTTYPE','Outpatient Mental Health','Y','N') 
  END    
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCLIENTTYPE' 
                     AND CodeName = 'Supported Living') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XCLIENTTYPE','Supported Living','Y','N') 
  END   
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCLIENTTYPE' 
                     AND CodeName = 'Other') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XCLIENTTYPE','Other','Y','N') 
  END  
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XCLIENTTYPE' 
                     AND CodeName = 'None') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XCLIENTTYPE','None','Y','N') 
  END   
  
   --Category = 'XSSISSDSTATUS'
DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'XSSISSDSTATUS' 
                  AND Active = 'Y' and GlobalCodeId > 10000
                  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XSSISSDSTATUS') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XSSISSDSTATUS','XSSISSDSTATUS','Y','Y','Y','Y','Y','N') 
  END  
   IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDSTATUS' 
                     AND CodeName = 'Not applicable') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDSTATUS','Not applicable','Y','N') 
  END   
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDSTATUS' 
                     AND CodeName = 'Eligible, receiving payments') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDSTATUS','Eligible, receiving payments','Y','N') 
  END  
 IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDSTATUS' 
                     AND CodeName = 'Eligible, not receiving payments') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDSTATUS','Eligible, not receiving payments','Y','N') 
  END  
   IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDSTATUS' 
                     AND CodeName = 'Eligibility determination pending') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDSTATUS','Eligibility determination pending','Y','N') 
  END  
   IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDSTATUS' 
                     AND CodeName = 'Potentially eligible, has not applied') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDSTATUS','Potentially eligible, has not applied','Y','N') 
  END  
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDSTATUS' 
                     AND CodeName = 'Determined to be ineligible') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDSTATUS','Determined to be ineligible','Y','N') 
  END  
   IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSSISSDSTATUS' 
                     AND CodeName = 'Eligibility status unknown') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSSISSDSTATUS','Eligibility status unknown','Y','N') 
  END  
  
   --Category = 'XSCHOOLATTENDENCE'
DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'XSCHOOLATTENDENCE' 
                  AND Active = 'Y' and GlobalCodeId > 10000
                  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XSCHOOLATTENDENCE') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XSCHOOLATTENDENCE','XSCHOOLATTENDENCE','Y','Y','Y','Y','Y','N') 
  END  
   IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSCHOOLATTENDENCE' 
                     AND CodeName = 'Attending school regularly: 5 days or less absent') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSCHOOLATTENDENCE','Attending school regularly: 5 days or less absent','Y','N') 
  END   
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSCHOOLATTENDENCE' 
                     AND CodeName = 'Home schooled') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSCHOOLATTENDENCE','Home schooled','Y','N') 
  END   
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSCHOOLATTENDENCE' 
                     AND CodeName = 'Not applicable') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSCHOOLATTENDENCE','Not applicable','Y','N') 
  END   
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSCHOOLATTENDENCE' 
                     AND CodeName = 'Not attending school regularly: 6 days or more absent') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSCHOOLATTENDENCE','Not attending school regularly: 6 days or more absent','Y','N') 
  END
  IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XSCHOOLATTENDENCE' 
                     AND CodeName = 'Not available') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XSCHOOLATTENDENCE','Not available','Y','N') 
  END   
  
    --Category = 'XMILITARYSERVICE'
DELETE
           FROM   GlobalCodes 
           WHERE  Category = 'XMILITARYSERVICE' 
                  AND Active = 'Y' and GlobalCodeId > 10000
                  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XMILITARYSERVICE') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XMILITARYSERVICE','XMILITARYSERVICE','Y','Y','Y','Y','Y','N') 
  END  
   IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XMILITARYSERVICE' 
                     AND CodeName = 'Yes') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XMILITARYSERVICE','Yes','Y','N') 
  END   
   IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XMILITARYSERVICE' 
                     AND CodeName = 'No') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES      ('XMILITARYSERVICE','No','Y','N') 
  END   
   
   


