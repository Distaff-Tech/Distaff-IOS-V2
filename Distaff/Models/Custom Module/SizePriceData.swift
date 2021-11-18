

import Foundation
import UIKit
struct SizePriceData : Codable {
    let id : Int?
    let size : String?
    let price : Double?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case size = "size"
        case price = "price"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        size = try values.decodeIfPresent(String.self, forKey: .size)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
    }

}
