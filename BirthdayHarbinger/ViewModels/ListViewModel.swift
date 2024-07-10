//
//  ListViewModel.swift
//  BirthdayHarbinger
//
//  Created by Özgün Can Beydili on 10.07.2024.
//

import Foundation

final class ListViewModel: ObservableObject {
    
    @Published var people: [Person] = []
    @Published var filteredPeople: [Person] = []
    
    init() { getPeople() }
    
    func getPeople() {
        people.append(Person(name: "Özgün", birthday: "02/10/2002", category: "Family"))
    }
    
//    func savePerson(person: Person) {
//        service.post(person: person) { [weak self] _ in
//            guard let self = self else { return }
//            
//            // Add or update the person in `people` array
//            DispatchQueue.main.async {
//                self.filterPeople(by: .All)
//            }
//        }
//    }
    
    /// filters people as category
    func filterPeople(by category: Category) {
        if category == .All {
            filteredPeople = people
        } else {
            filteredPeople = people.filter { $0.category == category.rawValue }
        }
    }
    
    /// sorts list as left days to birthday
    func peopleSortedByDaysLeft() -> [Person] {
        return filteredPeople.sorted(by: { person1, person2 in
            guard let daysLeft1 = person1.calculateLeftDays(),
                  let daysLeft2 = person2.calculateLeftDays() else {
                return false
            }
            return Int(daysLeft1)! < Int(daysLeft2)!
        })
    }
}
