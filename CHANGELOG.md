# 2.0.0

This major release upgrades the bazel dependencies and workspace. This change is breaking for anyone
using bazel to build this library. In order to use this library with bazel, you will also need to
upgrade your workspace versions to match the ones now used in this library's `WORKSPACE` file.

* [Update bazel workspace to latest versions. (#22)](https://github.com/material-foundation/material-text-accessibility-ios/commit/f21e585f9e5991e0eb00de8c7c01fe995057c902) (featherless)

# 1.2.1

This patch release adds various build system-related files.

## Non-source changes

* [Add missing Info.plist (#21)](https://github.com/material-foundation/material-text-accessibility-ios/commit/fc2a7cbbca2ac40fa6f09f34bf71033adc9d5308) (Louis Romero)
* [Remove obsolete comment (#20)](https://github.com/material-foundation/material-text-accessibility-ios/commit/bac12cbbdacd11c0bb315359ec5373d08fc76fb8) (Brenton Simpson)
* [Add support for kokoro and bazel continuous integration. (#19)](https://github.com/material-foundation/material-text-accessibility-ios/commit/fd570d71ae0124c75ad5af00e6b8b4b1668d5e40) (featherless)

## 1.2.0

### Enhancements

* Add tvOS as a target plaform.

## 1.1.4

### Enhancements

* Removed usage of header_mappings_dir.
* Ran swift 3 update for example.

## 1.1.3

### Enhancements

* Fixed unused variable warning when NS_BLOCK_ASSERTIONS is defined ([Adrian Secord](https://github.com/ajsecord)).

## 1.1.2

### Enhancements

* Added better warning coverage and fixed a documentation problem ([Adrian Secord](https://github.com/ajsecord)).

## 1.1.1

### Enhancements

* Added support for continuous code coverage analysis ([Sean O'Shea](https://github.com/seanoshea)).
* Added unit tests for textColorOnBackgroundImage ([Sean O'Shea](https://github.com/seanoshea)).
* Documentation clean ups ([Sean O'Shea](https://github.com/seanoshea)).

## 1.1.0

### Enhancements

* Added a `isLargeForContrastRatios:` advanced method to test a UIFont instance against the W3C's
  definition of "large" text.

## 1.0.2

### Bug Fixes

* Updated authors in the podspec to properly refer to Google.

## 1.0.1

### Bug Fixes

* Fixed podspec issues.

## 1.0.0

Initial release.

## x.x.x

This is a template. When cutting a new release, rename "stable" to the release number and create a
new, empty "Master" section.

### Breaking

### Enhancements

### Bug Fixes

* This is a template description
[person responsible](https://github.com/...)
[#xxx](github.com/google/material-text-accessibility-ios/issues/xxx)
