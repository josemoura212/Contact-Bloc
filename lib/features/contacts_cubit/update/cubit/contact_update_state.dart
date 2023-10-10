part of 'contact_update_cubit.dart';

@freezed
class ContactUpdateStateCubit with _$ContactUpdateStateCubit {
  const factory ContactUpdateStateCubit.initial() = _Initial;
  const factory ContactUpdateStateCubit.loading() = _Loading;
  const factory ContactUpdateStateCubit.success() = _Success;
  const factory ContactUpdateStateCubit.error({required String message}) =
      _Error;
}
