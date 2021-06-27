import 'dart:collection';
import 'dart:developer';
import 'package:desert_falcon_rescue/Globals/Colors.dart';
import 'package:desert_falcon_rescue/Views/Screens/MapScreen.dart';
import 'package:desert_falcon_rescue/Views/Utils/AppRoutes.dart';
import 'package:desert_falcon_rescue/Views/Widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';

class ApplicationScreen extends StatefulWidget {
  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  // Private Properties
  late double _screenHeight;
  late double _screenWidth;
  late GoogleMapController _mapController;
  Location _location = Location();
  LatLng _cameraPosition = LatLng(20.5937, 78.9629);
  late LatLng _currentLatLng;
  bool _isLocationSelected = false;
  bool _isLocationFetched = false;
  HashSet<Marker> _markers = HashSet();

  @override
  void initState() {
    _isLocationSelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(context, "send-req".tr()),
      body: _body(),
    );
  }

  Widget _body() {
    return _form();
  }

  Widget _form() {
    return Form(
      child: ListView(
        children: [
          _map(),
        ],
      ),
    );
  }

  Widget _map() {
    return InkWell(
      onTap: () {
        AppRoutes.push(
            context,
            MapScreen(_isLocationFetched ? _cameraPosition : null,
                (bool isSelected, LatLng cameraPosition) {
              _isLocationSelected = isSelected;
              _cameraPosition = cameraPosition;
              _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: _cameraPosition, zoom: 1000),
                ),
              );
            }));
      },
      child: Container(
        height: _screenHeight * 0.20,
        child: AbsorbPointer(
          child: Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition:
                      CameraPosition(target: _cameraPosition),
                  onMapCreated: _onMapCreated,
                  mapToolbarEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false),
              Icon(
                Icons.location_on,
                color: AppColors.textBlackColor,
              ),
              Container(
                color: Colors.black.withOpacity(0.5),
                height: _screenHeight * 0.20,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "select-your-location".tr(),
                    style:
                        TextStyle(fontSize: 50.sp, color: AppColors.whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    if (!_isLocationSelected) {
      LocationData location = await _location.getLocation();
      LatLng latLng = LatLng(location.latitude!, location.longitude!);
      _cameraPosition = latLng;
      _isLocationFetched = true;
      if (location.latitude != null && location.latitude != null) {
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 1000),
          ),
        );
      }
    }
  }
}
