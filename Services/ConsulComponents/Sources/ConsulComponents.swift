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
//  ConsulComponents.swift
//
//
//  Created by Mykola Buhaiov on 08.02.2024.
//

import Vapor
import JWT

public struct ConsulComponents: ConsulComponentsProtocol {
    /// Instance of app as `Application`
    let app: Application
    
    /// Init for `ConsulComponents`
    /// - Parameter app: `Application`
    init(app: Application) {
        self.app = app
    }
    
    /// Get connection status for consul
    /// - Returns: `HTTPResponseStatus` or `nil` depending on whether the status was obtained from the service
    public func getConsulStatus() async -> HTTPResponseStatus? {
        let path = Constants.consulStatusPath
        let url = app.consulConfiguration?.url ?? Constants.consulUrl
        let uri = URI(string: url + path)
        var headers = HTTPHeaders()
        if let username = app.consulConfiguration?.username, !username.isEmpty, let password = app.consulConfiguration?.password, !password.isEmpty {
            headers.basicAuthorization = BasicAuthorization(username: username, password: password)
        }
        let status = try? await app.client.get(uri, headers: headers).status
        self.app.logger.debug("ConsulKV connection status - \(String(describing: status?.reasonPhrase)). Connection for consul by URL - \(url), and path - \(path)")
        return status
    }

    /// Get value
    /// - Parameters:
    ///   - consulStatus: `HTTPResponseStatus` or `nil` depending on whether the status was obtained from the service
    ///   - path: `String` key by which the value will be obtained
    /// - Returns: `String` obtained value
    public func getValue(with consulStatus: HTTPResponseStatus?, by path: String) async throws -> String {
        let url = app.consulConfiguration?.url ?? Constants.consulUrl
        self.app.logger.debug("ConsulKV connection status - \(String(describing: consulStatus)). Connection for consul by URL - \(url), and path - \(path)")
        let uri = URI(string: url + "/" + path)
        let environmentKey = path.replacingOccurrences(of: "-", with: "_").uppercased()
        var value = ""
        if consulStatus == .ok {
            let valueResult = try? await getValueFromConsul(by: uri)
            value = valueResult ?? ""
        }
        return value.isEmpty ? self.getValueFromEnvironment(by: environmentKey) : value
    }

    /// Get JWKS value
    /// - Parameters:
    ///   - consulStatus: `HTTPResponseStatus` or `nil` depending on whether the status was obtained from the service
    ///   - path: `String` key by which the JWKS will be obtained
    ///   - fileName: `String`the name of the JWKS file that lies in the local directory
    /// - Returns: `String` JWKS value
    public func getJWKS(with consulStatus: HTTPResponseStatus?, by path: String, and fileName: String) async -> String {
        let url = app.consulConfiguration?.url ?? Constants.consulUrl
        let consulURI = URI(string: url + "/" + path)
        var valueJWKS = ""
        if consulStatus == .ok {
            let valueResult = try? await getJWKSFromConsul(by: consulURI)
            valueJWKS = valueResult ?? ""
        }
        return valueJWKS.isEmpty ? self.getJWKSFromLocalDirectory(by: fileName) : valueJWKS
    }

    /// Get value from Consul
    /// - Parameters:
    ///   - path: `URI` full path to the file, including service `host` and `port`. Example - `http://127.0.0.1:8500/v1/kv/config-develop/example-service/server-port`
    /// - Returns: `String` obtained value
    private func getValueFromConsul(by path: URI) async throws -> String {
        var headers = HTTPHeaders()
        if let username = app.consulConfiguration?.username, !username.isEmpty, let password = app.consulConfiguration?.password, !password.isEmpty {
            headers.basicAuthorization = BasicAuthorization(username: username, password: password)
        }
        let response = try await self.app.client.get(path, headers: headers)
        let dataValue = self.decode(response, path)
        let value = String(decoding: dataValue, as: UTF8.self)
        if value.isEmpty {
            self.app.logger.error("ERROR: Encoded empty value by '\(path)' in consul")
        } else {
            self.app.logger.info("SUCCESS: Encoded '\(value)' by '\(path)' from consul")
        }
        return value
    }

    /// Get `JWKS` value from Consul
    /// - Parameters:
    ///   - path: `URI` full path to the file, including service host and port
    /// - Returns: `String` `JWKS` value
    private func getJWKSFromConsul(by path: URI) async throws -> String {
        var headers = HTTPHeaders()
        if let username = app.consulConfiguration?.username, !username.isEmpty, let password = app.consulConfiguration?.password, !password.isEmpty {
            headers.basicAuthorization = BasicAuthorization(username: username, password: password)
        }
        let response = try await self.app.client.get(path, headers: headers)
        let decodingDataValue = self.decode(response, path)
        var jwksModel: JWKS?
        do {
            jwksModel = try JSONDecoder().decode(JWKS.self, from: decodingDataValue)
        } catch {
            self.app.logger.error("ERROR: Failed Decode JWKS from data. ERROR - \(error.localizedDescription)")
        }
        let jwksString = String(decoding: decodingDataValue, as: UTF8.self)

        guard jwksModel != nil, !jwksString.isEmpty else {
            self.app.logger.error("ERROR: JWKS value in consul equal '\(jwksString)'.")
            return ""
        }
        return jwksString
    }

    /// Get value from `.env` file
    /// - Parameter key: `String` key by which the value will be obtained
    /// - Returns: `String` obtained value
    private func getValueFromEnvironment(by key: String) -> String {
        guard let value = Environment.get(key), !value.isEmpty else {
            app.logger.error("ERROR: No value was found at the given - '\(key)'")
            fatalError("ERROR: No value was found at the given - '\(key)'")
        }
        app.logger.info("SUCCESS: Get '\(value)' by the given - '\(key)' get from local machine")
        return value
    }

    /// Get `JWKS` value from Local Directory
    /// - Parameter name: `String` the name of the `JWKS` file that lies in the local directory
    /// - Returns: `String` JWKS value
    private func getJWKSFromLocalDirectory(by name: String) -> String {
        let jwksFilePath = self.app.directory.workingDirectory + name
        guard let jwksValue = FileManager.default.contents(atPath: jwksFilePath) else {
            self.app.logger.error("ERROR: Failed to load JWKS Keypair file at the file path - '\(jwksFilePath)'")
            fatalError("ERROR: Failed to load JWKS Keypair file at the file path - '\(jwksFilePath)'")
        }
        guard let jwksString = String(data: jwksValue, encoding: .utf8), !jwksString.isEmpty else {
            self.app.logger.error("ERROR: Failed to encoding JWKS value from - '\(jwksValue)'")
            fatalError("ERROR: Failed to encoding JWKS value from - '\(jwksValue)'")
        }
        self.app.logger.info("SUCCESS: Get the JWKS value from the local machine along the file path \(jwksFilePath)")
        return jwksString
    }

    /// Get `Version` value from Local Directory
    /// - Returns: `String`
    private func getVersionFromLocalDirectory(by name: String) -> String {
        let versionPath = self.app.directory.workingDirectory + name
        guard let versionValue = FileManager.default.contents(atPath: versionPath) else {
            self.app.logger.error("ERROR: Failed to load Version file at the file path - '\(versionPath)'")
            fatalError("ERROR: Failed to load Version file at the file path - '\(versionPath)'")
        }
        guard let versionString = String(data: versionValue, encoding: .utf8)?.replacingOccurrences(of: "\n", with: ""), !versionString.isEmpty else {
            self.app.logger.error("ERROR: Failed to encoding Version value from - '\(versionValue)'")
            fatalError("ERROR: Failed to encoding Version value from - '\(versionValue)'")
        }
        self.app.logger.info("SUCCESS: Get the Version - \(versionString) from the local machine along the file path \(versionPath)")
        return versionString
    }

    /// Decode Consul `ClientResponse`
    /// - Parameter response: `ClientResponse` that come from Consul
    /// - Returns: `Data` that has been decoded
    private func decode(_ response: ClientResponse, _ uri: URI) -> Data {
        var content: [ConsulKeyValueResponse] = []
        do {
            content = try response.content.decode([ConsulKeyValueResponse].self)
        } catch {
            self.app.logger.error("ERROR: Failed decode ClientResponse from consul. LocalizedError - \(error.localizedDescription), error - \(error). For path - '\(uri)'")
        }
        guard let stringValue = content.first?.value else {
            self.app.logger.error("ERROR: No value was found at the - '\(uri)'")
            fatalError("ERROR: No value was found at the - '\(uri)'")
        }
        guard let arrayOfRawBytes = Array(decodingBase64: stringValue) else {
            self.app.logger.error("ERROR: Failed encoded '\(stringValue)' to 'Data'")
            fatalError("ERROR: Failed encoded '\(stringValue)' to 'Data'")
        }
        return Data(arrayOfRawBytes)
    }
}
