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
//  AllowedHostsMiddleware.swift
//  
//
//  Created by Mykola Buhaiov on 10.05.2024.
//

import Vapor

public struct AllowedHostsMiddleware: AsyncMiddleware {
    ///  "AllowedHostsMiddleware": It checks if the incoming request's IP address is identifiable and permitted based on a predefined list of allowed hosts.
    /// - Parameters:
    ///   - request: The incoming `Request`.
    ///   - next: Next `Responder` in the chain, potentially another middleware or the main router.
    /// - Returns: allowed response with a correct IP address
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        request.logger.info("INFO: ipAddress - \(String(describing: request.remoteAddress?.ipAddress))")
        request.logger.info("INFO: ipAddress headers - \(String(describing: request.headers))")
        guard let ipAddress = request.remoteAddress?.ipAddress else {
            request.application.logger.error("ERROR: Access attempt without an authorized IP address")
            throw HostError.notAcceptable
        }
        if !request.application.allowedHosts.contains(ipAddress) {
            request.application.logger.error("ERROR: Unauthorized access attempt from IP address: \(ipAddress)")
            throw HostError.unauthorizedAccessAttempt(ipAddress: ipAddress)
        }
        return try await next.respond(to: request)
    }
}
