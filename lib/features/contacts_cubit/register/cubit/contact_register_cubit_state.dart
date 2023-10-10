part of "contact_register_cubit.dart";

@freezed
class ContactRegisterCubitState with _$ContactRegisterCubitState {
  const factory ContactRegisterCubitState.inital() = _Inital;
  const factory ContactRegisterCubitState.loading() = _Loading;
  const factory ContactRegisterCubitState.success() = _Success;
  const factory ContactRegisterCubitState.error({required String message}) =
      _Error;
}
