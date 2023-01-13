USE quan_ly_sinh_vien;

-- Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’
SELECT 
    *
FROM
    student
WHERE
    student_name LIKE 'h%';

-- Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12
SELECT 
    *
FROM
    class
WHERE
    MONTH(start_date) = 12;

-- Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5
SELECT 
    *
FROM
    `subject`
WHERE
    credit BETWEEN 3 AND 5;

-- Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2
set sql_safe_updates = 0;
UPDATE student 
SET 
    class_id = 2
WHERE
    student_name = 'Hung';
set sql_safe_updates = 1;

-- Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần
SELECT 
    student_name, sub_name, mark
FROM
    mark
        JOIN
    `subject` ON mark.sub_id = `subject`.sub_id
        JOIN
    student ON mark.student_id = student.student_id
ORDER BY mark DESC , student.student_name ASC;