//
//  APPImageLoader.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 22/6/23.
//

import Foundation

/// Este método se encarga de descargar imágenes desde una URL, almacenando en caché los datos de imagen en memoria para un acceso más rápido en futuras solicitudes.

/// Define una clase final llamada APPImageLoader, lo que significa que no se puede heredar de ella.
final class APPImageLoader {
    /// Declara una propiedad estática llamada shared que representa una instancia compartida de APPImageLoader. Esto permite acceder a la instancia desde cualquier lugar de la aplicación utilizando APPImageLoader.shared.
    static let shared = APPImageLoader()

    /// Declara una variable privada llamada imageDataCache, que es una instancia de NSCache. Esta caché se utiliza para almacenar en memoria los datos de imagen descargados, utilizando la URL de la imagen como clave.
    private var imageDataCache = NSCache<NSString, NSData>()

    /// Define un constructor privado, lo que significa que no se puede crear directamente una instancia de APPImageLoader desde fuera de la clase. Esto asegura que la única instancia accesible sea la instancia compartida (shared).
    private init() {}

    /// Define un método público llamado downloadImage que acepta una URL de origen y una clausura de finalización como parámetros. Esta función se utiliza para descargar una imagen de la URL proporcionada y llamar a la clausura de finalización con un resultado que contiene los datos de la imagen o un error.
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        
        /// Crea una instancia de NSString a partir de la representación de cadena de la URL, que se utilizará como clave en la caché de datos de imagen.
        let key = url.absoluteString as NSString
        
        /// Comprueba si existe una imagen en la caché de datos para la clave especificada. Si se encuentra, se llama a la clausura de finalización con éxito y se devuelve el dato de imagen almacenado en la caché.
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }

        /// Crea una instancia de URLRequest utilizando la URL proporcionada.
        let request = URLRequest(url: url)
        
        /// Crea una tarea de descarga de datos utilizando URLSession.shared.dataTask(with: request). Esta tarea realiza la solicitud de descarga de datos desde la URL especificada.
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            
            /// Verifica si se obtuvieron datos de la descarga correctamente y si no se produjo ningún error. Si hay datos válidos, se continúa con el procesamiento. De lo contrario, se llama a la clausura de finalización con un error.
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            /// Crea una instancia de NSData a partir de los datos descargados.
            let value = data as NSData
            
            /// Almacena el dato de imagen descargado en la caché de datos utilizando la clave correspondiente.
            self?.imageDataCache.setObject(value, forKey: key)
            
            /// Llama a la clausura de finalización con éxito y pasa los datos de la imagen descargada.
            completion(.success(data))
        }
        
        /// Inicia la tarea de descarga de datos.
        task.resume()
    }
}
