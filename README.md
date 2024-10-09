# TMI-Web

TMI-Web is a social science research tool for managing, analyzing, coding, and visualizing qualitative survey data on identities. It presents identity and experience in a network graph, encouraging tactile exploration of intersectional identities and facets of privilege and marginalization.

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

## High-level architecture

TMI-Web has three primary components: the web application, the survey response database, and the persona database.

![image](https://github.com/CoralineAda/tmi-web/blob/main/diagrams/tmi-architecture.png)

Survey data is exported from your survey platform as a comma-separated-value (CSV) file, then imported into TMI-Web using the browser interface. TMI-Web stores the survey response data in a relational database, and creates personas in a graph database as the survey data is analyzed.

(To make sure that the web application is always responsive, certain long-running operations are carried out in the background, requiring a key-value store database that's used for a background job queue.)

## Setting up your local development environment

Instructions for installing and running TMI-Web locally are provided below.

### Get to your command line

Depending on the operating system you use, there may be different ways for you to access your local command line. Understanding how to navigate the file system and run programs from the command line is essential, so you're encouraged to find tutorials if you need help getting started.

### Clone this repository

In your terminal, navigate to the folder you use to store your other code projects. Or, you can navigate to any convenient location in your home directory.

Make a local copy of this repository by typing:

    git clone git@github.com:identity-research-lab/tmi-web.git

Navigate to the `tmi-web` directory with:

    cd tmi-web/

The rest of the instructions below assume that you are in the root `tmi-web` directory.

### Install Ruby

TMI-Web requires Ruby version 3.2.2 or higher. To check what version of Ruby your computer has installed, type:

    ruby -v

Upgrade your Ruby version as needed using the package manager of your choice. If you need help, refer to the Ruby installation guide at [https://www.ruby-lang.org/en/documentation/installation/](https://www.ruby-lang.org/en/documentation/installation/)

### Install PostgreSQL

The first database to set up is the relational database, PostgreSQL. (This is the database that survey responses are stored in.)

You can install and run PostgreSQL using the instructions at [https://www.postgresql.org/download/](https://www.postgresql.org/download/)

### Install Neo4j

The next database to set up is the graph database, Neo4j. (This is where interactive personas and identity and experience codes are stored.)

You can install Neo4j from [https://neo4j.com/product/neo4j-graph-database/](https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/)

Once installed, open the Neo4j native application and use the interface to create an empty database called `tmi_graph`. You will need to keep the Neo4j application open and the `tmi_graph` database started while running the Rails application locally.

### Install Redis

The final database to install is Redis. (Redis is used by TMI-Web as a queue for background jobs.) You can find instructions at [https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/](https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/)

### Install the Rails application

TMI-Web is built on the Ruby on Rails web application framework. It also uses a number of specialized Ruby libraries called gems. To install everything that the web application needs, make sure that you're in the `tmi-web` directory that you cloned from Github. Then type:

    bundle

If you get any errors, you may need to do some searching on the web to fix your installation problems. Read the error message carefully to see which Ruby gem is having trouble being installed, and search for that along with the name and version of your operating system.

Take heart! If everything goes smoothly, you're all set. And if something went wrong, diagnosing the installation will be the hardest part, and it's all smooth going from there.

### Prepare the PostgreSQL database

From the root `tmi-web` directory, run the following commands:

    rake db:drop
    rake db:create
    rake db:migrate

If you get an error, check that postgresql is running on your system.

### Prepare the Neo4j database

From the root directory of `tmi-web`, type:

    rake neo4j:migrate

If you get an error, make sure that Neo4j is running and that the `tmi_graph` database is started.

### Set environment variables

Before you start the application for the first time, there are some global environment variables that you need to set. Rails will look for them in a file named `.env` in the root `tmi-web` directory.

*IMPORTANT!* This file will contain your sensitive API keys, so you want to keep it secure. Do not commit the `.env` file to a source code repository, even a private one.

To create your local `.env` file, make a copy of `.env.example`. (This filename starts with a "." so it will be hidden by default. Use `ls -a` in your terminal to list all files in the directory, including invisible ones.) To make a copy of the example file, type:

    cp .env.example .env

Now, when you open the `.env` file in your text editor, you'll see a list of key/value pairs that need filling in. These are configuration options including database credentials, customizations, and the API keys that TMI-Web needs to communicate with third-party services. Follow the instructions provided in the file to register for the appropriate API keys.

### Run the test suite

    rspec --format documentation spec/

To always run rspec with the documentation flag:

    echo "--format documentation" > .rspec

### Start the background job runner

From the root directory of tmi-web, launch Sidekiq by typing:

    bundle exec sidekiq

You will see the log files for Sidekiq scroll into view. Sidekiq will continue running in the background until you terminate it with `control-c`.

### Start the application

To start TMI-web, type

    bin/rails server

You should see the output logs from the application begin to scroll into view. The application will continue running in that terminal shell until you interrupt the process (with `control-c`) or otherwise terminate the application. Shutting down the application can be safely done at any time.

Now that the application has been started, visit [http://localhost:3000](http://localhost:3000) in your web browser.

### Import sample data

In your browser, use the `Upload` navigation link. Click on the file selector, and navigate to the "data" directory inside the TMI-Web project directory. Select the file named `sample_data.csv` and click the `Upload and Merge` button. This creates 100 survey response records with random text.

Since TMI-Web is designed to merge sets of survey responses, note that you will need to completely reset your database before importing real survey responses. Refer to [Prepare the PostgreSQL database](#prepare-the-PostgreSQL-database) above for instructions.

### What to do if the application doesn't start

If you forgot to open the Neo4j application and start the `tmi_graph` database, the Rails application will hang as it tries to connect, and time out after 60 seconds. You'll always need to keep Neo4j running in the background while you're using TMI-Web in your local environment.

You may get an error that has to do with database migrations. This means that your local database is missing updates and changes to the database structure since the last time you ran the application.

To update the Postgresql database, from the root directory of `tmi-web` type:

    rake db:migrate

To update the Neo4j database, type:

    rake neo4j:migrate

## The code

### Reading the code

If you're new to Ruby, but know how to program in another language, there's a great guide to applying what you already know to Ruby at https://www.ruby-lang.org/en/documentation/ruby-from-other-languages/.

The code in TMI-Web is thoroughly commented, and the test suite is not only functional but acts as further documentation. The code has been written to be as simple and readable as possible, sometimes at the expense of elegance or performance.

### Read the docs

You can explore code documentation in your browser by typing:

    open doc/index.html

## Common tasks

### Clear the Sidekiq (background job) queue

Launch the local interactive Rails console:

    bin/rails console

At the prompt, type:

    Sidekiq.redis(&:flushdb)

To exit the console:

    exit

### Back up production PostgresSQL database

Navigate in your terminal to the `db` directory and run these commands:

    heroku pg:backups:capture --app tmi-web
    heroku pg:backups:download --app tmi-web

### Load PostgresSQL database backup into local db

Navigate in your terminal to root directory of the project and type

    pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d tmi_web_development db/latest.dump

### Restore production PostgresSQL database to last db capture

    heroku pg:backups:restore --app tmi-web

### Update the Neo4j database schema

    rake neo4j:migrate

### Generate a sample data comma-separated-value (CSV) file for upload

    rake export:sample_data

or

    rake 'export:sample_data'

### Generate code documentation

    rdoc -op doc

## Graph data model

There are four types of nodes in the graph database. They all center on the `Persona`. Each pair of nodes is connected by a uniquely labeled edge.

![image](https://github.com/CoralineAda/tmi-web/blob/main/diagrams/tmi-data-model.png)

### Persona
A `Persona` is a representation or data avatar of someone who completed the survey.

### Category
A `Category` is a label applied to a group of related Codes within a provided context. For example, a category may refer to a subset of the codes related to "age".

Categories are machine-derived. As such, they are influenced by biases in external training data. Careful human discernment of categories is required to identify and address these biases.

### Code
A `Code` is a label applied to a group of related responses within a provided context. For example, a Code like "self-reflects" may be be applied to one or more responses to the Age Experience question.

Since codes are contextual, they are not unique. If "self-reflects" is coded for both Gender Experience and Age Experience, there will be two distinct Codes, each with the appropriate context.

### Identity
An `Identity` is a word or phrase used by a survey participant to self-describe. Identities have associated contexts.

### Keyword
Keywords are the nouns extracted from a 'corpus' consisting of the exact text of certain freeform response fields. The extraction is performed using AI assistance, so results are non-determinate and must be assessed for bias by the researchers.

## Reference links

* [https://console.neo4j.io](https://console.neo4j.io)
* [https://platform.openai.com](https://console.neo4j.io)
