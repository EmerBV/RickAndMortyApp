//
//  APPAPICacheManager.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 22/6/23.
//

import Foundation

/// Esta clase administra múltiples cachés de respuestas de API en memoria, permitiendo almacenar y recuperar datos de respuesta de forma eficiente para diferentes endpoints de la API y URL específicas.
final class APPAPICacheManager {

    /// Declara una variable privada llamada cacheDictionary que es un diccionario. La clave del diccionario es un tipo de dato APPEndpoint, que es una enumeración personalizada, y el valor del diccionario es una instancia de NSCache que almacena datos de tipo NSData. Este diccionario se utiliza para almacenar múltiples cachés, cada una correspondiente a un endpoint específico.
    private var cacheDictionary: [
        APPEndpoint: NSCache<NSString, NSData>
    ] = [:]

    /// Define un constructor que se llama al crear una instancia de APPAPICacheManager. En este caso, el constructor llama al método setUpCache() para configurar las cachés iniciales.
    init() {
        setUpCache()
    }

    // MARK: - Public

    /// Define un método público llamado cachedResponse que recibe un endpoint de API y una URL como parámetros. Este método busca en la caché correspondiente al endpoint y la URL proporcionados y devuelve los datos de la respuesta almacenados en la caché, si están disponibles.
    public func cachedResponse(for endpoint: APPEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }

    /// Define un método público llamado setCache que recibe un endpoint de API, una URL y datos como parámetros. Este método establece los datos proporcionados en la caché correspondiente al endpoint y la URL proporcionados.
    public func setCache(for endpoint: APPEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }

    // MARK: - Private

    /// Define un método privado llamado setUpCache que se utiliza para configurar las cachés iniciales. Este método recorre todos los casos de la enumeración APPEndpoint y crea una nueva instancia de NSCache para cada uno, agregándola al cacheDictionary.
    private func setUpCache() {
        APPEndpoint.allCases.forEach({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        })
    }
}
