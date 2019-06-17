IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CQMSolution].[ssf_GetServicesTypeEP]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CQMSolution].ssf_GetServicesTypeEP
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CQMSolution].[ssf_GetServicesTypeEH]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CQMSolution].ssf_GetServicesTypeEH
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CQMSolution].[ssf_GetServices]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [CQMSolution].ssf_GetServices
GO