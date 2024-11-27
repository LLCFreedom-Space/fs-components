// FS Components
// Copyright (C) 2024  FREEDOM SPACE, LLC

//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as published
//  by the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

//
//  Application+Extensions.swift
//
//
//  Created by Mykola Buhaiov on 04.03.2024.
//

import Vapor
import MongoKitten

extension Application {
    /// A storage key used to associate `MongoComponentsProtocol` with the application storage.
    ///
    /// The `MongoComponentsKey` struct conforms to the `StorageKey` protocol, enabling type-safe storage
    /// and retrieval of `MongoComponentsProtocol` instances in the application.
    public struct MongoComponentsKey: StorageKey {
        /// The associated value type stored under this key.
        ///
        /// This typealias simplifies usage by referring to `MongoComponentsProtocol`.
        public typealias Value = MongoComponentsProtocol
    }

    /// Accessor for managing `MongoComponentsProtocol` within the application's storage.
    ///
    /// This computed property provides a convenient way to set or retrieve a `MongoComponentsProtocol`
    /// instance from the application's storage. The value is stored and accessed using the `MongoComponentsKey`.
    ///
    /// Example:
    /// ```swift
    /// app.mongoComponents = MyMongoComponents()
    /// if let components = app.mongoComponents {
    ///     components.configure()
    /// }
    /// ```
    public var mongoComponents: MongoComponentsProtocol? {
        get { storage[MongoComponentsKey.self] }
        set { storage[MongoComponentsKey.self] = newValue }
    }
}

extension Application {
    /// A storage key used to associate `MongoCluster` with the application storage.
    ///
    /// The `MongoClusterKey` struct conforms to the `StorageKey` protocol, enabling type-safe storage
    /// and retrieval of `MongoCluster` instances in the application.
    public struct MongoClusterKey: StorageKey {
        /// The associated value type stored under this key.
        ///
        /// This typealias simplifies usage by referring to `MongoCluster`.
        public typealias Value = MongoCluster
    }

    /// Accessor for managing `MongoCluster` within the application's storage.
    ///
    /// This computed property provides a convenient way to set or retrieve a `MongoCluster` instance
    /// from the application's storage. The value is stored and accessed using the `MongoClusterKey`.
    ///
    /// Example:
    /// ```swift
    /// try app.initializeMongoCluster(connectionString: "mongodb://localhost/myapp")
    /// if let cluster = app.mongoCluster {
    ///     cluster.connect()
    /// }
    /// ```
    public var mongoCluster: MongoCluster? {
        get { storage[MongoClusterKey.self] }
        set { storage[MongoClusterKey.self] = newValue }
    }

    /// Initializes a `MongoCluster` and stores it in application storage.
    ///
    /// - Parameter connectionString: The MongoDB URI as a `String`. Example: `"mongodb://localhost/myapp"`.
    /// - Throws: An error if the cluster initialization fails.
    ///
    /// Example:
    /// ```swift
    /// try app.initializeMongoCluster(connectionString: "mongodb://localhost/myapp")
    /// ```
    public func initializeMongoCluster(connectionString: String) throws {
        self.mongoCluster = try MongoCluster(lazyConnectingTo: ConnectionSettings(connectionString))
    }
}

extension Application {
    /// A storage key used to associate `MongoDatabase` with the application storage.
    ///
    /// The `MongoDBKey` struct conforms to the `StorageKey` protocol, enabling type-safe storage
    /// and retrieval of `MongoDatabase` instances in the application.
    public struct MongoDBKey: StorageKey {
        /// The associated value type stored under this key.
        ///
        /// This typealias simplifies usage by referring to `MongoDatabase`.
        public typealias Value = MongoDatabase
    }

    /// Accessor for managing `MongoDatabase` within the application's storage.
    ///
    /// This computed property provides a convenient way to set or retrieve a `MongoDatabase` instance
    /// from the application's storage. The value is stored and accessed using the `MongoDBKey`.
    ///
    /// Example:
    /// ```swift
    /// try app.initializeMongoDB(connectionString: "mongodb://localhost/myapp")
    /// if let database = app.mongoDB {
    ///     database.query("myCollection")
    /// }
    /// ```
    public var mongoDB: MongoDatabase? {
        get { storage[MongoDBKey.self] }
        set { storage[MongoDBKey.self] = newValue }
    }

    /// Initializes a `MongoDatabase` and stores it in application storage.
    ///
    /// - Parameter connectionString: The MongoDB URI as a `String`. Example: `"mongodb://localhost/myapp"`.
    /// - Throws: An error if the database initialization fails.
    ///
    /// Example:
    /// ```swift
    /// try app.initializeMongoDB(connectionString: "mongodb://localhost/myapp")
    /// ```
    public func initializeMongoDB(connectionString: String) throws {
        self.mongoDB = try MongoDatabase.lazyConnect(to: connectionString)
    }
}
