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
        
        //Create the clipping path for the graph gradient
        
        //1 - save the state of the context (commented out for now)
        context?.saveGState()
        
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y:height))
        clippingPath.addLine(to: CGPoint(x:columnXPoint(0), y:height))
        clippingPath.close()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: Constants.margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: Constants.margin, y: bounds.height)
        
        context?.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        context?.restoreGState()
        
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //Draw the circles on top of the graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
            circle.fill()
        }
        
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
        linePath.move(to: CGPoint(x: Constants.margin, y: Constants.topBorder))
        linePath.addLine(to: CGPoint(x: width - Constants.margin, y: Constants.topBorder))
        
        //center line
        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight/2 + Constants.topBorder))
        linePath.addLine(to: CGPoint(x: width - Constants.margin, y: graphHeight/2 + Constants.topBorder))
        
        //bottom line
        linePath.move(to: CGPoint(x: Constants.margin, y:height - Constants.bottomBorder))
        linePath.addLine(to: CGPoint(x:  width - Constants.margin, y: height - Constants.bottomBorder))
        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()


    }
}
