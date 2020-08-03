const graphql = require("graphql");
const { GraphQLObjectType, GraphQLString, GraphQLInt, GraphQLList,GraphQLNullableType } = graphql;

const IngredientType = new GraphQLObjectType({
    name: "Ingredient",
    type: "Query",
    fields: {
        id: { type: GraphQLInt },
        name: { type: GraphQLString },
    }
});

const RecipeType = new GraphQLObjectType({
    name: "Recipe",
    type: "Query",
    fields: function () {
        return {
            id: { type: GraphQLInt },
            name: { type: GraphQLString },
            recipes: {
                type: new GraphQLList(RecipeType)
            },
            ingredients: {type: new GraphQLList(IngredientType)}
        };
    }
});
const DishType = new GraphQLObjectType({
    name: "Dish",
    type: "Query",
    fields: {
        id: { type: GraphQLInt },
        name: { type: GraphQLString },
        recipes: {type: new GraphQLList(RecipeType)},
        ingredients: {type: new GraphQLList(IngredientType)}
    }
});

exports.DishType = DishType;
exports.RecipeType = RecipeType;