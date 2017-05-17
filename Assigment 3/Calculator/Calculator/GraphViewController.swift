//
//  GraphViewController.swift
//  Calculator
//
//  Created by Dirk Hornung on 16/5/17.
//  Copyright © 2017 Dirk Hornung. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.getYCoordinate = {(x) -> CGFloat in
                if let f = self.function {
                    return CGFloat(f(x))
                }
                return CGFloat()
            }
            
            // a. Pinching (zooms the entire graph, including the axes, in or out on the graph)
            let handler = #selector(GraphView.changeScale(byReactingTo: ))
            let pinchRegonizer = UIPinchGestureRecognizer(target: graphView, action: handler)
            graphView.addGestureRecognizer(pinchRegonizer)
            
            // b. Panning (move the entire graph, including axes, to follow the touch around)
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(GraphView.move(byReactingTo: ))))
            
            // c. Double-tapping (moves the origin of the graph to the point of the double tap)
            let tapRecognizer = UITapGestureRecognizer(target: graphView, action: #selector(GraphView.doubleTap))
            tapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    var function: ((CGFloat) -> CGFloat)?
}
