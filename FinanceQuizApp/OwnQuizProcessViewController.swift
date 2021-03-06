//
//  OwnQuizProcessViewController.swift
//  test
//
//  Created by Gibson Kong on 04/05/2017.
//  Copyright © 2017 訪客使用者. All rights reserved.
//

import UIKit
import CoreData

class OwnQuizProcessViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var sourceProcessType:String!
    
    var sourceDict = ["myFeaturedQuiz":1,"myMarkedQuiz":2,"TheEazierWrongQuiz":3]
    var MarkedQuiz : [MarkedQuiz] = []
    var TEWQ : [TheEazierWrongQuiz] = []
    var TheEazierWrongQuiz : [TheEazierWrongQuiz] = []
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false     
        self.tabBarController?.tabBar.isHidden = true
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        switch sourceDict[sourceProcessType]!{
        case 1:
            let fetchMarkedQuiz = NSFetchRequest<NSFetchRequestResult>(entityName: "MarkedQuiz")
            do{
                MarkedQuiz = try context?.fetch(fetchMarkedQuiz) as! [MarkedQuiz]
            } catch let error as NSError{
                print(error)
            }
            
            
        case 3:
            let fetchTEWQ = NSFetchRequest<NSFetchRequestResult>(entityName: "TheEazierWrongQuiz")
            do{
                TheEazierWrongQuiz = try context?.fetch(fetchTEWQ) as! [TheEazierWrongQuiz]
            } catch let error as NSError{
                print(error)
            }
            for i in TheEazierWrongQuiz{
                if i.count > 1{
                    TEWQ.append(i)
                }
            }
            
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sourceDict[sourceProcessType]!{
        case 1:
            return MarkedQuiz.count
        case 3:
            var temp = 0
            
            return TEWQ.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        switch sourceDict[sourceProcessType]!{
        case 1:
            let action = UITableViewRowAction(style: .default, title: "Delete") { (UITableViewRowAction, indexPath) in
                let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
                context?.delete(self.MarkedQuiz[indexPath.row])
                self.MarkedQuiz.remove(at: indexPath.row)
                tableView.reloadData()
                do{
                    try context?.save()
                } catch let error as NSError{
                    print("error : \(error)")
                }
            }
            return [action]
        case 3:
            let action = UITableViewRowAction(style: .default, title: "Delete") { (UITableViewRowAction, indexPath) in
                let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
                
                context?.delete(self.TheEazierWrongQuiz[indexPath.row])
                self.TheEazierWrongQuiz.remove(at: indexPath.row)
                tableView.reloadData()
                do{
                    try context?.save()
                } catch let error as NSError{
                    print("error : \(error)")
                }
            }
            return [action]
        default:
            return []
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sourceDict[sourceProcessType]!{
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
            
            cell.professionType.text = "\(ProfessionSet[Int(MarkedQuiz[indexPath.row].professionSet)].ProfessionName!)"
            
            cell.ExamGrade.text = "\(ProfessionSet[MarkedQuiz[indexPath.row].professionSet.toInt()].LicenseGrade[MarkedQuiz[indexPath.row].licenseGrade.toInt()].Grade!)"
            
            cell.ExamSet.text = "\(ProfessionSet[MarkedQuiz[indexPath.row].professionSet.toInt()].LicenseGrade[MarkedQuiz[indexPath.row].licenseGrade.toInt()].LicenseType[MarkedQuiz[indexPath.row].licenseGrade.toInt()].ExamSet[MarkedQuiz[indexPath.row].examSet.toInt()].name!)"
            let ExamSet = ProfessionSet[MarkedQuiz[indexPath.row].professionSet.toInt()].LicenseGrade[MarkedQuiz[indexPath.row].licenseGrade.toInt()].LicenseType[MarkedQuiz[indexPath.row].licenseGrade.toInt()].ExamSet[MarkedQuiz[indexPath.row].examSet.toInt()]
            cell.QuizQuestion.text = "\(ExamSet.quizList[Int(MarkedQuiz[indexPath.row].quizID)].question!)"
            
            
            return cell
            
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
            
            cell.professionType.text = "\(ProfessionSet[Int(TEWQ[indexPath.row].professionSet)].ProfessionName!)"
            
            cell.ExamGrade.text = "\(ProfessionSet[TEWQ[indexPath.row].professionSet.toInt()].LicenseGrade[TEWQ[indexPath.row].licenseGrade.toInt()].Grade)"
            
            cell.ExamSet.text = "\(ProfessionSet[TEWQ[indexPath.row].professionSet.toInt()].LicenseGrade[TEWQ[indexPath.row].licenseGrade.toInt()].LicenseType[TEWQ[indexPath.row].licenseGrade.toInt()].ExamSet[TEWQ[indexPath.row].examSet.toInt()].name)"
            let ExamSet = ProfessionSet[TEWQ[indexPath.row].professionSet.toInt()].LicenseGrade[TEWQ[indexPath.row].licenseGrade.toInt()].LicenseType[TEWQ[indexPath.row].licenseGrade.toInt()].ExamSet[TEWQ[indexPath.row].examSet.toInt()]
            cell.QuizQuestion.text = "\(ExamSet.quizList[Int(TEWQ[indexPath.row].quizID)].question!)"
            
            
            return cell
            
        default:
             let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
             return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DoingQuizView"{
            switch sourceDict[sourceProcessType]!{
            case 1:
                let indexPath = tableView.indexPathForSelectedRow!
                let destionation = segue.destination as! DoingOwnQuizViewController
                let ExamSet = ProfessionSet[MarkedQuiz[indexPath.row].professionSet.toInt()].LicenseGrade[MarkedQuiz[indexPath.row].licenseGrade.toInt()].LicenseType[MarkedQuiz[indexPath.row].licenseGrade.toInt()].ExamSet[MarkedQuiz[indexPath.row].examSet.toInt()]
                destionation.quiz = ExamSet.quizList[Int(MarkedQuiz[indexPath.row].quizID)]
            case 3:
                let indexPath = tableView.indexPathForSelectedRow!
                let destionation = segue.destination as! DoingOwnQuizViewController
                let ExamSet = ProfessionSet[TEWQ[indexPath.row].professionSet.toInt()].LicenseGrade[TEWQ[indexPath.row].licenseGrade.toInt()].LicenseType[TEWQ[indexPath.row].licenseGrade.toInt()].ExamSet[TEWQ[indexPath.row].examSet.toInt()]
                destionation.quiz = ExamSet.quizList[Int(TEWQ[indexPath.row].quizID)]
            default:
                break
            }
            
        }
    }
}



class TableViewCell : UITableViewCell{
    @IBOutlet var professionType: UILabel!
    @IBOutlet var ExamGrade: UILabel!
    @IBOutlet var ExamSet: UILabel!
    @IBOutlet var QuizQuestion: UILabel!
    
}
