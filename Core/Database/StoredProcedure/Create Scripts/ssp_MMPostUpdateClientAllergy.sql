if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_MMPostUpdateClientAllergy]')
                    and type in ( N'P', N'PC' ) ) 
    drop procedure [dbo].[ssp_MMPostUpdateClientAllergy]
GO

set QUOTED_IDENTIFIER on
set ANSI_NULLS on
GO

create procedure [dbo].[ssp_MMPostUpdateClientAllergy]
    @ScreenKeyId int
  , @StaffId int
  , @CurrentUser varchar(30)
  , @CustomParameters xml
as /*********************************************************************************************************************/
/* Stored Procedure:  ssp_MMPostUpdateClientAllergy																		*/
/* Date            Author           Purpose																				*/
/* 06/11/2015	   Wasif Butt		Added as post update stored procedure called after insert/delete allergy from Rx.	*/
/************************************************************************************************************************/
    begin
        begin try
            if exists ( select  *
                        from    sys.objects
                        where   object_id = object_id(N'[scsp_MMPostUpdateClientAllergy]')
                                and type in ( N'P', N'PC' ) ) 
                begin 
                    exec scsp_MMPostUpdateClientAllergy @ScreenKeyId, @StaffId,
                        @CurrentUser, @CustomParameters 
                end
        end try
        begin catch
            declare @Error as varchar(max);
            set @Error = convert (varchar, error_number()) + '*****'
                + convert (varchar(4000), error_message()) + '*****'
                + isnull(convert (varchar, error_procedure()),
                         'ssp_MMPostUpdateClientAllergy') + '*****'
                + convert (varchar, error_line()) + '*****'
                + convert (varchar, error_severity()) + '*****'
                + convert (varchar, error_state());
            raiserror (@Error, 16, 1); -- Message text.                                                                                 Severity.                                                                                 State.                                                                                
        end catch
    end
GO
