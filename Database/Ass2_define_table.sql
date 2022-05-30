
-- Khóa DBI202x_2.1-A_VN Các hệ cơ sở dữ liệu
-- Hang Nguyen (FZ17081)
-- Create 8 tables with all neccessary components and 
-- add artificial records to each table so that querries can be written for further requirement

CREATE TABLE writer 
(
	writerID nvarchar(5) NOT NULL,
	writerName nvarchar(30) NOT NULL,  
	PRIMARY KEY (writerID)
)

GO

INSERT INTO writer (writerID, writerName) 
VALUES 
	('W0001', 'Nguyen Mai Anh'),
	('W0002', 'NGUYEN THI BE'),
	('W0003', 'LE HOANG NAM'),
	('W0004', 'TRAN THI CHIEU'),
	('W0005', 'MAI THI QUE ANH'),
	('W0006', 'LE VAN SANG'),
	('W0007', 'TRAN HOANG KHAI'),
	('W0008', 'Tran Thi Nhu'),
	('W0009', 'Trinh Van Lang'),
	('W0010', 'Hoang Duc Tien');

go

CREATE TABLE editor
(
	editorID nvarchar(5) NOT NULL,
	editorName nvarchar(30) NOT NULL,
	PRIMARY KEY (editorID)
)
GO


INSERT INTO editor (editorID, editorName) 
VALUES 
	('E0001', 'Ngo Dinh Cong'),
	('E0002', 'NGUYEN THI HANH'),
	('E0003', 'LE HOANG MANH'),
	('E0004', 'TRAN THI CUC'),
	('E0005', 'MAI THI HUYNH'),
	('E0006', 'LE VAN TU'),
	('E0007', 'TRAN HOANG HIEU'),
	('E0008', 'Tran Thi Chi'),
	('E0009', 'Trinh Van Thai'),
	('E0010', 'Hoang Duc Canh');

go

CREATE TABLE article
(
	articleID nvarchar(5) NOT NULL,
	articleName nvarchar(60) NOT NULL, 
	fullContent nvarchar(4000), 
	publishedDate Datetime,
	headerName nvarchar(200) ,
	picID nvarchar(5) NOT NULL,
	PRIMARY KEY (articleID),
	FOREIGN KEY (picID) REFERENCES picture(picID)
)
GO

INSERT INTO article (articleID, articleName, fullContent, publishedDate, headerName, picID) 
VALUES 
	('A0001', 'Tien euro dang sut gia', 'Chung toi rat e ngai ve viec dong euro dang tang cao. Mac du vay .... het bai.', '2021-04-12', 'Theo to Washington ...giam euro.', 'P0003'),
	('A0002', 'He luy cua viec dau tu khong bai ban', 'Hien tai chung toi...can than hon.', '2021-05-14', 'Can phai ... hon.', 'P0001'),
	('A0003', 'He luy cua dau tu bitcoin', 'Tinh hinh...can than hon.', '2021-05-26', 'Thoi phai ... hon.', 'P0001'),
	('A0004', 'Co nhac sy Ha Tran tu doi vao ngay 14/5', 'Xin chia buon...co nha sy Ha Tran.', '2021-05-14', NULL, 'P0010'),
	('A0005', 'Phim Bo Gia pha dao phong ve', 'That bat ngo...can than hon.', '2021-05-14', 'Tai vi ... hon.', 'P0009'),
	('A0006', 'Bat duoc ten trom', 'Vao ngay ...can than hon.', NULL, 'Khong can ... hon.', 'P0008'),
	('A0007', 'Tre em vung Dong Nai duoc ho tro phao cuu sinh', NULL, '2021-07-01', NULL, 'P0007'),
	('A0008', 'Nhac phim ost noi tieng', 'Lot vao...can than hon.', NULL, 'Xep hang ... hon.', 'P0006'),
	('A0009', 'Tay Ban Nha gap nan SARS', NULL, '2021-07-15', 'Hom nay ... hon.', 'P0002'),
	('A0010', 'So nguoi chet vi Covid tang cao', 'Cap nhap ...can than hon.', '2021-05-14', NULL, 'P0004')

GO


CREATE TABLE picture
(
	picID nvarchar(5) NOT NULL,
	picName nvarchar(30) NOT NULL,
	PRIMARY KEY (picID)
)
GO

INSERT INTO picture (picID, picName) 
VALUES 
	('P0001', 'JDM'),
	('P0002', 'BG'),
	('P0003', 'MOL'),
	('P0004', 'LK'),
	('P0005', 'HDI'),
	('P0006', 'OP'),
	('P0007', 'NOR'),
	('P0008', 'DOM'),
	('P0009', 'ABV'),
	('P0010', 'ABC')

GO


CREATE TABLE category
(
	categoryID nvarchar(5) NOT NULL,
	categoryName nvarchar(30) NOT NULL,
	PRIMARY KEY (categoryID)
)
GO

INSERT INTO category (categoryID, categoryName) 
VALUES 
	('C0001', 'Economy'),
	('C0002', 'Social Science'),
	('C0003', 'Sport'),
	('C0004', 'International news'),
	('C0005', 'Investment'),
	('C0006', 'Education'),
	('C0007', 'Music'),
	('C0008', 'Celebrity'),
	('C0009', 'Crime'),
	('C0010', 'Children')

GO

CREATE TABLE articleWriter
(
	writerID nvarchar(5) NOT NULL,
	articleID nvarchar(5) NOT NULL,
	FOREIGN KEY (writerID) REFERENCES writer(writerID),
	FOREIGN KEY (articleID) REFERENCES article(articleID)
)
GO

INSERT INTO articleWriter (writerID, articleID) 
VALUES 
	('W0001', 'A0001'),
	('W0002', 'A0001'),
	('W0003', 'A0005'),
	('W0003', 'A0003'),
	('W0005', 'A0004'),
	('W0006', 'A0009'),
	('W0006', 'A0010'),
	('W0008', 'A0007'),
	('W0009', 'A0004'),
	('W0010', 'A0002')

GO

CREATE TABLE review
(
	reviewID nvarchar(5) NOT NULL,
	writerID nvarchar(5) NOT NULL,
	articleID nvarchar(5) NOT NULL,
	editorID nvarchar(5) NOT NULL,
	reviewDate datetime,
	PRIMARY KEY (reviewID),
	FOREIGN KEY (writerID) REFERENCES writer(writerID),
	FOREIGN KEY (articleID) REFERENCES article(articleID),
	FOREIGN KEY (editorID) REFERENCES editor(editorID)
)
GO

INSERT INTO review (reviewID, writerID, articleID, editorID) 
VALUES 
	('R0001', 'W0001', 'A0001', 'E0002'),
	('R0002', 'W0005', 'A0004', 'E0001'),
	('R0003', 'W0002', 'A0001', 'E0009'),
	('R0004', 'W0006', 'A0009', 'E0003'),
	('R0005', 'W0010', 'A0002', 'E0004'),
	('R0006', 'W0009', 'A0004', 'E0010'),
	('R0007', 'W0008', 'A0007', 'E0005'),
	('R0008', 'W0006', 'A0010', 'E0006'),
	('R0009', 'W0003', 'A0005', 'E0007'),
	('R0010', 'W0003', 'A0003', 'E0008')

GO

CREATE TABLE inCategory
(
	articleID nvarchar(5) NOT NULL,
	categoryID nvarchar(5) NOT NULL,
	FOREIGN KEY (categoryID) REFERENCES category(categoryID),
	FOREIGN KEY (articleID) REFERENCES article(articleID)
)
GO

INSERT INTO inCategory (articleID, categoryID) 
VALUES 
	('A0001', 'C0001'),
	('A0002', 'C0005'),
	('A0003', 'C0005'),
	('A0004', 'C0007'),
	('A0005', 'C0002'),
	('A0006', 'C0009'),
	('A0007', 'C0010'),
	('A0008', 'C0007'),
	('A0009', 'C0004'),
	('A0010', 'C0002')

GO

select month (publishedDate) as Month, count(*) TotalArticles from article
where publishedDate is not null
group by month(publishedDate);