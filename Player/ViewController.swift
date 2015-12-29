//
//  ViewController.swift
//  Player
//
//  Created by Jacinto Mena Lomeña on 29/12/15.
//  Copyright © 2015 Jacinto Mena Lomeña. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var cancion: UILabel!
    
    @IBOutlet weak var caratula: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var canciones : Array<Array<String>> = Array<Array<String>>()
    
    private var reproductor: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Se carga la información de las canciones que hay disponibles
        // Posiciones [nomnbreCancion,extension, titulo, nombrePortada, extension]
        canciones.append(["bisbalacort7seg", "mp3", "Waving Flag - K'naan feat Bisbal", "portadaBisbal", "jpg"])
        canciones.append(["03Amigos7seg", "mp3", "Amigos - Juanes", "portadaJuanes", "jpg"])
        canciones.append(["01APruebaDeTi7seg", "mp3", "A prueba de tí - Malu", "portadaMalu", "jpg"])
        canciones.append(["01Solamentetu7seg", "mp3", "Solamente tu - Pablo Alboran", "portadaAlboran", "jpg"])
        canciones.append(["05Addictedtoyou7seg", "mp3", "Addicted to you - Shakira", "portadaShakira", "jpg"])
        
        // Se deshabilitan los botones hasta que no se elija una cación
        self.playButton.enabled = false
        self.pauseButton.enabled = false
        self.stopButton.enabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return canciones.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return canciones[row][2]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Establecemos el nombre de la cación
        cancion.text = canciones[row][2]
        
        // Establecemos la portada
        let imagen : String = (canciones[row][3]) + "." + (canciones[row][4])
        self.caratula.image = UIImage(named: imagen)
        
        // Paramos el player en el caso de encontrarse funcionando
        if (reproductor != nil) {
            
            self.stop();
            
            // TODO: liberar el objeto
            reproductor = nil
        }
        
        // Cargamos el player con el nuevo reproductor para que el usuario haga play
        let url = NSBundle.mainBundle().URLForResource(canciones[row][0], withExtension: canciones[row][1])
        do {
            if (url != nil){
                reproductor = try AVAudioPlayer(contentsOfURL: url!)
            
                // Habilitamos el botón de play
                self.playButton.enabled = true
            }
        } catch {
            print("Error al cargar el fichero de sonido " + canciones[row][0] + "." + canciones[row][1])
        }
        
        // Iniciamos la reproducción
        self.play();
        
    }
    
    @IBAction func play() {
        if (!reproductor.playing) {
            reproductor.play()
        }
        stopButton.enabled = true
        pauseButton.enabled = true
        playButton.enabled = false
    }
    
    @IBAction func pause() {
        if (reproductor.playing) {
            reproductor.pause()
        }
        stopButton.enabled = true
        pauseButton.enabled = false
        playButton.enabled = true
    }
    
    @IBAction func stop() {

        reproductor.stop()
        reproductor.currentTime = 0.0
        stopButton.enabled = false
        pauseButton.enabled = false
        playButton.enabled = true
        
    }
    
    @IBAction func aleatorio() {
        let numero = random()
        let index : Int = numero % 5
        self.pickerView.selectRow(index, inComponent: 0, animated: true)
        self.pickerView(self.pickerView, didSelectRow: index, inComponent: 0)
    }
}

