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

/// A utility structure for configuring the logging level of the application.
///
/// This structure provides functionality to set up the logging level of the application
/// based on the environment variable `LOG_LEVEL`.
public struct LogLevel {
    /// The instance of the application used to configure the logging level.
    public let app: Application

    /// Configures the application's logging level based on the environment variable `LOG_LEVEL`.
    ///
    /// This method checks if a `LOG_LEVEL` is defined in the environment. If present, it attempts
    /// to set the logging level to the corresponding value. If the value is invalid or not defined,
    /// it defaults to `.info`. It also logs a success message indicating the logging level used.
    ///
    /// - Behavior:
    ///   - If `LOG_LEVEL` is set to a valid logging level (e.g., `debug`, `info`, `error`), the
    ///     logging level is updated, and a success message with the level is logged.
    ///   - If `LOG_LEVEL` is not set or invalid, the logging level defaults to `.info`, and
    ///     a corresponding success message is logged.
    ///
    /// - Example:
    ///   ```swift
    ///   let logLevel = LogLevel(app: app)
    ///   logLevel.setupLoggingLevel()
    ///   ```
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
