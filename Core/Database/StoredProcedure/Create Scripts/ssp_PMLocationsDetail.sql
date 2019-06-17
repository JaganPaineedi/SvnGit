
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMLocationsDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMLocationsDetail]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE  Procedure [dbo].[ssp_PMLocationsDetail]
	@LocationId INT      
AS    

/****************************************************************************** 
** File: ssp_PMLocationsDetail.sql
** Name: ssp_PMLocationsDetail 28
** Desc:  
** 
** 
** This template can be customized: 
** 
** Return values: Filter Values - Query to return values for Locations Details
** 
** Called by: 
** 
** Parameters: 
** Input Output 
** ---------- ----------- 
** N/A   Dropdown values
** Auth: Mary Suma
** Date: 04/30/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 04/30/2011		Mary Suma			Query to return values for Locations Details
-------- 			-------- 			--------------- 
-- 24 Aug 2011  Girish		Removed References to Rowidentifier and ExternalReferenceId 
-- 27 Aug 2011  Girish		Readded References to Rowidentifier and ExternalReferenceId
-- 07 Apr 2015  Shruthi.S	Added DefaultLocationForServiceCreationFromClaims new field.Ref #605 Network 180.
-- 03 Nov 2015  MD Hussain	Added new column "AddressDisplay". Ref #249 Engineering Improvement Initiatives- NBL(I). 
-- 13 Sept 2016  Nandita		      Added mobile column to Location table
-- 16 Oct 2017   Prem       Added new column  "TaxIdentificationNumber"  as part of MeaningFull use Stage-3 #62
-- 05 July 2018   Neha      Added new table called 'LocationLaboratoryFacilities' and a new column called 'LabLocation' to Locations table. Ref #667 Engineering Improvement Initiatives- NBL(I). 
*******************************************************************************/

         
BEGIN      
	SELECT  [LocationId]
      ,[LocationCode]
      ,[LocationName]
      ,[Active]
      ,[PrescribingLocation]
      ,[Address]
      ,[City]
      ,[State]
      ,[ZipCode]
      ,[PhoneNumber]
      ,[LocationType]
      ,[PlaceOfService]
      ,[Comment]
      ,[HandicapAcceess]
      ,[Adult]
      ,[Child]
      ,[MondayFrom]
      ,[MondayTo]
      ,[MondayClosed]
      ,[TuesdayFrom]
      ,[TuesdayTo]
      ,[TuesdayClosed]
      ,[WednesdayFrom]
      ,[WednesdayTo]
      ,[WednesdayClosed]
      ,[ThursdayFrom]
      ,[ThursdayTo]
      ,[ThursdayClosed]
      ,[FridayFrom]
      ,[FridayTo]
      ,[FridayClosed]
      ,[SaturdayFrom]
      ,[SaturdayTo]
      ,[SaturdayClosed]
      ,[SundayFrom]
      ,[SundayTo]
      ,[SundayClosed]
      ,[ExternalReferenceId]
      ,[FaxNumber]
      ,[NationalProviderId]
      ,[RowIdentifier]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[DefaultLocationForServiceCreationFromClaims]
      ,[AddressDisplay] 
	  ,[Mobile]
	  --Added by Prem 16 oct 2017
	  ,[TaxIdentificationNumber]
	  ,LabLocation
	  ,CQMCode
	  ,CQMCodeType
	FROM      
		Locations        
	WHERE      
		LocationId=@LocationId       
		AND      
		(ISNULL(RecordDeleted, 'N') ='N' )     
		
--******************************************************************************************************      
--Table 2 LocationClosedDates      
--******************************************************************************************************      
      
	SELECT       
		[LocationClosedDateId]
      ,[LocationId]
      ,[DateClosed]
      ,[RowIdentifier]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
	FROM      
		LocationClosedDates       
	WHERE      
		LocationId=@LocationId       
	AND      
		(ISNULL(RecordDeleted, 'N') ='N' ) 
	
			
--******************************************************************************************************      
--Table 3 LocationLaboratoryFacilities      
--******************************************************************************************************   
SELECT       
	  LLF.LocationLaboratoryFacilityId
      ,LLF.[CreatedBy]
      ,LLF.[CreatedDate]
      ,LLF.[ModifiedBy]
      ,LLF.[ModifiedDate]
      ,LLF.[RecordDeleted]
      ,LLF.[DeletedDate]
      ,LLF.[DeletedBy]
      ,LLF.LocationId 
      ,LLF.LaboratoryFacilityId
      ,LF.FacilityName as FacilityName
      ,L.LaboratoryName as LaboratoryName
      ,L.LaboratoryId
	FROM LocationLaboratoryFacilities  LLF  
		JOIN LaboratoryFacilities LF on LF.LaboratoryFacilityId=LLF.LaboratoryFacilityId AND (ISNULL(LF.RecordDeleted, 'N') ='N' ) 
		JOIN Laboratories L on L.LaboratoryId=LF.LaboratoryId AND (ISNULL(L.RecordDeleted, 'N') ='N' )  
	WHERE LLF.LocationId=@LocationId       
		AND (ISNULL(LLF.RecordDeleted, 'N') ='N' ) 
		
	  
END      
      
GO