/*
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ProfileData : Codable {
    let user_name : String?
    let fullname : String?
    let address : String?
    let gender : String?
    let about_me : String?
    let date_of_birth : String?
    let image : String?
    let canAddPost:Bool?
    
    enum CodingKeys: String, CodingKey {

        case user_name = "user_name"
        case fullname = "fullname"
        case address = "address"
        case gender = "gender"
        case about_me = "about_me"
        case date_of_birth = "date_of_birth"
        case image = "image"
        case canAddPost = "canAddPost"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        about_me = try values.decodeIfPresent(String.self, forKey: .about_me)
        date_of_birth = try values.decodeIfPresent(String.self, forKey: .date_of_birth)
        image = try values.decodeIfPresent(String.self, forKey: .image)
         canAddPost = try values.decodeIfPresent(Bool.self, forKey: .canAddPost)
    }

}

