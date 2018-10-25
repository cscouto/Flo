//
//  GraphView.swift
//  Flo
//
//  Created by COUTO, TIAGO [AG-Contractor/1000] on 10/19/18.
//  Copyright © 2018 Couto Code. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }
    
    //Weekly sample data
    var graphPoints = [4, 2, 6, 4, 5, 8, 3]
    
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height

        //clipping the corners
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadiusSize)
        
        path.addClip()
        
        //use the current context to draw
        let context = UIGraphicsGetCurrentContext()
        
        let colors = [startColor.cgColor, endColor.cgColor]
        
        //all contexts gave a color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //where the color changes
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context?.drawLinearGradient(gradient,
                                    start: startPoint,
                                    end: endPoint,
                                    options: [])
        
        //caclculate the x point
        let graphWidth = width - Constants.margin * 2 - 4
        
        let columnXPoint = { (column: Int) -> CGFloat in
            //calculate the gap between points
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + Constants.margin + 2
        }
        
        let graphHeight = height - Constants.topBorder - Constants.bottomBorder
        let maxValue = graphPoints.max()!
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + Constants.topBorder - y
        }
        
        //draw the line graph
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        //set up the points line
        let graphPath = UIBezierPath()
        
        //go to start line
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        
        //add points for each item in the graph points array at the correct (x,y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        graphPath.stroke()
    }
}
