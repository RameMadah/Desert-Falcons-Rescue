import 'dart:io';

import 'package:desert_falcon_rescue/Controllers/RescuerRegisterationController.dart';
import 'package:desert_falcon_rescue/Globals/Colors.dart';
import 'package:desert_falcon_rescue/Models/RescuerRegisterationModel.dart';
import 'package:desert_falcon_rescue/Views/Utils/HelperFunctions.dart';
import 'package:desert_falcon_rescue/Views/Widgets/AppBar.dart';
import 'package:desert_falcon_rescue/Views/Widgets/Button.dart';
import 'package:desert_falcon_rescue/Views/Widgets/TextInputWidget.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RescuerRegisteration extends StatefulWidget {
  @override
  _RescuerRegisterationState createState() => _RescuerRegisterationState();
}

class _RescuerRegisterationState extends State<RescuerRegisteration> {
  late double _screenHeight;
  late double _screenWidth;
  PickedFile? _profileImageFile;
  late String _name;
  late String _email;
  late String _username;
  late String _password;
  late String _retypePassword;
  late String _carModel;
  late String _phone;
  late String _city;
  late String _experience;
  late String _description;
  List<File> _documentList = [];
  bool _isTermsAndConditionsSelected = false;
  late RescuerRegisterationModel _rescuerRegisterationModel;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(context, "rescuer-registration".tr()),
      body: SafeArea(
          child: ChangeNotifierProvider.value(
        value: RescuerRegisterationController(),
        child: Consumer<RescuerRegisterationController>(
            builder: (context, controller, child) {
          switch (controller.registerationStatus) {
            case RescuerRegisterationStatus.Uninitialized:
            case RescuerRegisterationStatus.InProgress:
            case RescuerRegisterationStatus.Success:
            case RescuerRegisterationStatus.Error:
              return _form(context);
          }
        }),
      )),
    );
  }

  Widget _form(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _nameTextField(),
              _emailTextField(),
              _userNameTextField(),
              _passwordTextField(),
              _retypePasswordTextField(),
              _carModelAndMake(),
              _phoneTextField(),
              _cityTextField(),
              _rateYourSelf(),
              _descriptionField(),
              _documentsLabelContainer(),
              _documentImages(),
              _termsAndConditions(),
              _submitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileImage() {
    File? image;
    if (_profileImageFile != null) {
      image = File(_profileImageFile!.path);
    }
    return InkWell(
        onTap: () {
          _showPicker(context);
        },
        child: _profileImageFile == null || image == null
            ? Image.asset('assets/images/image_upload_icon.png',
                height: _screenHeight * 0.20, width: _screenWidth * 0.20)
            : CircleAvatar(
                backgroundColor: AppColors.whiteColor,
                radius: _screenHeight * 0.10,
                backgroundImage: FileImage(image),
              ));
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

  Widget _emailTextField() {
    return TextInputWidget(
        prefix: Icon(
          Icons.email,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'email'.tr(),
        keyBoardType: TextInputType.emailAddress,
        obscureText: false,
        controller: null,
        onSaved: (value) {
          _email = value;
        },
        validationText: "please-enter-email".tr(),
        textInputAction: null);
  }

  Widget _userNameTextField() {
    return TextInputWidget(
        prefix: Icon(
          Icons.person,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'user-name'.tr(),
        keyBoardType: TextInputType.text,
        obscureText: false,
        controller: null,
        onSaved: (value) {
          _username = value;
        },
        validationText: "please-enter-username".tr(),
        textInputAction: null);
  }

  Widget _passwordTextField() {
    return TextInputWidget(
        prefix: Icon(
          Icons.lock,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'password'.tr(),
        keyBoardType: TextInputType.text,
        obscureText: true,
        maxLines: 1,
        controller: null,
        onSaved: (value) {
          _password = value;
        },
        validationText: "please-enter-password".tr(),
        textInputAction: null);
  }

  Widget _retypePasswordTextField() {
    return TextInputWidget(
        prefix: Icon(
          Icons.lock,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'retype-password'.tr(),
        keyBoardType: TextInputType.text,
        obscureText: true,
        maxLines: 1,
        controller: null,
        onSaved: (value) {
          _retypePassword = value;
        },
        validationText: "please-enter-password".tr(),
        textInputAction: null);
  }

  Widget _carModelAndMake() {
    return TextInputWidget(
        prefix: Icon(
          Icons.car_rental_sharp,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'car-model-make'.tr(),
        keyBoardType: TextInputType.text,
        obscureText: false,
        controller: null,
        onSaved: (value) {
          _carModel = value;
        },
        validationText: "please-enter-car".tr(),
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

  Widget _cityTextField() {
    return TextInputWidget(
        prefix: Icon(
          Icons.pin_drop,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'city'.tr(),
        keyBoardType: TextInputType.text,
        obscureText: false,
        controller: null,
        onSaved: (value) {
          _city = value;
        },
        validationText: "please-enter-city".tr(),
        textInputAction: null);
  }

  Widget _rateYourSelf() {
    return TextInputWidget(
        prefix: Icon(
          Icons.star_rate,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'rate-your-self'.tr(),
        keyBoardType: TextInputType.text,
        obscureText: false,
        controller: null,
        onSaved: (value) {
          _experience = value;
        },
        validationText: "please-rate-your-self".tr(),
        textInputAction: null);
  }

  Widget _descriptionField() {
    return TextInputWidget(
        prefix: Icon(
          Icons.description,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'description-explain-your-self'.tr(),
        keyBoardType: TextInputType.text,
        obscureText: false,
        controller: null,
        onSaved: (value) {
          _description = value;
        },
        validationText: "please-enter-your-self".tr(),
        textInputAction: null);
  }

  Widget _documentsLabelContainer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
      child: InkWell(
        onTap: () async {
          File? scannedDoc = await DocumentScannerFlutter.launch(context);
          if (scannedDoc != null) {
            setState(() {
              _documentList.add(File(scannedDoc.path));
            });
          }
        },
        child: DottedBorder(
          color: AppColors.textBlackColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _documentText("upload-your-requirements".tr()),
                    _documentText("emirates-id".tr()),
                    _documentText("drivers-license".tr()),
                    _documentText("vehicle-photos".tr()),
                  ],
                ),
                Image.asset(
                  "assets/images/document_upload_logo.png",
                  height: _screenHeight * 0.10,
                  width: _screenHeight * 0.10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _documentText(String text) {
    return Text(text,
        style: TextStyle(fontSize: 40.sp, color: AppColors.textBlackColor));
  }

  Widget _documentImages() {
    return Container(
      height: _documentList.length == 0 ? 0 : 360.sp,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _documentList.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                height: 300.sp,
                width: 300.sp,
                padding: const EdgeInsets.all(8),
                child: Image.file(
                  _documentList[index],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _documentList.removeAt(index);
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

  Widget _termsAndConditions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('terms-and-Conditions'.tr(), style: TextStyle(fontSize: 40.sp)),
          Checkbox(
              value: _isTermsAndConditionsSelected,
              onChanged: (value) {
                setState(() {
                  if (value != null) _isTermsAndConditionsSelected = value;
                });
              })
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Provider.of<RescuerRegisterationController>(context)
                .registerationStatus ==
            RescuerRegisterationStatus.InProgress
        ? CircularProgressIndicator()
        : CustomButton('submit-req'.tr(), _registerButtonPressed);
  }

  void _registerButtonPressed() {
    if (_formKey.currentState == null) return;
    FormState currentState = _formKey.currentState!;
    if (!currentState.validate()) return;
    currentState.save();
    if (_password != _retypePassword) {
      Helper.showSnackbar("password-not-match-to-confirm".tr());
      return;
    }
    if (_documentList.isEmpty) {
      Helper.showSnackbar("please-upload-required-docs".tr());
      return;
    }
    if (!_isTermsAndConditionsSelected) {
      Helper.showSnackbar("please-accept-terms-and-condition".tr());
      return;
    }
    _rescuerRegisterationModel = RescuerRegisterationModel(
      username: _username,
      email: _email,
      password: _password,
      resecername: _name,
      carModel: _carModel,
      city: _city,
      confirmed: true,
      blocked: false,
      mobile: _phone,
      role: "public",
    );
    RescuerRegisterationController().registerwithModelAndUploadAttachments(
        _rescuerRegisterationModel, _documentList);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo-Library'.tr()),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'.tr()),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _imgFromCamera() async {
    PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      _profileImageFile = image;
    });
  }

  void _imgFromGallery() async {
    PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _profileImageFile = image;
    });
  }
}
