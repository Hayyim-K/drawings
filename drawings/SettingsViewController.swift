//
//  SettingsViewController.swift
//  drawings
//
//  Created by vitasiy on 17/07/2023.
//

import UIKit

protocol SettingsViewControllerDelegate {
  func settingsViewControllerFinished(settingsViewController: SettingsViewController)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var sliderBrush: UISlider!
    @IBOutlet weak var sliderOpacity: UISlider!
    
    @IBOutlet weak var redSlider: UISlider!
    
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var brushView: UIImageView!
    
    @IBOutlet weak var opacityView: UIImageView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var labelBrush: UILabel!
    @IBOutlet weak var labelOpacity: UILabel!
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var brush: CGFloat!
    var opacity: CGFloat!
    
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImages()
        setSliders()
        setRGBSliders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setImages()
        setSliders()
        setRGBSliders()
    }
    
    private func setRGBSliders() {
        redSlider.setValue(Float(red / 255), animated: true)
        redLabel.text = String(Int(red))
        greenSlider.setValue(Float(green / 255), animated: true)
        greenLabel.text = String(Int(green))
        blueSlider.setValue(Float(blue / 255), animated: true)
        blueLabel.text = String(Int(blue))
    }
    
    private func setImages() {
        brushView.backgroundColor = UIColor(red: red / 255,
                                            green: green / 255,
                                            blue: blue / 255,
                                            alpha: opacity)
        opacityView.backgroundColor = UIColor(red: red / 255,
                                              green: green / 255,
                                              blue: blue / 255,
                                              alpha: opacity)
        opacityView.layer.cornerRadius = opacityView.frame.width / 2
        let scale = CGFloat(sliderBrush.value)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        brushView.transform = transform
        opacityView.alpha = opacity
    }
    
    private func setSliders() {
        sliderBrush.setValue(Float(brush.native / 100), animated: true)
        sliderOpacity.setValue(Float(opacity.native), animated: true)
        labelBrush.text = String(format: "%.2f", brush.native)
        labelOpacity.text = String(format: "%.2f", opacity.native)
    }
    
    private func drawPreview() {
        UIGraphicsBeginImageContext(brushView.frame.size)
        guard var context = UIGraphicsGetCurrentContext() else { return }
        let c = 50
        context.setLineCap(.round)
        context.setLineWidth(200)
        context.setStrokeColor(red: red / 255,
                               green: green / 255,
                               blue: blue / 255,
                               alpha: 1.0)
        context.move(to: CGPoint(x: c, y: c))
        context.addLine(to: CGPoint(x: c, y: c))
        context.strokePath()
        
        brushView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(brushView.frame.size)
        context = UIGraphicsGetCurrentContext()!
        
        context.setLineCap(.round)
        context.setLineWidth(200)
        context.setStrokeColor(red: red / 255,
                               green: green / 255,
                               blue: blue / 255,
                               alpha: opacity)
        context.move(to: CGPoint(x: c, y: c))
        context.addLine(to: CGPoint(x: c, y: c))
        context.strokePath()
        opacityView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    
    @IBAction func close(_ sender: Any) {
        delegate?.settingsViewControllerFinished(settingsViewController: self)
        dismiss(animated: true)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        if sender == sliderBrush {
            brush = CGFloat(sender.value) * 100
            labelBrush.text = String(format: "%.2f", brush.native)
            let scale = CGFloat(sender.value)
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            brushView.transform = transform
        } else {
            opacity = CGFloat(sender.value)
            labelOpacity.text = String(format: "%.2f", opacity.native)
            opacityView.alpha = opacity
        }
        
        drawPreview()
    }
    
    @IBAction func colorChanged(_ sender: UISlider) {
        
        red = CGFloat(redSlider.value * 255)
        redLabel.text = String(Int(red))
        green = CGFloat(greenSlider.value * 255)
        greenLabel.text = String(Int(green))
        blue = CGFloat(blueSlider.value * 255)
        blueLabel.text = String(Int(blue))
         
        drawPreview()
    }
}


