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
//  LogLevel.swift
//
//
//  Created by Mykola Buhaiov on 18.02.2024.
//

import Vapor

public struct LogLevel {
    /// Instance of app as `Application`
    public let app: Application

    public init(app: Application) {
        self.app = app
    }

    public func setupLoggingLevel() {
        if let logLevel = Environment.process.LOG_LEVEL {
            app.logger.logLevel = Logger.Level(rawValue: logLevel) ?? .info
            app.logger.info("SUCCESS: Server start with logLevel: \(logLevel)")
        } else {
            app.logger.logLevel = .info
            app.logger.info("SUCCESS: Server start with logLevel: .info")
        }
    }
}
