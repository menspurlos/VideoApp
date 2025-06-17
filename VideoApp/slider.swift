//
//  slider.swift
//  VideoApp
//
//  Created by Dmitry Grishkin on 09.06.2025.
//

import UIKit

@IBDesignable
class MZSlider: UISlider {
    
    @IBInspectable var minFillColor : UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var minStrokeColor : UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var maxFillColor : UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var maxStrokeColor : UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var thumbNormalFillColor : UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var thumbNormalStrokeColor : UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var thumbHighlightFillColor : UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var thumbHighlightStrokeColor : UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var thumbRadius : CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var sliderCornerRadius : CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }

    private enum SliderTrack {
        case Minimum
        case Maximum
    }
    
    // MARK: - Draw Methods
    
    private struct Ratios {
        static let startPosition: CGFloat = 10
        static let bezierHeight: CGFloat = 6
        static let circle: CGFloat = 6
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.setMinimumTrackImage(imageForRect(rect: rect, side: .Minimum), for: .normal)
        self.setMaximumTrackImage(imageForRect(rect: rect, side: .Maximum), for: .normal)
        
        
        self.setThumbImage(customThumbImage(strokeColor: thumbNormalStrokeColor, fillColor: thumbNormalFillColor), for: .normal)
        self.setThumbImage(customThumbImage(strokeColor: thumbHighlightFillColor, fillColor: thumbHighlightStrokeColor), for: .highlighted)
    }
    
    private func imageForRect(rect: CGRect, side: SliderTrack) -> UIImage? {
        // We create an innerRect in which we draw the lines
        let innerRect = rect.insetBy(dx: 1.0, dy: 10.0)
        
        UIGraphicsBeginImageContextWithOptions(innerRect.size, false, 0);
        
        let path = UIBezierPath(roundedRect: CGRect(x: Ratios.startPosition, y: (innerRect.height/2) - 3, width: innerRect.width - 20, height: Ratios.bezierHeight), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: sliderCornerRadius, height: sliderCornerRadius))
        
        switch side {
        case .Minimum:
            minStrokeColor.setStroke()
            minFillColor.setFill()
            path.fill()
            path.stroke()
            
        case .Maximum:
            maxStrokeColor.setStroke()
            maxFillColor.setFill()
            path.stroke()
            path.fill()
        }
        
        let selectedSide = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero)
        
        UIGraphicsEndImageContext()
        
        return selectedSide
    }
    
    private func customThumbImage(strokeColor: UIColor, fillColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 40, height: 40), false, 0)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 20,y: 20), radius: thumbRadius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        strokeColor.setStroke()
        fillColor.setFill()
        
        circlePath.stroke()
        circlePath.fill()
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero)
        
        UIGraphicsEndImageContext()
        
        return thumbImage
    }
}
