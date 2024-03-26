# tmi-web

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

## Backup production database

  heroku pg:backups:capture --app tmi-web 
  heroku pg:backups:download --app tmi-web
  
## Load backup into local db

  pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d tmi_web_development db/latest.dump
  
## Update neo4j schema

Note: `noglob` required under zsh

  noglob rake neo4j:generate_schema_migration[constraint,Tag,uuid]
  rake neo4j:migrate

## neo4j hosting

  https://console.neo4j.io
  
## neo4j database constraints

CREATE CONSTRAINT `constraint_651783b9` FOR (n:`Persona`) REQUIRE (n.`uuid`) IS
UNIQUE OPTIONS {indexConfig: {}, indexProvider: 'range-1.0}

CREATE CONSTRAINT `constraint_b3f651ab` FOR (n:`Tag`) REQUIRE (n.`uuid`) IS UNIQUE
  OPTIONS {indexConfig: {}, indexProvider: 'range-1.0'}

CREATE CONSTRAINT `constraint_dbcee0a4` FOR (n:`ActiveGraph::Migrations::SchemaMigration`)
  REQUIRE (n.`migration_id`) IS UNIQUE OPTIONS {indexConfig: {}, indexProvider: 'range-1.0'}

CREATE CONSTRAINT `constraint_dd2c112` FOR (n:`Theme`) REQUIRE (n.`uuid`) IS UNIQUE
  OPTIONS {indexConfig: {}, indexProvider: 'range-1.0}
