//
//  Animations.swift
//  Wildlife Encyclopedia
//
//  Created by SwiftUI-Lab on 10-Jul-2020.
//  https://swiftui-lab.com/matchedGeometryEffect-part2
//

import SwiftUI

var debugAnimations = false
let duration_of_animation: Double = 0.6

extension Animation {
    static var shake: Animation {
        if debugAnimations {
            return Animation.easeInOut(duration: duration_of_animation)
        } else {
            return Animation.interactiveSpring(response: duration_of_animation, dampingFraction: 0.6, blendDuration: 0.25)
        }
    }
    
    static var fly: Animation {
        if debugAnimations {
            return Animation.easeInOut(duration: duration_of_animation)
        } else {
            return Animation.interactiveSpring(response: duration_of_animation, dampingFraction: 0.6, blendDuration: 0.25)
        }
    }
    
    static var basic: Animation {
        if debugAnimations {
            return Animation.easeInOut(duration: duration_of_animation)
        } else {
            return Animation.default
        }
    }
}
