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
//  AdminMiddleware.swift
//
//
//  Created by Mykola Buhaiov on 03.06.2024.
//

import JWT
import Vapor

/// Admin verification Middleware
public struct AdminMiddleware: AsyncMiddleware {
    public init() {}

    /// Verification an User type in payload
    /// - Parameters:
    ///   - request: The incoming `Request`.
    ///   - next: Next `Responder` in the chain, potentially another middleware or the main router.
    /// - Returns: An HTTP response from a server back to the client. An asynchronous `Response`.
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard request.payload.userType == .admin else {
            request.logger.error("ERROR: User is not admin")
            throw AuthenticationError.missingAuthorizationHeader
        }
        return try await next.respond(to: request)
    }
}

