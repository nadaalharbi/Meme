import UIKit

class MemeCollectionViewController: UICollectionViewController  {
    
    @IBOutlet weak var memeCollectionView: UICollectionView!
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeCollectionView.dataSource = self
        memeCollectionView.delegate = self

        let space: CGFloat = 1.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        flowLayout?.minimumLineSpacing = space
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
        flowLayout?.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView!.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        // Set the image of meme
        cell.memeImageView?.image = meme.memedImage

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController

        detailController.meme = memes[(indexPath as NSIndexPath).row]
        self.tabBarController?.tabBar.isHidden = true
        navigationController!.pushViewController(detailController, animated: true)
    }


}
