//
//  PencilKitViewController.swift
//  drawings
//
//  Created by vitasiy on 19/07/2023.
//

import UIKit
import PencilKit
import Photos

class PencilKitViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

    @IBOutlet weak var canvasView: PKCanvasView!
    
    var toolPicker: PKToolPicker!
    var drawing = PKDrawing()
    
    private var textField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = canvasView.bounds.size
        let att = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50.0)]
        let image = UIGraphicsImageRenderer(size: size, format: UIGraphicsImageRendererFormat()).image { rendererContext in
            "HELLO!!!".draw(in: canvasView.bounds, withAttributes: att)
        }
        canvasView.addSubview(UIImageView(image: image))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        canvasView.delegate = self
        canvasView.drawing = drawing
        
        canvasView.alwaysBounceVertical = true
        canvasView.drawingPolicy = .anyInput
        
        toolPicker = PKToolPicker()
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.showsDrawingPolicyControls = true
        
        toolPicker.addObserver(canvasView)
        toolPicker.addObserver(self)
        
        canvasView.becomeFirstResponder()
    }
    
    private func prepareImage() -> UIImage? {
        UIGraphicsBeginImageContext(canvasView.bounds.size)
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    @IBAction func inputText(_ sender: Any) {
        showTextSettings()
        
//        textField?.delegate = self
//        textField = UITextField(frame: CGRect(x: canvasView.bounds.width / 2, y: canvasView.bounds.height / 2, width: canvasView.bounds.width * 0.8, height: canvasView.bounds.height * 0.08))
//
//        guard let textField = textField else { return }
//        textField.center = canvasView.center
//        textField.backgroundColor = .black
//        textField.textColor = .white
//        textField.placeholder = "HELLO..."
//        canvasView.addSubview(textField)
    }
    
    @IBAction func shareDrawing(_ sender: Any) {
        guard let image = prepareImage() else { return }
        let activity = UIActivityViewController(activityItems: [image],
                                                applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func saveDrawingToCameraRoll(_ sender: Any) {
        let image = prepareImage()
        if let image = image {
            // added "Privacy - Photo Library Usage Description" row to the info.plist to access to the camera
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
    }
}

extension PencilKitViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PencilKitViewController {
    private func showTextSettings() {
        let textSetVC = self.storyboard?.instantiateViewController(withIdentifier: "TextSettingsViewController") as! TextSettingsViewController
//        textSetVC.delegate = self
        textSetVC.modalPresentationStyle = .overCurrentContext
        // следующие три строки кажется никак не влияют на итог... разобраться для чего они
        textSetVC.providesPresentationContextTransitionStyle = true
        textSetVC.definesPresentationContext = true
        textSetVC.modalTransitionStyle = .crossDissolve
        present(textSetVC, animated: true,  completion: nil)
    }
}


