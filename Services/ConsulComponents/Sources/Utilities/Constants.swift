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
//  Constants.swift
//
//
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

/// A collection of constant values used throughout the application.
///
/// `Constants` provides default configuration values, such as the URL and status path for interacting
/// with a Consul server. These values are useful for ensuring consistency and reducing duplication
/// across the codebase.
public enum Constants {
    /// The default URL for connecting to a local Consul server.
    ///
    /// This constant specifies the default base URL used to interact with a Consul server.
    /// It can be overridden in configurations where a different Consul instance is required.
    ///
    /// Example:
    /// - `http://127.0.0.1:8500` (local Consul instance)
    ///
    /// Usage:
    /// ```swift
    /// let consulUrl = Constants.consulUrl
    /// ```
    static let consulUrl = "http://127.0.0.1:8500"

    /// The default path for retrieving the Consul server's leader status.
    ///
    /// This constant defines the relative path used to fetch the leader status of the Consul cluster.
    /// The full URL is typically constructed by combining `consulUrl` with this path.
    ///
    /// Example:
    /// - `/v1/status/leader`
    ///
    /// Usage:
    /// ```swift
    /// let statusPath = Constants.consulStatusPath
    /// let fullUrl = "\(Constants.consulUrl)\(statusPath)"
    /// ```
    static let consulStatusPath = "/v1/status/leader"
}
