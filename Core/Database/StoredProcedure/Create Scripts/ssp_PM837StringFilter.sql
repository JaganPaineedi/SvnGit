IF OBJECT_ID('[ssp_PM837StringFilter]') IS NOT NULL
	DROP PROCEDURE [ssp_PM837StringFilter]
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ssp_PM837StringFilter] (@DataText varchar(1000),
@e_sep char(1), @se_sep char(1), @seg_term varchar(10), @DataTextOutput varchar(1000) output)
as
/*********************************************************************/
/* Stored Procedure: dbo.ssp_PM837StringFilter                         */
/* Creation Date:    1/14/03                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   *//* Input Parameters:	@DataText - 837 segment	*/
/*			@e_sep - element separator	*/
/*			@se_sep - sub element separator */
/*			@seg_term - segment terminator	*/
/*					     */
/*                                                                   */
/* Output Parameters:   837 segment                                            */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author      Purpose                                    */
/*  10/20/06   JHB	  Created                                    */
/*	08/07/13	dknewtson	Adding a replace statements for simple newlines.*/
/*	7/14/15	   dknewtson  Modified logic to remove carriage returns and line feeds:
						  replaced single replace statement with two.*/
/*********************************************************************/

-- Remove new line and carriage return
-- if segment terminator 
if (@seg_term <> char(13) + char(10)) and (@seg_term <> '~' + char(13) + char(10))
begin
	-- Remove newlines
	IF (@seg_term <> CHAR(10)) AND (@seg_term <> '~' + CHAR(10))
	BEGIN
		SET @DataTextOutput = REPLACE(@DataTextOutput,CHAR(10),' ')
	END
	-- Carriage Returns
	IF (@seg_term <> CHAR(13)) AND (@seg_term <> '~' + CHAR(13))
	BEGIN
		SET @DataTextOutput = REPLACE(@DataTextOutput,CHAR(13),' ')
	END 
END

-- Remove spaces from end of elements or sub elements and segments
while (patindex('% ' + @se_sep + '%', @DataTextOutput) <> 0)
begin
	set @DataTextOutput = replace(@DataTextOutput,' ' + @se_sep,@se_sep)
end

while (patindex('% ' + @e_sep + '%', @DataTextOutput) <> 0)
begin
	set @DataTextOutput = replace(@DataTextOutput,' ' + @e_sep,@e_sep)
end

while (patindex('% ' + @seg_term + '%', @DataTextOutput) <> 0)
begin
	set @DataTextOutput = replace(@DataTextOutput,' ' + @seg_term,@seg_term)
end

-- If sub elements are without data remove them
while (patindex('%' + @se_sep + @e_sep + '%', @DataTextOutput) <> 0)
begin
	set @DataTextOutput = replace(@DataTextOutput,@se_sep + @e_sep,@e_sep)
end

while (patindex('%' + @se_sep + @seg_term + '%', @DataTextOutput) <> 0)
begin
	set @DataTextOutput = replace(@DataTextOutput,@se_sep + @seg_term,@seg_term)
end

-- Remove elements without data
while (patindex('%' + @e_sep + @seg_term + '%', @DataTextOutput) <> 0)
begin
	set @DataTextOutput = replace(@DataTextOutput,@e_sep + @seg_term,@seg_term)
end
