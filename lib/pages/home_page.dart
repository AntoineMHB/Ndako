import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ndako/providers/theme_provider.dart';
import 'package:ndako/themes/color_schemes.dart';
import 'package:ndako/utils/responsive_util.dart';
import 'package:ndako/utils/smart_device_box.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isSearching = false;

  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  // list of smart devices
  List mySmartDevices = [
    // [ smartDeviceName, iconPath, powerStatus, statusText ]
    ["Smart Light", "lib/images/light-bulb.png", true],
    ["Motion Detection", "lib/images/motionIcon.png", false],
    ["Location Tracking", "lib/images/gpsIcon.png", false],
    ["Smart Fan", "lib/images/air-conditioner.png", false],
  ];

  // power button switched
  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      _searchQuery = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil().init(context);
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;
    final themeProvider = Provider.of<ThemeProvider>(context);

    final primaryColor =
        isLightMode ? ColorSchemes.primaryLight : ColorSchemes.primaryDark;
    final secondaryColor =
        isLightMode ? ColorSchemes.secondaryLight : ColorSchemes.secondaryDark;
    final textColor =
        isLightMode ? ColorSchemes.textLight : ColorSchemes.textDark;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // custom app bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // menu icon
                  Image.asset(
                    'lib/images/menu.png',
                    height: 45,
                    color: Colors.grey[800],
                  ),

                  // account icon
                  Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.grey[800],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // welcome home Antoine
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Home,",
                    style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                  ),
                  Text(
                    "ANTO",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 72,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Divider(
                color: Colors.grey[200],
                thickness: 1,
              ),
            ),

            const SizedBox(height: 25),

            // Smart devices + grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "Smart Devices",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                selectionColor: Colors.grey[800],
              ),
            ),

            Expanded(
                child: GridView.builder(
                    itemCount: mySmartDevices.length,
                    //physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(25),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 1 / 1.3),
                    itemBuilder: (context, index) {
                      return SmartDeviceBox(
                        smartDeviceName: mySmartDevices[index][0],
                        iconPath: mySmartDevices[index][1],
                        powerOn: mySmartDevices[index][2],
                        onChanged: (value) => powerSwitchChanged(value, index),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
