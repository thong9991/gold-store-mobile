import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/common/cubits/app_profile/app_profile_cubit.dart';
import '../../../../core/common/entities/profile.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/language_manager.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../../home/data/models/profile.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/widgets.dart';

class ChangeProfilePage extends StatelessWidget {
  const ChangeProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: context.read<SettingsBloc>()..add(SettingsInit()),
        child: const ChangeProfileView());
  }
}

class ChangeProfileView extends StatefulWidget {
  const ChangeProfileView({super.key});

  @override
  State<ChangeProfileView> createState() => _ChangeProfileViewState();
}

class _ChangeProfileViewState extends State<ChangeProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          Constants.empty,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 20),
            child: BlocListener<SettingsBloc, SettingsState>(
              listenWhen: (previous, current) {
                return previous.updateProfileStatus !=
                    current.updateProfileStatus;
              },
              listener: (context, state) {
                if (state.updateProfileStatus == UpdateProfileStatus.success) {
                  showSnackBar(context, ToastificationType.success,
                      AppStrings.strSaveProfileSuccessful, true);
                  context.read<SettingsBloc>().add(SettingsInit());
                }
              },
              child: Builder(
                builder: (context) {
                  SettingsBloc settingsBloc = context.read<SettingsBloc>();
                  ProfileEntity profile = (context.read<AppProfileCubit>().state
                          as AppProfileLoaded)
                      .profile;
                  return Column(
                    children: [
                      Center(
                          child: ImageIcon(
                        AssetImage("assets/images/profile.png"),
                        color: Colors.black,
                        size: 200.sp,
                      )),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomTextField(
                        initialValue: settingsBloc
                                .state.updateProfile.firstName.isNotEmpty
                            ? settingsBloc.state.updateProfile.firstName
                            : profile.firstName,
                        hintText: AppStrings.strFirstName.tr(context),
                        prefixIcon: const Icon(CupertinoIcons.person_solid),
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          if (value != null) {
                            settingsBloc.add(ProfileChange(
                                updateProfile: ProfileModel.fromEntity(
                                        settingsBloc.state.updateProfile)
                                    .copyWith(firstName: value)));
                          }
                          return;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTextField(
                        hintText: AppStrings.strLastName.tr(context),
                        initialValue:
                            settingsBloc.state.updateProfile.lastName.isNotEmpty
                                ? settingsBloc.state.updateProfile.lastName
                                : profile.lastName,
                        prefixIcon: const Icon(CupertinoIcons.person_fill),
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          if (value != null) {
                            context.read<SettingsBloc>().add(ProfileChange(
                                updateProfile: ProfileModel.fromEntity(
                                        settingsBloc.state.updateProfile)
                                    .copyWith(lastName: value)));
                          }
                          return;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTextField(
                        hintText: AppStrings.strPhone.tr(context),
                        initialValue:
                            settingsBloc.state.updateProfile.phone.isNotEmpty
                                ? settingsBloc.state.updateProfile.phone
                                : profile.phone,
                        prefixIcon: const Icon(CupertinoIcons.phone_fill),
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          if (value != null) {
                            context.read<SettingsBloc>().add(ProfileChange(
                                updateProfile: ProfileModel.fromEntity(
                                        settingsBloc.state.updateProfile)
                                    .copyWith(phone: value)));
                          }
                          return;
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTextField(
                        hintText: AppStrings.strAddress.tr(context),
                        initialValue:
                            settingsBloc.state.updateProfile.address.isNotEmpty
                                ? settingsBloc.state.updateProfile.address
                                : profile.address,
                        prefixIcon: const Icon(CupertinoIcons.location_solid),
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          if (value != null) {
                            context.read<SettingsBloc>().add(ProfileChange(
                                updateProfile: ProfileModel.fromEntity(
                                        settingsBloc.state.updateProfile)
                                    .copyWith(address: value)));
                          }
                          return;
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            elevation: 3.0,
                            backgroundColor: AppPalette.lightBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60.r)),
                          ),
                          onPressed: () {
                            context.read<SettingsBloc>().add(ProfileSave());
                          },
                          child: Padding(
                            padding: REdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              AppStrings.strSaveProfile.tr(context),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ))
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
