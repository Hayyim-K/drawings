//
//  ViewController.swift
//  drawings
//
//  Created by vitasiy on 17/07/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    private var lastPoint = CGPoint.zero
    private var red: CGFloat = 0.0
    private var green: CGFloat = 0.0
    private var blue: CGFloat = 0.0
    private var brushWidth: CGFloat = 10.0
    private var opacity: CGFloat = 1.0
    private var swiped = false
    
    private let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
    ]
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       swiped = false
        if let touch = touches.first{
            lastPoint = touch.location(in: tempImageView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: tempImageView)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        
        mainImageView.image?.draw(
            in: CGRect(x: 0,
                       y: 0,
                       width: mainImageView.frame.size.width,
                       height: mainImageView.frame.size.height),
            blendMode: .normal,
            alpha: 1.0
        )
        
        tempImageView.image?.draw(
            in: CGRect(x: 0,
                       y: 0,
                       width: tempImageView.frame.size.width,
                       height: tempImageView.frame.size.height),
            blendMode: .normal,
            alpha: opacity
        )
        
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempImageView.image = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingsViewController = segue.destination as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.brush = brushWidth
        settingsViewController.opacity = opacity
        settingsViewController.red = red * 255
        settingsViewController.green = green * 255
        settingsViewController.blue = blue * 255
    }
    
    private func drawLineFrom(_ point: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(tempImageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        tempImageView.image?.draw(
            in: CGRect(x: 0,
                       y: 0,
                       width: tempImageView.frame.size.width,
                       height: tempImageView.frame.size.height)
        )
        // 2
        context.move(to: point)
        context.addLine(to: toPoint)
        // 3
        context.setLineCap(.round)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context.setBlendMode(.normal)
        // 4
        context.strokePath()
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    private func share() {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.draw(
            in: CGRect(x: 0,
                       y: 0,
                       width: mainImageView.frame.size.width,
                       height: mainImageView.frame.size.height),
            blendMode: .normal,
            alpha: 1.0
        )
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image],
                                                applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func resetAction(_ sender: Any) {
        mainImageView.image = nil
    }
    
    @IBAction func saveAction(_ sender: Any) {
        share()
    }
    
    
    @IBAction func pencilPressed(_ sender: UIButton) {
        // 1
        var index = sender.tag
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        // 2
        (red, green, blue) = colors[index]
        
        // 3
        if index == colors.count - 1 {
            opacity = 1.0
        }
    }
}

extension ViewController: SettingsViewControllerDelegate {
    func settingsViewControllerFinished(settingsViewController: SettingsViewController) {
        brushWidth = settingsViewController.brush
        opacity = settingsViewController.opacity
        red = settingsViewController.red / 255
        green = settingsViewController.green / 255
        blue = settingsViewController.blue / 255
    }
}

