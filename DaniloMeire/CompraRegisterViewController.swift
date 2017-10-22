	//
//  CompraRegisterViewController.swift
//  DaniloMeire
//
//  Created by macos on 08/10/17.
//  Copyright © 2017 fiap. All rights reserved.
//

import UIKit
import CoreData

class CompraRegisterViewController: UIViewController {

    
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var ivFoto: UIImageView!
    @IBOutlet weak var tfValor: UITextField!
    @IBOutlet weak var btAddEstado: UIButton!
    @IBOutlet weak var swCartao: UISwitch!
    @IBOutlet weak var btAddFoto: UIButton!
    @IBOutlet weak var btCadastrar: UIButton!
    @IBOutlet weak var tfEstado: UITextField!
    
    var compra: Compra!
    var smallImage: UIImage!
    var pickerView: UIPickerView!
    
    var estadoSelecionado: Estado!
    var listEstados: [Estado]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if compra != nil {
            self.title = "Atualizar Produto"
            tfNome.text = compra.nome
            swCartao.isOn = compra.cartao
            tfValor.text = "\(compra.preco)"
            tfEstado.text = compra.estado?.nome
            estadoSelecionado = compra.estado
            if let image = compra.imagem as? UIImage {
                ivFoto.image = image
                btAddFoto.isHidden = true
            }
            btCadastrar.setTitle("Atualizar", for: .normal)
        }
        
        pickerView = UIPickerView() //Instanciando o UIPickerView
        pickerView.backgroundColor = .white
        pickerView.delegate = self  //Definindo seu delegate
        pickerView.dataSource = self  //Definindo seu dataSource

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        //O botão abaixo servirá para o usuário cancelar a escolha de gênero, chamando o método cancel
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //O botão done confirmará a escolha do usuário, chamando o método done.
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        
        
        //Aqui definimos que o pickerView será usado como entrada do extField
        tfEstado.inputView = pickerView
        
        //Definindo a toolbar como view de apoio do textField (view que fica acima do teclado)
        tfEstado.inputAccessoryView = toolbar
        
    }
    
    func loadEstado() {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Estado", in: self.context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.context.fetch(fetchRequest)
            for element  in result {
                let estado = element as! Estado
                listEstados.append(estado)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func cancel() {
        tfEstado.resignFirstResponder()
    }
    
    //O método done irá atribuir ao textField a escolhe feita no pickerView
    func done() {
        if (listEstados.count > 0) {
            estadoSelecionado = listEstados[pickerView.selectedRow(inComponent: 0)]
            tfEstado.text = listEstados[pickerView.selectedRow(inComponent: 0)].nome
        }
        cancel()
    }
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: UIButton?) {
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addFoto(_ sender: UIButton) {

        let alert = UIAlertController(title: "Selecionar Foto", message: "De onde você quer escolher a foto?", preferredStyle: .actionSheet)
        
        //Verificamos se o device possui câmera. Se sim, adicionamos a devida UIAlertAction
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        //As UIAlertActions de Biblioteca de fotos e Álbum de fotos também são criadas e adicionadas
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func addUpdateCompra(_ sender: UIButton) {
        
        if compra == nil {
            compra = Compra(context: context)
        }
        if !validaCampo(campo: tfNome, nomeCampo: "Nome do Produto") {
            return
        } else {
            compra.nome = tfNome.text!
        }
        
        if !validaCampo(campo: tfValor, nomeCampo: "Valor do Produto") {
            return
        } else {
            compra.preco = Double(tfValor.text!)!
        }
        compra.cartao = swCartao.isOn
        
        if !validaCampo(campo: tfEstado, nomeCampo: "Estado da Compra") {
            return
        } else {
            compra.estado = estadoSelecionado
        }

        if smallImage != nil {
            compra.imagem = smallImage
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        
        close(nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }

}

extension CompraRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivFoto.image = smallImage
        
        btAddFoto.isHidden = true
        dismiss(animated: true, completion: nil)
    }
}

extension CompraRegisterViewController: UIPickerViewDelegate {
    override func viewWillAppear(_ animated: Bool) {
        loadEstado()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Retornando o texto recuperado do objeto dataSource, baseado na linha selecionada
        return listEstados[row].nome
    }
}

extension CompraRegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    //Usaremos apenas 1 coluna (component) em nosso pickerView
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listEstados.count //O total de linhas será o total de itens em nosso dataSource
    }
}


