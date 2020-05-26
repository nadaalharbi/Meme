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
        actionButton.isEnabled = false // To prevent user from sharing un-finished work
        // Set initial text fields by calling declared method setTextField
        setTextField(textField: topTextField, text: "TOP")
        setTextField(textField: bottomTextField, text: "BOTTOM")
        self.subscribeToKeyboardNotifications()
        
        // MARK: check if device have camera or not to enable it.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }// end of viewDidLoad()
    
    override func viewWillAppear(_ animated: Bool) {
        self.subscribeToKeyboardNotifications()// calling
    }// end of viewWillAppear()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }// end of viewWillDisappear()
    
//    // MARK: Meme struct to set properties
//    struct Meme {
//        var topText: String // String representing the top text
//        var bottomText: String// String representing the bottom text
//        var originalImage: UIImage
//        var memedImage: UIImage
//    }// end of Meme struct
//    
    func setTextField(textField: UITextField, text: String) {
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes// Setting the defaultTextAttributes property
        textField.textAlignment = .center
    }// end of setTextField()

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP") || (textField.text == "BOTTOM")  {
           textField.text = ""
        }// end of if
    }// end of textFieldDidBeginEditing()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }// end of textFieldShouldReturn
    
    func subscribeToKeyboardNotifications() {
        //Show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }// end of subscribeToKeyboardNotifications()
    
    func unsubscribeFromKeyboardNotifications(){
        //Show keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        //Hide keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }// end of unsubscribeFromKeyboardNotifications()

    @objc func keyboardWillShow(_ notification: Notification){
        if bottomTextField.isEditing {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }// end of if
    }// end of keyboardWillShow()
    
    @objc func keyboardWillHide(_ notification: Notification){
       if self.view.frame.origin.y != 0 {
           self.view.frame.origin.y = 0
       }// end of if
    }// end of keyboardWillHide()
    
    func getKeyboardHeight(_ notification: Notification)->CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }// end of getKeyboardHeight()
    
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
        dismiss(animated: true, completion: nil) // dissmiss when finish assigning
    }// end of imagePickerController()
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        print("pickAnImageFromAlbum: Button picked")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
       // imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }// end of pickAnImage()
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }// end of pickAnImageFromCamera()
    
    @IBAction func cancelMeme(_ sender: Any) {
        // Re-set
        actionButton.isEnabled = false // disable sharing or saving un-finished work
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }// end of cancel()
    
   func generateMemedImage() -> UIImage {
        setToolbar(hidden: true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        setToolbar(hidden: false)
        return memedImage
    }// end of generateMemedImage()
    
    func setToolbar(hidden: Bool){
        self.topToolbar.isHidden = hidden
        self.bottomToolbar.isHidden = hidden
    }// end of setToolbar()
    
    @IBAction func shareMeme() {
        let memedImage: UIImage = generateMemedImage()// create the Meme
        let imageToShare = [ memedImage ]
        let shareController = UIActivityViewController(activityItems: imageToShare , applicationActivities: nil)
        self.present(shareController, animated: true, completion: nil)

        
        shareController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed:
        Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                _ = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imagePickerView.image!, memedImage: memedImage)
            }// end of if
        }//end of handler
     //dismiss(animated: true, completion: nil)
    }// end of save()
    
    // Setting memeTextAttributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor:UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -2
    ]
   
//    func save(memedImage: UIImage) {
//    // Create the meme
//    let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imagePickerView.image!, memedImage: memedImage)
//    }// end of save()
//    
    
}// end of class
