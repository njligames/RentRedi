//
//  MockNetworkManager.swift
//  RentRedi
//
//  Created by James Folk on 9/22/22.
//

import Foundation

/*
 Simulates a network layer by sleeping the caller's thread for a few seconds before returning the requested data
 */
class MockNetworkManager {
    private static let imagesFilename = "images"

    static func getImageUrls() -> Data? {
        return getData(filename: imagesFilename)
    }
    
    private static func getData(filename: String) -> Data? {

        if let path = Bundle.main.url(forResource: filename, withExtension: "json"),
            let data = try? Data.init(contentsOf: path) {
            return data
        } else {
            return nil
        }
    }
}

