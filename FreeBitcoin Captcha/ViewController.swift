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
    @IBOutlet var btnIniciar: UIBarButtonItem!
    @IBOutlet var btnCancelar: UIBarButtonItem!
    
    //Elementos esteticos
    @IBOutlet var dsNavBar: UINavigationBar!
    @IBOutlet var dsViewContenedor: UIView!
    @IBOutlet var dsToolBar: UIToolbar!
    @IBOutlet var btnAbrirWeb: UIBarButtonItem!
    @IBOutlet var btnNocturno: UIBarButtonItem!
    
    //Variables
    let enlace = URLRequest(url: URL(string: "https://www.freebitco.in/?op=home")!)
    var totalTime = 3600
    let timeTotal = 3600
    var timer = Timer()
    var startTime = NSDate()
    var nocturno = true
    var currTime = 0
    
    //Al cargar pantaalla
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UNUserNotificationCenter.current().delegate = self
        miWebKit.load(enlace)
        setNocturno()
    }

    //Peligro NO TOCAR
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Cuenta atras
    func iniciarTime(){
        startTime = NSDate()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
        
        btnCancelar.isEnabled = true;
        btnIniciar.isEnabled = false;
    }
    
    @objc func update() {
        let elapsedTime = NSDate().timeIntervalSince(startTime as Date)
        currTime = totalTime - Int(elapsedTime)
        print("El curreTime es de ---->> ", currTime)
        //total time is an instance variable that is the total amount of time in seconds that you want
        let (m,s) = secondsToMinutesSeconds(seconds: currTime)
        contador.text = String("\(m):\(s)")
        establecerProgress(valor: currTime)
        if currTime <= 0 {
            //Tiempo agotado
            resetTiempo()
        } else {
            Notificar()
        }
    }
    
    //Cancelar Tiempo
    func cancelarTime(){
        resetTiempo()
        
        timer.invalidate()
        cancelarNotificacion()
        
        btnIniciar.isEnabled = true
        btnCancelar.isEnabled = false
    }
    
    //Cancela Notificacion pendiente
    func cancelarNotificacion(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    //Formato Minutos y Segundos
        func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
            return ((seconds % 3600) / 60, (seconds % 3600) % 60)
        }
    
    //Barra Progreso
    func establecerProgress(valor: Int){
        let resto = Float(Double(valor) * 1) / Float(totalTime)
        print("Progreso establecido a ", resto)
        progresso.progress = 1 - resto
    }
    
    //Reseteo tiempo
    func resetTiempo(){
        timer.invalidate()
        
        totalTime = timeTotal
        contador.text = "🔰:🔰"
        progresso.progress = 0.0
    }
    
    //Notificaciones
    func Notificar(){
        //Trigger Notificación
        let triggerN = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(currTime), repeats: false)
        
        //Contenido Notificación
        let contenidoN = UNMutableNotificationContent()
        contenidoN.title = NSLocalizedString("Titulo_Notif", comment: "Titulo Notificacion")
        contenidoN.body = NSLocalizedString("Body_Notif", comment: "Descripción de la notificacion")
        contenidoN.sound = UNNotificationSound.default()

        //Acciones
            //Recordar en 5 min
            let recordarme5Action = UNNotificationAction(identifier: "recordarme5Action", title: NSLocalizedString("AcRecor5Min", comment: "Recordar en 5 min"), options: [])
        
            //Cancelar Recordatorio
            let cancelarAction = UNNotificationAction(identifier: "cancelarAction", title: NSLocalizedString("AcCancelRec", comment: "Cancelar Recordatorio"), options: [])
            //Iniciar 1h
            let iniciarAction = UNNotificationAction(identifier: "iniciarAction", title: NSLocalizedString("AcIniciar1h", comment: "Avisar en 1 hora"), options: [])
        
        //Categoria
        let categoriaActions = UNNotificationCategory(identifier: "categoriasFreeBitcoin", actions: [recordarme5Action, iniciarAction, cancelarAction], intentIdentifiers: [], options: [])
        
            //Añadir Categoria a Centro de control iOS
            UNUserNotificationCenter.current().setNotificationCategories([categoriaActions])
        
            //Asignas Categoria a Notificación
            contenidoN.categoryIdentifier = "categoriasFreeBitcoin"
        
        //Request Notificación
        let requestN = UNNotificationRequest(identifier: "FreeBitcoin Captcha", content: contenidoN, trigger: triggerN)
        
        //Elimina notificaciones pendientes
        cancelarNotificacion()
        
        //Envia la notificacion
        UNUserNotificationCenter.current().add(requestN) {(error) in
            if let error = error {
                print("Se ha producido un error: \(error)")
            }
        }
    }
    
    //Acciones Rápidas Notificaciones
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive reponse: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        miWebKit.reload()
        
        //Recordar en 5 minutos
        if reponse.actionIdentifier == "recordarme5Action" {
            totalTime = 300
            iniciarTime()
        }
        
        //Recordar en 1hora
        if reponse.actionIdentifier == "iniciarAction" {
            totalTime = timeTotal
            iniciarTime()
        }
        
        //Cancelar
        if reponse.actionIdentifier == "cancelarAction" {
            cancelarTime()
        }
        
    }

    
        //Mostrar notificacion incluso dentro de la app
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .sound])
        }
    
    //Botones superiores
    @IBAction func avanzarTime(_ sender: UIBarButtonItem) {
        print("Moviendo tiempo inicial a ",startTime)
        startTime = startTime.addingTimeInterval(-60)
    }
    @IBAction func retrocederTime(_ sender: UIBarButtonItem) {
        print("Moviendo tiempo inicial a ",startTime)
        if currTime > 3540 {
            cancelarTime()
            iniciarTime()
        } else {
            startTime = startTime.addingTimeInterval(60)
        }
    }
    
    //Botones inferiores
        //Inicia Cuenta Atras
        @IBAction func IniciarCuenta(_ sender: UIBarButtonItem) {
            print("Se procede a iniciar a cuenta atras")
            iniciarTime()
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
            cancelarTime()
        }
    
    //Estetica DISEÑO
    @IBAction func alterModoNoche(_ sender: UIBarButtonItem) {
        if nocturno {
            nocturno = false
        } else {
            nocturno = true
        }
        
        setNocturno()
    }
    
    func setNocturno(){
        
        if nocturno {
            dsViewContenedor.backgroundColor = .black
            dsNavBar.barStyle = .black
            dsToolBar.barStyle = .black
            contador.textColor = .white
            btnAbrirWeb.tintColor = .white
            btnNocturno.tintColor = .white
            UIApplication.shared.statusBarStyle = .lightContent
            
            btnNocturno.title = NSLocalizedString("BtnNoche", comment: "Texto Modo Noche")
        } else {
            dsViewContenedor.backgroundColor = .white
            dsNavBar.barStyle = .default
            dsToolBar.barStyle = .default
            contador.textColor = .black
            btnAbrirWeb.tintColor = .black
            btnNocturno.tintColor = .black
            UIApplication.shared.statusBarStyle = .default
            
            btnNocturno.title = NSLocalizedString("BtnDia", comment: "Texto Modo Dia")
        }
        
    }
}
