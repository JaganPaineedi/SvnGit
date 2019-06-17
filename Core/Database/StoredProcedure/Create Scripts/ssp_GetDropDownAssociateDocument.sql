
/****** Object:  StoredProcedure [dbo].[ssp_GetDropDownAssociateDocument]    Script Date: 01/11/2018 12:31:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDropDownAssociateDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetDropDownAssociateDocument]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetDropDownAssociateDocument]    Script Date: 01/11/2018 12:31:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create proc [dbo].[ssp_GetDropDownAssociateDocument]  
/*************************************************************/     
/* Stored Procedure: dbo.[ssp_GetDropDownAssociateDocument ]              */     
/* Creation Date:   3/12/2017                               */     
/* Purpose: To display the AssociateDocument name in DropDown     */     
/*  Date                  Author                 Purpose     */     
/*  3/12/2017          Rajeshwari           Created     */  
/* Task: Engineering Improvement Initiatives- NBL(I) #606 */    
   
/*************************************************************/ 
as  
begin  
select *  from DocumentCodes 
where DocumentType=10 and ServiceNote ='N' 
and ISNULL(RecordDeleted,'N')='N' 
order by DocumentName  
end
GO


