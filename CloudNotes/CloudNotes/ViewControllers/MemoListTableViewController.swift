//
//  MemoListTableViewController.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/19.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    weak var delegate: MemoListSelectDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
    }
    
    private func setupTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 70
        self.tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "memoCell")
    }

    @objc func addMemo() {
        delegate?.memoCellSelect(nil)
        moveToMemoDetailViewController()
    }
    
    private func moveToMemoDetailViewController() {
        if let memoDetailViewController = delegate as? MemoDetailViewController,
           (traitCollection.horizontalSizeClass == .compact && traitCollection.userInterfaceIdiom == .phone) {
            let memoDetailNavigationController = UINavigationController(rootViewController: memoDetailViewController)
            splitViewController?.showDetailViewController(memoDetailNavigationController, sender: nil)
        }
    }
}

extension MemoListTableViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoModel.shared.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell") as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.setupMemoCell(with: MemoModel.shared.list[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.memoCellSelect(MemoModel.shared.list[indexPath.row])
        self.moveToMemoDetailViewController()
    }
}

extension MemoListTableViewController: MemoDetailDelegate {
    func saveMemo(indexRow: Int) {
        self.tableView.insertRows(at: [IndexPath(row: indexRow, section: 0)], with: .automatic)
    }
}

protocol MemoListSelectDelegate: class {
    func memoCellSelect(_ memo: Memo?)
}
