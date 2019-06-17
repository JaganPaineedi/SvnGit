IF Exists(Select FormItemId from FormItems where FormItemId=3172 and FormSectionId=290)
BEGIN
Update FormItems Set ItemType=5366   where FormItemId=3172 and FormSectionId=290
END


IF Exists(Select FormItemId from FormItems where FormItemId=3258 and FormSectionId=294)
BEGIN
 Update FormItems Set ItemType=5366 where FormItemId=3258 and FormSectionId=294
END