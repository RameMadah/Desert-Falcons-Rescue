import 'dart:io';
import 'package:desert_falcon_rescue/Controllers/ApplicationController.dart';
import 'package:desert_falcon_rescue/Globals/Colors.dart';
import 'package:desert_falcon_rescue/Models/AreaModel.dart';
import 'package:desert_falcon_rescue/Models/HelpRequestModel.dart';
import 'package:desert_falcon_rescue/Views/Screens/MapScreen.dart';
import 'package:desert_falcon_rescue/Views/Screens/RescuerDashboard.dart';
import 'package:desert_falcon_rescue/Views/Utils/AppRoutes.dart';
import 'package:desert_falcon_rescue/Views/Utils/HelperFunctions.dart';
import 'package:desert_falcon_rescue/Views/Widgets/AppBar.dart';
import 'package:desert_falcon_rescue/Views/Widgets/Button.dart';
import 'package:desert_falcon_rescue/Views/Widgets/CircularProgressIndicatorWidget.dart';
import 'package:desert_falcon_rescue/Views/Widgets/TextInputWidget.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

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
  bool _isLocationSelected = false;
  bool _isLocationFetched = false;
  List<File> _imagesList = [];
  final GlobalKey<FormState> _formKey = GlobalKey();
  late String _areaName;
  late String _name;
  late String _phone;
  late String _vehicleMaker;
  late String _description;
  late HelpRequestModel _helpRequestModel;
  AreaModel? _selectedArea;
  @override
  void initState() {
    _isLocationSelected = false;
    ApplicationController().fetchAreas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: CustomAppBar(context, "send-req".tr()),
        body: ChangeNotifierProvider.value(
          value: ApplicationController(),
          child: Consumer<ApplicationController>(
              builder: (context, controller, child) {
            switch (controller.helpApplicationStatus) {
              case HelpApplicationStatus.Uninitialized:
              case HelpApplicationStatus.InProgress:
              case HelpApplicationStatus.Error:
                return _form(context);
              case HelpApplicationStatus.Success:
                Future(() {
                  controller.helpApplicationStatus =
                      HelpApplicationStatus.Uninitialized;
                  AppRoutes.push(context, RescuerDashboard(_phone));
                });
                return _form(context);
            }
          }),
        ));
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _map(),
            _areaTextField(),
            _nameTextField(),
            _phoneTextField(),
            _areasDropDown(),
            _imageUploadOptions(),
            _documentImages(),
            _submitButton(context),
            Container(
                height: 1,
                color: AppColors.darkGrayColor,
                margin: const EdgeInsets.only(top: 8)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Dont-panic-text".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 45.sp, color: AppColors.textBlackColor)),
            ),
          ],
        ),
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
              _isLocationFetched = true;
              _cameraPosition = cameraPosition;
              _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: _cameraPosition, zoom: 20),
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

  Widget _areaTextField() {
    return TextInputWidget(
        prefix: Icon(
          Icons.pin_drop,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'area-name'.tr(),
        keyBoardType: TextInputType.text,
        obscureText: false,
        controller: null,
        onSaved: (value) {
          _areaName = value;
        },
        validationText: "please-enter-area".tr(),
        textInputAction: null);
  }

  Widget _nameTextField() {
    return TextInputWidget(
        prefix: Icon(
          Icons.person,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'name'.tr(),
        keyBoardType: TextInputType.text,
        obscureText: false,
        controller: null,
        onSaved: (value) {
          _name = value;
        },
        validationText: "please-enter-name".tr(),
        textInputAction: null);
  }

  Widget _phoneTextField() {
    return TextInputWidget(
        prefix: Icon(
          Icons.phone,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'phone'.tr(),
        keyBoardType: TextInputType.number,
        obscureText: false,
        controller: null,
        onSaved: (value) {
          _phone = value;
        },
        validationText: "please-enter-phone".tr(),
        textInputAction: null);
  }

  Widget _areasDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'select-area'.tr(),
            style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w500),
          ),
          ValueListenableBuilder(
              valueListenable: ApplicationController().areasFetched,
              builder: (context, value, child) {
                if (value == false) {
                  return Center(child: CircularProgressIndicatorWidget());
                }
                _selectedArea ??= ApplicationController().areas[0];
                return DropdownButtonFormField<AreaModel>(
                  value: _selectedArea,
                  onChanged: (AreaModel? area) {
                    setState(() {
                      _selectedArea = area!;
                    });
                  },
                  items: ApplicationController()
                      .areas
                      .map<DropdownMenuItem<AreaModel>>((AreaModel model) {
                    return DropdownMenuItem(
                      value: model,
                      child: Text(model.areaNameEn ?? ""),
                    );
                  }).toList(),
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _imageUploadOptions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              _imgFromCamera();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/images/camera_capture_logo.png",
                    height: _screenHeight * 0.05, width: _screenHeight * 0.05),
                Padding(padding: const EdgeInsets.all(8)),
                Text('Record-from-Camera'.tr(),
                    style: TextStyle(
                        fontSize: 45.sp, color: AppColors.textBlackColor))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentImages() {
    return Container(
      height: _imagesList.length == 0 ? 0 : 360.sp,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imagesList.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                height: 300.sp,
                width: 300.sp,
                padding: const EdgeInsets.all(8),
                child: Image.file(
                  _imagesList[index],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _imagesList.removeAt(index);
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 75.sp,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Provider.of<ApplicationController>(context).helpApplicationStatus ==
            HelpApplicationStatus.InProgress
        ? Center(child: CircularProgressIndicator())
        : CustomButton('submit-req'.tr(), _submitButtonPressed);
  }

  void _submitButtonPressed() {
    Helper.closeKeyboard(context);
    if (_formKey.currentState == null) return;
    FormState currentState = _formKey.currentState!;
    if (!currentState.validate()) return;
    currentState.save();
    if (_imagesList.isEmpty) {
      Helper.showSnackbar("please-upload-images".tr());
      return;
    }
    if (_selectedArea == null) {
      Helper.showSnackbar("Please Select Area");
      return;
    }
    _helpRequestModel = HelpRequestModel(
        _areaName,
        _name,
        _phone,
        _cameraPosition.longitude.toString(),
        _cameraPosition.latitude.toString(),
        _selectedArea!.id!);
    ApplicationController()
        .helpRequestWithModelAndUploadImages(_helpRequestModel, _imagesList);
  }

  void _imgFromCamera() async {
    PickedFile? file = await ImagePicker().getImage(source: ImageSource.camera);
    if (file == null) return;
    setState(() {
      _imagesList.add(File(file.path));
    });
  }

  void _imgFromGallery() async {
    PickedFile? file =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      _imagesList.add(File(file.path));
    });
  }

  Future<bool?> _selectVideo(context) async {
    bool? _selectVideo;
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Image'.tr()),
                      onTap: () {
                        Navigator.of(context).pop();
                        _selectVideo = false;
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Video'.tr()),
                    onTap: () {
                      Navigator.of(context).pop();
                      _selectVideo = true;
                    },
                  ),
                ],
              ),
            ),
          );
        });
    return _selectVideo;
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
            CameraPosition(target: latLng, zoom: 20),
          ),
        );
      }
    }
  }
}
