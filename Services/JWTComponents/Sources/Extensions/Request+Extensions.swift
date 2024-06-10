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
//  Request+Extensions.swift
//
//
//  Created by Mykola Buhaiov on 03.06.2024.
//

import JWT
import Vapor

extension Request {
    /// Payload key from StorageKey
    private struct PayloadKey: StorageKey {
        /// Set up typealias for `AccessTokenPayload`
        typealias Value = AccessTokenPayload
    }

    /// Set up getter and setter for Payload key
    public var payload: AccessTokenPayload {
        get { storage[PayloadKey.self] ?? Constants.defaultPayload }
        set { storage[PayloadKey.self] = newValue }
    }
}
