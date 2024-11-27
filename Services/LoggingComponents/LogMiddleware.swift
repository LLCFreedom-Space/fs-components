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
//  LogMiddleware.swift
//
//
//  Created by Mykola Buhaiov on 18.02.2024.
//

import NIOCore
import Logging
import Vapor

/// A middleware that logs incoming requests, excluding specific paths.
///
/// `LogMiddleware` is an asynchronous middleware that intercepts HTTP requests,
/// logs relevant information about them, and then passes them down the middleware chain.
/// Certain paths (e.g., `/v1/status` and `/v1/health`) are excluded from logging to avoid cluttering the logs.
///
/// Example Usage:
/// ```swift
/// app.middleware.use(LogMiddleware())
/// ```
public struct LogMiddleware: AsyncMiddleware {
    /// Creates an instance of `LogMiddleware`.
    ///
    /// Example:
    /// ```swift
    /// let middleware = LogMiddleware()
    /// ```
    public init() {}

    /// Intercepts an HTTP request, logs it (if applicable), and passes it to the next responder in the chain.
    ///
    /// This method determines the request's path and conditionally logs its details.
    /// Paths `/v1/status` and `/v1/health` are excluded from logging to avoid unnecessary output for common health checks.
    ///
    /// - Parameters:
    ///   - request: The incoming `Request` to process.
    ///   - next: The next `AsyncResponder` in the middleware chain, which could be another middleware or the main application router.
    /// - Returns: An asynchronous `Response` returned by the next responder in the chain.
    ///
    /// Example:
    /// ```swift
    /// let response = try await logMiddleware.respond(to: request, chainingTo: next)
    /// ```
    ///
    /// Logging Behavior:
    /// - Logs the HTTP method and the request's URL path at `.info` level.
    /// - Skips logging for paths `/v1/status` and `/v1/health`.
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let path = "\(request.url.path.removingPercentEncoding ?? request.url.path)"

        // Conditionally log the request method and path.
        if path != "/v1/status" && path != "/v1/health" {
            request.logger.log(level: .info, "\(request.method) \(path)")
        }

        // Pass the request to the next responder and return its response.
        return try await next.respond(to: request)
    }
}
