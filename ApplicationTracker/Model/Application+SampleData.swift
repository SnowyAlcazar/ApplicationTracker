//
//  Application+SampleData.swift
//  ApplicationTracker
//
//  Created by Mark Brown on 13/11/2025.
//

import Foundation

extension Application {
    static let sampleAppsData: [Application] = [
        Application(
            position: "Contract PM - ECMS",
            businessSector: "Insurance",
            positionType: "Project Manager",
            employmentType: "Contract",
            dateApplied: Calendar.current.date(byAdding: .day, value: -266, to: Date()) ?? Date(),
            whereAdvertised: "Direct from Adele Bywater at ECMS",
            requiredSkills: "Insurance, azure infrastructure, move on premise hosting to cloud",
            remunerationType: "Daily",
            remunerationAmount: 650,
            iR35: "Outside",
            positionCommitment: "Full-time",
            workstyle: "Hybrid",
            officeDays: "3",
            notes: "Great opportunity at established insurance company",
            appStatus: "Interview"
        ),
        Application(
            position: "Project Manager",
            businessSector: "Finance",
            positionType: "PM",
            employmentType: "Contract",
            dateApplied: Calendar.current.date(byAdding: .day, value: -267, to: Date()) ?? Date(),
            whereAdvertised: "Eames Agency",
            requiredSkills: "Financial services, agile delivery, stakeholder management",
            remunerationType: "Daily",
            remunerationAmount: 550,
            iR35: "Inside",
            positionCommitment: "Full-time",
            workstyle: "Remote",
            officeDays: "0",
            notes: "Fully remote position",
            appStatus: "Open"
        ),
        Application(
            position: "Project Manager - Contract",
            businessSector: "Technology",
            positionType: "PM",
            employmentType: "Contract",
            dateApplied: Calendar.current.date(byAdding: .day, value: -275, to: Date()) ?? Date(),
            whereAdvertised: "Alchemy Agency",
            requiredSkills: "Digital transformation, change management, MS Project",
            remunerationType: "Daily",
            remunerationAmount: 600,
            iR35: "Outside",
            positionCommitment: "Full-time",
            workstyle: "Hybrid",
            officeDays: "2",
            notes: "6 month initial contract with extension",
            appStatus: "Open"
        ),
        Application(
            position: "Senior Project Manager",
            businessSector: "Healthcare",
            positionType: "Senior PM",
            employmentType: "Permanent",
            dateApplied: Calendar.current.date(byAdding: .day, value: -50, to: Date()) ?? Date(),
            whereAdvertised: "Company Website",
            requiredSkills: "Healthcare IT, compliance, team leadership",
            remunerationType: "Annual",
            remunerationAmount: 85000,
            iR35: "N/A",
            positionCommitment: "Full-time",
            workstyle: "Office",
            officeDays: "5",
            notes: "Permanent role with benefits package",
            appStatus: "Offer"
        ),
        Application(
            position: "Programme Manager",
            businessSector: "Government",
            positionType: "Programme Manager",
            employmentType: "Contract",
            dateApplied: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
            whereAdvertised: "Specialist Recruitment",
            requiredSkills: "Public sector, PRINCE2, governance",
            remunerationType: "Daily",
            remunerationAmount: 750,
            iR35: "Inside",
            positionCommitment: "Full-time",
            workstyle: "Hybrid",
            officeDays: "3",
            notes: "SC clearance required",
            appStatus: "Interview"
        ),
        Application(
            position: "Delivery Manager",
            businessSector: "Retail",
            positionType: "Delivery Manager",
            employmentType: "Permanent",
            dateApplied: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            whereAdvertised: "LinkedIn",
            requiredSkills: "Agile, Scrum, e-commerce",
            remunerationType: "Annual",
            remunerationAmount: 75000,
            iR35: "N/A",
            positionCommitment: "Full-time",
            workstyle: "Hybrid",
            officeDays: "2",
            notes: "Fast-growing retail tech company",
            appStatus: "Open"
        ),
        Application(
            position: "Technical Project Manager",
            businessSector: "Technology",
            positionType: "Technical PM",
            employmentType: "Contract",
            dateApplied: Calendar.current.date(byAdding: .day, value: -120, to: Date()) ?? Date(),
            whereAdvertised: "Contractor UK",
            requiredSkills: "Cloud migration, DevOps, technical delivery",
            remunerationType: "Daily",
            remunerationAmount: 700,
            iR35: "Outside",
            positionCommitment: "Full-time",
            workstyle: "Remote",
            officeDays: "0",
            notes: "No response after initial application",
            appStatus: "Closed"
        ),
        Application(
            position: "Portfolio Manager",
            businessSector: "Financial Services",
            positionType: "Portfolio Manager",
            employmentType: "Permanent",
            dateApplied: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
            whereAdvertised: "Reed",
            requiredSkills: "Portfolio management, strategic planning, budget oversight",
            remunerationType: "Annual",
            remunerationAmount: 95000,
            iR35: "N/A",
            positionCommitment: "Full-time",
            workstyle: "Hybrid",
            officeDays: "3",
            notes: "Senior role managing multiple projects",
            appStatus: "On hold"
        )
    ]
}

// MARK: - Sample Data for Other Models

extension Agent {
    static let sampleAgentsData: [Agent] = [
        Agent(
            name: "Adele Bywater",
            officePhone: "020 8565 0009",
            mobilePhone: "020 7092 3204",
            email: "adele.bywater@ecmconsultancy.com",
            isFavorite: true,
            notes: "Very responsive and helpful. Always keeps me updated."
        ),
        Agent(
            name: "Robin Muir",
            officePhone: "020 7123 4567",
            mobilePhone: "07700 900123",
            email: "robin.muir@eames.com",
            isFavorite: false,
            notes: "Specializes in finance sector roles"
        ),
        Agent(
            name: "Bayley Jenkins",
            officePhone: "020 7234 5678",
            mobilePhone: "07700 900234",
            email: "bayley.jenkins@alchemy.com",
            isFavorite: true,
            notes: "Great track record placing contractors"
        )
    ]
}

extension Agency {
    static let sampleAgenciesData: [Agency] = [
        Agency(name: "ECMS Consultancy", isFavorite: true),
        Agency(name: "Eames", isFavorite: false),
        Agency(name: "Alchemy", isFavorite: true),
        Agency(name: "Synergize Consulting", isFavorite: false)
    ]
}

extension Client {
    static let sampleClientsData: [Client] = [
        Client(
            name: "MS Amlin",
            businessSegment: "Insurance",
            hiringManager: "Sarah Johnson",
            hiringManagerPosition: "Head of IT"
        ),
        Client(
            name: "AXA XL",
            businessSegment: "Insurance",
            hiringManager: "Michael Chen",
            hiringManagerPosition: "Programme Director"
        ),
        Client(
            name: "ECMS Consultancy",
            businessSegment: "Consulting",
            hiringManager: "Emma Thompson",
            hiringManagerPosition: "Managing Director"
        )
    ]
}

