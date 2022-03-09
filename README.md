# Reuben

A Ruby framework for creating the **Reuben** bot using `discordrb`.

**Reuben** is currently live, and mainly developed for use by the [Game Dev Cafe](https://luka-sj.com/discord).

**Reuben** currently runs on Ruby 3.0.0.

## Dependencies

**Reuben** has major dependencies on the following gems to work properly:
- `activesupport`
- `discordrb`
- `erb`
- `mysql2`

`mysql` and `activesupport` gem dependencies are here due to internal requirements for the bot to function at the [Game Dev Cafe](https://luka-sj.com/discord).

Additional gem configuration can be found in `config/gems.rb`

---
**Reuben** comes with a Rails-like system for interfacing with a local or remote database system. This interface, however, is limited to **MySQL** databases only out of the box.

The `Database` interface creates new namespaces and models for all tables in your database and their relationships (more documentation hopefully to follow soon).

## Usage
1. Fork this repo
2. Create a `.env` file in the root and add the following:

```
   MYSQL_HOST=
   MYSQL_USERNAME=
   MYSQL_PASSWORD=
   BOT_TOKEN=
   RELEASE=
```
3. Start the application using `bin/reuben`

\
Running the bot is best handled on a server. Deployment using **Docker** or **systemctl** will follow as the bot is further developed.

Required gems will automatically install when application launches, unless `SKIP_GEM_INSTALL=true` is added to the `.env`.\
If you opt for skipping gem installation during application boot, you can always run the `bin/install_gems` from shell to install all the required gems.
