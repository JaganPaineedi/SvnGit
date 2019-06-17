--Manjunath Kondikoppa
--Date: 23 Jan 2018
--SmartViewSection Entries

--Graph
IF NOT EXISTS (SELECT 1 FROM SmartViewSections WHERE SectionName='Graph')
BEGIN
	INSERT INTO SmartViewSections (SectionName,SectionURL,DisplayAs,CustomSection,DefaultOrder,SectionHeight,ScreenIdToRedirect,Active,JavascriptFilePath,DetailPageScreenId)
	VALUES ('Graph','/Modules/SmartView/WebPages/SmartViewGraph.ascx','BMI','N',1,120,715,'Y','Modules/SmartView/Scripts/SmartViewGraph.js',716)
END
ELSE
BEGIN
	UPDATE SmartViewSections SET SectionName='Graph', SectionURL='/Modules/SmartView/WebPages/SmartViewGraph.ascx', DisplayAs='BMI'
	,DefaultOrder = 1,SectionHeight=120,ScreenIdToRedirect=715,Active='Y', DetailPageScreenId = 716,
	JavascriptFilePath = 'Modules/SmartView/Scripts/SmartViewGraph.js'
	where SectionName='Graph'
END
--Vitals
IF NOT EXISTS (SELECT 1 FROM SmartViewSections WHERE SectionName='Vitals')
BEGIN
	INSERT INTO SmartViewSections (SectionName,SectionURL,DisplayAs,CustomSection,DefaultOrder,SectionHeight,ScreenIdToRedirect,Active,JavascriptFilePath,DetailPageScreenId)
	VALUES ('Vitals','/Modules/SmartView/WebPages/SmartViewVitals.ascx','Vitals','N',2,90,715,'Y','Modules/SmartView/Scripts/SmartViewVitals.js',716)
END
ELSE
BEGIN
	UPDATE SmartViewSections SET SectionName='Vitals', SectionURL='/Modules/SmartView/WebPages/SmartViewVitals.ascx', DisplayAs='Vitals'
	,DefaultOrder = 2,SectionHeight=90,ScreenIdToRedirect=715,Active='Y', DetailPageScreenId = 716,
	JavascriptFilePath = 'Modules/SmartView/Scripts/SmartViewVitals.js'
	where SectionName='Vitals'
END

--Allergies
IF NOT EXISTS (SELECT 1 FROM SmartViewSections WHERE SectionName='Allergies')
BEGIN
	INSERT INTO SmartViewSections (SectionName,SectionURL,DisplayAs,CustomSection,DefaultOrder,SectionHeight,ScreenIdToRedirect,Active,JavascriptFilePath,DetailPageScreenId)
	VALUES ('Allergies','/Modules/SmartView/WebPages/SmartViewAllergies.ascx','Allergies','N',3,90,1027,'Y','Modules/SmartView/Scripts/SmartViewAllergies.js',1027)
END
ELSE
BEGIN
	UPDATE SmartViewSections SET SectionName='Allergies', SectionURL='/Modules/SmartView/WebPages/SmartViewAllergies.ascx', DisplayAs='Allergies'
	,DefaultOrder = 3,SectionHeight=90,ScreenIdToRedirect=1027,Active='Y', DetailPageScreenId = 1027,
	JavascriptFilePath = 'Modules/SmartView/Scripts/SmartViewAllergies.js'
	where SectionName='Allergies'
END

--Medications
IF NOT EXISTS (SELECT 1 FROM SmartViewSections WHERE SectionName='Medications')
BEGIN
	INSERT INTO SmartViewSections (SectionName,SectionURL,DisplayAs,CustomSection,DefaultOrder,SectionHeight,ScreenIdToRedirect,Active,JavascriptFilePath,DetailPageScreenId)
	VALUES ('Medications','/Modules/SmartView/WebPages/SmartViewMedications.ascx','Medications','N',4,90,985,'Y','Modules/SmartView/Scripts/SmartViewMedications.js',985)
END
ELSE
BEGIN
	UPDATE SmartViewSections SET SectionName='Medications', SectionURL='/Modules/SmartView/WebPages/SmartViewMedications.ascx', 
	DisplayAs='Medications',DefaultOrder = 4,SectionHeight=90,ScreenIdToRedirect=985,Active='Y', DetailPageScreenId = 985,
	JavascriptFilePath = 'Modules/SmartView/Scripts/SmartViewMedications.js'
	where SectionName='Medications'
END

--Immunizations
IF NOT EXISTS (SELECT 1 FROM SmartViewSections WHERE SectionName='Immunizations')
BEGIN
	INSERT INTO SmartViewSections (SectionName,SectionURL,DisplayAs,CustomSection,DefaultOrder,SectionHeight,ScreenIdToRedirect,Active,JavascriptFilePath,DetailPageScreenId)
	VALUES ('Immunizations','/Modules/SmartView/WebPages/SmartViewImmunizations.ascx','Immunizations','N',5,90,176,'Y','Modules/SmartView/Scripts/SmartViewImmunizations.js',176)
END
ELSE
BEGIN
	UPDATE SmartViewSections SET SectionName='Immunizations', SectionURL='/Modules/SmartView/WebPages/SmartViewImmunizations.ascx', 
	DisplayAs='Immunizations' ,DefaultOrder = 5,SectionHeight=90,ScreenIdToRedirect=176,Active='Y', DetailPageScreenId = 176,
	JavascriptFilePath = 'Modules/SmartView/Scripts/SmartViewImmunizations.js'
	where SectionName='Immunizations'
END
 

--select *  from SmartViewSections