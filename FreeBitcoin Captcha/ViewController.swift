//
//  ViewController.swift
//  FreeBitcoin Captcha
//
//  Created by Jorge Lopez Gil on 27/9/17.
//  Copyright © 2017 Jorge Lopez Gil. All rights reserved.
//

import UIKit
import WebKit
import UserNotifications

class ViewController: UIViewController {

    //Elementos Pantalla
    @IBOutlet var miWebKit: WKWebView!
    @IBOutlet var contador: UILabel!
    @IBOutlet var progresso: UIProgressView!
    
    //Variables
    let enlace = URLRequest(url: URL(string: "https://www.freebitco.in/?op=home")!)
    var tiempo = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        miWebKit.load(enlace)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Botones inferiores
        //Cancelar Web Carga
        @IBAction func CancelarWeb(_ sender: UIBarButtonItem) {
            print("Se ha cancelado cargar contenido")
            miWebKit.stopLoading()
        }
    
        //Abrir Web Externa
        @IBAction func AbrirWeb(_ sender: UIBarButtonItem) {
            print("Se va a proceder a abrir la Web")
        }
    
    
        //Recargar Web
        @IBAction func RecargarWeb(_ sender: UIBarButtonItem) {
            print("Recargando Web")
            miWebKit.reload()
        }
}

