//
//  ViewController.swift
//  FemmeHacks
//
//  Created by Sanjana Pruthi on 2/3/18.
//  Copyright © 2018 Sanjana Pruthi and Sruthi Sudhakar. All rights reserved.
//
import UIKit

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBAction func submitButton(_ sender: UIButton) {
        itemDisplay.text! = labele
       
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        UIApplication.shared.openURL( URL(string: ("https://www.google.com/search?q="+labele))!)
    }
    
    
    var labele = ""
    @IBOutlet weak var photoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImageButton(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController() // a view controller that lets a user pick media from their photo library
        
        imagePickerController.sourceType = .photoLibrary // only allow photos to be picked, not taken
        
        imagePickerController.delegate = self //make sure ViewController notified when user picks an image
        
        present(imagePickerController, animated: true, completion: nil) // once picked, it animates the image in and completion is nil becuase you dont call any method afterwards
    }
    
    @IBOutlet weak var itemDisplay: UILabel!
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //Dismiss the picker if the user cancelled
        
        dismiss(animated: true, completion: nil)
        
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //After selecting image, set it to the imageView in storyboard
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage! else {
            
            fatalError("Expected a dictionary containgin image but was provided the following: \(info)")
            
        }
        photoImageView.image = selectedImage
        clickMe()
        
        //dismiss the picker after image is set
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: Actions
    /*@IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        print("tap gesutre")
        
        let imagePickerController = UIImagePickerController() // a view controller that lets a user pick media from their photo library
        
        imagePickerController.sourceType = .photoLibrary // only allow photos to be picked, not taken
        
        imagePickerController.delegate = self //make sure ViewController notified when user picks an image
        
        present(imagePickerController, animated: true, completion: nil) // once picked, it animates the image in and completion is nil becuase you dont call any method afterwards
        
    }
    */
    func clickMe() {
        
       print("hello")
        
        var r  = URLRequest(url: URL(string: "https://main-presence-194115.appspot.com/upload_photo")!)
        r.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
       // r.setValue("application/json; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
       // r.setValue("application/json; boundary=\(boundary)", forHTTPHeaderField: "Accept")
        func createBody(parameters: [String: String],
                        boundary: String,
                        data: Data,
                        mimeType: String,
                        filename: String) -> Data {
            
            
            let body = NSMutableData()
            
            let boundaryPrefix = "--\(boundary)\r\n"
            
            for (key, value) in parameters {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimeType)\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
            body.appendString("--".appending(boundary.appending("--")))
            
            return body as Data
        }
        let params = [
            "file"  : "hello.jpg"
        ]
        
        r.httpBody = createBody(parameters: params,
                                boundary: boundary,
                                data: UIImageJPEGRepresentation(photoImageView.image!, 0.7)!,
                                mimeType: "image/jpg",
                                filename: "hello.jpg")
        let task = URLSession.shared.dataTask(with: r) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            var responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
           /* print (data)
            */
            for i in 0..<4{
                let j = responseString?.index(of: ":")
                responseString = responseString?.substring(from: j!)
                let k = responseString?.startIndex
                responseString?.remove(at: (k)!)
            }
            let next = responseString?.index(of: " ")
            responseString = responseString?.substring(from: next!)
            let k = responseString?.startIndex
            responseString?.remove(at: (k)!)
            let z = responseString?.index(of: " ")
            responseString = responseString?.substring(to: z!)
            print("hello")
            print("hello")
            print("hello")

            print (responseString!)
            self.labele=responseString!
            print("labele"+self.labele)
            //self.setImg()
            //labels.append(mySubstring)
                
            //}
            
            
          /*  do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let items = json["Label"] as? [[String: Any]] ?? []
                    print(items)
            } catch let error as NSError {
                print(error)
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let items = json!["Label Detection"] as? [[String: Any]] {
                    for item in items!{
                        tags.append(new (Tag(item["Label"], item["Score"]))
                    }
                }
                
            }catch{
                
                print("cry cry cry")
            }
            */

            
            
            
            
            
        }
        
       // itemDisplay.text! = labele
        task.resume()
        
        
        
        
    }
    
    func setImg()
    {
       // self.itemDisplay.text!=self.labele
    }
    
    
    

}
