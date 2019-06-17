

--Used CodeName in the If condition as per Shankha, Sincethe Code field was NULL in few environments
-- Modifications
-- Date                    Name                           Purpose
--07/25/2018             Pranay                           Added additional combinations w.r.t 950
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE category ='SURESCRIPTSLEVEL' and CodeName = 'No Surescripts')
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES('SURESCRIPTSLEVEL','No Surescripts','NoSureScript','NULL','Y','N',1,0,NULL,NULL,NULL,NULL) 
END
ELSE
BEGIN
UPDATE GlobalCodes
SET Code = 'NoSureScript'
WHERE  category ='SURESCRIPTSLEVEL' and CodeName = 'No Surescripts'
END
GO

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx Only')
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES('SURESCRIPTSLEVEL','NewRx Only','NewRx','NULL','Y','N',2,1,NULL,NULL,NULL,NULL) 
END
ELSE
BEGIN
UPDATE GlobalCodes
SET Code = 'NewRx'
WHERE  category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx Only'
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx + Refill')
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES('SURESCRIPTSLEVEL','NewRx + Refill','NewRxRefill','NULL','Y','N',4,3,NULL,NULL,NULL,NULL) 
END
ELSE
BEGIN
UPDATE GlobalCodes
SET Code = 'NewRxRefill'
WHERE  category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx + Refill'
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx + CancelRx')
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES('SURESCRIPTSLEVEL','NewRx + CancelRx','NewRxCancel','NULL','Y','N',3,17,NULL,NULL,NULL,NULL) 
END
ELSE
BEGIN
UPDATE GlobalCodes
SET Code = 'NewRxCancel'
WHERE  category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx + CancelRx'
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx + Refill + CancelRx')
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES('SURESCRIPTSLEVEL','NewRx + Refill + CancelRx','NewRxRefillCancel','NULL','Y','N',5,19,NULL,NULL,NULL,NULL) 
END
ELSE
BEGIN
UPDATE GlobalCodes
SET Code = 'NewRxRefillCancel'
WHERE  category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx + Refill + CancelRx'
END
GO


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx + Refill + EPCS')
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
VALUES('SURESCRIPTSLEVEL','NewRx + Refill + EPCS','NewRxRefillEPCS','NULL','Y','N',6,2051,NULL,NULL,NULL,NULL) 
END
ELSE
BEGIN
UPDATE GlobalCodes
SET Code = 'NewRxRefillEPCS'
WHERE  category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx + Refill + EPCS'
END
GO

IF NOT EXISTS ( SELECT  GlobalCodeId
                FROM    GlobalCodes
                WHERE   Category = 'SURESCRIPTSLEVEL'
                        AND CodeName = 'NewRx + FillRx' )
    BEGIN
        INSERT  INTO GlobalCodes
                ( Category ,
                  CodeName ,
                  Code ,
                  Description ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap
                )
        VALUES  ( 'SURESCRIPTSLEVEL' ,
                  'NewRx + FillRx' ,
                  'NewRxFillRx' ,
                  'NULL' ,
                  'Y' ,
                  'N' ,
                  7 ,
                  9 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL
                ); 
    END;



IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx + Refill + CancelRx + EPCS')
BEGIN
INSERT  INTO GlobalCodes
                ( Category ,
                  CodeName ,
                  Code ,
                  Description ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap
                )
        VALUES  ( 'SURESCRIPTSLEVEL' ,
                  'NewRx + Refill + CancelRx + EPCS' ,
                  'NewRxRefillCancelRxEPCS' ,
                  'NULL' ,
                  'Y' ,
                  'N' ,
                  8,
                  2067 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL
                ); 
end



IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE category ='SURESCRIPTSLEVEL' and CodeName = 'NewRx + Refill + CancelRx + EPCS + ChangeRx + FillRx')
BEGIN
 INSERT  INTO GlobalCodes
                ( Category ,
                  CodeName ,
                  Code ,
                  Description ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap
                )
        VALUES  ( 'SURESCRIPTSLEVEL' ,
                  'NewRx + Refill + CancelRx + EPCS + ChangeRx + FillRx',
                  'NewRxRefillCancelRxEPCSChangeRxFillRx' ,
                  'NULL' ,
                  'Y' ,
                  'N' ,
                  9,
                  2079 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL
                ); 
end


IF NOT EXISTS ( SELECT  GlobalCodeId
                FROM    GlobalCodes
                WHERE   Category = 'SURESCRIPTSLEVEL'
                        AND CodeName = 'NewRx + CancelRx + EPCS' )
    BEGIN
        INSERT  INTO GlobalCodes
                ( Category ,
                  CodeName ,
                  Code ,
                  Description ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap
                )
        VALUES  ( 'SURESCRIPTSLEVEL' ,
                  'NewRx + CancelRx + EPCS' ,
                  'NewRxCancelRxEPCS' ,
                  'NULL' ,
                  'Y' ,
                  'N' ,
                  10 ,
                  2065 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL
                ); 
    END;


    IF NOT EXISTS ( SELECT  GlobalCodeId
                    FROM    GlobalCodes
                    WHERE   Category = 'SURESCRIPTSLEVEL'
                            AND CodeName = 'NewRx + FillRx + CancelRx + EPCS' )
        BEGIN
            INSERT  INTO GlobalCodes
                    ( Category ,
                      CodeName ,
                      Code ,
                      Description ,
                      Active ,
                      CannotModifyNameOrDelete ,
                      SortOrder ,
                      ExternalCode1 ,
                      ExternalSource1 ,
                      ExternalCode2 ,
                      ExternalSource2 ,
                      Bitmap
                    )
            VALUES  ( 'SURESCRIPTSLEVEL' ,
                      'NewRx + FillRx + CancelRx + EPCS' ,
                      'NewRxFillRxCancelRxEPCS' ,
                      'NULL' ,
                      'Y' ,
                      'N' ,
                      11 ,
                      2073 ,
                      NULL ,
                      NULL ,
                      NULL ,
                      NULL
                    ); 
        END;

    IF NOT EXISTS ( SELECT  GlobalCodeId
                    FROM    GlobalCodes
                    WHERE   Category = 'SURESCRIPTSLEVEL'
                            AND CodeName = 'NewRx + FillRx + CancelRx + EPCS+ ChangeRx' )
        BEGIN
            INSERT  INTO GlobalCodes
                    ( Category ,
                      CodeName ,
                      Code ,
                      Description ,
                      Active ,
                      CannotModifyNameOrDelete ,
                      SortOrder ,
                      ExternalCode1 ,
                      ExternalSource1 ,
                      ExternalCode2 ,
                      ExternalSource2 ,
                      Bitmap
                    )
            VALUES  ( 'SURESCRIPTSLEVEL' ,
                      'NewRx + FillRx + CancelRx + EPCS+ ChangeRx' ,
                      'NewRxFillRxCancelRxEPCSChangeRx' ,
                      'NULL' ,
                      'Y' ,
                      'N' ,
                      12 ,
                      2077 ,
                      NULL ,
                      NULL ,
                      NULL ,
                      NULL
                    ); 
        END;
