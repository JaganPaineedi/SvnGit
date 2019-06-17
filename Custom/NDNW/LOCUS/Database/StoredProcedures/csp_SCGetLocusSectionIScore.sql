
/****** Object:  StoredProcedure [dbo].[csp_SCGetLocusSectionIScore]    Script Date: 12/02/2011 14:42:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetLocusSectionIScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetLocusSectionIScore]
GO

   
create  Procedure [dbo].[csp_SCGetLocusSectionIScore]            
                 
As            
/*********************************************************************/                            
/* Stored Procedure: dbo.[csp_SCGetLocusSectionIScore]             */                            
/* Creation Date:  02-05-2014                                            */                            
/*                                                                       */                            
/* Purpose: To Get bind the Section I Score List with  static values like  */                           
/*                                                                   */                          
/*                                                                   */                            
/* Output Parameters:                                */                            
/*                                                                   */                            
/*  Date                  Author                 Purpose          */                            
/* 02-05-2014             Dhanil Manuel               Created         */                            
/*********************************************************************/                     
            
    Declare @table table  
 (  
  TextField nvarchar(100),  
  ValueField int  
 )  
  
insert into @table(TextField,ValueField)  values('1- Minimal risk of harm',1)  
insert into @table(TextField,ValueField)  values('2- Low risk of harm',2)  
insert into @table(TextField,ValueField)  values('3- Moderate risk of harm',3)   
insert into @table(TextField,ValueField)  values('4 - Serious risk of harm',4)  
insert into @table(TextField,ValueField)  values('5 - Extreme risk of harm',5 ) 
 
  
  
select TextField,ValueField  from @table  
  
--Checking For Errors            
If (@@error!=0)           
  Begin            
  RAISERROR  20006  '[csp_SCGetSectionIScore]: An Error Occured'               
  Return            
 End            
            
            
GO


