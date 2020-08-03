
with recursive raw_data as (
select pk_dis_id, dis_name, pk_rpe_id, rpe_name, fk_rpe_rpe_recipe_id
from tst_dish_dis
left join tst_recipe_rpe on fk_dis_rpe_dish_id = pk_dis_id
union all
select pk_dis_id, dis_name, rpe.pk_rpe_id, rpe.rpe_name, rpe.fk_rpe_rpe_recipe_id
from raw_data rd
left join tst_recipe_rpe rpe on rd.pk_rpe_id = rpe.fk_rpe_rpe_recipe_id
where rpe.fk_rpe_rpe_recipe_id is not null
)
select *
from raw_data;


with recursive raw_data as (
select null as pk_dis_id, null as dis_name, pk_rpe_id, fk_rpe_rpe_recipe_id, rpe_path, rpe_level
from tst_recipe_rpe
where rpe_level = (select max(rpe_level) from tst_recipe_rpe)
union all
select null as pk_dis_id, null as dis_name, rpe.pk_rpe_id, rpe.fk_rpe_rpe_recipe_id, rpe.rpe_path, rpe.rpe_level
from raw_data rd
left join tst_recipe_rpe rpe on rd.fk_rpe_rpe_recipe_id = rpe.pk_rpe_id
where rpe.rpe_level < 3
)
select *
from raw_data;



select rpe.rpe_path, max(rpe_level)
From (
select rpe_path
from tst_recipe_rpe
where rpe_level = 1
) a
left join tst_recipe_rpe rpe on rpe.rpe_path like  a.rpe_path || '%'
group by rpe.rpe_path, rpe_level;







with recursive raw_data as (
select pk_dis_id, dis_name, pk_rpe_id, rpe_name, fk_rpe_rpe_recipe_id, rpe_path, rpe_level,JSON_BUILD_OBJECT('id', pk_rpe_id, 'name', rpe_name) as recipe
from (
select substring(rpe_path,1,4) first_path, max(rpe_level) max_level
from tst_recipe_rpe
group by substring(rpe_path,1,4)
) a
left join tst_recipe_rpe on max_level = rpe_level and rpe_path like first_path || '%'
left join tst_dish_dis on pk_dis_id = fk_dis_rpe_dish_id
union all
select dis.pk_dis_id, dis.dis_name, rpe.pk_rpe_id, rpe.rpe_name, rpe.fk_rpe_rpe_recipe_id, rpe.rpe_path, rpe.rpe_level,JSON_BUILD_OBJECT('id', rpe.pk_rpe_id, 'name', rpe.rpe_name, 'recipe', rd.recipe) as recipe
from raw_data rd
left join tst_recipe_rpe rpe on rd.rpe_path <> rpe.rpe_path and rd.rpe_path like rpe.rpe_path || '%'
left join tst_dish_dis dis on dis.pk_dis_id = fk_dis_rpe_dish_id
where rpe.rpe_level < 3
)
select *
from raw_data;


with recursive raw_data as (
select pk_dis_id, dis_name, fk_dis_rpe_dish_id, fk_rpe_rpe_recipe_id, JSONb_agg(jsonb_build_object('id', pk_rpe_id, 'name', rpe_name)) as recipes
from tst_recipe_rpe rpe
left join tst_dish_dis on pk_dis_id = fk_dis_rpe_dish_id
where not exists (select 1 from tst_recipe_rpe rpe2 where rpe2.rpe_path like rpe.rpe_path || '_%')
group by  pk_dis_id, dis_name,fk_dis_rpe_dish_id, fk_rpe_rpe_recipe_id
union all
select  dis.pk_dis_id, dis.dis_name, rpe.fk_dis_rpe_dish_id, rpe.fk_rpe_rpe_recipe_id, jsonb_build_object('id', rpe.pk_rpe_id, 'name', rpe.rpe_name) || jsonb_build_object('recipes',recipes)
from raw_data rd
left join tst_recipe_rpe rpe on rd.fk_rpe_rpe_recipe_id = rpe.pk_rpe_id
left join tst_dish_dis dis on dis.pk_dis_id = rpe.fk_dis_rpe_dish_id
where rd.fk_rpe_rpe_recipe_id is not null
)
select *  --pk_dis_id, dis_name, jsonb_agg(recipes)
from raw_data
where pk_dis_id is not null
--group by pk_dis_id, dis_name
;

select * from tst_recipe_rpe rpe
where pk_dis_id is not null