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
//  JWTMiddleware.swift
//
//
//  Created by Mykola Buhaiov on 03.06.2024.
//

import JWT
import Vapor

/// JSON Web Token Middleware
public struct JWTMiddleware: AsyncMiddleware {
    public init() {}

    /// Verification an JWT
    /// - Parameters:
    ///   - request: The incoming `Request`.
    ///   - next: Next `Responder` in the chain, potentially another middleware or the main router.
    /// - Returns: An HTTP response from a server back to the client. An asynchronous `Response`.
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let token = request.headers.bearerAuthorization?.token.utf8 else {
            request.logger.error("ERROR: No JWT in headers: \(request.headers)")
            throw AuthenticationError.missingAuthorizationHeader
        }
        do {
            request.payload = try request.jwt.verify(Array(token), as: AccessTokenPayload.self)
        } catch let JWTError.claimVerificationFailure(name: name, reason: reason) {
            request.logger.error("ERROR: JWT Verification Failure: \(name), \(reason)")
            if name == "exp" {
                request.logger.error("ERROR: JWT failure with - \(name) and \(reason)")
                throw JWTError.claimVerificationFailure(name: name, reason: reason)
            } else {
                request.logger.error("ERROR: JWT verification failure")
                throw AuthenticationError.claimVerificationFailure
            }
        } catch {
            request.logger.error("ERROR: JWT Middleware failure with - \(error)")
            throw error
        }
        guard request.payload.issuer == request.application.jwtClaimIssuer else {
            request.logger.error("ERROR: Issuer in JWT incorrect")
            throw AuthenticationError.missingAuthorizationHeader
        }
        guard request.payload.audience.value.contains(request.application.audienceName) else {
            request.logger.error("ERROR: Audience not contains server name")
            throw AuthenticationError.claimVerificationFailure
        }
        return try await next.respond(to: request)
    }
}
