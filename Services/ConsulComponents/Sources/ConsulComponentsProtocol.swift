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
//  ConsulComponentsProtocol.swift
//
//
//  Created by Mykola Buhaiov on 08.02.2024.
//

import Vapor

public protocol ConsulComponentsProtocol {
    /// Get connection status for consul
    /// - Parameters:
    /// - Returns: `HTTPResponseStatus` or `nil` depending on whether the status was obtained from the service
    func getConsulStatus() async -> HTTPResponseStatus?
    
    /// Get value
    /// - Parameters:
    ///   - consulStatus: `HTTPResponseStatus` or `nil` depending on whether the status was obtained from the service
    ///   - path: `String` key by which the value will be obtained
    /// - Returns: `String` obtained value
    func getValue(with consulStatus: HTTPResponseStatus?, by path: String) async throws -> String

    /// Get JWKS value
    /// - Parameters:
    ///   - consulStatus: `HTTPResponseStatus` or `nil` depending on whether the status was obtained from the service
    ///   - path: `String` key by which the JWKS will be obtained
    ///   - fileName: `String`the name of the JWKS file that lies in the local directory
    /// - Returns: `String` JWKS value
    func getJWKS(with consulStatus: HTTPResponseStatus?, by path: String, and fileName: String) async -> String
}
