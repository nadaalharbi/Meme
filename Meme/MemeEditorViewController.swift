import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.isEnabled = false // prevent user from sharing un-finished work
        setTextField(textField: topTextField, text: "TOP")
        setTextField(textField: bottomTextField, text: "BOTTOM")
        self.subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        //setTabBar(isHidden: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
 
    func setTextField(textField: UITextField, text: String) {
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP") || (textField.text == "BOTTOM")  {
           textField.text = ""
        }// end of if
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        //Show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        //Show keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        //Hide keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification){
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }// end of if
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
       if self.view.frame.origin.y != 0 {
           self.view.frame.origin.y = 0
       }// end of if
    }
    
    func getKeyboardHeight(_ notification: Notification)->CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        // Check if image has been edited
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imagePickerView.image = image
            actionButton.isEnabled = true
        }// end of if
            
        // Check if image hasn't been edited
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            actionButton.isEnabled = true
        }// end of if
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        chooseSourceType(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        chooseSourceType(sourceType: .camera)
    }
    
    func chooseSourceType(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        // Re-set
        actionButton.isEnabled = false
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
   func generateMemedImage() -> UIImage {
        setToolbar(hidden: true)
    
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    
        setToolbar(hidden: false)
    
        return memedImage
    }
    
    func setToolbar(hidden: Bool){
        self.topToolbar.isHidden = hidden
        self.bottomToolbar.isHidden = hidden
    }
    
    @IBAction func shareMeme() {
        let memedImage: UIImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage] , applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
        shareController.completionWithItemsHandler = {(shareController, completed, items, error) in
            if completed {
                let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imagePickerView.image!, memedImage: memedImage)
                // Add it to the memes array in the Application Delegate
    
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.memes.append(meme)
                
                self.dismiss(animated: true, completion: nil)
            }// end of if
        }//end of handler
    }
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor:UIColor.white,
        .font: UIFont(name: "impact", size: 40)!,
        .strokeWidth: -4.0
    ]
    
    func setTabBar(isHidden: Bool){
           self.tabBarController?.tabBar.isHidden = isHidden
       }
  
}
