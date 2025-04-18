USE [master]
GO
/****** Object:  Database [Predictions]    Script Date: 15.04.2025 18:07:14 ******/
CREATE DATABASE [Predictions]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Predictions', FILENAME = N'D:\Программы\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Predictions.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Predictions_log', FILENAME = N'D:\Программы\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Predictions_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Predictions] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Predictions].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Predictions] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Predictions] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Predictions] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Predictions] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Predictions] SET ARITHABORT OFF 
GO
ALTER DATABASE [Predictions] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Predictions] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Predictions] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Predictions] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Predictions] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Predictions] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Predictions] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Predictions] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Predictions] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Predictions] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Predictions] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Predictions] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Predictions] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Predictions] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Predictions] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Predictions] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Predictions] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Predictions] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Predictions] SET  MULTI_USER 
GO
ALTER DATABASE [Predictions] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Predictions] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Predictions] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Predictions] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Predictions] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Predictions] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Predictions] SET QUERY_STORE = ON
GO
ALTER DATABASE [Predictions] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Predictions]
GO
/****** Object:  Table [dbo].[ApartmentTypes]    Script Date: 15.04.2025 18:07:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApartmentTypes](
	[ApartmentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_ApartmentTypes] PRIMARY KEY CLUSTERED 
(
	[ApartmentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MetroStations]    Script Date: 15.04.2025 18:07:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MetroStations](
	[MetroStationID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Latitude] [decimal](9, 6) NOT NULL,
	[Longitude] [decimal](9, 6) NOT NULL,
 CONSTRAINT [PK_MetroStations] PRIMARY KEY CLUSTERED 
(
	[MetroStationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PricePredictions]    Script Date: 15.04.2025 18:07:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PricePredictions](
	[PredictionID] [int] IDENTITY(1,1) NOT NULL,
	[RealEstateID] [int] NOT NULL,
	[CurrentPrice] [decimal](12, 2) NOT NULL,
	[PriceIn5Years] [decimal](12, 2) NOT NULL,
	[PriceIn10Years] [decimal](12, 2) NOT NULL,
 CONSTRAINT [PK_PricePredictions] PRIMARY KEY CLUSTERED 
(
	[PredictionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RealEstate]    Script Date: 15.04.2025 18:07:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RealEstate](
	[RealEstateID] [int] IDENTITY(1,1) NOT NULL,
	[Rooms] [int] NOT NULL,
	[TotalArea] [decimal](6, 2) NOT NULL,
	[LivingArea] [decimal](6, 2) NOT NULL,
	[KitchenArea] [decimal](6, 2) NOT NULL,
	[Floor] [int] NOT NULL,
	[TotalFloors] [int] NOT NULL,
	[MetroStationID] [int] NOT NULL,
	[ApartmentTypeID] [int] NOT NULL,
	[RenovationID] [int] NOT NULL,
 CONSTRAINT [PK_RealEstate] PRIMARY KEY CLUSTERED 
(
	[RealEstateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Renovations]    Script Date: 15.04.2025 18:07:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Renovations](
	[RenovationID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Renovations] PRIMARY KEY CLUSTERED 
(
	[RenovationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ApartmentTypes] ON 

INSERT [dbo].[ApartmentTypes] ([ApartmentTypeID], [Name]) VALUES (1, N'Новостройка')
INSERT [dbo].[ApartmentTypes] ([ApartmentTypeID], [Name]) VALUES (2, N'Вторичка')
SET IDENTITY_INSERT [dbo].[ApartmentTypes] OFF
GO
SET IDENTITY_INSERT [dbo].[MetroStations] ON 

INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (1, N'Авиамоторная', CAST(55.752500 AS Decimal(9, 6)), CAST(37.719170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (2, N'Автозаводская', CAST(55.707500 AS Decimal(9, 6)), CAST(37.657500 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (3, N'Академическая', CAST(55.687780 AS Decimal(9, 6)), CAST(37.573330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (4, N'Александровский сад', CAST(55.752500 AS Decimal(9, 6)), CAST(37.608890 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (5, N'Алексеевская', CAST(55.808890 AS Decimal(9, 6)), CAST(37.638890 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (6, N'Алма-Атинская', CAST(55.632500 AS Decimal(9, 6)), CAST(37.766110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (7, N'Алтуфьево', CAST(55.898060 AS Decimal(9, 6)), CAST(37.586940 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (8, N'Аминьевская', CAST(55.697220 AS Decimal(9, 6)), CAST(37.465000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (9, N'Андроновка', CAST(55.745275 AS Decimal(9, 6)), CAST(37.739213 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (10, N'Аникеевка', CAST(55.832306 AS Decimal(9, 6)), CAST(37.219163 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (11, N'Аннино', CAST(55.582780 AS Decimal(9, 6)), CAST(37.596670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (12, N'Арбатская', CAST(55.752220 AS Decimal(9, 6)), CAST(37.606110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (13, N'Аэропорт', CAST(55.800280 AS Decimal(9, 6)), CAST(37.532780 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (14, N'Аэропорт Внуково', CAST(55.607220 AS Decimal(9, 6)), CAST(37.287780 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (15, N'Бабушкинская', CAST(55.869440 AS Decimal(9, 6)), CAST(37.664440 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (16, N'Багратионовская', CAST(55.743890 AS Decimal(9, 6)), CAST(37.497780 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (17, N'Балтийская', CAST(55.826554 AS Decimal(9, 6)), CAST(37.499785 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (18, N'Баррикадная', CAST(55.761110 AS Decimal(9, 6)), CAST(37.579440 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (19, N'Бауманская', CAST(55.773060 AS Decimal(9, 6)), CAST(37.680560 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (20, N'Беговая', CAST(55.773890 AS Decimal(9, 6)), CAST(37.546670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (21, N'Белокаменная', CAST(55.829378 AS Decimal(9, 6)), CAST(37.702319 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (22, N'Беломорская', CAST(55.865830 AS Decimal(9, 6)), CAST(37.476390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (23, N'Белорусская', CAST(55.776670 AS Decimal(9, 6)), CAST(37.583610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (24, N'Беляево', CAST(55.642780 AS Decimal(9, 6)), CAST(37.525830 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (25, N'Бескудниково', CAST(55.882187 AS Decimal(9, 6)), CAST(37.567698 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (26, N'Бибирево', CAST(55.883890 AS Decimal(9, 6)), CAST(37.603330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (27, N'Библиотека имени Ленина', CAST(55.751110 AS Decimal(9, 6)), CAST(37.610000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (28, N'Битца', CAST(55.571120 AS Decimal(9, 6)), CAST(37.611257 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (29, N'Битцевский парк', CAST(55.600164 AS Decimal(9, 6)), CAST(37.556370 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (30, N'Борисово', CAST(55.633330 AS Decimal(9, 6)), CAST(37.743060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (31, N'Боровицкая', CAST(55.751110 AS Decimal(9, 6)), CAST(37.607220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (32, N'Боровское шоссе', CAST(55.647780 AS Decimal(9, 6)), CAST(37.370280 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (33, N'Ботанический сад', CAST(55.845000 AS Decimal(9, 6)), CAST(37.638330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (34, N'Братиславская', CAST(55.659720 AS Decimal(9, 6)), CAST(37.750560 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (35, N'Бульвар адмирала Ушакова', CAST(55.545022 AS Decimal(9, 6)), CAST(37.541613 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (36, N'Бульвар Дмитрия Донского', CAST(55.569170 AS Decimal(9, 6)), CAST(37.576940 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (37, N'Бульвар Рокоссовского', CAST(55.814720 AS Decimal(9, 6)), CAST(37.734170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (38, N'Бунинская аллея', CAST(55.537967 AS Decimal(9, 6)), CAST(37.515925 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (39, N'Бутово', CAST(55.541696 AS Decimal(9, 6)), CAST(37.570645 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (40, N'Бутырская', CAST(55.813330 AS Decimal(9, 6)), CAST(37.602780 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (41, N'Варшавская', CAST(55.653330 AS Decimal(9, 6)), CAST(37.619440 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (42, N'Варшавская (Коломенское)', CAST(55.653294 AS Decimal(9, 6)), CAST(37.619523 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (43, N'ВДНХ', CAST(55.821110 AS Decimal(9, 6)), CAST(37.641110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (44, N'Верхние котлы', CAST(55.690082 AS Decimal(9, 6)), CAST(37.618765 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (45, N'Верхние Лихоборы', CAST(55.856110 AS Decimal(9, 6)), CAST(37.561110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (46, N'Вешняки', CAST(55.722467 AS Decimal(9, 6)), CAST(37.798107 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (47, N'Владыкино', CAST(55.847220 AS Decimal(9, 6)), CAST(37.590000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (48, N'Внуково', CAST(55.607087 AS Decimal(9, 6)), CAST(37.287702 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (49, N'Водный стадион', CAST(55.839720 AS Decimal(9, 6)), CAST(37.486670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (50, N'Войковская', CAST(55.818890 AS Decimal(9, 6)), CAST(37.498060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (51, N'Волгоградский проспект', CAST(55.725280 AS Decimal(9, 6)), CAST(37.686940 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (52, N'Волжская', CAST(55.690830 AS Decimal(9, 6)), CAST(37.753060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (53, N'Волоколамская', CAST(55.835280 AS Decimal(9, 6)), CAST(37.382220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (54, N'Воробьёвы горы', CAST(55.710280 AS Decimal(9, 6)), CAST(37.559170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (55, N'Воронцовская', CAST(55.658890 AS Decimal(9, 6)), CAST(37.539170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (56, N'Выставочная', CAST(55.747916 AS Decimal(9, 6)), CAST(37.532911 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (57, N'Выставочный центр', CAST(55.824089 AS Decimal(9, 6)), CAST(37.638503 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (58, N'Выхино', CAST(55.715560 AS Decimal(9, 6)), CAST(37.818060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (59, N'Генерала Тюленева', CAST(55.626390 AS Decimal(9, 6)), CAST(37.487780 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (60, N'Говорово', CAST(55.659440 AS Decimal(9, 6)), CAST(37.417220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (61, N'Гражданская', CAST(55.805484 AS Decimal(9, 6)), CAST(37.553323 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (62, N'Давыдково', CAST(55.715280 AS Decimal(9, 6)), CAST(37.451670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (63, N'Дегунино', CAST(55.865224 AS Decimal(9, 6)), CAST(37.573208 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (64, N'Деловой центр', CAST(55.750000 AS Decimal(9, 6)), CAST(37.541110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (65, N'Депо', CAST(55.674204 AS Decimal(9, 6)), CAST(37.728148 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (66, N'Динамо', CAST(55.789720 AS Decimal(9, 6)), CAST(37.558060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (67, N'Дмитровская', CAST(55.806940 AS Decimal(9, 6)), CAST(37.581670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (68, N'Добрынинская', CAST(55.729170 AS Decimal(9, 6)), CAST(37.624170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (69, N'Долгопрудная', CAST(55.940034 AS Decimal(9, 6)), CAST(37.520034 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (70, N'Домодедовская', CAST(55.610830 AS Decimal(9, 6)), CAST(37.718610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (71, N'Достоевская', CAST(55.781670 AS Decimal(9, 6)), CAST(37.615000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (72, N'Дубровка', CAST(55.718610 AS Decimal(9, 6)), CAST(37.676110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (73, N'Жулебино', CAST(55.685560 AS Decimal(9, 6)), CAST(37.856390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (74, N'Зеленоград — Крюково', CAST(55.980195 AS Decimal(9, 6)), CAST(37.174326 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (75, N'ЗИЛ', CAST(55.698670 AS Decimal(9, 6)), CAST(37.649271 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (76, N'Зорге', CAST(55.789014 AS Decimal(9, 6)), CAST(37.502537 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (77, N'Зюзино', CAST(55.655830 AS Decimal(9, 6)), CAST(37.573610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (78, N'Зябликово', CAST(55.612500 AS Decimal(9, 6)), CAST(37.745280 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (79, N'Измайлово', CAST(55.788412 AS Decimal(9, 6)), CAST(37.743032 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (80, N'Измайловская', CAST(55.787780 AS Decimal(9, 6)), CAST(37.781390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (81, N'Калитники', CAST(55.734151 AS Decimal(9, 6)), CAST(37.701978 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (82, N'Калужская', CAST(55.657220 AS Decimal(9, 6)), CAST(37.540560 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (83, N'Кантемировская', CAST(55.635830 AS Decimal(9, 6)), CAST(37.656390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (84, N'Карамышевская', CAST(55.775830 AS Decimal(9, 6)), CAST(37.485000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (85, N'Каховская', CAST(55.653060 AS Decimal(9, 6)), CAST(37.598330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (86, N'Каширская', CAST(55.655000 AS Decimal(9, 6)), CAST(37.648610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (87, N'Киевская', CAST(55.744440 AS Decimal(9, 6)), CAST(37.565560 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (88, N'Китай-город', CAST(55.755280 AS Decimal(9, 6)), CAST(37.633330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (89, N'Кленовый бульвар', CAST(55.674720 AS Decimal(9, 6)), CAST(37.682220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (90, N'Кожуховская', CAST(55.707500 AS Decimal(9, 6)), CAST(37.685000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (91, N'Коломенская', CAST(55.678610 AS Decimal(9, 6)), CAST(37.663890 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (92, N'Коммунарка', CAST(55.616670 AS Decimal(9, 6)), CAST(37.481390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (93, N'Комсомольская', CAST(55.775280 AS Decimal(9, 6)), CAST(37.656110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (94, N'Коньково', CAST(55.633330 AS Decimal(9, 6)), CAST(37.518890 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (95, N'Коптево', CAST(55.840454 AS Decimal(9, 6)), CAST(37.521417 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (96, N'Корниловская', CAST(55.616670 AS Decimal(9, 6)), CAST(37.481390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (97, N'Косино', CAST(55.703330 AS Decimal(9, 6)), CAST(37.851110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (98, N'Котельники', CAST(55.674170 AS Decimal(9, 6)), CAST(37.858330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (99, N'Красногвардейская', CAST(55.613610 AS Decimal(9, 6)), CAST(37.744440 AS Decimal(9, 6)))
GO
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (100, N'Красногорская', CAST(55.814339 AS Decimal(9, 6)), CAST(37.303949 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (101, N'Краснопресненская', CAST(55.761390 AS Decimal(9, 6)), CAST(37.577500 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (102, N'Красносельская', CAST(55.780000 AS Decimal(9, 6)), CAST(37.667220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (103, N'Красные Ворота', CAST(55.768890 AS Decimal(9, 6)), CAST(37.648610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (104, N'Красный балтиец', CAST(55.817117 AS Decimal(9, 6)), CAST(37.520734 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (105, N'Красный Строитель', CAST(55.590012 AS Decimal(9, 6)), CAST(37.616108 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (106, N'Крестьянская Застава', CAST(55.733060 AS Decimal(9, 6)), CAST(37.667220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (107, N'Кропоткинская', CAST(55.745280 AS Decimal(9, 6)), CAST(37.603610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (108, N'Крылатское', CAST(55.756670 AS Decimal(9, 6)), CAST(37.408060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (109, N'Крымская', CAST(55.690003 AS Decimal(9, 6)), CAST(37.605126 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (110, N'Кузнецкий Мост', CAST(55.760560 AS Decimal(9, 6)), CAST(37.625830 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (111, N'Кузьминки', CAST(55.705560 AS Decimal(9, 6)), CAST(37.765560 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (112, N'Кунцевская', CAST(55.730830 AS Decimal(9, 6)), CAST(37.445830 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (113, N'Курская', CAST(55.758060 AS Decimal(9, 6)), CAST(37.658330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (114, N'Курьяново', CAST(55.649861 AS Decimal(9, 6)), CAST(37.701552 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (115, N'Кутузовская', CAST(55.740000 AS Decimal(9, 6)), CAST(37.534440 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (116, N'Ленинский проспект', CAST(55.707780 AS Decimal(9, 6)), CAST(37.586110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (117, N'Лермонтовский проспект', CAST(55.701390 AS Decimal(9, 6)), CAST(37.852500 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (118, N'Лесопарковая', CAST(55.581969 AS Decimal(9, 6)), CAST(37.577313 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (119, N'Лефортово', CAST(55.764698 AS Decimal(9, 6)), CAST(37.706759 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (120, N'Лианозово', CAST(55.898890 AS Decimal(9, 6)), CAST(37.544720 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (121, N'Лихоборы', CAST(55.847673 AS Decimal(9, 6)), CAST(37.553043 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (122, N'Локомотив', CAST(55.803134 AS Decimal(9, 6)), CAST(37.746059 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (123, N'Ломоносовский проспект', CAST(55.707220 AS Decimal(9, 6)), CAST(37.516110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (124, N'Лубянка', CAST(55.759720 AS Decimal(9, 6)), CAST(37.627220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (125, N'Лужники', CAST(55.720860 AS Decimal(9, 6)), CAST(37.560354 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (126, N'Лухмановская', CAST(55.708610 AS Decimal(9, 6)), CAST(37.900830 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (127, N'Люблино', CAST(55.675830 AS Decimal(9, 6)), CAST(37.761670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (128, N'Марк', CAST(55.905962 AS Decimal(9, 6)), CAST(37.537263 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (129, N'Марксистская', CAST(55.741110 AS Decimal(9, 6)), CAST(37.654170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (130, N'Марьина Роща', CAST(55.795280 AS Decimal(9, 6)), CAST(37.616110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (131, N'Марьина роща (Шереметьевская)', CAST(55.793854 AS Decimal(9, 6)), CAST(37.617059 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (132, N'Марьино', CAST(55.650000 AS Decimal(9, 6)), CAST(37.743060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (133, N'Матвеевская', CAST(55.704580 AS Decimal(9, 6)), CAST(37.481693 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (134, N'Маяковская', CAST(55.770000 AS Decimal(9, 6)), CAST(37.595830 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (135, N'Медведково', CAST(55.887220 AS Decimal(9, 6)), CAST(37.661390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (136, N'Международная', CAST(55.750000 AS Decimal(9, 6)), CAST(37.541110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (137, N'Менделеевская', CAST(55.781110 AS Decimal(9, 6)), CAST(37.601110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (138, N'Минская', CAST(55.724720 AS Decimal(9, 6)), CAST(37.496670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (139, N'Митино', CAST(55.845830 AS Decimal(9, 6)), CAST(37.362220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (140, N'Мичуринский проспект', CAST(55.689440 AS Decimal(9, 6)), CAST(37.483060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (141, N'Мнёвники', CAST(55.761110 AS Decimal(9, 6)), CAST(37.471390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (142, N'Молодёжная', CAST(55.740830 AS Decimal(9, 6)), CAST(37.416670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (143, N'Москва-Сити', CAST(55.748330 AS Decimal(9, 6)), CAST(37.533890 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (144, N'Москва-Товарная', CAST(55.745656 AS Decimal(9, 6)), CAST(37.688313 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (145, N'Москворечье', CAST(55.640150 AS Decimal(9, 6)), CAST(37.688228 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (146, N'Мякинино', CAST(55.825280 AS Decimal(9, 6)), CAST(37.385280 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (147, N'Нагатинская', CAST(55.683060 AS Decimal(9, 6)), CAST(37.622500 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (148, N'Нагатинский Затон', CAST(55.684170 AS Decimal(9, 6)), CAST(37.703330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (149, N'Нагорная', CAST(55.672500 AS Decimal(9, 6)), CAST(37.610280 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (150, N'Народное Ополчение', CAST(55.775830 AS Decimal(9, 6)), CAST(37.485000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (151, N'Нахабино', CAST(55.841658 AS Decimal(9, 6)), CAST(37.184857 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (152, N'Нахимовский проспект', CAST(55.662780 AS Decimal(9, 6)), CAST(37.605560 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (153, N'Некрасовка', CAST(55.702780 AS Decimal(9, 6)), CAST(37.928330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (154, N'Немчиновка', CAST(55.715995 AS Decimal(9, 6)), CAST(37.375362 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (155, N'Нижегородская', CAST(55.732500 AS Decimal(9, 6)), CAST(37.728330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (156, N'Новаторская', CAST(55.670280 AS Decimal(9, 6)), CAST(37.520280 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (157, N'Новогиреево', CAST(55.751670 AS Decimal(9, 6)), CAST(37.816670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (158, N'Новодачная', CAST(55.924397 AS Decimal(9, 6)), CAST(37.527944 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (159, N'Новокосино', CAST(55.745000 AS Decimal(9, 6)), CAST(37.863890 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (160, N'Новокузнецкая', CAST(55.741390 AS Decimal(9, 6)), CAST(37.629440 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (161, N'Новомосковская', CAST(55.560280 AS Decimal(9, 6)), CAST(37.468330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (162, N'Новомосковская', CAST(55.616670 AS Decimal(9, 6)), CAST(37.481390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (163, N'Новопеределкино', CAST(55.639720 AS Decimal(9, 6)), CAST(37.355280 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (164, N'Новоподрезково', CAST(55.936534 AS Decimal(9, 6)), CAST(37.352246 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (165, N'Новослободская', CAST(55.780000 AS Decimal(9, 6)), CAST(37.602780 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (166, N'Новохохловская', CAST(55.724051 AS Decimal(9, 6)), CAST(37.716367 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (167, N'Новоясеневская', CAST(55.601110 AS Decimal(9, 6)), CAST(37.554170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (168, N'Новые Черёмушки', CAST(55.670280 AS Decimal(9, 6)), CAST(37.554440 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (169, N'Озёрная', CAST(55.670560 AS Decimal(9, 6)), CAST(37.448330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (170, N'Окружная', CAST(55.846110 AS Decimal(9, 6)), CAST(37.573890 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (171, N'Окская', CAST(55.718610 AS Decimal(9, 6)), CAST(37.781390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (172, N'Октябрьская', CAST(55.729720 AS Decimal(9, 6)), CAST(37.609170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (173, N'Октябрьское Поле', CAST(55.793610 AS Decimal(9, 6)), CAST(37.493610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (174, N'Ольховая', CAST(55.568610 AS Decimal(9, 6)), CAST(37.459440 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (175, N'Опалиха', CAST(55.822705 AS Decimal(9, 6)), CAST(37.248768 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (176, N'Орехово', CAST(55.613330 AS Decimal(9, 6)), CAST(37.695000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (177, N'Остафьево', CAST(55.486179 AS Decimal(9, 6)), CAST(37.553805 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (178, N'Отрадное', CAST(55.863330 AS Decimal(9, 6)), CAST(37.604720 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (179, N'Охотный Ряд', CAST(55.757780 AS Decimal(9, 6)), CAST(37.616670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (180, N'Очаково', CAST(55.683148 AS Decimal(9, 6)), CAST(37.450558 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (181, N'Павелецкая', CAST(55.730560 AS Decimal(9, 6)), CAST(37.637780 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (182, N'Павшино', CAST(55.814971 AS Decimal(9, 6)), CAST(37.341894 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (183, N'Панфиловская', CAST(55.804076 AS Decimal(9, 6)), CAST(37.495473 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (184, N'Парк культуры', CAST(55.735560 AS Decimal(9, 6)), CAST(37.594170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (185, N'Парк Победы', CAST(55.736110 AS Decimal(9, 6)), CAST(37.518330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (186, N'Партизанская', CAST(55.788610 AS Decimal(9, 6)), CAST(37.750560 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (187, N'Пенягино', CAST(55.822192 AS Decimal(9, 6)), CAST(37.360881 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (188, N'Первомайская', CAST(55.794720 AS Decimal(9, 6)), CAST(37.799170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (189, N'Перерва', CAST(55.661415 AS Decimal(9, 6)), CAST(37.716998 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (190, N'Перово', CAST(55.751110 AS Decimal(9, 6)), CAST(37.786670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (191, N'Петровский парк', CAST(55.791940 AS Decimal(9, 6)), CAST(37.557220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (192, N'Петровско-Разумовская', CAST(55.835000 AS Decimal(9, 6)), CAST(37.574440 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (193, N'Печатники', CAST(55.693330 AS Decimal(9, 6)), CAST(37.726940 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (194, N'Пионерская', CAST(55.736110 AS Decimal(9, 6)), CAST(37.467220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (195, N'Планерная', CAST(55.860830 AS Decimal(9, 6)), CAST(37.436390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (196, N'Площадь Гагарина', CAST(55.706775 AS Decimal(9, 6)), CAST(37.586584 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (197, N'Площадь Ильича', CAST(55.747220 AS Decimal(9, 6)), CAST(37.682500 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (198, N'Площадь Революции', CAST(55.756670 AS Decimal(9, 6)), CAST(37.621670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (199, N'Подольск', CAST(55.431841 AS Decimal(9, 6)), CAST(37.563941 AS Decimal(9, 6)))
GO
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (200, N'Покровское', CAST(55.602970 AS Decimal(9, 6)), CAST(37.632073 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (201, N'Полежаевская', CAST(55.777500 AS Decimal(9, 6)), CAST(37.519170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (202, N'Полянка', CAST(55.737780 AS Decimal(9, 6)), CAST(37.618060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (203, N'Потапово', CAST(55.553060 AS Decimal(9, 6)), CAST(37.493060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (204, N'Пражская', CAST(55.612500 AS Decimal(9, 6)), CAST(37.604440 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (205, N'Преображенская площадь', CAST(55.796390 AS Decimal(9, 6)), CAST(37.715000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (206, N'Прокшино', CAST(55.586110 AS Decimal(9, 6)), CAST(37.433890 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (207, N'Пролетарская', CAST(55.731940 AS Decimal(9, 6)), CAST(37.665830 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (208, N'Проспект Вернадского', CAST(55.677220 AS Decimal(9, 6)), CAST(37.506110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (209, N'Проспект Мира', CAST(55.779720 AS Decimal(9, 6)), CAST(37.631670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (210, N'Профсоюзная', CAST(55.678060 AS Decimal(9, 6)), CAST(37.562780 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (211, N'Пушкинская', CAST(55.765000 AS Decimal(9, 6)), CAST(37.607780 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (212, N'Пыхтино', CAST(55.625000 AS Decimal(9, 6)), CAST(37.298060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (213, N'Пятницкое шоссе', CAST(55.856390 AS Decimal(9, 6)), CAST(37.354440 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (214, N'Рабочий посёлок', CAST(55.726920 AS Decimal(9, 6)), CAST(37.417885 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (215, N'Раменки', CAST(55.697500 AS Decimal(9, 6)), CAST(37.498610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (216, N'Рассказовка', CAST(55.634170 AS Decimal(9, 6)), CAST(37.335280 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (217, N'Речной вокзал', CAST(55.855000 AS Decimal(9, 6)), CAST(37.476110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (218, N'Рижская', CAST(55.793610 AS Decimal(9, 6)), CAST(37.636110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (219, N'Римская', CAST(55.746390 AS Decimal(9, 6)), CAST(37.681940 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (220, N'Ростокино', CAST(55.839129 AS Decimal(9, 6)), CAST(37.668139 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (221, N'Румянцево', CAST(55.633060 AS Decimal(9, 6)), CAST(37.441940 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (222, N'Рязанский проспект', CAST(55.716940 AS Decimal(9, 6)), CAST(37.793330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (223, N'Савёловская', CAST(55.792780 AS Decimal(9, 6)), CAST(37.588610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (224, N'Саларьево', CAST(55.621940 AS Decimal(9, 6)), CAST(37.424170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (225, N'Санино', CAST(55.583886 AS Decimal(9, 6)), CAST(37.138168 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (226, N'Свиблово', CAST(55.855280 AS Decimal(9, 6)), CAST(37.652780 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (227, N'Севастопольская', CAST(55.652500 AS Decimal(9, 6)), CAST(37.598330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (228, N'Селигерская', CAST(55.866390 AS Decimal(9, 6)), CAST(37.547220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (229, N'Семёновская', CAST(55.783330 AS Decimal(9, 6)), CAST(37.720830 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (230, N'Серпуховская', CAST(55.728060 AS Decimal(9, 6)), CAST(37.624720 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (231, N'Сетунь', CAST(55.723993 AS Decimal(9, 6)), CAST(37.398636 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (232, N'Силикатная', CAST(55.470495 AS Decimal(9, 6)), CAST(37.555112 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (233, N'Сколково', CAST(55.700094 AS Decimal(9, 6)), CAST(37.342531 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (234, N'Славянский бульвар', CAST(55.729720 AS Decimal(9, 6)), CAST(37.470560 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (235, N'Смоленская', CAST(55.747500 AS Decimal(9, 6)), CAST(37.582220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (236, N'Сокол', CAST(55.805000 AS Decimal(9, 6)), CAST(37.515280 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (237, N'Соколиная гора', CAST(55.769918 AS Decimal(9, 6)), CAST(37.745387 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (238, N'Сокольники', CAST(55.788890 AS Decimal(9, 6)), CAST(37.680280 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (239, N'Солнцево', CAST(55.649440 AS Decimal(9, 6)), CAST(37.391110 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (240, N'Спартак', CAST(55.818330 AS Decimal(9, 6)), CAST(37.435830 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (241, N'Спортивная', CAST(55.723330 AS Decimal(9, 6)), CAST(37.563890 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (242, N'Сретенский бульвар', CAST(55.766670 AS Decimal(9, 6)), CAST(37.639170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (243, N'Стахановская', CAST(55.727220 AS Decimal(9, 6)), CAST(37.752220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (244, N'Стрешнево', CAST(55.815517 AS Decimal(9, 6)), CAST(37.492552 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (245, N'Строгино', CAST(55.803890 AS Decimal(9, 6)), CAST(37.403060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (246, N'Студенческая', CAST(55.738890 AS Decimal(9, 6)), CAST(37.548330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (247, N'Сухаревская', CAST(55.773330 AS Decimal(9, 6)), CAST(37.631940 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (248, N'Сходненская', CAST(55.850560 AS Decimal(9, 6)), CAST(37.439720 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (249, N'Таганская', CAST(55.741670 AS Decimal(9, 6)), CAST(37.651670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (250, N'Тверская', CAST(55.764720 AS Decimal(9, 6)), CAST(37.606390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (251, N'Театральная', CAST(55.757780 AS Decimal(9, 6)), CAST(37.618890 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (252, N'Текстильщики', CAST(55.708890 AS Decimal(9, 6)), CAST(37.731670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (253, N'Тёплый Стан', CAST(55.619170 AS Decimal(9, 6)), CAST(37.508330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (254, N'Терехово', CAST(55.748060 AS Decimal(9, 6)), CAST(37.459720 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (255, N'Тестовская', CAST(55.750145 AS Decimal(9, 6)), CAST(37.530571 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (256, N'Технопарк', CAST(55.693890 AS Decimal(9, 6)), CAST(37.664440 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (257, N'Тимирязевская', CAST(55.817500 AS Decimal(9, 6)), CAST(37.576390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (258, N'Третьяковская', CAST(55.741110 AS Decimal(9, 6)), CAST(37.627500 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (259, N'Трикотажная', CAST(55.833137 AS Decimal(9, 6)), CAST(37.398976 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (260, N'Тропарёво', CAST(55.645830 AS Decimal(9, 6)), CAST(37.472500 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (261, N'Трубная', CAST(55.768890 AS Decimal(9, 6)), CAST(37.620000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (262, N'Тульская', CAST(55.708610 AS Decimal(9, 6)), CAST(37.622780 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (263, N'Тургеневская', CAST(55.766110 AS Decimal(9, 6)), CAST(37.637500 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (264, N'Тушинская', CAST(55.826670 AS Decimal(9, 6)), CAST(37.436670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (265, N'Тютчевская', CAST(55.616670 AS Decimal(9, 6)), CAST(37.481390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (266, N'Угрешская', CAST(55.717944 AS Decimal(9, 6)), CAST(37.695555 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (267, N'Улица 1905 года', CAST(55.765000 AS Decimal(9, 6)), CAST(37.561390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (268, N'Улица Академика Королёва', CAST(55.821825 AS Decimal(9, 6)), CAST(37.627169 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (269, N'Улица Академика Янгеля', CAST(55.595000 AS Decimal(9, 6)), CAST(37.600280 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (270, N'Улица Горчакова', CAST(55.541888 AS Decimal(9, 6)), CAST(37.531174 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (271, N'Улица Дмитриевского', CAST(55.710280 AS Decimal(9, 6)), CAST(37.880000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (272, N'Улица Скобелевская', CAST(55.549179 AS Decimal(9, 6)), CAST(37.555115 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (273, N'Улица старокачаловская', CAST(55.568633 AS Decimal(9, 6)), CAST(37.576211 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (274, N'Университет', CAST(55.692500 AS Decimal(9, 6)), CAST(37.533330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (275, N'Университет дружбы народов', CAST(55.648890 AS Decimal(9, 6)), CAST(37.508330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (276, N'Физтех', CAST(55.921670 AS Decimal(9, 6)), CAST(37.546390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (277, N'Филатов Луг', CAST(55.601390 AS Decimal(9, 6)), CAST(37.407780 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (278, N'Филёвский парк', CAST(55.739720 AS Decimal(9, 6)), CAST(37.483330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (279, N'Фили', CAST(55.746110 AS Decimal(9, 6)), CAST(37.515000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (280, N'Фонвизинская', CAST(55.822780 AS Decimal(9, 6)), CAST(37.588060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (281, N'Фрунзенская', CAST(55.726670 AS Decimal(9, 6)), CAST(37.578610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (282, N'Хлебниково', CAST(55.970897 AS Decimal(9, 6)), CAST(37.504591 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (283, N'Ховрино', CAST(55.878890 AS Decimal(9, 6)), CAST(37.481390 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (284, N'Хорошёво', CAST(55.776846 AS Decimal(9, 6)), CAST(37.507125 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (285, N'Хорошёвская', CAST(55.776670 AS Decimal(9, 6)), CAST(37.519170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (286, N'Царицыно', CAST(55.621390 AS Decimal(9, 6)), CAST(37.669440 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (287, N'Цветной бульвар', CAST(55.770830 AS Decimal(9, 6)), CAST(37.618610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (288, N'ЦСКА', CAST(55.786670 AS Decimal(9, 6)), CAST(37.533330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (289, N'Черкизовская', CAST(55.803890 AS Decimal(9, 6)), CAST(37.744720 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (290, N'Чертановская', CAST(55.640560 AS Decimal(9, 6)), CAST(37.606670 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (291, N'Чеховская', CAST(55.764720 AS Decimal(9, 6)), CAST(37.609170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (292, N'Чистые пруды', CAST(55.765830 AS Decimal(9, 6)), CAST(37.638890 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (293, N'Чкаловская', CAST(55.756390 AS Decimal(9, 6)), CAST(37.657220 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (294, N'Шаболовская', CAST(55.719720 AS Decimal(9, 6)), CAST(37.608330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (295, N'Шелепиха', CAST(55.756221 AS Decimal(9, 6)), CAST(37.526964 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (296, N'Шипиловская', CAST(55.621110 AS Decimal(9, 6)), CAST(37.743060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (297, N'Шоссе Энтузиастов', CAST(55.757500 AS Decimal(9, 6)), CAST(37.750000 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (298, N'Щёлковская', CAST(55.809440 AS Decimal(9, 6)), CAST(37.798610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (299, N'Щербинка', CAST(55.510085 AS Decimal(9, 6)), CAST(37.561682 AS Decimal(9, 6)))
GO
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (300, N'Щукинская', CAST(55.808610 AS Decimal(9, 6)), CAST(37.464170 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (301, N'Электрозаводская', CAST(55.781670 AS Decimal(9, 6)), CAST(37.703610 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (302, N'Юго-Восточная', CAST(55.705280 AS Decimal(9, 6)), CAST(37.818060 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (303, N'Юго-Западная', CAST(55.663610 AS Decimal(9, 6)), CAST(37.483330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (304, N'Южная', CAST(55.622500 AS Decimal(9, 6)), CAST(37.608890 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (305, N'Ясенево', CAST(55.606390 AS Decimal(9, 6)), CAST(37.533330 AS Decimal(9, 6)))
INSERT [dbo].[MetroStations] ([MetroStationID], [Name], [Latitude], [Longitude]) VALUES (306, N'Яхромская', CAST(55.880000 AS Decimal(9, 6)), CAST(37.545280 AS Decimal(9, 6)))
SET IDENTITY_INSERT [dbo].[MetroStations] OFF
GO
SET IDENTITY_INSERT [dbo].[PricePredictions] ON 

INSERT [dbo].[PricePredictions] ([PredictionID], [RealEstateID], [CurrentPrice], [PriceIn5Years], [PriceIn10Years]) VALUES (1, 1, CAST(22187460.00 AS Decimal(12, 2)), CAST(28317441.01 AS Decimal(12, 2)), CAST(36141027.86 AS Decimal(12, 2)))
INSERT [dbo].[PricePredictions] ([PredictionID], [RealEstateID], [CurrentPrice], [PriceIn5Years], [PriceIn10Years]) VALUES (2, 2, CAST(23745260.00 AS Decimal(12, 2)), CAST(30305637.53 AS Decimal(12, 2)), CAST(38678526.42 AS Decimal(12, 2)))
INSERT [dbo].[PricePredictions] ([PredictionID], [RealEstateID], [CurrentPrice], [PriceIn5Years], [PriceIn10Years]) VALUES (3, 3, CAST(21968280.00 AS Decimal(12, 2)), CAST(28037705.61 AS Decimal(12, 2)), CAST(35784006.73 AS Decimal(12, 2)))
INSERT [dbo].[PricePredictions] ([PredictionID], [RealEstateID], [CurrentPrice], [PriceIn5Years], [PriceIn10Years]) VALUES (4, 4, CAST(23745260.00 AS Decimal(12, 2)), CAST(30305637.53 AS Decimal(12, 2)), CAST(38678526.42 AS Decimal(12, 2)))
INSERT [dbo].[PricePredictions] ([PredictionID], [RealEstateID], [CurrentPrice], [PriceIn5Years], [PriceIn10Years]) VALUES (5, 5, CAST(21794200.00 AS Decimal(12, 2)), CAST(27815533.07 AS Decimal(12, 2)), CAST(35500452.01 AS Decimal(12, 2)))
INSERT [dbo].[PricePredictions] ([PredictionID], [RealEstateID], [CurrentPrice], [PriceIn5Years], [PriceIn10Years]) VALUES (6, 6, CAST(25277610.00 AS Decimal(12, 2)), CAST(32261352.69 AS Decimal(12, 2)), CAST(41174569.62 AS Decimal(12, 2)))
INSERT [dbo].[PricePredictions] ([PredictionID], [RealEstateID], [CurrentPrice], [PriceIn5Years], [PriceIn10Years]) VALUES (7, 7, CAST(21794200.00 AS Decimal(12, 2)), CAST(27815533.07 AS Decimal(12, 2)), CAST(35500452.01 AS Decimal(12, 2)))
INSERT [dbo].[PricePredictions] ([PredictionID], [RealEstateID], [CurrentPrice], [PriceIn5Years], [PriceIn10Years]) VALUES (8, 8, CAST(23745260.00 AS Decimal(12, 2)), CAST(30305637.53 AS Decimal(12, 2)), CAST(38678526.42 AS Decimal(12, 2)))
SET IDENTITY_INSERT [dbo].[PricePredictions] OFF
GO
SET IDENTITY_INSERT [dbo].[RealEstate] ON 

INSERT [dbo].[RealEstate] ([RealEstateID], [Rooms], [TotalArea], [LivingArea], [KitchenArea], [Floor], [TotalFloors], [MetroStationID], [ApartmentTypeID], [RenovationID]) VALUES (1, 2, CAST(60.00 AS Decimal(6, 2)), CAST(35.00 AS Decimal(6, 2)), CAST(10.00 AS Decimal(6, 2)), 4, 9, 1, 1, 1)
INSERT [dbo].[RealEstate] ([RealEstateID], [Rooms], [TotalArea], [LivingArea], [KitchenArea], [Floor], [TotalFloors], [MetroStationID], [ApartmentTypeID], [RenovationID]) VALUES (2, 3, CAST(80.00 AS Decimal(6, 2)), CAST(55.00 AS Decimal(6, 2)), CAST(12.00 AS Decimal(6, 2)), 12, 18, 27, 2, 3)
INSERT [dbo].[RealEstate] ([RealEstateID], [Rooms], [TotalArea], [LivingArea], [KitchenArea], [Floor], [TotalFloors], [MetroStationID], [ApartmentTypeID], [RenovationID]) VALUES (3, 3, CAST(90.00 AS Decimal(6, 2)), CAST(60.00 AS Decimal(6, 2)), CAST(10.00 AS Decimal(6, 2)), 4, 6, 70, 2, 1)
INSERT [dbo].[RealEstate] ([RealEstateID], [Rooms], [TotalArea], [LivingArea], [KitchenArea], [Floor], [TotalFloors], [MetroStationID], [ApartmentTypeID], [RenovationID]) VALUES (4, 1, CAST(30.00 AS Decimal(6, 2)), CAST(15.00 AS Decimal(6, 2)), CAST(8.00 AS Decimal(6, 2)), 1, 5, 133, 2, 3)
INSERT [dbo].[RealEstate] ([RealEstateID], [Rooms], [TotalArea], [LivingArea], [KitchenArea], [Floor], [TotalFloors], [MetroStationID], [ApartmentTypeID], [RenovationID]) VALUES (5, 2, CAST(65.00 AS Decimal(6, 2)), CAST(40.00 AS Decimal(6, 2)), CAST(10.00 AS Decimal(6, 2)), 12, 15, 195, 1, 4)
INSERT [dbo].[RealEstate] ([RealEstateID], [Rooms], [TotalArea], [LivingArea], [KitchenArea], [Floor], [TotalFloors], [MetroStationID], [ApartmentTypeID], [RenovationID]) VALUES (6, 2, CAST(60.00 AS Decimal(6, 2)), CAST(37.00 AS Decimal(6, 2)), CAST(13.00 AS Decimal(6, 2)), 10, 10, 256, 2, 2)
INSERT [dbo].[RealEstate] ([RealEstateID], [Rooms], [TotalArea], [LivingArea], [KitchenArea], [Floor], [TotalFloors], [MetroStationID], [ApartmentTypeID], [RenovationID]) VALUES (7, 4, CAST(100.00 AS Decimal(6, 2)), CAST(70.00 AS Decimal(6, 2)), CAST(17.00 AS Decimal(6, 2)), 3, 10, 286, 1, 4)
INSERT [dbo].[RealEstate] ([RealEstateID], [Rooms], [TotalArea], [LivingArea], [KitchenArea], [Floor], [TotalFloors], [MetroStationID], [ApartmentTypeID], [RenovationID]) VALUES (8, 2, CAST(60.00 AS Decimal(6, 2)), CAST(30.00 AS Decimal(6, 2)), CAST(12.00 AS Decimal(6, 2)), 4, 8, 8, 2, 3)
SET IDENTITY_INSERT [dbo].[RealEstate] OFF
GO
SET IDENTITY_INSERT [dbo].[Renovations] ON 

INSERT [dbo].[Renovations] ([RenovationID], [Name]) VALUES (1, N'Косметический')
INSERT [dbo].[Renovations] ([RenovationID], [Name]) VALUES (2, N'Дизайнерский')
INSERT [dbo].[Renovations] ([RenovationID], [Name]) VALUES (3, N'Евроремонт')
INSERT [dbo].[Renovations] ([RenovationID], [Name]) VALUES (4, N'Без ремонта')
SET IDENTITY_INSERT [dbo].[Renovations] OFF
GO
ALTER TABLE [dbo].[PricePredictions]  WITH CHECK ADD  CONSTRAINT [FK_PricePredictions_RealEstate] FOREIGN KEY([RealEstateID])
REFERENCES [dbo].[RealEstate] ([RealEstateID])
GO
ALTER TABLE [dbo].[PricePredictions] CHECK CONSTRAINT [FK_PricePredictions_RealEstate]
GO
ALTER TABLE [dbo].[RealEstate]  WITH CHECK ADD  CONSTRAINT [FK_RealEstate_ApartmentTypes] FOREIGN KEY([ApartmentTypeID])
REFERENCES [dbo].[ApartmentTypes] ([ApartmentTypeID])
GO
ALTER TABLE [dbo].[RealEstate] CHECK CONSTRAINT [FK_RealEstate_ApartmentTypes]
GO
ALTER TABLE [dbo].[RealEstate]  WITH CHECK ADD  CONSTRAINT [FK_RealEstate_MetroStations] FOREIGN KEY([MetroStationID])
REFERENCES [dbo].[MetroStations] ([MetroStationID])
GO
ALTER TABLE [dbo].[RealEstate] CHECK CONSTRAINT [FK_RealEstate_MetroStations]
GO
ALTER TABLE [dbo].[RealEstate]  WITH CHECK ADD  CONSTRAINT [FK_RealEstate_Renovations] FOREIGN KEY([RenovationID])
REFERENCES [dbo].[Renovations] ([RenovationID])
GO
ALTER TABLE [dbo].[RealEstate] CHECK CONSTRAINT [FK_RealEstate_Renovations]
GO
USE [master]
GO
ALTER DATABASE [Predictions] SET  READ_WRITE 
GO
