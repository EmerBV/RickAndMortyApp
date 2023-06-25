//
//  APPEndpoint.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 22/6/23.
//

import Foundation

/// Define los distintos puntos finales de la API, como "character", "location" y "episode". Esta enumeración proporciona una forma estructurada de representar y trabajar con los puntos finales de la API en el código.

/// Define una enumeración congelada (@frozen) llamada APPEndpoint. El atributo @frozen indica que la enumeración no puede tener casos adicionales más allá de los especificados en su definición inicial.
@frozen enum APPEndpoint: String, CaseIterable, Hashable {
    /// Define un caso de la enumeración llamado character. Este caso representa el punto final para obtener información de personajes de la API.
    
    case character
    
    /// Define un caso de la enumeración llamado location. Este caso representa el punto final para obtener información de ubicaciones de la API.
    case location
    
    /// Define un caso de la enumeración llamado episode. Este caso representa el punto final para obtener información de episodios de la API.
    case episode
    
    /// String: La enumeración se basa en valores de tipo String, lo que significa que cada caso de la enumeración tiene un valor asociado de tipo String.
    
    /// CaseIterable: La enumeración implementa el protocolo CaseIterable, lo que permite iterar sobre todos los casos de la enumeración. Esto permite, por ejemplo, obtener una colección de todos los casos de APPEndpoint utilizando APPEndpoint.allCases.
    
    /// Hashable: La enumeración implementa el protocolo Hashable, lo que permite utilizar instancias de APPEndpoint como claves en diccionarios y realizar comparaciones de igualdad basadas en su valor hash.
}
