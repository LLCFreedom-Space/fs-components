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
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

extension Application {
    /// A key for storing and retrieving RedisComponents in the application's storage.
    ///
    /// This struct conforms to the `StorageKey` protocol and is used internally
    /// to access the RedisComponents instance in the application's storage.
    ///
    /// It provides a type-safe way to store and retrieve the Redis components that
    /// conform to the `RedisComponentsProtocol`, enabling Redis-related functionality
    /// to be available throughout the application.
    public struct RedisComponentsKey: StorageKey {
        /// A less verbose typealias for the `RedisComponentsProtocol` type.
        ///
        /// This alias allows the RedisComponents instance to be stored in the application's
        /// storage as a `RedisComponentsProtocol` type, without needing to explicitly define the
        /// concrete implementation type.
        public typealias Value = RedisComponentsProtocol
    }

    /// A computed property for accessing Redis components stored in the application's storage.
    ///
    /// This property provides a way to get or set the Redis components that conform to
    /// the `RedisComponentsProtocol` in the application's `Storage`. If Redis components
    /// have been previously stored, they can be retrieved using this property. You can
    /// also set a new instance of `RedisComponentsProtocol` to the application storage.
    ///
    /// Example Usage:
    ///
    /// ```swift
    /// app.redisComponents = RedisComponents(app: app)
    /// ```
    ///
    /// - Returns: An optional `RedisComponentsProtocol` instance, which could be a concrete
    ///            type such as `RedisComponents` or any other implementation conforming to the protocol.
    public var redisComponents: RedisComponentsProtocol? {
        get { storage[RedisComponentsKey.self] }
        set { storage[RedisComponentsKey.self] = newValue }
    }
}
