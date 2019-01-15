//
//  RootViewController.swift
//  Example
//
//  Created by Pierluigi D'Andrea on 23/11/17.
//  Copyright © 2017 Pierluigi D'Andrea. All rights reserved.
//

import SatispayInStore
import UIKit

class RootViewController: UIViewController {

    private let dhController = DHController()

    override func viewDidLoad() {

        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        start()

    }

}

// MARK: - Flow
extension RootViewController {

    private func start() {

        //  the keychain contains all the keys that are required to send authenticated requests
        if SatispayInStoreConfig.environment.keychain.containsData {
            main()
        } else {
            requestActivation()
        }

    }

}

// MARK: - Activation
extension RootViewController {

    private func requestActivation() {

        dismissChildViewController()

        let tokenController = UIAlertController(title: "Activation token",
                                                message: "Insert an activation token to login",
                                                preferredStyle: .alert)

        tokenController.addTextField()

        let activationAction: (UIAlertAction) -> Void = { [weak tokenController, weak self] _ in

            guard let tokenField = tokenController?.textFields?.first else {
                return
            }

            self?.performActivation(with: tokenField.text)

        }

        tokenController.addAction(UIAlertAction(title: "OK", style: .default, handler: activationAction))
        tokenController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(tokenController, animated: true, completion: nil)

    }

    private func performActivation(with token: String?) {

        guard let token = token?.trimmingCharacters(in: .whitespacesAndNewlines), token.count == 6 else {

            DispatchQueue.main.async { [weak self] in
                self?.requestActivation()
            }

            return

        }

        do {
            try dhController.importPublicKey()
        } catch let error {
            return presentError(error)
        }

        _ = dhController.generateParameters { [weak self] (params, error) in
            self?.didGenerateParameters(params, token: token, error: error)
        }

    }

    private func didGenerateParameters(_ params: DHParams?, token: String, error: NetworkServiceError?) {

        guard let params = params else {
            return presentError(error)
        }

        print("\(#function): ok")

        _ = dhController.exchange(parameters: params) { [weak self] (result, error) in
            self?.didCompleteExchange(with: result, token: token, error: error)
        }

    }

    private func didCompleteExchange(with result: (DHParams, DHExchangeResponse)?, token: String, error: NetworkServiceError?) {

        guard let result = result else {
            return presentError(error)
        }

        print("\(#function): ok")

        let (params, response) = result

        _ = dhController.challenge(parameters: params, exchangeResponse: response) { [weak self] (result, error) in
            self?.didCompleteChallenge(with: result, token: token, error: error)
        }

    }

    private func didCompleteChallenge(with result: (DHController.Context, DHChallengeResponse)?, token: String, error: NetworkServiceError?) {

        guard let result = result else {
            return presentError(error)
        }

        print("\(#function): ok")

        let (context, response) = result

        _ = dhController.verification(context: context, challengeResponse: response, token: token) { [weak self] (error) in
            self?.didCompleteVerification(error: error)
        }

    }

    private func didCompleteVerification(error: NetworkServiceError?) {

        if let error = error {
            return presentError(error) { [weak self] in
                self?.start()
            }
        }

        start()

    }

}

// MARK: - Main
extension RootViewController {

    private func main() {

        _ = AnalyticsController().started(udid: nil, deviceInfo: "SatispayInStore-example", appVersion: "1.0") { [weak self] (response, error) in

            guard response?.status == "OK" else {

                self?.presentError(error) { [weak self] in
                    self?.start()
                }

                return

            }

            self?.presentMainController()

        }

    }

    private func presentMainController() {

        _ = ProfileController().me { [weak self] (profile, error) in

            guard let controller = self else {
                return
            }

            guard let profile = profile else {
                return controller.presentError(error)
            }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let mainParentController = storyboard.instantiateViewController(withIdentifier: "MainViewControllerParent") as! NavigationController

            mainParentController.configure(with: profile)

            controller.presentChildViewController(mainParentController)

        }

    }

}

// MARK: - Child controller
extension RootViewController {

    private func presentChildViewController(_ controller: UIViewController) {

        let currentController = children.first
        currentController?.willMove(toParent: nil)

        addChild(controller)

        controller.view.frame = view.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        controller.beginAppearanceTransition(true, animated: true)
        view.addSubview(controller.view)

        controller.view.alpha = 0

        UIView.animate(withDuration: 0.2, animations: {

            controller.view.alpha = 1

        }, completion: { [weak self] _ in

            controller.endAppearanceTransition()
            controller.didMove(toParent: self)

            if let currentController = currentController {

                if currentController.presentedViewController != nil {
                    currentController.dismiss(animated: false, completion: nil)
                }

                currentController.beginAppearanceTransition(false, animated: true)
                currentController.view.removeFromSuperview()
                currentController.endAppearanceTransition()

                currentController.removeFromParent()

            }

        })

    }

    private func dismissChildViewController() {

        guard let controller = children.first else {
            return
        }

        controller.willMove(toParent: nil)

        UIView.animate(withDuration: 0.2, animations: {

            controller.view.alpha = 0

        }, completion: { _ in

            if controller.presentedViewController != nil {
                controller.dismiss(animated: false, completion: nil)
            }

            controller.beginAppearanceTransition(false, animated: true)
            controller.view.removeFromSuperview()
            controller.endAppearanceTransition()

            controller.removeFromParent()

        })

    }

}

// MARK: - Utils
extension RootViewController {

    private func presentError(_ error: Error?, source: String = #function, completion: (() -> Void)? = nil) {

        print("\(source) failed with \(String(describing: error))")

        let errorController = UIAlertController(title: "Error",
                                                message: error?.localizedDescription ?? "An error occurred",
                                                preferredStyle: .alert)

        errorController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in completion?() }))

        present(errorController, animated: true, completion: nil)

    }

}
