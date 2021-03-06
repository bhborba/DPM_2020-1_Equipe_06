//
//  ImageViewController.swift
//  PyRelio
//
//  Created by Daniel dos Santos on 27/05/20.
//  Copyright © 2020 Daniel dos Santos. All rights reserved.
//

import UIKit
import CoreData

class ImageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var myImg: UIImageView!
    @IBOutlet weak var tf_nome: UITextField!
    @IBOutlet weak var tf_descricao: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.abrirCaptura();
    }
    
    @IBAction func cancelar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmar(_ sender: Any) {
        self.salvarRegistro()
    }
    
    func abrirCaptura() {
         let image = UIImagePickerController()

               image.delegate = self

        image.sourceType = UIImagePickerController.SourceType.camera

               image.allowsEditing = false

               

               self.present(image, animated: true){

                   

               }
    }
    
    //camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {

            myImg.image = image

        } else {

            //error

        }

        self.dismiss(animated: true, completion: nil)

    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        guard let image = info[.originalImage] as? UIImage else {
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
//        myImg.image = image;
//    }
//
//    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
//    }
    
    func salvarRegistro() {
        
        let r = Registro();
        r.nome = tf_nome.text;
        r.descricao = tf_descricao.text;
        ListImagesViewController.lista.append(r);
        
        let imageData = myImg.image!.pngData()
        let compresedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        
        r.imagem = compresedImage;
        
        self.persisteRegistro(nome: r.nome,descricao: r.descricao);
        
//        let alert = UIAlertController(title: "Ok", message: "Sua image foi salva", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
        
//        DispatchQueue.main.async {
//            self.dismiss(animated: true, completion: nil)
//        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcb = storyboard.instantiateViewController(withIdentifier: "ListaRegistros") as! UIViewController
        
        DispatchQueue.main.async {
            self.present(vcb, animated: true, completion: nil)
        }
    }
    
    func persisteRegistro(nome: String!, descricao: String!) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RegistroModel", in: context)
        let nnewEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        nnewEntity.setValue(nome, forKey: "nome")
        nnewEntity.setValue(descricao, forKey: "descricao")
        
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Failed")
        }
    }
    
    func loadRegistro() -> (String, String, String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RegistroModel")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                let nome = data.value(forKey: "nome") as! String
                let descricao = data.value(forKey: "descricao") as! String
                
                let r = Registro();
                r.nome = nome;
                r.descricao = descricao;
                ListImagesViewController.lista.append(r);
                
            }
        } catch {
            print("Failed")
        }
        return (nome: "", email: "", senha: "")
    }
    
}
