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
//  MongoComponents.swift
//
//
//  Created by Mykola Buhaiov on 04.03.2024.
//

import Vapor
import MongoClient

/// A concrete implementation of `MongoComponentsProtocol` for managing MongoDB connections.
///
/// This struct provides functionality for checking the connection state of a MongoDB instance,
/// using the application's MongoDB cluster configuration.
public struct MongoComponents: MongoComponentsProtocol {
    /// The instance of the application used for MongoDB connection checks.
    public let app: Application

    /// Initializes a new instance of `MongoComponents` with the specified application.
    ///
    /// - Parameter app: The `Application` instance used to access MongoDB configuration and logging.
    public init(app: Application) {
        self.app = app
    }

    /// Checks the connection state of a MongoDB instance using the specified URL.
    ///
    /// This asynchronous function retrieves the connection state from the application's MongoDB cluster
    /// configuration. It logs the connection state for debugging purposes. If the connection state is
    /// unavailable, it logs an error and returns `.disconnected`.
    ///
    /// - Parameter url: A `String` representing the connection URL of the MongoDB instance.
    ///   **Note:** This parameter is currently unused in the implementation but can be expanded in the future.
    ///
    /// - Returns: A `MongoConnectionState` value representing the status of the connection, such as `.connected`
    ///   or `.disconnected`.
    ///
    /// - Logging:
    ///   - Logs the result of the connection state check using the application's logger.
    ///   - Logs an error if the connection state is `nil`.
    public func checkConnection(by url: String) async -> MongoConnectionState {
        let result = app.mongoCluster?.connectionState
        app.logger.debug("Connect to mongo have result: \(String(describing: result))")
        guard let result else {
            app.logger.error("Connection to mongo not found. Result: \(String(describing: result))")
            return .disconnected
        }
        return result
    }
}
