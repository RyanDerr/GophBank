# Postgres Database Configuration Overview

## Local Postgres Database
The `docker-compose.yml` file is used to orchestrate the creation and configuration of two Docker containers: a PostgreSQL database and a Liquibase container.

### PostgreSQL Container
The PostgreSQL container is a popular open-source relational database. In this setup, it is used to store and manage the data for your application.

### Liquibase Container
The Liquibase container is used to manage database schema changes. It applies changes to the PostgreSQL database using a changelog file.

The changelog file `/liquibase/changelog.yml` contains a series of changesets, each of which describes a change to the database schema. These changesets are applied in the order they appear in the changelog.

The actual changesets are stored in separate files under the `/liquibase/changelogs/` directory. This allows for better organization and version control of your database schema changes.


### Workflow
To get running locally you run `docker-compose up -d`

Docker Compose will:

- Start a PostgreSQL container.
- Start a Liquibase container.
- The Liquibase container will then read the `/liquibase/changelog.yml` file and apply the changesets found in the `/liquibase/changelogs/` directory to the PostgreSQL database.
- The condition: `service_healthy` line in the `docker-compose.yml` file ensures that Docker Compose waits for the PostgreSQL service to be healthy before starting the Liquibase service. This is crucial as the Liquibase service depends on the PostgreSQL service to be running and healthy.

This setup ensures that your database schema is always in a known state and can be reliably reproduced across different environments.

# Important Notes
- When desiring to update the database on local or remote AWS it's important that once a change has been completed if an update or new change is desired you will need to create a new changelog record and file to perform the change, you cannot go back and edit an already applied file.