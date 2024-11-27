[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
![GitHub release (with filter)](https://img.shields.io/github/v/release/LLCFreedom-Space/fs-allowed-hosts-middleware)
 [![Read the Docs](https://readthedocs.org/projects/docs/badge/?version=latest)](https://llcfreedom-space.github.io/fs-allowed-hosts-middleware/)
![example workflow](https://github.com/LLCFreedom-Space/fs-allowed-hosts-middleware/actions/workflows/docc.yml/badge.svg?branch=main)
![example workflow](https://github.com/LLCFreedom-Space/fs-allowed-hosts-middleware/actions/workflows/lint.yml/badge.svg?branch=main)
![example workflow](https://github.com/LLCFreedom-Space/fs-allowed-hosts-middleware/actions/workflows/test.yml/badge.svg?branch=main)
 [![codecov](https://codecov.io/github/LLCFreedom-Space/fs-allowed-hosts-middleware/graph/badge.svg?token=2EUIA4OGS9)](https://codecov.io/github/LLCFreedom-Space/fs-allowed-hosts-middleware)
 
# FS Components

Quick implementation of components.

## Swift version

The latest version of FSComponents requires **Swift 5.9** and **MacOS v13** or later. You can download this version of the Swift binaries by following this [link](https://swift.org/download/).

## Usage

### Swift Package Manager

#### Add dependencies using the version
Add the `FSComponents` package to the dependencies within your application’s `Package.swift` file. Substitute `"x.x.x"` with the latest `FSComponents` [release](https://github.com/LLCFreedom-Space/fs-components/releases).
```swift
.package(url: "https://github.com/LLCFreedom-Space/fs-components.git", from: "x.x.x")
```
Add `ValidationComponents` to your target's dependencies:
```swift
dependencies: [
    .product(name: "ValidationComponents", package: "fs-components"),
],
```
#### Import package
```swift
import ValidationComponents
```

#### Add dependencies using the branch
Add the `FSComponents` package to the dependencies within your application’s `Package.swift` file. Substitute `"name branch"` with the latest `FSComponents` [release](https://github.com/LLCFreedom-Space/fs-components/releases).
```swift
.package(url: "https://github.com/LLCFreedom-Space/fs-components.git", branch: "name branch")
```
Add `ValidationComponents` to your target's dependencies:
```swift
dependencies: [
    .product(name: "ValidationComponents", package: "fs-components"),
],
```
#### Import package
```swift
import ValidationComponents
```

## Getting Started
An example of a method call from this library 
First you need to setup allowed hosts in field - `allowedHosts`
```
app.allowedHosts = ["first-host", "second-host"]
```
After you setup you need to call middleware in configuration
```
app.middleware.use(AllowedHostsMiddleware)

```
To access the methods that are in this library, you need to call the application, since this library is an extension to the application

## Links

LLC Freedom Space – [@LLCFreedomSpace](https://twitter.com/llcfreedomspace) – [support@freedomspace.company](mailto:support@freedomspace.company)

Distributed under the GNU AFFERO GENERAL PUBLIC LICENSE Version 3. See [LICENSE.md][license-url] for more information.

 [GitHub](https://github.com/LLCFreedom-Space)

[swift-image]:https://img.shields.io/badge/swift-5.9-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-GPLv3-blue.svg
[license-url]: LICENSE
