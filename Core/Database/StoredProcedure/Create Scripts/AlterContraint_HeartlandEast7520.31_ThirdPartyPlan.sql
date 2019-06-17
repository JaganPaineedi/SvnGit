ALTER TABLE [dbo].[CoveragePlans] DROP CONSTRAINT [CK__CoverageP__Third__650F7D9F]
GO

ALTER TABLE [dbo].[CoveragePlans]  WITH CHECK ADD CHECK  (([ThirdPartyPlan]='I' OR [ThirdPartyPlan]='N' OR [ThirdPartyPlan]='Y' OR [ThirdPartyPlan]='R'))
GO