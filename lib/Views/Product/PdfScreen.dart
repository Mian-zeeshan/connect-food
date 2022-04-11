import 'dart:typed_data';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/CheckAdminController.dart';
import 'package:connectsaleorder/Models/CartModel.dart';
import 'package:connectsaleorder/Utils/AppUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfScreen extends StatefulWidget{
  @override
  _PdfScreen createState() => _PdfScreen();

}

class _PdfScreen extends State<PdfScreen>{
  var utils = AppUtils();
  CartModel cartModel = Get.arguments;
  var totalItems = 0;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  CheckAdminController checkAdminController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(var item in cartModel.products){
      totalItems += item.selectedQuantity;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: checkAdminController.system.mainColor,
        title: Text("Invoice" , style: utils.headingStyle(whiteColor),),
        centerTitle: true,
        leading: IconButton(icon: Icon(CupertinoIcons.arrow_left , color: whiteColor, size: 24,),onPressed: (){
          Get.back();
        },),
      ),
      body: Theme(
        data: ThemeData(
          primaryColor: checkAdminController.system.mainColor,
          secondaryHeaderColor: whiteColor,
          iconTheme: IconThemeData(
            color: whiteColor
          )
        ),
        child: PdfPreview(
          build: (format) => _generatePdf(format),
          allowSharing: true,
          canChangePageFormat: false,
          canChangeOrientation: false,
          canDebug: false,
        ),
      ),
    );
  }
  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Container(
            width: PdfPageFormat.a4.width,
            height: PdfPageFormat.a4.height,
              child: pw.Column(
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                            child: pw.Text("Connect Sales Order" , style: pw.TextStyle(
                              color: PdfColor.fromHex("#000000"),
                              fontSize: 4,
                              fontWeight: pw.FontWeight.bold,
                              decoration: pw.TextDecoration.none,
                            ))
                        ),
                        pw.Container(
                            child: pw.Text("Customer Copy" , style: pw.TextStyle(
                              color: PdfColor.fromHex("#000000"),
                              fontSize: 3,
                              fontWeight: pw.FontWeight.normal,
                              decoration: pw.TextDecoration.none,
                            ))
                        ),
                      ]
                  ),
                  pw.SizedBox(height: 7),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children:[
                        pw.Text("${cartModel.cartId}" , style: pw.TextStyle(
                          color: PdfColor.fromHex("#000000"),
                          fontSize: 3,
                          fontWeight: pw.FontWeight.normal,
                          decoration: pw.TextDecoration.none,
                        ),)
                      ]
                  ),
                  pw.SizedBox(height: 1),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children:[
                        pw.Text("${DateFormat("yyyy-MM-dd").format(DateTime.fromMillisecondsSinceEpoch(cartModel.createdAt))}" , style: pw.TextStyle(
                          color: PdfColor.fromHex("#000000"),
                          fontSize: 3,
                          fontWeight: pw.FontWeight.normal,
                          decoration: pw.TextDecoration.none,
                        ),)
                      ]
                  ),
                  pw.SizedBox(height: 1),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children:[
                        pw.Text("Customer: ${cartModel.customer!.name}" , style: pw.TextStyle(
                          color: PdfColor.fromHex("#000000"),
                          fontSize: 3,
                          fontWeight: pw.FontWeight.normal,
                          decoration: pw.TextDecoration.none,
                        ),)
                      ]
                  ),
                  pw.SizedBox(height: 2),/*
                  pw.Container(
                    width: PdfPageFormat.a4.width,
                    height: 1 * 0.1,
                    color: PdfColor.fromHex("#000000")
                  ),*/
                  pw.SizedBox(height: 1),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              /*pw.Container(
                                  width: PdfPageFormat.roll80.width/20,
                                  padding: pw.EdgeInsets.all(4),
                                  child: pw.Center(
                                      child: pw.Text("Sr" , style: pw.TextStyle(
                                        color: PdfColor.fromHex("#000000"),
                                        fontSize: 2.5,
                                        fontWeight: pw.FontWeight.bold,
                                        decoration: pw.TextDecoration.none,
                                      ),)
                                  )
                              ),*/
                              pw.Container(
                                  width: PdfPageFormat.roll80.width/2,
                                  padding: pw.EdgeInsets.all(4),
                                  child: pw.Text("Name" , style: pw.TextStyle(
                                    color: PdfColor.fromHex("#000000"),
                                    fontSize: 2.5,
                                    fontWeight: pw.FontWeight.bold,
                                    decoration: pw.TextDecoration.none,
                                  ),),
                              ),
                              pw.Container(
                                  width: PdfPageFormat.roll80.width/12,
                                  padding: pw.EdgeInsets.all(4),
                                  child: pw.Center(
                                      child: pw.Text("Unit" , style: pw.TextStyle(
                                        color: PdfColor.fromHex("#000000"),
                                        fontSize: 2.5,
                                        fontWeight: pw.FontWeight.bold,
                                        decoration: pw.TextDecoration.none,
                                      ),)
                                  )
                              ),
                              pw.Container(
                                  width: PdfPageFormat.roll80.width/10,
                                  padding: pw.EdgeInsets.all(4),
                                  child: pw.Center(
                                      child: pw.Text("Qty" , style: pw.TextStyle(
                                        color: PdfColor.fromHex("#000000"),
                                        fontSize: 2.5,
                                        fontWeight: pw.FontWeight.bold,
                                        decoration: pw.TextDecoration.none,
                                      ),)
                                  )
                              ),
                              pw.Container(
                                  width: PdfPageFormat.roll80.width/7,
                                  padding: pw.EdgeInsets.all(4),
                                  child: pw.Center(
                                      child: pw.Text("Amount" , style: pw.TextStyle(
                                        color: PdfColor.fromHex("#000000"),
                                        fontSize: 2.5,
                                        fontWeight: pw.FontWeight.bold,
                                        decoration: pw.TextDecoration.none,
                                      ),)
                                  )
                              ),/*pw.Container(
                                  width: PdfPageFormat.roll80.width/7,
                                  padding: pw.EdgeInsets.all(4),
                                  child:pw.Center(
                                      child: pw.Text("PAD" , style: pw.TextStyle(
                                        color: PdfColor.fromHex("#000000"),
                                        fontSize: 2.5,
                                        fontWeight: pw.FontWeight.bold,
                                        decoration: pw.TextDecoration.none,
                                      ),)
                                  )
                              ),*//**/
                            ]
                        ),
                        pw.SizedBox(height: 2 * 0.2),
                        pw.Container(
                            width: PdfPageFormat.roll80.width,
                            height: 1 * 0.1,
                            color: PdfColor.fromHex("#808080")
                        ),
                        pw.SizedBox(height: 2 * 0.2),
                      ]
                  ),
                  for(var i = 0 ; i < cartModel.products.length; i++)
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              /*pw.Container(
                                  width: PdfPageFormat.roll80.width/20,
                                  padding: pw.EdgeInsets.all(2),
                                  child: pw.Center(
                                      child: pw.Text("${i+1}" , style: pw.TextStyle(
                                        color: PdfColor.fromHex("#000000"),
                                        fontSize: 3,
                                        fontWeight: pw.FontWeight.normal,
                                        decoration: pw.TextDecoration.none,
                                      ),)
                                  )
                              ),*/
                              pw.Container(
                                  width: PdfPageFormat.roll80.width/2,
                                  padding: pw.EdgeInsets.all(2),
                                  child: pw.Text("${cartModel.products[i].name}" , style: pw.TextStyle(
                                    color: PdfColor.fromHex("#000000"),
                                    fontSize: 2.5,
                                    fontWeight: pw.FontWeight.normal,
                                    decoration: pw.TextDecoration.none,
                                  ),),
                              ),
                              pw.Container(
                                  width: PdfPageFormat.roll80.width/12,
                                  padding: pw.EdgeInsets.all(2),
                                  child: pw.Center(
                                      child: pw.Text("${cartModel.products[i].mUnit}" , style: pw.TextStyle(
                                        color: PdfColor.fromHex("#000000"),
                                        fontSize: 2.5,
                                        fontWeight: pw.FontWeight.normal,
                                        decoration: pw.TextDecoration.none,
                                      ),)
                                  )
                              ),
                              pw.Container(
                                  width: PdfPageFormat.roll80.width/10,
                                  padding: pw.EdgeInsets.all(2),
                                  child: pw.Center(
                                      child: pw.Text("${cartModel.products[i].selectedQuantity}" , style: pw.TextStyle(
                                        color: PdfColor.fromHex("#000000"),
                                        fontSize: 2.5,
                                        fontWeight: pw.FontWeight.normal,
                                        decoration: pw.TextDecoration.none,
                                      ),)
                                  )
                              ),
                              pw.Container(
                                  width: PdfPageFormat.roll80.width/7,
                                  padding: pw.EdgeInsets.all(2),
                                  child: pw.Center(
                                    child: pw.Text("${oCcy.format((cartModel.products[i].discountedPrice! * cartModel.products[i].selectedQuantity)).replaceAll(".00", "")}" , style: pw.TextStyle(
                                      color: PdfColor.fromHex("#000000"),
                                      fontSize: 2.5,
                                      fontWeight: pw.FontWeight.normal,
                                      decoration: pw.TextDecoration.none,
                                    ),)
                                  )
                              ),/*pw.Container(
                                  width: PdfPageFormat.roll80.width/7,
                                  padding: pw.EdgeInsets.all(2),
                                  child:pw.Center(
                                    child: pw.Text("${cartModel.products[i].salesRate.round()} " , style: pw.TextStyle(
                                      color: PdfColor.fromHex("#000000"),
                                      fontSize: 2.5,
                                      fontWeight: pw.FontWeight.normal,
                                      decoration: pw.TextDecoration.none,
                                    ),)
                                  )
                              ),*//**/
                            ]
                        ),
                        pw.SizedBox(height: 0.1),
                        pw.Container(
                            width: PdfPageFormat.roll80.width,
                            height:0.1,
                            color: PdfColor.fromHex("#808080")
                        ),
                        pw.SizedBox(height: 0.1),
                      ]
                    ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children:[
                      pw.Text("Total Items: $totalItems" , style: pw.TextStyle(
                        color: PdfColor.fromHex("#000000"),
                        fontSize: 3,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.none,
                      ),),
                      pw.SizedBox(width: 8),
                      pw.Text("Sub Total: ${oCcy.format(cartModel.totalBill.round()).replaceAll(".00", "")} " , style: pw.TextStyle(
                        color: PdfColor.fromHex("#000000"),
                        fontSize: 3,
                        fontWeight: pw.FontWeight.normal,
                        decoration: pw.TextDecoration.none,
                      ),)
                    ]
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children:[
                      pw.Text("Tax: 0 " , style: pw.TextStyle(
                        color: PdfColor.fromHex("#000000"),
                        fontSize: 3,
                        fontWeight: pw.FontWeight.normal,
                        decoration: pw.TextDecoration.none,
                      ),)
                    ]
                  ),pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children:[
                      pw.Text("Discount: ${oCcy.format(cartModel.discount.round()).replaceAll(".00", "")} " , style: pw.TextStyle(
                        color: PdfColor.fromHex("#000000"),
                        fontSize: 3,
                        fontWeight: pw.FontWeight.normal,
                        decoration: pw.TextDecoration.none,
                      ),)
                    ]
                  ),pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children:[
                      pw.Text("Total Bill: ${oCcy.format(cartModel.discountedBill.round()).replaceAll(".00", "")} " , style: pw.TextStyle(
                        color: PdfColor.fromHex("#000000"),
                        fontSize: 3,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.none,
                      ),)
                    ]
                  ),pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children:[
                      pw.Text("Amount Paid: ${oCcy.format(cartModel.amountPaid).replaceAll(".00", "")}" , style: pw.TextStyle(
                        color: PdfColor.fromHex("#000000"),
                        fontSize: 3,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.none,
                      ),)
                    ]
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children:[
                      pw.Text("Thank you" , style: pw.TextStyle(
                        color: PdfColor.fromHex("#000000"),
                        fontSize: 3,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.none,
                      ),)
                    ]
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children:[
                        pw.BarcodeWidget(
                            data: "${cartModel.cartId},${DateFormat("yyyy-MM-dd").format(DateTime.fromMillisecondsSinceEpoch(cartModel.createdAt))},${cartModel.discountedBill}, customer: ${cartModel.customer!.name}",
                            barcode: pw.Barcode.qrCode(),
                            width: 25,
                            height: 15
                        )
                      ]
                  ),
                  pw.SizedBox(height: 2),
                ],
              )
          );
        },
      ),
    );

    return pdf.save();
  }

}