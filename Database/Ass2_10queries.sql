
-- Khóa DBI202x_2.1-A_VN Các hệ cơ sở dữ liệu
-- Hang Nguyen (FZ17081)
-- 10 câu truy vấn bắt buộc
-- có bao gồm sử dụng ít nhất 1 function (câu 10.)
-- có bao gồm sử dụng ít nhất 1 indexing (các bảng chính đã có primary key, tự động là clustered index)
-- có bao gồm sử dụng ít nhất 1 stored procedure (câu 2.)
-- có bao gồm sử dụng ít nhất 1 trigger (cho bảng article, câu 2.)
-- có ít nhất 2 transactions (implicit transaction đã sử dụng cho cả 10 câu) 


USE Assignmen2
GO

-- 1. Truy vấn dữ liệu trên bảng writer
select * from writer;

-- 2. Truy vấn có sử dụng Order by cho tháng xuất bản của bài báo 
-- theo thứ tự từ tháng xa nhất tới gần đây nhất trên bảng article
-- có sử dụng stored procedure và trigger ở đây

-- nếu có stored procedure này rồi thì drop, để lập lại bảng mới, tránh gặp lỗi đã có ở CSDL
if object_ID('MonthOfPublish','P') IS NOT NULL
drop proc MonthOfPublish
go

-- tạo stored procedure
create proc MonthOfPublish (@from int, @to int) as
begin
	if exists (select month (publishedDate) as Month from article where month(publishedDate) between @from and @to)
	begin 
		-- chọn tháng xuất bản và số bài xuất bản trong tháng đó, sau đó sắp xếp từ bé tới lớn theo tháng
		select month(publishedDate) as Month, count(*) as MonthCount from article
		group by month(publishedDate)
		having month(publishedDate) between @from and @to
		order by 1;
	end		
end
go

exec MonthOfPublish 1,6
go

-- trigger cho bảng article
-- sao cho khi update ngày chỉnh sửa bài đăng không được
-- muộn hơn ngày đăng đang có trong bảng
create trigger tr_num_1
on dbo.article
	for update
	as
	begin
		declare @newdate datetime;
		declare @olddate datetime;

		select @olddate = publishedDate from deleted;
		select @newdate = publishedDate from inserted;
		
		if (@newdate < @olddate)
		begin 
			print 'New date can not be inserted'
			rollback
		end
	end
go


-- 3. Truy vấn sử dụng toán tử Like cho tên có chư cái 'o' trên bảng writer
select * from writer
where writerName like '%o%';
go

-- 4. Truy vấn liên quan tới điều kiện về thời gian
-- Lấy tháng từ ngày xuất bản và đếm tổng số bài theo mỗi tháng trên bảng article
select month (publishedDate) as Month, count(*) TotalArticles from article
where publishedDate is not null
group by month(publishedDate);
go

-- 5. Truy vấn dữ liệu từ nhiều bảng sử dụng Inner join
-- Hai bảng writer và articleWriter với column chung 'writerID'
select * from writer w
inner join articleWriter a
	on w.writerID = a.writerID;
go

--  6. Truy vấn sử dụng Self join, Outer join
-- Left join bảng writer với bảng articleWriter, in tất cả giá trị bảng writer và cả những giá trị match với bảng articleWriter
select * from writer w
left join articleWriter a
	on w.writerID = a.writerID;


-- 7. Truy vấn sử dụng truy vấn con
-- Lấy những writerID có nhiều hơn 1 editor quản lý
select writerID
from (select writerID, count(editorID) as numberEditor from review
	  group by writerID) a
where numberEditor >1;
go

-- 8. Truy vấn sử dụng With
-- Lấy những writerID có đúng 1 editor quản lý
with articleCount (writerID, numberEditor) as
(
	select writerID, count(editorID) as numberEditor from review
	group by writerID
)
select writerID from articleCount
where numberEditor =1 ;
go

--  9. Truy vấn thống kê sử dụng Group by và Having
-- Giống câu lệnh số 4., nhưng cấu trúc câu lệnh lần này dùng điều kiện sau khi group by.
select month (publishedDate) as Month, count(*) TotalArticles from article
group by month(publishedDate)
having month(publishedDate) is not null;
go

-- 10. Truy vấn sử dụng function (hàm) đã viết trong bước trước.
-- Giống câu lệnh 7, nhưng thay vì query thẳng, thì dùng function.
-- Khi check estimated execuation plan thì bằng nhau với cost 50%
if object_ID(N'MoreThan1Editor', N'FIN') is not null
	drop function MoreThan1Editor
go

CREATE FUNCTION [dbo].[MoreThan1Editor] (@Editormin SMALLINT)
returns table as return
(select writerID, 
		count(editorID) numberEditor
from review
group by writerID
having count(editorID) > @Editormin
)
go

select * from dbo.MoreThan1Editor (1);
go

