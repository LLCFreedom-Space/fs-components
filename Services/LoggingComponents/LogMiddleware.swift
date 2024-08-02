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

public struct LogMiddleware: AsyncMiddleware {
    public init() {}
    
    /// Check path and don't show logger if it need
    /// - Parameters:
    ///   - request: The incoming `Request`.
    ///   - next: Next `Responder` in the chain, potentially another middleware or the main router.
    /// - Returns: An HTTP response from a server back to the client. An asynchronous `Response`.
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let path = "\(request.url.path.removingPercentEncoding ?? request.url.path)"
        if path != "/v1/status" && path != "/v1/health" {
            request.logger.log(level: .trace, "\(request.method) \(path)")
        }
        return try await next.respond(to: request)
    }
}
