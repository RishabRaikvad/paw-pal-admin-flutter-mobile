import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_pal_admin/model/user_model.dart';
import 'package:paw_pal_admin/services/firebase_services.dart';

part 'user_management_state.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  FirebaseServices services;
  List<UserModel> lstUserList = [];
  Map<String, int> userPetCount = {};

  UserManagementCubit(this.services) : super(UserManagementInitial());

  Future<void> getUsers() async {
    emit(UserManagementLoading());
    try {
      lstUserList = await services.getUsers();
      userPetCount = await services.getUserPetCounts();
      emit(UserManagementSuccess());
    } catch (e) {
      debugPrint('Errorkdfn : $e');
      emit(UserManagementError(e.toString()));
    }
  }

  int getPetCount(String userId) {
    return userPetCount[userId] ?? 0;
  }
  String getUserAddress(UserModel user){
    return "${user.address} ${user.city}, ${user.state}, ${user.pinCode}";
  }
}
