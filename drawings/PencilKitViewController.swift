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


