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
//  Constants.swift
//
//
//  Created by Mykola Buhaiov on 03.06.2024.
//

import Vapor

/// Constants
public enum Constants {
    /// Issuer name that issued access token
    public static let audienceName = "jwt-library"

    public static let defaultJwtClaimIssuer = "jwt-library"

    public static let accessTokenLifetime: Double = 60 * 60

    public static let defaultPayload = AccessTokenPayload(
        sub: UUID(),
        userType: .standard,
        expirationAt: Date().addingTimeInterval(TimeInterval(Constants.accessTokenLifetime)),
        issuedAt: Date(),
        issuer: Constants.defaultJwtClaimIssuer,
        audience: [Constants.audienceName]
    )
}
