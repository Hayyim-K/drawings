//
//  TextSettingsViewController.swift
//  drawings
//
//  Created by vitasiy on 27/07/2023.
//

import UIKit


class TextSettingsViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bIUButton: UIButton!
    @IBOutlet weak var textSizeSlider: UISlider!
    
    private var textSize: CGFloat = 22
    private var textFont = "Arial"
    private var textColore: UIColor = .black
    private var (isBold, isItalic, isUndeline) = (false, false, false)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparetion()
        setupKeyboardHiding()
        popUpButtonManager()
    }
    
    private func preparetion() {
        textField.set(isBold, isItalic, isUndeline, textFont, textSize)
        textSizeSlider.value = Float(textSize)
    }
    
    private func updateTextField() {
        
    }
    
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector:
                                                #selector (keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:
                                                #selector (keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        
        guard let userinfo = sender.userInfo,
              let keyboardFrame = userinfo[
                UIResponder.keyboardFrameEndUserInfoKey
              ] as? NSValue else { return }
        
        mainView.frame.origin.y = keyboardFrame.cgRectValue.origin.y - mainView.frame.height - 8
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        mainView.frame.origin.y = view.frame.height - mainView.frame.height
    }
    
    
    
    func popUpButtonManager() {
        // Pop-up button
        
        let styleClosure = { (action: UIAction) in
            print(action.title)
            if let actions = self.bIUButton.menu?.children as? [UIAction] {
                for userAction in actions {
                    if action == userAction {
                        userAction.state = userAction.state == .on ? .off : .on
                    }
                }
                
                if actions[0].state == .on {
                    self.isBold = true
                    self.textField.set(self.isBold, self.isItalic, self.isUndeline, self.textFont, self.textSize)
                    
                } else if actions[0].state == .off {
                    self.isBold = false
                    self.textField.set(self.isBold, self.isItalic, self.isUndeline, self.textFont, self.textSize)
                }
                
                if actions[1].state == .on {
                    self.isItalic = true
                    self.textField.set(self.isBold, self.isItalic, self.isUndeline, self.textFont, self.textSize)
                } else if actions[1].state == .off {
                    self.isItalic = false
                    self.textField.set(self.isBold, self.isItalic, self.isUndeline, self.textFont, self.textSize)
                }
                
                if actions[2].state == .on {
                    self.isUndeline = true
                    self.textField.set(self.isBold, self.isItalic, self.isUndeline, self.textFont, self.textSize)
                } else if actions[2].state == .off {
                    self.isUndeline = false
                    self.textField.set(self.isBold, self.isItalic, self.isUndeline, self.textFont, self.textSize)
                }
                
            }
        }
        
        bIUButton.menu = UIMenu(children: [
            UIAction(title: "Bold", handler: styleClosure),
            UIAction(title: "Italics", handler: styleClosure),
            UIAction(title: "Underline", handler: styleClosure)
        ])
        
    }
    
    
    @IBAction func fontChoosing(_ sender: Any) {
        showFontPicker(textField!)
        if let currentFont = textField.font?.fontName {
            textFont = currentFont
        }
        
    }
    
    
    @IBAction func sliderHasTouched(_ sender: Any) {
        textSize = CGFloat(textSizeSlider.value)
        textField.textColor = textColore
        textField.set(isBold, isItalic, isUndeline, textFont, textSize)
    }
    
    @IBAction func addText(_ sender: Any) {
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension TextSettingsViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TextSettingsViewController: UIFontPickerViewControllerDelegate {
    
    func showFontPicker(_ sender: Any) {
        let fontConfig = UIFontPickerViewController.Configuration()
        fontConfig.includeFaces = false
        let fontPicker = UIFontPickerViewController(configuration: fontConfig)
        fontPicker.delegate = self
        present(fontPicker, animated: true, completion: nil)
    }
    
    func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
        
    }
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        guard let descriptor = viewController.selectedFontDescriptor else { return }
        let font = UIFont(descriptor: descriptor, size: textSize)
        textFont = font.fontName
        textField.font = UIFont(name: textFont, size: textSize)
    }
}

