"use strict";
const graphql = require("graphql");
const express = require("express");
const { graphqlHTTP } = require('express-graphql');
const { GraphQLSchema  } = require('graphql');
const { query } = require("./graphql/queries");

const schema = new GraphQLSchema({
  query
});

const app = express();
app.use(
    '/',
    graphqlHTTP({
      schema: schema,
      graphiql: true,
    })
);

app.listen(3000, () =>
    console.log('GraphQL server running on localhost:3000')
);