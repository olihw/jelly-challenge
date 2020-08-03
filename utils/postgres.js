const pgPromise = require('pg-promise');

const pgp = pgPromise({}); // Empty object means no additional config required

const config = {
    host:'localhost',
    port: 5555,
    database: 'testdb',
    user: 'postgres',
    password: 'postgres'
};

const db = pgp(config);

exports.db = db;