import 'package:distribution/Screen/SalesView/OrderTakeingscreen/OrderTakingScreen.dart';
import 'package:distribution/Screen/SalesView/SaleInvoise/SaleInvoiseScreen.dart';
import 'package:distribution/Screen/SalesView/SetUp/ItemsListScreen/ItemsListsScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../compoents/AppColors.dart';
import '../CustomerScreen/CustomersDefineScreen.dart';
import '../DashBoardScreen.dart';
import 'AnimationCard.dart';
import 'RecoveryScreen/Recovery.dart';
import 'Sales/SalesScreen.dart';
import 'SetUp/EmployeeDefine/EmployeeDefine.dart';
import 'SetUp/SalesAreaScreen/SalesAreaScreen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Sales",
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
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderTakingScreen()));
                          },
                          child: AnimationCard(
                            icon:Icons.add_card,
                            title: "Order Taking ",
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>RecoveryListScreen()));
                          },
                          child: AnimationCard(
                            icon: Icons.newspaper,
                            title: "Recovery",
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>SaleInvoiseScreen()));
                          },
                          child: AnimationCard(
                            icon: Icons.add_chart_rounded,
                            title: "Sales Invoice ",
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>SalessScreen()));
                          },
                          child: AnimationCard(
                            icon: Icons.sim_card_alert_rounded,
                            title: "Sales",
                          ),
                        ),
                        AnimationCard(
                          icon: Icons.wallet,
                          title: "Cash Deposit",
                        ),
                        AnimationCard(
                          icon: Icons.cloud_upload_rounded,
                          title: "Load Return",
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
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AnimationCard(
                        icon:Icons.add_card,
                        title: "Amount Receivable",
                      ),
                      AnimationCard(
                        icon: Icons.newspaper,
                        title: "Customer Ledger",
                      ),
                      AnimationCard(
                        icon: Icons.add_chart_rounded,
                        title: "Credit Aging",
                      ),
                      AnimationCard(
                        icon: Icons.sim_card_alert_rounded,
                        title: "Datewise Orders",
                      ),
                      AnimationCard(
                        icon: Icons.wallet,
                        title: "Productwise Order",
                      ),
                      AnimationCard(
                        icon: Icons.cloud_upload_rounded,
                        title: "Salesmanwise Order",
                      ),
                      AnimationCard(
                        icon: Icons.cloud_upload_rounded,
                        title: "Customerwise Orders",
                      ),
                      AnimationCard(
                        icon: Icons.cloud_upload_rounded,
                        title: "Daily Sales Report",
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
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>SalesAreaScreen()));
                        },
                        child: AnimationCard(
                          icon:Icons.location_on_rounded,
                          title: "Sales Areas ",
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>ItemListScreen()));
                        },
                        child: AnimationCard(
                          icon: Icons.newspaper,
                          title: "List of Items",
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>CustomersDefineScreen()));
                        },
                        child: AnimationCard(
                          icon: Icons.people,
                          title: "Define Customers ",
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployeesScreen()));
                        },
                        child: AnimationCard(
                          icon: Icons.person,
                          title: "Employee Information",
                        ),
                      ),
                      AnimationCard(
                        icon: Icons.car_crash,
                        title: "Vehicle Information",
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
