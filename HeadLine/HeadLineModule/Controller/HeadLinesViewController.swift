//
//  HeadLinesViewController.swift
//  HeadLine
//
//  Created by Keerthika Chokkalingam on 03/09/23.
//

import UIKit

class HeadLinesViewController: UIViewController {

    var viewModel: HeadLineViewModal?
    var responseNews: HeadLinesResponse?
    var apiDataCollectionValues = [ArticalSet]()
    var indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var headLineListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

extension HeadLinesViewController {
    func setUpUI() {
        headLineListTableView.delegate = self
        headLineListTableView.dataSource = self
        headLineListTableView.register(UINib(nibName: "HeadLinesListTableViewCell", bundle: nil), forCellReuseIdentifier: "HeadLinesListTableViewCell")
        indicator = Utils().setUpLoader(sender: view)
        getNewsApiCall()
    }
    func getNewsApiCall() {
        if NetworkConnectionHandler().checkReachable() {
            Utils().startLoading(sender: indicator, wholeView: view)
            viewModel = HeadLineViewModal()
            viewModel?.GetNewsForDashboardApiCall(data: ApiConstants.sourceUrl,completion: { [weak self] in
                self?.responseNews = self?.viewModel?.aPIResponseModel
                let filter = self?.responseNews?.articles?.filter{$0.urlToImage != nil}
                self?.responseNews?.articles = filter
                DispatchQueue.main.async {
                    Utils().endLoading(sender: self?.indicator ?? UIActivityIndicatorView() , wholeView: self?.view ?? UIView())
                    self?.headLineListTableView.reloadData()
                }
            })
        } else {
            let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                Utils().endLoading(sender: self.indicator, wholeView: self.view ?? UIView())
                controller.dismiss(animated: true)
                }
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
    }
}

extension HeadLinesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseNews?.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeadLinesListTableViewCell", for: indexPath)as? HeadLinesListTableViewCell else {return UITableViewCell()}
        guard let currentData = responseNews?.articles?[indexPath.row] else {return UITableViewCell()}
        cell.loadCellValues(data: currentData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detaildHeadLineVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedHeadLineViewController") as? DetailedHeadLineViewController else {return}
        detaildHeadLineVc.gettedArticleSet = responseNews?.articles?[indexPath.row]
        self.addChild(detaildHeadLineVc)
        self.view.addSubview(detaildHeadLineVc.view)
        detaildHeadLineVc.didMove(toParent: self)
    }
}
