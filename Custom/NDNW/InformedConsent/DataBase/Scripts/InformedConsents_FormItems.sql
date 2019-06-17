--Created By: Amit Kumar Srivastava
--Created Date: 2 Dec 2011
--Modified Date: 13 Dec 2011
--Purpose: Insert Category for DFA
 ---------------------FormCollection TAble Entry-------------------------

 if(not(Exists(select FormCollectionId from FormCollections where FormCollectionId=35)))
 begin
 Set Identity_Insert FormCollections ON
	INSERT INTO FormCollections
           (FormCollectionId,
          NumberOfForms)
     VALUES(35,1)     
 Set Identity_Insert FormCollections OFF
end                        ---------------END-------------
GO
------------------------------------Form Table Entry--------------------------------
Set Identity_Insert Forms ON
 if(not(Exists(select FormId from Forms where FormId=132)))
 begin
	INSERT INTO Forms
           (FormId,
           [FormName]
           ,[TableName]
           ,[TotalNumberOfColumns]
           ,[Active]
        )
     VALUES
           (132,'Informed Consent','CustomDocumentInformedConsents',1,'Y')
	end
 Set Identity_Insert  Forms OFF
                           ---------------END-------------
GO
-------------------------------FormCollectionForms Table Entry---------------------------
Set Identity_Insert FormCollectionForms ON
 if(not(Exists(select FormCollectionFormId from FormCollectionForms where FormCollectionFormId=66)))
INSERT INTO FormCollectionForms
           (FormCollectionFormId,
           [FormCollectionId]
           ,[FormId]
           ,[Active]
           ,[FormOrder])
     VALUES
           (66,35,132,'Y',2)
 Set Identity_Insert  FormCollectionForms OFF
                          ---------------END-------------
GO

 
------------------------------FormSections Table Entry----------------------------------------------
Set Identity_Insert FormSections ON
 if(not(Exists(select FormSectionId  from FormSections where FormSectionId=488)))
INSERT INTO FormSections
           ([FormSectionId]
            ,[FormId]
           ,[SortOrder]
           ,[SectionLabel]
           ,[Active]
          )
     VALUES
           (488,132,1,'','Y')
           
Set Identity_Insert  FormSections OFF
                          ---------------END-------------
GO
------------------------------FormSectionGroups Table Entry----------------------------------------------
Set Identity_Insert FormSectionGroups ON
 if(not(Exists(select FormSectionGroupId  from FormSectionGroups where FormSectionGroupId=1396)))
 begin
INSERT INTO FormSectionGroups
           ([FormSectionGroupId],           
           [FormSectionId]
           ,[SortOrder]          
           ,[Active]           
           ,[NumberOfItemsInRow])
     VALUES
           (1396,488,1,'Y',1)
end
Set Identity_Insert  FormSectionGroups OFF

Set Identity_Insert FormSectionGroups ON
 if(not(Exists(select FormSectionGroupId  from FormSectionGroups where FormSectionGroupId=1397)))
 begin
INSERT INTO FormSectionGroups
           ([FormSectionGroupId],           
           [FormSectionId]
           ,[SortOrder]          
           ,[Active]           
           ,[NumberOfItemsInRow])
     VALUES
           (1397,488,2,'Y',2)
end
Set Identity_Insert  FormSectionGroups OFF


Set Identity_Insert FormSectionGroups ON
 if(not(Exists(select FormSectionGroupId  from FormSectionGroups where FormSectionGroupId=1398)))
 begin
INSERT INTO FormSectionGroups
           ([FormSectionGroupId],           
           [FormSectionId]
           ,[SortOrder]          
           ,[Active]           
           ,[NumberOfItemsInRow])
     VALUES
           (1398,488,3,'Y',1)
end
Set Identity_Insert  FormSectionGroups OFF
                          ---------------END-------------
GO
------------------------------FormItems Table Entry----------------------------------------------
Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5472))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5472, 488, 1396, 5374, 'I have read the New Directions Northwest Handbook, and discussed any parts of it I did not understand with my casework staff. Staff have explained to me and I understand the purpose of the Handbook and what it says including the following:' ,1, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF 

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5473))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5473, 488, 1396, 5374, '<b>•</b> My rights according to Chapter II of the Mental Health and Developmental Disabilities Code, the Illinois Confidentiality Act and the Health Insurance Portability and Accountability Act of 1996 (HIPAA).<br/>' ,2, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF 

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5474))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5474, 488, 1396, 5374, '<b>•</b> Services and activities offered by New Directions Northwest<br/>' ,3, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5475))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5475, 488, 1396, 5374, '<b>•</b> How assessments are used and how my care plan is developed with my input and/or others.<br/>' ,4, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5476))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5476, 488, 1396, 5374, '<b>•</b> Information on how I move through and leave New Directions Northwest.<br/>' ,5, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5477))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5477, 488, 1396, 5374, '<b>•</b>  My role as a client at New Directions Northwest<br/>
' ,6, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  



Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5478))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5478, 488, 1396, 5374, '<b>•</b> When and how I would file a grievance or complaint<br/>
' ,7, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5479))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5479, 488, 1396, 5374, '<b>•</b> New Directions Northwest Code of Ethics<br/>
' ,8, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5480))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5480, 488, 1396, 5374, '<b>•</b> Information on Advance Directives<br/>
' ,9, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5481))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5481, 488, 1396, 5374, '<b>•</b> How I am involved in outcomes, evaluating and giving input on the services and my satisfaction at New Directions Northwest<br/>
' ,10, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5482))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5482, 488, 1396, 5374, '<b>•</b> How I pay for New Directions Northwest services<br/>
' ,11, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5483))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5483, 488, 1396, 5374, '<b>•</b> Safety Information when I am in a New Directions Northwest building<br/>
' ,12, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5484))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5484, 488, 1396, 5374, '<b>•</b> What New Directions Northwest does when someone brings drugs (legal or illegal) or weapons to the program<br/>
' ,13, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5485))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5485, 488, 1396, 5374, '<b>•</b> Where I can smoke at a New Directions Northwest Program<br/>
' ,14, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF



Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5486))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5486, 488, 1396, 5374, '<b>•</b> Rules about seclusion and restraint<br/>' ,15, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5487))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5487, 488, 1396, 5374, 'o Conditions that lead to restrictions or loss of privileges and how to get them back if taken away ' ,16, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5488))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5488, 488, 1396, 5374, 'In addition, based on the New Directions Northwest Handbook and other orientation information (which includes the following information about my own particular program: services and activities, hours of operation, access to after-hour and crisis services, who my caseworker/program is and how we will work together, and safety information such as where the emergency exits are, first aid kit locations, fire extinguisher locations, and details about emergency drills), my signature following the statement below indicates my informed consent to use New Directions Northwest services and my agreement with the following five points:' ,17, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5489))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5489, 488, 1396, 5374, '1. I authorize New Directions Northwest to bill for services I am entitled to have paid for by third party payors, including insurance companies and government programs such as Medicare and Medicaid, and to directly receive those payments.<br/>
' ,18, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5490))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5490, 488, 1396, 5374, '2. I authorize New Directions Northwest to provide for necessary medical services in the event of an emergency.<br/>
' ,19, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5491))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5491, 488, 1396, 5374, '3. I understand that after I leave New Directions Northwest’s program someone will contact me and ask questions about my psychosocial goal progress. The purpose of these interviews is to improve the services New Directions Northwest offers.
<br/>' ,20, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  


Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5492))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5492, 488, 1396, 5374, '4. I understand that without this signed agreement I cannot participate in the rehabilitation programs designed for me at New Directions Northwest.<br/>' ,21, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5493))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5493, 488, 1396, 5374, '<b>Client Signature Prompt:</b><br/>' ,22, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5494))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5494, 488, 1396, 5374, 'The New Directions Northwest Handbook and other orientation information clearly outline the potential advantages and disadvantages of being a registered client of the organization.<br/>' ,23, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5495))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5495, 488, 1396, 5374, '<b>Witness Signature Prompt:</b><br/>' ,24, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5496))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5496, 488, 1396, 5374, 'I witnessed the client sign this informed consent, and I verify that the contents of the informed consent have been explained to and are understood by the client and/or guardian as applicable.' ,25, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5497))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5497, 488, 1397, 5362, '' ,1, 'Y',  'Y', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  
             

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5498))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5498, 488, 1397, 5374, 'Client refuses or is unwilling to sign this consent' ,2, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  
            

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5499))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5499, 488, 1398, 5374, 'Client refuses or is unwilling to sign this consent because (explain):' ,1, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  
            

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5500))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[MaximumLength],[DropdownType],[ItemColumnName])
VALUES 
(5500, 488, 1398, 5363, '' ,1, 'Y',  'N', 600,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  

Set Identity_Insert FormItems ON 
if(not(Exists(select FormItemId from FormItems where FormItemId=5502))) 
BEGIN 
INSERT INTO FormItems 
([FormItemId],[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],  [GlobalCodeCategory],[ItemColumnName],[MaximumLength],[DropdownType])
VALUES 
(5502, 488, 1396, 5374, '5. I understand the risks and costs involved in my services at New Directions Northwest including the nature of the services, possible alternative services and the potential risk and benefits of the services.<br/>' ,23, 'Y',  'N', NULL,NULL,NULL,NULL,NULL) 
END
Set Identity_Insert FormItems OFF  

                        
---------------END-------------
GO


 ----------------------------------------   DocumentCodes Table   -----------------------------------
Set Identity_Insert documentCodes ON
 if(not(Exists(select DocumentCodeId from documentCodes where DocumentCodeId=10037)))
 begin
   INSERT INTO documentCodes
       (DocumentCodeId,DocumentName,DocumentDescription,DocumentType,Active,ServiceNote,OnlyAvailableOnline,StoredProcedure,TableList,RequiresSignature,FormCollectionId,ViewDocumentURL,ViewDocumentRDL,ViewStoredProcedure)
        VALUES(10037,'Informed Consent',NULL,10,'Y','N','Y','csp_SCGetCustomDocumentInformedConsents','CustomDocumentInformedConsents','Y',35,'RDLCustomDocumentInformedConsents','RDLCustomDocumentInformedConsents','csp_RDLGetCustomDocumentInformedConsents')
 end
  Set Identity_Insert documentCodes OFF
  GO
   -----------------------------------------------END--------------------------------------------
                  
                   
   ----------------------------------------   Screens Table   -----------------------------------
 Set Identity_Insert screens ON
 if(not(Exists(select ScreenId from screens where screenId=10975)))
 BEGIN
    INSERT INTO screens
  (ScreenId,ScreenName,ScreenType,ScreenURL,TabId,InitializationStoredProcedure,DocumentCodeId,validationstoredprocedureupdate,PostupdatestoredProcedure) 
  values(10975,'Informed Consent',5763,'/Custom/InformedConsent/WebPages/CustomInformedConsents.ascx',2,'csp_InitCustomDocumentInformedConsents',10037,'csp_ValidateCustomDocumentInformedConsents','csp_SCPostUpdateCustomDocumentInformedConsents')
 END
  Set Identity_Insert screens OFF
  
  if(Exists(select ScreenId from screens where screenId=10684))
 BEGIN
	update screens
	set PostupdatestoredProcedure='csp_SCPostUpdateCustomRegistrations'
	where screenid=10684
 end
    -----------------------------------------------END--------------------------------------------
    
       ----------------------------------------   Banners Table   -----------------------------------

 if(not(Exists(select ScreenId from banners where ScreenId=10975)))
 BEGIN
  INSERT INTO banners
  (BannerName,DisplayAs,Active,DefaultOrder,Custom,TabId,ScreenId,parentbannerid)
  values('Informed Consent','Informed Consent','Y',1,'Y','2',10975,21)
 END
 
  
    -----------------------------------------------END--------------------------------------------