# Using Phoenix with Nix and Direnv
This project is an example of a fresh [Phoenix](https://www.phoenixframework.org/) project
configured to work with direnv and nix to provide an app-specific development environment
including a dedicated postgres server.

## Usage
If you have nix and direnv installed, you simply need to change directories to this project
and allow direnv to operate by running `direnv allow`. This will cause nix to fetch the
dependencies including Postgres 15, and create an isolated Postgres data directory in
`.direnv/postgres` by using direnv's layouts feature (thanks to [this post](https://ylan.segal-family.com/blog/2021/07/23/per-project-postgres-with-asdf-and-direnv/) for help).

Once all the deps have been pulled down and the data directory has been created, you must
use `pg_ctl start` to start the Postgres server. Then you can run `mix ecto.create` to create
the database. This Postgres server will be isolated from your other projects, so no worries
about leaving it running if you have the resources. You can always use `pg_ctl stop` when
you're finished working as well.