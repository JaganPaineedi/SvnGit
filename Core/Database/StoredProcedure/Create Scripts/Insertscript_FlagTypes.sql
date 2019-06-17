
SET IDENTITY_INSERT [dbo].[FlagTypes] ON
	IF NOT EXISTS(SELECT 1 FROM FlagTypes WHERE FlagTypeId = 46861)
	BEGIN
		INSERT INTO [FlagTypes] (
			[FlagTypeId]
			,[FlagType]
			,[Active]
			,[NeverPopup]
			,[Bitmap]
			,[BitmapImage]
			)
		VALUES (
			46861
			,'Pended >12 days ago'
			,'Y'
			,'Y'
			,'bff4ebee-5e0e-4f17-b6bb-502c3d81dbdf'
			,0xFFD8FFE000104A46494600010101004800480000FFE1008C4578696600004D4D002A000000080007011A00050000000100000062011B0005000000010000006A012800030000000100020000013100020000001100000072511000010000000101000000511100040000000100000B13511200040000000100000B130000000000011948000003E800011948000003E87061696E742E6E657420342E302E31330000FFDB0043000201010201010202020202020202030503030303030604040305070607070706070708090B0908080A0807070A0D0A0A0B0C0C0C0C07090E0F0D0C0E0B0C0C0CFFDB004301020202030303060303060C0807080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0CFFC00011080012001203012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00B5FB787ED97F1ABE217C54D4747F1878B752B16D06E6E347BAD2B48964B0D3E3BAB399ED679044ADCACB242D3C66467610DC45F360E2AB78A3FE0A1BF13AF3E1D7C29FB278D35A487C0E63B7974EFB4B2C37571657026B79E50B8322989E18F0E4E4DBB9EF5F49FF00C14DBF608D4BE2DFFC151B48F0DE83358E971FC6ED397C456B7776DB208AFF004E8E2B3D5B0072F23590D265541C9FB2CE73C935E8DA97FC1BDFA4DDEAF67A5DBF8C2D6CFC2D01827B9BC5D39E4D72F2454659577B4BE4468CCC4AED8FE50A8087219DBF34CCB25CD258DAD2C35DC64D59F35B7D6DABD93D3D0FEB8E12F10B8369F0FE02966CA11AB494938AA77D629C399DA2F59A6A5DDBBF6B9F6F7C3AFDA9BC0FF117E1F683E2087C41A4DA43AF69D6FA8A413DDA2CB0ACD1AC8118678601B047A8A2BCFF0040FF008258FC0BD0342B2B15F03C374B650240269EFAE5A5942285DCE44801638C9C00327A0A2BEDE32CC795734617FF0013FF00E44FE77AD4B85DD493A756BA8DDDBF774F6E9FF2F0CEFDB8B4EB797F699FD956F1ADE16BCB5F88B771C33940648564F0F6AC1D55BA80C00040EB819AFA568A2BD43E3C28A28A00FFD9
			)
	END

	IF NOT EXISTS(SELECT 1 FROM FlagTypes WHERE FlagTypeId = 46862)
	BEGIN
		INSERT INTO [FlagTypes] (
			[FlagTypeId]
			,[FlagType]
			,[Active]
			,[NeverPopup]
			,[Bitmap]
			,[BitmapImage]
			)
		VALUES (
			46862
			,'Pended 10-12 days ago'
			,'Y'
			,'Y'
			,'144c98f4-a37f-4b21-b588-267b6652348e'
			,0xFFD8FFE000104A46494600010101004800480000FFE100AC4578696600004D4D002A000000080009011A0005000000010000007A011B0005000000010000008201280003000000010002000001310002000000110000008A03010005000000010000009C030300010000000100000000511000010000000101000000511100040000000100000B12511200040000000100000B12000000000001192F000003E80001192F000003E87061696E742E6E657420342E302E31330000000186A00000B18FFFDB0043000201010201010202020202020202030503030303030604040305070607070706070708090B0908080A0807070A0D0A0A0B0C0C0C0C07090E0F0D0C0E0B0C0C0CFFDB004301020202030303060303060C0807080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0CFFC00011080012001203012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F7EF8E3FB597C52F8A3AFDED878B3C417367A8787EF6EB42D4B4ED31DECEC92F2CA77B69A4588313B6568BCF8F7B3B08AE22E79AD1D77F6C0F1C5CF83BC03F67F136A6B1785F644F67E7911CF35B4DE6432C8072E0C6D126189E6163DEBBBFDB4FF655BED67FE0A9B0F86B4B92D74FB3F8EDA42F896CAE2E0ED863D534C8E2B2D50003EF48F63FD9522AF53F649CE7A9AF61BDFF008241E9F71A8DAD8C3E2282DF4188C52CD702CD9F54B970A448BB8BF94AACCC48C27CA02821882CDFCB1C53C07C5B3CF71B572B73952A8D5A4E76D24D4ECAED69069C7B256EF63FACB84F8FF83E190606966AA11AB4D4938AA77D629C399DA2F59A6A5DDBBF6B9F507837E3C785FC63E10D2B588F58D3EDE3D56CE1BC58A5B850F18910385619E08CE0FBD15C8E93FB07FC2BD274AB5B51E178E716B12442496EE63249B401B988703271938039A2BF7BA357895538AA94E873595FDF9EFD7FE5D9FCF75A970C3A9274EAD751BBB7EEE1B74FF978713FB7169D6F2FED33FB2ADE35BC2D796BF116EE3867280C90AC9E1ED583AAB7501800081D70335F4AD1457D61F22145145007FFD9
			)
	END
SET IDENTITY_INSERT [dbo].[FlagTypes] OFF