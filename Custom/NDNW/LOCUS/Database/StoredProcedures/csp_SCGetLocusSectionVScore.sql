     
/****** Object:  StoredProcedure [dbo].[csp_SCGetLocusSectionVScore]    Script Date: 12/02/2011 14:42:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetLocusSectionVScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetLocusSectionVScore]
GO

   
create  Procedure [dbo].[csp_SCGetLocusSectionVScore]            
                 
As            
/*********************************************************************/                            
/* Stored Procedure: dbo.[csp_SCGetLocusSectionVScore]             */                            
/* Creation Date:  12/02/2011                                              */                            
/*                                                                       */                            
/* Purpose: To Get bind the Section V Score List with  static values like  */                           
/*                                                                   */                          
/*                                                                   */                            
/* Output Parameters:                                */                            
/*                                                                   */                            
/*  Date                  Author                 Purpose          */                            
/* 12/02/2011             Rakesh Kumar -II               Created         */                            
/*********************************************************************/                     
            
    Declare @table table  
 (  
  TextField nvarchar(100),  
  ValueField int  
 )  
  
insert into @table(TextField,ValueField)  values('1 - Fully Responsive to Treatment and Recovery Management',1)  
insert into @table(TextField,ValueField)  values('2 - Significant Response to Treatment and Recovery Management',2)  
insert into @table(TextField,ValueField)  values('3 - Moderate or Equivocal Response to Treatment and Recovery Management',3)   
insert into @table(TextField,ValueField)  values('4 - Poor Response to Treatment and Recovery Management',4)  
insert into @table(TextField,ValueField)  values('5 - Negligible Response to Treatment',5 )  
 
  
  
select TextField,ValueField  from @table  
  
--Checking For Errors            
If (@@error!=0)           
  Begin            
  RAISERROR  20006  '[csp_SCGetLocusSectionVScore]: An Error Occured'               
  Return            
 End            
            
            
GO


