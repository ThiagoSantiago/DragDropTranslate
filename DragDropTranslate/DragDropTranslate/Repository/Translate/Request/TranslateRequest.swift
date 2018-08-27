//
//  TranslateRequest.swift
//  DragDropTranslate
//
//  Created by Thiago Santiago on 8/26/18.
//  Copyright © 2018 Thiago Santiago. All rights reserved.
//

import Foundation

class TranslateRequest {
    var textToTranslate: String?
    
    init(textDragged: String) {
        textToTranslate = textDragged
    }
    
    public var endpoint: String {
        return "language/translate/v2"
    }
    
    public var method: String {
        return "POST"
    }
    
    public var body:  [String : String] {
        return ["q":textToTranslate ?? "", "target": "en"]
    }
}
