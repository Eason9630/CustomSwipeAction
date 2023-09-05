import UIKit

// 使用者的結構
struct User {
    let name: String
    var isFavorite: Bool
    var isMuted: Bool
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 創建一個 UITableView
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // 一些示例使用者數據
    var users: [User] = [
        "Eason Lin",
        "Sandy Hong",
        "Allen Lin",
        "Eason Lin",
        "Sandy Hong",
        "Allen Lin"
    ].compactMap({
        User(name: $0, isFavorite: false, isMuted: false)
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        title = "Swipe Actions" // 設置標題
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds // 設置 UITableView 的框架
    }

    // MARK: - UITableViewDelegate 和 UITableViewDataSource 相關方法
    
    // 允許編輯行
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 設置滑動操作（刪除、收藏、靜音）
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            // 刪除使用者
            self.users.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        let user = users[indexPath.row]
        
        // 根據使用者的收藏狀態設置操作標題
        let favoriteActionTitle = user.isFavorite ? "Unfavorite" : "Favorite"
        let muteActionTitle = user.isMuted ? "Unmute" : "Mute"
        
        let favoriteAction = UITableViewRowAction(style: .normal, title: favoriteActionTitle) { _, indexPath in
            // 切換使用者的收藏狀態
            self.users[indexPath.row].isFavorite.toggle()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let muteAction = UITableViewRowAction(style: .normal, title: muteActionTitle) { _, indexPath in
            // 切換使用者的靜音狀態
            self.users[indexPath.row].isMuted.toggle()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        favoriteAction.backgroundColor = .systemBlue // 設置操作的背景顏色
        muteAction.backgroundColor = .systemOrange // 設置操作的背景顏色
        
        return [deleteAction, favoriteAction, muteAction] // 返回所有滑動操作
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count // 返回使用者數量
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = user.name // 設置儲存格的文本標籤
        if user.isFavorite {
            cell.backgroundColor = .systemBlue // 如果是收藏的使用者，設置儲存格背景顏色為藍色
        } else if user.isMuted {
            cell.backgroundColor = .systemOrange // 如果是靜音的使用者，設置儲存格背景顏色為橙色
        } else {
            cell.backgroundColor = nil // 恢復儲存格的背景顏色
        }
        
        return cell // 返回配置後的儲存格
    }
}
