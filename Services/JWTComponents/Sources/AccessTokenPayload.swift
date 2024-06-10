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
//  AccessTokenPayload.swift
//
//
//  Created by Mykola Buhaiov on 03.06.2024.
//

import JWT
import Vapor

/// Payload data for a refresh token
/// A representation of the payload used in the access tokens
/// for this service's authentication.
public struct AccessTokenPayload: JWTPayload {
    /// Unique identifier for this `User`
    public let subject: UUID
    /// UserType for checking admin routes.
    /// It is custom payload property.
    public let userType: UserType
    /// Expiration
    public let expiration: ExpirationClaim
    /// Issues at
    public let issuedAt: IssuedAtClaim
    /// For whom "web-app", "ios-app", "android-app", "client"
    public let audience: AudienceClaim
    /// Service JWT generator name "service"
    public let issuer: IssuerClaim

    /// Init AccessTokenPayload
    /// - Parameters:
    ///   - sub: userId
    ///   - userType: UserType for checking admin routes
    ///   - expirationAt: Expiration
    ///   - issuedAt: issues at
    ///   - issuer: Service JWT generator name
    ///   - audience:
    public init(
        sub: UUID,
        userType: Self.UserType,
        expirationAt: Date = Date().addingTimeInterval(TimeInterval(Constants.accessTokenLifetime)),
        issuedAt: Date = Date(),
        issuer: String = Constants.defaultJwtClaimIssuer,
        audience: [String] = [Constants.audienceName]
    ) {
        var audienceClaimValue = audience
        if !audienceClaimValue.contains(Constants.audienceName) {
            audienceClaimValue.append(Constants.audienceName)
        }
        self.issuer = IssuerClaim(value: issuer)
        self.audience = AudienceClaim(value: audienceClaimValue)
        self.expiration = ExpirationClaim(value: expirationAt)
        self.issuedAt = IssuedAtClaim(value: issuedAt)
        self.userType = userType
        self.subject = sub
    }

    /// Verification JWT payload
    /// - Parameter signer: JWT token that need verification
    /// - Throws: Whatever throws in the implementation.
    public func verify(using signer: JWTSigner, include: String) throws {
        try self.expiration.verifyNotExpired()
        try self.audience.verifyIntendedAudience(includes: include)
    }

    /// Verification JWT payload
    /// - Parameter signer: JWT token that need verification
    /// - Throws: Whatever throws in the implementation.
    public func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
        try self.audience.verifyIntendedAudience(includes: Constants.audienceName)
    }
}

public extension AccessTokenPayload {
    /// CodingKey enum for coding key
    enum CodingKeys: String, CodingKey {
        /// Case for subject
        case subject = "sub"
        /// Case for expiration
        case expiration = "exp"
        /// Case for issuedAt
        case issuedAt = "iat"
        /// Case for audience
        case audience = "aud"
        /// Case for issuer
        case issuer = "iss"
        /// Case for user type
        case userType = "user_type"
    }

    /// UserType enum for type of user
    enum UserType: String, Content, CaseIterable {
        /// Standard user
        case standard
        /// Admin user for specific routes
        case admin
    }
}
