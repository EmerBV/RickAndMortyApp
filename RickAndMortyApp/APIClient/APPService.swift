//
//  APPService.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 22/6/23.
//

import Foundation

/// Esta clase proporciona métodos para enviar llamadas a la API de Rick and Morty, manejar cachés de respuestas en memoria y decodificar los datos de respuesta en objetos utilizables en la aplicación. La clase utiliza un administrador de caché (APPAPICacheManager) para almacenar en caché las respuestas de la API y mejorar el rendimiento de la aplicación al evitar múltiples solicitudes de la misma información.
final class APPService {
    
    /// Declara una propiedad estática llamada shared que representa una instancia compartida de APPService. Esto permite acceder a la instancia desde cualquier lugar de la aplicación utilizando APPService.shared.
    static let shared = APPService()

    /// Declara una propiedad privada llamada cacheManager que es una instancia de APPAPICacheManager. Esta propiedad se utiliza para administrar las cachés de respuestas de API en memoria.
    private let cacheManager = APPAPICacheManager()

    /// Define un constructor privado, lo que significa que no se puede crear directamente una instancia de APPService desde fuera de la clase. Esto asegura que la única instancia accesible sea la instancia compartida (shared).
    private init() {}

    /// Define una enumeración de errores llamada APPServiceError que representa posibles errores que pueden ocurrir durante la ejecución de las llamadas de la API.
    enum APPServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }

    /// Define un método público llamado execute que se utiliza para enviar una llamada a la API de Rick and Morty. Toma una instancia de APPRequest, el tipo de objeto esperado en la respuesta de la API, y una clausura de finalización como parámetros. Este método realiza la llamada a la API y llama a la clausura de finalización con un resultado que contiene los datos decodificados o un error.
    public func execute<T: Codable>(
        _ request: APPRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        /// Comprueba si hay datos de respuesta en caché para la combinación de endpoint y URL especificados en la solicitud. Si los datos están disponibles, se intenta decodificarlos utilizando JSONDecoder y se llama a la clausura de finalización con éxito o con el error de decodificación.
        if let cachedData = cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
            return
        }

        /// Intenta crear una instancia de URLRequest utilizando el método request(from:). Si no se puede crear la solicitud, se llama a la clausura de finalización con el error APPServiceError.failedToCreateRequest.
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(APPServiceError.failedToCreateRequest))
            return
        }

        /// Crea una tarea de descarga de datos utilizando URLSession.shared.dataTask(with:). Esta tarea realiza la solicitud a la API y recibe los datos de respuesta.
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            
            /// Verifica si se obtuvieron datos de la respuesta correctamente y si no se produjo ningún error. Si hay datos válidos, se continúa con el procesamiento. De lo contrario, se llama a la clausura de finalización con el error APPServiceError.failedToGetData.
            guard let data = data, error == nil else {
                completion(.failure(error ?? APPServiceError.failedToGetData))
                return
            }

            /// Intenta decodificar los datos de respuesta utilizando JSONDecoder y el tipo de objeto esperado (type). Si la decodificación es exitosa, se llama a la clausura de finalización con éxito y se almacenan los datos en la caché utilizando el cacheManager.
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(
                    for: request.endpoint,
                    url: request.url,
                    data: data
                )
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // MARK: - Private

    /// Define un método privado llamado request que toma una instancia de APPRequest y devuelve una instancia de URLRequest. Este método crea una solicitud URL utilizando la URL de la solicitud APPRequest y establece el método HTTP correspondiente en la solicitud.
    private func request(from appRequest: APPRequest) -> URLRequest? {
        guard let url = appRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = appRequest.httpMethod
        return request
    }
}
