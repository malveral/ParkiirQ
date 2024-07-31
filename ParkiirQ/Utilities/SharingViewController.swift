//
//  SharingViewController.swift
//  ParkiirQ
//
//  Created by Michelle Alvera Lolang on 31/07/24.
//

import Foundation
import SwiftUI
import UIKit

struct SharingViewController: UIViewControllerRepresentable {
    @Binding var isPresenting: Bool
    var content: () -> UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresenting {
            uiViewController.present(content(), animated: true, completion: nil)
        }
    }
}
