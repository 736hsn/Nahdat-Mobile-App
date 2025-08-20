import 'package:image_picker/image_picker.dart';
import 'package:supervisor/src/features/voter/models/voter_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class FetchProfileLoading extends ProfileState {}

class FetchProfileSuccess extends ProfileState {
  final String message;
  final VoterModel profile;
  final XFile? selectedImage;

  FetchProfileSuccess({
    required this.message,
    required this.profile,
    this.selectedImage,
  });

  FetchProfileSuccess copyWith({
    String? message,
    VoterModel? profile,
    XFile? selectedImage,
  }) {
    return FetchProfileSuccess(
      message: message ?? this.message,
      profile: profile ?? this.profile,
      selectedImage: selectedImage ?? this.selectedImage,
    );
  }
}

class FetchProfileError extends ProfileState {
  final String error;

  FetchProfileError(this.error);
}

class EditProfileLoading extends ProfileState {}

class EditProfileSuccess extends ProfileState {
  final String message;
  final VoterModel profile;

  EditProfileSuccess(this.message, this.profile);
}

class EditProfileError extends ProfileState {
  final String error;

  EditProfileError(this.error);
}
