//
//  FaceView.swift
//  FaceIt
//
//  Created by Keith Knight on 7/2/17.
//  Copyright © 2017 Living Green. All rights reserved.
//

/////////
// VIEW
/////////

import Foundation
import UIKit

@IBDesignable
class FaceView: UIView {
    
    // Public API
    
    @IBInspectable
    var scale: CGFloat = 0.9  { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var eyesOpen: Bool = true  { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0  { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var color: UIColor = UIColor.blue  { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    // 1.0 is full smile -1.0 is full frown
    var mouthCurvature: Double = -0.5 { didSet { setNeedsDisplay() } }
    
    ///////////////////////////////////////////////////////////////////////
    // Gesture pinch and expand to change scale
    ///////////////////////////////////////////////////////////////////////
    
    // Pinch handler
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer)
    {
        switch pinchRecognizer.state {  // inherited from UIPinchRecognizer
        case .changed, .ended:
//            scale *= CGFloat(pinchRecognizer.state.rawValue)
            scale *= pinchRecognizer.scale
            print("scale =  + \(scale)")
            pinchRecognizer.scale = 1 // reset scale
        default:
            break;
        }
    }

    
    
    // Private Implementation
    
    // private computed var
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2  * scale
    }
    
    private var skullCenter: CGPoint  {
        // let skullCenter = convert(center, from: superview)
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private enum Eye {
        case left
        case right
    }
    
    private func pathForEye(_ eye: Eye) -> UIBezierPath {
        // func centerOfEye is only called from within pathForEye
        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            // ternary construct
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
        }
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)  // call func
        
        //let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius,
        //     startAngle: 0, endAngle: CGFloat:pi * 2, clockwise: true)
        
        let path: UIBezierPath
        if eyesOpen { // circles
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius,
                                startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        } else { // lines
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        
        let mouthRect = CGRect(
            x: skullCenter.x - mouthWidth / 2,
            y: skullCenter.y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight
        )
        
        // CGFloat has a constructor that takes a float in order to cast from Double to CGFloat
        let smileOffset = CGFloat(max(-1, min(mouthCurvature,1))) * mouthRect.height
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y:  start.y + smileOffset)
        let cp2 =  CGPoint(x: end.x - mouthRect.width / 3, y:  start.y + smileOffset)
        
        //let path = UIBezierPath(rect: mouthRect) // to see rectangle
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForSkull() -> UIBezierPath
    {
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius,
                                startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect)  {   // add this
  	     // Drawing code
        color.set()   // was UIColor.blue.set()
        pathForSkull().stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
    }
    
    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
    }
}
