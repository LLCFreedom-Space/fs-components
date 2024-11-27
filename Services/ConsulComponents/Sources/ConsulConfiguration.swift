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
//  ConsulConfiguration.swift
//  
//
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

/// A generic `ConsulConfiguration` data that can be save in storage.
/// A configuration object for connecting to a Consul server.
///
/// `ConsulConfiguration` contains the necessary information to establish a connection
/// to a Consul server, including its URL and optional authentication credentials.
///
/// Example:
/// ```swift
/// let config = ConsulConfiguration(
///     url: "http://127.0.0.1:8500",
///     username: "admin",
///     password: "password123"
/// )
/// ```
public struct ConsulConfiguration {
    /// The URL of the Consul server.
    ///
    /// This property specifies the base URL of the Consul server to which the application will connect.
    /// The URL should include the protocol (`http` or `https`).
    ///
    /// Example:
    /// - `http://127.0.0.1:8500` (local Consul instance)
    /// - `https://xmpl-consul.example.com` (remote Consul instance with secure connection)
    public let url: String

    /// The username for Consul server authentication.
    ///
    /// This property provides an optional username for authenticating with the Consul server.
    /// Leave this as `nil` if authentication is not required or if only a token-based authentication is used.
    ///
    /// Example:
    /// - `"admin"`
    /// - `nil` (when authentication is not required)
    public let username: String?

    /// The password for Consul server authentication.
    ///
    /// This property provides an optional password for authenticating with the Consul server.
    /// If `username` is provided, you should typically provide a corresponding password.
    ///
    /// Example:
    /// - `"password123"`
    /// - `nil` (when authentication is not required)
    public let password: String?
}
