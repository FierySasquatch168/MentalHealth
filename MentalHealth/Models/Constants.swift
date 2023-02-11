//
//  Constants.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import Foundation

struct Constants {
    static let shared = Constants()
    let accessKey = "FRBSEMoZbgqUKkLShrsxfilHFnKibFUZI8yuI8LEBXE"
    let secretKey = "3yaEFpg_fJSpPQUFO3-peaSjU2ztI9_hbOJXAhh11dM"
    let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    let accessScope = "public+read_user+write_likes"
    let defaultBaseURL =  URL(string: "https://api.unsplash.com")!
}
