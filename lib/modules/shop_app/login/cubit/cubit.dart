import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/models/login_model.dart';
import 'package:udemy_flutter/modules/shop_app/login/cubit/states.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/network/end_points.dart';
import 'package:udemy_flutter/shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  ShopLoginModel loginModel;
  static ShopLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    @required String email,
    @required String password,
  }) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {'email': email, 'password': password},
    ).then((value) {
      print(value.toString());
      loginModel=ShopLoginModel.fromJson(value.data);
      print(loginModel.data.token.toString());
      print(loginModel.data.email.toString());
      print(loginModel.data.name.toString());
      showToast(
        text: loginModel.message,
        state: ToastStates.SUCCESS,
      );
      emit(ShopLoginSuccessState(loginModel));
    }).catchError((error) {
      print(error.toString());
      showToast(
        text: loginModel.message,
        state: ToastStates.ERROR,
      );
      emit(ShopLoginErrorState(error.toString()));
    });
  }
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(ShopChangePasswordVisibilityState());
  }

}
