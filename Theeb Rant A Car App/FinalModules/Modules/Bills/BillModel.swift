//
//  BillModel.swift
//  Theeb Rent A Car App
//
//  Created by ahmed elshobary on 10/08/2023.
//

import Foundation

struct BillResponseModel: Codable {
    var Invoices: InvoicesModel?
}

struct InvoicesModel: Codable {
    var Success: String?
    var UnpaidInvoices: UnpaidInvoicesModel?
    var PaidInvoices: PaidInvoicesModel?
    var VarianceReason: String?
}

struct UnpaidInvoicesModel: Codable {
    var Invoice: [InvoiceModel]?
}

struct PaidInvoicesModel: Codable {
    var Invoice: [InvoiceModel]?
}

struct InvoiceModel: Codable {
    var InvoiceType: String?
    var InvoiceAmount: String?
    var BalanceAmount: Int?
    var PaidAmount: Int?
    var InvoiceClosed: Int?
    var InvoiceNo: Int?
    var AgreementNo: Int?
    var ReservationNo: Int?
}
