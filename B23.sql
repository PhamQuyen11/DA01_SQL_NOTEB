With customer_rfm as (
Select a.customer_id, current_date – max(order_date) as R,
Count (distinct order_id) as F,
Sum (sales) as M,
From customer a
Join sales b on a.customer_id = b.customer_id
Group by a.customer_id),

rfm_score as (
Select customer_id
Ntile (5) over (order by R desc) as R_score,
Ntile (5) over (order by F) as F_score,
Ntile (5) over (order by M) as M_score
From customer_rfm)

, rfm_final as (
Select customer_id, cast (R_score as varchar) || cast (F_score as varchar || cast (M_score as varchar) as rfm_score
From rfm_score)

Select segment, count (*) from (
Select a.customer_id, b.segment from rfm_final a
Join segment_score b on a.rfm_score = b.scores ) as a
Group by segment 
Order by count (*)
