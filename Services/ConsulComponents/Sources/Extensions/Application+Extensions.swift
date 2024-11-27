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
//  Created by Mykola Buhaiov on 08.02.2024.
//

import Vapor

extension Application {
    /// A key for storing and retrieving the `ConsulComponentsProtocol` in the application's storage.
    ///
    /// This struct conforms to the `StorageKey` protocol, providing a type-safe way to access `ConsulComponentsProtocol`
    /// instances from the application's storage.
    ///
    /// - Note: `ConsulComponentsKey` is used to store the `ConsulComponentsProtocol` object in the application storage,
    ///         which provides methods for interacting with Consul-related components like getting values and JWKS.
    public struct ConsulComponentsKey: StorageKey {
        /// A less verbose typealias for `ConsulComponentsProtocol`.
        public typealias Value = ConsulComponentsProtocol
    }

    /// Property for accessing the `ConsulComponentsProtocol` in the application storage.
    ///
    /// - This property provides an easy-to-use getter and setter for accessing the `ConsulComponentsProtocol`
    ///   instance stored in the application’s storage. It enables components of the application to interact with
    ///   Consul services.
    ///
    /// - Returns: An optional `ConsulComponentsProtocol` instance if it has been set; otherwise, `nil`.
    ///
    /// - Example Usage:
    /// ```swift
    /// app.consulComponents = myConsulComponentsInstance
    /// ```
    public var consulComponents: ConsulComponentsProtocol? {
        get { storage[ConsulComponentsKey.self] }
        set { storage[ConsulComponentsKey.self] = newValue }
    }
}

extension Application {

    /// A key for storing and retrieving the `ConsulConfiguration` in the application's storage.
    ///
    /// This struct conforms to the `StorageKey` protocol and provides a type-safe way to store and retrieve the
    /// `ConsulConfiguration` object in the application's storage, which contains the configuration for accessing
    /// Consul services.
    ///
    /// - Note: `ConsulConfigurationKey` is used for storing `ConsulConfiguration` in application storage, which
    ///         includes connection details like URL, username, and password.
    private struct ConsulConfigurationKey: StorageKey {
        /// A less verbose typealias for `ConsulConfiguration`.
        typealias Value = ConsulConfiguration
    }

    /// Property for accessing the `ConsulConfiguration` in the application storage.
    ///
    /// - This property provides an easy-to-use getter and setter for accessing the `ConsulConfiguration` instance
    ///   stored in the application’s storage. This configuration includes parameters like the URL and authentication
    ///   details for connecting to the Consul service.
    ///
    /// - Returns: An optional `ConsulConfiguration` instance if it has been set; otherwise, `nil`.
    ///
    /// - Example Usage:
    /// ```swift
    /// app.consulConfiguration = myConsulConfigurationInstance
    /// ```
    public var consulConfiguration: ConsulConfiguration? {
        get { storage[ConsulConfigurationKey.self] }
        set { storage[ConsulConfigurationKey.self] = newValue }
    }
}
