// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fs-components",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "PostgresComponents", targets: ["PostgresComponents"]),
        .library(name: "RedisComponents", targets: ["RedisComponents"]),
        .library(name: "ConsulComponents", targets: ["ConsulComponents"]),
        .library(name: "ValidationComponents", targets: ["ValidationComponents"]),
        .library(name: "ApplicationStatusComponents", targets: ["ApplicationStatusComponents"]),
        .library(name: "LoggingComponents", targets: ["LoggingComponents"]),
        .library(name: "MongoComponents", targets: ["MongoComponents"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        // 🖋 Swift ORM (queries, models, and relations) for NoSQL and SQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.1.0"),
        // 🐘 Swift ORM (queries, models, relations, etc) built on PostgreSQL.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.1.1"),
        // Vapor provider for RedisKit + RedisNIO
        .package(url: "https://github.com/vapor/redis.git", from: "5.0.0-alpha.2.1"),
        // 🔏 Vapor JWT provider
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
        // 🐈 MongoDB driver based on Swift NIO.
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
