
-- Name : Sachin Borgave
-- Date : 21-06-2016

---Global CodeID 19800
IF  EXISTS(Select GlobalCodeId,CodeName from GlobalCodes where Category='SECURITYQUESTION' and CodeName='where did you and your spouse take your first trip?')
BEGIN
	UPDATE GlobalCodes set CodeName='Where did you and your spouse take your first trip?' where Category='SECURITYQUESTION' and CodeName='where did you and your spouse take your first trip?'
END


---Global CodeID 19802
IF  EXISTS(Select GlobalCodeId,CodeName from GlobalCodes where Category='SECURITYQUESTION' and  CodeName='where did you first meet your best friend?')
BEGIN
	UPDATE GlobalCodes set CodeName='Where did you first meet your best friend?' where Category='SECURITYQUESTION' and CodeName='where did you first meet your best friend?'
END


---Global CodeID 19803
IF  EXISTS(Select GlobalCodeId,CodeName from GlobalCodes where Category='SECURITYQUESTION' and CodeName='where did your spouse complete her undergraduate degree?')
BEGIN
	UPDATE GlobalCodes set CodeName='Where did your spouse complete her undergraduate degree?' where Category='SECURITYQUESTION' and CodeName='where did your spouse complete her undergraduate degree?'
END

---Global CodeID 19804
IF  EXISTS(Select GlobalCodeId,CodeName from GlobalCodes where Category='SECURITYQUESTION' and CodeName='where did your spouse complete her graduate degree?')
BEGIN
	UPDATE GlobalCodes set CodeName='Where did your spouse complete her graduate degree?' where Category='SECURITYQUESTION' and CodeName='where did your spouse complete her graduate degree?'
END


---Global CodeID 19787 -- Replaced with were
IF  EXISTS(Select GlobalCodeId,CodeName from GlobalCodes where Category='SECURITYQUESTION' and CodeName='In what city was your spouse/significant other born?')
BEGIN
	UPDATE GlobalCodes set CodeName='In what city were your spouse/significant other born?' where Category='SECURITYQUESTION' and CodeName='In what city was your spouse/significant other born?'
END