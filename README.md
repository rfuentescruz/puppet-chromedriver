
# chromedriver

[![Build Status](https://travis-ci.org/rfuentescruz/puppet-chromedriver.svg?branch=master)](https://travis-ci.org/rfuentescruz/puppet-chromedriver)
[![Codecov](https://img.shields.io/codecov/c/github/rfuentescruz/puppet-chromedriver.svg)](chromedriver)

Puppet module for installing [Chromedriver](http://chromedriver.chromium.org/).
#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with chromedriver](#setup)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

Allows developers to manage their installation of `chromedriver` and make sure that they are can use the most recent version.

`chromedriver` only supports the most recent version of Google Chrome. This puts a lot of incentive on making sure that `chromedriver` installations use the most recent available version.

## Setup

### Setup Requirements

## Usage

### Basic Usage

```puppet
include chromedriver
```

### Custom chromedriver version
```
class { 'chromedriver':
  version => '2.36'
}
```

## Limitations

Linux and Mac versions of the `chromedriver` binary do not support 32-bit

## Development

Development, testing of this module was done with the help of [PDK](https://puppet.com/docs/pdk/1.x/pdk.html). If you want to contribute, feel free to fork and submit a PR but please make sure that `pdk test` and `pdk validate` succeeds.
