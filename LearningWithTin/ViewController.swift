//
//  ViewController.swift
//  LearningWithTin
//
//  Created by Huy on 10/1/25.
//

import UIKit
import Alamofire
class JokeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRandomJoke()
    }

    private func fetchRandomJoke() {
        let url = "https://official-joke-api.appspot.com/random_joke"
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let data):
                print("Raw JSON response: \(data)")
                
                // Parse dữ liệu nếu cần
                if let joke = data as? [String: Any],
                   let setup = joke["setup"] as? String,
                   let punchline = joke["punchline"] as? String {
                    print("Joke: \(setup) - \(punchline)")
                }
                
            case .failure(let error):
                print("Failed to fetch joke: \(error.localizedDescription)")
            }
        }
    }
}

