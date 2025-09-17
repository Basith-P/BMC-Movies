//
//  MovieResponse.swift
//  BMC Movies
//
//  Created by Basith P on 17/09/25.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}
