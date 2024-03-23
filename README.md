# tmi-web

## Backup production database

  heroku pg:backups:capture --app tmi-web 
  heroku pg:backups:download --app tmi-web
  
## Load backup into local db

  pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d tmi_web_development latest.dump
  
  
