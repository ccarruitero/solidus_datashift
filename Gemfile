# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem 'solidus', github: 'solidusio/solidus', branch: branch

gemspec

gem 'datashift', github: 'ccarruitero/datashift', branch: 'fix_delegator_2.4'
gem 'solidus_multi_domain', github: 'solidusio/solidus_multi_domain'
