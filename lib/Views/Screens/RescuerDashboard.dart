import 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/APIManager/LogoutAPIManager.dart';
import 'package:desert_falcon_rescue/Controllers/HelpRequestController.dart';
import 'package:desert_falcon_rescue/Globals/Colors.dart';
import 'package:desert_falcon_rescue/Managers/UserDefaultManager.dart';
import 'package:desert_falcon_rescue/Managers/UserSessionManager.dart';
import 'package:desert_falcon_rescue/Models/HelpRequestFetchModel.dart';
import 'package:desert_falcon_rescue/Views/Screens/StartPage.dart';
import 'package:desert_falcon_rescue/Views/Utils/AppRoutes.dart';
import 'package:desert_falcon_rescue/Views/Widgets/AppBar.dart';
import 'package:desert_falcon_rescue/Views/Widgets/CircularProgressIndicatorWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';

class RescuerDashboard extends StatefulWidget {
  String? phoneNumber;
  RescuerDashboard(this.phoneNumber);
  @override
  _RescuerDashboardState createState() => _RescuerDashboardState();
}

class _RescuerDashboardState extends State<RescuerDashboard> {
  late double _screenHeight;
  late double _screenWidth;

  bool _isLoaderShown = false;
  late bool _isRescuer;
  HelpRequestController? _helpRequestController;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    _isRescuer = widget.phoneNumber == null;
    return Scaffold(
      appBar: AppBar(
        leading: !_isRescuer
            ? IconButton(
                icon: Icon(Icons.navigate_before,
                    color: AppColors.darkGrayColor, size: 40),
                onPressed: () {
                  AppRoutes.pop(context);
                },
              )
            : null,
        title: Text(
          !_isRescuer ? "your-help-request".tr() : "rescuer-dashboard".tr(),
          style: TextStyle(color: AppColors.darkGrayColor, fontSize: 60.sp),
        ),
        centerTitle: true,
        backgroundColor: AppColors.grayColor,
        actions: [
          if (_isRescuer)
            InkWell(
                onTap: () async {
                  setState(() {
                    _isLoaderShown = true;
                  });
                  String? deviceID = await PlatformDeviceId.getDeviceId;
                  APIManager().logout(deviceID ?? "");
                  UserSessionManager().user = null;
                  UserDefaultManager().deleteUser();
                  AppRoutes.makeFirst(context, StartPage());
                },
                child: Icon(Icons.logout,
                    size: 120.sp, color: AppColors.darkGrayColor)),
        ],
      ),
      body: SafeArea(
          child: ChangeNotifierProvider.value(
        value: HelpRequestController(),
        child: Consumer<HelpRequestController>(
            builder: (context, controller, child) {
          switch (controller.checkoutRequestStates) {
            case CheckoutRequestStates.Uninitalized:
            case CheckoutRequestStates.Error:
            case CheckoutRequestStates.InProcess:
            case CheckoutRequestStates.Completed:
              return _body(context);
          }
        }),
      )),
    );
  }

  Widget _body(BuildContext context) {
    if (_helpRequestController == null) {
      _helpRequestController = Provider.of<HelpRequestController>(context);
      _helpRequestController!.fetchHelpRequest(widget.phoneNumber);
    }
    CheckoutRequestStates _currentCheckoutStates =
        Provider.of<HelpRequestController>(context).checkoutRequestStates;

    return Stack(
      children: [
        StreamBuilder(
          stream: _helpRequestController!.streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return errorMessage("some-error-occured".tr());
            } else if (!snapshot.hasData ||
                snapshot.data == HelpRequestStates.Fetching) {
              return CircularProgressIndicatorWidget();
            } else if (snapshot.hasData &&
                snapshot.data == HelpRequestStates.NoData) {
              return errorMessage("no-requests-found".tr());
            } else if (snapshot.hasData &&
                snapshot.data == HelpRequestStates.Fetched) {
              return ListView.builder(
                itemCount: _helpRequestController!.helpRequestsList.length,
                itemBuilder: (BuildContext context, int index) {
                  HelpRequestFetchModel model =
                      _helpRequestController!.helpRequestsList[index];
                  return _infoCard(model);
                },
              );
            }
            return Container();
          },
        ),
        if (_currentCheckoutStates == CheckoutRequestStates.InProcess)
          CircularProgressIndicatorWidget(color: Colors.red),
        if (_isLoaderShown) CircularProgressIndicatorWidget(color: Colors.red),
      ],
    );
  }

  Widget _infoCard(HelpRequestFetchModel model) {
    return Container(
      margin:
          EdgeInsets.only(top: 36.sp, bottom: 12.sp, left: 58.sp, right: 58.sp),
      decoration: BoxDecoration(
          border: Border.all(
              color: AppColors.textGrayColor,
              style: BorderStyle.solid,
              width: 1.5),
          borderRadius: BorderRadius.circular(6)),
      height: _screenHeight * 0.25,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.location.toString(),
                  style: TextStyle(
                      fontSize: 45.sp,
                      color: AppColors.textGrayColor,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.greenColorLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _helpRequestController!.helpRequestsList
                              .remove(model);
                        });
                      },
                      child: Icon(Icons.close,
                          color: AppColors.whiteColor, size: 100.sp),
                    ),
                    Padding(padding: const EdgeInsets.all(2)),
                    InkWell(
                      onTap: () {
                        _helpRequestController!
                            .checkoutRequest(model.id!, _isRescuer);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.greenColorDark,
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.check,
                            color: AppColors.whiteColor, size: 100.sp),
                      ),
                    )
                  ]),
                )
              ],
            ),
            Container(
              height: _screenHeight * 0.15,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                InkWell(
                  onTap: () {
                    MapsLauncher.launchCoordinates(
                        double.parse(model.locLat ?? "0"),
                        double.parse(model.locLang ?? "0"));
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "assets/images/check-location.png",
                        fit: BoxFit.fill,
                        height: _screenHeight * 0.15,
                        width: _screenHeight * 0.20,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "check-location".tr(),
                            style: TextStyle(
                                fontSize: 50.sp, color: AppColors.whiteColor),
                          )),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8)),
                Image.asset(
                  "assets/images/car-image.png",
                  fit: BoxFit.fill,
                  height: _screenHeight * 0.15,
                  width: _screenHeight * 0.15,
                ),
                Padding(padding: const EdgeInsets.all(8)),
                Image.asset(
                  "assets/images/car-image01.png",
                  fit: BoxFit.fill,
                  height: _screenHeight * 0.15,
                  width: _screenHeight * 0.15,
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget errorMessage(String message) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "$message",
            style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textBlackColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
