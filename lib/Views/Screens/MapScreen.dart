import 'dart:collection';
import 'dart:developer';

import 'package:desert_falcon_rescue/Globals/Colors.dart';
import 'package:desert_falcon_rescue/Views/Utils/AppRoutes.dart';
import 'package:desert_falcon_rescue/Views/Widgets/AppBar.dart';
import 'package:desert_falcon_rescue/Views/Widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  LatLng? _initialLatLng;
  Function(bool, LatLng) callBack;
  MapScreen(this._initialLatLng, this.callBack);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _latLng;
  late GoogleMapController _googleMapController;

  @override
  void initState() {
    if (widget._initialLatLng != null) {
      _latLng = widget._initialLatLng!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, 'select-your-location'.tr()),
      body: _body(),
      persistentFooterButtons: [_selectLocationButton()],
    );
  }

  Widget _body() {
    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onCameraMove: (CameraPosition cameraPosition) {
            _latLng = cameraPosition.target;
          },
          initialCameraPosition: CameraPosition(
            target: widget._initialLatLng == null
                ? LatLng(0, 0)
                : widget._initialLatLng!,
            zoom: 20,
          ),
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          onMapCreated: _onMapCreated,
        ),
        Icon(
          Icons.location_on,
          color: AppColors.textBlackColor,
        ),
      ],
    );
  }

  Widget _selectLocationButton() {
    return CustomButton("confirm-location".tr(), () {
      widget.callBack(true, _latLng);
      AppRoutes.pop(context);
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    if (widget._initialLatLng == null) {
      Location _location = Location();
      _googleMapController = controller;
      LocationData location = await _location.getLocation();
      LatLng latLng = LatLng(location.latitude!, location.longitude!);
      if (location.latitude != null && location.latitude != null) {
        _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 1000),
          ),
        );
      }
    }
  }
}
