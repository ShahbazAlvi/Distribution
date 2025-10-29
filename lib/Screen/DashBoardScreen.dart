import 'package:distribution/Screen/SalesView/SalesScreen.dart';
import 'package:distribution/Screen/dashBoardView/calender.dart';
import 'package:distribution/Screen/dashBoardView/chartdashboard.dart';
import 'package:distribution/Screen/dashBoardView/recoverienChart.dart';
import 'package:flutter/material.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  String? selectedOption;
  bool isButtonSelected = false;

  final List<String> dropdownItems = ['Today', 'Week', 'Month', 'Year'];

  List<double> salesData = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
  late final recovered = [10.0, 25.0, 40.0, 55.0, 70.0, 80.0, 85.0, 90.0, 95.0, 100.0];
  late final due = [20.0, 30.0, 35.0, 50.0, 60.0, 70.0, 78.0, 82.0, 90.0, 98.0];


  void _onDropdownChanged(String? value) {
    setState(() {
      selectedOption = value;
      isButtonSelected = false;
      _updateChartData(value);
    });
  }

  void _onButtonPressed() {
    setState(() {
      if (!isButtonSelected) {
        selectedOption = null;
        isButtonSelected = true;
        _updateChartData("All");
      } else {
        isButtonSelected = false;
      }
    });
  }

  void _updateChartData(String? filter) {
    switch (filter) {
      case 'Today':
        salesData = [10, 20, 30, 40, 30, 20, 10];
        break;
      case 'Week':
        salesData = [20, 30, 50, 60, 70, 80, 90];
        break;
      case 'Month':
        salesData = [30, 40, 60, 70, 90, 100];
        break;
      case 'Year':
        salesData = [40, 60, 80, 100];
        break;
      case 'All':
        salesData = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
        break;
      default:
        salesData = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Dashboard",
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
              colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FutureBuilder<String?>(
                future: _getUsername(), // async method defined above
                builder: (context, snapshot) {
                  final username = snapshot.data ?? "Admin";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF5B86E5),
                          size: 35,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Welcome $username',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Now add username text outside const
            

            ListTile(
              leading: const Icon(Icons.dashboard, color: Color(0xFF5B86E5)),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shop, color: Color(0xFF5B86E5)),
              title: const Text('Sales'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesScreen()));
                
              },
            ),
            ListTile(
              leading: const Icon(Icons.follow_the_signs, color: Color(0xFF5B86E5)),
              title: const Text('Follow Up'),
              onTap: () {
                
              },
            ),
            
              ListTile(
                leading: const Icon(Icons.assignment_ind, color: Color(0xFF5B86E5)),
                title: const Text('Assign To'),
                onTap: () {
                  
                },
              ),
            
              ListTile(
                leading: const Icon(Icons.phone, color: Color(0xFF5B86E5)),
                title: const Text('Call Track'),
                onTap: () {
                  
                },
              ),
            ListTile(
              leading: const Icon(Icons.done, color: Color(0xFF5B86E5)),
              title: const Text('Success Client'),
              onTap: () {
                
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Color(0xFF5B86E5)),
              title: const Text('Calendar'),
              onTap: () {
                
              },
            ),
            
              ListTile(
                leading: const Icon(Icons.history_outlined, color: Color(0xFF5B86E5)),
                title: const Text('Activity Track '),
                onTap: () {
                  
                },
              ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF5B86E5)),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout',),
                      ),
                    ],
                  ),
                );
                
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    /// Dropdown (Equal Width)
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedOption,
                        hint: const Text('Select Period'),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(12),

                          ),
                        ),
                        items: dropdownItems
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                            .toList(),
                        onChanged: _onDropdownChanged,
                      ),
                    ),
                    const SizedBox(width: 12),

                    /// Button (Equal Width)
                    Expanded(
                      child: SizedBox(
                        height: 58, // match dropdown height
                        child: ElevatedButton(
                          onPressed: _onButtonPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isButtonSelected
                                ? Color(0xFF5B86E5)
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "All",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),



              const SizedBox(height: 16),
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
              const SizedBox(height: 16),

              Text('Sales',style: TextStyle(fontWeight: FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SalesChart(
                  salesData: salesData,
                  selectedFilter: selectedOption ?? (isButtonSelected ? "All" : "Today"),
                ),
              ),


              Text('Calender Recoveries',style: TextStyle(fontWeight: FontWeight.bold),),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: CalendarWidget(),
              ),
              Text('Recoveries Done & Due',style: TextStyle(fontWeight: FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Recoverienchart(recoveredData: recovered, dueData: due),
              ),


        
            ],
          ),
        ),
      ),
    );
  }

  Future<String?>? _getUsername() async {}
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
