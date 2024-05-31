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
//  RedisComponents.swift
//
//
//  Created by Mykola Buhaiov on 07.02.2024.
//

import Vapor
import Redis

public struct RedisComponents: RedisComponentsProtocol {
    /// Instance of app as `Application`
    public let app: Application

    public init(app: Application) {
        self.app = app
    }

    public func getPong() async -> String {
        try? app.boot()
        do {
            return try await app.redis.ping().get()
        } catch {
            return "Check redis connect fail with error: \(error)"
        }
    }

    /// Get status for `Redis` database
    /// - Returns: `String` - Connection status. Example - `Ok`
    public func getRedisStatus() async -> (String, HTTPResponseStatus) {
        try? app.boot()
        let statusCode = HTTPResponseStatus.serviceUnavailable
        do {
            let responseRedis = try await app.redis.ping().get()
            if responseRedis.description == "PONG" {
                return ("Ok", .ok)
            } else {
                return ("No connect to Redis database. Response: \(responseRedis.description)", statusCode)
            }
        } catch {
            app.logger.error("No connect to Redis database. Reason: \(error)")
            return ("No connect to Redis database. Reason: \(error)", statusCode)
        }
    }

    /// Schedule repeated task
    /// - Parameter delay: `Int64`
    public func scheduleRepeatedTask(by second: Int64) {
        try? self.app.boot()
        DispatchQueue.global().async {
            self.app.client.eventLoop.scheduleRepeatedTask(initialDelay: .seconds(0), delay: .seconds(second)) { _ in
                self.app.logger.debug("Send ping to Redis. Re-send after \(second) seconds.")
                app.redis.ping()
                    .flatMapThrowing { response in
                        if response.description != "PONG" {
                            self.app.logger.error("Send ping to Redis fail with error: \(response)")
                        }
                    }
            }
        }
    }
}
