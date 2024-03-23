# tmi-web

## Backup production database

  heroku pg:backups:capture --app tmi-web 
  heroku pg:backups:download --app tmi-web
  
## Load backup into local db

  pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d tmi_web_development db/latest.dump
  
## Update neo4j schema
Note: `noglob` required under zsh

  noglob rake neo4j:generate_schema_migration[constraint,Tag,uuid]
  rake neo4j:migrate
