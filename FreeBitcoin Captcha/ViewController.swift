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
    var totalTime = 18
    var timer = Timer()
    var startTime = NSDate()
    
    //Al cargar pantaalla
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UNUserNotificationCenter.current().delegate = self
        miWebKit.load(enlace)
    }

    //Peligro NO TOCAR
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Cuenta atras
    @objc func update() {
        let elapsedTime = NSDate().timeIntervalSince(startTime as Date)
        let currTime = totalTime - Int(elapsedTime)
        //total time is an instance variable that is the total amount of time in seconds that you want
        let (m,s) = secondsToMinutesSeconds(seconds: currTime)
        contador.text = String("\(m):\(s)")
        if currTime <= 0 {
            //Tiempo agotado
            resetTiempo()
        }
    }
    
    //Formato Minutos y Segundos
        func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
            return ((seconds % 3600) / 60, (seconds % 3600) % 60)
        }
    
    //Reseteo tiempo
    func resetTiempo(){
        timer.invalidate()
        
        contador.text = "🔰:🔰"
        progresso.progress = 0.0
    }
    
    //Notificaciones
    func Notificar(){
        //Trigger Notificación
        let triggerN = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(totalTime), repeats: false)
        
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
            
            startTime = NSDate()
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
            startTime = NSDate() // new instance variable that you would need to add.
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
            resetTiempo()
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
}
