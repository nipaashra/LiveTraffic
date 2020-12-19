//
//  TrafficInfoDM.swift
//  SingaporeLiveTraffic
//
//  Created by Apple on 19/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Foundation

// MARK: - TrafficInfo
struct TrafficInfo: Codable{
    let items: [Item]
    let apiInfo: APIInfo

    enum CodingKeys: String, CodingKey {
        case items
        case apiInfo = "api_info"
    }
}

// MARK: - APIInfo
struct APIInfo: Codable {
    let status: String
}

// MARK: - Item
struct Item: Codable {
    let timestamp: String
    let cameras: [Camera]
}

// MARK: - Camera
struct Camera: Codable {
    let timestamp: String
    let image: String
    let location: Location
    let cameraID: String
    let imageMetadata: ImageMetadata

    enum CodingKeys: String, CodingKey {
        case timestamp, image, location
        case cameraID = "camera_id"
        case imageMetadata = "image_metadata"
    }
}

// MARK: - ImageMetadata
struct ImageMetadata: Codable {
    let height, width: Int
    let md5: String
}

// MARK: - Location
struct Location: Codable {
    let latitude, longitude: Double
}
