//
//  FacialExpression.swift
//  FaceIt
//
//  Created by Keith Knight on 7/2/17.
//  Copyright © 2017 Living Green. All rights reserved.
//

//////////
// MODEL
//////////

import Foundation
// UI-independent representation of a facial expression

struct FacialExpression
{
    enum Eyes: Int {
        case open
        case closed
        case squinting  // Example of a Model attribute that has no View equivalent
    }
    enum Mouth: Int {
        case frown  // Nothing in the Model about mouth curvature
        case smirk
        case neutral
        case grin
        case smile
        
        var sadder: Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
        var happier: Mouth {
            return Mouth(rawValue:rawValue + 1) ?? .smile
        }
    }
    
    var sadder: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.sadder)
    }
    var happier: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
    
    let eyes : Eyes
    let mouth: Mouth
}
