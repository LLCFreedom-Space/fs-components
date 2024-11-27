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

/// A concrete implementation of `ConsulComponentsProtocol` for interacting with a Consul server.
///
/// `ConsulComponents` provides functionality for:
/// - Checking the connection status of the Consul server.
/// - Fetching configuration values from Consul or local environment variables.
/// - Retrieving JSON Web Key Sets (JWKS) from Consul or local files.
///
/// This implementation uses the `Application` context for accessing configuration and logging.
public struct ConsulComponents: ConsulComponentsProtocol {
    /// The `Application` instance used for configuration and networking.
    public let app: Application

    /// Initializes a new `ConsulComponents` instance.
    ///
    /// - Parameter app: The `Application` instance.
    public init(app: Application) {
        self.app = app
    }

    /// Retrieves the connection status of the Consul server.
    ///
    /// - Returns: `HTTPResponseStatus` if the connection status was successfully retrieved, or `nil` otherwise.
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

    /// Retrieves a value from Consul or the environment.
    ///
    /// - Parameters:
    ///   - consulStatus: The current `HTTPResponseStatus` of the Consul server, or `nil` if the status was not checked.
    ///   - path: The key to look up in Consul.
    /// - Returns: The retrieved value as a `String`.
    /// - Throws: An error if the value cannot be retrieved.
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

    /// Retrieves a JWKS value from Consul or a local file.
    ///
    /// - Parameters:
    ///   - consulStatus: The current `HTTPResponseStatus` of the Consul server, or `nil` if the status was not checked.
    ///   - path: The key to look up in Consul.
    ///   - fileName: The name of the JWKS file in the local directory.
    /// - Returns: The retrieved JWKS value as a `String`.
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

    /// Fetches a value from Consul using the specified URI.
    ///
    /// This method performs the following steps:
    /// 1. Constructs request headers, including basic authorization if credentials are provided.
    /// 2. Sends a GET request to the specified Consul URI.
    /// 3. Decodes the response body into raw data.
    /// 4. Converts the decoded data into a UTF-8 string representation.
    ///
    /// - Parameter path: The full `URI` of the Consul key-value endpoint, including the service host and port.
    ///                   Example: `http://127.0.0.1:8500/v1/kv/config/example-service/key`
    /// - Returns: The value associated with the specified key as a `String`.
    /// - Throws: An error if the request fails or if the response cannot be decoded.
    ///
    /// ## Logging
    /// - Logs an error if the decoded value is empty.
    /// - Logs a success message if the value is successfully retrieved and decoded.
    private func getValueFromConsul(by path: URI) async throws -> String {
        var headers = HTTPHeaders()

        // Add basic authorization headers if credentials are provided.
        if let username = app.consulConfiguration?.username, !username.isEmpty,
           let password = app.consulConfiguration?.password, !password.isEmpty {
            headers.basicAuthorization = BasicAuthorization(username: username, password: password)
        }

        // Send a GET request to the specified URI.
        let response = try await app.client.get(path, headers: headers)

        // Decode the response data.
        let dataValue = self.decode(response, path)

        // Convert the decoded data to a UTF-8 string.
        let value = String(decoding: dataValue, as: UTF8.self)

        // Log based on the outcome.
        if value.isEmpty {
            app.logger.error("Encoded empty value for '\(path)' in Consul.")
        } else {
            app.logger.info("SUCCESS: Retrieved value '\(value)' for '\(path)' from Consul.")
        }

        return value
    }

    /// Fetches a JWKS (JSON Web Key Set) value from Consul using the specified URI.
    ///
    /// This method performs the following steps:
    /// 1. Constructs request headers, including basic authorization if credentials are provided.
    /// 2. Sends a GET request to the specified Consul URI.
    /// 3. Decodes the response body into raw data.
    /// 4. Attempts to deserialize the data into a `JWKS` object.
    /// 5. Returns the JWKS as a UTF-8 encoded string if decoding is successful, or logs an error otherwise.
    ///
    /// - Parameter path: The full `URI` of the Consul endpoint, including the service host and port.
    ///                   Example: `http://127.0.0.1:8500/v1/kv/config/example-service/jwks`
    /// - Returns: A `String` representation of the JWKS value if successfully retrieved and decoded, or an empty string if an error occurs.
    /// - Throws: An error if the request fails or if the response cannot be decoded.
    ///
    /// ## Logging
    /// - Logs an error if the decoding process fails or the JWKS value is empty.
    /// - Logs detailed information for debugging purposes, including errors and success messages.
    private func getJWKSFromConsul(by path: URI) async throws -> String {
        var headers = HTTPHeaders()

        // Add basic authorization headers if credentials are provided.
        if let username = app.consulConfiguration?.username, !username.isEmpty,
           let password = app.consulConfiguration?.password, !password.isEmpty {
            headers.basicAuthorization = BasicAuthorization(username: username, password: password)
        }

        // Send a GET request to the specified URI.
        let response = try await app.client.get(path, headers: headers)

        // Decode the response data.
        let decodingDataValue = self.decode(response, path)

        // Attempt to decode the data into a JWKS model.
        var jwksModel: JWKS?
        do {
            jwksModel = try JSONDecoder().decode(JWKS.self, from: decodingDataValue)
        } catch {
            app.logger.error("Failed to decode JWKS from data. ERROR - \(error.localizedDescription)")
        }

        // Convert the decoded data to a UTF-8 string representation.
        let jwksString = String(decoding: decodingDataValue, as: UTF8.self)

        // Log and handle the result.
        guard jwksModel != nil, !jwksString.isEmpty else {
            app.logger.error("JWKS value in Consul is empty or invalid: '\(jwksString)'.")
            return ""
        }

        return jwksString
    }

    /// Retrieves a value from the environment variables using the specified key.
    ///
    /// This method checks if an environment variable exists for the given key and ensures that its value is not empty.
    /// If no value is found, the method logs an error and terminates the application.
    /// If a value is found, it logs the success and returns the value.
    ///
    /// - Parameter key: A `String` representing the environment variable key to look up.
    ///                  The key should match the variable name in the `.env` file or system environment.
    /// - Returns: A `String` representing the value of the environment variable associated with the given key.
    /// - Throws: This method terminates the application (`fatalError`) if the value is not found or is empty.
    ///
    /// ## Logging
    /// - Logs an error message if no value is found for the key.
    /// - Logs a success message when a value is successfully retrieved.
    ///
    /// ## Example Usage
    /// ```swift
    /// let databaseURL = getValueFromEnvironment(by: "DATABASE_URL")
    /// print(databaseURL) // "postgresql://localhost/mydb"
    /// ```
    ///
    /// ## Notes
    /// - Ensure that the `.env` file or system environment contains the required keys.
    /// - This method is critical for applications relying on environment-based configurations.
    private func getValueFromEnvironment(by key: String) -> String {
        guard let value = Environment.get(key), !value.isEmpty else {
            // Log an error and terminate if the value is missing or empty.
            app.logger.error("No value was found at the given key - '\(key)'")
            fatalError("No value was found at the given key - '\(key)'")
        }

        // Log success and return the value.
        app.logger.info("SUCCESS: Retrieved '\(value)' for the given key - '\(key)' from local environment")
        return value
    }

    /// Retrieves a JWKS (JSON Web Key Set) from a local directory.
    ///
    /// This method attempts to load a JWKS file from the local directory using the provided file name.
    /// If the file exists and can be read, it returns the JWKS content as a UTF-8 string.
    /// If the file cannot be found, or the content cannot be encoded, the method logs an error and terminates the application.
    ///
    /// - Parameter name: A `String` representing the name of the JWKS file to load from the local directory.
    ///                   The method assumes the file is located in the application's working directory.
    /// - Returns: A `String` containing the JWKS value read from the file, encoded as UTF-8.
    /// - Throws: This method terminates the application (`fatalError`) if the file cannot be loaded or the content cannot be encoded.
    ///
    /// ## Logging
    /// - Logs an error if the JWKS file cannot be loaded or its content cannot be decoded.
    /// - Logs a success message when the JWKS value is successfully retrieved.
    ///
    /// ## Example Usage
    /// ```swift
    /// let jwks = getJWKSFromLocalDirectory(by: "jwks-file.json")
    /// print(jwks) // Prints the contents of the JWKS file
    /// ```
    ///
    /// ## Notes
    /// - Ensure the file is available in the application's working directory with the correct name.
    /// - The file content should be in JSON format and valid for decoding.
    private func getJWKSFromLocalDirectory(by name: String) -> String {
        // Construct the full file path using the working directory and the provided file name.
        let jwksFilePath = self.app.directory.workingDirectory + name

        // Attempt to load the file contents.
        guard let jwksValue = FileManager.default.contents(atPath: jwksFilePath) else {
            self.app.logger.error("ERROR: Failed to load JWKS Keypair file at the file path - '\(jwksFilePath)'")
            fatalError("Failed to load JWKS Keypair file at the file path - '\(jwksFilePath)'")
        }

        // Attempt to convert the file contents to a UTF-8 string.
        guard let jwksString = String(data: jwksValue, encoding: .utf8), !jwksString.isEmpty else {
            self.app.logger.error("Failed to encode JWKS value from the data - '\(jwksValue)'")
            fatalError("Failed to encode JWKS value from the data - '\(jwksValue)'")
        }

        // Log the success and return the JWKS string.
        self.app.logger.info("SUCCESS: Retrieved the JWKS value from the local machine along the file path \(jwksFilePath)")
        return jwksString
    }

    /// Retrieves a version string from a local file.
    ///
    /// This method attempts to load a version file from the local directory using the provided file name.
    /// If the file exists and can be read, it returns the version content as a UTF-8 string, removing any newline characters.
    /// If the file cannot be found or the content cannot be encoded, the method logs an error and terminates the application.
    ///
    /// - Parameter name: A `String` representing the name of the version file to load from the local directory.
    ///                   The method assumes the file is located in the application's working directory.
    /// - Returns: A `String` containing the version value read from the file, encoded as UTF-8 without newline characters.
    /// - Throws: This method terminates the application (`fatalError`) if the file cannot be loaded or the content cannot be encoded.
    ///
    /// ## Logging
    /// - Logs an error if the version file cannot be loaded or its content cannot be decoded.
    /// - Logs a success message when the version value is successfully retrieved.
    ///
    /// ## Example Usage
    /// ```swift
    /// let version = getVersionFromLocalDirectory(by: "version.txt")
    /// print(version) // Prints the version from the file
    /// ```
    ///
    /// ## Notes
    /// - Ensure the file is available in the application's working directory with the correct name.
    /// - The file content should be a plain text version string (e.g., "1.0.0").
    private func getVersionFromLocalDirectory(by name: String) -> String {
        // Construct the full file path using the working directory and the provided file name.
        let versionPath = self.app.directory.workingDirectory + name

        // Attempt to load the file contents.
        guard let versionValue = FileManager.default.contents(atPath: versionPath) else {
            self.app.logger.error("ERROR: Failed to load Version file at the file path - '\(versionPath)'")
            fatalError("ERROR: Failed to load Version file at the file path - '\(versionPath)'")
        }

        // Attempt to convert the file contents to a UTF-8 string and remove newline characters.
        guard let versionString = String(data: versionValue, encoding: .utf8)?.replacingOccurrences(of: "\n", with: ""), !versionString.isEmpty else {
            self.app.logger.error("ERROR: Failed to encode Version value from the data - '\(versionValue)'")
            fatalError("ERROR: Failed to encode Version value from the data - '\(versionValue)'")
        }

        // Log the success and return the version string.
        self.app.logger.info("SUCCESS: Retrieved the Version - \(versionString) from the local machine along the file path \(versionPath)")
        return versionString
    }

    /// Decodes the `ClientResponse` from Consul into a `Data` object.
    ///
    /// This method attempts to decode the `ClientResponse` received from Consul into an array of `ConsulKeyValueResponse` objects.
    /// It then extracts the first value from the response, decodes it from Base64, and returns the result as a `Data` object.
    ///
    /// - Parameters:
    ///   - response: The `ClientResponse` received from Consul, containing the raw data to be decoded.
    ///   - uri: The `URI` of the request, used for logging and error handling to trace where the data was fetched from.
    /// - Returns: A `Data` object containing the decoded value from the response, converted from Base64 encoding.
    ///
    /// - Throws: This method terminates the application (`fatalError`) if:
    ///   - The `ClientResponse` cannot be decoded into an array of `ConsulKeyValueResponse` objects.
    ///   - No value is found in the decoded response.
    ///   - The Base64 string cannot be converted into `Data`.
    ///
    /// ## Logging:
    /// - Logs an error if the decoding process fails, if no value is found, or if Base64 decoding fails.
    ///
    /// ## Example Usage:
    /// ```swift
    /// let data = decode(response, uri)
    /// print(data) // Prints the decoded data from Consul response
    /// ```
    ///
    /// ## Notes:
    /// - The method assumes the `ClientResponse` content is in Base64-encoded format.
    /// - If the Base64 decoding fails, the method will log an error and terminate the application.
    private func decode(_ response: ClientResponse, _ uri: URI) -> Data {
        // Attempt to decode the response into an array of `ConsulKeyValueResponse`.
        var content: [ConsulKeyValueResponse] = []
        do {
            content = try response.content.decode([ConsulKeyValueResponse].self)
        } catch {
            self.app.logger.error("ERROR: Failed to decode ClientResponse from Consul. LocalizedError - \(error.localizedDescription), error - \(error). For path - '\(uri)'")
        }

        // Ensure the first element has a value, otherwise log an error and terminate.
        guard let stringValue = content.first?.value else {
            self.app.logger.error("ERROR: No value was found at the - '\(uri)'")
            fatalError("ERROR: No value was found at the - '\(uri)'")
        }

        // Attempt to decode the Base64-encoded string into raw bytes.
        guard let arrayOfRawBytes = Array(decodingBase64: stringValue) else {
            self.app.logger.error("ERROR: Failed to decode '\(stringValue)' to 'Data'")
            fatalError("ERROR: Failed to decode '\(stringValue)' to 'Data'")
        }

        // Return the decoded data as a `Data` object.
        return Data(arrayOfRawBytes)
    }
}
