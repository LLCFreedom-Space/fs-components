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
//  Created by Mykola Buhaiov on 10.02.2024.
//

import Vapor

/// Constants
public enum Constants {
    /// Default url for consul
    static let consulUrl = "http://127.0.0.1:8500"

    /// Default path for get consul status
    static let consulStatusPath = "/v1/status/leader"
}