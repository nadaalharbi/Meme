import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewdidload")
    }// end of viewDidLoad()
    
    
    @IBAction func pickImage() {
        print("tag: experiment1")
        // MARK: pick img from gallery and replase present with it.
        let nextController = UIImagePickerController()
        present(nextController, animated: true, completion: nil)//like navigationto next page
        
    }// end of experiment()
    
    @IBAction func saveImage(){
        // MARK: save image or share it or what ever you want.
         let image = UIImage()
         let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        
    }// end of saveImage()
    
    @IBAction func alert(){
        //MARK: alert message with choices
        let alertContoller = UIAlertController()
        alertContoller.title = "Test  Alert"
        alertContoller.message = "test the alert message!"
        
        //provide button to cancel, OK (Positive-Negative Button)
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
            
        }
        alertContoller.addAction(okAction)
        present(alertContoller, animated: true, completion: nil)// presnet it
        //dismiss(animated: true, completion: nil)// to dismiss the alert msg
    }// end of alert()
    
    
    
    @IBAction func next(_ sender: Any) {
        performSegue(withIdentifier: "nextBtn", sender: self)
    }
    
}// end of class
