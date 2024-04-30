-- Create a dummy role for IAM authentication used by liquibase to connect to the RDS instance, not used locally but requires a roles existence.
CREATE ROLE rds_iam;