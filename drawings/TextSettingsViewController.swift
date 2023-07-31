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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHiding()
    }
    

    
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector:
                                                #selector (keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:
                                                #selector (keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
//
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        
//         = 0

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
        
//        let colorClosure = { (action: UIAction) in
//            updateColor (action.title)
//            let button = UIButton (primaryAction: nil)
//            button.menu = UIMenu (children: [
//                UIAction (title: "Bondi Blue", handler: colorClosure),
//                UlAction (title: "Flower Power", handler: colorClosure)
//            ])
//            button.showsMenuAsPrimarvAction = true
//            [button. changesSelectionAsPrimarvAction = true
//             }
             }
             
             
             @IBAction func fontChoosing(_ sender: Any) {
                showFontPicker(textField!)
            }
             
             
             @IBAction func sliderHasTouched(_ sender: Any) {
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
                    fontConfig.includeFaces = true
                    let fontPicker = UIFontPickerViewController(configuration: fontConfig)
                    fontPicker.delegate = self
                    self.present(fontPicker, animated: true, completion: nil)
                }
            }
