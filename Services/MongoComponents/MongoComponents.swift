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

public struct MongoComponents: MongoComponentsProtocol {
    /// Instance of app as `Application`
    public let app: Application

    public func getConnection(by url: String) async -> MongoConnectionState {
        do {
            let mongoCluster = try await MongoCluster(connectingTo: ConnectionSettings(url))
            let result = mongoCluster.connectionState
            app.logger.debug("Connect to mongo have result: \(result)")
            return result
        } catch {
            app.logger.error("ERROR: Connection to mongo db fail with error: \(error)")
            return .disconnected
        }
    }
}
