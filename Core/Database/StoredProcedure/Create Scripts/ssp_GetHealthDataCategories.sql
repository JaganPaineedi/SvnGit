
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetHealthDataCategories]    Script Date: 06/13/2015 16:55:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHealthDataCategories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetHealthDataCategories]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetHealthDataCategories]    Script Date: 06/13/2015 16:55:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*********************************************************************/                                                    
/* Stored Procedure: dbo.ssp_GetHealthDataCategories				 */                                                                       
/* Creation Date:  May/06/2011										 */                                                                                                       
/* Purpose:  Get All  HealthDataCategories							 */                                                                                            
/* Input Parameters:												 */                                                                                                
/* Output Parameters:												 */                                                    
/* Return:  Data Table if suceess otherwise raise an error			 */                                                                 
/* Author:Devi Dayal Jangra											 */                            
/* Gautam				11/17/2013			Modifed the ssp as per the task 5 in Core Bugs.
											To display all health data elements and health data
											sub templates associated to lab vitals	*/ 
/* Chethan N			01/17/2014			What: Removed Checking for -1 in else if
											Why: To return empty result set for the input values other than 6309 & 6310
 15/Oct/2014   PPOTNURU Modified Table Name				
 03/Nov/2014   PPOTNURU Removed category where condition								*/
/*********************************************************************/ 
CREATE PROCEDURE [dbo].[ssp_GetHealthDataCategories] 
	-- Add the parameters for the stored procedure here
	( @HealthData int,
	  @HealthDataName varchar(100)= ''
	)
AS
BEGIN

DECLARE @Name VARCHAR(50)      
SET @Name= '%' + @HealthDataName + '%'   

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY	
		
		--SELECT 
		--	HealthDataCategoryId,
		--	CategoryName					 
		--FROM  HealthDataCategories
		--WHERE Active='Y' And RecordDeleted is null
		
		IF @HealthData=6309 
			Begin
				Select HealthDataAttributeId as HealthDataId,
				Name as CategoryName from HealthDataAttributes 
				where Name LIKE @Name and ISNULL(RecordDeleted,'N')='N'
			End
		ELSE IF @HealthData=6310 
				Begin
					select DISTINCT HDST.HealthDataSubTemplateId as HealthDataId,HDST.Name as CategoryName
					FROM   HealthDataSubTemplates HDST 
					JOIN HealthDataTemplateAttributes HDTA  
							ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId and   ISNULL(HDST.RecordDeleted,'N')='N'
								 and  ISNULL(HDTA.RecordDeleted,'N')='N'
					JOIN HealthDataTemplates HDT   
						   ON HDT.HealthDataTemplateId = HDTA.HealthDataTemplateId and   ISNULL(HDT.RecordDeleted,'N')='N'
					JOIN HealthDataSubTemplateAttributes HDSTA   
						   ON HDST.HealthDataSubTemplateId = HDSTA.HealthDataSubTemplateId   and   ISNULL(HDSTA.RecordDeleted,'N')='N'
					JOIN HealthDataAttributes HDA   
						   ON HDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId  and   ISNULL(HDA.RecordDeleted,'N')='N'   
					WHERE  HDA.Category =8226  
				End
		ELSE 
				Begin
					Select ' ' as HealthDataId,' ' as CategoryName FROM SystemConfigurations WHERE Databaseversion=-1 
				End
		
		
	END TRY
	BEGIN CATCH
		RAISERROR  20006   'ssp_GetHealthDataCategories: An Error Occured' 		
	END CATCH
	
	
END

GO

