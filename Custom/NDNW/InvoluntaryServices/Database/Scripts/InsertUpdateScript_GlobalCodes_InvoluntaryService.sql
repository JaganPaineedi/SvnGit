/********************************************************************************************
Author    :  Malathi Shiva   
CreatedDate  :  04 May 2015 
Purpose    :  GlobalCodes insert/update script - Involuntary Service : Task# 36 - New Directions - Customizations
*********************************************************************************************/
DELETE FROM GlobalCodes 
WHERE  Category = 'XInServiceStatus' 
       AND GlobalCodeId > 10000 

--Category = 'XInServiceStatus'     
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XInServiceStatus') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XInServiceStatus','XInServiceStatus','Y', 
                   'Y' 
                   ,'Y','Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInServiceStatus' 
                     AND CodeName = 'Pre Commitment Investigation') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInServiceStatus','Pre Commitment Investigation', 
                   'Y', 
                   'N',1) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInServiceStatus' 
                     AND CodeName = 'Revocation') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInServiceStatus','Revocation','Y','N',2) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInServiceStatus' 
                     AND CodeName = 'Recertification') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInServiceStatus','Recertification','Y','N',3) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInServiceStatus' 
                     AND CodeName = 'Ongoing') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInServiceStatus','Ongoing','Y','N',4) 
  END 

DELETE FROM GlobalCodes 
WHERE  Category = 'XIntypeofpetition' 
       AND GlobalCodeId > 10000 

--Category = 'XIntypeofpetition'     
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XIntypeofpetition') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XIntypeofpetition','XIntypeofpetition','Y','Y' 
                   , 
                   'Y','Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XIntypeofpetition' 
                     AND 
             CodeName = 
             'Two Person, or County Health Officer, or Court Magistrate' 
                ) 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XIntypeofpetition', 
                   'Two Person, or County Health Officer, or Court Magistrate', 
                   'Y' 
                   ,'N' 
                   ,1) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XIntypeofpetition' 
                     AND CodeName = 'CMHP Director') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XIntypeofpetition','CMHP Director','Y','N',2) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XIntypeofpetition' 
                     AND CodeName = 'Physician/Hospital Hold') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XIntypeofpetition','Physician/Hospital Hold','Y','N', 
                   3) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XIntypeofpetition' 
                     AND CodeName = 'Recertification') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XIntypeofpetition','Recertification','Y','N',4) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XIntypeofpetition' 
                     AND CodeName = 'Revocation') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XIntypeofpetition','Revocation','Y','N',5) 
  END 

DELETE FROM GlobalCodes 
WHERE  Category = 'XInHearingRecommend' 
       AND GlobalCodeId > 10000 

--Category = 'XInHearingRecommend'     
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XInHearingRecommend') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XInHearingRecommend', 
                   'XInHearingRecommend','Y','Y','Y', 
                   'Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInHearingRecommend' 
                     AND 
          CodeName = 'No: Petition/Notice of Mental Illness Withdrawn') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder,Code) 
      VALUES      ('XInHearingRecommend', 
                   'No: Petition/Notice of Mental Illness Withdrawn','Y','N',1,1) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInHearingRecommend' 
                     AND CodeName = 'No: Client agrees to Voluntary Treatment') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder,Code) 
      VALUES      ('XInHearingRecommend', 
                   'No: Client agrees to Voluntary Treatment','Y', 
                   'N',2,2) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInHearingRecommend' 
                     AND CodeName = 'No: Lack of Probable Cause') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder,Code) 
      VALUES      ('XInHearingRecommend','No: Lack of Probable Cause' 
                   , 
                   'Y','N',3,3) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInHearingRecommend' 
                     AND CodeName = 'No: But Judge Orders hearing') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder,Code) 
      VALUES      ('XInHearingRecommend', 
                   'No: But Judge Orders hearing' 
                   ,'Y','N',4,4) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInHearingRecommend' 
                     AND CodeName = 'Yes: Probable Cause') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder,Code) 
      VALUES      ('XInHearingRecommend','Yes: Probable Cause','Y', 
                   'N', 
                   5,5) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInHearingRecommend' 
                     AND CodeName = 'No: 14 day Diversion') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder,Code) 
      VALUES      ('XInHearingRecommend','No: 14 day Diversion','Y', 
                   'N' 
                   ,6,6) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInHearingRecommend' 
                     AND CodeName = 'Yes: Protested Recertification') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder,Code) 
      VALUES      ('XInHearingRecommend', 
                   'Yes: Protested Recertification','Y','N',7,7) 
  END 

DELETE FROM GlobalCodes 
WHERE  Category = 'XInReasonforhearing' 
       AND GlobalCodeId > 10000 

--Category = 'XInReasonforhearing'     
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XInReasonforhearing') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XInReasonforhearing','XInReasonforhearing' 
                   , 
                   'Y','Y','Y','Y', 
                   'Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInReasonforhearing' 
                     AND CodeName = 'Danger to self') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInReasonforhearing','Danger to self','Y','N',1) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInReasonforhearing' 
                     AND CodeName = 'Danger to others') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInReasonforhearing','Danger to others','Y','N',2) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInReasonforhearing' 
                     AND CodeName = 'Basic personal needs') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInReasonforhearing','Basic personal needs','Y','N' 
                   ,3 
      ) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInReasonforhearing' 
                     AND 
          CodeName = 'Chronically mentally Ill (meets expanded criteria)' 
                    ) 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInReasonforhearing', 
                   'Chronically mentally Ill (meets expanded criteria)','Y','N',4 
      ) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInReasonforhearing' 
                     AND 
             CodeName = 
             'Not Applicable (hearing not recommended: No Probable Cause)') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInReasonforhearing', 
                   'Not Applicable (hearing not recommended: No Probable Cause)', 
                   'Y', 
                   'N',5) 
  END 

DELETE FROM GlobalCodes 
WHERE  Category = 'XInBasisforServices' 
       AND GlobalCodeId > 10000 

--Category = 'XInBasisforServices'     
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XInBasisforServices') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XInBasisforServices','XInBasisforServices' 
                   , 
                   'Y','Y','Y','Y', 
                   'Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInBasisforServices' 
                     AND CodeName = 'Danger to self') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInBasisforServices','Danger to self','Y','N',1) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInBasisforServices' 
                     AND CodeName = 'Danger to others') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInBasisforServices','Danger to others','Y','N',2) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInBasisforServices' 
                     AND CodeName = 'Basic personal needs') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInBasisforServices','Basic personal needs','Y','N' 
                   ,3 
      ) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInBasisforServices' 
                     AND 
          CodeName = 'Chronically mentally Ill (meets expanded criteria)' 
                    ) 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInBasisforServices', 
                   'Chronically mentally Ill (meets expanded criteria)','Y','N',4 
      ) 
  END 

DELETE FROM GlobalCodes 
WHERE  Category = 'XInDisposition' 
       AND GlobalCodeId > 10000 

--Category = 'XInDisposition'     
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XInDisposition') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XInDisposition','XInDisposition','Y','Y', 
                   'Y' 
                   ,'Y','Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInDisposition' 
                     AND CodeName = 'Found not mentally ill') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInDisposition','Found not mentally ill','Y','N',1) 
  END 
  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInDisposition' 
                     AND CodeName = 'Dismissed') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInDisposition','Dismissed','Y','N',2) 
  END 
  
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInDisposition' 
                     AND CodeName = 'Conditionally released') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInDisposition','Conditionally released','Y','N',3) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInDisposition' 
                     AND CodeName = 'Outpatient commitment') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInDisposition','Outpatient commitment','Y','N',4) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInDisposition' 
                     AND CodeName = 'Inpatient commitment') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInDisposition','Inpatient commitment','Y','N',5) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInDisposition' 
                     AND CodeName = 'Revocation') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInDisposition','Revocation','Y','N',6) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInDisposition' 
                     AND CodeName = 'Recertification') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInDisposition','Recertification','Y','N',7) 
  END 

DELETE FROM GlobalCodes 
WHERE  Category = 'XInCommitted' 
       AND GlobalCodeId > 10000 

--Category = 'XInCommitted'     
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XInCommitted') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XInCommitted','XInCommitted','Y','Y','Y', 
                   'Y' 
                   ,'Y','N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInCommitted' 
                     AND CodeName = 'Yes') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder,Code) 
      VALUES      ('XInCommitted','Yes','Y','N',1,'Y') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInCommitted' 
                     AND CodeName = 'No') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder,Code) 
      VALUES      ('XInCommitted','No','Y','N',2,'N') 
  END 

DELETE FROM GlobalCodes 
WHERE  Category = 'XInServiceSetting' 
       AND GlobalCodeId > 10000 

--Category = 'XInServiceSetting'     
IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodeCategories 
              WHERE  Category = 'XInServiceSetting') 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit 
                   , 
                   AllowSortOrderEdit 
                   ,UserDefinedCategory,HasSubcodes) 
      VALUES      ('XInServiceSetting','XInServiceSetting','Y' 
                   , 
                   'Y','Y','Y','Y', 
                   'N') 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInServiceSetting' 
                     AND CodeName = 'Community Mental Health Program') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInServiceSetting', 
                   'Community Mental Health Program', 
                   'Y','N',1) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInServiceSetting' 
                     AND CodeName = 'Community Hospital') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInServiceSetting','Community Hospital','Y','N',2) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInServiceSetting' 
                     AND CodeName = 'State Hospital') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInServiceSetting','State Hospital','Y','N',3) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInServiceSetting' 
                     AND CodeName = 'VA Hospital') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInServiceSetting','VA Hospital','Y','N',4) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInServiceSetting' 
                     AND CodeName = 'State – Approved Facility') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInServiceSetting','State – Approved Facility', 
                   'Y', 
                   'N',5) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInServiceSetting' 
                     AND CodeName = 'Outpatient') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInServiceSetting','Outpatient','Y','N',6) 
  END 

IF NOT EXISTS(SELECT 1 
              FROM   GlobalCodes 
              WHERE  Category = 'XInServiceSetting' 
                     AND CodeName = 'Other') 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete,SortOrder) 
      VALUES      ('XInServiceSetting','Other','Y','N',7) 
  END 