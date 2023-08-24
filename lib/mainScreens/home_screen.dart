import 'package:amo_cabs/infoHandler/app_info.dart';
import 'package:amo_cabs/mainScreens/history_page.dart';
import 'package:amo_cabs/mainScreens/main_screen.dart';
import 'package:amo_cabs/mainScreens/offer_page.dart';
import 'package:amo_cabs/mainScreens/support_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';
import '../models/user_model.dart';
import '../widgets/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  String userName = "First Name";
  String userLastName = "Last name";
  String userPhone = "Phone";
  List<Widget> toShowOnScreen = [
    MainScreen(),
    HistoryPage(),
    SupportPage(),
    OfferPage(),

  ];
  getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? userDetails = prefs.getStringList('userCurrentInfo');

    if (userDetails != null) {
      UserModel userModel = UserModel(
          id: userDetails[0],
          phoneNumber: userDetails[1],
          firstName: userDetails[2],
          lastName: userDetails[3],
          email: userDetails[4]);
      userModelCurrentInfo = userModel;

      userName = userModelCurrentInfo!.firstName!;
      userLastName = userModelCurrentInfo!.lastName!;
      userPhone = userModelCurrentInfo!.phoneNumber!;
    }
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        backgroundColor: Colors.blue.shade500,
        elevation: 4,
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
        ),
        child: MyDrawer(
          name: userName,
          lastName: userLastName,
          phone: userPhone,
        ),
      ),
      body: toShowOnScreen[
          Provider.of<AppInfo>(context, listen: true).currentIndex],
    );
  }
}
