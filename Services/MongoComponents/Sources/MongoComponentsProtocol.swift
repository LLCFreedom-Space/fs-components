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
//  MongoComponentsProtocol.swift
//
//
//  Created by Mykola Buhaiov on 04.03.2024.
//

import Vapor
import MongoClient

/// A protocol defining components for managing and verifying MongoDB connections.
public protocol MongoComponentsProtocol {
    /// Checks the connection state of a MongoDB instance using the specified URL.
    ///
    /// This asynchronous function attempts to connect to the MongoDB instance at the given URL
    /// and determines the connection state. It can be used to verify the availability and status
    /// of a MongoDB database.
    ///
    /// - Parameter url: A `String` representing the connection URL of the MongoDB instance.
    ///
    /// - Returns: A `MongoConnectionState` value representing the status of the connection,
    ///   such as `.connected`, `.disconnected`, or other custom states.
    ///
    /// - Note: Ensure that the URL provided is valid and accessible to avoid connection errors.
    func checkConnection(by url: String) async -> MongoConnectionState
}
