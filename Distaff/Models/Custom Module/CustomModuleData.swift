/* 
 Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
struct CustomModuleData : Codable {
    let message : String?
    let status : String?
    var clothstyle : [Clothstyle]?
    var shapesArray : [Shape]?
    var shapeBorderColorArray :[shape_border_colour]?
    var shapeFillColorArray :[shape_border_colour]?
    var  sizePriceList :[SizePriceData]?
    
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case clothstyle = "clothstyle"
        case shapesArray = "shape"
        case shapeBorderColorArray = "shape_colour"
        case shapeFillColorArray = "shape_fill_colour"
        case sizePriceList = "size"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        clothstyle = try values.decodeIfPresent([Clothstyle].self, forKey: .clothstyle)
        shapesArray = try values.decodeIfPresent([Shape].self, forKey: .shapesArray)
        shapeBorderColorArray = try values.decodeIfPresent([shape_border_colour].self, forKey: .shapeBorderColorArray)
        shapeFillColorArray = try values.decodeIfPresent([shape_border_colour].self, forKey: .shapeBorderColorArray)
        sizePriceList = try values.decodeIfPresent([SizePriceData].self, forKey: .sizePriceList)
        
    }
    
}
