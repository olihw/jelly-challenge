create table tst_dish_dis (
        pk_dis_id serial primary key not null,
        dis_name varchar(100) not null,
        dis_modified_at timestamp not null default CURRENT_TIMESTAMP,
        dis_modified_by char(4) not null,
        dis_created_at timestamp not null default CURRENT_TIMESTAMP,
        dis_created_by char(4) not null
);

create table tst_recipe_rpe (
        pk_rpe_id serial primary key not null,
        rpe_name varchar(100) not null,
        fk_dis_rpe_dish_id integer null references tst_dish_dis(pk_dis_id),
        fk_rpe_rpe_recipe_id integer null references tst_recipe_rpe(pk_rpe_id),
        check (fk_dis_rpe_dish_id is not null or fk_rpe_rpe_recipe_id is not null),
        rpe_path varchar(100) not null,
        rpe_level integer not null,
        rpe_modified_at timestamp not null default current_timestamp,
        rpe_modified_by char(4) not null,
        rpe_created_at timestamp not null default current_timestamp,
        rpe_created_by char(4) not null
);

create table tst_ingredient_ing (
        pk_ing_id serial primary key not null,
        ing_name varchar(100) not null unique,
        ing_modified_at timestamp not null default current_timestamp,
        ing_modified_by char(4) not null,
        ing_created_at timestamp not null default current_timestamp,
        ing_created_by char(4) not null
);

create table tst_dish_ingredients_dig (
        pk_dig_id serial primary key not null,
        fk_dis_dig_dish_id integer not null references tst_dish_dis(pk_dis_id),
        fk_ing_dig_ingredient_id integer not null references tst_ingredient_ing(pk_ing_id),
        dig_amount integer not null,
        dig_modified_at timestamp not null default current_timestamp,
        dig_modified_by char(4) not null,
        dig_created_at timestamp not null default current_timestamp,
        dig_created_by char(4) not null
);

create table tst_recipe_ingredient_rig (
        pk_rig_id serial primary key not null,
        fk_rpe_rig_recipe_id integer not null references tst_recipe_rpe(pk_rpe_id),
        fk_ing_rig_ingredient_id integer not null references tst_ingredient_ing(pk_ing_id),
        rig_amount integer not null,
        rig_modified_at timestamp not null default current_timestamp,
        rig_modified_by char(4) not null,
        rig_created_at timestamp not null default current_timestamp,
        rig_created_by char(4) not null
);


insert into tst_dish_dis (dis_name, dis_modified_by, dis_created_by)
select 'Dish 1', 'olha','olha' union all
select 'Dish 2', 'olha','olha';

insert into tst_recipe_rpe (rpe_name, fk_dis_rpe_dish_id, fk_rpe_rpe_recipe_id, rpe_path, rpe_level, rpe_modified_by, rpe_created_by) values ('Recipe 1', (select pk_dis_id from tst_dish_dis where dis_name = 'Dish 1'), null, '0001', 1, 'olha','olha');
insert into tst_recipe_rpe (rpe_name, fk_dis_rpe_dish_id, fk_rpe_rpe_recipe_id, rpe_path, rpe_level, rpe_modified_by, rpe_created_by) values ('Recipe 2', (select pk_dis_id from tst_dish_dis where dis_name = 'Dish 1'), null, '0002', 1, 'olha','olha');
insert into tst_recipe_rpe (rpe_name, fk_dis_rpe_dish_id, fk_rpe_rpe_recipe_id, rpe_path, rpe_level, rpe_modified_by, rpe_created_by) values ('Recipe 3', (select pk_dis_id from tst_dish_dis where dis_name = 'Dish 2'), null, '0003', 1, 'olha','olha');
insert into tst_recipe_rpe (rpe_name, fk_dis_rpe_dish_id, fk_rpe_rpe_recipe_id, rpe_path, rpe_level, rpe_modified_by, rpe_created_by) values ('Recipe 4', (select pk_dis_id from tst_dish_dis where dis_name = 'Dish 2'), null, '0004', 1, 'olha','olha');
insert into tst_recipe_rpe (rpe_name, fk_dis_rpe_dish_id, fk_rpe_rpe_recipe_id, rpe_path, rpe_level, rpe_modified_by, rpe_created_by) values ('Recipe 5', (select pk_dis_id from tst_dish_dis where dis_name = 'Dish 2'), null, '0005', 1, 'olha','olha');
insert into tst_recipe_rpe (rpe_name, fk_dis_rpe_dish_id, fk_rpe_rpe_recipe_id, rpe_path, rpe_level, rpe_modified_by, rpe_created_by) values ('Recipe 6', null, (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 1'), '00010001', 2, 'olha','olha');
insert into tst_recipe_rpe (rpe_name, fk_dis_rpe_dish_id, fk_rpe_rpe_recipe_id, rpe_path, rpe_level, rpe_modified_by, rpe_created_by) values ('Recipe 7', null, (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 1'), '00010002', 2, 'olha','olha');
insert into tst_recipe_rpe (rpe_name, fk_dis_rpe_dish_id, fk_rpe_rpe_recipe_id, rpe_path, rpe_level, rpe_modified_by, rpe_created_by) values ('Recipe 8', null, (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 6'), '000100010001', 3, 'olha','olha');

insert into tst_ingredient_ing (ing_name, ing_modified_by, ing_created_by)
select 'Ingredient 1', 'olha', 'olha' union all
select 'Ingredient 2', 'olha', 'olha' union all
select 'Ingredient 3', 'olha', 'olha' union all
select 'Ingredient 4', 'olha', 'olha' union all
select 'Ingredient 5', 'olha', 'olha' union all
select 'Ingredient 6', 'olha', 'olha' union all
select 'Ingredient 7', 'olha', 'olha' union all
select 'Ingredient 8', 'olha', 'olha' union all
select 'Ingredient 9', 'olha', 'olha' union all
select 'Ingredient 10', 'olha', 'olha';

insert into tst_dish_ingredients_dig (fk_dis_dig_dish_id,fk_ing_dig_ingredient_id,dig_amount, dig_modified_by, dig_created_by)
select (select pk_dis_id from tst_dish_dis where dis_name = 'Dish 1'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 1'), 10, 'olha', 'olha'  UNION ALL
select (select pk_dis_id from tst_dish_dis where dis_name = 'Dish 1'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 2'), 100, 'olha', 'olha'  UNION ALL
select (select pk_dis_id from tst_dish_dis where dis_name = 'Dish 1'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 3'), 20, 'olha', 'olha'  UNION ALL
select (select pk_dis_id from tst_dish_dis where dis_name = 'Dish 2'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 2'), 20, 'olha', 'olha'  UNION ALL
select (select pk_dis_id from tst_dish_dis where dis_name = 'Dish 2'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 4'), 20, 'olha', 'olha';


insert into tst_recipe_ingredient_rig (fk_rpe_rig_recipe_id,fk_ing_rig_ingredient_id, rig_amount, rig_modified_by, rig_created_by)
select (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 1'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 6'), 200, 'olha','olha' union all
select (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 1'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 7'), 200, 'olha','olha' union all
select (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 1'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 8'), 100, 'olha','olha' union all
select (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 2'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 1'), 50, 'olha','olha' union all
select (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 2'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 5'), 40, 'olha','olha' union all
select (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 2'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 9'), 30, 'olha','olha' union all
select (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 3'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 10'), 2, 'olha','olha' union all
select (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 4'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 9'), 100, 'olha','olha' union all
select (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 5'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 8'), 40, 'olha','olha' union all
select (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 6'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 7'), 4, 'olha','olha' union all
select (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 7'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 6'), 20, 'olha','olha' union all
select (select pk_rpe_id from tst_recipe_rpe where rpe_name = 'Recipe 8'), (select pk_ing_id from tst_ingredient_ing where ing_name = 'Ingredient 5'), 80, 'olha','olha';

