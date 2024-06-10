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
//  Application+Extensions.swift
//  
//
//  Created by Mykola Buhaiov on 03.06.2024.
//

import Vapor
import JWT

extension Application {
    /// A `AudienceNameKey` conform to StorageKey protocol
    private struct AudienceNameKey: StorageKey {
        /// Less verbose typealias for `String`.
        typealias Value = String
    }
    
    /// Setup `audienceName` in application storage
    public var audienceName: String {
        get { storage[AudienceNameKey.self] ?? Constants.audienceName }
        set { storage[AudienceNameKey.self] = newValue }
    }
}

extension Application {
    /// `ClaimIssuer` from `StorageKey`
    private struct JwtClaimIssuerKey: StorageKey {
        /// String
        typealias Value = IssuerClaim
    }
    
    /// `IssuerClaim` from StorageKey
    public var jwtClaimIssuer: IssuerClaim {
        get { storage[JwtClaimIssuerKey.self] ?? IssuerClaim(value: Constants.defaultJwtClaimIssuer) }
        set { storage[JwtClaimIssuerKey.self] = newValue }
    }
}
