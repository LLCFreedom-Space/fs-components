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
    /// A `MongoComponentsKey` conform to StorageKey protocol
    public struct MongoComponentsKey: StorageKey {
        /// Less verbose typealias for `MongoComponentsProtocol`.
        public typealias Value = MongoComponentsProtocol
    }

    /// Setup `mongoComponents` in application storage
    public var mongoComponents: MongoComponentsProtocol? {
        get { storage[MongoComponentsKey.self] }
        set { storage[MongoComponentsKey.self] = newValue }
    }
}

extension Application {
    /// A `MongoClusterKey` conform to StorageKey protocol
    public struct MongoClusterKey: StorageKey {
        /// Less verbose typealias for `MongoCluster`.
        public typealias Value = MongoCluster
    }

    /// Setup `mongoCluster` in application storage
    public var mongoCluster: MongoCluster? {
        get { storage[MongoClusterKey.self] }
        set { storage[MongoClusterKey.self] = newValue }
    }

    /*
     /// For example setup mongo cluster need use method like this:
     app.mongoCluster = try await MongoCluster(connectingTo: ConnectionSettings(connectionString))
     */
}
