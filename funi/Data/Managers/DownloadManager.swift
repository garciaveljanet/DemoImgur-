//
//  DownloadManager.swift
//  funi
//
import Foundation

enum RequestResult<CustomType> {
    case success(CustomType)
    case fail(Error)
}

enum APIError: Error {
    case unknown
    case missingData
    case serialization
    case invalidData
}
