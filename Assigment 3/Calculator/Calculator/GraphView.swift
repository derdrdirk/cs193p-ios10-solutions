//
//  GraphView.swift
//  Calculator
//
//  Created by Dirk Hornung on 16/5/17.
//  Copyright © 2017 Dirk Hornung. All rights reserved.
//

import UIKit

class GraphView: UIView {

    @IBInspectable
    var origin: CGPoint! { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 1.0
    
    @IBInspectable
    var color = UIColor.black
    
    @IBInspectable
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    
    var getYCoordinate: ((CGFloat) -> CGFloat)?
    
    
    private func pathForFunction() -> UIBezierPath {
        let path = UIBezierPath()
        
        let width = Int(bounds.size.width)
        var point = CGPoint()
        
        var noPathPoint = true;
        
        // Iterate over every pixel of the device (from left to right)
        for pixel in 0...width {
            point.x = CGFloat(pixel)
            let y = getYCoordinate!((point.x - origin.x) / scale)
            
            // if y value NaN and not zero skip
            if (!y.isNormal && !y.isZero) {
                noPathPoint = true
                continue
            }

            point.y = origin.y - CGFloat(y*scale)
            
            
            if (noPathPoint) {
                path.move(to: point)
                noPathPoint = false
            } else {
                path.addLine(to: point)
            }
        }
        
        path.lineWidth = lineWidth;
        return path
    }
    
    // a. Pinching
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    // b. Panning
    func move(byReactingTo panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .changed:
            let translation = panRecognizer.translation(in: self)
            // apply translation
            origin.x += translation.x
            origin.y += translation.y
            
            // reset recognizer
            panRecognizer.setTranslation(CGPoint(), in: self)
        default:
            break
        }
    }
    
    // c. Double Tapping
    func doubleTap(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        switch tapRecognizer.state {
        case .ended:
            origin = tapRecognizer.location(in: self)
        default:
            break
        }
    }
    
    override func draw(_ rect: CGRect) {
        // set the default origin to center
        origin = origin ?? CGPoint(x: bounds.midX, y: bounds.midY)
        let graphBoundaries = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.size.width, height: bounds.size.height)
        
        color.set()
        pathForFunction().stroke()
        
        let drawer = AxesDrawer()
        drawer.drawAxes(in: graphBoundaries, origin: origin, pointsPerUnit: CGFloat(scale))
    }

}
