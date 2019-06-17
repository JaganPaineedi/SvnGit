IF NOT EXISTS (SELECT * FROM dbo.RecodeCategories WHERE CategoryCode LIKE 'XCoveragePlanToIncludeForPrintingProviderID')
INSERT INTO [dbo].[RecodeCategories]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[CategoryCode]
           ,[CategoryName]
           ,[Description]
           ,[MappingEntity]
           ,[RecodeType]
           )



select  'sa'
		,getdate()
		,'sa'	
		,getdate()
		,'XCoveragePlanToIncludeForPrintingProviderID'
		,'XCoveragePlanToIncludeForPrintingProviderID'
		,'Show Provider ID in the Paper Claim for these Coverage Plans'
		,'CoveragePlans.coveragePlanId'
		,8401


--SELECT TOP 1 * FROM recodecategories ORDER BY 1 DESC
DECLARE @RecodeCategory1Id INT = (SELECT recodecategoryid FROM dbo.RecodeCategories WHERE CategoryName LIKE 'XCoveragePlanToIncludeForPrintingProviderID')
DECLARE @IntegerCodeId INT = (SELECT CoveragePlanId FROM dbo.CoveragePlans WHERE CoveragePlanName LIKE 'DMAP - MH')
IF NOT EXISTS (SELECT * FROM dbo.Recodes WHERE RecodeCategoryId = @RecodeCategory1Id AND IntegerCodeId = @IntegerCodeId) 
   INSERT INTO [dbo].[Recodes]
           ([CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[IntegerCodeId]
           ,[CodeName]
           ,[RecodeCategoryId]
          )
 
values ('sa', getdate(),'sa',getdate(),@IntegerCodeId,'DMAP - MH',@RecodeCategory1Id)


--SELECT TOP 1 * FROM dbo.Recodes ORDER BY 1 desc




