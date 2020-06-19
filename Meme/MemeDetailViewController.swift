import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    @IBOutlet weak var imageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.imageView!.image = self.meme.memedImage
        setTabBar(isHidden: true)
    }
       
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           setTabBar(isHidden: false)
    }
    
    func setTabBar(isHidden: Bool){
        self.tabBarController?.tabBar.isHidden = isHidden
    }
    
}
