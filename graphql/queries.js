const { db } = require("../utils/postgres");
const { GraphQLObjectType, GraphQLID, GraphQLList } = require("graphql");
const { DishType,RecipeType } = require("./types");

const RootQuery = new GraphQLObjectType({
    name: "RootQueryType",
    type: "Query",
    fields: {
        dishes: {
            type: new GraphQLList(DishType),
            resolve() {
                const query = `
                with recursive raw_data as (
    select 
        pk_dis_id, 
        dis_name, 
        fk_dis_rpe_dish_id, 
        fk_rpe_rpe_recipe_id, 
        jsonb_build_object('id', pk_rpe_id, 'name', rpe_name, 'ingredients', json_agg(jsonb_build_object('id', pk_ing_id, 'name', ing_name))) as recipes
    from tst_recipe_rpe rpe
    left join tst_dish_dis on pk_dis_id = fk_dis_rpe_dish_id
    left join tst_recipe_ingredient_rig on fk_rpe_rig_recipe_id = pk_rpe_id
    left join tst_ingredient_ing on pk_ing_id = fk_ing_rig_ingredient_id 
    where not exists (select 1 from tst_recipe_rpe rpe2 where rpe2.rpe_path like rpe.rpe_path || '_%')
    group by pk_dis_id, dis_name, fk_dis_rpe_dish_id, fk_rpe_rpe_recipe_id, pk_rpe_id, rpe_name
    union all
    select  
        dis.pk_dis_id, 
        dis.dis_name, 
        rpe.fk_dis_rpe_dish_id, 
        rpe.fk_rpe_rpe_recipe_id, 
        jsonb_build_object(
                'id', rpe.pk_rpe_id, 
                'name', rpe.rpe_name,
                'recipes', jsonb_build_array(rd.recipes),
                'ingredients', (
                        select 
                        JSON_AGG(jsonb_build_object('id', pk_ing_id, 'name', ing_name)) 
                        from tst_recipe_ingredient_rig
                        left join tst_ingredient_ing on pk_ing_id = fk_ing_rig_ingredient_id 
                        where fk_rpe_rig_recipe_id = rpe.pk_rpe_id
                )
        )
    from raw_data rd
    left join tst_recipe_rpe rpe on rd.fk_rpe_rpe_recipe_id = rpe.pk_rpe_id
    left join tst_dish_dis dis on dis.pk_dis_id = rpe.fk_dis_rpe_dish_id
    where rd.fk_rpe_rpe_recipe_id is not null
    )
    select pk_dis_id as id, dis_name as name, jsonb_agg(raw_data.recipes) as recipes,
    (
        select 
        JSON_AGG(jsonb_build_object('id', pk_ing_id, 'name', ing_name)) 
        from tst_dish_ingredients_dig
        left join tst_ingredient_ing on pk_ing_id = fk_ing_dig_ingredient_id
        where fk_dis_dig_dish_id = pk_dis_id
    ) ingredients
    from raw_data
    where pk_dis_id is not null
    group by pk_dis_id, dis_name
    ;
                `;
                return db
                    .query(query)
                    .then(res => res)
                    .catch(err => err);
            }
        }
    }
});

exports.query = RootQuery;