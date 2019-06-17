--- Insert script for GlobalCode category  DENIALREASON and code name 'Member copay'

if not exists ( select  *
                from    GlobalCodeCategories
                where   Category = 'DENIALREASON' )
  begin 
    insert  into GlobalCodeCategories
            (Category,
             CategoryName,
             Active,
             AllowAddDelete,
             AllowCodeNameEdit,
             AllowSortOrderEdit,
             UsedInCareManagement)
    values  ('DENIALREASON',
             'Denial Reason',
             'Y',
             'Y',
             'Y',
             'Y',
             'Y') 
  end

if not exists ( select  GlobalCodeId
                from    GlobalCodes
                where   GlobalCodeId = 2584 )
  begin
    set identity_insert GlobalCodes on

    insert  into GlobalCodes
            (GlobalCodeId,
             Category,
             CodeName,
             Code,
             Active,
             CannotModifyNameOrDelete)
    values  (2584,
             'DENIALREASON',
             'Member copay',
             'MEMBERCOPAY',
             'Y',
             'N') 

    set identity_insert GlobalCodes off
  end

