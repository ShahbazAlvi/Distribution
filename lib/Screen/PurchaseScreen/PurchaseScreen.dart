import 'package:flutter/material.dart';

import '../../compoents/AppColors.dart';
import '../SalesView/AnimationCard.dart';
import 'GRNScreen/GRN_Screen.dart';
import 'Payment_Supplier_Screen/PaymentSupplierScreen.dart';
import 'SupplierLedgerScreen/SupplierLedgerScreen.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Purchase",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            )),
        ),
        centerTitle: true,
        elevation: 6,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Functionalities",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.text,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>GRNScreen()));
                        },
                        child: AnimationCard(
                          icon:Icons.add_card,
                          title: "GRN",
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentToSupplierScreen()));
                        },
                        child: AnimationCard(
                          icon: Icons.attach_money_rounded,
                          title: "Payment to Supplier",
                        ),
                      ),






                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text("Reports",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.text,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AnimationCard(
                        icon:Icons.money_outlined,
                        title: "Amount Payable",
                      ),
                      AnimationCard(
                        icon: Icons.date_range_outlined,
                        title: "DateWise Purchase",
                      ),
                      AnimationCard(
                        icon: Icons.indeterminate_check_box_rounded,
                        title: "ItemsWise Purchase",
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>SupplierLedgerScreen()));
                        },
                        child: AnimationCard(
                          icon: Icons.indeterminate_check_box_rounded,
                          title: "Supplier ledger",
                        ),
                      ),

                      AnimationCard(
                        icon: Icons.person,
                        title: "SupplierWise Purchase",
                      ),
                      AnimationCard(
                        icon: Icons.equalizer,
                        title: "Stock Position",
                      ),






                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text("Setup",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.text,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AnimationCard(
                        icon: Icons.car_crash,
                        title: "Define Supplier",
                      ),






                    ],
                  ),
                ),
              )
            ],
          ),
        ),

      ),

    );
  }
}
