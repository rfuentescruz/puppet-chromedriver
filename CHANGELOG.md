# Changelog

All notable changes to this project will be documented in this file.

## Release 0.4.0

 - Stop fetching all available / valid remote versions and consider only the
   latest version available
 - Remove dependency on `nokogiri`

**Bugfixes**

 - Prevent errors regarding duplicate resource declaration for any `package`
   resource already declared by other modules (e.g. `unzip`)
 - Fix `unzip` errors when extracting a new binary archive over a previous
   version

## Release 0.3.0

**Bugfixes**

 - Puppet will get stuck waiting for facts when checking versions of old
   `chromedriver`

## Release 0.2.0

**Bugfixes**

 - Fix remote version sorting causing v2.9 to always be installed
 - Make sure that new version archives are downloaded and extracted if available
 - Make sure that chromedriver binary is executable

## Release 0.1.0

Initial release
