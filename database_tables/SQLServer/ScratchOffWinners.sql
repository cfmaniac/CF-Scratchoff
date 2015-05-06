USE [SWTV_DEV]
GO

/****** Object:  Table [dbo].[MallScrecialsWinners]    Script Date: 7/25/2014 4:31:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MallScrecialsWinners](
	[msw_id] [int] IDENTITY(1,1) NOT NULL,
	[mmb_id] [int] NOT NULL,
	[sco_id] [int] NOT NULL,
	[msw_scratched] [int] NULL,
	[msw_win_date] [datetime] NULL,
	[msw_redeem_date] [datetime] NULL,
 CONSTRAINT [PK_MallScrecialsWinners] PRIMARY KEY CLUSTERED 
(
	[msw_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MallScrecialsWinners] ADD  CONSTRAINT [DF_MallScrecialsWinners_msw_scratched]  DEFAULT ((0)) FOR [msw_scratched]
GO

