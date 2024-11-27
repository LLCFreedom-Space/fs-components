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

/// A protocol defining the components for interacting with a Consul server.
///
/// `ConsulComponentsProtocol` provides methods for checking the connection status,
/// retrieving values from Consul, and obtaining JSON Web Key Sets (JWKS) either from Consul or a local file.
///
/// Implementing this protocol allows for flexible and asynchronous interaction with Consul services.
public protocol ConsulComponentsProtocol {

    /// Retrieves the connection status of the Consul server.
    ///
    /// This method checks whether the application can successfully connect to the Consul server.
    ///
    /// - Returns: The `HTTPResponseStatus` if the connection status is successfully obtained, or `nil` if it cannot be determined.
    ///
    /// Example:
    /// ```swift
    /// if let status = await consulComponents.getConsulStatus() {
    ///     print("Consul status: \(status)")
    /// } else {
    ///     print("Failed to retrieve Consul status.")
    /// }
    /// ```
    func getConsulStatus() async -> HTTPResponseStatus?

    /// Retrieves a value from Consul by its key.
    ///
    /// This method fetches a value stored in Consul using the specified key. The connection status
    /// (`consulStatus`) can optionally be passed to ensure the Consul server is reachable before attempting retrieval.
    ///
    /// - Parameters:
    ///   - consulStatus: The current `HTTPResponseStatus` of the Consul server, or `nil` if the status has not been checked.
    ///   - path: The `String` key used to look up the value in Consul.
    /// - Returns: The `String` value retrieved from Consul.
    /// - Throws: An error if the value cannot be retrieved or an issue occurs during the process.
    ///
    /// Example:
    /// ```swift
    /// let value = try await consulComponents.getValue(with: status, by: "config/service/key")
    /// print("Retrieved value: \(value)")
    /// ```
    func getValue(with consulStatus: HTTPResponseStatus?, by path: String) async throws -> String

    /// Retrieves a JWKS value from Consul or a local file.
    ///
    /// This method attempts to fetch a JWKS value stored in Consul by a specified key. If unavailable,
    /// it falls back to retrieving the JWKS from a local file.
    ///
    /// - Parameters:
    ///   - consulStatus: The current `HTTPResponseStatus` of the Consul server, or `nil` if the status has not been checked.
    ///   - path: The `String` key used to look up the JWKS value in Consul.
    ///   - fileName: The `String` name of the local JWKS file to be used as a fallback.
    /// - Returns: The `String` JWKS value, either from Consul or the local file.
    ///
    /// Example:
    /// ```swift
    /// let jwks = await consulComponents.getJWKS(with: status, by: "jwks/key", and: "local-jwks.json")
    /// print("Retrieved JWKS: \(jwks)")
    /// ```
    func getJWKS(with consulStatus: HTTPResponseStatus?, by path: String, and fileName: String) async -> String
}
