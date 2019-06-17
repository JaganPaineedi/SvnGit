INSERT INTO dbo.GlobalCodeCategories (Category,
                                      CategoryName,
                                      Active,
                                      AllowAddDelete,
                                      AllowCodeNameEdit,
                                      AllowSortOrderEdit,
                                      Description,
                                      UserDefinedCategory,
                                      HasSubcodes,
                                      UsedInPracticeManagement,
                                      UsedInCareManagement)
SELECT 'WBPrecautions',
       'WBPrecautions',
       'Y',
       'Y',
       'Y',
       'Y',
       '',
       'N',
       'N',
       'N',
       'N'
 WHERE NOT EXISTS (SELECT *
                     FROM dbo.GlobalCodeCategories AS a
                    WHERE ISNULL(a.RecordDeleted, 'N') = 'N'
                      AND a.Category                   = 'WBPrecautions');
CREATE TABLE #Codes ( [Code] varchar(100), [SortOrder] int, [CodeName] varchar(250), [Bitmap] varchar(200), [BitmapImage] image )
INSERT INTO #Codes
VALUES
( 'F', 1, 'Falls', '87a31a61-7df8-4b83-8434-2313778f2f18', 0x47494638396119001b00f600000000000102040404040606060506080b0b0b0e0e0e1414141717171818181919191a1a1a1e1e1e2020202424242929292b2b2b3737373939393b3b3b3b3b3d3f3f3f4242424646464a4a4a5959595d5d5d6060606464646767676f70727373737a7a7a7f7f7f81828485858587888a8888888e8e8e9090909697999b9c9ea1a1a1a5a6a8a8a8a8b1b1b1b3b4b6b5b5b5b7b7b7b9b9b9bfbfbfc2c2c2c3c3c3c6c6c6c7c7c7c7c8cac9c9c9d1d1d1d4d4d4d9dadcdcdcdce2e2e2e6e6e6eaeaeaebeceeecedef00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021f904010000420021fe284564697465642077697468204c756e615069633a20687474703a2f2f6c756e617069632e636f6d2f002c0000000019001b000007c7804282838485868788898a8b8c832a0a00163f8d863d0500981f9485330003981685200f228b3f979e9a823a12980f8c2f0c000c20212326a8062f8dad98989f00123e893838822fbe9e9805258a38980d27b29f153331323c8b3c06c0979f0d832d268b3a1ddc000718983d3e179e0d318b41261635269f1a0703c0001b9439c90044c8e04b018b46c00634c856c381b2618b22045c218804010a946698fba460d321750180782c240240801b2309b908100045ca413b080048f172d00a0f226beadcc9536720003b ), 
( 'B', 2, 'Bleeding', '4bc93e5a-8705-4a61-a249-c71f6abb89a2', 0x4749463839611e001b00f700007c1317771b1c970b0c9b0e148816168d1318831a1e9f1610931c159f191695171bae0306a10d00aa070ca5090ab30304ba0300b00b07bd0b01b30a0baa1406b2190ba10c12a71716ad1416a41318ae1d189c221da2281db52212bd231cbc291f921e21be1d228c24248b353497303397393aad2225a32a22aa2828b12023bf2420b22921bb2821b5262aa33333ab3835ae3b38bf3034b3363ac40e01ca0b02c30c08dc0300d30b03d90a00d40a08db090ac51101cd1700cf1901c6140aca110ec31d0dda1606d41903dd1e04d2150cc31514cb1217c91d1bd91c16e20500e20806ec1906dd2003c62010c5211fd42716dc2216d02919d5321fe3270ced260eed290ce52614e52d15ed2913f62811cb2321c03c2dd93229bc403eb14b3c9c44419f5151ac4347a04847b24542bc4443a05655a75851ae5b53a75b5bab5c58b35855b4615cb75b60b56465b26b6da37577df4344d34e4fd65750d9625cc76562d96363cf756ccd7a76ec797cc0807ecb857dcf8680dd9b9ce18683e19389e68991ee8f95ff999cdfaca8e3a3a3e7acaef5a5a6ffafa9edafb2f9adb1e6b3b2e4bbb7ffc2bcffcdc9ffd2d2ffddd2ffd1d8ffdbdaffe3deffe4e3ffebe500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021f904010000940021fe284564697465642077697468204c756e615069633a20687474703a2f2f6c756e617069632e636f6d2f002c000000001e001b000008fe0029091c48b0a0c18308132a5cc8b0e14145901c369cf4e5ce24890a27f9397162d1458192de44c228d010870a1dbc381a286844219290c67c8822658b1d8191d4a0801151e221321e9a0071f24212a540298aa8e863d4212117071850b8e00252a3184672fcd8b048a2a4322210200000a8519d223a94e038d2a567c34879ccac41f4080f061a3692d8a0e1814e53af92fe98287203c7922c589eace8439212a330702004a142a54a952b5c363022b9678e132456864c6132640814167a48ae91a38508911e3c84080942e4c3998f0ec5c47152c3c78c1d3b68ecf0a1e10b6e8693dac808f140c20ce7122444489086241f112d263c80c01dc2040c05063391940406c485060bd23b1050804d634a90d0185030c042060201dcfc6d3ca84d091225b891c87b078d44e0810826a820820101003b ), 
( 'S', 3, 'Seizures', '5cecbe7d-4e8c-432f-a3ff-a2aaa88908f7', 0x47494638396117001800f60000b4783abd7a3bdd6d17da6c1dd6711fc5752ccc722ad67425dd7424d47924d2732bdc7329d37a2ed9792cc57432cd7634c57836cb7a34c6773cc9773dc27a3cd27734d47835dc7a32d17a38e36f22e27223e0762ab57e43bd7d44b57b49ad7c54c17b42c97c41bb814ec38044ca8248cc8b53d28b53e5994df19c4ce3995cfe9c53cc976fdc9662dda270d0a47de5a065e9a775edb179f1b27ab8a182d5aa8ad5ae91ceb29ae9b988f1b485feb982f3bf8dffc586ffcd80eec396fcc697ffd39ae7c4a4eccaacf0cfa2ffcca4ffd3a2ffdaace2c9b5ffdeb3fedcbfffe3b4ffe8b6ffe3bcffecbcf6dac4ffe4c0ffe2c8ffedcdfff2c7fff3ccffeed1ffefd9fff3d5fff9d4fff6dbfff9dbfff6e4fffae500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021f9040100005b0021fe284564697465642077697468204c756e615069633a20687474703a2f2f6c756e617069632e636f6d2f002c00000000170018000007fe805b82838485868788898a8b885a5858575457555655598c5b584b382c2420012630434f8b583d14180f060f0c160f201f8a5a371007071020222010110e1e978850010d02073b4a4e4c3f3222225a8948121b022a4a528f56524e33cf8848210b1907394952555790588a531e0a1a1a17150e2f3a475155dd87573d210a0b031910347030a2c5917c861c09111180c1020d08145cc0e0618aac2a5188c848e18001020208260401d6e88a4928517e9c3880e0010d92858cd89832058b232b4a7824b8552311100f2262fc6042f4078a040a3a34f1192042840000388888c02041881530096509220282030c4e0b1478ea828aac253e5a940810a04389181445aa30d242171da42a53ae60dacbb7afdf418100003b ), 
( 'BP', 4, 'Bulimia Protocol', 'a3b5a095-708f-4a0e-81b8-e2f1eb02ee0f', 0x47494638396115001700f60000be7d37ba753ebd7c3ad86d1dd6721ee2741ecd7327cc742bd57425d97624d47823d3752bda762ad37a2dd8782bc57735ca7631c57836cb7a34c27639c37a3ccc7c3ad67531d17932dc7c32bd7640b77842bc7b43ba7c49c37d42ce7c40dd8637d18b46d18551db9358dc985be3944fe69850eb9852e59c59e99d5dd09666d59a62da9b66e19f69dda165dea26ed2a274dba272d7a67be1a165e1a06aeaa86eefa671ffbb7bd2a784e8b081e8b588ecbc94f6c396fec791ffcd90ffd192ffd39bffdc9cf2cca7ffcca4ffd4a4ffd6acffdaa9ffd6b3ffdab4fedcbbffe6abffe7b4ffebb4ffe2beffebbdfff0bffcddc4ffe2c3ffeec2fde5cdffecccfff4cfffeed2ffeedefff4d4fff3dcfff8defff4e3fff8e500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021f9040100005c0021fe284564697465642077697468204c756e615069633a20687474703a2f2f6c756e617069632e636f6d2f002c00000000150017000007fe805c8283848586878889835a5b8a855a4f484c474c48504855598d88481c1a1d141415131e142a47885b471b1716080b170b0c0e171b4f875843000e0417273223120a0a123a58865945000a0926494a4a3606bd2f59c84402080827494d4e3c100e0f419b8458471dda253e3f3c221507135487aa1b09050908ad160b1f4053f48e6440806fc1010bfc1c8040526ed016231d180cf0458345880a060e686062e861000609502c6912a5490d0c081eece848644202052d9a5cc93265c8020510606829944b423e194da85089c2e300820a381a72d93224028204247afcf861e381810b138428e54284420307062a883a70a0428014000d1de1100116840a260f2a74d81063ca4e43526ec098b1c2455f18398e1c4b64454b162b581263b9eba8b163c78100003b ), 
( 'UI', 5, 'Urinary Incontinence', '7a4433fd-5f19-4ec1-9375-3e3d9c88666d', 0x47494638396118001600f60000b8763cbc7d3ecf7425cc752bcd792dd47326d97425d3762ad97529d4792cc57636cc7633c57a36cd7a33c87638c47b3dcc7a3bd17532d37933d07d39af7a48b47740b47b44bc7e43b47f4dba7a4cc27c44bc8045b6804aaf8356bb8654b0895ea58360dc8d4bc69364d69869d3a47de4aa7afcb67adaad86fcbe85fabe8ee4ba94e9b991f1bd95fbc28dffcc8feac096ebc39cf2c295f6c398e0c5a7eac8a3f8caa3ffd3abfdd7b4ffdab5f1d7bcffdcbcffe6b3ffebbef6ddc7ffeac4ffecccfff1cdffefd2fdedd9fff0d5fff4dcfff5e4fff9e600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021f904010000470021fe284564697465642077697468204c756e615069633a20687474703a2f2f6c756e617069632e636f6d2f002c00000000180016000007fe804782838485868746468782458b83433d38373f8446393a3a3d8e463318001e348d4746411f181420428b46341a0b0f31a24640160c0f1d438b45300c070a294482463e1b04041c9488300e080b2dc1a3c4c61b3ea285452c11cd29b23e17070700d58744d9dbd04540151202013cd085443212dbd63f160309eed68442e6ced0667130768187224345e619188022201000d37cc0abf402028208288008e3118040030c1a11bd508020818920a388ec604060008664868cdc605620c40f224480b8206080800894887e6890d0b3848d1b2e161c30c040c541443534e45be060c2800202166450e5e888101b00144c70b560c283113aba0a13e2a3c60912187057dc10f254ed912245880c2182d72ec25175fd0a2e1408003b ), 
( 'I', 6, 'Infection', 'f47f7d73-9721-409c-b5c7-dfb72a11d64e', 0x4749463839611d001b00f600000c0d0036353176794e6466656e6d69777463767e667173728c887da39f62bcb066cebe67e0c9798b8c90949597bcbb8da19ea5afaeb6b4b2b3b5bdb2b6b7bbd7c185d2c38cd0c396e3cf9ce2d591f8e599cec6a1cac4aae5d5a1e7d5afe4d5b4e0d7bafbe9abfaf3afbebdc2c3c3c3c7c9c3c8c9c1cbcccdd1cec9cfd4cedcd4c7ddd8c2d6d2cfdbd4cad9dccbcdcdd2d4d3d5d5dcd6daddd5d6dbdbe2dbc9e1ded6dde2dceae4ccfff2cffffbdddcdbe1dfe3e4eae7e2e4eae3eee9e6e3e4e9e3e9eaececeff2eee2ecf1ed00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021f904010000440021fe284564697465642077697468204c756e615069633a20687474703a2f2f6c756e617069632e636f6d2f002c000000001d001b000007ac804482838485868788898a88403b418b9082403f4430918b3d334411978a43294023443a82949d84273b10238f2932442ca78333243f112f353d442535b286122c3236448ebe84283526ba95c6822f362444310704422dcd3b2327311300001b392a3ecd44320602090a1938343ce42e0f220b0b1d39bde434171a0c151e35afe440580881e1030272835670b851208003848264281bd00062a117142ca2caa8d199a68e20438a1c49525120003b ), 
( 'O', 7, 'Other', '0f030e1c-945b-4412-82ec-a6d9f42ecddc', 0x47494638396119001900f60000be793cd7741fda721ee2731bcf7527cd752dca792dd37425da7724d27827d3752bda762ad37a28c57534cb7633c57a37cc7a33c87738c27a3dca7b3bd37630d17a32e07726bd7642b47d47bb7b43b57b4bb97f4dc27c41c97c41b8844bbf915fd78342d88a4adb904fcc8e55cc8a58d19455d6985de79c59e89a5ccf996bd49a68d59f71e29d66daa26fdba474daaa7aeaa267eaa772ebad7adaad84e6b28dedb789eeb98ff7b883f5bb8bfabe8ce8bb91eec29cfacb97f7c89aeec6a2f2c6a2ffcea2ffd6a4ffd3acfed5b3ffdcb5ffddbbffe2b6ffe4baffe2c6ffeac5ffebcbffedd4ffefdafff4d6fff2dcfff3e3fff9e400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021f904010000510021fe284564697465642077697468204c756e615069633a20687474703a2f2f6c756e617069632e636f6d2f002c00000000190019000007fe805182838485868788898a854e4c8e4c4e8b854f4f483b2e292b36424b92824b452d1c0e15200d11001a3f9d8b451910040510111110150e123491894b17140b05253c44402c0e16071342bb864f3e0e0b0a22474d8d4930020314244d884d1fb00f414a8350460402071c4588491e06061b4750844a270808133e4f87ae14052a94d02374a30081073ff8191a72810005174998457992838282083b14127a72040001062622126212e317468df532244820c1884425210e2c683004e5a0262f0c243080a3db272015021ce840eed01322122a5490d023c9122542001c0800410693444c7044b04801048a10100a242890a128a24a3524442840a10204032c10268c282211119322333c64e09001c3071d4aea2a72a2648810224a9638b1e9c989634f90234b9e4c997220003b )


INSERT INTO dbo.GlobalCodes (Category,
                             CodeName,
                             Code,
                             Description,
                             Active,
                             CannotModifyNameOrDelete,
                             SortOrder,
							 Bitmap,
							 BitmapImage)
SELECT 'WBPrecautions',
       a.CodeName,
       a.Code,
       '',
       'Y',
       'N',
       a.SortOrder,
	   a.Bitmap,
	   a.BitmapImage
  FROM #Codes AS a
 WHERE NOT EXISTS (SELECT 1
                     FROM dbo.GlobalCodes AS b
                    WHERE ISNULL(b.RecordDeleted, 'N') = 'N'
                      AND b.Category                   = 'WBPrecautions'
                      AND b.Code                       = a.Code);
DROP TABLE #Codes;
GO


