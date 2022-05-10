//
//  ViewController.swift
//  prac(collecView)
//
//  Created by Cepl on 27/04/22.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

struct Hero: Decodable {
    
    let img: String
  
}

class ViewController: UIViewController, UICollectionViewDataSource {

    var heros = [Hero]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
       
        let url = URL(string: "https://api.opendota.com/api/herostats")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do {
                self.heros =  try JSONDecoder().decode([Hero].self, from: data!)
                }catch{
                    print("Parse Error")
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }.resume()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heros.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 0{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
       
        
        let defaultLink = "https://api.opendota.com"
        let completeLink = defaultLink + heros[indexPath.row].img
        cell.imageView.downloaded(from: completeLink)
        
        /***if indexPath.row % 2 == 0   {
        cell.imageView.clipsToBounds = false
        cell.imageView.layer.cornerRadius = cell.imageView.frame.width / 20
        }***/
        cell.imageView.contentMode = .scaleAspectFill
        
        return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell2", for: indexPath) as! Custom2CollectionViewCell
            
           
            
            let defaultLink = "https://api.opendota.com"
            let completeLink = defaultLink + heros[indexPath.row].img
            cell.imageView2.downloaded(from: completeLink)
            
            
            cell.imageView2.layer.cornerRadius = cell.imageView2.frame.width / 2
            
            cell.imageView2.contentMode = .scaleAspectFill
            
            return cell
            
        }
            
            
    }
}

 

    




