//
//  filmDetailViewController.swift
//  Cinema
//
//  Created by Khaled on 16.04.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import UIKit
import WebKit



class filmDetailViewController: UIViewController {
    
    var validPhotos: [Int] = []
    var counter = 0
    var vidos: [VideoKey] = []
    var id: Int?
    var storeItem = StoreItemController()
    @IBOutlet weak var filmTitle: UILabel!
    @IBOutlet weak var filmDate: UILabel!
    @IBOutlet weak var voteAndPopularity: UILabel!
    @IBOutlet weak var genre2: UILabel!
    @IBOutlet weak var genre3: UILabel!
    @IBOutlet weak var genre1: UILabel!
    @IBOutlet weak var filmPoster: UIImageView!
    @IBOutlet weak var descrFilmTitle: UILabel!
    @IBOutlet weak var filmRunningTime: UILabel!
    @IBOutlet weak var filmDirector: UILabel!
    @IBOutlet weak var filmWriter: UILabel!
    @IBOutlet weak var filmSoundDirector: UILabel!
    @IBOutlet weak var filmDescription: UILabel!
    @IBOutlet weak var firstActor: UIImageView!
    @IBOutlet weak var secondActor: UIImageView!
    @IBOutlet weak var thirdActor: UIImageView!
    @IBOutlet weak var firstActorName: UILabel!
    @IBOutlet weak var secondActorName: UILabel!
    @IBOutlet weak var thirdActorName: UILabel!
    @IBOutlet weak var starButton: UIButton!
    var poster = ""
    var popularity: Double = 1
    var cast: [CastMembers] = []
    var filmImage: UIImage?
    var filmName = ""
    var manipulation = Manipulation()
    @IBOutlet weak var filmOverview: UIView!
    let query = [
        "api_key": "1fc2dab4bce286017391d10ae5a2a0df",
        "language": "en-US"
    ]
    @IBOutlet weak var videoWebView: WKWebView!
    @IBOutlet weak var videoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if manipulation.find(id: id!){
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        fetchVideo()
        fetchFilmDetails()
        firstActorName.text = "Fionn Whitehead"
        secondActorName.text = "Tom Hardy"
        thirdActorName.text = "Aneuring Barnard"
        fetchCrewMembers()
    }
    
    
    
    @IBAction func starTapped(_ sender: Any) {
        if !manipulation.find(id: id!){
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            manipulation.save(id: id!, overview: descrFilmTitle.text!, popularity: Double(popularity), posterPath: poster, title: filmTitle.text!, type: "Favourite")
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            manipulation.delete(id: id!)
        }
    }
    
    
    func fetchFilmDetails(){
        storeItem.fetchFilmDetails(id: id!, matching: query) { (film) in
            if let film = film{
                DispatchQueue.main.async {
                    self.filmName = film.title
                    
                    print(film.genres[0].name)
                    self.filmTitle.text = film.title
                    self.filmDate.text = "(\(film.releaseDate))"
                    if(film.genres.count == 2){
                        print("kuda")
                        self.genre1.text = film.genres[0].name
                        self.genre2.text = film.genres[1].name
                        self.genre3.text = ""
                        
                        let maxSize = CGSize(width: 1, height: 14.5)
                        let size = self.genre3.sizeThatFits(maxSize)
                        self.genre3.frame = CGRect(origin: CGPoint(x: 255.5, y: 0), size: size)
                    } else {
                        self.genre1.text = film.genres[0].name
                        self.genre2.text = film.genres[1].name
                        self.genre3.text = film.genres[2].name
                    }
                    
                    self.voteAndPopularity.text = "\(film.votes) / 10 (\(Double(round(10*film.popularity)/10)))"
                    self.descrFilmTitle.text = film.title
                    
                    self.popularity = film.popularity
                    
                    self.poster = film.posterPath ?? ""
                    
                    if let img = film.posterPath{
                        
                        self.storeItem.fetchImage(url: img) { (image) in
                            if let image = image{
                                DispatchQueue.main.async {
                                    self.filmPoster.image = image
                                    self.filmImage = image
                                }
                            }
                            
                        }
                    }
                    
                    
                    
                    self.filmRunningTime.text = "\(Int(film.runtime/60))h \(film.runtime%60)m"
                    self.filmDescription.text = film.description
                    
                }
            }
        }
    }
    
    func fetchCrewMembers() {
        storeItem.fetchCrewAndCast(id: id!, matching: query) { (cast) in
            if let cast = cast{
                DispatchQueue.main.async {
                    self.cast = cast.cast
                    for i in cast.crew{
                        if(i.job == "Director"){
                            self.filmDirector.text = i.name
                            break
                        }
                    }
                    
                    for i in cast.crew{
                        if(i.department == "Writing"){
                            self.filmWriter.text = i.name
                            break
                        }
                    }
                    for i in cast.crew{
                        if(i.job == "Original Music Composer"){
                            self.filmSoundDirector.text = i.name
                            break
                        }
                    }
                    
                        for i in 0...cast.cast.count{
                            //sdelat optional!!!!!!!!!!!!!!!!
                            if cast.cast[i].profilePath != nil{
                                self.validPhotos.append(i)
                                self.counter+=1
                            }
                            if (self.counter >= 3){
                                break
                            }
                        }
                    
                    self.storeItem.fetchImage(url: cast.cast[self.validPhotos[0]].profilePath!) { (image) in
                        DispatchQueue.main.async {
                            self.firstActor.layer.cornerRadius = 30
                            self.firstActor.image = image
                            
                        }
                    }
                    
                    self.storeItem.fetchImage(url: cast.cast[self.validPhotos[1]].profilePath!) { (image) in
                        DispatchQueue.main.async {
                            self.secondActor.layer.cornerRadius = 30
                            self.secondActor.image = image
                            
                        }
                    }
                    self.storeItem.fetchImage(url:cast.cast[self.validPhotos[2]].profilePath!) { (image) in
                            DispatchQueue.main.async {
                                self.thirdActor.layer.cornerRadius = 30
                                self.thirdActor.image = image
                                
                            }
                        }
                    self.firstActorName.text = cast.cast[self.validPhotos[0]].name
                    self.secondActorName.text = cast.cast[self.validPhotos[1]].name
                    self.thirdActorName.text = cast.cast[self.validPhotos[2]].name
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCrew"{
            let destin = segue.destination as? fullCrewTableViewController
                destin?.cast = self.cast
                destin?.nameOfTheFilm = self.filmName
            destin?.imageOfTheFilm = self.filmImage
            
        }
    }
    
    
    
    func fetchVideo(){
        storeItem.fetchVideo(id: id!, matching: query) { (video) in
            if let video = video{
                DispatchQueue.main.async {
                    self.vidos.append(contentsOf: video)
                    if !video.isEmpty{
                        self.playVideo(videoID: video[0].key)
                    }
                    
                }
            }
        }
    }
    
    func playVideo(videoID: String){
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?playsinline=1") else {
        return
        }
        
        videoWebView.configuration.allowsInlineMediaPlayback = true
        videoWebView.load(URLRequest(url: youtubeURL))
    }
}
