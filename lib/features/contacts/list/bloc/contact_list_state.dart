part of "contact_list_bloc.dart";

@freezed
class ContactListState with _$ContactListState {
  const factory ContactListState.inital() = _ContactListStateInitial;
  const factory ContactListState.data({required List<ContactModel> contacts}) =
      _ContactListStateData;
  const factory ContactListState.error({required String error}) =
      _ContactListStateError;
}
