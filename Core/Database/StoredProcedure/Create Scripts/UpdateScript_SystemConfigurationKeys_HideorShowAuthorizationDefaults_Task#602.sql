--Created By SuryaBalan on 6-July-2016, As per Krishna I have changed Sys Config Key from 'HideorShowAuthorizationCodes' to 'ShowAuthorizationCodes'
--Network 180 - Customizations #602 had released long back
update SystemConfigurationKeys set [Key]='ShowAuthorizationCodes' WHERE [Key]='HideorShowAuthorizationCodes'