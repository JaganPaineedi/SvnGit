 
/****** Object:  StoredProcedure [dbo].[csp_SCGetLocusSectionIIScore]    Script Date: 12/02/2011 14:42:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetLocusSectionIIScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetLocusSectionIIScore]
GO

   
create  Procedure [dbo].[csp_SCGetLocusSectionIIScore]            
                 
As            
/*********************************************************************/                            
/* Stored Procedure: dbo.[csp_SCGetLocusSectionIIScore]             */                            
/* Creation Date:  12/02/2011                                              */                            
/*                                                                       */                            
/* Purpose: To Get bind the Section II Score List with  static values like  */                           
/*                                                                   */                          
/*                                                                   */                            
/* Output Parameters:                                */                            
/*                                                                   */                            
/*  Date                  Author                 Purpose          */                            
/* 12/02/2011             Rakesh Kumar -II               Created         */                            
/*********************************************************************/                     
            
    Declare @table table  
 (  
  TextField  nvarchar(100),  
  ValueField int  
 )  
  
insert into @table(TextField,ValueField)  values('1 - Minimal Impairment',1)  
insert into @table(TextField,ValueField)  values('2 - Mild Impairment',2)  
insert into @table(TextField,ValueField)  values('3 - Moderate Impairment ',3)   
insert into @table(TextField,ValueField)  values('4 - Serious Impairment',4)  
insert into @table(TextField,ValueField)  values('5 - Severe Impairment',5 )  
 
  
  
select TextField,ValueField  from @table  
  
--Checking For Errors            
If (@@error!=0)           
  Begin            
  RAISERROR  20006  '[csp_SCGetSectionIIScore]: An Error Occured'               
  Return            
 End            
            
            
GO


