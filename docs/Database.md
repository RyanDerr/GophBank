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

## Connecting To Remote RDS Database
To connect to a remote PostgreSQL RDS database using IAM authentication and pgAdmin, you will need to use the AWS CLI and pgAdmin.

Here are the steps:

1) **Download and Install pgAdmin**: If you haven't installed pgAdmin on your machine, you can do so by following the instructions on the [official pgAdmin download page](https://www.pgadmin.org/download/).

2) **Install AWS CLI**: If you haven't installed the AWS CLI on your machine, you can do so by following the instructions on the official [AWS CLI docs](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

3) **Configure AWS CLI**: Run aws configure in your terminal and provide your AWS Access Key ID, Secret Access Key, Default region name, and Default output format when prompted.

4) **Generate an IAM Authentication Token**: AWS RDS uses token-based authentication, which involves generating a token and using that as your password when connecting to the database. You can generate this token using the aws rds generate-db-auth-token command. Replace {db-endpoint}, {db-port}, and {aws-region} with your database endpoint, port, and AWS region respectively. The syntax is as follows:
    ```shell
    aws rds generate-db-auth-token \
        --hostname {db-endpoint} \
        --port {db-port} \
        --region {aws-region} \
        --username db_domain_users # This is taken from the user created for IAM access
    ```
5) **Download the Root Certificate**: To connect to your RDS instance over SSL, you'll need the RDS root certificate. You can download it from the [official AWS website](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html#UsingWithRDS.SSL.CertificatesAllRegions).

6) **Connect to the Database using pgAdmin**: Open pgAdmin and create a new server with the following details:

    - **Name**: Any name you prefer
    - **Host**: Your RDS instance endpoint
    - **Port**: Your RDS instance port
    - **Username**: db_domain_users
    - **Password**: Paste the token generated in step 4
    - **SSL mode**: verify-full
    - **Root certificate**: The path to the root certificate you downloaded in step 5

### Notes/FAQ
- Remember, the IAM authentication token has a lifetime of 15 minutes, so if your connection lasts longer, you will need to generate and use a new token.
- Ensure that your IAM user/group has the necessary permissions/policies attached to connect to the RDS database.

# Important Notes
- When desiring to update the database on local or remote AWS it's important that once a change has been completed if an update or new change is desired you will need to create a new changelog record and file to perform the change, you cannot go back and edit an already applied file.
- For deploying a new Liquibase changelog within our repository, it's as simple as executing the [Liquibase Update](https://github.com/RyanDerr/GophBank/actions/workflows/liquibase.yml) pipeline. Choose the environment you wish to apply the database changes to, and the pipeline will handle the rest.