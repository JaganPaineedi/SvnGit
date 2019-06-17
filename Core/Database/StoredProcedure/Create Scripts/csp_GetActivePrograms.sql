/****** Object:  StoredProcedure [dbo].[csp_GetActivePrograms]    Script Date: 04/11/2013 11:09:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetActivePrograms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetActivePrograms]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetActivePrograms]    Script Date: 04/11/2013 11:09:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Robert Caffrey  
-- Create date: 12 Apr 2013  
-- Description: Added for Binding dropdown for Revenue Report  
-- =============================================  



Create Procedure [dbo].[csp_GetActivePrograms]

AS

Select 
Programs.ProgramName,
Programs.ProgramId
 from Programs
 where Active = 'y'
 AND ISNULL(Programs.RecordDeleted,'N') = 'N'
 union Select '<All Programs>', null
 
 Order by 1
 





GO


