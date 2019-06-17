--ScreenId=10683 Entry
--Created by katta sharath kumar  on 23 July 2013
--Screens Table Entry
SET IDENTITY_INSERT Screens on
IF Not EXISTS(SELECT * FROM Screens WHERE ScreenId=10683)
	INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId,ValidationStoredProcedureUpdate,PostUpdateStoredProcedure)
	VALUES 
	(10683,'Inquiry Details',5761,'/Custom/InquiryDetails/WebPages/MemberInquiryDetail.ascx',1,'csp_SCValidateInquiry','csp_PostUpdateInquiry')
	else
	update Screens set
	ScreenName='Inquiry Details',
	ScreenType=5761,
	ScreenURL='/Custom/InquiryDetails/WebPages/MemberInquiryDetail.ascx',
	TabId=1,
	ValidationStoredProcedureUpdate='csp_SCValidateInquiry',
	PostUpdateStoredProcedure='csp_PostUpdateInquiry'
	where ScreenId=10683
SET IDENTITY_INSERT Screens off

SET IDENTITY_INSERT Screens on
IF Not EXISTS(SELECT ScreenId FROM Screens WHERE ScreenId=40022)
	INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId)
	VALUES 
	(40022,'Guardian Information',5761,'/Custom/InquiryDetails/WebPages/MemberInquiryGuardianInformation.ascx',1)
	else
	update Screens set
	ScreenName='Guardian Information',
	ScreenType=5761,
	ScreenURL='/Custom/InquiryDetails/WebPages/MemberInquiryGuardianInformation.ascx',
	TabId=1
	where ScreenId=40022
SET IDENTITY_INSERT Screens off

SET IDENTITY_INSERT Screens on
IF Not EXISTS(SELECT ScreenId FROM Screens WHERE ScreenId=10681)
	INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId)
	VALUES 
	(40023,'Client Inquiries',5762,'/Custom/InquiryDetails/WebPages/MemberInquiriesList.ascx',2)
	else
	update Screens set
	ScreenName='Client Inquiries',
	ScreenType=5762,
	ScreenURL='/Custom/InquiryDetails/WebPages/MemberInquiriesList.ascx',
	TabId=2
	where ScreenId=10681
SET IDENTITY_INSERT Screens off

SET IDENTITY_INSERT Screens ON
IF Not EXISTS(SELECT ScreenId FROM Screens WHERE ScreenId=10680)
	INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId)
	VALUES 
	(10680,'Inquiries',5762,'/Custom/InquiryDetails/WebPages/Inquiries.ascx',1)
	else
	update Screens set
	ScreenName='Inquiries',
	ScreenType=5762,
	ScreenURL='/Custom/InquiryDetails/WebPages/Inquiries.ascx',
	TabId=1	where ScreenId=10680
SET IDENTITY_INSERT Screens off



----------------------------------------   Banner Table   -----------------------------------  
IF Not EXISTS(SELECT ScreenId FROM Banners WHERE ScreenId=10680)
      Insert INTO Banners(BannerName,DisplayAs,Active,DefaultOrder,TabId,Custom,ScreenId)
      Values('Inquiries','Inquiries','Y',1,1,'N',10680)
else
     UPDATE Banners SET BannerName='Inquiries',
	DisplayAs='Inquiries',
	Active='Y',
	DefaultOrder=1,
	TabId=1
	WHERE ScreenId=10680
      
IF Not EXISTS(SELECT ScreenId FROM Banners WHERE ScreenId=10681)
    Insert into Banners(BannerName,DisplayAs,Active,DefaultOrder,TabId,Custom,ScreenId)
     Values ('Client Inquiries','Client Inquiries','Y',1,2,'N',10681)
Else
UPDATE Banners SET
	BannerName='Client Inquiries',
	DisplayAs='Client Inquiries',
	Active='Y',
	DefaultOrder=1,
	TabId=2	
	WHERE ScreenId=10681





