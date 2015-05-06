USE [SWTV_DEV]
GO

/****** Object:  Table [dbo].[MallMerchantScrecials]    Script Date: 7/25/2014 4:30:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MallMerchantScrecials](
	[sco_id] [int] IDENTITY(1,1) NOT NULL,
	[mall_id] [int] NULL CONSTRAINT [DF_MallMerchantScrecials_mall_id]  DEFAULT ((0)),
	[mmr_id] [int] NULL,
	[mpm_id] [int] NULL,
	[sco_type_id] [int] NOT NULL CONSTRAINT [DF_MerchantScrecials_sco_type]  DEFAULT ((1)),
	[sco_title] [varchar](50) NULL,
	[sco_description] [text] NULL,
	[sco_defaultImg] [varchar](50) NULL CONSTRAINT [DF_MallMerchantScrecials_sco_defaultImg]  DEFAULT ('screcial17.gif'),
	[sco_defaultBg] [varchar](50) NULL CONSTRAINT [DF_MallMerchantScrecials_sco_defaultBg]  DEFAULT ('winners4.png'),
	[sco_descImg] [varchar](250) NULL,
	[sco_border] [bit] NULL CONSTRAINT [DF_MallMerchantScrecials_sco_border]  DEFAULT ((1)),
	[sco_descDisplay] [int] NULL CONSTRAINT [DF_MallMerchantScrecials_sco_descDisplay]  DEFAULT ((0)),
	[sco_buttons] [int] NULL CONSTRAINT [DF_MallMerchantScrecials_sco_buttons]  DEFAULT ((1)),
	[sco_link_href] [varchar](250) NULL,
	[sco_link_text] [varchar](150) NULL,
	[sco_value] [int] NULL,
	[sco_fixed] [bit] NULL CONSTRAINT [DF_MerchantScrecials_sco_fixed]  DEFAULT ((0)),
	[sco_value_type] [bit] NULL CONSTRAINT [DF_MallMerchantScrecials_sco_value_type]  DEFAULT ((0)),
	[sco_holiday] [bit] NULL CONSTRAINT [DF_MallMerchantScrecials_sco_holiday]  DEFAULT ((0)),
	[sco_created] [datetime] NULL CONSTRAINT [DF_MallMerchantScrecials_sco_created]  DEFAULT (getdate()),
	[sco_start] [datetime] NULL,
	[sco_end] [datetime] NULL,
	[sco_active] [bit] NULL CONSTRAINT [DF_MerchantScrecials_sco_active]  DEFAULT ((1)),
 CONSTRAINT [PK_MerchantScrecials] PRIMARY KEY CLUSTERED 
(
	[sco_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mall ID (If set to 0 displays on all Malls)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'mall_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Merchant ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'mmr_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Promo ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'mpm_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Screcial Type Denotion: 1-StandAlone (Custom), 2- Created from a Promo, 3-Created from a Product' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'sco_type_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ScratchOff Image' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'sco_defaultImg'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Background Image Set in the Screcials Manager' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'sco_defaultBg'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Image contained within the Screcial Description (For Use with Product-based Screcials)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'sco_descImg'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Denotes whether or Not to Display the Screcial''s Dotted Border' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'sco_border'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Display Type for the Screcial 0=TextOnly, 1-Text and DescIMG on Left, 2- Text and DescIMG on Right' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'sco_descDisplay'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Integer Value for the Color of the Button 1=Green,2=Blue, 3=Red' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'sco_buttons'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Integer Value of Screcial Value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'sco_value'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Either a Fixed Amount or Percentage' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'sco_fixed'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Either Dollars or Points' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'sco_value_type'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is this Screcial SetUp for a Holiday? 1=Yes. 0=No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MallMerchantScrecials', @level2type=N'COLUMN',@level2name=N'sco_holiday'
GO

