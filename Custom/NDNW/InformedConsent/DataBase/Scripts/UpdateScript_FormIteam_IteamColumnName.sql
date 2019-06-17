IF((Exists(select FormItemId from FormItems where FormItemId=5497))) 
BEGIN 
UPDATE FormItems SET [ItemColumnName]='MemberRefusedSignature' WHERE [FormItemId]=5497
END

IF((Exists(select FormItemId from FormItems where FormItemId=5500))) 
BEGIN 
UPDATE FormItems SET [ItemColumnName]='MemberRefusedExplaination' WHERE [FormItemId]=5500
END
             