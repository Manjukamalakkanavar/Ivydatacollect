USE [IvyDataCollect]
GO
/****** Object:  Table [dbo].[TB_Fall_Application_Dates]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_Fall_Application_Dates](
	[Fall_Application_id] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedByID] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[UniversityID] [int] NOT NULL,
	[ApplicantType] [int] NOT NULL,
	[Admission_Deadline] [varchar](50) NULL,
	[Admission_Notification] [varchar](50) NULL,
	[Admission_Deposit_Deadline] [varchar](50) NULL,
	[Admission_Offer] [varchar](50) NULL,
	[Admission_WaitingListUsed] [varchar](50) NULL,
	[Defer_Admission] [varchar](50) NULL,
	[Transfer_Admission] [varchar](50) NULL,
	[Application_Deadline] [varchar](50) NULL,
	[Admission_Notes] [varchar](500) NULL,
	[Data_URL] [varchar](500) NULL,
	[Fall_Status] [varchar](50) NULL,
	[Fall_Comments] [varchar](500) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[TB_Fall_Application_Dates] ON
INSERT [dbo].[TB_Fall_Application_Dates] ([Fall_Application_id], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UniversityID], [ApplicantType], [Admission_Deadline], [Admission_Notification], [Admission_Deposit_Deadline], [Admission_Offer], [Admission_WaitingListUsed], [Defer_Admission], [Transfer_Admission], [Application_Deadline], [Admission_Notes], [Data_URL], [Fall_Status], [Fall_Comments]) VALUES (11, CAST(0x0000A44A00D81A7C AS DateTime), 1, CAST(0x0000A44A00D81A7C AS DateTime), 450705, 1, N'11-Feb', N'12-Feb', N'10-Feb', N'17-Feb', N'', N'', N'', N'', N'', N'', N'Process', N'')
INSERT [dbo].[TB_Fall_Application_Dates] ([Fall_Application_id], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UniversityID], [ApplicantType], [Admission_Deadline], [Admission_Notification], [Admission_Deposit_Deadline], [Admission_Offer], [Admission_WaitingListUsed], [Defer_Admission], [Transfer_Admission], [Application_Deadline], [Admission_Notes], [Data_URL], [Fall_Status], [Fall_Comments]) VALUES (12, CAST(0x0000A44A00D81A7C AS DateTime), 1, CAST(0x0000A44A00D81A7C AS DateTime), 450705, 1, N'09-Feb', N'02-Feb', N'09-Feb', N'01-Feb', N'', N'', N'', N'', N'', N'', N'Process', N'')
SET IDENTITY_INSERT [dbo].[TB_Fall_Application_Dates] OFF
/****** Object:  StoredProcedure [dbo].[ivyp_DoLogin]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[ivyp_DoLogin](@UserID nvarchar(100), @Pwd nvarchar(250))
as begin
  if exists(select 1 from [dbo].[ivyt_Accounts] where [EmailAddress] = @UserID and Pwd = @Pwd)
	return 0
   else
     RAISERROR (N'Login filed for user id: %s', -- Message text.
           16, -- Severity,
           1, -- State,
           @UserID, -- First argument.
           null)
end
GO
/****** Object:  Table [dbo].[ivyt_UserRoleTypes]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ivyt_UserRoleTypes](
	[UserRoleTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_ivyt_UserRoleType] PRIMARY KEY CLUSTERED 
(
	[UserRoleTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ivyt_UserRoleTypes] ON
INSERT [dbo].[ivyt_UserRoleTypes] ([UserRoleTypeID], [Name], [Description]) VALUES (1, N'DataManager', N'Review and accept or reject data, assgin school to operator')
INSERT [dbo].[ivyt_UserRoleTypes] ([UserRoleTypeID], [Name], [Description]) VALUES (2, N'DataEntry', N'Entering data, collect data from public sites etc')
INSERT [dbo].[ivyt_UserRoleTypes] ([UserRoleTypeID], [Name], [Description]) VALUES (3, N'DataVerify', N'Verify data already in the database')
SET IDENTITY_INSERT [dbo].[ivyt_UserRoleTypes] OFF
/****** Object:  StoredProcedure [dbo].[ivyp_Assign]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--assing or reassing unit to operator or verification person
CREATE procedure [dbo].[ivyp_Assign](@IDList varchar(4000), @userID int)
as begin

  declare @sql nvarchar(4000)
  --get user type
  declare @userType nvarchar(100)
  select @userType = [RoleType] from [dbo].[ivyt_UserRoleType] a, [dbo].[ivyt_Accounts] b where b.AccountID = @userID and b.RoleTypeID = a.RoleTypeID
  --update existing
  if @userType = 'DataEntry'
  begin
	  set @sql = 'update  a
	  set OperatorID = ' + cast(@userID as nvarchar) +
	  ' CollectorAssignDate= getDate()  from [dbo].[ivyt_DataCollect_School_assignment] a
	  where UnitID in ('+@IDList+')'

	  EXEC(@sql)
  end
  else  if @userType = 'DataEverify'
  begin

	   set @sql = 'update  a
	  set VerifiedByID = ' + cast(@userID as nvarchar) +
	  ' VerifiedAssignDate =getDate() from [dbo].[ivyt_DataCollect_School_assignment] a
	  where UnitID in ('+@IDList+')'

	  EXEC(@sql)
  end

  --assign new (for data entry only since DataEverify will never have record before data entry
   set @sql = 'insert into [dbo].[ivyt_DataCollect_School_assignment]([UnitID], [OperatorID], CollectorAssignDate)
	  select UnitID, ' + cast(@userID as nvarchar)  +
	  ' , getDate() from  [dbo].[ivyt_hd] a
	   where UnitID in ('+@IDList+') where UnitID not in (select UnitID from [dbo].[ivyt_DataCollect_School_assignment])'
	EXEC(@sql)

end
GO
/****** Object:  Table [dbo].[ivyt_Universities]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ivyt_Universities](
	[UniversityID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](6) NOT NULL,
	[Name] [nvarchar](120) NOT NULL,
	[Address] [nvarchar](100) NULL,
	[City] [nvarchar](30) NULL,
	[StateCode] [nvarchar](2) NULL,
	[Zip] [nvarchar](10) NULL,
	[WebAddress] [nvarchar](150) NULL,
	[AdminUrl] [nvarchar](200) NULL,
	[FaidUrl] [nvarchar](200) NULL,
	[ApplUrl] [nvarchar](200) NULL,
	[NpricUrl] [nvarchar](200) NULL,
 CONSTRAINT [primary_key_hd_UNITID] PRIMARY KEY CLUSTERED 
(
	[UniversityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ivyt_Universities] ON
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450703, N'219578', N'Aquinas College', N'4210 Harding Pike', N'Nashville', N'TN', N'37205', N'www.aquinascollege.edu', N'www.aquinascollege.edu/admissions/index.php', N'www.aquinascollege.edu/admissions/finaid/index.php', N'www.aquinascollege.edu/admissions/online-application.php', N'www.aquinascollege.edu/admissions/finaid/index.php')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450704, N'219587', N'Arnolds Beauty School', N'1179 S Second St', N'Milan', N'TN', N'38358', N'arnoldsbeautyschool.com', NULL, NULL, NULL, N'arnoldsbeautyschool.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450705, N'219596', N'Tennessee Technology Center at Athens', N'1635 Vo Tech Dr', N'Athens', N'TN', N'37371-0848', N'www.ttcathens.edu', NULL, NULL, NULL, N'www.ttcathens.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450706, N'219602', N'Austin Peay State University', N'601 College St', N'Clarksville', N'TN', N'37044', N'www.apsu.edu', N'www.apsu.edu/admissions/', N'www.apsu.edu/financialaid/', N'www.apsu.edu/admissions/', N'www.apsu.edu/financialaid')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450707, N'219639', N'Baptist Memorial College of Health Sciences', N'1003 Monroe Ave', N'Memphis', N'TN', N'38104', N'www.bchs.edu', N'www.bchs.edu', N'www.bchs.edu', N'www.bchs.edu', N'www.bchs.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450708, N'219709', N'Belmont University', N'1900 Belmont Blvd', N'Nashville', N'TN', N'37212-3757', N'www.belmont.edu', N'www.belmont.edu/prospectivestudents', N'www.belmont.edu/sfs/undergrad/index.html', N'www.xap.com/applications/Belmont_University/apply.html', N'belmont.studentaidcalculator.com/survey.aspx')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450709, N'219718', N'Bethel University', N'325 Cherry Ave', N'McKenzie', N'TN', N'38201', N'www.bethelu.edu/', N'www.bethelu.edu/admissions', N'www.bethelu.edu/fa', N'secure.sitemason.com/www.bethelu.edu/admission/application', N'www.bethelu.edu/fa_calc/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450710, N'219790', N'Bryan College-Dayton', N'721 Bryan Drive', N'Dayton', N'TN', N'37321-7000', N'www.bryan.edu', N'www.bryan.edu/climb-higher', N'www.bryan.edu/financial_aid', N'https://apply.bryan.edu/', N'www.bryan.edu/aid_estimator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450711, N'219806', N'Carson-Newman University', N'1646 S Russell Ave', N'Jefferson City', N'TN', N'37760', N'www.cn.edu', N'admissions.cn.edu/', N'admissions.cn.edu/admissions/finaid/default.asp', N'admissions.cn.edu/', N'www.cn.edu/administration/financial-assistance/net-price-calculator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450712, N'219824', N'Chattanooga State Community College', N'4501 Amnicola Hwy', N'Chattanooga', N'TN', N'37406-1097', N'www.chattanoogastate.edu', N'www.chattanoogastate.edu/admissions/', N'www.chattanoogastate.edu/financial/financial-aid/', N'www.chattanoogastate.edu/admissions/apply/', N'www.chattanoogastate.edu/financial/financial-aid/netpricecalculator/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450713, N'219833', N'Christian Brothers University', N'650 East Parkway South', N'Memphis', N'TN', N'38104', N'www.cbu.edu', N'www.cbu.edu/admissions/home.html', N'www.cbu.edu/financialassistance/overview.html', N'https://cbu-uga.edu.185r.net/application/login/', N'tcc.noellevitz.com/%28S%281mqz3yc2uiceq3jjcgxxsyjh%29%29/Christian%20Brothers%20Unihl%29%29/Christian%20Brothers%20University/Freshman-Students')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450714, N'219842', N'Pentecostal Theological Seminary', N'900 Walker St NE', N'Cleveland', N'TN', N'37320-3330', N'www.ptseminary.edu/', N'www.ptseminary.edu/appform.html', N'finaid.ptseminary.edu/', N'www.ptseminary.edu/appform.html', NULL)
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450715, N'219879', N'Cleveland State Community College', N'3535 Adkisson Drive', N'Cleveland', N'TN', N'37312', N'www.clevelandstatecc.edu', N'www.clevelandstatecc.edu/admissions/', N'www.clevelandstatecc.edu/admissions/financial-aid-scholarships-overview', N'www.clevelandstatecc.edu/PROD/bwskalog.P_DispLoginNon', N'www.clevelandstatecc.edu/npcalc.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450716, N'219888', N'Columbia State Community College', N'1665 Hampshire Pike', N'Columbia', N'TN', N'38401', N'www.columbiastate.edu', N'www.columbiastate.edu/Admissions', N'www.columbiastate.edu/financial-aid', N'www.columbiastate.edu//how-to-apply', N'www.columbiastate.edu/IR/NetPriceCalc/NetPriceCalculator/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450717, N'219903', N'Concorde Career College-Memphis', N'5100 Poplar Avenue, Suite 132', N'Memphis', N'TN', N'38137-0132', N'www.concorde.edu', N'www.concorde.edu/', N'www.concorde.edu/', N'www.concorde.edu/', N'www.concorde.edu/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450718, N'219921', N'Tennessee Technology Center at Covington', N'1600 Hwy 51 South', N'Covington', N'TN', N'38019', N'www.ttccovington.edu', N'www.ttccovington.edu', N'www.ttccovington.edu', NULL, N'www.ttccovington.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450719, N'219949', N'Cumberland University', N'1 Cumberland Square', N'Lebanon', N'TN', N'37087', N'www.cumberland.edu', N'www.cumberland.edu/', N'www.cumberland.edu/financial_aid', N'https://charlie.cumberland.edu/eapplication/login.asp', N'www.cumberland.edu/admissions/tuition_and_fees')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450720, N'219976', N'Lipscomb University', N'One University Park Drive', N'Nashville', N'TN', N'37204-3951', N'www.lipscomb.edu', N'www.golipscomb.com', N'financialaid.lipscomb.edu', N'https://www.commonapp.org/CommonApp/default.aspx', N'www.lipscomb.edu/financialaid/Page/Index/10729')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450721, N'219994', N'Tennessee Technology Center at Dickson', N'740 Hwy 46', N'Dickson', N'TN', N'37055', N'www.ttcdickson.edu', NULL, NULL, NULL, N'www.ttcdickson.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450722, N'220002', N'Daymar Institute-Nashville', N'340 Plus Park Blvd', N'Nashville', N'TN', N'37217', N'www.daymarinstitute.edu', NULL, NULL, NULL, N'daymarinstitute.studentaidcalculator.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450723, N'220057', N'Dyersburg State Community College', N'1510 Lake Rd', N'Dyersburg', N'TN', N'38024-2411', N'www.dscc.edu', N'www.dscc.edu/admissions', N'www.dscc.edu/paying%20for%20college', N'https://www.dscc.edu/admissions/how%20to%20apply', N'www.dscc.edu/paying%20for%20college/what%20it%20costs/net%20price%20calculator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450724, N'220075', N'East Tennessee State University', N'807 University Pky', N'Johnson City', N'TN', N'37614-0000', N'www.etsu.edu', N'www.etsu.edu/admissions/', N'www.etsu.edu/finaid/', N'https://selfserv.etsu.edu/pls/PROD/bwskalog.P_DispLoginNon', N'www.etsu.edu/finaid/netpricecalc.aspx')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450725, N'220118', N'Chattanooga College Medical Dental and Technical Careers', N'3805 Brainerd Rd', N'Chattanooga', N'TN', N'37411-3742', N'www.chattanoogacollege.edu', N'www.chattanoogacollege.edu', N'www.chattanoogacollege.edu', NULL, N'www.chattanoogacollege.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450726, N'220127', N'Tennessee Technology Center at Elizabethton', N'426 Highway 91', N'Elizabethton', N'TN', N'37643', N'www.ttcelizabethton.edu', N'www.ttcelizabethton.edu', N'www.ttcelizabethton.edu', N'www.ttcelizabethton.edu', N'www.ttcelizabethton.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450727, N'220136', N'Emmanuel Christian Seminary', N'One Walker Dr', N'Johnson City', N'TN', N'37601-9989', N'www.ecs.edu', N'admissions.ecs.edu/Admissions/Home.aspx', N'admissions.ecs.edu/admissions/FinancialAid.aspx', N'apply.ecs.edu/Login.aspx', NULL)
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450728, N'220163', N'Fayetteville College of Cosmetology Arts and Sciences', N'201 West College Street', N'Fayetteville', N'TN', N'37334-0135', N'www.fayettevillecollegeofcosmetologyartsandsciences.com', NULL, NULL, NULL, N'www.fayettevillecollegeofcosmetologyartsandsciences.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450729, N'220181', N'Fisk University', N'1000 17th Ave North', N'Nashville', N'TN', N'37208-4501', N'www.fisk.edu', N'www.fisk.edu/Admission.aspx', N'www.fisk.edu/FinancialAid.aspx', N'www.collegefortn.org/Applications/HBCU/apply.html?application_id=2492', N'www.fisk.edu/netprice/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450730, N'220206', N'Welch College', N'3606 West End Ave', N'Nashville', N'TN', N'37205-0117', N'WWW.FWBBC.EDU', NULL, NULL, NULL, N'www.fwbbc.edu/NetPriceCalculator/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450731, N'220215', N'Freed-Hardeman University', N'158 E Main St', N'Henderson', N'TN', N'38340-2399', N'www.fhu.edu', N'www.fhu.edu/admissions', N'www.fhu.edu/admissions/tuition', N'https://www.fhu.edu/admissions/apply', N'www.fhu.edu/admissions/tuition/FinancialAidEstimator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450732, N'220251', N'Tennessee Technology Center at Harriman', N'1745 Harriman Highway', N'Harriman', N'TN', N'37748-5849', N'www.ttcharriman.edu', N'www.ttcharriman.edu', N'www.ttcharriman.edu/financial-aid', N'www.ttcharriman.edu/admissions', N'www.ttcharriman.edu/sites/default/files/harriman/npc/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450733, N'220279', N'Tennessee Technology Center at Hartsville', N'716 McMurry Blvd', N'Hartsville', N'TN', N'37074-2028', N'www.ttchartsville.edu', NULL, NULL, NULL, N'www.ttchartsville.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450734, N'220312', N'Hiwassee College', N'225 Hiwassee College Drive', N'Madisonville', N'TN', N'37354-4001', N'www.hiwassee.edu', N'hiwassee.edu/admissions/', N'hiwassee.edu/affordability/financial-aid/', N'hiwassee.edu/admissions/apply-now/', N'hiwassee.edu/netpricecalculator/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450735, N'220321', N'Tennessee Technology Center at Hohenwald', N'813 West Main', N'Hohenwald', N'TN', N'38462-2201', N'www.ttchohenwald.edu', N'www.ttchohenwald.edu', N'www.ttchohenwald.edu', N'www.ttchohenwald.edu', N'www.ttchohenwald.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450736, N'220394', N'Tennessee Technology Center at Jacksboro', N'265 Elkins Rd', N'Jacksboro', N'TN', N'37757', N'www.ttcjacksboro.edu/', N'www.ttcjacksboro.edu', N'www.ttcjacksboro.edu', N'www.ttcjacksboro.edu', N'www.ttcjacksboro.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450737, N'220400', N'Jackson State Community College', N'2046 North Pky', N'Jackson', N'TN', N'38301-3797', N'www.jscc.edu', N'www.jscc.edu/admissions/', N'www.jscc.edu/financial-aid/', N'www.jscc.edu/admissions/apply.html', N'www.jscc.edu/calculator/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450738, N'220464', N'John A Gupton College', N'1616 Church St', N'Nashville', N'TN', N'37203-2954', N'www.guptoncollege.edu', NULL, NULL, NULL, N'www.guptoncollege.com/netprice/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450739, N'220473', N'Johnson University', N'7900 Johnson Dr', N'Knoxville', N'TN', N'37998', N'www.johnsonu.edu', N'www.johnsonu.edu/Admissions.aspx', N'www.johnsonu.edu/Admissions/Financial-Aid-(1).aspx', N'www.johnsonu.edu/Admissions/Apply.aspx', N'www.johnsonu.edu/NetPriceCalculator/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450740, N'220491', N'Paul Mitchell the School-Nashville', N'5510 Crossings Circle', N'Antioch', N'TN', N'37013', N'www.paulmitchelltheschool.com', NULL, NULL, NULL, N'school.paulmitchell.edu/nashville-tn/programs')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450741, N'220516', N'King College', N'1350 King College Rd', N'Bristol', N'TN', N'37620-2699', N'www.king.edu', N'admissions.king.edu', N'financialaid.king.edu', N'apply.king.edu', N'npc.collegeboard.org/student/app/king')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450742, N'220552', N'South College', N'3904 Lonas Road', N'Knoxville', N'TN', N'37909-0000', N'www.southcollegetn.edu', N'www.southcollegetn.edu', N'www.southcollegetn.edu', N'www.southcollegetn.edu', N'www.southcollegetn.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450743, N'220570', N'Knoxville Institute of Hair Design', N'1221 N Central Street', N'Knoxville', N'TN', N'37917', N'kihd.net', N'kihd.net', NULL, NULL, N'kihd.net')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450744, N'220598', N'Lane College', N'545 Lane Ave', N'Jackson', N'TN', N'38301-4598', N'www.lanecollege.edu', NULL, NULL, NULL, N'www.lanecollege.edu/lanepage2.asp?id=050002035')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450745, N'220604', N'Le Moyne-Owen College', N'807 Walker Ave', N'Memphis', N'TN', N'38126-6595', N'www.loc.edu', N'www.loc.edu/enrollment-management/admission-recruitment.asp', N'www.loc.edu/financial-aid/default.asp', N'www.loc.edu/SelfService/Admissions/Application.aspx?applicationformid=1', N'www.loc.edu/financial-aid/calculator/net-price-calculator-home.asp')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450746, N'220613', N'Lee University', N'1120 N Ocoee St', N'Cleveland', N'TN', N'37311', N'www.leeuniversity.edu', N'prospects.leeuniversity.edu', N'www.leeuniversity.edu/financial-aid', N'secure.collegefortn.org/College_Planning/Applications_and_Transcripts/Apply_to_College/Apply_to_College.aspx', N'npc.collegeboard.org/student/app/lee')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450747, N'220631', N'Lincoln Memorial University', N'6965 Cumberland Gap Pky', N'Harrogate', N'TN', N'37752-9900', N'www.lmunet.edu', N'www.lmunet.edu/admissions/index.html', N'www.lmunet.edu/admissions/finaid.html', N'lmu1.lmunet.edu/admissions/apply/new_apply2.html', N'www.lmunet.edu/admissions/finaid.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450748, N'220640', N'Tennessee Technology Center at Livingston', N'740 High Tech Dr', N'Livingston', N'TN', N'38570', N'www.ttclivingston.edu', N'www.ttclivingston.edu', N'www.ttclivingston.edu', N'www.ttclivingston.edu', N'ttclivingston.edu/sites/default/files/livingston/npc/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450749, N'220701', N'Martin Methodist College', N'433 West Madison Street', N'Pulaski', N'TN', N'38478-2799', N'www.martinmethodist.edu', N'www.martinmethodist.edu/admissions', N'www.martinmethodist.edu/financial-aid', N'https://mmcweb.martinmethodist.edu/mmcadmin/app/', N'mmcweb.martinmethodist.edu/mmcadmin/npc/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450750, N'220710', N'Maryville College', N'502 E Lamar Alexander Pky', N'Maryville', N'TN', N'37804-5907', N'www.maryvillecollege.edu', N'maryvillecollege.edu/admissions', N'www.maryvillecollege.edu/admissions/finaid/', N'www.maryvillecollege.edu/admissions/apply/', N'www.maryvillecollege.edu/admissions/finaid/net-price-calculator/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450751, N'220756', N'Tennessee Technology Center at McKenzie', N'16940 Highland Dr', N'McKenzie', N'TN', N'38201', N'www.ttcmckenzie.edu', N'www.ttcmckenzie.edu/student-services', N'www.ttcmckenzie.edu/financial-aid', NULL, N'www.ttcmckenzie.edu/sites/default/files/mckenzie/npc/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450752, N'220765', N'Genesis Career College', N'880-A East 10th Street', N'Cookeville', N'TN', N'38501-1907', N'www.genesiscareer.edu', N'www.genesiscareer.edu', N'www.genesiscareer.edu/financial-aid/', N'www.genesiscareer.edu/apply-today/', N'www.genesiscareer.edu/NetPriceCalculator/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450753, N'220792', N'Meharry Medical College', N'1005 DB Todd Blvd.', N'Nashville', N'TN', N'37208', N'www.mmc.edu', N'www.mmc.edu/prospectivestudents/admissions/index.html', N'www.mmc.edu/prospectivestudents/financial-aid/index.html', N'www.mmc.edu/prospectivestudents/admissions/index.html', NULL)
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450754, N'220808', N'Memphis College of Art', N'1930 Poplar Ave', N'Memphis', N'TN', N'38104-2764', N'www.mca.edu', N'www.mca.edu', N'www.mca.edu', N'www.mca.edu', N'www.mca.edu/admissions/financial-aid/net-price-calculator/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450755, N'220853', N'Tennessee Technology Center at Memphis', N'550 Alabama Ave', N'Memphis', N'TN', N'38105-3604', N'www.ttcmemphis.edu', NULL, NULL, NULL, N'www.ttcmemphis.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450756, N'220862', N'University of Memphis', N'Southern Avenue', N'Memphis', N'TN', N'38152', N'www.memphis.edu', N'www.memphis.edu/admissions/', N'www.memphis.edu/financialaid/', N'collegefortn.org/applications/university_of_Memphis/apply.html', N'www.collegeportraits.org/TN/UofM/estimator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450757, N'220871', N'Memphis Theological Seminary', N'168 East Parkway South', N'Memphis', N'TN', N'38104-4395', N'www.memphisseminary.edu/', NULL, NULL, NULL, N'www.memphisseminary.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450758, N'220941', N'Victory University', N'255 N Highland', N'Memphis', N'TN', N'38111-1375', N'www.victory.edu', N'www.victory.edu/admissions/', N'www.victory.edu/admissions/financial-aid/', N'portal.victory.edu/public/apply.php', N'www.victory.edu/admissions/net-price-calculator/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450759, N'220978', N'Middle Tennessee State University', N'1301 East Main Street', N'Murfreesboro', N'TN', N'37132', N'www.mtsu.edu', N'www.mtsu.edu/admissn/', N'www.mtsu.edu/admissn/fin_admissn.php', N'www.mtsu.edu/applynow/', N'www.mtsu.edu/financialaid/npcalc/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450760, N'220996', N'Middle Tennessee School of Anesthesia Inc', N'315 Hospital Drive', N'Madison', N'TN', N'37115', N'www.MTSA.edu', NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450761, N'221014', N'Milligan College', N'1 Blowers Blvd.', N'Milligan College', N'TN', N'37682', N'www.milligan.edu', N'www.milligan.edu/admission/index.html', N'www.milligan.edu/sfs/index.html', N'https://www.applyweb.com/apply/millgn/index.html', N'www.milligan.edu/SFS/costs.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450762, N'221050', N'Tennessee Technology Center at Morristown', N'821 W Louise Ave', N'Morristown', N'TN', N'37813-2094', N'www.ttcmorristown.edu', N'www.ttcmorristown.edu', N'www.ttcmorristown.edu', N'www.ttcmorristown.edu', N'www.ttcmorristown.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450763, N'221096', N'Motlow State Community College', N'6015 Ledford Mill Road', N'Tullahoma', N'TN', N'37388', N'www.mscc.edu', N'www.mscc.edu/admissions', N'www.mscc.edu/financialaid', N'www.collegefortn.org/applications/Motlow_State_Community_College/apply.html?application_id=3596', N'www.mscc.edu/financialaid/netpricecalculator/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450764, N'221102', N'Tennessee Technology Center at Murfreesboro', N'1303 Old Fort Pky', N'Murfreesboro', N'TN', N'37129-3311', N'www.ttcmurfreesboro.edu', N'www.ttcmurfreesboro.edu/admissions', N'www.ttcmurfreesboro.edu/financial-aid', N'www.ttcmurfreesboro.edu/admissions', N'www.ttcmurfreesboro.edu/sites/default/files/murfreesboro/npc/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450765, N'221148', N'Nashville Auto Diesel College', N'1524 Gallatin Rd', N'Nashville', N'TN', N'37206', N'www.nadcedu.com', N'www.nadcedu.com', N'www.nadcedu.com', N'https://adm064.lincolnedu.com/admissions/manageOA.do?school=Online', N'www.lincolnedu.com/net-price-calculator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450766, N'221157', N'Nashville College of Medical Careers', N'1556 Crestview Dr', N'Madison', N'TN', N'37115', N'www.Nashvillecollege.com', N'www.nashvillecollege.com/page2.html', N'www.nashvillecollege.com/page2.html', NULL, N'www.nashvillecollege.com/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450767, N'221184', N'Nashville State Community College', N'120 White Bridge Rd', N'Nashville', N'TN', N'37209-4515', N'www.nscc.edu', N'www.nscc.edu/admissions/', N'www.nscc.edu/admissions/financial-aid/', N'www.nscc.edu/admissions/apply-to-nscc/', N'www.nscc.edu/consumer-information/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450768, N'221236', N'Tennessee Technology Center at Newbern', N'340 Washington St', N'Newbern', N'TN', N'38059', N'www.ttcnewbern.edu', N'www.ttcnewbern.edu', N'www.ttcnewbern.edu', N'www.ttcnewbern.edu', N'www.ttcnewbern.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450769, N'221254', N'O''More College of Design', N'423 S Margin St', N'Franklin', N'TN', N'37064', N'www.omorecollege.edu', N'www.omorecollege.edu', N'www.omorecollege.edu', N'www.omorecollege.edu', N'www.omorecollege.edu/content/netpricecalculator.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450770, N'221281', N'Tennessee Technology Center at Paris', N'312 S Wilson Street', N'Paris', N'TN', N'38242', N'www.ttcparis.edu', NULL, NULL, NULL, N'www.ttcparis.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450771, N'221290', N'Plaza Beauty School', N'4682 Spottswood Ave', N'Memphis', N'TN', N'38117-4822', N'www.plazabeautyschool.com', N'www.plazabeautyschool.com', N'www.plazabeautyschool.com', N'www.plazabeautyschool.com', N'www.plazabeautyschool.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450772, N'221333', N'Tennessee Technology Center at Pulaski', N'1233 E College St', N'Pulaski', N'TN', N'38478-0614', N'www.ttcpulaski.edu', N'www.ttcpulaski.edu/admissions', N'www.ttcpulaski.edu/financial-aid', N'www.ttcpulaski.edu', N'ttcpulaski.edu/sites/default/files/pulaski/npc/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450773, N'221351', N'Rhodes College', N'2000 North Parkway', N'Memphis', N'TN', N'38112-1690', N'www.rhodes.edu', N'www.rhodes.edu/admission/', N'www.rhodes.edu/finaid/', N'apply.rhodes.edu/', N'npc.collegeboard.org/student/app/rhodes')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450774, N'221388', N'Tennessee Technology Center at Ripley', N'127 Industrial Drive', N'Ripley', N'TN', N'38063', N'www.ttcripley.edu', N'ttcripley.edu/admissions', N'ttcripley.edu/financial-aid', N'ttcripley.edu/application-procedure', N'ttcripley.edu/netpricecalculator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450775, N'221397', N'Roane State Community College', N'276 Patton Lane', N'Harriman', N'TN', N'37748', N'www.roanestate.edu', N'www.roanestate.edu/?5355-Admissions-Office', N'www.roanestate.edu/?5357-Financial-Aid', N'www.roanestate.edu/?6958-Admissions-Apply-Now', N'www.roanestate.edu/fa/netPriceCalculator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450776, N'221430', N'Tennessee Technology Center at Crump', N'3070 Hwy. 64 West', N'Crump', N'TN', N'38327', N'www.ttccrump.edu', N'www.ttccrump.edu', N'www.ttccrump.edu', N'www.ttccrump.edu', N'www.ttccrump.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450777, N'221485', N'Southwest Tennessee Community College', N'737 Union Avenue', N'Memphis', N'TN', N'38103', N'www.southwest.tn.edu', N'www.southwest.tn.edu/admissions/', N'www.southwest.tn.edu/financial_aid/', N'www.collegefortn.org/applications/Southwest_Tennessee_CC/apply.html', N'apps.southwest.tn.edu/NetPrice/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450778, N'221494', N'Tennessee Technology Center at Shelbyville', N'1405 Madison St', N'Shelbyville', N'TN', N'37160', N'www.ttcshelbyville.edu', NULL, NULL, NULL, N'www.ttcshelbyville.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450779, N'221519', N'Sewanee-The University of the South', N'735 University Avenue', N'Sewanee', N'TN', N'37383-1000', N'www.sewanee.edu', N'admission.sewanee.edu/', N'admission.sewanee.edu/finaid', N'admission.sewanee.edu/apply', N'www.collegecostcalculator.org/sewaneetheuniversityofthesouth')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450780, N'221582', N'Tennessee Technology Center at Oneida-Huntsville', N'355 Scott High Drive', N'Huntsville', N'TN', N'37756-4149', N'www.ttconeida.edu', NULL, NULL, NULL, N'www.ttconeida.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450781, N'221591', N'Tennessee Technology Center at Crossville', N'910 Miller Avenue', N'Crossville', N'TN', N'38555', N'www.ttcc.edu', N'www.ttcc.edu', N'www.ttcc.edu', N'www.ttcc.edu', N'www.ttcc.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450782, N'221607', N'Tennessee Technology Center at McMinnville', N'241 Vo Tech Dr', N'McMinnville', N'TN', N'37110', N'www.ttcmcminnville.edu', NULL, NULL, NULL, N'www.ttcmcminnville.edu/sites/default/files/mcminnville/npc/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450783, N'221616', N'Tennessee Technology Center at Jackson', N'2468 Technology Center Drive', N'Jackson', N'TN', N'38301', N'www.ttcjackson.edu', N'www.ttcjackson.edu', N'www.ttcjackson.edu', N'www.ttcjackson.edu', N'www.ttcjackson.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450784, N'221625', N'Tennessee Technology Center at Knoxville', N'1100 Liberty St', N'Knoxville', N'TN', N'37919', N'www.ttcknoxville.edu/', N'www.ttcknoxville.edu/', N'www.ttcknoxville.edu/', NULL, N'www.ttcknoxville.edu/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450785, N'221634', N'Tennessee Technology Center at Whiteville', N'1685 Highway 64', N'Whiteville', N'TN', N'38075-0489', N'www.ttcwhiteville.edu', N'www.ttcwhiteville.edu', N'www.ttcwhiteville.edu', N'www.ttcwhiteville.edu', N'www.ttcwhiteville.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450786, N'221643', N'Pellissippi State Community College', N'10915 Hardin Valley Road', N'Knoxville', N'TN', N'37933-0990', N'www.pstcc.edu/', N'www.pstcc.edu/admissions/', N'www.pstcc.edu/financial_aid/', N'www.pstcc.edu/admissions/apply.html', N'www.pstcc.edu/financial_aid/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450787, N'221661', N'Southern Adventist University', N'4881 Taylor Cir', N'Collegedale', N'TN', N'37315-0370', N'www.southern.edu', N'https://www.southern.edu/enrollment/Pages/default.aspx', N'https://www.southern.edu/sites/enrollment/Pages/default.aspx', N'https://www.southern.edu/enrollment/admissions/Pages/applynow.aspx', N'www.southern.edu/enrollment/finances/Pages/financialaidcalculator.aspx#start')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450788, N'221670', N'Southern College of Optometry', N'1245 Madison Ave', N'Memphis', N'TN', N'38104-2211', N'www.sco.edu', N'www.sco.edu/admissions', N'www.sco.edu/tuitionandfinancialaid', N'www.sco.edu/apply', NULL)
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450789, N'221731', N'Tennessee Wesleyan College', N'204 East College Street', N'Athens', N'TN', N'37303', N'www.twcnet.edu', N'www.twcnet.edu/admissions/', N'www.twcnet.edu/admissions/tuition-and-financial-aid-information/', N'www.collegefortn.org/applications/TN_Common_App/apply.html?application_id=2771', N'www.twcnet.edu/admissions/tuition-and-financial-aid-information/net-price-calculator/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450790, N'221740', N'The University of Tennessee at Chattanooga', N'615 McCallie Ave', N'Chattanooga', N'TN', N'37403-2598', N'www.utc.edu', N'www.utc.edu/admissions.php', N'www.utc.edu/Administration/FinancialAid/', N'secure.utc.edu/admissions/secure/', N'www.utc.edu/Administration/Bursar/fees.php')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450791, N'221759', N'The University of Tennessee', N'527 Andy Holt Tower', N'Knoxville', N'TN', N'37996', N'www.tennessee.edu', N'admissions.utk.edu', N'finaid.utk.edu', N'vip.utk.edu', N'www.collegeportraits.org/TN/UTK/estimator/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450792, N'221768', N'The University of Tennessee-Martin', N'544 University Street', N'Martin', N'TN', N'38238-0002', N'www.utm.edu', N'www.utm.edu/admis.php', N'www.utm.edu/departments/finaid/', N'www.utm.edu/departments/admissions/apply.php', N'www.utm.edu/departments/finaid/calculator.php')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450793, N'221795', N'Fountainhead College of Technology', N'10208 Technology Drive', N'Knoxville', N'TN', N'37932', N'www.fountainheadcollege.edu', NULL, NULL, NULL, N'fountainheadcollege.edu/admissions-college-information/financial-aid/net-price-calculator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450794, N'221829', N'Tennessee School of Beauty of Knoxville Inc', N'4704 Western Ave', N'Knoxville', N'TN', N'37921', N'www.tennesseeschoolofbeauty.com', NULL, NULL, NULL, N'www.tennesseeschoolofbeauty.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450795, N'221838', N'Tennessee State University', N'3500 John A. Merritt Blvd', N'Nashville', N'TN', N'37209-1561', N'www.tnstate.edu', N'www.tnstate.edu/admissions/', N'www.tnstate.edu/financial_aid/', N'www.tnstate.edu/admissions/apply.aspx', N'www.tnstate.edu/financial_aid/tuition_calculator.aspx')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450796, N'221847', N'Tennessee Technological University', N'1 William L. Jones Drive', N'Cookeville', N'TN', N'38505-0001', N'www.tntech.edu', N'www.tntech.edu/admissions/', N'www.tntech.edu/financialaid/', N'www.tntech.edu/admissions/', N'www.tntech.edu/financialaid/netprice/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450797, N'221856', N'Tennessee Temple University', N'1815 Union Ave', N'Chattanooga', N'TN', N'37404', N'www.tntemple.edu', N'www.tntemple.edu/admissions', N'www.tntemple.edu/financial-aid-1', N'www.tntemple.edu/apply-now', N'www.tntemple.edu/calculator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450798, N'221892', N'Trevecca Nazarene University', N'333 Murfreesboro Rd', N'Nashville', N'TN', N'37210', N'www.trevecca.edu', N'www.trevecca.edu/admissions', N'www.trevecca.edu/admissions/financial.aid', NULL, N'npc.collegeboard.org/student/app/trevecca')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450799, N'221908', N'Northeast State Community College', N'2425 Hwy 75', N'Blountville', N'TN', N'37617-0246', N'www.NortheastState.edu', N'www.northeaststate.edu/admissions/', N'www.northeaststate.edu/financialaid/', N'banssprod.northeaststate.edu/pls/PROD/bwskalog.P_DispLoginNon', N'www.northeaststate.edu/financialAid.aspx?id=786&terms=Net%20Price')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450800, N'221953', N'Tusculum College', N'60 Shiloh Road', N'Greeneville', N'TN', N'37743', N'www.tusculum.edu', N'www.tusculum.edu/admission/', N'www.tusculum.edu/faid/', N'www.tusculum.edu/admission/admission_apply.html', N'www.tusculum.edu/npc/index.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450801, N'221971', N'Union University', N'1050 Union University Dr', N'Jackson', N'TN', N'38305-3697', N'www.uu.edu', N'www.uu.edu/admissions/undergraduate/GetToKnowUs.cfm', N'www.uu.edu/financialaid/', N'https://www.uu.edu/applications/undergrad/', N'www.uu.edu/financialaid/undergraduate/npc/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450802, N'221980', N'New Concepts School of Cosmetology', N'1412 South Lee Hwy', N'Cleveland', N'TN', N'37311', N'newconcepts.doodlekit.com', NULL, NULL, NULL, N'newconcepts.doodlekit.com')
GO
print 'Processed 100 total records'
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450803, N'221999', N'Vanderbilt University', N'2101 West End Avenue', N'Nashville', N'TN', N'37240', N'www.vanderbilt.edu', N'www.vanderbilt.edu/Admissions/', N'www.vanderbilt.edu/financialaid/', N'www.vanderbilt.edu/Admissions/applyNow.php', N'npc.collegeboard.org/student/app/vanderbilt')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450804, N'222026', N'Volunteer Beauty School-Dyersburg', N'2440 Lake Road', N'Dyersburg', N'TN', N'38024-1604', N'www.volunteerbeauty.com', N'www.volunteerbeauty.com', N'www.volunteerbeauty.com', NULL, N'www.volunteerbeauty.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450805, N'222053', N'Volunteer State Community College', N'1480 Nashville Pike', N'Gallatin', N'TN', N'37066-3188', N'www.volstate.edu', N'volstate.edu/Admissions/Information/', N'volstate.edu/FinancialAid/', N'www.collegefortn.org/Applications/Volunteer_State_CC/apply.html?application_id=3581', N'www.volstate.edu/FinancialAid/Cost.php')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450806, N'222062', N'Walters State Community College', N'500 South Davy Crockett Parkway', N'Morristown', N'TN', N'37813-6899', N'www.ws.edu', N'www.ws.edu/admissions/', N'www.ws.edu/financial-aid/', N'www.ws.edu/admissions/apply/default.shtm#submitonline', N'www.ws.edu/about/admin/planning-research/right-to-know/net-price-calculator/default.shtmhtm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450807, N'222099', N'West Tennessee Business College', N'1186 Highway 45 Bypass', N'Jackson', N'TN', N'38301', N'www.wtbc.edu', N'www.wtbc.edu', N'www.wtbc.edu', N'www.wtbc.edu', N'www.wtbc.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450808, N'222105', N'William Moore College of Technology', N'1200 Poplar  Ave', N'Memphis', N'TN', N'38104-7240', N'www.williamrmoore.org', N'www.williamrmoore.org', N'www.williamrmoore.org', NULL, N'www.williamrmoore.org')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450809, N'222178', N'Abilene Christian University', N'1600 Campus Court', N'Abilene', N'TX', N'79699', N'www.acu.edu', N'www.acu.edu/admissions', N'www.acu.edu/campusoffices/sfs/index.html', N'www.acuadmissions.org/start/apply.htm', N'www.acu.edu/campusoffices/sfs/calculator/freshmen.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450810, N'222497', N'Alamo Community College District Central Office', N'201 W. Sheridan', N'San Antonio', N'TX', N'78204-1429', N'www.alamo.edu/district/', N'www.alamo.edu/district/admissions/', N'www.alamo.edu/district/financial-aid/', N'www.applytexas.org/adappc/gen/c_start.WBX', N'www.alamo.edu/district/business-office/tuition-and-fees/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450811, N'222567', N'Alvin Community College', N'3110 Mustang Rd', N'Alvin', N'TX', N'77511-4898', N'www.alvincollege.edu', N'www.alvincollege.edu/future/get_started.cfm', N'www.alvincollege.edu/FinancialAid/default.htm', N'www.applytexas.org/adappc/gen/c_start.WBX?s_logon_msg=Y', N'www.alvincollege.edu/netprice/netpricecalculator/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450812, N'222576', N'Amarillo College', N'2011 S. Washington', N'Amarillo', N'TX', N'79109', N'www.actx.edu', N'www.actx.edu/admission/', N'www.actx.edu/fin/', N'www.actx.edu/contact/index.php?module=article&id=31', N'www.actx.edu/fin/index.php?module=article&id=390')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450813, N'222628', N'Amberton University', N'1700 Eastgate Dr', N'Garland', N'TX', N'75041-5595', N'www.amberton.edu', N'www.amberton.edu', N'www.amberton.edu', N'www.amberton.edu', N'www.amberton.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450814, N'222673', N'American Commercial College-San Angelo', N'3177 Executive Dr', N'San Angelo', N'TX', N'76904', N'www.americancommercialcollege.com', NULL, NULL, NULL, N'www.americancommercialcollege.com/netpricecalc.php')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450815, N'222682', N'American Commercial College-Lubbock', N'2007 34th St', N'Lubbock', N'TX', N'79411', N'americancommercialcollege.com', NULL, NULL, N'americancommercialcollege.com', N'www.americancommercialcollege.com/netpricecalc.php')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450816, N'222691', N'American Commercial College-Abilene', N'402 Butternut St', N'Abilene', N'TX', N'79602', N'americancommercialcollege.com', NULL, NULL, N'americancommercialcollege.com', N'www.americancommercialcollege.com/netpricecalc.php')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450817, N'222707', N'American Commercial College-Odessa', N'5119 Twin Towers', N'Odessa', N'TX', N'79762', N'americancommercialcollege.com', NULL, NULL, NULL, N'www.americancommercialcollege.com/netpricecalc.php')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450818, N'222761', N'ATI Technical Training Center', N'6627 Maple Ave', N'Dallas', N'TX', N'75235', N'www.aticareertraining.edu', N'www.aticareertraining.edu', N'www.aticareertraining.edu', N'www.aticareertraining.edu', N'www.aticareertraining.edu/financial-assistance/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450819, N'431275', N'Herkimer County BOCES-Practical Nursing Program', N'295 W Main St', N'Ilion', N'NY', N'13357', N'www.herkimer-boces.org', N'www.herkimer-boces.org', N'www.herkimer-boces.org', N'www.herkimer-boces.org', N'www.herkimer-boces.org')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450820, N'431284', N'International Beauty College 3', N'1225 Beltline Rd Ste 7', N'Garland', N'TX', N'75040-3294', N'www.ibc3.edu', NULL, NULL, NULL, N'www.ibc3.edu/courses.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450821, N'431309', N'Dewey University', N'427 Barbosa Ave. Third Floor', N'Hato Rey', N'PR', N'00910-9538', N'www.jdc.edu', N'www.jdc.edu', N'www.jdc.edu', NULL, N'www.jdc.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450822, N'431558', N'Lee County High Tech Center North', N'360 Santa Barbara Blvd North', N'Cape Coral', N'FL', N'33993-2479', N'www.hightechnorth.com', N'www.hightechnorth.com', N'www.hightechnorth.com', NULL, N'www.hightechnorth.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450823, N'431594', N'Massachusetts General Hospital Dietetic Internship', N'Fruit St', N'Boston', N'MA', N'02114-2696', NULL, NULL, NULL, NULL, N'www.massgeneral.org/dietetic/financialaid/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450824, N'431600', N'Mercy Hospital School of Nursing', N'1401 Blvd of the Allies', N'Pittsburgh', N'PA', N'15219-5166', N'www.upmc.com/HospitalsFacilities/Hospitals/Mercy/professionaleducation/school-of-nursing/Pages/default.aspx', N'www.upmc.com/HospitalsFacilities/Hospitals/Mercy/professionaleducation/school-of-nursing/Pages/default.aspx', N'www.upmc.com/HospitalsFacilities/Hospitals/Mercy/professionaleducation/school-of-nursing/Pages/default.aspx', N'www.upmc.com/HospitalsFacilities/Hospitals/Mercy/professionaleducation/school-of-nursing/Pages/default.aspx', N'www.upmc.com/HospitalsFacilities/Hospitals/Mercy/professionaleducation/school-of-nursing/Pages/default.aspx')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450825, N'431637', N'American Beauty Academy', N'11006 Veirs Mill Road', N'Wheaton', N'MD', N'20902-1911', N'www.americanbeautyacademy.org', N'www.americanbeautyacademy.org', N'www.americanbeautyacademy.org', NULL, N'www.americanbeautyacademy.org')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450826, N'431691', N'Northland Career Center', N'1801 Branch', N'Platte City', N'MO', N'64079', N'www.northlandcareercenter.com', N'www.northlandcareercenter.com', N'www.northlandcareercenter.com', NULL, N'www.northlandcareercenter.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450827, N'446288', N'Paul Mitchell the School-Great Lakes', N'2950 Lapeer', N'Port Huron', N'MI', N'48060', N'school.paulmitchell.edu/port-huron-mi', NULL, NULL, NULL, N'school.paulmitchell.edu/port-huron-mi/programs/netprice?progid=1')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450828, N'446297', N'Harley''s Beauty and Barber Career Institute', N'1510 Ontario Street', N'Columbia', N'SC', N'29204', N'www.hbbci.com', N'www.hbbci.com', N'www.hbbci.com', NULL, NULL)
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450829, N'446303', N'Healthcare Training Institute', N'1969 Morris Ave', N'Union', N'NJ', N'07083', N'www.htinj.edu', N'www.htinj.edu', NULL, NULL, N'www.htinj.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450830, N'446321', N'Hudson Valley School of Advanced Aesthetic Skin Care', N'1723 Rte 9W', N'West Park', N'NY', N'12493', N'www.HVSAesthetics.com', N'hvsaesthetics.com/admissions/admission-eligibility-requirements', N'hvsaesthetics.com/admissions/financial-aid', NULL, N'hvsaesthetics.com/wp-content/uploads/2011/11/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450831, N'446349', N'John D Rockefeller IV Career Center', N'95 Rockyside Road', N'New Cumberland', N'WV', N'26047', N'www.jdrcc.org', NULL, NULL, NULL, N'jdrcc.studentaidcalculator.com/survey.aspx')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450832, N'446358', N'Ladera Career Paths Training Centers', N'6820 La Tijera Blvd Ste 217', N'Los Angeles', N'CA', N'90045-1931', N'laderaonline.com/', NULL, NULL, NULL, N'laderaonline.com/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450833, N'446385', N'Los Angeles Music Academy', N'370 S Fair Oaks Ave', N'Pasadena', N'CA', N'91105', N'www.lamusicacademy.edu', N'lamusicacademy.edu/jm/index.php?option=com_content&view=article&id=39&Itemid=35', N'lamusicacademy.edu/jm/index.php?option=com_content&view=article&id=44&Itemid=40', N'lamusicacademy.edu/jm/index.php?option=com_content&view=article&id=39&Itemid=35', N'lamusicacademy.edu/netprice/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450834, N'446394', N'Maple Springs Baptist Bible College and Seminary', N'4130 Belt Rd', N'Capitol Heights', N'MD', N'20743', N'www.msbbcs.edu', N'www.msbbcs.edu', N'www.msbbcs.edu', N'www.msbbcs.edu', N'www.msbbcs.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450835, N'446400', N'MCI Institute of Technology', N'3650 Shawnee Ave.', N'West Palm Beach', N'FL', N'33409', N'www.mciiot.com', N'www.mciiot.com', N'www.mciiot.com', N'www.mciiot.com', N'www.mciiot.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450836, N'446419', N'Oregon Career & Technology Center', N'5224 Bayshore Road', N'Oregon', N'OH', N'43616', N'www.oregoncityschools.org/home/adult-home.html', NULL, N'www.oregoncityschools.org/Course-Offerings/financial-aid.html', NULL, N'www.oregoncityschools.org/Net-Price-Calculator.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450837, N'446428', N'Performance Training Institute', N'1012 Cox Cro Rd', N'Toms River', N'NJ', N'08755', N'www.ptitraining.edu', N'www.ptitraining.edu', N'www.ptitraining.edu', N'https://apply.ptitraining.edu', N'www.ptitraining.edu/financial-aid/net-price-calculator/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450838, N'446437', N'Pacific Coast Trade School', N'1690 Universe Cir', N'Oxnard', N'CA', N'93033', N'pctschool.com/', NULL, NULL, NULL, N'pctschool.com/finaid.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450839, N'446446', N'Centura Institute', N'6359 Edgewater Drive', N'Orlando', N'FL', N'32810', N'www.centura.edu/Orlando/default.aspx', N'www.centura.edu', N'www.centura.edu', N'www.centura.edu', N'www.centura.edu/Orlando/Shared%20Documents/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450840, N'446455', N'Precision Manufacturing Institute', N'764 Bessemer Street, Suite 105', N'Meadville', N'PA', N'16335', N'www.pmionline.edu', NULL, NULL, NULL, N'pmionline.edu/index.php?/meadville/Calculator/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450841, N'446464', N'Professional Massage Training Center', N'229 East Commercial Street', N'Springfield', N'MO', N'65803', N'www.pmtc.edu', NULL, NULL, NULL, N'pmtc.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450842, N'446491', N'Regency School of Hair Design', N'567 North Lake Dr.', N'Prestonsburg', N'KY', N'41653', NULL, NULL, NULL, NULL, N'www.regencybeauty.com/?')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450843, N'446507', N'Renaissance School of Therapeutic Massage', N'566 West 1350 South', N'Bountiful', N'UT', N'84010', N'www.renaissancemassageschool.com', NULL, NULL, NULL, N'www.renaissancemassageschool.com/tuition-calculator/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450844, N'446516', N'Rosslyn Training Academy of Cosmetology', N'Calle Paz 213', N'Aguada', N'PR', N'00602', N'rosslyntrainig.edu', NULL, NULL, NULL, N'www.rosslyntraining.edu/calculadora.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450845, N'446525', N'SAE Institute of Technology-Nashville', N'7 Music Circle N', N'Nashville', N'TN', N'37203', N'www.nashville.sae.edu', NULL, NULL, NULL, N'www.nashville.sae.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450846, N'446534', N'Eclipse School of Cosmetology and Barbering', N'52 s. plaza way', N'Cape Girardeau', N'MO', N'63701', N'eclips.edu', N'www.eclips.edu', N'www.eclips.edu', N'www.eclips.edu', N'eclips.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450847, N'446543', N'Shear Academy', N'780 West Ave', N'Crossville', N'TN', N'38555', N'shearacademy.com', NULL, NULL, NULL, N'shearacademy.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450848, N'446552', N'Southern Technical College', N'2910 S. Orlando Drive', N'Sanford', N'FL', N'32773', N'www.southerntech.edu', NULL, NULL, NULL, N'www.southerntech.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450849, N'446561', N'Stanbridge College', N'2041 Business Ctr Dr Ste 107', N'Irvine', N'CA', N'92612', N'www.stanbridge.edu', NULL, NULL, NULL, N'www.stanbridge.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450850, N'446570', N'Styletrends Barber and Hairstyling Academy', N'239 Hampton St', N'Rock Hill', N'SC', N'29730', N'www.styletrendsacademy.com', NULL, NULL, N'www.styletrendsacademy.com', N'www.styletrendsacademy.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450851, N'446589', N'Universal Career School', N'10720 W Flagler School Ste 21', N'Sweetwater', N'FL', N'33174', N'www.universalbeautyschool.com', NULL, NULL, NULL, N'universalbeautyschool.com/NPC')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450852, N'446598', N'Universal College of Healing Arts', N'8702 North 30th Street', N'Omaha', N'NE', N'68112-1810', N'www.ucha.com', NULL, NULL, NULL, N'www.ucha.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450853, N'446604', N'Uta Mesivta of Kiryas Joel', N'48 Bakertown Rd Suite 501', N'Monroe', N'NY', N'10950', NULL, NULL, NULL, NULL, N'utamesivta.org')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450854, N'446613', N'W L Bonner College', N'4430 Argent Ct', N'Columbia', N'SC', N'29203-5901', N'www.wlbc.edu', N'www.wlbc.edu', N'www.wlbc.edu', N'www.wlbc.edu', N'www.wlbc.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450855, N'446640', N'Harrisburg University of Science and Technology', N'326 Market Street', N'Harrisburg', N'PA', N'17101-2208', N'www.HarrisburgU.edu', N'www.harrisburgu.edu/admissions/', N'www.harrisburgu.edu/admissions/financial-aid/', N'www.harrisburgu.edu/admissions/apply.php', N'www.harrisburgu.edu/NetPrice/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450856, N'450119', N'Blue Cliff College-Fayetteville', N'3448 N. College', N'Fayetteville', N'AR', N'72703', N'bluecliffcollege.com', N'bluecliffcollege.com/admissions.shtml', N'bluecliffcollege.com/financialaid.shtml', N'bluecliffcollege.com/contact.shtml', N'bluecliffcollege.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450857, N'450128', N'Blue Cliff College-Alexandria', N'1505 Metro Dr Ste 1', N'Alexandria', N'LA', N'71301', N'bluecliffcollege.com', N'www.bluecliffcollege.com/admissions.shtml', N'www.bluecliffcollege.com/financialaid.shtml', N'www.bluecliffcollege.com/contact.shtml', N'bluecliffcollege.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450858, N'450146', N'StenoTech Career Institute-Piscataway', N'262 Old New Brunswick Rd - Unit A', N'Piscataway', N'NJ', N'08854-3756', N'www.stenotech.edu', N'www.stenotech.edu', N'www.stenotech.edu', N'www.stenotech.edu', N'www.stenotech.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450859, N'450155', N'Anthem College-Brookfield', N'440 South Executive Dr-Ste 230', N'Brookfield', N'WI', N'53005', N'www.anthem.edu', N'www.anthem.edu/admissions', N'www.anthem.edu/financial-aid', NULL, N'anthem.edu/anthemcollege/net-price-calculator/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450860, N'450173', N'Ultimate Medical Academy-Tampa', N'9309 N Florida Ave Ste 100', N'Tampa', N'FL', N'33612', N'www.studymedical.com', NULL, NULL, NULL, N'www.ultimatemedical.edu/npcalc/npcalc.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450861, N'450182', N'Beauty Schools of America-North Miami Beach', N'1813 NE 163rd Street', N'North Miami Beach', N'FL', N'33162', N'www.bsa.edu', N'www.bsa.edu/admission.html', N'www.bsa.edu/admission/financial-aid.html', N'www.bsa.edu/signup/', N'www.bsa.edu/admission/net-price-calculator.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450862, N'450191', N'Virginia College-Biloxi', N'920 Cedar Lake Rd-Ste C', N'Biloxi', N'MS', N'39532', N'www.vc.edu/college/biloxi-colleges-mississippi.cfm', NULL, NULL, NULL, N'enroll.vc.edu/npc/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450863, N'450207', N'ITT Technical Institute-St. Petersburg', N'877 Executive Center Dr. West, Suite 100', N'St. Petersburg', N'FL', N'33702', N'www.itt-tech.edu', NULL, NULL, NULL, N'www.itt-tech.edu/npc')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450864, N'450216', N'ITT Technical Institute-Baton Rouge', N'14141 Airline Highway, Suite 101', N'Baton Rouge', N'LA', N'70817', N'www.itt-tech.edu', NULL, NULL, NULL, N'www.itt-tech.edu/npc')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450865, N'450225', N'ITT Technical Institute-Columbia', N'1628 Browning Road, Suite 180', N'Columbia', N'SC', N'29210', N'www.itt-tech.edu', NULL, NULL, NULL, N'www.itt-tech.edu/npc')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450866, N'450234', N'ITT Technical Institute-Wichita', N'8111 E. 32nd Street North, Suite 103', N'Wichita', N'KS', N'67226', N'www.itt-tech.edu', NULL, NULL, NULL, N'www.itt-tech.edu/npc')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450867, N'450243', N'ITT Technical Institute-Atlanta', N'485 Oak Place, Suite 100', N'Atlanta', N'GA', N'30349', N'www.itt-tech.edu', NULL, NULL, NULL, N'www.itt-tech.edu/npc')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450868, N'450252', N'ITT Technical Institute-Mobile', N'3100 Cottage Hill Rd Bldg 3', N'Mobile', N'AL', N'36606', N'www.itt-tech.edu', NULL, NULL, NULL, N'www.itt-tech.edu/npc')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450869, N'450261', N'ITT Technical Institute-Chattanooga', N'5600 Brainerd Rd Suite G-1', N'Chattanooga', N'TN', N'37411', N'www.itt-tech.edu', NULL, NULL, NULL, N'www.itt-tech.edu/npc')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450870, N'450270', N'ITT Technical Institute-South Bend', N'17390 Dugdale Dr Ste 100', N'South Bend', N'IN', N'46635', N'www.itt-tech.edu', NULL, NULL, NULL, N'www.itt-tech.edu/npc')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450871, N'450289', N'Virginia College-School of Business and Health', N'721 Eastgate Loop Rd.', N'Chattanooga', N'TN', N'37411', N'www.vc.edu/college/chattanooga-colleges-tennessee.cfm', NULL, NULL, NULL, N'enroll.vc.edu/npc')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450872, N'450298', N'Strayer University-Delaware', N'240 Continental Dr Ste 108', N'Newark', N'DE', N'19713', N'www.strayeruniversity.edu', NULL, NULL, NULL, N'npc.collegeboard.org/student/app/strayeruniversity')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450873, N'450304', N'Brite Divinity School', N'2800 S. University Dr.', N'Fort Worth', N'TX', N'76129', N'www.brite.tcu.edu', N'www.brite.tcu.edu/admission/', NULL, NULL, N'www.brite.tcu.edu/admission/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450874, N'450377', N'Strayer University-Alabama', N'3570 Grandview Pkwy Ste 200', N'Birmingham', N'AL', N'35243', N'www.strayer.edu/campus/birmingham', NULL, NULL, N'www.strayer.edu', N'npc.collegeboard.org/student/app/strayeruniversity')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450875, N'450395', N'Brown Aveda Institute-Rocky River', N'19336 Detroit Rd.', N'Rocky River', N'OH', N'44116', N'www.brownaveda.com', N'www.brownaveda.com', N'www.brownaveda.com', N'www.brownaveda.com', N'www.brownaveda.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450876, N'450401', N'Clary Sage College', N'3131 South Sheridan', N'Tulsa', N'OK', N'74145', N'www.clarysagecollege.com', NULL, NULL, NULL, N'www.clarysagecollege.com/financial-aid/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450877, N'450429', N'Broadview University-Layton', N'869 West Hill Field Road', N'Layton', N'UT', N'84041', N'www.broadviewuniversity.edu', N'www.broadviewuniversity.edu', NULL, N'www.broadviewuniversity.edu/apply/', N'www.broadviewuniversity.edu/financial-aid.aspx')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450878, N'450447', N'International Academy of Design and Technology-Sacramento', N'2450 Del Paso Road-St 250', N'Sacramento', N'CA', N'95834', N'www.iadtsacramento.com', N'www.iadtsacramento.com', N'www.iadtsacramento.com', N'www.iadtsacramento.com', N'iadt.studentaidcalculator.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450879, N'450456', N'University of Phoenix-Birmingham Campus', N'100 Corporate Parkway', N'Birmingham', N'AL', N'35242-2982', N'www.phoenix.edu', NULL, N'faw.phoenix.edu', N'myapply.phoenix.edu', N'www.phoenix.edu/tuition_and_financial_options/tuition_and_fees.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450880, N'450465', N'International Academy of Design and Technology-San Antonio', N'4511 Horizon Hill Rd', N'San Antonio', N'TX', N'78229', N'www.iadtsanantonio.com', NULL, NULL, NULL, N'iadt.studentaidcalculator.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450881, N'450474', N'University of Phoenix-Augusta Campus', N'3150 Perimeter Pkwy', N'Augusta', N'GA', N'30909-4583', N'www.phoenix.edu', NULL, N'faw.phoenix.edu', N'myapply.phoenix.edu', N'www.phoenix.edu/tuition_and_financial_options/tuition_and_fees.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450882, N'450483', N'University of Phoenix-Washington DC Campus', N'25 Massachusetts Ave NW', N'Washington', N'DC', N'20001-1431', N'www.phoenix.edu', NULL, N'faw.phoenix.edu', N'myapply.phoenix.edu', N'www.phoenix.edu/tuition_and_financial_options/tuition_and_fees.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450883, N'450492', N'University of Phoenix-Chattanooga Campus', N'1208 Pointe Centre Dr', N'Chattanooga', N'TN', N'37421-3983', N'www.phoenix.edu', NULL, N'faw.phoenix.edu', N'myapply.phoenix.edu', N'www.phoenix.edu/tuition_and_financial_options/tuition_and_fees.html')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450884, N'450508', N'DeVry University-Michigan', N'26999 Central Park Blvd Ste 125', N'Southfield', N'MI', N'48076-4174', N'www.devry.edu', NULL, NULL, NULL, N'www.devry.edu/financial-aid-tuition/financial-aid-calculator.jsp')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450885, N'450517', N'DeVry University-Tennessee', N'6401 Poplar Ave., Ste. 600', N'Memphis', N'TN', N'38119-4808', N'www.devry.edu', NULL, NULL, NULL, N'www.devry.edu/financial-aid-tuition/financial-aid-calculator.jsp')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450886, N'450526', N'Argosy University-Inland Empire', N'3401 Centre Lake Drive, Suite 200', N'Ontario', N'CA', N'91761', N'www.argosy.edu/inlandempire', N'www.argosy.edu/admissions', N'www.argosy.edu/admissions/scholarships-financial-aid', N'www.argosy.edu/admissions', N'tcc.noellevitz.com/edmc/Argosy%20University?iframe=true&width600&height=1000')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450887, N'450535', N'Argosy University-Nashville', N'100 Centerview Dr, Suite 225', N'Nashville', N'TN', N'37214', N'www.argosy.edu/nashville/', N'www.argosy.edu/admissions', N'www.argosy.edu/admissions/scholarships-financial-aid', N'www.argosy.edu/admissions', N'tcc.noellevitz.com/edmc/Argosy%20University?iframe=true&width600&height=1000')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450888, N'450544', N'Argosy University-San Diego', N'1615 Murray Canyon Road, Suite 100', N'San Diego', N'CA', N'92108', N'www.argosy.edu/sandiego', N'www.argosy.edu/admissions', N'www.argosy.edu/admissions/scholarships-financial-aid', N'www.argosy.edu/admissions', N'tcc.noellevitz.com/edmc/Argosy%20University?iframe=true&width600&height=1000')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450889, N'450553', N'Vatterott Education Center', NULL, NULL, N'TX', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450890, N'450571', N'Rasmussen College-Wisconsin', N'904 South Taylor Street, Suite 100', N'Green Bay', N'WI', N'54303-2349', N'rasmussen.edu', N'rasmussen.edu', N'rasmussen.edu', N'rasmussen.edu', N'rasmussen.studentaidcalculator.com/survey.aspx')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450891, N'450580', N'Empire Beauty School-Lisle', N'2709 Maple Avenue', N'Lisle', N'IL', N'60532', N'www.empire.edu', N'www.empire.edu', N'www.empire.edu', NULL, N'www.empire.edu/net-price-calculator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450892, N'450599', N'Empire Beauty School-Richmond', N'9049 West Broad St. #3', N'Richmond', N'VA', N'23294', N'www.empire.edu', N'www.empire.edu', N'www.empire.edu', NULL, N'www.empire.edu/net-price-calculator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450893, N'450605', N'Empire Beauty School-North Hills', N'4768 McKnight Road', N'Pittsburgh', N'PA', N'15237', N'www.empire.edu', N'www.empire.edu', N'www.empire.edu', NULL, N'www.empire.edu/net-price-calculator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450894, N'450614', N'Empire Beauty School-Concord', N'Shops @ Kings Grant 10075 Weddington Rd', N'Concord', N'NC', N'28027', N'www.empire.edu', N'www.empire.edu', N'www.empire.edu', NULL, N'www.empire.edu/net-price-calculator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450895, N'450623', N'Empire Beauty School-Arlington Heights', N'264 West Rand Rd', N'Arlington Heights', N'IL', N'60004', N'www.empire.edu', N'www.empire.edu', N'www.empire.edu', NULL, N'www.empire.edu/net-price-calculator')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450896, N'450632', N'Lexington Healing Arts Academy', N'272 Southland Drive', N'Lexington', N'KY', N'40503', N'www.lexingtonhealingarts.com', NULL, NULL, NULL, N'Notapplicable.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450897, N'450641', N'Empire Beauty School-Hooksett', N'1328 Hooksett Rd', N'Hooksett', N'NH', N'03106', N'www.empirebeautyschools.com', N'www.empirebeautyschools.com', N'www.empirebeautyschools.com', N'www.empirebeautyschools.com', N'www.empirebeautyschools.com')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450898, N'450650', N'The Institute of Beauty and Wellness', N'327 East Saint Paul Avenue', N'Milwaukee', N'WI', N'53202', N'www.ibw.edu', NULL, NULL, NULL, N'www.institutebw.com/admissions/NetPriceCalculator2009-2010.htm')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450899, N'450669', N'InterCoast Colleges-Carson', N'One Civic Plaza-Ste 110', N'Carson', N'CA', N'90745', N'www.intercoast.edu/locations/carson', N'www.intercoast.edu/admissions/', N'www.intercoast.edu/financial-services/', NULL, N'www.intercoast.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450900, N'450678', N'InterCoast Career Institute-South Portland', N'207 Gannett Dr', N'South Portland', N'ME', N'04106', N'www.intercoast.edu', N'www.intercoast.edu', N'www.intercoast.edu', N'www.intercoast.edu', N'www.intercoast.edu')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450901, N'450696', N'Carrington College California-Stockton', N'1313 W. Robinhood Drive, Suite B', N'Stockton', N'CA', N'95207', N'www.carrington.edu', NULL, NULL, NULL, N'carrington.edu/financial-aid/net-price-calculator/carrington-college-california/')
INSERT [dbo].[ivyt_Universities] ([UniversityID], [Code], [Name], [Address], [City], [StateCode], [Zip], [WebAddress], [AdminUrl], [FaidUrl], [ApplUrl], [NpricUrl]) VALUES (450902, N'450702', N'Carrington College California-Citrus Heights', N'7301 Greenback Lane, Ste A', N'Citrus Heights', N'CA', N'95621', N'www.carrington.edu', NULL, NULL, NULL, N'carrington.edu/financial-aid/net-price-calculator/carrington-college-california/')
SET IDENTITY_INSERT [dbo].[ivyt_Universities] OFF
GO
print 'Processed 200 total records'
/****** Object:  StoredProcedure [dbo].[ivyp_SaveVerificationData]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ivyp_SaveVerificationData](
@UnitID int
,@FFVerifyComments nvarchar(500)
,@FSVerifyComments nvarchar(500)
,@FMVerifyComments nvarchar(500)
,@TFVerifyComments nvarchar(500)
,@TSVerifyComments nvarchar(500)
,@TMVerifyComments nvarchar(500)
,@PassReview int
,@OperatorID int
)
as begin
	update [dbo].[ivyt_DataCollect_Admission]
		set FFVerifyComments = @FFVerifyComments
		,FSVerifyComments = @FSVerifyComments
		,FMVerifyComments = @FMVerifyComments
		,TFVerifyComments = @TFVerifyComments
		,TSVerifyComments = @TSVerifyComments
		,TMVerifyComments = @TMVerifyComments
		,[PassReview] = @PassReview
		where UnitID = @UnitID
  
    update [dbo].[ivyt_DataCollect_School_assignment]
		set VerifyFinishDateTime = getDate()
		where UnitID = @UnitID
end
GO
/****** Object:  StoredProcedure [dbo].[ivyp_SaveAdmissionData]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ivyp_SaveAdmissionData](
@UnitID int
,@EarlyAction nvarchar(100)
,@EarlyDescisionI nvarchar(100)
,@EarlyDescisionIDeposit nvarchar(100)
,@EarlyDescisionII nvarchar(100)
,@EarlyDescisionIIDeposit nvarchar(100)
,@FFRegularDecision nvarchar(100)
,@FFRegularDescisionDeposit nvarchar(100)
,@FFScholarship nvarchar(100)
,@FFDataURLs nvarchar(500)
,@FSPriority nvarchar(100)
,@FSPriorityDeposit nvarchar(100)
,@FSRegularDecision nvarchar(100)
,@FSRegularDescisionDeposit nvarchar(100)
,@FSScholarship nvarchar(100)
,@FSDataURLs nvarchar(500)
,@FMPriority nvarchar(100)
,@FMPriorityDeposit nvarchar(100)
,@FMRegularDecision nvarchar(100)
,@FMRegularDescisionDeposit nvarchar(100)
,@FMScholarship nvarchar(100)
,@FMDataURLs nvarchar(500)
,@TFRegularDecision nvarchar(100)
,@TFRegularDescisionDeposit nvarchar(100)
,@TFScholarship nvarchar(100)
,@TFDataURLs nvarchar(500)
,@TSPriority nvarchar(100)
,@TSPriorityDeposit nvarchar(100)
,@TSRegularDecision nvarchar(100)
,@TSRegularDescisionDeposit nvarchar(100)
,@TSScholarship nvarchar(100)
,@TSDataURLs nvarchar(500)
,@TMPriority nvarchar(100)
,@TMPriorityDeposit nvarchar(100)
,@TMRegularDecision nvarchar(100)
,@TMRegularDescisionDeposit nvarchar(100)
,@TMScholarship nvarchar(100)
,@TMDataURLs nvarchar(500)
,@ApplicationFee numeric(18, 2)
,@AppFeeWaiver nvarchar(250)
,@OperatorID int
)
as begin

  begin tran

  begin try
	--if exists, update
	  if exists(select 1 from [dbo].[ivyt_DataCollect_Admission] where UnitID = @UnitID)
	  begin
		update [dbo].[ivyt_DataCollect_Admission]
			set EarlyAction = @EarlyAction
			,EarlyDescisionI = @EarlyDescisionI
			,EarlyDescisionIDeposit = @EarlyDescisionIDeposit
			,EarlyDescisionII = @EarlyDescisionII
			,EarlyDescisionIIDeposit = @EarlyDescisionIIDeposit
			,FFRegularDecision = @FFRegularDecision
			,FFRegularDescisionDeposit = @FFRegularDescisionDeposit
			,FFScholarship = @FFScholarship
			,FFDataURLs = @FFDataURLs
			,FSPriority = @FSPriority
			,FSPriorityDeposit = @FSPriorityDeposit
			,FSRegularDecision = @FSRegularDecision
			,FSRegularDescisionDeposit = @FSRegularDescisionDeposit
			,FSScholarship = @FSScholarship
			,FSDataURLs = @FSDataURLs
			,FMPriority = @FMPriority
			,FMPriorityDeposit = @FMPriorityDeposit
			,FMRegularDecision = @FMRegularDecision
			,FMRegularDescisionDeposit = @FMRegularDescisionDeposit
			,FMScholarship = @FMScholarship
			,FMDataURLs = @FMDataURLs
			,TFRegularDecision = @TFRegularDecision
			,TFRegularDescisionDeposit = @TFRegularDescisionDeposit
			,TFScholarship = @TFScholarship
			,TFDataURLs = @TFDataURLs
			,TSPriority = @TSPriority
			,TSPriorityDeposit = @TSPriorityDeposit
			,TSRegularDecision = @TSRegularDecision
			,TSRegularDescisionDeposit = @TSRegularDescisionDeposit
			,TSScholarship = @TSScholarship
			,TSDataURLs = @TSDataURLs
			,TMPriority = @TMPriority
			,TMPriorityDeposit = @TMPriorityDeposit
			,TMRegularDecision = @TMRegularDecision
			,TMRegularDescisionDeposit = @TMRegularDescisionDeposit
			,TMScholarship = @TMScholarship
			,TMDataURLs = @TMDataURLs
			,ApplicationFee = @ApplicationFee
			,AppFeeWaiver = @AppFeeWaiver
			,LastModifiedDateTime = getDate()
			,LastModifiedByID = @OperatorID
			where UnitID = @UnitID
	  end
	  else begin
		insert into [dbo].[ivyt_DataCollect_Admission](
			UnitID
			,EarlyAction
			,EarlyDescisionI
			,EarlyDescisionIDeposit
			,EarlyDescisionII
			,EarlyDescisionIIDeposit
			,FFRegularDecision
			,FFRegularDescisionDeposit
			,FFScholarship
			,FFDataURLs
			,FSPriority
			,FSPriorityDeposit
			,FSRegularDecision
			,FSRegularDescisionDeposit
			,FSScholarship
			,FSDataURLs
			,FMPriority
			,FMPriorityDeposit
			,FMRegularDecision
			,FMRegularDescisionDeposit
			,FMScholarship
			,FMDataURLs
			,TFRegularDecision
			,TFRegularDescisionDeposit
			,TFScholarship
			,TFDataURLs
			,TSPriority
			,TSPriorityDeposit
			,TSRegularDecision
			,TSRegularDescisionDeposit
			,TSScholarship
			,TSDataURLs
			,TMPriority
			,TMPriorityDeposit
			,TMRegularDecision
			,TMRegularDescisionDeposit
			,TMScholarship
			,TMDataURLs
			,ApplicationFee
			,AppFeeWaiver
			,CreatedDateTime
		)
		select
			@UnitID
			,@EarlyAction
			,@EarlyDescisionI
			,@EarlyDescisionIDeposit
			,@EarlyDescisionII
			,@EarlyDescisionIIDeposit
			,@FFRegularDecision
			,@FFRegularDescisionDeposit
			,@FFScholarship
			,@FFDataURLs
			,@FSPriority
			,@FSPriorityDeposit
			,@FSRegularDecision
			,@FSRegularDescisionDeposit
			,@FSScholarship
			,@FSDataURLs
			,@FMPriority
			,@FMPriorityDeposit
			,@FMRegularDecision
			,@FMRegularDescisionDeposit
			,@FMScholarship
			,@FMDataURLs
			,@TFRegularDecision
			,@TFRegularDescisionDeposit
			,@TFScholarship
			,@TFDataURLs
			,@TSPriority
			,@TSPriorityDeposit
			,@TSRegularDecision
			,@TSRegularDescisionDeposit
			,@TSScholarship
			,@TSDataURLs
			,@TMPriority
			,@TMPriorityDeposit
			,@TMRegularDecision
			,@TMRegularDescisionDeposit
			,@TMScholarship
			,@TMDataURLs
			,@ApplicationFee
			,@AppFeeWaiver
			,getDate()
	  end

	  update [dbo].[ivyt_DataCollect_School_assignment]
			set [CollectSubmmitDateTime] = getDate()
			where UnitID = @UnitID
	  commit
  end try
  begin catch
	rollback
	RAISERROR (N'Save Data Failed with UnitID= %s', -- Message text.
           16, -- Severity,
           1, -- State,
           @UnitID, -- First argument.
           null)
  end catch
end
GO
/****** Object:  StoredProcedure [dbo].[ivyp_getSchoolDataByIdy]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ivyp_getSchoolDataByIdy](@SchoolID nvarchar, @UserID int)
as begin

select
b.UnitID
,EarlyAction
,EarlyDescisionI
,EarlyDescisionIDeposit
,EarlyDescisionII
,EarlyDescisionIIDeposit
,FFRegularDecision
,FFRegularDescisionDeposit
,FFScholarship
,FFDataURLs
,FFVerifyComments
,FSPriority
,FSPriorityDeposit
,FSRegularDecision
,FSRegularDescisionDeposit
,FSScholarship
,FSDataURLs
,FSVerifyComments
,FMPriority
,FMPriorityDeposit
,FMRegularDecision
,FMRegularDescisionDeposit
,FMScholarship
,FMDataURLs
,FMVerifyComments
,TFRegularDecision
,TFRegularDescisionDeposit
,TFScholarship
,TFDataURLs
,TFVerifyComments
,TSPriority
,TSPriorityDeposit
,TSRegularDecision
,TSRegularDescisionDeposit
,TSScholarship
,TSDataURLs
,TSVerifyComments
,TMPriority
,TMPriorityDeposit
,TMRegularDecision
,TMRegularDescisionDeposit
,TMScholarship
,TMDataURLs
,TMVerifyComments
,ApplicationFee
,AppFeeWaiver
,PassReview
,c.CreatedDateTime
,c.LastModifiedDateTime
,c.LastModifiedByID
,INSTNM
,ADDR
,CITY
,STABBR
,ZIP
,WEBADDR
,ADMINURL
,FAIDURL
,APPLURL
,NPRICURL
,OperatorID
,VerifiedByID
,CollectorAssignDate
,VerifiedAssignDate
,CollectStartDateTime
,CollectSubmmitDateTime
,VerifyStartDateTime
,VerifyFinishDateTime
from  [dbo].[ivyt_hd] a, [dbo].[ivyt_DataCollect_School_assignment] b, [dbo].[ivyt_DataCollect_Admission] c, [dbo].[ivyt_Accounts] d, [dbo].[ivyt_UserRoleType] e
where a.UNITID = b.UnitID and 
((b.OperatorID = @UserID and c.UnitID = b.UnitID and d.AccountID = b.OperatorID and d.RoleTypeID = e.RoleTypeID and e.RoleType = 'DataEntry') or
 (b.VerifiedByID = @UserID and c.UnitID = b.UnitID and d.AccountID = b.OperatorID and d.RoleTypeID = e.RoleTypeID and e.RoleType = 'DataEverify'))
end
GO
/****** Object:  StoredProcedure [dbo].[ivyp_GetAssignment]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ivyp_GetAssignment](@UserID nvarchar(100))
as begin

select
b.UnitID
,PassReview
,INSTNM
,case when e.RoleType = 'DataEntry' then CollectorAssignDate else VerifiedAssignDate end as AssingnmentDate
from  [dbo].[ivyt_hd] a, [dbo].[ivyt_DataCollect_School_assignment] b, [dbo].[ivyt_DataCollect_Admission] c, [dbo].[ivyt_Accounts] d, [dbo].[ivyt_UserRoleType] e
where 
 ((b.OperatorID = @UserID and c.UnitID = b.UnitID and d.AccountID = b.OperatorID and d.RoleTypeID = e.RoleTypeID and e.RoleType = 'DataEntry') or
 (b.VerifiedByID = @UserID and c.UnitID = b.UnitID and d.AccountID = b.OperatorID and d.RoleTypeID = e.RoleTypeID and e.RoleType = 'DataEverify'))

end
GO
/****** Object:  Table [dbo].[ivyt_ApplicantType]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ivyt_ApplicantType](
	[TypeID] [int] NOT NULL,
	[ApplicantTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_ivyt_ApplicantType] PRIMARY KEY CLUSTERED 
(
	[TypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[ivyt_ApplicantType] ([TypeID], [ApplicantTypeName]) VALUES (1, N'Domestic')
INSERT [dbo].[ivyt_ApplicantType] ([TypeID], [ApplicantTypeName]) VALUES (2, N'International')
/****** Object:  Table [dbo].[ivyt_AdmissionPolicy]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ivyt_AdmissionPolicy](
	[UnitID] [int] NULL,
	[HasClosingDate] [varchar](5) NULL,
	[IntlHasClosingDate] [varchar](5) NULL,
	[EarlyActionPlanAvailable] [varchar](5) NULL,
	[EarlyDecisionPlanAvailable] [varchar](5) NULL,
	[EarlyAdmissionAvailable] [varchar](5) NULL,
	[OpenAdmission] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Tb_Summer_Priority_Dates]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tb_Summer_Priority_Dates](
	[Spring_Application_Id] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedByID] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[UniversityID] [int] NOT NULL,
	[ApplicantType] [int] NOT NULL,
	[Decision_Offered] [varchar](50) NULL,
	[Decision_Deadline] [varchar](50) NULL,
	[Decision_Notification] [varchar](50) NULL,
	[Deposit_Deadline] [varchar](50) NULL,
	[Financial_Aid_Deadline] [varchar](50) NULL,
	[Notes] [varchar](500) NULL,
	[Data_URL] [varchar](500) NULL,
	[Spring_Comments] [varchar](500) NULL,
	[Spring_Status] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Tb_Summer_Priority_Dates] ON
INSERT [dbo].[Tb_Summer_Priority_Dates] ([Spring_Application_Id], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UniversityID], [ApplicantType], [Decision_Offered], [Decision_Deadline], [Decision_Notification], [Deposit_Deadline], [Financial_Aid_Deadline], [Notes], [Data_URL], [Spring_Comments], [Spring_Status]) VALUES (3, CAST(0x0000A43E015BAE1E AS DateTime), 1, CAST(0x0000A43F01712C64 AS DateTime), 450704, 1, N'', N'February 16,February 17', N'February 16,February 17', N'February 16,February 17', N'', N'', N'', N'Pri', N'Pass')
INSERT [dbo].[Tb_Summer_Priority_Dates] ([Spring_Application_Id], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UniversityID], [ApplicantType], [Decision_Offered], [Decision_Deadline], [Decision_Notification], [Deposit_Deadline], [Financial_Aid_Deadline], [Notes], [Data_URL], [Spring_Comments], [Spring_Status]) VALUES (4, CAST(0x0000A43E015BAE22 AS DateTime), 1, CAST(0x0000A43F01712C64 AS DateTime), 450704, 2, N'', N'February 16,February 17', N'February 16,February 17', N'February 16,February 17', N'', N'', N'', N'Pri', N'Pass')
SET IDENTITY_INSERT [dbo].[Tb_Summer_Priority_Dates] OFF
/****** Object:  Table [dbo].[Tb_Summer_Application_Dates]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tb_Summer_Application_Dates](
	[Spring_Application_Id] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedByID] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[UniversityID] [int] NOT NULL,
	[ApplicantType] [int] NOT NULL,
	[Admission_Deadline] [varchar](50) NULL,
	[Admission_Notification] [varchar](50) NULL,
	[Deposit_Deadline] [varchar](50) NULL,
	[Accept_Offer] [varchar](50) NULL,
	[Admission_WaitingListUsed] [varchar](50) NULL,
	[Defer_Admission] [varchar](50) NULL,
	[Transfer_Admission] [varchar](50) NULL,
	[Financial_Aid_Deadline] [varchar](50) NULL,
	[Notes] [varchar](500) NULL,
	[Data_URL] [varchar](500) NULL,
	[Spring_Comments] [varchar](500) NULL,
	[Spring_Status] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Tb_Summer_Application_Dates] ON
INSERT [dbo].[Tb_Summer_Application_Dates] ([Spring_Application_Id], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UniversityID], [ApplicantType], [Admission_Deadline], [Admission_Notification], [Deposit_Deadline], [Accept_Offer], [Admission_WaitingListUsed], [Defer_Admission], [Transfer_Admission], [Financial_Aid_Deadline], [Notes], [Data_URL], [Spring_Comments], [Spring_Status]) VALUES (3, CAST(0x0000A44A0174852E AS DateTime), 1, CAST(0x0000A44A0174852E AS DateTime), 450703, 1, N'03-Feb', N'09-Feb', N'17-Feb', N'16-Feb', N'Yes11', N'', N'', N'', N'', N'', N'', N'Process')
INSERT [dbo].[Tb_Summer_Application_Dates] ([Spring_Application_Id], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UniversityID], [ApplicantType], [Admission_Deadline], [Admission_Notification], [Deposit_Deadline], [Accept_Offer], [Admission_WaitingListUsed], [Defer_Admission], [Transfer_Admission], [Financial_Aid_Deadline], [Notes], [Data_URL], [Spring_Comments], [Spring_Status]) VALUES (4, CAST(0x0000A44A01748533 AS DateTime), 1, CAST(0x0000A44A01748533 AS DateTime), 450703, 2, N'02-Feb', N'11-Feb', N'26-Feb', N'25-Feb', N'Yes', N'', N'', N'', N'', N'', N'', N'Process')
SET IDENTITY_INSERT [dbo].[Tb_Summer_Application_Dates] OFF
/****** Object:  Table [dbo].[Tb_Spring_Priority_Dates]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tb_Spring_Priority_Dates](
	[Spring_Application_Id] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedByID] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[UniversityID] [int] NOT NULL,
	[ApplicantType] [int] NOT NULL,
	[Decision_Offered] [varchar](50) NULL,
	[Decision_Deadline] [varchar](50) NULL,
	[Decision_Notification] [varchar](50) NULL,
	[Deposit_Deadline] [varchar](50) NULL,
	[Financial_Aid_Deadline] [varchar](50) NULL,
	[Notes] [varchar](500) NULL,
	[Data_URL] [varchar](500) NULL,
	[Spring_Comments] [varchar](500) NULL,
	[Spring_Status] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Tb_Spring_Priority_Dates] ON
INSERT [dbo].[Tb_Spring_Priority_Dates] ([Spring_Application_Id], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UniversityID], [ApplicantType], [Decision_Offered], [Decision_Deadline], [Decision_Notification], [Deposit_Deadline], [Financial_Aid_Deadline], [Notes], [Data_URL], [Spring_Comments], [Spring_Status]) VALUES (3, CAST(0x0000A43E015A8DD1 AS DateTime), 1, CAST(0x0000A43E015A8DD1 AS DateTime), 450704, 1, N'', N'February 13,February 14', N'February 13,February 14', N'February 13,February 14', N'', N'', N'', N'', N'Process')
INSERT [dbo].[Tb_Spring_Priority_Dates] ([Spring_Application_Id], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UniversityID], [ApplicantType], [Decision_Offered], [Decision_Deadline], [Decision_Notification], [Deposit_Deadline], [Financial_Aid_Deadline], [Notes], [Data_URL], [Spring_Comments], [Spring_Status]) VALUES (4, CAST(0x0000A43E015A8DD6 AS DateTime), 1, CAST(0x0000A43E015A8DD6 AS DateTime), 450704, 2, N'', N'February 13,February 14', N'February 13,February 14', N'February 13,February 14', N'', N'', N'', N'', N'Process')
SET IDENTITY_INSERT [dbo].[Tb_Spring_Priority_Dates] OFF
/****** Object:  Table [dbo].[Tb_Spring_Application_Dates]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tb_Spring_Application_Dates](
	[Spring_Application_Id] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedByID] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[UniversityID] [int] NOT NULL,
	[ApplicantType] [int] NOT NULL,
	[Admission_Deadline] [varchar](50) NULL,
	[Admission_Notification] [varchar](50) NULL,
	[Deposit_Deadline] [varchar](50) NULL,
	[Accept_Offer] [varchar](50) NULL,
	[Admission_WaitingListUsed] [varchar](50) NULL,
	[Defer_Admission] [varchar](50) NULL,
	[Transfer_Admission] [varchar](50) NULL,
	[Financial_Aid_Deadline] [varchar](50) NULL,
	[Notes] [varchar](500) NULL,
	[Data_URL] [varchar](500) NULL,
	[Spring_Comments] [varchar](500) NULL,
	[Spring_Status] [varchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_Fall_Early_Admission]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_Fall_Early_Admission](
	[Early_Application_id] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedByID] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[UniversityID] [int] NOT NULL,
	[ApplicantType] [int] NOT NULL,
	[Early_Decision_Offered] [varchar](50) NULL,
	[Earlr_Notification] [varchar](50) NULL,
	[Early_Decision_Deadline] [varchar](50) NULL,
	[Early_Deposit_Deadline] [varchar](50) NULL,
	[Early_Financial_Aid_Deadline] [varchar](50) NULL,
	[Early_Action_offered] [varchar](50) NULL,
	[Early_Action_Deadline] [varchar](50) NULL,
	[Early_Action_Notification] [varchar](50) NULL,
	[Early_Notes] [varchar](500) NULL,
	[Data_URL] [varchar](500) NULL,
	[Early_Status] [varchar](50) NULL,
	[Early_Comments] [varchar](500) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ivyt_Users]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ivyt_Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[EmailAddress] [nvarchar](150) NOT NULL,
	[Password] [nvarchar](150) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[UserRoleTypeID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK__ivyt_Acc__349DA5860519C6AF] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ivyt_Users] ON
INSERT [dbo].[ivyt_Users] ([UserID], [EmailAddress], [Password], [IsActive], [UserRoleTypeID], [CreatedDate]) VALUES (1, N'manager@universityapp.com', N'manager', 1, 1, CAST(0x0000A29500000000 AS DateTime))
INSERT [dbo].[ivyt_Users] ([UserID], [EmailAddress], [Password], [IsActive], [UserRoleTypeID], [CreatedDate]) VALUES (2, N'user1@universityapp.com', N'user1', 1, 2, CAST(0x0000A29500000000 AS DateTime))
INSERT [dbo].[ivyt_Users] ([UserID], [EmailAddress], [Password], [IsActive], [UserRoleTypeID], [CreatedDate]) VALUES (3, N'user2@universityapp.com', N'user2', 1, 3, CAST(0x0000A29500000000 AS DateTime))
SET IDENTITY_INSERT [dbo].[ivyt_Users] OFF
/****** Object:  Table [dbo].[ivyt_UniversityAssignments]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ivyt_UniversityAssignments](
	[AssignmentID] [int] IDENTITY(1,1) NOT NULL,
	[UniversityID] [int] NOT NULL,
	[OperatorID] [int] NOT NULL,
	[AssignedDate] [datetime] NULL,
	[AssignedByID] [int] NULL,
	[CollectStartDate] [datetime] NULL,
	[CollectSubmitDate] [datetime] NULL,
	[Status] [nvarchar](20) NULL,
	[PassReview] [bit] NULL,
	[VerifiedDate] [datetime] NULL,
	[VerifiedByID] [int] NULL,
	[Comments] [nvarchar](1000) NULL,
 CONSTRAINT [PK_ivyt_UniversityAssignments_1] PRIMARY KEY CLUSTERED 
(
	[UniversityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ivyt_UniversityAssignments] UNIQUE NONCLUSTERED 
(
	[UniversityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ivyt_UniversityAssignments] ON
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (1, 450703, 2, CAST(0x0000A29900BC943F AS DateTime), NULL, CAST(0x0000A2AE010CBD50 AS DateTime), NULL, N'Started', 0, NULL, NULL, N'Capture all information in admission date')
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (2, 450704, 2, CAST(0x0000A29900BCA15F AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (3, 450705, 2, CAST(0x0000A29900C03232 AS DateTime), NULL, CAST(0x0000A2AE00DD3092 AS DateTime), NULL, N'Started', NULL, NULL, NULL, N'Priority information required')
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (4, 450706, 2, CAST(0x0000A29900C0323C AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (5, 450707, 2, CAST(0x0000A29900C06FFF AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (6, 450708, 2, CAST(0x0000A29900C07003 AS DateTime), NULL, CAST(0x0000A2AE0107A6DD AS DateTime), CAST(0x0000A2AE0108C911 AS DateTime), N'Completed', 0, NULL, NULL, N'missing info1')
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (7, 450709, 2, CAST(0x0000A29900C28297 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (8, 450710, 2, CAST(0x0000A29900C2B04A AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (9, 450711, 2, CAST(0x0000A29900C2B04C AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (14, 450712, 2, CAST(0x0000A29900CB26F6 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (36, 450713, 3, CAST(0x0000A2AE010BC418 AS DateTime), 1, NULL, NULL, NULL, 1, CAST(0x0000A2ED0007F5E0 AS DateTime), 3, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (11, 450714, 2, CAST(0x0000A29900C8B6B2 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (39, 450715, 2, CAST(0x0000A2FA001459E8 AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (15, 450718, 2, CAST(0x0000A29900CD48DB AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (16, 450719, 2, CAST(0x0000A29900CD9A4B AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (12, 450720, 2, CAST(0x0000A29900C8CF33 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (13, 450722, 2, CAST(0x0000A29900C8CF37 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (17, 450723, 2, CAST(0x0000A29900CDB6D7 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (18, 450724, 2, CAST(0x0000A29900CDB6D9 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (32, 450725, 2, CAST(0x0000A2AD0153D56C AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (34, 450727, 3, CAST(0x0000A2AE01050268 AS DateTime), 1, NULL, NULL, NULL, 0, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (19, 450728, 2, CAST(0x0000A29900D52AAA AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (20, 450729, 2, CAST(0x0000A29900D52AAE AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (31, 450730, 2, CAST(0x0000A2AD0152E50F AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (35, 450731, 3, CAST(0x0000A2AE01050296 AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (37, 450734, 3, CAST(0x0000A2AE010BC42D AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (38, 450737, 3, CAST(0x0000A2AE010F10F4 AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (21, 450762, 2, CAST(0x0000A29900EEADF1 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (22, 450763, 2, CAST(0x0000A29900EEAE7A AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (23, 450764, 2, CAST(0x0000A29900EEAE7B AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (24, 450765, 2, CAST(0x0000A29900EEAE7C AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (25, 450766, 2, CAST(0x0000A29900EEAE7D AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (26, 450767, 2, CAST(0x0000A29900EEAE7D AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (27, 450768, 2, CAST(0x0000A29900EEAE7E AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (28, 450769, 2, CAST(0x0000A29900EEAE7F AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (29, 450770, 2, CAST(0x0000A29900EEAE7F AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (30, 450771, 2, CAST(0x0000A29900EEAE81 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (40, 450809, 3, CAST(0x0000A305016DC081 AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (41, 450810, 3, CAST(0x0000A305016DC0F3 AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (42, 450811, 3, CAST(0x0000A305016DC0FE AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (43, 450812, 3, CAST(0x0000A305016DC101 AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (44, 450813, 3, CAST(0x0000A305016DDF47 AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (46, 450816, 3, CAST(0x0000A305016DDF60 AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_UniversityAssignments] ([AssignmentID], [UniversityID], [OperatorID], [AssignedDate], [AssignedByID], [CollectStartDate], [CollectSubmitDate], [Status], [PassReview], [VerifiedDate], [VerifiedByID], [Comments]) VALUES (45, 450825, 3, CAST(0x0000A305016DDF4E AS DateTime), 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[ivyt_UniversityAssignments] OFF
/****** Object:  Table [dbo].[ivyt_AdmissionFees]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ivyt_AdmissionFees](
	[AdmissionFeeID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedByID] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[UniversityID] [int] NOT NULL,
	[ApplicantType] [int] NOT NULL,
	[ApplicationFee] [numeric](6, 2) NULL,
	[ApplicationFeeWaiver] [nvarchar](20) NULL,
	[FeeWaiverNotes] [nvarchar](500) NULL,
	[FeeDataURL] [nvarchar](500) NULL,
	[AdmissionFees_Status] [varchar](20) NULL,
	[AdmissionFees_Comments] [varchar](max) NULL,
 CONSTRAINT [PK_ivyt_AdmissionFees] PRIMARY KEY CLUSTERED 
(
	[AdmissionFeeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ivyt_AdmissionDates]    Script Date: 02/26/2015 16:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ivyt_AdmissionDates](
	[AdmissionDateID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedByID] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[UnitID] [int] NOT NULL,
	[ApplicantType] [int] NOT NULL,
	[Semester] [int] NOT NULL,
	[ApplicationDeadline] [nvarchar](50) NULL,
	[AdmissionNotificationDate] [nvarchar](50) NULL,
	[DepositDeadline] [nvarchar](50) NULL,
	[AcceptOfferDeadline] [nvarchar](50) NULL,
	[WaitingListUsed] [nvarchar](50) NULL,
	[DeferAdmission] [nvarchar](50) NULL,
	[TransferAdmission] [nvarchar](50) NULL,
	[FinancialAidAppDeadline] [nvarchar](50) NULL,
	[AdmissionNotes] [nvarchar](50) NULL,
	[DataURL] [nvarchar](50) NULL,
	[PriorityDecisionOffered] [nvarchar](50) NULL,
	[PriorityDecisionDeadline] [nvarchar](50) NULL,
	[PriorityDecisionNotificationDate] [nvarchar](50) NULL,
	[PriorityDecisionDepositDeadline] [nvarchar](50) NULL,
	[PriorityFinancialAidAppDeadline] [nvarchar](50) NULL,
	[PriorityActionOffered] [nvarchar](50) NULL,
	[PriorityActionDeadline] [nvarchar](50) NULL,
	[PriorityActionNotificationDate] [nvarchar](50) NULL,
	[PriorityAdmissionNotes] [nvarchar](50) NULL,
	[PriorityDataURL] [nvarchar](50) NULL,
 CONSTRAINT [PK_ivyt_AdmissionDates] PRIMARY KEY CLUSTERED 
(
	[AdmissionDateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ivyt_AdmissionDates] ON
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (25, CAST(0x0000A2AD017EABDB AS DateTime), 2, CAST(0x0000A2AE0108C910 AS DateTime), 450708, 1, 1, N'15-Jan', N'01-Apr', N'01-May', N'01-May', N'Yes', N'Yes', N'Accepted', NULL, NULL, NULL, N'Yes', N'Nov 1, Jan 1', N'Dec 15, Feb 15', N'Dec 15, Feb 15', NULL, N'No', NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (26, CAST(0x0000A2AD017ED5D7 AS DateTime), 2, CAST(0x0000A2AE0108C910 AS DateTime), 450708, 2, 1, N'15-Jan', N'01-Apr', N'01-May', N'01-May', N'Yes', N'Yes', N'Not Accepted', NULL, NULL, NULL, N'Yes', N'Nov 1, Jan 1', N'Dec 15, Feb 15', N'Dec 15, Feb 15', NULL, N'No', NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (27, CAST(0x0000A2AD017F0274 AS DateTime), 2, CAST(0x0000A2AE0108C910 AS DateTime), 450708, 1, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (28, CAST(0x0000A2AD017F432A AS DateTime), 2, CAST(0x0000A2AE0108C911 AS DateTime), 450708, 2, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (29, CAST(0x0000A2AD017F5F43 AS DateTime), 2, CAST(0x0000A2AE0108C911 AS DateTime), 450708, 1, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (30, CAST(0x0000A2AD017F7926 AS DateTime), 2, CAST(0x0000A2AE0108C911 AS DateTime), 450708, 2, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (31, CAST(0x0000A2AE00DD308D AS DateTime), 2, CAST(0x0000A2AE00DD308D AS DateTime), 450705, 1, 1, N'15-Jan', N'01-Apr', N'01-May', N'01-May', N'Yes', N'Yes', N'Accepted', NULL, NULL, NULL, N'Yes', N'Nov 1, Jan 1', N'Dec 15, Feb 15', N'Dec 15, Feb 15', NULL, N'No', NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (32, CAST(0x0000A2AE00DD308D AS DateTime), 2, CAST(0x0000A2AE00DD308D AS DateTime), 450705, 2, 1, N'15-Jan', N'01-Apr', N'01-May', N'01-May', N'Yes', N'Yes', N'Not Accepted', NULL, NULL, NULL, N'Yes', N'Nov 1, Jan 1', N'Dec 15, Feb 15', N'Dec 15, Feb 15', NULL, N'No', NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (33, CAST(0x0000A2AE00DD308E AS DateTime), 2, CAST(0x0000A2AE00DD308E AS DateTime), 450705, 1, 2, N'15-Jan', N'01-Apr', N'01-May', N'01-May', N'Yes', N'Yes', N'Accepted', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (34, CAST(0x0000A2AE00DD308E AS DateTime), 2, CAST(0x0000A2AE00DD308E AS DateTime), 450705, 2, 2, N'15-Jan', N'01-Apr', N'01-May', N'01-May', N'Yes', N'Yes', N'Not Accepted', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (35, CAST(0x0000A2AE00DD308E AS DateTime), 2, CAST(0x0000A2AE00DD308E AS DateTime), 450705, 1, 3, N'15-Jan', N'01-Apr', N'01-May', N'01-May', N'Yes', N'Yes', N'Accepted', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (36, CAST(0x0000A2AE00DD308F AS DateTime), 2, CAST(0x0000A2AE00DD308F AS DateTime), 450705, 2, 3, N'15-Jan', N'01-Apr', N'01-May', N'01-May', N'Yes', N'Yes', N'Not Accepted', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (37, CAST(0x0000A2AE010CBD4E AS DateTime), 2, CAST(0x0000A2AE010CBD4E AS DateTime), 450703, 1, 1, N'15-Feb', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (38, CAST(0x0000A2AE010CBD4E AS DateTime), 2, CAST(0x0000A2AE010CBD4E AS DateTime), 450703, 2, 1, N'15-Feb', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (39, CAST(0x0000A2AE010CBD4F AS DateTime), 2, CAST(0x0000A2AE010CBD4F AS DateTime), 450703, 1, 2, N'15-Feb', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (40, CAST(0x0000A2AE010CBD4F AS DateTime), 2, CAST(0x0000A2AE010CBD4F AS DateTime), 450703, 2, 2, N'15-Feb', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (41, CAST(0x0000A2AE010CBD4F AS DateTime), 2, CAST(0x0000A2AE010CBD4F AS DateTime), 450703, 1, 3, N'15-Feb', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[ivyt_AdmissionDates] ([AdmissionDateID], [CreatedDate], [LastModifiedByID], [LastModifiedDate], [UnitID], [ApplicantType], [Semester], [ApplicationDeadline], [AdmissionNotificationDate], [DepositDeadline], [AcceptOfferDeadline], [WaitingListUsed], [DeferAdmission], [TransferAdmission], [FinancialAidAppDeadline], [AdmissionNotes], [DataURL], [PriorityDecisionOffered], [PriorityDecisionDeadline], [PriorityDecisionNotificationDate], [PriorityDecisionDepositDeadline], [PriorityFinancialAidAppDeadline], [PriorityActionOffered], [PriorityActionDeadline], [PriorityActionNotificationDate], [PriorityAdmissionNotes], [PriorityDataURL]) VALUES (42, CAST(0x0000A2AE010CBD4F AS DateTime), 2, CAST(0x0000A2AE010CBD4F AS DateTime), 450703, 2, 3, N'15-Feb', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[ivyt_AdmissionDates] OFF
/****** Object:  StoredProcedure [dbo].[Sp_Insert_Fall_Application_Dates]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Insert_Fall_Application_Dates] 
@LastModifiedByID int,
@UniversityID int ,
@ApplicantType int, 
@Admission_Deadline varchar(50) ,
	@Admission_Notification varchar(50) ,
	@Admission_Deposit_Deadline Varchar(50) ,
	@Admission_Offer varchar(50) ,
	@Admission_WaitingListUsed varchar(50) ,
	@Defer_Admission varchar(50) ,
	@Transfer_Admission varchar(50) ,
	@Application_Deadline varchar(50) ,
	@Admission_Notes varchar(500) ,
	@Data_URL varchar(500) 
	as
	begin
	
	insert into TB_Fall_Application_Dates 
	(
	CreatedDate,LastModifiedByID,LastModifiedDate,UniversityID,
	ApplicantType,Admission_Deadline,Admission_Notification,
	Admission_Deposit_Deadline,Admission_Offer,
	Admission_WaitingListUsed,Defer_Admission,Transfer_Admission,
	Application_Deadline,Admission_Notes,Data_URL,
	Fall_Status,Fall_Comments
	)
	values(
	GETDATE(),@LastModifiedByID,GETDATE(),@UniversityID,
	@ApplicantType,@Admission_Deadline,@Admission_Notification,
	@Admission_Deposit_Deadline,@Admission_Offer,
	@Admission_WaitingListUsed,@Defer_Admission,@Transfer_Admission,
	@Application_Deadline,@Admission_Notes,@Data_URL,
	'Process',''
	)
	
IF @@ERROR = 0 AND @@ROWCOUNT =1                            
Begin                            
Select top 1 Fall_Application_id   from TB_Fall_Application_Dates Order by Fall_Application_id Desc                            
End                            
                            
Else                             
Begin                            
Select 0                            
End        
          
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Select_TB_Fall_Application_Dates]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Select_TB_Fall_Application_Dates]  
@UniversityID int  
as  
begin  
select * from TB_Fall_Application_Dates 
where UniversityID=@UniversityID  
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_delete_Fall_Application_Dates1]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_delete_Fall_Application_Dates1]    
@UniversityID int   
 as  
 begin  
   
delete TB_Fall_Application_Dates   
 where UniversityID=@UniversityID       
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Fall_Application_Dates1]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Update_Fall_Application_Dates1]   
@LastModifiedByID int,  
@UniversityID int ,  
@ApplicantType int,   
@Admission_Deadline varchar(50) ,  
 @Admission_Notification varchar(50) ,  
 @Admission_Deposit_Deadline Varchar(50) ,  
 @Admission_Offer varchar(50) ,  
 @Admission_WaitingListUsed varchar(50) ,  
 @Defer_Admission varchar(50) ,  
 @Transfer_Admission varchar(50) ,  
 @Application_Deadline varchar(50) ,  
 @Admission_Notes varchar(500) ,  
 @Data_URL varchar(500)   
 as  
 begin  
   
update TB_Fall_Application_Dates   
set 
 LastModifiedByID=LastModifiedByID,LastModifiedDate=getdate(),
 Admission_Deadline=@Admission_Deadline,Admission_Notification=@Admission_Notification,  
 Admission_Deposit_Deadline=@Admission_Deposit_Deadline,Admission_Offer=@Admission_Offer,  
 Admission_WaitingListUsed=@Admission_WaitingListUsed,Defer_Admission=@Defer_Admission,
 Transfer_Admission=@Transfer_Admission,  
 Application_Deadline=@Application_Deadline,Admission_Notes=@Admission_Notes,Data_URL=@Data_URL 
 where UniversityID=@UniversityID and ApplicantType=@ApplicantType
  
 
   
IF @@ERROR = 0 AND @@ROWCOUNT =1                              
Begin                              
Select  Fall_Application_id  from TB_Fall_Application_Dates where UniversityID=@UniversityID and ApplicantType=@ApplicantType                          
End                              
                              
Else                               
Begin                              
Select 0                              
End          
            
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Fall_Application_Dates  ]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Update_Fall_Application_Dates  ]  
@user_id int,            
@UniversityID int,  
@AdmissionFees_Comments varchar(max),  
@Status varchar(20)            
as            
begin           
update TB_Fall_Application_Dates    
set  
Fall_Status=@Status,Fall_Comments=@AdmissionFees_Comments,  
LastModifiedByID=@user_id,LastModifiedDate=GETDATE()  
  
where UniversityID=@UniversityID  
  
IF @@ERROR = 0 AND @@ROWCOUNT =1                                
Begin                                
Select Fall_Application_id   from TB_Fall_Application_Dates where UniversityID=@UniversityID                           
End                                
                                
Else                                 
Begin                                
Select 0                                
End            
              
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Select_ivyt_Universities]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Select_ivyt_Universities]
as
begin
select * from  ivyt_Universities 
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Select_ivyt_AdmissionFees]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Select_ivyt_AdmissionFees]
@UniversityID int
as
begin
select * from ivyt_AdmissionFees where UniversityID=@UniversityID
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Insert_AdmissionFeeid]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Insert_AdmissionFeeid]
@LastModifiedByID int,
@UniversityID int ,
	@ApplicantType int ,
	@ApplicationFee numeric(6, 2) ,
	@ApplicationFeeWaiver nvarchar(20) ,
	@FeeWaiverNotes nvarchar(500) ,
	@FeeDataURL nvarchar(500)
	as
	begin
	insert into [ivyt_AdmissionFees]
	(
	[CreatedDate],
	[LastModifiedByID],
	[LastModifiedDate]  ,
	[UniversityID],
	[ApplicantType] ,
	[ApplicationFee] ,
	[ApplicationFeeWaiver],
	[FeeWaiverNotes],
	[FeeDataURL] ,
	[AdmissionFees_Status],
	[AdmissionFees_Comments] 
	)
	values
	(
	getdate(),@LastModifiedByID,getdate(),
	@UniversityID,@ApplicantType,@ApplicationFee,@ApplicationFeeWaiver,
	@FeeWaiverNotes,@FeeDataURL,'Process',' '
	)
	
	IF @@ERROR = 0 AND @@ROWCOUNT =1                            
Begin                            
Select top 1 AdmissionFeeID   from [ivyt_AdmissionFees] Order by AdmissionFeeID Desc                            
End                            
                            
Else                             
Begin                            
Select 0                            
End        
          
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_AdmissionFeeid1]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Update_AdmissionFeeid1]  
@LastModifiedByID int,  
@UniversityID int ,  
 @ApplicantType int ,  
 @ApplicationFee numeric(6, 2) ,  
 @ApplicationFeeWaiver nvarchar(20) ,  
 @FeeWaiverNotes nvarchar(500) ,  
 @FeeDataURL nvarchar(500)  
 as  
 begin  
 update [ivyt_AdmissionFees] set  
 LastModifiedByID=@LastModifiedByID,
 [LastModifiedDate]=getdate(),
[ApplicationFee] =@ApplicationFee,  
 [ApplicationFeeWaiver]=@ApplicationFeeWaiver,  
 [FeeWaiverNotes]=@FeeWaiverNotes,  
 [FeeDataURL]=@FeeDataURL
 where
 ApplicantType=@ApplicantType and UniversityID=@UniversityID

   
 IF @@ERROR = 0 AND @@ROWCOUNT =1                              
Begin                              
Select  AdmissionFeeID   from [ivyt_AdmissionFees] where UniversityID=@UniversityID                            
End                              
                              
Else                               
Begin                              
Select 0                              
End          
            
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_AdmissionFeeid]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Update_AdmissionFeeid]
@user_id int,          
@UniversityID int,
@AdmissionFees_Comments varchar(max),
@Status varchar(20)          
as          
begin          
update ivyt_AdmissionFees  
set
AdmissionFees_Status=@Status,AdmissionFees_Comments=@AdmissionFees_Comments,
LastModifiedByID=@user_id,LastModifiedDate=GETDATE()

where UniversityID=@UniversityID

IF @@ERROR = 0 AND @@ROWCOUNT =1                              
Begin                              
Select AdmissionFeeID   from [ivyt_AdmissionFees] where UniversityID=@UniversityID                         
End                              
                              
Else                               
Begin                              
Select 0                              
End          
            
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Delete_AdmissionFeeid1]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Delete_AdmissionFeeid1]  
@UniversityID int   

 as  
 begin  
delete ivyt_AdmissionFees where UniversityID=@UniversityID          
      end
GO
/****** Object:  StoredProcedure [dbo].[SP_Select_Login]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_Select_Login]
@EmailAddress varchar(150),
@Password varchar(150)
as
begin
select * from ivyt_Users where EmailAddress=@EmailAddress and Password=@Password
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Select_Tb_Summer_Priority_Dates]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Select_Tb_Summer_Priority_Dates]        
@UniversityID int        
as        
begin        
select * from Tb_Summer_Priority_Dates
where UniversityID=@UniversityID        
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Insert_Summer_Priority_Admission]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Insert_Summer_Priority_Admission] 
@LastModifiedByID int,
@UniversityID int ,
@ApplicantType int, 
@Decision_Offered varchar(50) ,
	@Decision_Deadline varchar(50) ,
	@Decision_Notification varchar(50) ,
	@Deposit_Deadline varchar(50) ,
	@Financial_Aid_Deadline varchar(50) ,
	@Notes varchar(500) ,
	@Data_URL varchar(500) 
 
	as
	begin
	
	insert into Tb_Summer_Priority_Dates(
	[CreatedDate],
	[LastModifiedByID],
	[LastModifiedDate],
	[UniversityID],
	[ApplicantType],
	Decision_Offered  ,
	Decision_Deadline  ,
	Decision_Notification  ,
	Deposit_Deadline  ,
	Financial_Aid_Deadline  ,
	Notes ,
	Data_URL ,
	Spring_Comments ,
	Spring_Status
	)
	
	values(
	GETDATE(),@LastModifiedByID,GETDATE(),@UniversityID,
	@ApplicantType,@Decision_Offered  ,
	@Decision_Deadline  ,
	@Decision_Notification  ,
	@Deposit_Deadline  ,
	@Financial_Aid_Deadline  ,
	@Notes ,
	@Data_URL ,
	'' ,
	'Process'
	)
	
	IF @@ERROR = 0 AND @@ROWCOUNT =1                            
Begin                            
Select top 1 Spring_Application_Id   from Tb_Summer_Priority_Dates Order by Spring_Application_Id Desc                            
End                            
                            
Else                             
Begin                            
Select 0                            
End        
          
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Tb_Summer_Priority_Dates]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Update_Tb_Summer_Priority_Dates]     
@LastModifiedByID int,    
@UniversityID int ,    
@ApplicantType int,     
@Decision_Offered varchar(50) ,    
 @Decision_Deadline varchar(50) ,    
 @Decision_Notification varchar(50) ,    
 @Deposit_Deadline varchar(50) ,    
 @Financial_Aid_Deadline varchar(50) ,    
 @Notes varchar(500) ,    
 @Data_URL varchar(500)     
     
 as    
 begin    
     
update Tb_Summer_Priority_Dates set  
 LastModifiedByID=@LastModifiedByID,    
 LastModifiedDate=getdate(),    
 Decision_Offered =@Decision_Offered ,    
 Decision_Deadline =@Decision_Deadline ,    
 Decision_Notification=@Decision_Notification  ,    
 Deposit_Deadline=@Deposit_Deadline  ,    
 Financial_Aid_Deadline=@Financial_Aid_Deadline  ,    
 Notes=@Financial_Aid_Deadline ,    
 Data_URL =@Data_URL  
  where   
  UniversityID=@UniversityID and ApplicantType=@ApplicantType   
              
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Summer_pri_Application_Dates  ]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Update_Summer_pri_Application_Dates  ]    
@user_id int,              
@UniversityID int,    
@AdmissionFees_Comments varchar(max),    
@Status varchar(20)              
as              
begin           
update Tb_Summer_Priority_Dates 
set    
Spring_Status=@Status,Spring_Comments=@AdmissionFees_Comments,    
LastModifiedByID=@user_id,LastModifiedDate=GETDATE()    
    
where UniversityID=@UniversityID    
    
IF @@ERROR = 0 AND @@ROWCOUNT =1                                  
Begin                                  
Select Spring_Application_Id   from Tb_Summer_Priority_Dates where UniversityID=@UniversityID                             
End                                  
                                  
Else                                   
Begin                                  
Select 0                                  
End              
                
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Delete_Tb_Summer_Priority_Dates]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Delete_Tb_Summer_Priority_Dates]     
   
@UniversityID int   
     
 as    
 begin    
     
delete Tb_Summer_Priority_Dates 
  where   
  UniversityID=@UniversityID  
              
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Delete_Tb_Summer_Application_Dates]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Delete_Tb_Summer_Application_Dates]         
       
@UniversityID int       
 as        
 begin        
         
delete Tb_Summer_Application_Dates 
where UniversityID=@UniversityID  
         
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Summer_Application_Dates  ]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Update_Summer_Application_Dates  ]    
@user_id int,              
@UniversityID int,    
@AdmissionFees_Comments varchar(max),    
@Status varchar(20)              
as              
begin           
update Tb_Summer_Application_Dates
set    
Spring_Status=@Status,Spring_Comments=@AdmissionFees_Comments,    
LastModifiedByID=@user_id,LastModifiedDate=GETDATE()    
    
where UniversityID=@UniversityID    
    
IF @@ERROR = 0 AND @@ROWCOUNT =1                                  
Begin                                  
Select Spring_Application_Id   from Tb_Summer_Application_Dates where UniversityID=@UniversityID                             
End                                  
                                  
Else                                   
Begin                                  
Select 0                                  
End              
                
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Tb_Summer_Application_Dates]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Update_Tb_Summer_Application_Dates]         
@LastModifiedByID int,        
@UniversityID int ,        
@ApplicantType int,         
@Admission_Deadline varchar(50) ,        
 @Admission_Notification varchar(50) ,        
 @Deposit_Deadline varchar(50) ,        
 @Accept_Offer varchar(50) ,        
 @Admission_WaitingListUsed varchar(50) ,        
 @Defer_Admission varchar(50) ,        
 @Transfer_Admission varchar(50) ,        
 @Financial_Aid_Deadline varchar(50) ,        
 @Notes varchar(500) ,        
 @Data_URL varchar(500)        
 as        
 begin        
         
update Tb_Summer_Application_Dates set        
LastModifiedByID=@LastModifiedByID,        
LastModifiedDate=getdate(),           
Admission_Deadline=@Admission_Deadline ,        
Admission_Notification=@Admission_Notification ,        
Deposit_Deadline=@Deposit_Deadline ,        
Accept_Offer=@Accept_Offer ,        
Admission_WaitingListUsed=@Admission_WaitingListUsed ,        
Defer_Admission=@Defer_Admission ,        
Transfer_Admission=@Transfer_Admission ,        
Financial_Aid_Deadline=@Financial_Aid_Deadline ,        
Notes=@Notes,        
Data_URL =@Data_URL    
where UniversityID=@UniversityID  and  ApplicantType=@ApplicantType    
         
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Insert_Summer_Admission]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Insert_Summer_Admission]   
@LastModifiedByID int,  
@UniversityID int ,  
@ApplicantType int,   
@Admission_Deadline varchar(50) ,  
 @Admission_Notification varchar(50) ,  
 @Deposit_Deadline varchar(50) ,  
 @Accept_Offer varchar(50) ,  
 @Admission_WaitingListUsed varchar(50) ,  
 @Defer_Admission varchar(50) ,  
 @Transfer_Admission varchar(50) ,  
 @Financial_Aid_Deadline varchar(50) ,  
 @Notes varchar(500) ,  
 @Data_URL varchar(500)  
 as  
 begin  
   
 insert into Tb_Summer_Application_Dates (  
 [CreatedDate],  
 [LastModifiedByID],  
 [LastModifiedDate],  
 [UniversityID],  
 [ApplicantType],  
 [Admission_Deadline] ,  
 [Admission_Notification] ,  
 [Deposit_Deadline] ,  
 [Accept_Offer] ,  
 [Admission_WaitingListUsed] ,  
 [Defer_Admission] ,  
 [Transfer_Admission] ,  
 [Financial_Aid_Deadline] ,  
 [Notes],  
 [Data_URL],  
 [Spring_Comments],  
 [Spring_Status]  
 )  
   
 values(  
 GETDATE(),@LastModifiedByID,GETDATE(),@UniversityID,  
 @ApplicantType,@Admission_Deadline  ,  
 @Admission_Notification  ,  
 @Deposit_Deadline  ,  
 @Accept_Offer  ,  
 @Admission_WaitingListUsed  ,  
 @Defer_Admission  ,  
 @Transfer_Admission  ,  
 @Financial_Aid_Deadline  ,  
 @Notes ,  
 @Data_URL ,  
 '' ,  
 'Process'  
 )  
   
 IF @@ERROR = 0 AND @@ROWCOUNT =1                              
Begin                              
Select top 1 Spring_Application_Id   from Tb_Summer_Application_Dates Order by Spring_Application_Id Desc                              
End                              
                              
Else                               
Begin                              
Select 0                              
End          
            
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Select_Tb_Summer_Application_Datess]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Select_Tb_Summer_Application_Datess]      
@UniversityID int      
as      
begin      
select * from Tb_Summer_Application_Dates 
where UniversityID=@UniversityID      
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Select_Tb_Spring_Priority_Dates]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Select_Tb_Spring_Priority_Dates]              
@UniversityID int              
as              
begin              
select * from Tb_Spring_Priority_Dates      
where UniversityID=@UniversityID              
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Insert_Spring_Priority_Admission]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Insert_Spring_Priority_Admission] 
@LastModifiedByID int,
@UniversityID int ,
@ApplicantType int, 
@Decision_Offered varchar(50) ,
	@Decision_Deadline varchar(50) ,
	@Decision_Notification varchar(50) ,
	@Deposit_Deadline varchar(50) ,
	@Financial_Aid_Deadline varchar(50) ,
	@Notes varchar(500) ,
	@Data_URL varchar(500) 
 
	as
	begin
	
	insert into Tb_Spring_Priority_Dates(
	[CreatedDate],
	[LastModifiedByID],
	[LastModifiedDate],
	[UniversityID],
	[ApplicantType],
	Decision_Offered  ,
	Decision_Deadline  ,
	Decision_Notification  ,
	Deposit_Deadline  ,
	Financial_Aid_Deadline  ,
	Notes ,
	Data_URL ,
	Spring_Comments ,
	Spring_Status
	)
	
	values(
	GETDATE(),@LastModifiedByID,GETDATE(),@UniversityID,
	@ApplicantType,@Decision_Offered  ,
	@Decision_Deadline  ,
	@Decision_Notification  ,
	@Deposit_Deadline  ,
	@Financial_Aid_Deadline  ,
	@Notes ,
	@Data_URL ,
	'' ,
	'Process'
	)
	
	IF @@ERROR = 0 AND @@ROWCOUNT =1                            
Begin                            
Select top 1 Spring_Application_Id   from Tb_Spring_Priority_Dates Order by Spring_Application_Id Desc                            
End                            
                            
Else                             
Begin                            
Select 0                            
End        
          
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Spring_Priority_Application_Dates  ]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Update_Spring_Priority_Application_Dates  ]    
@user_id int,              
@UniversityID int,    
@AdmissionFees_Comments varchar(max),    
@Status varchar(20)              
as              
begin           
update Tb_Spring_Priority_Dates
set    
Spring_Status=@Status,Spring_Comments=@AdmissionFees_Comments,    
LastModifiedByID=@user_id,LastModifiedDate=GETDATE()    
    
where UniversityID=@UniversityID    
    
IF @@ERROR = 0 AND @@ROWCOUNT =1                                  
Begin                                  
Select Spring_Application_Id   from Tb_Spring_Priority_Dates where UniversityID=@UniversityID                             
End                                  
                                  
Else                                   
Begin                                  
Select 0                                  
End              
                
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Spring_Priority_Admission]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Update_Spring_Priority_Admission]   
@LastModifiedByID int,  
@UniversityID int ,  
@ApplicantType int,   
@Decision_Offered varchar(50) ,  
 @Decision_Deadline varchar(50) ,  
 @Decision_Notification varchar(50) ,  
 @Deposit_Deadline varchar(50) ,  
 @Financial_Aid_Deadline varchar(50) ,  
 @Notes varchar(500) ,  
 @Data_URL varchar(500)   
   
 as  
 begin  
   
update Tb_Spring_Priority_Dates set
 LastModifiedByID=@LastModifiedByID,  
 LastModifiedDate=getdate(),  
 Decision_Offered =@Decision_Offered ,  
 Decision_Deadline =@Decision_Deadline ,  
 Decision_Notification=@Decision_Notification  ,  
 Deposit_Deadline=@Deposit_Deadline  ,  
 Financial_Aid_Deadline=@Financial_Aid_Deadline  ,  
 Notes=@Financial_Aid_Deadline ,  
 Data_URL =@Data_URL
  where 
  UniversityID=@UniversityID and ApplicantType=@ApplicantType 
            
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Delete_Spring_Priority_Admission]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Delete_Spring_Priority_Admission]   
@UniversityID int   
   
 as  
 begin  
   
delete Tb_Spring_Priority_Dates
  where 
  UniversityID=@UniversityID
            
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_delete_Spring_Admission]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_delete_Spring_Admission]        
@UniversityID int  
 as    
 begin    
     
delete Tb_Spring_Application_Dates 
where UniversityID=@UniversityID  
     
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Spring_Application_Dates  ]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Update_Spring_Application_Dates  ]    
@user_id int,              
@UniversityID int,    
@AdmissionFees_Comments varchar(max),    
@Status varchar(20)              
as              
begin           
update Tb_Spring_Application_Dates
set    
Spring_Status=@Status,Spring_Comments=@AdmissionFees_Comments,    
LastModifiedByID=@user_id,LastModifiedDate=GETDATE()    
    
where UniversityID=@UniversityID    
    
IF @@ERROR = 0 AND @@ROWCOUNT =1                                  
Begin                                  
Select Spring_Application_Id   from Tb_Spring_Application_Dates where UniversityID=@UniversityID                             
End                                  
                                  
Else                                   
Begin                                  
Select 0                                  
End              
                
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Spring_Admission]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Update_Spring_Admission]       
@LastModifiedByID int,      
@UniversityID int ,      
@ApplicantType int,       
@Admission_Deadline varchar(50) ,      
 @Admission_Notification varchar(50) ,      
 @Deposit_Deadline varchar(50) ,      
 @Accept_Offer varchar(50) ,      
 @Admission_WaitingListUsed varchar(50) ,      
 @Defer_Admission varchar(50) ,      
 @Transfer_Admission varchar(50) ,      
 @Financial_Aid_Deadline varchar(50) ,      
 @Notes varchar(500) ,      
 @Data_URL varchar(500)      
 as      
 begin      
       
update Tb_Spring_Application_Dates set      
LastModifiedByID=@LastModifiedByID,      
LastModifiedDate=getdate(),         
Admission_Deadline=@Admission_Deadline ,      
Admission_Notification=@Admission_Notification ,      
Deposit_Deadline=@Deposit_Deadline ,      
Accept_Offer=@Accept_Offer ,      
Admission_WaitingListUsed=@Admission_WaitingListUsed ,      
Defer_Admission=@Defer_Admission ,      
Transfer_Admission=@Transfer_Admission ,      
Financial_Aid_Deadline=@Financial_Aid_Deadline ,      
Notes=@Notes,      
Data_URL =@Data_URL  
where UniversityID=@UniversityID  and  ApplicantType=@ApplicantType  
       
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Insert_Spring_Admission]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Insert_Spring_Admission]   
@LastModifiedByID int,  
@UniversityID int ,  
@ApplicantType int,   
@Admission_Deadline varchar(50) ,  
 @Admission_Notification varchar(50) ,  
 @Deposit_Deadline varchar(50) ,  
 @Accept_Offer varchar(50) ,  
 @Admission_WaitingListUsed varchar(50) ,  
 @Defer_Admission varchar(50) ,  
 @Transfer_Admission varchar(50) ,  
 @Financial_Aid_Deadline varchar(50) ,  
 @Notes varchar(500) ,  
 @Data_URL varchar(500)  
 as  
 begin  
   
 insert into Tb_Spring_Application_Dates(  
 [CreatedDate],  
 [LastModifiedByID],  
 [LastModifiedDate],  
 [UniversityID],  
 [ApplicantType],  
 [Admission_Deadline] ,  
 [Admission_Notification] ,  
 [Deposit_Deadline] ,  
 [Accept_Offer] ,  
 [Admission_WaitingListUsed] ,  
 [Defer_Admission] ,  
 [Transfer_Admission] ,  
 [Financial_Aid_Deadline] ,  
 [Notes],  
 [Data_URL],  
 [Spring_Comments],  
 [Spring_Status]  
 )  
   
 values(  
 GETDATE(),@LastModifiedByID,GETDATE(),@UniversityID,  
 @ApplicantType,@Admission_Deadline  ,  
 @Admission_Notification  ,  
 @Deposit_Deadline  ,  
 @Accept_Offer  ,  
 @Admission_WaitingListUsed  ,  
 @Defer_Admission  ,  
 @Transfer_Admission  ,  
 @Financial_Aid_Deadline  ,  
 @Notes ,  
 @Data_URL ,  
'','process'  
 )  
   
 IF @@ERROR = 0 AND @@ROWCOUNT =1                              
Begin                              
Select top 1 Spring_Application_Id   from Tb_Spring_Application_Dates Order by Spring_Application_Id Desc                              
End                              
                              
Else                               
Begin                              
Select 0                              
End          
            
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Select_Tb_Spring_Application_Dates]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Select_Tb_Spring_Application_Dates]    
@UniversityID int    
as    
begin    
select * from Tb_Spring_Application_Dates
where UniversityID=@UniversityID    
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Select_TB_Fall_Early_Admission]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Sp_Select_TB_Fall_Early_Admission]  
@UniversityID int  
as  
begin  
select * from TB_Fall_Early_Admission
where UniversityID=@UniversityID  
end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Insert_Early_Admission]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Insert_Early_Admission] 
@LastModifiedByID int,
@UniversityID int ,
@ApplicantType int, 
@Early_Decision_Offered varchar(50) ,
	@Earlr_Notification varchar(50) ,
	@Early_Decision_Deadline Varchar(50) ,
	@Early_Deposit_Deadline varchar(50) ,
	@Early_Financial_Aid_Deadline varchar(50) ,
	@Early_Action_offered varchar(50) ,
	@Early_Action_Deadline varchar(50) ,
	@Early_Action_Notification varchar(50) ,
	@Early_Notes varchar(500) ,
	@Data_URL varchar(500) 
	as
	begin
	
	insert into TB_Fall_Early_Admission(
	[CreatedDate],
	[LastModifiedByID],
	[LastModifiedDate],
	[UniversityID],
	[ApplicantType], 
	[Early_Decision_Offered] ,
	[Earlr_Notification] ,
	[Early_Decision_Deadline] ,
	[Early_Deposit_Deadline] ,
	[Early_Financial_Aid_Deadline] ,
	[Early_Action_offered] ,
	[Early_Action_Deadline] ,
	[Early_Action_Notification] ,
	[Early_Notes] ,
	[Data_URL],
	[Early_Status] ,
	[Early_Comments])
	values(
	GETDATE(),@LastModifiedByID,GETDATE(),@UniversityID,
	@ApplicantType,@Early_Decision_Offered ,
	@Earlr_Notification ,
	@Early_Decision_Deadline ,
	@Early_Deposit_Deadline ,
	@Early_Financial_Aid_Deadline ,
	@Early_Action_offered ,
	@Early_Action_Deadline ,
	@Early_Action_Notification ,
	@Early_Notes ,
	@Data_URL,'Process',''
	)
	
IF @@ERROR = 0 AND @@ROWCOUNT =1                            
Begin                            
Select top 1 Early_Application_id   from TB_Fall_Early_Admission Order by Early_Application_id Desc                            
End                            
                            
Else                             
Begin                            
Select 0                            
End        
          
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Early_Application_Dates  ]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Update_Early_Application_Dates  ]  
@user_id int,            
@UniversityID int,  
@AdmissionFees_Comments varchar(max),  
@Status varchar(20)            
as            
begin         
update TB_Fall_Early_Admission    
set  
Early_Status=@Status,Early_Comments=@AdmissionFees_Comments,  
LastModifiedByID=@user_id,LastModifiedDate=GETDATE()  
  
where UniversityID=@UniversityID  
  
IF @@ERROR = 0 AND @@ROWCOUNT =1                                
Begin                                
Select Early_Application_id   from TB_Fall_Early_Admission where UniversityID=@UniversityID                           
End                                
                                
Else                                 
Begin                                
Select 0                                
End            
              
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_Update_Early_Admission]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_Update_Early_Admission]   
@LastModifiedByID int,  
@UniversityID int ,  
@ApplicantType int,   
@Early_Decision_Offered varchar(50) ,  
 @Earlr_Notification varchar(50) ,  
 @Early_Decision_Deadline Varchar(50) ,  
 @Early_Deposit_Deadline varchar(50) ,  
 @Early_Financial_Aid_Deadline varchar(50) ,  
 @Early_Action_offered varchar(50) ,  
 @Early_Action_Deadline varchar(50) ,  
 @Early_Action_Notification varchar(50) ,  
 @Early_Notes varchar(500) ,  
 @Data_URL varchar(500)   
 as  
 begin  
   
update TB_Fall_Early_Admission set   
 LastModifiedByID=@LastModifiedByID,  
 LastModifiedDate=getdate(),     
 Early_Decision_Offered=@Early_Decision_Offered ,  
 Earlr_Notification=@Earlr_Notification ,  
 Early_Decision_Deadline=@Early_Decision_Deadline ,  
 Early_Deposit_Deadline=@Early_Deposit_Deadline ,  
 Early_Financial_Aid_Deadline=@Early_Financial_Aid_Deadline ,  
 Early_Action_offered=@Early_Action_offered ,  
 Early_Action_Deadline=@Early_Action_Deadline ,  
 Early_Action_Notification=@Early_Action_Notification ,  
 Early_Notes=@Early_Notes ,  
 Data_URL=@Data_URL
 where
 UniversityID=@UniversityID and  
 ApplicantType=@ApplicantType
 
   
IF @@ERROR = 0 AND @@ROWCOUNT =1                              
Begin                              
Select top 1 Early_Application_id   from TB_Fall_Early_Admission Order by Early_Application_id Desc                              
End                              
                              
Else                               
Begin                              
Select 0                              
End          
            
      end
GO
/****** Object:  StoredProcedure [dbo].[Sp_delete_Early_Admission]    Script Date: 02/26/2015 16:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_delete_Early_Admission]   

@UniversityID int  
 as  
 begin  
   
delete TB_Fall_Early_Admission 
 where
 UniversityID=@UniversityID 
 
     
      end
GO
/****** Object:  Default [DF__ivyt_Data__Colle__145C0A3F]    Script Date: 02/26/2015 16:49:03 ******/
ALTER TABLE [dbo].[ivyt_UniversityAssignments] ADD  CONSTRAINT [DF__ivyt_Data__Colle__145C0A3F]  DEFAULT (getdate()) FOR [AssignedDate]
GO
/****** Object:  ForeignKey [FK_ivyt_AdmissionDates_ivyt_Universities]    Script Date: 02/26/2015 16:49:03 ******/
ALTER TABLE [dbo].[ivyt_AdmissionDates]  WITH CHECK ADD  CONSTRAINT [FK_ivyt_AdmissionDates_ivyt_Universities] FOREIGN KEY([UnitID])
REFERENCES [dbo].[ivyt_Universities] ([UniversityID])
GO
ALTER TABLE [dbo].[ivyt_AdmissionDates] CHECK CONSTRAINT [FK_ivyt_AdmissionDates_ivyt_Universities]
GO
/****** Object:  ForeignKey [FK_ivyt_AdmissionFees_ivyt_Universities]    Script Date: 02/26/2015 16:49:03 ******/
ALTER TABLE [dbo].[ivyt_AdmissionFees]  WITH CHECK ADD  CONSTRAINT [FK_ivyt_AdmissionFees_ivyt_Universities] FOREIGN KEY([UniversityID])
REFERENCES [dbo].[ivyt_Universities] ([UniversityID])
GO
ALTER TABLE [dbo].[ivyt_AdmissionFees] CHECK CONSTRAINT [FK_ivyt_AdmissionFees_ivyt_Universities]
GO
/****** Object:  ForeignKey [FK_ivyt_UniversityAssignments_ivyt_Universities]    Script Date: 02/26/2015 16:49:03 ******/
ALTER TABLE [dbo].[ivyt_UniversityAssignments]  WITH CHECK ADD  CONSTRAINT [FK_ivyt_UniversityAssignments_ivyt_Universities] FOREIGN KEY([UniversityID])
REFERENCES [dbo].[ivyt_Universities] ([UniversityID])
GO
ALTER TABLE [dbo].[ivyt_UniversityAssignments] CHECK CONSTRAINT [FK_ivyt_UniversityAssignments_ivyt_Universities]
GO
/****** Object:  ForeignKey [FK_ivyt_UniversityAssignments_ivyt_Users]    Script Date: 02/26/2015 16:49:03 ******/
ALTER TABLE [dbo].[ivyt_UniversityAssignments]  WITH CHECK ADD  CONSTRAINT [FK_ivyt_UniversityAssignments_ivyt_Users] FOREIGN KEY([OperatorID])
REFERENCES [dbo].[ivyt_Users] ([UserID])
GO
ALTER TABLE [dbo].[ivyt_UniversityAssignments] CHECK CONSTRAINT [FK_ivyt_UniversityAssignments_ivyt_Users]
GO
/****** Object:  ForeignKey [FK_ivyt_UniversityAssignments_ivyt_Users1]    Script Date: 02/26/2015 16:49:03 ******/
ALTER TABLE [dbo].[ivyt_UniversityAssignments]  WITH CHECK ADD  CONSTRAINT [FK_ivyt_UniversityAssignments_ivyt_Users1] FOREIGN KEY([VerifiedByID])
REFERENCES [dbo].[ivyt_Users] ([UserID])
GO
ALTER TABLE [dbo].[ivyt_UniversityAssignments] CHECK CONSTRAINT [FK_ivyt_UniversityAssignments_ivyt_Users1]
GO
/****** Object:  ForeignKey [FK_ivyt_Users_ivyt_UserRoleTypes]    Script Date: 02/26/2015 16:49:03 ******/
ALTER TABLE [dbo].[ivyt_Users]  WITH CHECK ADD  CONSTRAINT [FK_ivyt_Users_ivyt_UserRoleTypes] FOREIGN KEY([UserRoleTypeID])
REFERENCES [dbo].[ivyt_UserRoleTypes] ([UserRoleTypeID])
GO
ALTER TABLE [dbo].[ivyt_Users] CHECK CONSTRAINT [FK_ivyt_Users_ivyt_UserRoleTypes]
GO
