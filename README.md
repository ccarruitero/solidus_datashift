SolidusDatashift
================
[![Gem Version][rubygems-image]][rubygems-url]
[![Build Status][travis-image]][travis-url]

Allow import data to your solidus store

Installation
------------

Add solidus_datashift to your Gemfile:

```ruby
gem 'solidus_datashift'
```

Bundle your dependencies

```shell
bundle
```

Usage
-----

This gem include some rake tasks, namespaced into `solidus_datashift`, that let
you import data to your project.

For example for import products you should use the following command

```
rake solidus_datashift:product_import[your_file_name]
```

You can check all available importer tasks by running

```
rake -T
```

Copyright (c) 2018 [César Carruitero](https://github.com/ccarruitero), released under MIT License

[rubygems-image]: https://badge.fury.io/rb/solidus_datashift.svg
[rubygems-url]: https://badge.fury.io/rb/solidus_datashift
[travis-image]: https://travis-ci.org/ccarruitero/solidus_datashift.svg?branch=master
[travis-url]: https://travis-ci.org/ccarruitero/solidus_datashift
