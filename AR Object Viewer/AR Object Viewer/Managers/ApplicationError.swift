//
//  ApplicationError.swift
//  AR Object Viewer
//
//  Created by Rohan Bimal Raj on 17/12/22.
//

import Foundation

enum ApplicationError: Error, CaseIterable {
    case FOLDER_CREATION_FAILED
    case FAILED_TO_DELETE
    case FILE_ALREADY_EXIST
    case FAILED_TO_COPY_ITEMS
    case FAILED_TO_GET_ITEM
}

extension ApplicationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .FOLDER_CREATION_FAILED:
            return NSLocalizedString("Oops the application failed to create the folder required for storing the models.", comment: "")
        case .FAILED_TO_DELETE:
            return NSLocalizedString("Oops the application failed to delete the item.", comment: "")
        case .FILE_ALREADY_EXIST:
            return NSLocalizedString("The model that you are trying to add already exsist", comment: "")
        case .FAILED_TO_COPY_ITEMS:
            return NSLocalizedString("Oops the application failed to copy the items.", comment: "")
        case .FAILED_TO_GET_ITEM:
            return NSLocalizedString("Oops failed to add item please try again", comment: "")
        }
    }
}
