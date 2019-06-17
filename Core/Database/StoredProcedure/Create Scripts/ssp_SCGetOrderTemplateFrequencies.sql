/****** Object:  StoredProcedure [dbo].[ssp_SCGetOrderTemplateFrequencies]    Script Date: 07/31/2013 12:00:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetOrderTemplateFrequencies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetOrderTemplateFrequencies]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetOrderTemplateFrequencies]    Script Date: 07/31/2013 12:00:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[ssp_SCGetOrderTemplateFrequencies]     
/********************************************************************************                                                      
-- Stored Procedure: ssp_SCGetOrderTemplates  
-- Copyright: Streamline Healthcare Solutions    
-- Purpose: Procedure to return Order Templates for shared tables.    
-- Author:  Vithobha    
-- Date:    June 06 2013    
-- *****History Start****    
   Praveen Potnuru Added DispenseTime7,DispenseTime8 on 16/04/2014
   31/March/2015 Varun Added IsDefault 
-- *****History End****                                                                                              
 /*   Updates:                                                       */                                                                                              
 /*   Date			Author			Purpose                       */      
/*	27 May 2015		Chethan N		What: Replaced Inner Join with Left join as 'No frequency' has no global codes
									Why:  Woods - Environment Issues Tracking task # 844.01 */
/*	30/7/2015		Chethan N		What: Added SelectDays to Select statement
									Why: Philhaven Development task# 318		  */
/*	03 Mar 2016		Seema Thakur	What: Added OneTimeOnly to Select statement
									Why: Renaissance - Dev Item task# 651		  */
*********************************************************************************/    
AS     
    BEGIN
    SELECT OTF.OrderTemplateFrequencyId, 
       OTF.CreatedBy, 
       OTF.CreatedDate, 
       OTF.ModifiedBy, 
       OTF.ModifiedDate, 
       OTF.RecordDeleted, 
       OTF.DeletedDate, 
       OTF.DeletedBy, 
       OTF.TimesPerDay, 
       OTF.DispenseTime1, 
       OTF.DispenseTime2, 
       OTF.DispenseTime3, 
       OTF.DispenseTime4, 
       OTF.DispenseTime5, 
       OTF.DispenseTime6,
       OTF.DispenseTime7,
       OTF.DispenseTime8,
       CASE WHEN DispenseTime1 IS NOT NULL THEN CONVERT(VARCHAR(15),DispenseTime1,100)  ELSE '' END +
       CASE WHEN DispenseTime2 IS NOT NULL THEN ', '+ CONVERT(VARCHAR(15),DispenseTime2,100) ELSE '' END+
	   CASE WHEN DispenseTime3 IS NOT NULL THEN ', '+ CONVERT(VARCHAR(15),DispenseTime3,100) ELSE '' END+
	   CASE WHEN DispenseTime4 IS NOT NULL THEN ', '+ CONVERT(VARCHAR(15),DispenseTime4,100) ELSE '' END+
	   CASE WHEN DispenseTime5 IS NOT NULL THEN ', '+ CONVERT(VARCHAR(15),DispenseTime5,100) ELSE '' END+
	   CASE WHEN DispenseTime6 IS NOT NULL THEN ', '+ CONVERT(VARCHAR(15),DispenseTime6,100) ELSE '' END+
	   CASE WHEN DispenseTime7 IS NOT NULL THEN ', '+ CONVERT(VARCHAR(15),DispenseTime7,100) ELSE '' END+
	   CASE WHEN DispenseTime8 IS NOT NULL THEN ', '+ CONVERT(VARCHAR(15),DispenseTime8,100) ELSE '' END
       AS DispenseTimes,
       OTF.FrequencyId,
       OTF.RxFrequencyId,
       OTF.DisplayName,
       OTF.IsPRN,
       CASE WHEN OTF.IsPRN = 'Y' THEN  (ISNULL(GC.CodeName,'')+' - PRN' + ' ('+OTF.DisplayName+')') ELSE ISNULL(GC.CodeName,'') + ' ('+OTF.DisplayName+')' END AS FrequencyName,
       GC1.CodeName As RxFrequencyName,
       OTF.IsDefault,
       OTF.SelectDays,  
       OTF.OneTimeOnly	--Seema 03-Mar-2016
FROM   dbo.OrderTemplateFrequencies  as OTF
LEFT JOIN GlobalCodes as GC on OTF.FrequencyId=GC.GlobalCodeId and ISNULL(GC.RecordDeleted, 'N') = 'N'
LEFT JOIN GlobalCodes as GC1 on OTF.RxFrequencyId=GC1.GlobalCodeId and ISNULL(GC1.RecordDeleted, 'N') = 'N'
       WHERE   ISNULL(OTF.RecordDeleted, 'N') = 'N'    
       RETURN    
    END  
GO


