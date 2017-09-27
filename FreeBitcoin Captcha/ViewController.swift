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

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

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
        UNUserNotificationCenter.current().delegate = self
        miWebKit.load(enlace)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Notificaciones
    func Notificar(){
        //Trigger Notificación
        let triggerN = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        
        //Contenido Notificación
        let contenidoN = UNMutableNotificationContent()
        contenidoN.title = "Añade Bitcoins 💰"
        contenidoN.body = "Ya ha pasado más de 1⌚️Hora, vuelve para ganarte unos 🤑 Bitcoins 🤑"
        contenidoN.sound = UNNotificationSound.default()
        
        //Request Notificación
        let requestN = UNNotificationRequest(identifier: "FreeBitcoin Captcha", content: contenidoN, trigger: triggerN)
        
        //Elimina notificaciones pendientes
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        //Envia la notificacion
        UNUserNotificationCenter.current().add(requestN) {(error) in
            if let error = error {
                print("Se ha producido un error: \(error)")
            }
        }
        
        contador.text = "30:00"
        progresso.progress = 0.5
        
    }
    
        //Mostrar notificacion incluso dentro de la app
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .sound])
        }

    //Botones inferiores
        //Inicia Cuenta Atras
        @IBAction func IniciarCuenta(_ sender: UIBarButtonItem) {
            print("Se procede a iniciar a cuenta atras")
            Notificar()
        }
    
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
    
        //Cancela Cuenta Atras
        @IBAction func CancelarCuenta(_ sender: UIBarButtonItem) {
            print("Se procede a cancelar la cuenta atras")
        }
}

