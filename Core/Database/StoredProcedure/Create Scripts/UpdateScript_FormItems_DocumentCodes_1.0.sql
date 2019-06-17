/*********************************************************************/  
/*  Date         Author       Purpose                                    */                          
/* 12/May/2018  Swatika    Added new column namely "Add Default Staff Co-Signer" and Changed label "Default CoSigner" to "Add Client As Co-Signer" 
                           As part of Renaissance - Dev Items #695*/      

/******************************************************************************************************************************************/ 

/*Changed label "Default CoSigner" to "Add Client As Co-Signer"*/

Update FormItems SET ItemLabel='Add Client As Co-Signer' WHERE ItemLabel='Default CoSigner' AND FormSectionId=390


/*Added new item namely "Add Default Staff Co-Signer"*/
IF NOT EXISTS(SELECT 1 FROM FormItems WHERE ItemLabel='Add Default Staff Co-Signer' AND FormSectionId=390)
BEGIN
INSERT [dbo].[FormItems] ([FormSectionId], [FormSectionGroupId], [ItemType],[ItemLabel], [SortOrder], [Active], [ItemRequiresComment], [ItemWidth]) 
                   VALUES (390, 999, 5374,N'Add Default Staff Co-Signer', 25, N'Y', N'N',175)
END


IF NOT EXISTS(SELECT 1 FROM FormItems WHERE ItemColumnName='DefaultStaffCosigner' AND FormSectionId=390)
BEGIN
INSERT [dbo].[FormItems] ([FormSectionId], [FormSectionGroupId], [ItemType],[ItemLabel], [SortOrder], [Active],[GlobalCodeCategory],[ItemColumnName], [ItemRequiresComment], [ItemWidth],[DropdownType]) 
                   VALUES (390, 999, 5365,N'<span style="margin-left:16px"></span>', 26, N'Y',N'RADIOYN',N'DefaultStaffCosigner', N'N',150,N'G')
END


/*Update Sort order "*/
Update FormItems SET SortOrder=27 , ItemLabel='<span style="margin-left:42px"></span>Need 5 Columns' WHERE ItemLabel='Need 5 Columns' AND FormSectionId=390

Update FormItems SET SortOrder=28 WHERE ItemColumnName='Need5Columns' AND FormSectionId=390

Update FormItems SET SortOrder=29 ,ItemLabel='<span style="margin-left:42px"></span>Family History Document' WHERE ItemLabel='<span style="margin-left:7px"></span>Family History Document' AND FormSectionId=390

Update FormItems SET SortOrder=30 WHERE ItemColumnName='FamilyHistoryDocument' AND FormSectionId=390

Update FormItems SET SortOrder=31,ItemLabel='DSMV' WHERE ItemLabel='<span style="margin-left:42px"></span>DSMV' AND FormSectionId=390

Update FormItems SET SortOrder=32 WHERE ItemColumnName='DSMV' AND FormSectionId=390

Update FormItems SET SortOrder=33 ,ItemLabel='<span style="margin-left:42px"></span>Exclude From Batch Signing' WHERE ItemLabel='Exclude From Batch Signing' AND FormSectionId=390

Update FormItems SET SortOrder=34 WHERE ItemColumnName='ExcludeFromBatchSigning' AND FormSectionId=390

Update FormItems SET SortOrder=35 ,ItemLabel='<span style="margin-left:42px"></span>CoSigner RDL' WHERE ItemLabel='<span style="margin-left:62px"></span>CoSigner RDL' AND FormSectionId=390

Update FormItems SET SortOrder=36 WHERE ItemColumnName='CoSignerRDL' AND FormSectionId=390

Update FormItems SET SortOrder=37 ,ItemLabel='Days Document Editable After Signature' WHERE ItemLabel='<span style="margin-left:42px"></span>Days Document Editable After Signature' AND FormSectionId=390

Update FormItems SET SortOrder=38 WHERE ItemColumnName='DaysDocumentEditableAfterSignature' AND FormSectionId=390

Update FormItems SET SortOrder=39 , ItemLabel='<span style="margin-left:42px"></span>Mobile' WHERE ItemLabel='Mobile' AND FormSectionId=390

Update FormItems SET SortOrder=40 WHERE ItemColumnName='Mobile' AND FormSectionId=390

Update FormItems SET SortOrder=41,ItemLabel='<span style="margin-left:42px">AllowPortalUserAsAuthor' WHERE ItemLabel='<span style="margin-left:7px">AllowPortalUserAsAuthor' AND FormSectionId=390

Update FormItems SET SortOrder=42 WHERE ItemColumnName='AllowClientPortalUserAsAuthor' AND FormSectionId=390

Update FormItems SET SortOrder=43,ItemLabel='Disclosure Print Order' WHERE ItemLabel='<span style="margin-left:43px">Disclosure Print Order' AND FormSectionId=390

Update FormItems SET SortOrder=44 WHERE ItemColumnName='PrintOrder' AND FormSectionId=390

Update FormItems SET SortOrder=45 ,ItemLabel='<span style="margin-left:42px">Disclosure Print Order By Effective date' WHERE ItemLabel='Disclosure Print Order By Effective date' AND FormSectionId=390

Update FormItems SET SortOrder=46 WHERE ItemColumnName='DisclosurePrintOrder' AND FormSectionId=390
