create database furama_query;
drop database furama_query;
use furama_table;

-- 2. Hiển thị thông tin của tất cả nhân viên có trong hệ thống có tên bắt đầu là một trong các ký tự “H”, “T” hoặc “K” và có tối đa 15 kí tự.
select * from nhan_vien
where ho_ten like 'H%' or ho_ten like 'T%' or ho_ten like 'K%' and length(ho_ten)<=15;

-- 3. Hiển thị thông tin của tất cả khách hàng có độ tuổi từ 18 đến 50 tuổi và có địa chỉ ở “Đà Nẵng” hoặc “Quảng Trị”.
select * from khach_hang
where dia_chi like '% ĐÀ Nẵng' or dia_chi like '% Quảng Trị'
having (year(curdate()) - year(ngay_sinh)) between 18 and 50;

-- 4. Mỗi khách hàng đã từng đặt phòng bao nhiêu lần. Sắp xếp theo số lần đăt phòng. chỉ đếm khách hàng có tên loại khách 'diamond'
select kh.ho_ten, count(hd.ma_khach_hang) as 'so_lan_dat_phong' from khach_hang kh
join hop_dong hd on kh.ma_khach_hang = hd.ma_khach_hang
where kh.ma_loai_khach = 1
group by hd.ma_khach_hang;

-- 5. Hiển thị mã khách hàng , họ tên, tên loại khách,mã hợp đồng ,tên dịch vụ,ngày làm hợp đồng, ngày kết thúc , tổng tiền cho tất cả các khách hàng đã từng đặt phòng 
select distinct kh.ma_khach_hang, kh.ho_ten, lk.ten_loai_khach, hd.ma_hop_dong, hd.ngay_lam_hop_dong, hd.ngay_ket_thuc, dv.ten_dich_vu,dv.chi_phi_thue,hdct.so_luong,dvdk.gia,
(ifnull(dv.chi_phi_thue,0) + ifnull(sum(ifnull(hdct.so_luong,0)) * ifnull(dvdk.gia,0),0))'tong_tien'
from khach_hang kh
join loai_khach lk on lk.ma_loai_khach = kh.ma_loai_khach
left join hop_dong hd on kh.ma_khach_hang = hd.ma_khach_hang
left join hop_dong_chi_tiet hdct on hd.ma_hop_dong = hdct.ma_hop_dong
left join dich_vu dv on hd.ma_dich_vu = dv.ma_dich_vu
left join dich_vu_di_kem dvdk on dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
group by ma_khach_hang, ma_hop_dong ;

-- 6. HIển thị mã dịch vụ, tên dịch vụ, diện tích, chi phí thuê, tên loại dịch vụ của tất cả các dịch vụ chưa từng được khách hàng thực hiện dặt từ quý 1 của năm 2021
select dv.ma_dich_vu, dv.ten_dich_vu, dv.dien_tich, dv.chi_phi_thue, ldv.ten_loai_dich_vu
from dich_vu dv
join hop_dong hd on hd.ma_dich_vu = dv.ma_dich_vu
join loai_dich_vu ldv on ldv.ma_loai_dich_vu = dv.ma_loai_dich_vu
where year(hd.ngay_lam_hop_dong) < 2021;

-- 7. Hiển thị thông tin mã dịch vụ, tên dịch vụ, diện tích, số người tối đa, chi phí thuê, tên loại dịch vụ
select dv.ma_dich_vu, dv.ten_dich_vu, dv.dien_tich, dv.so_nguoi_toi_da, dv.chi_phi_thue, ldv.ten_loai_dich_vu,hd.ngay_lam_hop_dong
from dich_vu dv
join hop_dong hd on hd.ma_dich_vu = dv.ma_dich_vu
join loai_dich_vu ldv on ldv.ma_loai_dich_vu = dv.ma_loai_dich_vu
where year(hd.ngay_lam_hop_dong) not in (2021);

-- 8. Hiển thị thông tin họ và tên khách hàng có trong hệ thống, với yêu cầu họ tên không trùng nhau
-- cach 1
select ho_ten from khach_hang
group by ho_ten;

-- cach 2
select distinct ho_ten from khach_hang;

-- cach 3
select ho_ten from khach_hang
union
select ho_ten from khach_hang;

-- 9. thống kê doanh thu theo thang
select month(ngay_lam_hop_dong) 'Month', count(ngay_lam_hop_dong) 'so_hop_dong' from hop_dong
group by month(ngay_lam_hop_dong) 
order by month(ngay_lam_hop_dong);

-- 10. Hiển thị thông tin từng hợp đồng thì sử dụng bao nhiêu dịch vụ đi kèm
select hd.ma_hop_dong,hd.ngay_lam_hop_dong,hd.ngay_ket_thuc,hd.tien_dat_coc, ifnull(sum(hdct.so_luong),0) 'So_luong_dich_vu_di_kem'
from hop_dong hd
left join hop_dong_chi_tiet hdct on hd.ma_hop_dong = hdct.ma_hop_dong
group by hd.ma_hop_dong;

-- 11. Hiển thị thông tin các dịch vụ đi kèm bởi khách hàng Diamond và địa chỉ ở Vinh or quảng Ngãi
select dvdk.*
from dich_vu_di_kem dvdk
join hop_dong_chi_tiet hdct on hdct.ma_dich_vu_di_kem = dvdk.ma_dich_vu_di_kem
join hop_dong hd on hdct.ma_hop_dong = hd.ma_hop_dong
join khach_hang kh on kh.ma_khach_hang = hd.ma_khach_hang
join loai_khach lk on lk.ma_loai_khach = kh.ma_loai_khach
where kh.ma_loai_khach = 1 and ( kh.dia_chi like '%Vinh' or kh.dia_chi like '%Quảng Ngãi'); 

-- 12. Hiển thị thông tin mã hợp đồng, tên nhân viên, tên khach ,sđt, tên dịch vụ, số lượng dịch vụ đi kèm, tiền đặt cọc đặt vào 3 tháng cuối 2020 nhưng chưa đặt vào 6 tháng đâu 2021
select hd.ma_hop_dong, nv.ho_ten 'ten_nhan_vien',kh.ho_ten 'ten_khach_hang',kh.so_dien_thoai 'sdt_khach_hang',dv.ten_dich_vu,((ifnull(hdct.so_luong,0))) 'so_luong_dich_vu_di_kem',hd.tien_dat_coc
from hop_dong hd 
left join nhan_vien nv on hd.ma_nhan_vien = nv.ma_nhan_vien
left join khach_hang kh on hd.ma_khach_hang = kh.ma_khach_hang
left join hop_dong_chi_tiet hdct on hd.ma_hop_dong = hdct.ma_hop_dong 
left join dich_vu dv on hd.ma_dich_vu = dv.ma_dich_vu
where (month(hd.ngay_lam_hop_dong) in (10,11,12) 
and year (hd.ngay_lam_hop_dong) = 2020  )
and not (year(hd.ngay_lam_hop_dong) = 2021 
and ( month(hd.ngay_lam_hop_dong) <7) )
group by ma_hop_dong;

-- 13. Hiển thị thông tin các dịch vụ đi kèm được sử dụng nhiều nhất bởi các khách hàng đã đặt phòng
select dvdk.* , sum(hdct.so_luong) 'max_so_luong_dich_vu_di_kem' from dich_vu_di_kem dvdk 
join hop_dong_chi_tiet hdct on dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem 
group by ma_dich_vu_di_kem
having sum(hdct.so_luong) >= all ( select sum(hdct.so_luong) from hop_dong_chi_tiet hdct 
group by ma_dich_vu_di_kem);

-- 14 . Hiển thị thông tin các dich vụ đi kèm chỉ mới được sử dụng 1 lần duy nhất
select hd.ma_hop_dong, ldv.ten_loai_dich_vu,dvdk.ten_dich_vu_di_kem,count(hdct.ma_dich_vu_di_kem) 'so_lan_su_dung'
from loai_dich_vu ldv 
join dich_vu dv on dv.ma_loai_dich_vu = ldv.ma_loai_dich_vu
join hop_dong hd on hd.ma_hop_dong = dv.ma_dich_vu
join hop_dong_chi_tiet hdct on hdct.ma_hop_dong = hd.ma_hop_dong
join dich_vu_di_kem dvdk on dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
group by hdct.ma_dich_vu_di_kem
having count(hdct.ma_dich_vu_di_kem) = 1;

-- 15. Hiển thị thông tin của tất cả nhân viên chỉ lập được tối đa 3 hợp đồng từ năm 2020 đến 2021
select nv.ma_nhan_vien,nv.ho_ten,td.ten_trinh_do,bp.ten_bo_phan,nv.so_dien_thoai,nv.dia_chi
from nhan_vien nv
join trinh_do td on nv.ma_trinh_do =td.ma_trinh_do
join bo_phan bp on nv.ma_bo_phan = bp.ma_bo_phan
join hop_dong hd on hd.ma_nhan_vien = nv.ma_nhan_vien
where year(hd.ngay_lam_hop_dong) in (2020,2021)
group by hd.ma_nhan_vien
having count(hd.ma_nhan_vien) <= 3;

-- 16. Xóa những nhân viên chưa lập được hợp đồng nào  từ năm 2019 đến 2021
set sql_safe_updates = 0;
delete from nhan_vien nv
where nv.ma_nhan_vien not in ( select hd.ma_nhan_vien from hop_dong hd);
select * from nhan_vien;
set sql_safe_updates = 1;

-- 17. Cập nhật thông tin khách hàng từ platinum lên diamond,chỉ cập nhật những khách hàng đã từng đặt phòng với tổng tiền thanh toán trong năm 2021 lớn hơn 10 triệu
update khach_hang kh set kh.ma_loai_khach = 1 where kh.ma_loai_khach = 2;
select * from khach_hang;

-- 18. Xóa những khách hàng có hợp đồng trước năm 2021
set sql_safe_updates = 0;
set foreign_key_checks = 0;
delete from khach_hang 
where ma_khach_hang in (select ma_khach_hang from hop_dong where month (ngay_lam_hop_dong) =10);
set sql_safe_updates =1;
set foreign_key_checks = 1;

-- 19. Cập nhật giá cho các dịch vụ đi kèm được sử dụng trên 10 lần trong năm 2020 lên gấp đôi
set sql_safe_updates = 0;
update dich_vu_di_kem set gia = gia * 2 where ma_dich_vu_di_kem in ( select ma_dich_vu_di_kem from (select sum(hdct.so_luong),hdct.ma_dich_vu_di_kem from hop_dong_chi_tiet hdct
join hop_dong hd on hdct.ma_hop_dong = hd.ma_hop_dong
join dich_vu_di_kem dvdk on dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
where year(ngay_lam_hop_dong ) =2020
group by hdct.ma_dich_vu_di_kem 
having sum(hdct.so_luong) > 10) as tim_ma_dich_vu); 

-- Hiển thị thông tin của tát cả nhân viên và khách hàng có trong hệ thống 
select nv.ma_nhan_vien 'id' ,nv.ho_ten,nv.email,nv.so_dien_thoai,nv.ngay_sinh,nv.dia_chi from nhan_vien nv
union 
select kh.ma_khach_hang 'id' ,kh.ho_ten,kh.email,kh.so_dien_thoai,kh.ngay_sinh,kh.dia_chi from khach_hang kh
