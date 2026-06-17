import "package:esim_open_source/domain/data/response/account/account_model.dart";
import "package:stacked/stacked.dart";

class UserService with ListenableServiceMixin {
  UserService() {
    ///The [listenToReactiveValues()] is function that comes with every
    ///service. It takes in a list of the values and let the ViewModels
    ///react when there are any changes.
    listenToReactiveValues(<dynamic>[_accountList]);
  }
  // 1
  ///This [_counter] is a reactive value. It acts as stream
  ///to let each ViewModel listening to it to adjust it's
  ///value accordingly. We set the initial value to 0.
  final ReactiveValue<List<AccountModel>?> _accountList =
      ReactiveValue<List<AccountModel>?>(null);

  List<AccountModel>? get accountList => _accountList.value;

  set accountList(List<AccountModel>? value) {
    _accountList.value = value;
    notifyListeners();
  }
}
