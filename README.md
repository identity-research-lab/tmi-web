# TMI-Web

TMI-Web is a social science research tool for managing, analyzing, coding, and visualizing qualitative survey data on identities. It presents identity and experience in a network graph, encouraging tactile exploration of intersectional identities and facets of privilege and marginalization.

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

## Setting up your local development environment

TMI-Web has three primary components: the web application, the survey response database, and the persona database. 

![image](https://github.com/CoralineAda/tmi-web/blob/main/diagrams/tmi-architecture.jpg)

Instructions for installing and running TMI-Web locally are provided below.
 
### Install Ruby

TMI-Web requires Ruby version 3.2.2 or higher. To check what version of Ruby your computer has installed, go to your terminal and type

    ruby -v
    
Upgrade your Ruby version as needed using the package manager of your choice. If you need help, refer to the Ruby installation guide at https://www.ruby-lang.org/en/documentation/installation/

### Install PostgreSQL

TMI-Web uses two databases, the first of which is the relational database PostgreSQL. (This is the database that survey responses are stored in.)

You will need to install and run postgres using the instructions at https://www.postgresql.org/download/

### Install Neo4j

The other database that TMI-Web uses is the graph database Neo4j. (This is where TMI-Graph data is stored, including interactive personas and identity and experience codes.)

You can install Neo4j from https://neo4j.com/product/neo4j-graph-database/

Once installed, you will need to start Neo4j, most easily using the native application. Use the application to create an empty database called `tmi_graph`. You will need to manually start the database from the application each time prior to starting the Rails application.

### Install the Rails application

TMI-Web uses Ruby on Rails as a web application framework. It also uses a number of specialized Ruby libraries called gems. To install everything that the web application needs, navigate in your terminal to the tmi-web directory that you cloned from Github. Then type

    bundle

If you get any errors, you may need to do some searching on the web to fix your installation problems. Read the error message carefully to see which Ruby gem is having trouble being installed, and search for that along with the name and version of your operating system. 

Take heart! If everything goes smoothly, you're all set. And if something went wrong, diagnosing the installation will be the hardest part, and it's all smooth going from there.

### Prepare the Postgres database

From your local terminal, run the following commands:

    rake db:create
    rake db:migrate

If you get an error, check that postgres is running on your system.
    
### Prepare the Neo4j database

From your local terminal, type:

  rake neo4j:migrate

If you get an error, make sure that Neo4j is running and the tmi-web is started.

### Set environment variables

Before you start the application for the first time, there are some global environment variables that you need to set. Rails will look for them in a file named `.env` in the root tmi-web directory. 

*IMPORTANT* This file will contain your sensitive API keys, so you want to keep it secure. Do not commit the `.env` to a source code repository, even a private one.

To create your local `.env` file, make a copy of `.env.example`. (Since this filename starts with a `.`, it will be hidden by default. Use `ls -a` in your terminal to list all files in the directory, including invisible ones.) In the root directory of tmi-web, type

    cp .env.example .env
    
When you open the file in your editor, you'll see a list of key/value pairs that need filling in. Most of these are the API keys that TMI-Web needs to communicate with third-party services. Follow the instructions provided in the file to register for the appropriate API keys.

### Start the application

To start TMI-web, type

    bin/rails server
    
You should see the output logs from the application begin to scroll into view. The application will continue running in that terminal shell until you interrupt the process (with cmd-c) or otherwise terminate the application. Shutting down the application can be safely done at any time.

Now that the application has been started, visit [http://localhost:3000
](http://localhost:3000) in your web browser.

### What to do if the homepage times out

If you forgot to launch the Neo4j application and start the tmi_graph database, the Rails application will try to connect for 30+ seconds and then time out. You'll always need to keep Neo4j running in the background while you're using TMI-Web in your local environment.

You may get an error that has to do with database migrations. You may be missing changes to the database structure from the last time you ran the application. 

To update the Postgresql database, from the root directory of tmi-web type

    rake db:migrate
    
To update the Neo4j database, type

    rake neo4j:migrate
    
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
