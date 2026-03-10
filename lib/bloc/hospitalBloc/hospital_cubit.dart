import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/core/constant.dart';
import 'package:paw_pal_admin/routes/routes.dart';
import 'package:paw_pal_admin/services/firebase_services.dart';

import '../../core/AppColors.dart';
import '../../core/CommonMethods.dart';
import '../../model/hospital_model.dart';
import '../../services/firestore_service.dart';
import '../../services/image_upload_service.dart';

part 'hospital_state.dart';

class HospitalCubit extends Cubit<HospitalState> {
  final FirebaseServices services;
  final fireStore = FireStoreService().fireStore;
  final ImageUploadService imageService = ImageUploadService();
  String? hospitalImg;
  HospitalCubit(this.services) : super(HospitalInitial());
  HospitalModel? hospitalModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final ValueNotifier<File?> hospitalImageNotifier = ValueNotifier(null);

  TextEditingController openingController = TextEditingController();
  TextEditingController closingController = TextEditingController();

  List<HospitalModel> lstHospital = [];

  Future<void> getHospitals() async {
    emit(lstHospital.isEmpty ? HospitalLoading() : HospitalRefresh());
    try {
      lstHospital = await services.getHospitals();
      emit(HospitalSuccess());
    } catch (e) {
      emit(HospitalError(e.toString()));
    }
  }

  List<String> specializations = [
    "General Consultation",
    "Soft Tissue Surgery",
    "ICU",
    "Pathology & Laboratory Testing",
    "Dental Treatment",
    "Emergency & Critical Care",
    "Neurology",
    "Cardiology",
    "Physiotherapy & Rehabilitation",
    "Ophthalmology",
    "Vaccination & Immunization",
    "Orthopedic Surgery",
  ];

  List<AvailabilityModel> availabilityList = [
    AvailabilityModel(day: "Sunday"),
    AvailabilityModel(day: "Monday"),
    AvailabilityModel(day: "Tuesday"),
    AvailabilityModel(day: "Wednesday"),
    AvailabilityModel(day: "Thursday"),
    AvailabilityModel(day: "Friday"),
    AvailabilityModel(day: "Saturday"),
  ];

  List<String> selectedSpecializations = [];

  void addSpecializations(String value) {
    if (selectedSpecializations.contains(value)) {
      selectedSpecializations.remove(value);
    } else {
      selectedSpecializations.add(value);
    }
    emit(HospitalUpdate());
  }

  void toggleDayAvailability(int index, bool value) {
    availabilityList[index].isOpen = value;

    emit(HospitalUpdate());
  }

  void setOrUpdateAvailability(int index) {
    availabilityList[index].startTime = openingController.text;
    availabilityList[index].endTime = closingController.text;
    emit(HospitalUpdate());
    openingController.clear();
    closingController.clear();
  }


  Future<void> pickTime({
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    TimeOfDay initTime = controller.text.isNotEmpty
        ? Constant.stringToTimeOfDay(controller.text.trim())
        : TimeOfDay.now();
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: initTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              dialHandColor: AppColors.primaryColor,
              hourMinuteColor: AppColors.primaryColor.withValues(alpha: 0.1),
              hourMinuteTextColor: AppColors.primaryColor,
              dayPeriodColor: AppColors.primaryColor.withValues(alpha: 0.1),
              dayPeriodTextColor: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null && context.mounted) {
      controller.text = time.format(context);
      emit(HospitalUpdate());
    }
  }

  void createHospital(BuildContext context) async {
    emit(HospitalCreateLoading());
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return;
      final mainImage = await imageService.uploadImage(
        image: hospitalImageNotifier.value,
        uid: user.uid,
      );
      String id = fireStore.collection("hospitals").doc().id;
      HospitalModel model = HospitalModel(
        id: id,
        hospitalName: nameController.text.trim(),
        aboutHospital: descriptionController.text.trim(),
        imageUrl: mainImage ?? "",
        contactNumber: phoneController.text.trim(),
        address: addressController.text.trim(),
        specializations: selectedSpecializations,
        availability: availabilityList,
      );
      await services.createHospital(model);
      if(context.mounted){
        context.pop();
      }
      CommonMethods().showSuccessToast("Hospital Created SuccessFully");
      emit(HospitalCreateSuccess());
    } catch (e) {
      CommonMethods().showSuccessToast(e.toString());
      emit(HospitalCreateError(e.toString()));
    }
  }

  bool isOpenNow(HospitalModel model) {
    DateTime now = DateTime.now();
    List<String> days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ];
    String today = days[now.weekday % 7];
    int index = model.availability.indexWhere((e) => e.day == today);
    if (index == -1) return false;
    final todayData = model.availability[index];
    if (todayData.isOpen != true) return false;
    TimeOfDay start = _convertToTime(todayData.startTime ?? "");
    TimeOfDay end = _convertToTime(todayData.endTime ?? "");

    TimeOfDay current = TimeOfDay.fromDateTime(now);

    int startMinutes = start.hour * 60 + start.minute;
    int endMinutes = end.hour * 60 + end.minute;
    int currentMinutes = current.hour * 60 + current.minute;

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

  TimeOfDay _convertToTime(String time) {
    final format = time.replaceAll(" ", "");
    final period = format.substring(format.length - 2);
    final parts = format.substring(0, format.length - 2).split(":");

    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    if (period == "PM" && hour != 12) hour += 12;
    if (period == "AM" && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> updateAvailabilityOfHospital(
    int index,
    bool value,
    String id,
  ) async {
    try {
      lstHospital[index].isAvailable = value;
      emit(HospitalUpdate());
      await services.updateAvailabilityOfHospital(
        id: id,
        object: {"isAvailable": value},
      );
    } catch (e) {
      lstHospital[index].isAvailable = !value;
      CommonMethods().showErrorToast(e.toString());
      emit(HospitalUpdate());
    }
  }

  void navigateForEdit(BuildContext context, HospitalModel model) {
    hospitalModel = model;
    context.pushNamed(Routes.createHospitalScreen);
    emit(HospitalUpdate());
  }

  void setHospitalData(HospitalModel model) {
    nameController.text = model.hospitalName;
    descriptionController.text = model.aboutHospital;
    phoneController.text = model.contactNumber;
    addressController.text = model.address;

    selectedSpecializations = List.from(model.specializations);

     hospitalImg = model.imageUrl;

    availabilityList = model.availability;

    emit(HospitalUpdate());
  }

  void updateHospital(BuildContext context,String id)async{
    emit(HospitalCreateLoading());
    try{
      final user = CommonMethods.getCurrentUser();
      if (user == null) return;
      hospitalImg = hospitalModel?.imageUrl ?? "";
       if(hospitalImageNotifier.value !=null){
         hospitalImg = await imageService.uploadImage(
        image: hospitalImageNotifier.value,
        uid: user.uid,
      );
       }
      HospitalModel model = HospitalModel(
        id: id,
        hospitalName: nameController.text.trim(),
        aboutHospital: descriptionController.text.trim(),
        imageUrl: hospitalImg ?? "",
        contactNumber: phoneController.text.trim(),
        address: addressController.text.trim(),
        specializations: selectedSpecializations,
        availability: availabilityList,
      );
      await services.updateHospital(model);
      await getHospitals();
      if(context.mounted){
        context.pop();
      }
      CommonMethods().showSuccessToast("Hospital Updated SuccessFully");
      emit(HospitalCreateSuccess());
    }catch(e){
      CommonMethods().showErrorToast(e.toString());
      debugPrint("Errror :${e.toString()}");
      emit(HospitalCreateError(e.toString()));
    }
  }

  void resetHospitalForm() {
    hospitalModel = null;

    nameController.clear();
    descriptionController.clear();
    phoneController.clear();
    addressController.clear();

    openingController.clear();
    closingController.clear();

    hospitalImageNotifier.value = null;

    selectedSpecializations.clear();

    availabilityList = [
      AvailabilityModel(day: "Sunday"),
      AvailabilityModel(day: "Monday"),
      AvailabilityModel(day: "Tuesday"),
      AvailabilityModel(day: "Wednesday"),
      AvailabilityModel(day: "Thursday"),
      AvailabilityModel(day: "Friday"),
      AvailabilityModel(day: "Saturday"),
    ];

   // emit(HospitalInitial());
  }
}
