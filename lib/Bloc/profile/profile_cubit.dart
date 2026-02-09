import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileModel {
  final String name;
  final String email;
  final String phone;
  final String? imagePath;

  ProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    this.imagePath,
  });

  ProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? imagePath,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class ProfileCubit extends Cubit<ProfileModel> {
  ProfileCubit()
      : super(ProfileModel(
          name: "Your Name",
          email: "youremail@gmail.com",
          phone: "9876543210",
        )) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();

    emit(ProfileModel(
      name: prefs.getString('profile_name') ?? "Your Name",
      email: prefs.getString('profile_email') ?? "youremail@gmail.com",
      phone: prefs.getString('profile_phone') ?? "9876543210",
      imagePath: prefs.getString('profile_image'),
    ));
  }

  Future<void> updateProfile(ProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('profile_name', profile.name);
    await prefs.setString('profile_email', profile.email);
    await prefs.setString('profile_phone', profile.phone);

    if (profile.imagePath != null) {
      await prefs.setString('profile_image', profile.imagePath!);
    }

    emit(profile);
  }
}
