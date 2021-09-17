//
//  AlbumListViewController.swift
//  MyAlbum
//
//  Created by Jinyoung Kim on 2021/09/17.
//

import UIKit
import Photos

class AlbumListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var assetFetchResults: [PHFetchResult<PHAsset>] = []
    private var assetCollections: [PHAssetCollection] = []
    
    private let imageManger: PHCachingImageManager = PHCachingImageManager()
    private let cellIdentifier: String = "AlbumCollectionViewCell"
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "앨범"
        
        setCollectionView()
        
        PHPhotoLibrary.shared().register(self)
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("접근 허가됨")
            self.requestCollections()
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    print("사용자가 허용함")
                    self.requestCollections()
                case .denied:
                    print("사용자가 불허함")
                default:
                    break
                }
            }
        case .restricted:
            print("접근 제한")
        case .limited:
            print("일부 접근 제한")
        @unknown default:
            fatalError()
        }
        self.collectionView.reloadData()
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController: ImageListViewController = segue.destination as? ImageListViewController else {
            return
        }
        guard let cell: AlbumCollectionViewCell = sender as? AlbumCollectionViewCell else {
            return
        }
        guard let indexPath = self.collectionView.indexPath(for: cell) else {
            return
        }
        
        nextViewController.assetFetchResult = self.assetFetchResults[indexPath.item]
        nextViewController.navigationController?.navigationItem.title = self.assetCollections[indexPath.item].localizedTitle
    }
}

// MARK: - Private Funcs
extension AlbumListViewController {
    
    private func requestCollections() {
        assetFetchResults.removeAll()
        assetCollections.removeAll()
        
        let fetchResult: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        fetchResult.enumerateObjects { (collection, count, stop) in
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            self.assetFetchResults.append(fetchResult)
            self.assetCollections.append(collection)
        }
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AlbumListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 1.3)
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
extension AlbumListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetFetchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: AlbumCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlbumCollectionViewCell else { fatalError("Unable to create collection view cell") }
        let fetchResult: PHFetchResult<PHAsset> = self.assetFetchResults[indexPath.item]
        
        if fetchResult.count != 0 {
            let asset: PHAsset = fetchResult.firstObject!
            
            imageManger.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil) { (image, _) in
                cell.imageView.image = image
            }
        } else {
            cell.imageView.image = nil
        }
        cell.countLabel.text = String(fetchResult.count)
        cell.nameLabel.text = self.assetCollections[indexPath.item].localizedTitle
        
        return cell
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension AlbumListViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        for i in 0..<self.assetFetchResults.count {
            if let changes = changeInstance.changeDetails(for: assetFetchResults[i]) {
                assetFetchResults[i] = changes.fetchResultAfterChanges
            }
        }
        
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
        }
    }
}
