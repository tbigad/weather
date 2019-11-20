//
//  CodableHelper.swift
//  WeatherTest
//
//  Created by Pavel N on 11/20/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import Foundation

public typealias EncodeResult = (data: Data?, error: Error?)

open class CodableHelper {

    open class func decode<T>(_ type: T.Type, from data: Data) -> (decodableObj: T?, error: Error?) where T : Decodable {
        var returnedDecodable: T? = nil
        var returnedError: Error? = nil

        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .base64
        decoder.dateDecodingStrategy = .iso8601

        do {
            returnedDecodable = try decoder.decode(type, from: data)
        } catch {
            returnedError = error
        }
        return (returnedDecodable, returnedError)
    }

    open class func encode<T>(_ value: T, prettyPrint: Bool = false) -> EncodeResult where T : Encodable {
        var returnedData: Data?
        var returnedError: Error? = nil

        let encoder = JSONEncoder()
        encoder.outputFormatting = (prettyPrint ? .prettyPrinted : .sortedKeys)
        
        encoder.dataEncodingStrategy = .base64
        encoder.dateEncodingStrategy = .iso8601

        do {
            returnedData = try encoder.encode(value)
        } catch {
            returnedError = error
        }

        return (returnedData, returnedError)
    }

}
