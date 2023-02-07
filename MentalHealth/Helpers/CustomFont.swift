//
//  FontNames.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

enum CustomFont: String {
    case KyivTypeSans = "Kyiv*TypeSans"
    case KyivTypeSansLight = "Kyiv*TypeSans_Light"
    case kyivTypeSansLight2 = "Kyiv*TypeSans_Light2"
    case kyivTypeSansLight3 = "Kyiv*TypeSans_Light3"
    case kyivTypeSansRegular = "Kyiv*TypeSans_Regular"
    case kyivTypeSansRegular2 = "Kyiv*TypeSans_Regular2"
    case kyivTypeSansRegular3 = "Kyiv*TypeSans_Regular3"
    case kyivTypeSansMedium = "Kyiv*TypeSans_Medium"
    case kyivTypeSansMedium2 = "Kyiv*TypeSans_Medium2"
    case kyivTypeSansMedium3 = "Kyiv*TypeSans_Medium3"
    case kyivTypeSansBold = "Kyiv*TypeSans_Bold"
    case kyivTypeSansBold2 = "Kyiv*TypeSans_Bold2"
    case kyivTypeSansBold3 = "Kyiv*TypeSans_Bold3"
    case KyivTypeSansHeavy = "Kyiv*TypeSans_Heavy"
    case KyivTypeSansHeavy2 = "Kyiv*TypeSans_Heavy2"
    case KyivTypeSansHeavy3 = "Kyiv*TypeSans_Heavy3"
    case KyivTypeSansBlack = "Kyiv*TypeSans_Black"
    case KyivTypeSansBlack2 = "Kyiv*TypeSans_Black2"
    case KyivTypeSansBlack3 = "Kyiv*TypeSans_Black3"
    case Gruppo = "Gruppo"
    case InterLight = "Inter-Light"
    case InterMedium = "Inter-Medium"
    case GillSans = "GillSans"
    case GillSansItalic = "GillSans-Italic"
    case GillSansLight = "GillSans-Light"
    case GillSansLightItalic = "GillSans-LightItalic"
    case GillSansSemiBold = "GillSans-SemiBold"
    case GillSansSemiBoldItalic = "GillSans-SemiBoldItalic"
    case GillSansBold = "GillSans-Bold"
    case GillSansBoldItalic = "GillSans-BoldItalic"
    case GillSansUltraBold = "GillSans-UltraBold"
    case GillSansExtraCondensedBold = "GillSansMT-ExtraCondensedBold"

}

/*
 
 for family in UIFont.familyNames.sorted() {
     let names = UIFont.fontNames(forFamilyName: family)
     print("Family: \(family) Font names: \(names)")
 }
 
 Family: Kyiv*Type Sans Font names: [
 "Kyiv*TypeSans",
 "Kyiv*TypeSans_Light-",
 "Kyiv*TypeSans_Light",
 "Kyiv*TypeSans_Light2",
 "Kyiv*TypeSans_Light3",
 "Kyiv*TypeSans_Regular-",
 "Kyiv*TypeSans_Regular",
 "Kyiv*TypeSans_Regular2",
 "Kyiv*TypeSans_Regular3",
 "Kyiv*TypeSans_Medium-",
 "Kyiv*TypeSans_Medium",
 "Kyiv*TypeSans_Medium2",
 "Kyiv*TypeSans_Medium3",
 "Kyiv*TypeSans_Bold-",
 "Kyiv*TypeSans_Bold",
 "Kyiv*TypeSans_Bold2",
 "Kyiv*TypeSans_Bold3",
 "Kyiv*TypeSans_Heavy-",
 "Kyiv*TypeSans_Heavy",
 "Kyiv*TypeSans_Heavy2",
 "Kyiv*TypeSans_Heavy3",
 "Kyiv*TypeSans_Black-",
 "Kyiv*TypeSans_Black",
 "Kyiv*TypeSans_Black2",
 "Kyiv*TypeSans_Black3"
 ]
 
 Family: Gruppo Font names: ["Gruppo"]
 
 Family: Inter Font names: [
 "Inter-Light",
 "Inter-Medium"
 ]
 
 Family: Gill Sans Font names: [
 "GillSans",
 "GillSans-Italic",
 "GillSans-Light",
 "GillSans-LightItalic",
 "GillSans-SemiBold",
 "GillSans-SemiBoldItalic",
 "GillSans-Bold",
 "GillSans-BoldItalic",
 "GillSans-UltraBold"
 ]
 
 let str = NSAttributedString(string: "YOURSELF", attributes: [
     NSAttributedString.Key.foregroundColor : UIColor.customDeepBlue!,
     NSAttributedString.Key.strokeColor : UIColor.customStroke!,
     NSAttributedString.Key.strokeWidth : -1,
     NSAttributedString.Key.font : UIFont(name: CustomFont.GillSansExtraCondensedBold.rawValue, size: 80)
         ])
     let label = UILabel(frame: view.frame)
     label.attributedText = str
     view.addSubview(label)
 
 */
