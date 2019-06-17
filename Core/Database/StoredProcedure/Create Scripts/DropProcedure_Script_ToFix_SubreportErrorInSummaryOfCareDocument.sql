
/****** Object:  StoredProcedure [dbo].[csp_SCGetSOCFunctionalCognitiveDetails]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetSOCFunctionalCognitiveDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetSOCFunctionalCognitiveDetails]
GO


/****** Object:  StoredProcedure [dbo].[csp_SCGetSOCFunctionalCognitiveDetailsAnswers]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetSOCFunctionalCognitiveDetailsAnswers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetSOCFunctionalCognitiveDetailsAnswers]
GO