#!/usr/bin/env rake

require "rubygems"
require "sequel"

namespace :db do
  task :create do
    createdb
  end

  task :drop do
    dropdb
  end

  task :migrate, [:version] do |_, args|
    migrate(args[:version])
  end

  task :reset do
    dropdb
    createdb
    migrate
  end

  def dropdb
    system "dropdb politracker_development --if-exists"
  end

  def createdb
    system "createdb politracker_development"
  end

  def migrate(version = nil)
    Sequel.extension :migration
    db = Sequel.connect("postgres://localhost/politracker_development") #ENV.fetch("DATABASE_URL")
    if version
      puts "Migrating to version #{version}"
      Sequel::Migrator.run(db, "db/migrations", target: version.to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrations")
    end
  end
end
