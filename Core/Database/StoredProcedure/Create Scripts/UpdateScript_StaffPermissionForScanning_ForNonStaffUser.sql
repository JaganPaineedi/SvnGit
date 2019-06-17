/****************************************************************************************************/
/* Date    : 16-Oct-2017                                                                            */
/* Author  : Arjun K R                                                                              */
/* Purpose : Script to give permission for imageassociation and imageupload for all non staff user  */
/****************************************************************************************************/

 IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes where Category='STAFFROLE' and CodeName='PATIENTPORTALUSER' and ISNULL(RecordDeleted,'N')='N')  
 BEGIN  
   INSERT INTO GlobalCodes(Category,CodeName,code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color)  
   VALUES('STAFFROLE','PATIENTPORTALUSER','PATIENTPORTALUSER',NULL,'Y','Y',NULL,'CLIENTSTAFF',NULL,NULL,NULL,NULL,NULL,NULL)   
 END  
 
 
DECLARE @PatientPortalRoleId INT    
SELECT TOP 1 @PatientPortalRoleId =GlobalCodeId FROM GlobalCodes where Category='STAFFROLE' and CodeName='PATIENTPORTALUSER' and ISNULL(RecordDeleted,'N')='N'  

INSERT INTO StaffRoles (StaffId,RoleId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)  
SELECT S.StaffId,@PatientPortalRoleId,'SHSDBA',GetDate(),'SHSDBA',GetDate()  
FROM Staff S WHERE 
NOT EXISTS(Select 1 from StaffRoles SR where SR.RoleId=@PatientPortalRoleId and SR.StaffId=S.StaffId and ISNULL(SR.RecordDeleted,'N')='N')
AND ISNULL(S.NonStaffUser, 'N') = 'Y'
AND S.TempClientId IS NOT NULL 


INSERT INTO PermissionTemplates(RoleId,PermissionTemplateType,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)  
SELECT @PatientPortalRoleId,G.GlobalCodeId ,'SHSDBA',GetDate(),'SHSDBA',GetDate()  
FROM GlobalCodes G WHERE G.Category='PERMISSIONTEMPLATETP' and ISNULL(G.RecordDeleted,'N')='N'  
AND NOT EXISTS(SELECT 1 FROM PermissionTemplates SR WHERE SR.PermissionTemplateType=G.GlobalCodeId   
AND SR.RoleId=@PatientPortalRoleId AND ISNULL(SR.RecordDeleted,'N')='N')  


/****************************** Image Association********************************************************************/  
DECLARE @PermissionTemplateId INT  
SELECT TOP 1 @PermissionTemplateId= PermissionTemplateId  FROM PermissionTemplates WHERE RoleId=@PatientPortalRoleId   
AND PermissionTemplateType=5908 AND ISNULL(RecordDeleted,'N')='N' 

INSERT INTO PermissionTemplateItems(PermissionTemplateId,PermissionItemId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)  
SELECT @PermissionTemplateId,GC.GlobalCodeId,'SHSDBA',GetDate(),'SHSDBA',GetDate()  
FROM GlobalCodes GC
WHERE GC.GlobalCodeId=5811 
AND ISNULL(GC.RecordDeleted,'N')='N'   
AND NOT EXISTS(SELECT 1 FROM PermissionTemplateItems SR WHERE SR.PermissionTemplateId=@PermissionTemplateId 
AND SR.PermissionItemId=GC.GlobalCodeId and GC.GlobalCodeId=5811 AND ISNULL(SR.RecordDeleted,'N')='N') 
/*******************************************************************************************************************/


/**************************** Image Upload *************************************************************************/
SELECT TOP 1 @PermissionTemplateId= PermissionTemplateId  FROM PermissionTemplates WHERE RoleId=@PatientPortalRoleId   
AND PermissionTemplateType=5921 AND ISNULL(RecordDeleted,'N')='N' 

INSERT INTO PermissionTemplateItems(PermissionTemplateId,PermissionItemId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)  
SELECT @PermissionTemplateId,S.ScreenId,'SHSDBA',GetDate(),'SHSDBA',GetDate()  
FROM Screens S
WHERE S.ScreenId=103 
AND ISNULL(S.RecordDeleted,'N')='N'   
AND NOT EXISTS(SELECT 1 FROM PermissionTemplateItems SR WHERE SR.PermissionTemplateId=@PermissionTemplateId 
AND SR.PermissionItemId=S.ScreenId and S.ScreenId=103 AND ISNULL(SR.RecordDeleted,'N')='N') 
/******************************************************************************************************************/

 
 