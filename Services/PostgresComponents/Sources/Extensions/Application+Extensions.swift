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
    /// A storage key used to associate `PostgresComponentsProtocol` with the application storage.
    ///
    /// The `PostgresComponentsKey` struct conforms to the `StorageKey` protocol, enabling type-safe storage
    /// and retrieval of `PostgresComponentsProtocol` instances in the application.
    public struct PostgresComponentsKey: StorageKey {
        /// The associated value type stored under this key.
        ///
        /// This typealias simplifies usage by referring to `PostgresComponentsProtocol`.
        public typealias Value = PostgresComponentsProtocol
    }

    /// Accessor for managing `PostgresComponentsProtocol` within the application's storage.
    ///
    /// This computed property provides a convenient way to set or retrieve a `PostgresComponentsProtocol`
    /// instance from the application's storage. The value is stored and accessed using the `PostgresComponentsKey`.
    ///
    /// - Note: Use this property to configure and access Postgres components at the application level.
    ///
    /// Example:
    /// ```swift
    /// app.postgresComponents = MyPostgresComponents()
    /// if let components = app.postgresComponents {
    ///     components.connect()
    /// }
    /// ```
    public var postgresComponents: PostgresComponentsProtocol? {
        get { storage[PostgresComponentsKey.self] }
        set { storage[PostgresComponentsKey.self] = newValue }
    }
}
