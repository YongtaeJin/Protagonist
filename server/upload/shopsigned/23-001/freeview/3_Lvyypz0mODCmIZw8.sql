




select a.i_shop, a.i_no,
       n_company,
       f_persioninfo,
       if(coalesce(
           length(trim(i_regno)) + length(trim(n_company)) + length(trim(n_person)) + length(trim(t_tel1)) + length(trim(t_tel2)) + length(trim(i_email)) +
             length(trim(i_presno)) + length(trim(i_post)) + length(trim(t_addr1)) + length(trim(t_addr2)) + length(trim(t_tel2)) + length(trim(f_saugup)) +
             length(trim(f_run)) + length(trim(f_dart)) + length(trim(t_enarainfo)) + length(trim(t_enarainfopw))
           , 0) > 0, 'Y', 'N') chk1,
       if(b.f_f1y = c.f_u1y, 'Y', 'N') chk2,
       if(b.f_f2y = c.f_u2y, 'Y', 'N') chk3,
       if(b.f_f3y = c.f_u3y, 'Y', 'N') chk4,
       f_dochk,
       f_enarachk

  from tb_shopinput a
       left outer join (select i_shop, 
                               sum(case when f_gubun = '1' and f_yn = '1' then 1 else 0 end) f_f1y,
                               sum(case when f_gubun = '1' and f_yn = '0' then 1 else 0 end) f_f1n,
                               sum(case when f_gubun = '2' and f_yn = '1' then 1 else 0 end) f_f2y,
                               sum(case when f_gubun = '2' and f_yn = '0' then 1 else 0 end) f_f2n,
                               sum(case when f_gubun = '3' and f_yn = '1' then 1 else 0 end) f_f3y,
                               sum(case when f_gubun = '3' and f_yn = '0' then 1 else 0 end) f_f3n
                          from tb_shopmag_file 
                         where i_shop = '23-001' 
                         group by i_shop) b on a.i_shop = b.i_shop
       left outer join (select c2.i_shop, c2.i_no,
                               sum(case when f_gubun = '1' and f_yn = '1' then 1 else 0 end) f_u1y,
                               sum(case when f_gubun = '1' and f_yn = '0' then 1 else 0 end) f_u1n,
                               sum(case when f_gubun = '2' and f_yn = '1' then 1 else 0 end) f_u2y,
                               sum(case when f_gubun = '2' and f_yn = '0' then 1 else 0 end) f_u2n,
                               sum(case when f_gubun = '3' and f_yn = '1' then 1 else 0 end) f_u3y,
                               sum(case when f_gubun = '3' and f_yn = '0' then 1 else 0 end) f_u3n
                          from tb_shopmag_file c1
                               join tb_shopinput_file c2 on  c1.i_shop = c2.i_shop and c1.i_ser = c2.i_ser
                         where c1.i_shop = '23-001' 
                         group by c2.i_shop, c2.i_no) c on a.i_shop = b.i_shop and a.i_no = c.i_no
  where a.i_shop = '23-001' 

;