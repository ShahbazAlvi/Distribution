import 'package:flutter/material.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    AnimatedDashboardCard(icon: Icons.person, title:'Total Sales', count:'50'/*provider.totalCustomers.toString()*/, bcolor:Colors.green),
                    AnimatedDashboardCard(icon: Icons.shop, title:'Total Purchases', count:'85'/*provider.totalProducts.toString()*/, bcolor:Colors.red),
                    AnimatedDashboardCard(icon: Icons.people_alt, title:'Total Recovenes', count:"34"/*provider.totalStaffs.toString()*/, bcolor:Colors.blue),
                    AnimatedDashboardCard(icon: Icons.account_balance_wallet, title:'Total Expenses', count:'40'/*provider.totalTransactions.toString()*/, bcolor:Colors.orange),

        
                  ],
                ),
              ),
        
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedDashboardCard extends StatefulWidget {
  final IconData icon;
  final  String title;
  final String count;
  final Color bcolor;
  const AnimatedDashboardCard({super.key, required this.icon, required this.title, required this.count, required this.bcolor});

  @override
  State<AnimatedDashboardCard> createState() => _AnimatedDashboardCardState();
}

class _AnimatedDashboardCardState extends State<AnimatedDashboardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: widget.bcolor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: widget.bcolor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(widget.icon,size: 32,color: Colors.white,),
          const SizedBox(height: 10),
          Text(widget.title,style: TextStyle(color: Colors.white),),
          const SizedBox(height: 10),
          Text(widget.count,style: TextStyle(color: Colors.white),),

        ],
      ),
    );
  }
}
