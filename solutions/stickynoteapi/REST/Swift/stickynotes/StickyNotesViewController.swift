// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

let kHostAddress = "localhost"
let kHostPort = 8080

class StickyNotesViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var imageView: UIImageView?
  @IBOutlet weak var textField: UITextField?
  var request: URLRequest?
  var task: URLSessionDataTask?

  func textFieldDidEndEditing(_ textField: UITextField) {

    let urlComponents = NSURLComponents()
    urlComponents.scheme = "http";
    urlComponents.host = kHostAddress;
    urlComponents.port = kHostPort;
    urlComponents.path = "/stickynote";

    let messageQuery = URLQueryItem(name: "message", value: textField.text)
    urlComponents.queryItems = [messageQuery]

    self.request = URLRequest(url:urlComponents.url!)

    let session = URLSession.shared()
    self.task = session.dataTask(with: self.request!, completionHandler: {data, response, error in
      if data == nil {
        DispatchQueue.main.async(execute: {
          self.imageView!.backgroundColor = UIColor.red()
          self.imageView!.image = nil
        })
      } else {
        let image = UIImage.init(data:data!)
        DispatchQueue.main.async(execute: {
          self.imageView!.backgroundColor = UIColor.gray()
          self.imageView!.image = image
        })
      }
    })
    self.task!.resume()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .lightContent
  }
  
}

