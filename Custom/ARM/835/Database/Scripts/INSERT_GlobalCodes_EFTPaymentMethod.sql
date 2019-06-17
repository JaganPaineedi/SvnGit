


INSERT  INTO dbo.GlobalCodes
        ( 
         CreatedBy
        ,CreatedDate
        ,ModifiedBy
        ,ModifiedDate
        ,Category
        ,CodeName
        ,Code
        ,Description
        ,Active
        ,CannotModifyNameOrDelete
        )
        SELECT  'dknewtson'-- CreatedBy - type_CurrentUser
               ,GETDATE()-- CreatedDate - type_CurrentDatetime
               ,'dknewtson'-- ModifiedBy - type_CurrentUser
               ,GETDATE()-- ModifiedDate - type_CurrentDatetime
               ,'PAYMENTMETHOD'-- Category - char(20)
               ,'EFT'-- CodeName - varchar(250)
               ,'EFT'-- Code - varchar(100)
               ,'Electronic Finance Transfer'-- Description - type_Comment
               ,'Y'-- Active - type_Active
               ,'N'-- CannotModifyNameOrDelete - type_YOrN
        WHERE   NOT EXISTS ( SELECT 1
                             FROM   dbo.GlobalCodes gc
                             WHERE  Category = 'PAYMENTMETHOD'
                                    AND CodeName = 'EFT' )