# TMI-Web

TMI-Web is a social science research tool for managing, analyzing, coding, and visualizing qualitative survey data on identities. It presents identity and experience in a network graph, encouraging tactile exploration of intersectional identities and facets of privilege and marginalization.

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

## Setting up a local development environment

TMI-Web has three primary components: the web application, the survey response database, and the identity graph database. Instructions for installing and running TMI-Web locally are provided below.
 
### Install Ruby

TMI-Web requires Ruby version 3.2.2 or higher. To check what version of Ruby your computer has installed, go to your terminal and type

    ruby -v
    
Upgrade your Ruby version as needed using the package manager of your choice. If you need help, refer to the Ruby installation page at https://www.ruby-lang.org/en/documentation/installation/

### Install PostgreSQL

TMI-Web uses two databases, on of which is the relational database PostgreSQL. You will need to install and run postgres using the instructions at https://www.postgresql.org/download/

### Install Neo4j

The other database that TMI-Web uses is the graph database Neo4j. You can install Neo4j from https://neo4j.com/product/neo4j-graph-database/

Once installed, you will need to start Neo4j, most easily using the native application. Use the application to create an empty database called `tmi-graph`. You will need to manually start the database from the application each time prior to starting the Rails application.

### Rails

TMI-Web uses Ruby on Rails as a web application framework. It also uses a number of specialized Ruby libraries called gems. To install everything that the web application needs, navigate in your terminal to the tmi-web directory that you cloned from Github. Then type

    bundle

If you get any errors, you may need to do some searching on the web to fix your installation problems. Read the error message carefully to see which Ruby gem is having trouble being installed, and search for that along with the name and version of your operating system. 

Take heart! If everything goes smoothly, you're all set. And if something went wrong, diagnosing the installation will be the hardest part, and it's all smooth going from there.

### Preparing the Postgres database

From your local terminal, run the following commands:

    rake db:create
    rake db:migrate

If you get an error, check that postgres is running on your system.
    
### Preparing the Neo4j database

From your local terminal, type:

  rake neo4j:migrate

If you get an error, make sure that Neo4j is running and the tmi-web is started.
      
### Starting the application

To start TMI-web, type

    bin/rails server
    
You should see the output logs from the application begin to scroll into view. The application will continue running in that terminal shell until you interrupt the process (with cmd-c) or otherwise terminate the application. Shutting down the application can be safely done at any time.

Now that the application has been started, visit `localhost:3000` in your web browser.

## Dev concerns

### Start local sidekiq

  bundle exec sidekiq

### Clear sidekiq (background job) queue

  Sidekiq.redis(&:flushdb)

### Backup production postgres database

  heroku pg:backups:capture --app tmi-web
  heroku pg:backups:download --app tmi-web

### Restore production postgres database to last db capture

  heroku pg:backups:restore --app tmi-web

### Load postgres database backup into local db

  pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d tmi_web_development db/latest.dump

### Update neo4j schema

  rake neo4j:migrate

### Generate rdocs

  rdoc -op doc

## Dashboards

### neo4j hosting

  https://console.neo4j.io

### ChatGPT API dashboard

  https://platform.openai.com
