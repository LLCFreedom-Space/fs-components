// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fs-components",
    platforms: [
        // The package supports macOS 13.0 and later.
        .macOS(.v13)
    ],
    products: [
        // Defines the products (libraries) the package produces.
        // Each product is a library that can be used by other packages.
        .library(name: "PostgresComponents", targets: ["PostgresComponents"]),
        .library(name: "RedisComponents", targets: ["RedisComponents"]),
        .library(name: "ConsulComponents", targets: ["ConsulComponents"]),
        .library(name: "ValidationComponents", targets: ["ValidationComponents"]),
        .library(name: "ApplicationStatusComponents", targets: ["ApplicationStatusComponents"]),
        .library(name: "LoggingComponents", targets: ["LoggingComponents"]),
        .library(name: "MongoComponents", targets: ["MongoComponents"]),
    ],
    dependencies: [
        // Package dependencies are other Swift packages that this package relies on.
        // These packages are fetched from the provided URLs and version ranges.
        // Vapor framework, a web framework for Swift, required to build server-side applications.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        // Fluent ORM, needed for SQL and NoSQL database management and migrations.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.1.0"),
        // Fluent PostgreSQL driver, specifically used for PostgreSQL database operations.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.1.1"),
        // Redis package, used for interacting with Redis databases.
        .package(url: "https://github.com/vapor/redis.git", from: "5.0.0-alpha.2.1"),
        // JWT provider for Vapor, needed for generating and verifying JSON Web Tokens.
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
        // MongoKitten package, used for interacting with MongoDB.
        .package(url: "https://github.com/orlandos-nl/MongoKitten.git", from: "7.6.4"),
    ],
    targets: [
        .target(name: "PostgresComponents",
                dependencies: [
                    .product(name: "Vapor", package: "vapor"),
                    .product(name: "Fluent", package: "fluent"),
                    .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
                ],
                path: "./Services/PostgresComponents"
               ),
        .target(name: "RedisComponents",
                dependencies: [
                    .product(name: "Vapor", package: "vapor"),
                    .product(name: "Redis", package: "redis")
                ],
                path: "./Services/RedisComponents"
               ),
        .target(name: "ConsulComponents",
                dependencies: [
                    .product(name: "Vapor", package: "vapor"),
                    .product(name: "JWT", package: "jwt")
                ],
                path: "./Services/ConsulComponents"
               ),
        .target(name: "ValidationComponents",
                dependencies: [
                    .product(name: "Vapor", package: "vapor"),
                ],
                path: "./Services/ValidationComponents"
               ),
        .target(name: "ApplicationStatusComponents",
                dependencies: [
                    .product(name: "Vapor", package: "vapor"),
                ],
                path: "./Services/ApplicationStatusComponents"
               ),
        .target(name: "LoggingComponents",
                dependencies: [
                    .product(name: "Vapor", package: "vapor"),
                ],
                path: "./Services/LoggingComponents"
               ),
        .target(name: "MongoComponents",
                dependencies: [
                    .product(name: "Vapor", package: "vapor"),
                    .product(name: "MongoKitten", package: "MongoKitten")
                ],
                path: "./Services/MongoComponents"
               ),
        // A test target for testing all components.
        .testTarget(
            name: "fs-componentsTests",
            dependencies: [
                "PostgresComponents",
                "RedisComponents",
                "ConsulComponents",
                "ValidationComponents",
                "ApplicationStatusComponents",
                "LoggingComponents",
                "MongoComponents"
            ]
        )
    ]
)
