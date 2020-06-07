import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    @IBOutlet weak var imageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.imageView!.image = self.meme.memedImage
        setTabBar(hidden: true)
    }
       
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           setTabBar(hidden: false)
    }
    
    func setTabBar(hidden: Bool){
        self.tabBarController?.tabBar.isHidden = hidden
    }
    
}
