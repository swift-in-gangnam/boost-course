//
//  ImageListViewController.swift
//  MyAlbum
//
//  Created by Jinyoung Kim on 2021/09/17.
//

import UIKit
import Photos

class ImageListViewController: UIViewController {
    
    enum ViewMode {
        case select, view
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chooseModeButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    private let cellIdentifier: String = "ImageCollectionViewCell"
    private let imageManger: PHCachingImageManager = PHCachingImageManager()
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    
    private var isImageNewestFirst: Bool = true
    private var titleTemp: String!
    var assetFetchResult: PHFetchResult<PHAsset>!
    
    private var viewMode: ViewMode = .view {
        didSet {
            switch viewMode {
            case .view:
                setButtonsViewMode(.view)
            case .select:
                setButtonsViewMode(.select)
            }
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.shared().register(self)
        
        self.sortButton.title = "최신순"
        self.titleTemp = self.navigationController?.navigationItem.title
        
        setCollectionView()
        setButtonsViewMode(.view)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK: - IBAcgtion Funcs
    @IBAction func sortImage(_ sender: Any) {
        if self.isImageNewestFirst {
            self.sortButton.title = "과거순"
        } else {
            self.sortButton.title = "최신순"
        }
        self.isImageNewestFirst = !self.isImageNewestFirst
        self.collectionView.reloadData()
    }
    
    @IBAction func chooseMode(_ sender: Any) {
        switch self.viewMode {
        case .view:
            self.viewMode = .select
        case .select:
            self.viewMode = .view
        }
    }
    
    @IBAction func trashSelectedImages(_ sender: Any) {
        guard let indexPaths = self.collectionView.indexPathsForSelectedItems else {
            return
        }
        var assetsToDelete: [PHAsset] = []
        for indexPath in indexPaths {
            let index = getIndex(indexPath: indexPath)
            assetsToDelete.append(self.assetFetchResult.object(at: index))
        }
        
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSFastEnumeration)
        } completionHandler: { (_, _) in
            OperationQueue.main.addOperation {
                self.viewMode = .view
            }
        }
    }
    
    @IBAction func actionPopUp(_ sender: Any) {
        var imagesToShare: [UIImage] = []
        guard let indexPaths = self.collectionView.indexPathsForSelectedItems else {
            return
        }
        for indexPath in indexPaths {
            let index = getIndex(indexPath: indexPath)
            let asset = assetFetchResult.object(at: index)
            imageManger.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: nil) { (image, _) in
                if let image = image {
                    imagesToShare.append(image)
                }
            }
        }
        let activityViewController = UIActivityViewController(activityItems: imagesToShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - Private Funcs
extension ImageListViewController {
    private func setButtonsViewMode(_ viewMode: ViewMode) {
        switch viewMode {
        case .view:
            self.title = self.titleTemp
            self.chooseModeButton.title = "선택"
            self.actionButton.isEnabled = false
            self.sortButton.isEnabled = true
            self.trashButton.isEnabled = false
            
            guard let indexPaths = self.collectionView.indexPathsForSelectedItems else {
                return
            }
            
            for indexPath in indexPaths {
                self.collectionView.deselectItem(at: indexPath, animated: true)
                self.collectionView.cellForItem(at: indexPath)?.alpha = 1
            }
            
            self.collectionView.allowsMultipleSelection = false
        case .select:
            self.collectionView.allowsMultipleSelection = true
            
            self.title = "\(self.collectionView.indexPathsForSelectedItems?.count ?? 0)장 선택"
            self.chooseModeButton.title = "취소"
            self.actionButton.isEnabled = false
            self.sortButton.isEnabled = false
            self.trashButton.isEnabled = false
            
            guard let indexPaths = self.collectionView.indexPathsForSelectedItems else {
                return
            }

            if indexPaths.count > 0 {
                self.actionButton.isEnabled = true
                self.trashButton.isEnabled = true
            }
        }
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func getIndex(indexPath: IndexPath) -> Int {
        if self.isImageNewestFirst {
            return indexPath.item
        } else {
            return self.assetFetchResult.count-indexPath.item-1
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImageListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UICollectionViewDataSource
extension ImageListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetFetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImageCollectionViewCell else { fatalError("Unable to create collection view cell") }
        
        let index = getIndex(indexPath: indexPath)
        
        let asset: PHAsset = assetFetchResult.object(at: index)
        
        imageManger.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil) { (image, _) in
            cell.imageView.image = image
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ImageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.viewMode {
        case .view:
            guard let nextViewController = self.storyboard?.instantiateViewController(identifier: "ImageZoomViewController") as? ImageZoomViewController else { fatalError("Unable to create Image Zoom View Controller") }
            
            let index = getIndex(indexPath: indexPath)
            let asset = self.assetFetchResult.object(at: index)
            
            nextViewController.asset = asset
            
            let dateFormatter = DateFormatter()
            guard let date: Date = asset.creationDate else {
                return
            }

            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            dateFormatter.dateFormat = "YYYY-MM-dd"

            nextViewController.dateString = dateFormatter.string(from: date)

            dateFormatter.dateFormat = "a hh:mm:ss"

            nextViewController.timeString = dateFormatter.string(from: date)

            self.navigationController?.pushViewController(nextViewController, animated: true)
            
            self.collectionView.deselectItem(at: indexPath, animated: false)
        case .select:
            setButtonsViewMode(.select)
            self.collectionView.cellForItem(at: indexPath)?.alpha = 0.5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch self.viewMode {
        case .view:
            return
        case .select:
            setButtonsViewMode(.select)
            self.collectionView.cellForItem(at: indexPath)?.alpha = 1
        }
    }
}


// MARK: - PHPhotoLibraryChangeObserver
extension ImageListViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: assetFetchResult) else {
            return
        }
        
        assetFetchResult = changes.fetchResultAfterChanges
        
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
        }
    }
}
